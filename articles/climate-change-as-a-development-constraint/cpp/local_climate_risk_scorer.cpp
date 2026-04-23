#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class ClimateScorer {
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
        if (score >= 0.85) return "Extreme climate-development risk";
        if (score >= 0.65) return "High climate-development risk";
        if (score >= 0.45) return "Moderate climate-development risk";
        return "Lower climate-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"heat_stress", 0.81, 0.18},
        {"hydrological_disruption", 0.76, 0.16},
        {"food_livelihood_exposure", 0.78, 0.18},
        {"health_burden", 0.74, 0.14},
        {"infrastructure_vulnerability", 0.79, 0.18},
        {"justice_exposure", 0.71, 0.16}
    };

    double composite = ClimateScorer::score(signals);
    std::string label = ClimateScorer::classify(composite);

    std::cout << "Local Climate Risk Scorer\n";
    std::cout << "-------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite climate score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
