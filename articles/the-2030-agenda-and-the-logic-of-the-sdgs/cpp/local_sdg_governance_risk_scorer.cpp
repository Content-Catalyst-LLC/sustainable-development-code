#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class SDGScorer {
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
        if (score >= 0.85) return "Extreme SDG governance risk";
        if (score >= 0.65) return "High SDG governance risk";
        if (score >= 0.45) return "Moderate SDG governance risk";
        return "Lower SDG governance risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"universality_exposure", 0.64, 0.16},
        {"integration_complexity", 0.72, 0.16},
        {"implementation_gap", 0.61, 0.14},
        {"means_of_implementation_gap", 0.58, 0.14},
        {"partnership_gap", 0.55, 0.12},
        {"monitoring_gap", 0.57, 0.12},
        {"policy_fragmentation", 0.63, 0.08},
        {"alignment_gap", 0.52, 0.08}
    };

    double composite = SDGScorer::score(signals);
    std::string label = SDGScorer::classify(composite);

    std::cout << "Local SDG Governance Risk Scorer\n";
    std::cout << "-------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(32) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite SDG governance score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
