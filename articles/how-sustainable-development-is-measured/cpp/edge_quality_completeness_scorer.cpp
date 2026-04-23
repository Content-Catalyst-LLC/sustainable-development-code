/*
 * edge_quality_completeness_scorer.cpp
 *
 * Optional C++ example for local data-quality and completeness scoring.
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

class QualityScorer {
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
        if (score >= 0.85) return "High quality";
        if (score >= 0.65) return "Moderate quality";
        if (score >= 0.40) return "Low quality";
        return "Critical quality gap";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"coverage_rate", 0.81, 0.35},
        {"metadata_completeness", 0.74, 0.25},
        {"subgroup_reporting", 0.59, 0.20},
        {"time_series_consistency", 0.68, 0.20}
    };

    double composite = QualityScorer::score(signals);
    std::string label = QualityScorer::classify(composite);

    std::cout << "Edge Quality Completeness Scorer\n";
    std::cout << "--------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(26) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite quality score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
