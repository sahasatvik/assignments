#include <Rcpp.h>
#include <vector>
#include <random>
#include <algorithm>
#include <numeric>

using namespace Rcpp;

// [[Rcpp::export]]
IntegerMatrix potts_gibbs_rcpp(
    List neighbors_r,
    NumericVector beta,
    IntegerVector z0,
    NumericMatrix weights,
    int burn,
    int n_samples,
    int seed = 123
) {
    const int N = z0.size();
    const int K = beta.size();
    const int total_iter = burn + n_samples;


    std::vector<std::vector<int>> neighbors(N);
    for (int j = 0; j < N; ++j) {
        IntegerVector nb = neighbors_r[j];
        neighbors[j].reserve(nb.size());
        for (int v : nb) neighbors[j].push_back(v - 1); // 0-based
    }

    std::vector<int> z_now(N);
    for (int j = 0; j < N; ++j)
        z_now[j] = z0[j] - 1;


    int max_neighbors = 0;
    for (int j = 0; j < N; ++j)
        max_neighbors = std::max(max_neighbors, (int)neighbors[j].size());

    std::vector<std::vector<double>> exp_table(
        K, std::vector<double>(max_neighbors + 1)
    );

    for (int k = 0; k < K; ++k) {
        for (int u = 0; u <= max_neighbors; ++u) {
            exp_table[k][u] = std::exp(beta[k] * u);
        }
    }


    std::vector<uint8_t> U(N * K, 0);

    for (int j = 0; j < N; ++j) {
        for (int nb : neighbors[j]) {
            U[j * K + z_now[nb]]++;
        }
    }


    std::mt19937 rng(seed);
    std::uniform_real_distribution<double> unif(0.0, 1.0);


    std::vector<int> order(N);
    std::iota(order.begin(), order.end(), 0);


    IntegerMatrix out(N, n_samples);

    std::vector<double> prob(K);
    int saved = 0;



    for (int iter = 0; iter < total_iter; ++iter) {

        std::shuffle(order.begin(), order.end(), rng);

        for (int idx = 0; idx < N; ++idx) {
            int j = order[idx];
            int old_k = z_now[j];

            // Remove z_j
            for (int nb : neighbors[j]) {
                U[nb * K + old_k]--;
            }

            double sum_p = 0.0;
            uint8_t* Uj = &U[j * K];

            for (int k = 0; k < K; ++k) {
                double p = exp_table[k][Uj[k]] * weights(j, k);
                prob[k] = p;
                sum_p += p;
            }

            // Sample new label
            double u = unif(rng) * sum_p;
            double cumsum = 0.0;
            int new_k = K - 1;

            for (int k = 0; k < K; ++k) {
                cumsum += prob[k];
                if (u <= cumsum) {
                    new_k = k;
                    break;
                }
            }

            z_now[j] = new_k;

            // Add z_j
            for (int nb : neighbors[j]) {
                U[nb * K + new_k]++;
            }
        }

        // Save after burn-in
        if (iter >= burn) {
            for (int j = 0; j < N; ++j)
                out(j, saved) = z_now[j] + 1;   // 1-based
            saved++;
        }
    }

    return out;
}
