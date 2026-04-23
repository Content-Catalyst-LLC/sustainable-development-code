CREATE VIEW goal_distance_dashboard AS
SELECT
    country_name,
    goal,
    COUNT(*) AS indicators_reported,
    AVG(
        CASE
            WHEN direction = 'higher_better' THEN
                CASE
                    WHEN upper_bound > lower_bound THEN
                        MIN(1.0, MAX(0.0, (target_value - actual_value) / (upper_bound - lower_bound)))
                    ELSE NULL
                END
            WHEN direction = 'lower_better' THEN
                CASE
                    WHEN upper_bound > lower_bound THEN
                        MIN(1.0, MAX(0.0, (actual_value - target_value) / (upper_bound - lower_bound)))
                    ELSE NULL
                END
            ELSE NULL
        END
    ) AS avg_distance_to_target
FROM development_indicator_registry
GROUP BY country_name, goal;

CREATE VIEW country_coverage_dashboard AS
SELECT
    country_name,
    goal,
    COUNT(*) AS indicators_expected,
    SUM(CASE WHEN actual_value IS NOT NULL THEN 1 ELSE 0 END) AS indicators_reported,
    AVG(CASE WHEN source_name IS NOT NULL AND source_name <> '' THEN 1.0 ELSE 0.0 END) AS source_completeness_rate,
    AVG(CASE WHEN metadata_version IS NOT NULL AND metadata_version <> '' THEN 1.0 ELSE 0.0 END) AS metadata_completeness_rate
FROM development_indicator_registry
GROUP BY country_name, goal;
