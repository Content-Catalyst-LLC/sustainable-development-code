/*
 * edge_interoperability_scorer.cpp
 *
 * Optional C++ example for local interoperability and resilience scoring
 * in distributed digital or green infrastructure systems.
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

class InteroperabilityScorer {
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
        if (score >= 0.80) return "High interoperability";
        if (score >= 0.60) return "Moderate interoperability";
        if (score >= 0.40) return "Constrained interoperability";
        return "Low interoperability";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"open_standards_alignment", 0.76, 0.30},
        {"local_maintenance_capacity", 0.58, 0.25},
        {"supplier_diversity", 0.62, 0.20},
        {"grid_or_network_stability", 0.71, 0.15},
        {"training_readiness", 0.68, 0.10}
    };

    double composite = InteroperabilityScorer::score(signals);
    std::string label = InteroperabilityScorer::classify(composite);

    std::cout << "Edge Interoperability Scorer\n";
    std::cout << "----------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite interoperability score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
