/*
 * edge_resilience_scorer.cpp
 *
 * C++ example for local resilience scoring at the infrastructure edge.
 * This is useful where a node or local controller must classify operating conditions
 * under uncertain future environments without waiting for central analysis.
 */

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class ResilienceScorer {
public:
    static double score(const std::vector<Signal>& signals) {
        double weighted_sum = 0.0;
        double total_weight = 0.0;

        for (const auto& signal : signals) {
            weighted_sum += signal.value * signal.weight;
            total_weight += signal.weight;
        }

        return total_weight > 0.0 ? weighted_sum / total_weight : 0.0;
    }

    static std::string classify(double score) {
        if (score >= 0.75) return "High resilience";
        if (score >= 0.50) return "Moderate resilience";
        if (score >= 0.30) return "Stressed resilience";
        return "Low resilience";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"drainage_margin", 0.61, 0.30},
        {"backup_power_readiness", 0.73, 0.25},
        {"sensor_network_uptime", 0.82, 0.20},
        {"operator_response_readiness", 0.57, 0.15},
        {"communications_redundancy", 0.49, 0.10}
    };

    double composite = ResilienceScorer::score(signals);
    std::string label = ResilienceScorer::classify(composite);

    std::cout << "Edge Resilience Scorer\n";
    std::cout << "----------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite resilience score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
