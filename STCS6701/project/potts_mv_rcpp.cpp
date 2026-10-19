// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <vector>
#include <cmath>
#include <random>
#include <algorithm>
#include <cstdio>
#include <numeric>

using namespace Rcpp;

/* Random Number Generation */
struct FastRNG {
    std::mt19937 mt;
    std::uniform_real_distribution<double> dist_01;

    FastRNG(unsigned int seed) : mt(seed), dist_01(0.0, 1.0) {}

    inline double runif() { return dist_01(mt); }

    inline double rnorm(double mean, double sd) {
        std::normal_distribution<double> dist_n(mean, sd);
        return dist_n(mt);
    }

    // Sample discrete (0-based return)
    inline int sample_discrete(const std::vector<double>& probs) {
        double sum = 0.0;
        for (double p : probs) sum += p;
        double u = dist_01(mt) * sum;
        double cum = 0.0;
        for (size_t k = 0; k < probs.size(); ++k) {
            cum += probs[k];
            if (u < cum) return k;
        }
        return probs.size() - 1;
    }
};

/* Log Density of Multivariate Normal */
inline double dmvn_log_prec(const arma::rowvec& x, const arma::rowvec& mu, const arma::mat& Prec, double log_det_prec) {
    arma::rowvec diff = x - mu;
    double dist_sq = arma::as_scalar(diff * Prec * diff.t());
    double const_term = -0.5 * x.n_elem * std::log(2.0 * M_PI);
    return const_term + 0.5 * log_det_prec - 0.5 * dist_sq;
}

/* Sample from Multivariate Normal */
arma::vec rmvn(const arma::vec& mu, const arma::mat& Sigma, FastRNG& rng) {
    int k = mu.n_elem;
    arma::vec z(k);
    for(int i=0; i<k; ++i) z[i] = rng.rnorm(0, 1);

    // mu + L * z where Sigma = L L'
    arma::mat L;
    try {
        L = arma::chol(Sigma, "lower");
    } catch (...) {
        // Fallback for numerical instability
        L = arma::chol(Sigma + arma::eye(k,k)*1e-6, "lower");
    }
    return mu + L * z;
}

/* Sample from Inverse Wishart (v, S) */
arma::mat riwish(double v, const arma::mat& S, FastRNG& rng) {
    int d = S.n_rows;

    // Bartlett decomposition for Wishart
    arma::mat A(d, d, arma::fill::zeros);
    std::chi_squared_distribution<double> dist_chi;

    for(int i=0; i<d; ++i) {
        // Diagonal: sqrt(ChiSq(v - i))
        std::chi_squared_distribution<double>::param_type param(v - i);
        A(i, i) = std::sqrt(dist_chi(rng.mt, param));
        // Lower triangle: Normal(0, 1)
        for(int j=0; j<i; ++j) {
            A(i, j) = rng.rnorm(0, 1);
        }
    }

    // Rescale
    arma::mat L;
    try {
        L = arma::chol(S, "lower");
    } catch (...) {
        L = arma::chol(S + arma::eye(d,d)*1e-6, "lower");
    }


    arma::mat B = arma::inv(A.t()); // Upper triangular
    arma::mat Core = B * B.t();

    return L * Core * L.t();
}


// [[Rcpp::export]]
List gmm_mv_potts_gibbs_rcpp(
    NumericMatrix x,    // N x D
    List neighbors,
    int K,
    NumericVector m0,   // D
    double kappa0,
    NumericMatrix S0,   // D x D
    double nu0,
    double a_beta,
    double b_beta,
    NumericMatrix mu0,  // K x D
    List Sigma0,        // List of K matrices (D x D)
    IntegerVector z0,
    NumericVector beta0,
    int n_samples,
    int burn,
    double target_acceptance_rate = 0.44,
    bool fixed_beta = false,
    int n_mh_beta = 10,
    int n_gibbs_aux = 5,
    double sd_mh_beta = 0.05,
    int refresh = 50,
    bool verbose = true
) {
    int N = x.nrow();
    int D = x.ncol();
    int total_iter = burn + n_samples;

    arma::mat X = as<arma::mat>(x); // Use Armadillo matrix
    arma::vec m0_vec = as<arma::vec>(m0);
    arma::mat S0_mat = as<arma::mat>(S0);

    // Adjacency List (0-based)
    std::vector<std::vector<int>> adj(N);
    for(int i = 0; i < N; ++i) {
        IntegerVector nb = neighbors[i];
        adj[i].reserve(nb.size());
        for(int n : nb)
                adj[i].push_back(n - 1);
    }

    FastRNG rng(static_cast<unsigned int>(R::runif(0,1) * 2e9));

    arma::cube mu_out(D, K, total_iter + 1);
    std::vector<arma::cube> sigma_out(total_iter + 1, arma::cube(D, D, K));
    NumericMatrix beta_out(K, total_iter + 1);
    IntegerMatrix z_out(N, total_iter + 1);

    // Current State
    arma::mat mu_curr = as<arma::mat>(mu0).t();
    std::vector<arma::mat> sigma_curr(K);
    std::vector<arma::mat> prec_curr(K);
    std::vector<double> log_det_prec_curr(K);

    for(int k=0; k<K; ++k) {
        arma::mat S_k = as<arma::mat>(Sigma0[k]);
        sigma_curr[k] = S_k;
        prec_curr[k] = arma::inv_sympd(S_k);
        log_det_prec_curr[k] = std::log(arma::det(prec_curr[k]));

        mu_out.slice(0).col(k) = mu_curr.col(k);
        sigma_out[0].slice(k) = sigma_curr[k];
    }

    std::vector<double> beta_curr = as<std::vector<double>>(beta0);
    beta_out(_, 0) = beta0;

    std::vector<int> z_curr(N);
    for(int j=0; j<N; ++j)
        z_curr[j] = z0[j] - 1;          // 0-based

    for(int j=0; j<N; ++j)
        z_out(j, 0) = z_curr[j] + 1;


    // Potts statistics
    std::vector<int> U(N * K, 0);
    std::vector<int> z_N(K, 0);
    std::vector<double> T_z(K, 0.0);

    for (int j = 0; j < N; ++j) {
        int k_self = z_curr[j];
        z_N[k_self]++;
        for (int neighbor_idx : adj[j]) {
            int k_neighbor = z_curr[neighbor_idx];
            U[j * K + k_neighbor]++;
        }
    }
    for (int j = 0; j < N; ++j)
        T_z[z_curr[j]] += U[j * K + z_curr[j]];
    for(int k=0; k<K; ++k)
        T_z[k] *= 0.5;

    std::vector<int> order(N);
    std::iota(order.begin(), order.end(), 0);

    double current_sd_mh = sd_mh_beta;
    int accepted_count = 0;
    int batch_count = 0;

    if (verbose) Rprintf("Iteration %5d", 0);

    // Main Gibbs Loop
    for (int iter = 0; iter < total_iter; ++iter) {
        Rcpp::checkUserInterrupt();

        // Update GMM Parameters (NIW)
        std::vector<arma::mat> Scatter(K, arma::mat(D, D, arma::fill::zeros));
        std::vector<arma::vec> x_bar(K, arma::vec(D, arma::fill::zeros));
        std::vector<int> N_k(K, 0);

        for(int j=0; j<N; ++j) {
            int k = z_curr[j];
            arma::vec val = X.row(j).t();
            x_bar[k] += val;
            N_k[k]++;
        }

        for(int k=0; k<K; ++k) {
            if(N_k[k] > 0) {
                x_bar[k] /= N_k[k];
                for(int j=0; j<N; ++j) {
                    if(z_curr[j] == k) {
                        arma::vec diff = X.row(j).t() - x_bar[k];
                        Scatter[k] += diff * diff.t();
                    }
                }
            } else {
                x_bar[k] = arma::vec(D, arma::fill::zeros);
            }
        }

        for(int k=0; k<K; ++k) {
            double kappa_n = kappa0 + N_k[k];
            double nu_n = nu0 + N_k[k];
            arma::vec mu_n = (kappa0 * m0_vec + N_k[k] * x_bar[k]) / kappa_n;

            arma::vec diff_prior = x_bar[k] - m0_vec;
            arma::mat S_n = S0_mat + Scatter[k] + (kappa0 * N_k[k] / kappa_n) * (diff_prior * diff_prior.t());

            sigma_curr[k] = riwish(nu_n, S_n, rng);

            prec_curr[k] = arma::inv_sympd(sigma_curr[k]);
            log_det_prec_curr[k] = std::log(arma::det(prec_curr[k]));

            mu_curr.col(k) = rmvn(mu_n, sigma_curr[k] / kappa_n, rng);

            sigma_out[iter + 1].slice(k) = sigma_curr[k];
            mu_out.slice(iter + 1).col(k) = mu_curr.col(k);
        }

        // Precompute Log Likelihoods
        std::vector<double> log_liks(N * K);
        for(int k=0; k<K; ++k) {
            arma::vec mu_k = mu_curr.col(k);
            for(int j=0; j<N; ++j) {
                log_liks[j * K + k] = dmvn_log_prec(X.row(j), mu_k.t(), prec_curr[k], log_det_prec_curr[k]);
            }
        }

        // Update Labels
        std::shuffle(order.begin(), order.end(), rng.mt);

        for(int j : order) {
            int old_k = z_curr[j];

            // Remove z_j
            z_N[old_k]--;
            T_z[old_k] -= U[j * K + old_k];
            for(int nb : adj[j])
                U[nb * K + old_k]--;

            std::vector<double> log_probs(K);
            double max_lp = -1e9;

            for(int k=0; k<K; ++k) {
                log_probs[k] = beta_curr[k] * U[j * K + k] + log_liks[j * K + k];
                if(log_probs[k] > max_lp) max_lp = log_probs[k];
            }

            std::vector<double> probs(K);
            for(int k=0; k<K; ++k)
                probs[k] = std::exp(log_probs[k] - max_lp);

            int new_k = rng.sample_discrete(probs);
            z_curr[j] = new_k;

            // Add z_j
            for(int nb : adj[j]) U[nb * K + new_k]++;
            T_z[new_k] += U[j * K + new_k];
            z_N[new_k]++;
        }

        for(int j=0; j<N; ++j)
                z_out(j, iter + 1) = z_curr[j] + 1;     // 1-based


        // Update Beta (Exchange Algorithm)
        double beta_acc = 0;
        if (!fixed_beta) {
            double log_p_beta = 0.0;
            for(int k=0; k<K; ++k)
                log_p_beta += (a_beta - 1.0) * std::log(beta_curr[k]) - b_beta * beta_curr[k];

            for(int mh=0; mh < n_mh_beta; ++mh) {
                std::vector<double> beta_star = beta_curr;
                double log_proposal_ratio = 0.0;

                // bool invalid = false;
                for(int k=0; k<K; ++k) {
                    double u = rng.rnorm(0.0, current_sd_mh);
                    // beta_star[k] += rng.rnorm(0.0, current_sd_mh);
                    beta_star[k] *= std::exp(u);
                    // if(beta_star[k] <= 0) invalid = true;
                    log_proposal_ratio += u;
                }
                // if(invalid) continue;

                // Draw auxiliary using Gibbs
                std::vector<int> z_star = z_curr;
                std::vector<int> U_star = U;
                std::vector<double> T_z_star = T_z;

                for(int aux=0; aux < n_gibbs_aux; ++aux) {
                    for(int j : order) {
                        int old_k_s = z_star[j];
                        T_z_star[old_k_s] -= U_star[j * K + old_k_s];
                        for(int nb : adj[j]) U_star[nb * K + old_k_s]--;

                        std::vector<double> p_star(K);
                        for(int k=0; k<K; ++k) p_star[k] = std::exp(beta_star[k] * U_star[j * K + k]);

                        int new_k_s = rng.sample_discrete(p_star);
                        z_star[j] = new_k_s;

                        for(int nb : adj[j]) U_star[nb * K + new_k_s]++;
                        T_z_star[new_k_s] += U_star[j * K + new_k_s];
                    }
                }

                double log_p_beta_star = 0.0;
                for(int k=0; k<K; ++k)
                        log_p_beta_star += (a_beta - 1.0)*std::log(beta_star[k]) - b_beta*beta_star[k];

                double dot_prod = 0.0;
                for(int k=0; k<K; ++k)
                        dot_prod += (beta_star[k] - beta_curr[k]) * (T_z[k] - T_z_star[k]);

                // double log_alpha = log_p_beta_star - log_p_beta + dot_prod;
                double log_alpha = log_p_beta_star - log_p_beta + dot_prod + log_proposal_ratio;

                if (std::log(rng.runif()) < log_alpha) {
                    beta_curr = beta_star;
                    log_p_beta = log_p_beta_star;
                    beta_acc++;
                }
            }

            accepted_count += beta_acc;
            batch_count += n_mh_beta;
        }

        // Store Beta
        for(int k=0; k<K; ++k)
                beta_out(k, iter + 1) = beta_curr[k];


        if (verbose && refresh > 0 && ((iter + 1) % refresh == 0)) {
            double rate = (batch_count > 0) ? (double)accepted_count / batch_count : 0.0;

            if ((iter + 1) <= burn && !fixed_beta && batch_count > 0) {
                // Adapt MH step size to target rate
                if (rate > target_acceptance_rate)
                        current_sd_mh *= 1.05;
                else
                        current_sd_mh *= 0.95;

                if(current_sd_mh < 1e-4)
                        current_sd_mh = 1e-4;

                if(current_sd_mh > 5.0)
                        current_sd_mh = 5.0;
            }
            accepted_count = 0; batch_count = 0;

            Rprintf(
                "\rIteration %5d%s, MH Acceptance = %.3f, SD = %.3f",
                iter + 1,
                ((iter + 1) <= burn) ? " (Burn)" : "       ",
                rate,
                current_sd_mh
            );
        }
    }
    if(verbose) Rprintf("\n");

    // Slice for output
    Range r_out(burn + 1, total_iter);

    List sigma_final(K);
    for(int k=0; k<K; ++k) {
        arma::cube s_k(D, D, r_out.size());
        for(int i=0; i < r_out.size(); ++i) {
            s_k.slice(i) = sigma_out[r_out[i]].slice(k);
        }
        sigma_final[k] = s_k;
    }

    arma::cube mu_final(D, K, r_out.size());
    for(int i=0; i < r_out.size(); ++i) {
        mu_final.slice(i) = mu_out.slice(r_out[i]);
    }

    return List::create(
        Named("mu") = mu_final,
        Named("Sigma") = sigma_final,
        Named("beta") = beta_out(Range(0, K-1), r_out),
        Named("z") = z_out(Range(0, N-1), r_out)
    );
}
