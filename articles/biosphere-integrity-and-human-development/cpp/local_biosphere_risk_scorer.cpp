#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class BiosphereScorer {
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
        if (score >= 0.85) return "Extreme biosphere-development risk";
        if (score >= 0.65) return "High biosphere-development risk";
        if (score >= 0.45) return "Moderate biosphere-development risk";
        return "Lower biosphere-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"ecosystem_degradation", 0.80, 0.22},
        {"fragmentation_risk", 0.76, 0.16},
        {"service_erosion", 0.78, 0.18},
        {"function_loss", 0.79, 0.18},
        {"justice_exposure", 0.70, 0.12},
        {"livelihood_dependence", 0.74, 0.14}
    };

    double composite = BiosphereScorer::score(signals);
    std::string label = BiosphereScorer::classify(composite);

    std::cout << "Local Biosphere Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite biosphere score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
