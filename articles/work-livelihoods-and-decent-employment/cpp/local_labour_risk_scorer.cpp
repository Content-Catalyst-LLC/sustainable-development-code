#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class LabourScorer {
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
        if (score >= 0.85) return "Extreme decent-employment risk";
        if (score >= 0.65) return "High decent-employment risk";
        if (score >= 0.45) return "Moderate decent-employment risk";
        return "Lower decent-employment risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"informality_risk", 0.72, 0.20},
        {"precarity_risk", 0.69, 0.20},
        {"income_insecurity", 0.63, 0.15},
        {"rights_exposure", 0.66, 0.15},
        {"youth_exclusion", 0.61, 0.15},
        {"gender_gap", 0.58, 0.15}
    };

    double composite = LabourScorer::score(signals);
    std::string label = LabourScorer::classify(composite);

    std::cout << "Local Labour Risk Scorer\n";
    std::cout << "------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite labour score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
