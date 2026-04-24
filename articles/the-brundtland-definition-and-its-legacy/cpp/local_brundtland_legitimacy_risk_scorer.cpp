#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class BrundtlandScorer {
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
        if (score >= 0.85) return "Extreme Brundtland legitimacy risk";
        if (score >= 0.65) return "High Brundtland legitimacy risk";
        if (score >= 0.45) return "Moderate Brundtland legitimacy risk";
        return "Lower Brundtland legitimacy risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"present_need_pressure", 0.73, 0.16},
        {"poverty_support_gap", 0.56, 0.14},
        {"ecological_degradation", 0.68, 0.16},
        {"future_burden_transfer", 0.62, 0.14},
        {"institutional_durability_gap", 0.51, 0.12},
        {"stewardship_gap", 0.54, 0.10},
        {"absorptive_stress", 0.59, 0.10},
        {"technology_organisation_constraint", 0.47, 0.08}
    };

    double composite = BrundtlandScorer::score(signals);
    std::string label = BrundtlandScorer::classify(composite);

    std::cout << "Local Brundtland Legitimacy Risk Scorer\n";
    std::cout << "---------------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(34) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite Brundtland score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
