#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class UrbanScorer {
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
        if (score >= 0.85) return "Extreme urban-development risk";
        if (score >= 0.65) return "High urban-development risk";
        if (score >= 0.45) return "Moderate urban-development risk";
        return "Lower urban-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"housing_affordability", 0.74, 0.20},
        {"informality_exclusion", 0.69, 0.18},
        {"service_deficit", 0.66, 0.18},
        {"resilience_weakness", 0.70, 0.16},
        {"justice_exposure", 0.64, 0.14},
        {"mobility_constraint", 0.58, 0.14}
    };

    double composite = UrbanScorer::score(signals);
    std::string label = UrbanScorer::classify(composite);

    std::cout << "Local Urban Risk Scorer\n";
    std::cout << "-----------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite urban score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
