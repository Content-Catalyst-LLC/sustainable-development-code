#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class FreshwaterScorer {
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
        if (score >= 0.85) return "Extreme freshwater-development risk";
        if (score >= 0.65) return "High freshwater-development risk";
        if (score >= 0.45) return "Moderate freshwater-development risk";
        return "Lower freshwater-development risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"streamflow_stress", 0.80, 0.20},
        {"soil_moisture_stress", 0.76, 0.18},
        {"water_quality_burden", 0.74, 0.16},
        {"wastewater_deficit", 0.72, 0.16},
        {"ecosystem_decline", 0.79, 0.15},
        {"sanitation_exposure", 0.71, 0.15}
    };

    double composite = FreshwaterScorer::score(signals);
    std::string label = FreshwaterScorer::classify(composite);

    std::cout << "Local Freshwater Risk Scorer\n";
    std::cout << "----------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite freshwater score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
