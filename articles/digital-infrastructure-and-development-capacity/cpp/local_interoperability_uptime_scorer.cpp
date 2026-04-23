/*
 * local_interoperability_uptime_scorer.cpp
 *
 * Optional C++ example for local interoperability and uptime scoring.
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
        if (score >= 0.85) return "High operational robustness";
        if (score >= 0.65) return "Moderate operational robustness";
        if (score >= 0.45) return "Constrained operational robustness";
        return "Weak operational robustness";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"interoperability", 0.83, 0.25},
        {"registry_integrity", 0.79, 0.20},
        {"uptime_resilience", 0.74, 0.20},
        {"cybersecurity", 0.68, 0.20},
        {"open_standards", 0.72, 0.15}
    };

    double composite = InteroperabilityScorer::score(signals);
    std::string label = InteroperabilityScorer::classify(composite);

    std::cout << "Local Interoperability Uptime Scorer\n";
    std::cout << "------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite robustness score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
