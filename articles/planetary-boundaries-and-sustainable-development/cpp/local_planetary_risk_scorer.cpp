#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class PlanetaryScorer {
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
        if (score >= 0.85) return "Extreme planetary-development risk";
        if (score >= 0.65) return "High planetary-development risk";
        if (score >= 0.45) return "Moderate planetary-development risk";
        return "Lower planetary-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"climate_stress", 0.80, 0.17},
        {"biosphere_loss", 0.82, 0.17},
        {"freshwater_change", 0.74, 0.14},
        {"land_system_change", 0.76, 0.14},
        {"biogeochemical_pressure", 0.84, 0.18},
        {"novel_entities", 0.79, 0.20}
    };

    double composite = PlanetaryScorer::score(signals);
    std::string label = PlanetaryScorer::classify(composite);

    std::cout << "Local Planetary Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite planetary score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
