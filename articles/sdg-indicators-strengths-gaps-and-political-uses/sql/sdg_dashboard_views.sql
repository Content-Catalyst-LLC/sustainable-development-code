CREATE VIEW sdg_goal_dashboard AS
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
FROM sdg_indicator_registry
GROUP BY country_name, goal;

SELECT
    country_name,
    goal,
    indicators_reported,
    avg_distance_to_target
FROM sdg_goal_dashboard
ORDER BY country_name, avg_distance_to_target ASC;
