#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class HumanDevelopmentScorer {
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
        if (score >= 0.85) return "Extreme human development risk";
        if (score >= 0.65) return "High human development risk";
        if (score >= 0.45) return "Moderate human development risk";
        return "Lower human development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"output_growth_pressure", 0.71, 0.16},
        {"income_conversion_gap", 0.58, 0.14},
        {"public_goods_gap", 0.61, 0.14},
        {"distribution_constraint", 0.66, 0.14},
        {"institutional_support_gap", 0.54, 0.12},
        {"ecological_durability_gap", 0.57, 0.12},
        {"agency_freedom_gap", 0.49, 0.10},
        {"alignment_gap", 0.46, 0.08}
    };

    double composite = HumanDevelopmentScorer::score(signals);
    std::string label = HumanDevelopmentScorer::classify(composite);

    std::cout << "Local Human Development Risk Scorer\n";
    std::cout << "-----------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite human development score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
