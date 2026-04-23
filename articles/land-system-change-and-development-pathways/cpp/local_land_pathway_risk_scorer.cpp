#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class LandScorer {
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
        if (score >= 0.85) return "Extreme land-pathway risk";
        if (score >= 0.65) return "High land-pathway risk";
        if (score >= 0.45) return "Moderate land-pathway risk";
        return "Lower land-pathway risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"conversion_pressure", 0.80, 0.22},
        {"land_degradation", 0.77, 0.20},
        {"fragmentation_risk", 0.74, 0.16},
        {"biodiversity_loss", 0.79, 0.16},
        {"infrastructure_pressure", 0.72, 0.14},
        {"justice_exposure", 0.70, 0.12}
    };

    double composite = LandScorer::score(signals);
    std::string label = LandScorer::classify(composite);

    std::cout << "Local Land Pathway Risk Scorer\n";
    std::cout << "------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite land score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
