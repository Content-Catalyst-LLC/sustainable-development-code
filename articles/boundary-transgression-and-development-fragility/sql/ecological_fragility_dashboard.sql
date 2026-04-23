CREATE VIEW ecological_fragility_dashboard AS
SELECT
    country_name,
    region_name,
    year,
    (
        0.25 * climate_pressure_index +
        0.20 * freshwater_pressure_index +
        0.20 * biosphere_pressure_index +
        0.20 * land_system_pressure_index +
        0.15 * nutrient_pressure_index
    ) AS boundary_pressure_score,
    (
        0.35 * adaptive_capacity_index +
        0.25 * institutional_capacity_index +
        0.20 * infrastructure_resilience_index +
        0.20 * equity_protection_index
    ) AS capacity_score,
    (
        0.70 * (
            0.25 * climate_pressure_index +
            0.20 * freshwater_pressure_index +
            0.20 * biosphere_pressure_index +
            0.20 * land_system_pressure_index +
            0.15 * nutrient_pressure_index
        ) -
        0.50 * (
            0.35 * adaptive_capacity_index +
            0.25 * institutional_capacity_index +
            0.20 * infrastructure_resilience_index +
            0.20 * equity_protection_index
        )
    ) AS ecological_fragility_score
FROM ecological_pressure_registry;

SELECT
    country_name,
    region_name,
    year,
    boundary_pressure_score,
    capacity_score,
    ecological_fragility_score
FROM ecological_fragility_dashboard
ORDER BY ecological_fragility_score DESC, boundary_pressure_score DESC;
