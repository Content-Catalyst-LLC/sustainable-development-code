/*
 * local_coordination_alert_scorer.cpp
 *
 * Optional C++ example for local system-event and coordination alert scoring.
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

class CoordinationScorer {
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
        if (score >= 0.85) return "High systemic coordination alert";
        if (score >= 0.65) return "Moderate systemic coordination alert";
        if (score >= 0.45) return "Constrained systemic coordination alert";
        return "Lower systemic coordination alert";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"spillover_pressure", 0.79, 0.25},
        {"implementation_gap", 0.72, 0.20},
        {"interagency_fragmentation", 0.68, 0.20},
        {"territorial_mismatch", 0.74, 0.20},
        {"shock_response_stress", 0.66, 0.15}
    };

    double composite = CoordinationScorer::score(signals);
    std::string label = CoordinationScorer::classify(composite);

    std::cout << "Local Coordination Alert Scorer\n";
    std::cout << "-------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite coordination score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
