/*
 * local_infrastructure_quality_and_resilience_scorer.cpp
 *
 * Optional C++ example for local infrastructure quality and resilience scoring.
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

class InfrastructureScorer {
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
        if (score >= 0.85) return "High infrastructure resilience";
        if (score >= 0.65) return "Moderate infrastructure resilience";
        if (score >= 0.45) return "Constrained infrastructure resilience";
        return "Weak infrastructure resilience";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"service_reliability", 0.81, 0.25},
        {"maintenance_capacity", 0.76, 0.20},
        {"inspection_quality", 0.69, 0.15},
        {"redundancy", 0.72, 0.20},
        {"climate_resilience", 0.75, 0.20}
    };

    double composite = InfrastructureScorer::score(signals);
    std::string label = InfrastructureScorer::classify(composite);

    std::cout << "Local Infrastructure Quality and Resilience Scorer\n";
    std::cout << "-------------------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite infrastructure score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
