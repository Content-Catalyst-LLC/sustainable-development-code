#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class PolicyCoherenceScorer {
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
        if (score >= 0.85) return "Extreme policy coherence risk";
        if (score >= 0.65) return "High policy coherence risk";
        if (score >= 0.45) return "Moderate policy coherence risk";
        return "Lower policy coherence risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"tradeoff_intensity", 0.73, 0.20},
        {"sectoral_spillover", 0.68, 0.16},
        {"transboundary_spillover", 0.61, 0.14},
        {"intergenerational_spillover", 0.64, 0.14},
        {"governance_fragmentation", 0.66, 0.18},
        {"policy_alignment_gap", 0.55, 0.18}
    };

    double composite = PolicyCoherenceScorer::score(signals);
    std::string label = PolicyCoherenceScorer::classify(composite);

    std::cout << "Local Policy Coherence Risk Scorer\n";
    std::cout << "----------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite policy coherence score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
