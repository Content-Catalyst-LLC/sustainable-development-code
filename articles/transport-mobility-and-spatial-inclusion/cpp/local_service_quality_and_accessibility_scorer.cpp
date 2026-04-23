/*
 * local_service_quality_and_accessibility_scorer.cpp
 *
 * Optional C++ example for local service quality and accessibility scoring.
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

class MobilityScorer {
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
        if (score >= 0.85) return "High service quality";
        if (score >= 0.65) return "Moderate service quality";
        if (score >= 0.45) return "Constrained service quality";
        return "Weak service quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"route_coverage", 0.82, 0.25},
        {"service_reliability", 0.74, 0.20},
        {"fare_affordability", 0.68, 0.20},
        {"stop_accessibility", 0.77, 0.20},
        {"safety", 0.71, 0.15}
    };

    double composite = MobilityScorer::score(signals);
    std::string label = MobilityScorer::classify(composite);

    std::cout << "Local Service Quality and Accessibility Scorer\n";
    std::cout << "---------------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite mobility score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
