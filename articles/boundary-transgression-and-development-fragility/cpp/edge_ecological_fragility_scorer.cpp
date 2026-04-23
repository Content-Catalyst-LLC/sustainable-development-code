/*
 * edge_ecological_fragility_scorer.cpp
 *
 * C++ example for local ecological fragility and resilience scoring at the infrastructure edge.
 */

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class FragilityScorer {
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
        if (score >= 0.75) return "Severe fragility";
        if (score >= 0.55) return "Elevated fragility";
        if (score >= 0.35) return "Moderate fragility";
        return "Lower fragility";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"climate_pressure", 0.78, 0.25},
        {"freshwater_pressure", 0.72, 0.20},
        {"biosphere_pressure", 0.66, 0.20},
        {"land_system_pressure", 0.61, 0.20},
        {"nutrient_pressure", 0.54, 0.15}
    };

    double composite = FragilityScorer::score(signals);
    std::string label = FragilityScorer::classify(composite);

    std::cout << "Edge Ecological Fragility Scorer\n";
    std::cout << "--------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite ecological fragility score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
