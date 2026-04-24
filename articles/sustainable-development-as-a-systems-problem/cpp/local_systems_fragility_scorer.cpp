#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class SystemsFragilityScorer {
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
        if (score >= 0.85) return "Extreme systems fragility";
        if (score >= 0.65) return "High systems fragility";
        if (score >= 0.45) return "Moderate systems fragility";
        return "Lower systems fragility";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"interdependence_intensity", 0.74, 0.16},
        {"feedback_risk", 0.69, 0.16},
        {"delay_exposure", 0.63, 0.14},
        {"path_dependence", 0.61, 0.14},
        {"cross_scale_pressure", 0.66, 0.14},
        {"earth_system_stress", 0.72, 0.14},
        {"governance_fragmentation", 0.58, 0.12}
    };

    double composite = SystemsFragilityScorer::score(signals);
    std::string label = SystemsFragilityScorer::classify(composite);

    std::cout << "Local Systems Fragility Scorer\n";
    std::cout << "------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite systems fragility score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
