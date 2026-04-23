#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class InclusionScorer {
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
        if (score >= 0.85) return "Extreme inclusion risk";
        if (score >= 0.65) return "High inclusion risk";
        if (score >= 0.45) return "Moderate inclusion risk";
        return "Lower inclusion risk";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"opportunity_blockage", 0.74, 0.22},
        {"risk_exposure", 0.66, 0.18},
        {"institutional_capture", 0.70, 0.22},
        {"public_goods_gap", 0.58, 0.14},
        {"income_security_gap", 0.61, 0.12},
        {"health_access_gap", 0.52, 0.12}
    };

    double composite = InclusionScorer::score(signals);
    std::string label = InclusionScorer::classify(composite);

    std::cout << "Local Inclusion Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite inclusion score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
