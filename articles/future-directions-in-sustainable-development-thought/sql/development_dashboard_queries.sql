-- Scenario viability dashboard.
SELECT
    scenario,
    ROUND(
        0.16 * income_index +
        0.22 * ecological_integrity_index +
        0.18 * resilience_index +
        0.16 * governance_capacity_index +
        0.13 * technology_capability_index +
        0.15 * justice_equity_index,
        4
    ) AS viability_score,
    planetary_pressure_index,
    institutional_stress_index,
    CASE
        WHEN planetary_pressure_index >= 0.65 OR institutional_stress_index >= 0.70 THEN 'threshold_review'
        WHEN (
            0.16 * income_index +
            0.22 * ecological_integrity_index +
            0.18 * resilience_index +
            0.16 * governance_capacity_index +
            0.13 * technology_capability_index +
            0.15 * justice_equity_index
        ) < 0.55 THEN 'high_concern'
        ELSE 'monitor'
    END AS review_status
FROM scenario_scores
ORDER BY viability_score DESC;

-- Longitudinal country viability summary.
SELECT
    country,
    MIN(year) AS first_year,
    MAX(year) AS latest_year,
    ROUND(AVG(
        0.16 * income_index +
        0.22 * ecological_integrity_index +
        0.18 * resilience_index +
        0.16 * governance_capacity_index +
        0.13 * technology_capability_index +
        0.15 * justice_equity_index
    ), 4) AS avg_viability_score,
    ROUND(AVG(planetary_pressure_index), 4) AS avg_planetary_pressure,
    ROUND(AVG(institutional_stress_index), 4) AS avg_institutional_stress
FROM development_panel
GROUP BY country
ORDER BY avg_viability_score DESC;
