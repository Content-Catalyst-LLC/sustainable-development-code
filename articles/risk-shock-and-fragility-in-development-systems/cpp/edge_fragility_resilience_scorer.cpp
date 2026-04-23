/*
 * edge_fragility_resilience_scorer.cpp
 *
 * C++ example for local fragility and resilience scoring at the infrastructure edge.
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
        if (score >= 0.50) return "Elevated fragility";
        if (score >= 0.30) return "Moderate fragility";
        return "Lower fragility";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"flood_exposure", 0.79, 0.25},
        {"power_instability", 0.66, 0.20},
        {"water_system_brittleness", 0.73, 0.20},
        {"communications_failure_risk", 0.58, 0.15},
        {"low institutional fallback", 0.69, 0.20}
    };

    double composite = FragilityScorer::score(signals);
    std::string label = FragilityScorer::classify(composite);

    std::cout << "Edge Fragility Resilience Scorer\n";
    std::cout << "--------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite fragility score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
