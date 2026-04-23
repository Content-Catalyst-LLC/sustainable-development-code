#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class NutrientScorer {
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
        if (score >= 0.85) return "Extreme nutrient-development stress";
        if (score >= 0.65) return "High nutrient-development stress";
        if (score >= 0.45) return "Moderate nutrient-development stress";
        return "Lower nutrient-development stress";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"nitrogen_surplus", 0.81, 0.22},
        {"phosphorus_surplus", 0.76, 0.18},
        {"runoff_leakage", 0.74, 0.18},
        {"eutrophication_exposure", 0.79, 0.17},
        {"water_quality_burden", 0.72, 0.15},
        {"soil_balance_stress", 0.70, 0.10}
    };

    double composite = NutrientScorer::score(signals);
    std::string label = NutrientScorer::classify(composite);

    std::cout << "Local Nutrient Risk Scorer\n";
    std::cout << "--------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite nutrient score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
