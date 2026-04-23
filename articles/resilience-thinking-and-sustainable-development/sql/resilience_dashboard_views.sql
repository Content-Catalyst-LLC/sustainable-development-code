CREATE VIEW resilience_dashboard AS
SELECT
    system_name,
    region_name,
    year,
    disturbance_exposure_index,
    (
        0.20 * coping_capacity_index +
        0.20 * adaptive_capacity_index +
        0.20 * transformative_capacity_index +
        0.15 * institutional_learning_index +
        0.15 * ecological_buffer_index +
        0.10 * equity_protection_index
    ) AS resilience_capacity_score,
    (
        0.65 * disturbance_exposure_index -
        0.35 * (
            0.20 * coping_capacity_index +
            0.20 * adaptive_capacity_index +
            0.20 * transformative_capacity_index +
            0.15 * institutional_learning_index +
            0.15 * ecological_buffer_index +
            0.10 * equity_protection_index
        )
    ) AS brittleness_score
FROM resilience_registry;

SELECT
    system_name,
    region_name,
    year,
    disturbance_exposure_index,
    resilience_capacity_score,
    brittleness_score
FROM resilience_dashboard
ORDER BY resilience_capacity_score DESC, brittleness_score ASC;
