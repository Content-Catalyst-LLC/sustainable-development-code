/*
 * adaptive_edge_resilience.cpp
 *
 * A C++ example for local resilience scoring at the infrastructure edge.
 * This could represent an edge node evaluating uncertain conditions for
 * water, transport, or energy systems when remote coordination is delayed.
 */

#include <iostream>
#include <string>
#include <vector>
#include <iomanip>

struct ResilienceSignal {
    std::string name;
    double value;
    double weight;
};

class EdgeResilienceEvaluator {
public:
    static double computeScore(const std::vector<ResilienceSignal>& signals) {
        double weighted_sum = 0.0;
        double total_weight = 0.0;

        for (const auto& signal : signals) {
            weighted_sum += signal.value * signal.weight;
            total_weight += signal.weight;
        }

        if (total_weight == 0.0) {
            return 0.0;
        }

        return weighted_sum / total_weight;
    }

    static std::string classify(double score) {
        if (score >= 0.75) return "High resilience";
        if (score >= 0.50) return "Moderate resilience";
        if (score >= 0.30) return "Stressed resilience";
        return "Low resilience";
    }
};

int main() {
    std::vector<ResilienceSignal> signals = {
        {"water_storage_buffer", 0.82, 0.30},
        {"backup_power_readiness", 0.61, 0.25},
        {"sensor_network_uptime", 0.77, 0.20},
        {"drainage_capacity_margin", 0.49, 0.15},
        {"operator_response_readiness", 0.68, 0.10}
    };

    double score = EdgeResilienceEvaluator::computeScore(signals);
    std::string category = EdgeResilienceEvaluator::classify(score);

    std::cout << "Adaptive Edge Resilience Evaluation\n";
    std::cout << "-----------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite resilience score: " << std::fixed << std::setprecision(3) << score << "\n";
    std::cout << "Classification: " << category << "\n";

    return 0;
}
