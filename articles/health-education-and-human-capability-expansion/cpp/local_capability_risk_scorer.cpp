#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class CapabilityScorer {
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
        if (score >= 0.85) return "Extreme capability risk";
        if (score >= 0.65) return "High capability risk";
        if (score >= 0.45) return "Moderate capability risk";
        return "Lower capability risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"financial_hardship_risk", 0.74, 0.22},
        {"learning_deprivation", 0.66, 0.18},
        {"life_course_vulnerability", 0.71, 0.18},
        {"inequality_exclusion", 0.64, 0.16},
        {"service_quality_gap", 0.58, 0.14},
        {"health_access_gap", 0.52, 0.12}
    };

    double composite = CapabilityScorer::score(signals);
    std::string label = CapabilityScorer::classify(composite);

    std::cout << "Local Capability Risk Scorer\n";
    std::cout << "----------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite capability score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
