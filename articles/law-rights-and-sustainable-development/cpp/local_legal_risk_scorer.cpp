#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class LegalScorer {
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
        if (score >= 0.85) return "High legal-development quality";
        if (score >= 0.65) return "Moderate legal-development quality";
        if (score >= 0.45) return "Constrained legal-development quality";
        return "Weak legal-development quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"rights_protection", 0.82, 0.25},
        {"access_to_justice", 0.73, 0.20},
        {"procedural_participation", 0.71, 0.15},
        {"environmental_rights", 0.76, 0.20},
        {"enforcement_capacity", 0.68, 0.20}
    };

    double composite = LegalScorer::score(signals);
    std::string label = LegalScorer::classify(composite);

    std::cout << "Local Legal Risk Scorer\n";
    std::cout << "-----------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite legal score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
