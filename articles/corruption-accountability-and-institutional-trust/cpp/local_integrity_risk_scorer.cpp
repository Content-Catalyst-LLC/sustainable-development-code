#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class IntegrityScorer {
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
        if (score >= 0.85) return "High integrity quality";
        if (score >= 0.65) return "Moderate integrity quality";
        if (score >= 0.45) return "Constrained integrity quality";
        return "Weak integrity quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"procurement_integrity", 0.80, 0.25},
        {"audit_capacity", 0.73, 0.20},
        {"complaint_access", 0.68, 0.15},
        {"service_integrity", 0.72, 0.20},
        {"trust_support", 0.70, 0.20}
    };

    double composite = IntegrityScorer::score(signals);
    std::string label = IntegrityScorer::classify(composite);

    std::cout << "Local Integrity Risk Scorer\n";
    std::cout << "---------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite integrity score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
