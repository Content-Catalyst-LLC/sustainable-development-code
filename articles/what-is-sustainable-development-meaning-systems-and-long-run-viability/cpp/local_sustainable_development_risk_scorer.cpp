#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class SustainableDevelopmentScorer {
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
        if (score >= 0.85) return "Extreme sustainable development risk";
        if (score >= 0.65) return "High sustainable development risk";
        if (score >= 0.45) return "Moderate sustainable development risk";
        return "Lower sustainable development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"present_deprivation", 0.71, 0.16},
        {"wellbeing_support_gap", 0.54, 0.14},
        {"ecological_stress", 0.68, 0.14},
        {"future_burden_transfer", 0.60, 0.12},
        {"institutional_durability_gap", 0.52, 0.10},
        {"systems_interdependence_risk", 0.58, 0.10},
        {"long_run_viability_gap", 0.57, 0.12},
        {"planetary_constraint_exposure", 0.62, 0.12}
    };

    double composite = SustainableDevelopmentScorer::score(signals);
    std::string label = SustainableDevelopmentScorer::classify(composite);

    std::cout << "Local Sustainable Development Risk Scorer\n";
    std::cout << "-----------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(34) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite sustainable development score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
