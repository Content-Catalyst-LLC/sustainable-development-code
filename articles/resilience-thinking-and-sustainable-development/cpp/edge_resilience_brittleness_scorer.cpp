/*
 * edge_resilience_brittleness_scorer.cpp
 *
 * C++ example for local resilience and brittleness scoring at the infrastructure edge.
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

class ResilienceScorer {
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
        if (score >= 0.75) return "High resilience";
        if (score >= 0.55) return "Moderate resilience";
        if (score >= 0.35) return "Stressed resilience";
        return "Low resilience";
    }
};

int main() {
    std::vector<Signal> signals = {
        {"coping_capacity", 0.72, 0.20},
        {"adaptive_capacity", 0.66, 0.20},
        {"transformative_capacity", 0.49, 0.20},
        {"institutional_learning", 0.61, 0.15},
        {"ecological_buffer", 0.74, 0.15},
        {"equity_protection", 0.58, 0.10}
    };

    double composite = ResilienceScorer::score(signals);
    std::string label = ResilienceScorer::classify(composite);

    std::cout << "Edge Resilience Brittleness Scorer\n";
    std::cout << "----------------------------------\n";

    for (const auto& signal : signals) {
        std::cout << std::left << std::setw(28) << signal.name
                  << " value=" << std::fixed << std::setprecision(2) << signal.value
                  << " weight=" << signal.weight << "\n";
    }

    std::cout << "\nComposite resilience score: " << std::fixed << std::setprecision(3) << composite << "\n";
    std::cout << "Classification: " << label << "\n";

    return 0;
}
