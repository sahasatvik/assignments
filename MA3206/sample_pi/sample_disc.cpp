#include <random>
#include <cstdlib>

const double pi = 3.14159265358979323846;

int main(int argc, const char *argv[]) {
        long n = 100;
        if (argc > 1)
                n = std::stol(argv[1]);

        // Set up random number generator
        std::random_device rd;
        std::mt19937 generator(rd());
        std::uniform_real_distribution<> distribution(-1, 1);

        long accepted = 0;
        long rejected = 0;
        
        // Loop until 'n' points accepted
        while (accepted < n) {
                // Pick random coordinates from the square
                double x = distribution(generator);
                double y = distribution(generator);
                if (x*x + y*y <= 1) {
                        accepted += 1;
                } else {
                        rejected += 1;
                }
        }
        
        // Calculate pi estimates, errors
        long total = accepted + rejected;
        double pi_estimate = 4.0 * accepted / total;
        double error = pi_estimate - pi;
        double error_rel = 100 * error / pi;

        printf("%d accepted, %d total, pi estimated as %f\n", accepted, total, pi_estimate);
        printf("Error is %f (%f%%)\n", error, error_rel);

        return 0;
}
