#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

struct Signal {
    std::string name;
    double value;
    double weight;
};

class ParticipationScorer {
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
        if (score >= 0.85) return "High participation quality";
        if (score >= 0.65) return "Moderate participation quality";
        if (score >= 0.45) return "Constrained participation quality";
        return "Weak participation quality";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"participatory_depth", 0.82, 0.25},
        {"representation_quality", 0.74, 0.20},
        {"institutional_uptake", 0.69, 0.20},
        {"community_control", 0.77, 0.20},
        {"feedback_closure", 0.70, 0.15}
    };

    double composite = ParticipationScorer::score(signals);
    std::string label = ParticipationScorer::classify(composite);

    std::cout << "Local Participation Signal Scorer\n";
    std::cout << "---------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(24) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite participation score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
