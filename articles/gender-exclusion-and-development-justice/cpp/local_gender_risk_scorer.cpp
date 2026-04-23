#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class GenderScorer {
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
        if (score >= 0.85) return "Extreme gender-justice risk";
        if (score >= 0.65) return "High gender-justice risk";
        if (score >= 0.45) return "Moderate gender-justice risk";
        return "Lower gender-justice risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"care_burden", 0.74, 0.22},
        {"violence_exposure", 0.67, 0.20},
        {"institutional_power_gap", 0.63, 0.18},
        {"property_rights_gap", 0.60, 0.14},
        {"economic_participation_gap", 0.58, 0.14},
        {"education_access_gap", 0.49, 0.12}
    };

    double composite = GenderScorer::score(signals);
    std::string label = GenderScorer::classify(composite);

    std::cout << "Local Gender Risk Scorer\n";
    std::cout << "------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite gender score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
