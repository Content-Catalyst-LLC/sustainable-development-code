/*
 * local_debt_alert_scorer.cpp
 *
 * Optional C++ example for local debt-alert and sustainability-threshold scoring.
 */

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class AlertScorer {
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
        if (score >= 0.80) return "Severe alert";
        if (score >= 0.60) return "Elevated alert";
        if (score >= 0.40) return "Moderate alert";
        return "Lower alert";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"debt_service_stress", 0.74, 0.30},
        {"refinancing_stress", 0.66, 0.25},
        {"fx_exposure", 0.58, 0.20},
        {"climate_vulnerability", 0.71, 0.15},
        {"investment_compression", 0.62, 0.10}
    };

    double composite = AlertScorer::score(signals);
    std::string label = AlertScorer::classify(composite);

    std::cout << "Local Debt Alert Scorer\n";
    std::cout << "-----------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite alert score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
