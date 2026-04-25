DROP TABLE IF EXISTS freshwater_indicators;

CREATE TABLE freshwater_indicators (
    territory_id INTEGER PRIMARY KEY,
    territory_name TEXT NOT NULL,
    country_or_region TEXT NOT NULL,
    territory_type TEXT NOT NULL,
    streamflow_stress_index REAL NOT NULL CHECK (streamflow_stress_index BETWEEN 0 AND 1),
    soil_moisture_stress_index REAL NOT NULL CHECK (soil_moisture_stress_index BETWEEN 0 AND 1),
    water_quality_burden_index REAL NOT NULL CHECK (water_quality_burden_index BETWEEN 0 AND 1),
    wastewater_treatment_deficit_index REAL NOT NULL CHECK (wastewater_treatment_deficit_index BETWEEN 0 AND 1),
    freshwater_ecosystem_decline_index REAL NOT NULL CHECK (freshwater_ecosystem_decline_index BETWEEN 0 AND 1),
    food_livelihood_dependence_index REAL NOT NULL CHECK (food_livelihood_dependence_index BETWEEN 0 AND 1),
    health_sanitation_exposure_index REAL NOT NULL CHECK (health_sanitation_exposure_index BETWEEN 0 AND 1),
    governance_capacity_index REAL NOT NULL CHECK (governance_capacity_index BETWEEN 0 AND 1),
    monitoring_readiness_index REAL NOT NULL CHECK (monitoring_readiness_index BETWEEN 0 AND 1)
);

INSERT INTO freshwater_indicators VALUES
(1, 'Mountain Watershed', 'Region A', 'mountain_watershed', 0.58, 0.49, 0.42, 0.36, 0.61, 0.72, 0.48, 0.57, 0.53),
(2, 'Dryland Agricultural Basin', 'Region B', 'dryland_basin', 0.81, 0.78, 0.63, 0.55, 0.69, 0.88, 0.72, 0.41, 0.39),
(3, 'Urban River Corridor', 'Region C', 'urban_river', 0.64, 0.46, 0.82, 0.76, 0.71, 0.52, 0.84, 0.48, 0.46),
(4, 'Wetland Restoration Zone', 'Region D', 'wetland_restoration', 0.35, 0.38, 0.44, 0.31, 0.39, 0.46, 0.37, 0.72, 0.76),
(5, 'Coastal Delta Settlement', 'Region E', 'coastal_delta', 0.73, 0.62, 0.77, 0.68, 0.74, 0.79, 0.81, 0.44, 0.42);

DROP VIEW IF EXISTS freshwater_risk_scores;

CREATE VIEW freshwater_risk_scores AS
SELECT
    territory_name,
    country_or_region,
    territory_type,
    (
        0.22 * streamflow_stress_index +
        0.20 * soil_moisture_stress_index +
        0.18 * water_quality_burden_index +
        0.20 * wastewater_treatment_deficit_index +
        0.20 * freshwater_ecosystem_decline_index
    ) AS hydrological_stress_score,
    (
        0.45 * food_livelihood_dependence_index +
        0.35 * health_sanitation_exposure_index +
        0.20 * water_quality_burden_index
    ) AS development_exposure_score,
    (
        0.55 * governance_capacity_index +
        0.45 * monitoring_readiness_index
    ) AS governance_readiness_score,
    (
        0.42 * (
            0.22 * streamflow_stress_index +
            0.20 * soil_moisture_stress_index +
            0.18 * water_quality_burden_index +
            0.20 * wastewater_treatment_deficit_index +
            0.20 * freshwater_ecosystem_decline_index
        ) +
        0.28 * (
            0.45 * food_livelihood_dependence_index +
            0.35 * health_sanitation_exposure_index +
            0.20 * water_quality_burden_index
        ) +
        0.15 * health_sanitation_exposure_index +
        0.15 * (
            1 - (
                0.55 * governance_capacity_index +
                0.45 * monitoring_readiness_index
            )
        )
    ) AS constrained_freshwater_risk_score
FROM freshwater_indicators;

SELECT
    territory_name,
    country_or_region,
    territory_type,
    ROUND(hydrological_stress_score, 3) AS hydrological_stress_score,
    ROUND(development_exposure_score, 3) AS development_exposure_score,
    ROUND(governance_readiness_score, 3) AS governance_readiness_score,
    ROUND(constrained_freshwater_risk_score, 3) AS constrained_freshwater_risk_score,
    CASE
        WHEN constrained_freshwater_risk_score >= 0.80 THEN 'Extreme freshwater-development risk'
        WHEN constrained_freshwater_risk_score >= 0.60 THEN 'High freshwater-development risk'
        WHEN constrained_freshwater_risk_score >= 0.40 THEN 'Moderate freshwater-development risk'
        ELSE 'Lower freshwater-development risk'
    END AS risk_band
FROM freshwater_risk_scores
ORDER BY constrained_freshwater_risk_score DESC;
