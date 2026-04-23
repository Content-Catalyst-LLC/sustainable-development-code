#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class GovernanceScorer {
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
        if (score >= 0.85) return "High multilateral-governance quality";
        if (score >= 0.65) return "Moderate multilateral-governance quality";
        if (score >= 0.45) return "Constrained multilateral-governance quality";
        return "Weak multilateral-governance quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"coordination_strength", 0.79, 0.25},
        {"finance_support", 0.74, 0.20},
        {"knowledge_standards", 0.76, 0.20},
        {"implementation_support", 0.68, 0.15},
        {"legitimacy", 0.70, 0.20}
    };

    double composite = GovernanceScorer::score(signals);
    std::string label = GovernanceScorer::classify(composite);

    std::cout << "Local Multilateral Risk Scorer\n";
    std::cout << "------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite governance score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
