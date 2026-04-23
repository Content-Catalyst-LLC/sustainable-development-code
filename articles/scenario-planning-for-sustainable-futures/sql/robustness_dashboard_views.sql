CREATE VIEW strategy_robustness_dashboard AS
SELECT
    s.strategy_name,
    AVG(p.performance_score) AS avg_performance,
    MIN(p.performance_score) AS min_performance,
    MAX(p.performance_score) AS max_performance,
    AVG(p.cost_score) AS avg_cost,
    AVG(p.adaptability_score) AS avg_adaptability,
    AVG(p.equity_score) AS avg_equity,
    COUNT(*) AS scenarios_tested
FROM scenario_strategy_performance p
JOIN strategy_registry s ON p.strategy_id = s.strategy_id
GROUP BY s.strategy_name;

SELECT
    strategy_name,
    avg_performance,
    min_performance,
    max_performance,
    avg_cost,
    avg_adaptability,
    avg_equity,
    scenarios_tested
FROM strategy_robustness_dashboard
ORDER BY min_performance DESC, avg_adaptability DESC;
