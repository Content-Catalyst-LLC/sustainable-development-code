CREATE TABLE development_pathway_scenarios (
    record_id INTEGER PRIMARY KEY,
    strategy_name VARCHAR(255) NOT NULL,
    scenario_name VARCHAR(255) NOT NULL,
    assessment_year INTEGER NOT NULL,
    performance_score DECIMAL(5,4) NOT NULL,
    cost_score DECIMAL(5,4) NOT NULL,
    adaptability_score DECIMAL(5,4) NOT NULL,
    equity_score DECIMAL(5,4) NOT NULL
);

INSERT INTO development_pathway_scenarios (
    record_id,
    strategy_name,
    scenario_name,
    assessment_year,
    performance_score,
    cost_score,
    adaptability_score,
    equity_score
) VALUES
(1, 'Adaptive Infrastructure', 'High Warming / Trade Fragmentation', 2026, 0.74, 0.48, 0.82, 0.67),
(2, 'Adaptive Infrastructure', 'Moderate Warming / Cooperative Transition', 2026, 0.81, 0.48, 0.82, 0.67),
(3, 'Industrial Export Push', 'High Warming / Trade Fragmentation', 2026, 0.42, 0.61, 0.33, 0.39),
(4, 'Industrial Export Push', 'Moderate Warming / Cooperative Transition', 2026, 0.72, 0.61, 0.33, 0.39);

CREATE VIEW pathway_robustness_scores AS
SELECT
    strategy_name,
    AVG(performance_score) AS avg_performance,
    MIN(performance_score) AS min_performance,
    MAX(performance_score) AS max_performance,
    AVG(cost_score) AS avg_cost,
    AVG(adaptability_score) AS avg_adaptability,
    AVG(equity_score) AS avg_equity,
    COUNT(*) AS scenarios_tested
FROM development_pathway_scenarios
GROUP BY strategy_name;

SELECT
    strategy_name,
    avg_performance,
    min_performance,
    max_performance,
    avg_cost,
    avg_adaptability,
    avg_equity,
    scenarios_tested
FROM pathway_robustness_scores
ORDER BY min_performance DESC, avg_adaptability DESC;
