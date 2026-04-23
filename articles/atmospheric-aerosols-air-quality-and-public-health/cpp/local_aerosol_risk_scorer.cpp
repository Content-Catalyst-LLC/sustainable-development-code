#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class AerosolScorer {
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
        if (score >= 0.85) return "Extreme aerosol-health burden";
        if (score >= 0.65) return "High aerosol-health burden";
        if (score >= 0.45) return "Moderate aerosol-health burden";
        return "Lower aerosol-health burden";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"ambient_pm25", 0.82, 0.25},
        {"household_exposure", 0.72, 0.20},
        {"transport_pressure", 0.74, 0.20},
        {"industrial_pressure", 0.69, 0.15},
        {"exposure_inequality", 0.71, 0.20}
    };

    double composite = AerosolScorer::score(signals);
    std::string label = AerosolScorer::classify(composite);

    std::cout << "Local Aerosol Risk Scorer\n";
    std::cout << "-------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite aerosol score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
