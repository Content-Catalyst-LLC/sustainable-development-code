DROP TABLE IF EXISTS land_system_indicators;

CREATE TABLE land_system_indicators (
    territory_id INTEGER PRIMARY KEY,
    territory_name TEXT NOT NULL,
    country_or_region TEXT NOT NULL,
    territory_type TEXT NOT NULL,
    conversion_pressure_index REAL NOT NULL CHECK (conversion_pressure_index BETWEEN 0 AND 1),
    land_degradation_index REAL NOT NULL CHECK (land_degradation_index BETWEEN 0 AND 1),
    fragmentation_risk_index REAL NOT NULL CHECK (fragmentation_risk_index BETWEEN 0 AND 1),
    biodiversity_function_loss_index REAL NOT NULL CHECK (biodiversity_function_loss_index BETWEEN 0 AND 1),
    food_settlement_dependence_index REAL NOT NULL CHECK (food_settlement_dependence_index BETWEEN 0 AND 1),
    infrastructure_expansion_pressure_index REAL NOT NULL CHECK (infrastructure_expansion_pressure_index BETWEEN 0 AND 1),
    justice_exposure_index REAL NOT NULL CHECK (justice_exposure_index BETWEEN 0 AND 1),
    governance_capacity_index REAL NOT NULL CHECK (governance_capacity_index BETWEEN 0 AND 1),
    restoration_readiness_index REAL NOT NULL CHECK (restoration_readiness_index BETWEEN 0 AND 1)
);

INSERT INTO land_system_indicators VALUES
(1, 'Delta Agricultural Zone', 'Region A', 'agricultural_delta', 0.72, 0.61, 0.58, 0.66, 0.88, 0.63, 0.71, 0.42, 0.38),
(2, 'Forest Frontier', 'Region B', 'forest_frontier', 0.84, 0.55, 0.79, 0.82, 0.54, 0.76, 0.68, 0.36, 0.44),
(3, 'Urban Expansion Belt', 'Region C', 'peri_urban', 0.69, 0.48, 0.73, 0.57, 0.77, 0.91, 0.64, 0.51, 0.47),
(4, 'Restoration Corridor', 'Region D', 'restoration_zone', 0.31, 0.43, 0.39, 0.41, 0.49, 0.35, 0.38, 0.72, 0.81),
(5, 'Dryland Livelihood Zone', 'Region E', 'dryland', 0.58, 0.77, 0.52, 0.64, 0.86, 0.41, 0.82, 0.39, 0.46);

DROP VIEW IF EXISTS land_pathway_scores;

CREATE VIEW land_pathway_scores AS
SELECT
    territory_name,
    country_or_region,
    territory_type,
    (
        0.22 * conversion_pressure_index +
        0.22 * land_degradation_index +
        0.18 * fragmentation_risk_index +
        0.18 * biodiversity_function_loss_index +
        0.20 * infrastructure_expansion_pressure_index
    ) AS territorial_stress_score,
    (
        0.55 * food_settlement_dependence_index +
        0.25 * justice_exposure_index +
        0.20 * biodiversity_function_loss_index
    ) AS development_dependence_score,
    (
        0.55 * governance_capacity_index +
        0.45 * restoration_readiness_index
    ) AS governance_readiness_score,
    (
        0.40 * (
            0.22 * conversion_pressure_index +
            0.22 * land_degradation_index +
            0.18 * fragmentation_risk_index +
            0.18 * biodiversity_function_loss_index +
            0.20 * infrastructure_expansion_pressure_index
        ) +
        0.25 * (
            0.55 * food_settlement_dependence_index +
            0.25 * justice_exposure_index +
            0.20 * biodiversity_function_loss_index
        ) +
        0.20 * justice_exposure_index +
        0.15 * (
            1 - (
                0.55 * governance_capacity_index +
                0.45 * restoration_readiness_index
            )
        )
    ) AS constrained_land_pathway_risk_score
FROM land_system_indicators;

SELECT
    territory_name,
    country_or_region,
    territory_type,
    ROUND(territorial_stress_score, 3) AS territorial_stress_score,
    ROUND(development_dependence_score, 3) AS development_dependence_score,
    ROUND(governance_readiness_score, 3) AS governance_readiness_score,
    ROUND(constrained_land_pathway_risk_score, 3) AS constrained_land_pathway_risk_score,
    CASE
        WHEN constrained_land_pathway_risk_score >= 0.80 THEN 'Extreme land-pathway risk'
        WHEN constrained_land_pathway_risk_score >= 0.60 THEN 'High land-pathway risk'
        WHEN constrained_land_pathway_risk_score >= 0.40 THEN 'Moderate land-pathway risk'
        ELSE 'Lower land-pathway risk'
    END AS risk_band
FROM land_pathway_scores
ORDER BY constrained_land_pathway_risk_score DESC;
