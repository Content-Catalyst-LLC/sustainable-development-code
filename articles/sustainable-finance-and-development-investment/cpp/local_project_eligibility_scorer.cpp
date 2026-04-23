/*
 * local_project_eligibility_scorer.cpp
 *
 * Optional C++ example for local project eligibility and resilience scoring.
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

class EligibilityScorer {
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
        if (score >= 0.85) return "Highly eligible";
        if (score >= 0.65) return "Eligible";
        if (score >= 0.45) return "Conditionally eligible";
        return "Weak eligibility";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"development_additionality", 0.83, 0.30},
        {"climate_resilience", 0.74, 0.25},
        {"inclusion_strength", 0.69, 0.20},
        {"bankability", 0.61, 0.15},
        {"implementation_feasibility", 0.72, 0.10}
    };

    double composite = EligibilityScorer::score(signals);
    std::string label = EligibilityScorer::classify(composite);

    std::cout << "Local Project Eligibility Scorer\n";
    std::cout << "--------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite eligibility score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
