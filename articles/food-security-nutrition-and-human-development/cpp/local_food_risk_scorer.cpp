#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class FoodScorer {
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
        if (score >= 0.85) return "Extreme food-development risk";
        if (score >= 0.65) return "High food-development risk";
        if (score >= 0.45) return "Moderate food-development risk";
        return "Lower food-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"diet_affordability_stress", 0.74, 0.22},
        {"price_volatility", 0.66, 0.16},
        {"food_system_fragility", 0.71, 0.18},
        {"poverty_exposure", 0.69, 0.16},
        {"child_maternal_risk", 0.64, 0.14},
        {"nutrition_quality_gap", 0.58, 0.14}
    };

    double composite = FoodScorer::score(signals);
    std::string label = FoodScorer::classify(composite);

    std::cout << "Local Food Risk Scorer\n";
    std::cout << "----------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite food score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
