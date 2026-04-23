#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class IndicatorScorer {
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
        if (score >= 0.85) return "Extreme indicator-limit risk";
        if (score >= 0.65) return "High indicator-limit risk";
        if (score >= 0.45) return "Moderate indicator-limit risk";
        return "Lower indicator-limit risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"inequality_penalty", 0.72, 0.20},
        {"gender_gap", 0.61, 0.15},
        {"multidimensional_poverty", 0.68, 0.20},
        {"subnational_variation", 0.70, 0.15},
        {"security_exclusion", 0.66, 0.15},
        {"data_confidence_gap", 0.58, 0.15}
    };

    double composite = IndicatorScorer::score(signals);
    std::string label = IndicatorScorer::classify(composite);

    std::cout << "Local Indicator Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite indicator score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
