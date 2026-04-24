#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class StewardshipScorer {
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
        if (score >= 0.85) return "Extreme intergenerational justice risk";
        if (score >= 0.65) return "High intergenerational justice risk";
        if (score >= 0.45) return "Moderate intergenerational justice risk";
        return "Lower intergenerational justice risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"future_burden_transfer", 0.76, 0.18},
        {"ecological_degradation", 0.72, 0.16},
        {"institutional_erosion", 0.63, 0.14},
        {"public_debt_lock_in", 0.58, 0.12},
        {"infrastructure_lock_in", 0.57, 0.12},
        {"climate_risk_transfer", 0.69, 0.14},
        {"future_representation_gap", 0.62, 0.14}
    };

    double composite = StewardshipScorer::score(signals);
    std::string label = StewardshipScorer::classify(composite);

    std::cout << "Local Stewardship Risk Scorer\n";
    std::cout << "-----------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite stewardship score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
