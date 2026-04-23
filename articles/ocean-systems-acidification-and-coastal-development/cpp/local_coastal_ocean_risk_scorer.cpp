#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class CoastalOceanScorer {
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
        if (score >= 0.85) return "Extreme coastal-ocean risk";
        if (score >= 0.65) return "High coastal-ocean risk";
        if (score >= 0.45) return "Moderate coastal-ocean risk";
        return "Lower coastal-ocean risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"acidification_pressure", 0.79, 0.22},
        {"warming_pressure", 0.75, 0.18},
        {"deoxygenation_pressure", 0.71, 0.15},
        {"marine_dependence", 0.83, 0.20},
        {"fisheries_dependence", 0.76, 0.15},
        {"justice_exposure", 0.72, 0.10}
    };

    double composite = CoastalOceanScorer::score(signals);
    std::string label = CoastalOceanScorer::classify(composite);

    std::cout << "Local Coastal-Ocean Risk Scorer\n";
    std::cout << "-------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite coastal-ocean score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
