#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class LongRunScorer {
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
        if (score >= 0.85) return "Extreme long-run development risk";
        if (score >= 0.65) return "High long-run development risk";
        if (score >= 0.45) return "Moderate long-run development risk";
        return "Lower long-run development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"climate_boundary_pressure", 0.80, 0.16},
        {"biosphere_boundary_pressure", 0.78, 0.16},
        {"land_system_pressure", 0.70, 0.14},
        {"freshwater_pressure", 0.66, 0.14},
        {"biogeochemical_pressure", 0.75, 0.14},
        {"novel_entities_pressure", 0.72, 0.13},
        {"ocean_acidification_pressure", 0.61, 0.13}
    };

    double composite = LongRunScorer::score(signals);
    std::string label = LongRunScorer::classify(composite);

    std::cout << "Local Long-Run Development Risk Scorer\n";
    std::cout << "--------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(32) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite long-run development score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
