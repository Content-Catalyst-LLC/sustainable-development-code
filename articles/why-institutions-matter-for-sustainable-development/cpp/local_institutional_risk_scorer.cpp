#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class InstitutionalScorer {
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
        if (score >= 0.85) return "High institutional quality";
        if (score >= 0.65) return "Moderate institutional quality";
        if (score >= 0.45) return "Constrained institutional quality";
        return "Weak institutional quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"implementation_capacity", 0.79, 0.22},
        {"coordination_capacity", 0.75, 0.18},
        {"delivery_reliability", 0.73, 0.18},
        {"trust_support", 0.68, 0.16},
        {"accountability_strength", 0.72, 0.14},
        {"learning_capacity", 0.70, 0.12}
    };

    double composite = InstitutionalScorer::score(signals);
    std::string label = InstitutionalScorer::classify(composite);

    std::cout << "Local Institutional Risk Scorer\n";
    std::cout << "-------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite institutional score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
