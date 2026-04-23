#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class PovertyScorer {
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
        if (score >= 0.85) return "Extreme multidimensional poverty risk";
        if (score >= 0.65) return "High multidimensional poverty risk";
        if (score >= 0.45) return "Moderate multidimensional poverty risk";
        return "Lower multidimensional poverty risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"housing_deprivation", 0.72, 0.14},
        {"sanitation_deprivation", 0.70, 0.14},
        {"energy_deprivation", 0.66, 0.14},
        {"nutrition_deprivation", 0.68, 0.14},
        {"learning_deprivation", 0.61, 0.14},
        {"climate_exposure", 0.59, 0.10},
        {"child_vulnerability", 0.64, 0.10},
        {"public_goods_gap", 0.57, 0.10}
    };

    double composite = PovertyScorer::score(signals);
    std::string label = PovertyScorer::classify(composite);

    std::cout << "Local Poverty Risk Scorer\n";
    std::cout << "-------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite poverty score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
