#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class OvershootScorer {
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
        if (score >= 0.85) return "Extreme overshoot risk";
        if (score >= 0.65) return "High overshoot risk";
        if (score >= 0.45) return "Moderate overshoot risk";
        return "Lower overshoot risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"growth_pressure", 0.72, 0.16},
        {"throughput_pressure", 0.75, 0.16},
        {"resource_depletion", 0.66, 0.14},
        {"waste_absorptive_stress", 0.68, 0.14},
        {"planetary_pressure", 0.74, 0.14},
        {"delay_recognition_risk", 0.61, 0.13},
        {"infrastructure_lockin", 0.59, 0.13}
    };

    double composite = OvershootScorer::score(signals);
    std::string label = OvershootScorer::classify(composite);

    std::cout << "Local Overshoot Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(30) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite overshoot score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
