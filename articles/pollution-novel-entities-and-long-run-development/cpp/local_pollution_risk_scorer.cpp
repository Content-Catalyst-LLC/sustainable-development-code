#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class PollutionScorer {
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
        if (score >= 0.85) return "Extreme pollution-development risk";
        if (score >= 0.65) return "High pollution-development risk";
        if (score >= 0.45) return "Moderate pollution-development risk";
        return "Lower pollution-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"hazardous_throughput", 0.80, 0.22},
        {"waste_overload", 0.76, 0.18},
        {"persistence_risk", 0.78, 0.20},
        {"assessment_lag", 0.72, 0.15},
        {"exposure_inequality", 0.70, 0.15},
        {"public_health_burden", 0.74, 0.10}
    };

    double composite = PollutionScorer::score(signals);
    std::string label = PollutionScorer::classify(composite);

    std::cout << "Local Pollution Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite pollution score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
