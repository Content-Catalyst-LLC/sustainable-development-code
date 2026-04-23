#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class ThresholdScorer {
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
        if (score >= 0.85) return "Extreme threshold risk";
        if (score >= 0.65) return "High threshold risk";
        if (score >= 0.45) return "Moderate threshold risk";
        return "Lower threshold risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"cumulative_pressure", 0.82, 0.20},
        {"feedback_intensity", 0.77, 0.20},
        {"cascade_exposure", 0.75, 0.20},
        {"recovery_difficulty", 0.71, 0.20},
        {"justice_exposure", 0.68, 0.20}
    };

    double composite = ThresholdScorer::score(signals);
    std::string label = ThresholdScorer::classify(composite);

    std::cout << "Local Threshold Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite threshold score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
