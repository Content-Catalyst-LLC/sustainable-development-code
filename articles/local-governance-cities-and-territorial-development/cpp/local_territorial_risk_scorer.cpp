#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class TerritorialScorer {
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
        if (score >= 0.85) return "High territorial-governance quality";
        if (score >= 0.65) return "Moderate territorial-governance quality";
        if (score >= 0.45) return "Constrained territorial-governance quality";
        return "Weak territorial-governance quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"service_reach", 0.78, 0.25},
        {"land_housing_coordination", 0.72, 0.20},
        {"mobility_integration", 0.74, 0.20},
        {"resilience_capacity", 0.70, 0.15},
        {"spatial_justice", 0.68, 0.20}
    };

    double composite = TerritorialScorer::score(signals);
    std::string label = TerritorialScorer::classify(composite);

    std::cout << "Local Territorial Risk Scorer\n";
    std::cout << "-----------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite territorial score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
