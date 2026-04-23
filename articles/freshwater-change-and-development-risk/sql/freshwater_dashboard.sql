CREATE VIEW freshwater_stress_dashboard AS
SELECT
    territory_name,
    AVG(streamflow_stress_index) AS avg_streamflow_stress,
    AVG(soil_moisture_stress_index) AS avg_soil_moisture_stress,
    AVG(water_quality_burden_index) AS avg_water_quality_burden
FROM freshwater_risk_registry
GROUP BY territory_name;

CREATE VIEW freshwater_governance_dashboard AS
SELECT
    territory_name,
    AVG(wastewater_treatment_deficit_index) AS avg_wastewater_treatment_deficit,
    AVG(freshwater_ecosystem_decline_index) AS avg_freshwater_ecosystem_decline,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(monitoring_readiness_index) AS avg_monitoring_readiness
FROM freshwater_governance_log
GROUP BY territory_name;

CREATE VIEW freshwater_burden_dashboard AS
SELECT
    territory_name,
    AVG(food_livelihood_dependence_index) AS avg_food_livelihood_dependence,
    AVG(health_sanitation_exposure_index) AS avg_health_sanitation_exposure,
    AVG(water_quality_burden_index) AS avg_water_quality_burden
FROM freshwater_burden_log
GROUP BY territory_name;
