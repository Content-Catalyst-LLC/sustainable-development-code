CREATE VIEW fragility_dashboard AS
SELECT
    country_name,
    region_name,
    year,
    (
        0.40 * shock_exposure_index +
        0.35 * climate_risk_index +
        0.25 * food_system_stress_index
    ) AS combined_exposure_score,
    (
        0.30 * institutional_capacity_index +
        0.25 * infrastructure_resilience_index +
        0.25 * social_protection_index +
        0.20 * fiscal_space_index
    ) AS combined_resilience_score,
    inequality_burden_index,
    (
        (
            0.60 * (
                0.40 * shock_exposure_index +
                0.35 * climate_risk_index +
                0.25 * food_system_stress_index
            ) +
            0.40 * inequality_burden_index
        ) -
        (
            0.50 * (
                0.30 * institutional_capacity_index +
                0.25 * infrastructure_resilience_index +
                0.25 * social_protection_index +
                0.20 * fiscal_space_index
            )
        )
    ) AS fragility_score
FROM fragility_registry;

SELECT
    country_name,
    region_name,
    year,
    combined_exposure_score,
    combined_resilience_score,
    inequality_burden_index,
    fragility_score
FROM fragility_dashboard
ORDER BY fragility_score DESC, combined_exposure_score DESC;
