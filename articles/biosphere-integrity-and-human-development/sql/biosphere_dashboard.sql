CREATE VIEW biosphere_stress_dashboard AS
SELECT
    territory_name,
    AVG(ecosystem_degradation_index) AS avg_ecosystem_degradation,
    AVG(fragmentation_risk_index) AS avg_fragmentation_risk,
    AVG(ecological_service_erosion_index) AS avg_ecological_service_erosion
FROM biosphere_risk_registry
GROUP BY territory_name;

CREATE VIEW biosphere_governance_dashboard AS
SELECT
    territory_name,
    AVG(biosphere_function_loss_index) AS avg_biosphere_function_loss,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(restoration_readiness_index) AS avg_restoration_readiness
FROM biosphere_governance_log
GROUP BY territory_name;

CREATE VIEW biosphere_burden_dashboard AS
SELECT
    territory_name,
    AVG(food_water_health_dependence_index) AS avg_food_water_health_dependence,
    AVG(livelihood_ecological_dependence_index) AS avg_livelihood_ecological_dependence,
    AVG(justice_exposure_index) AS avg_justice_exposure
FROM biosphere_burden_log
GROUP BY territory_name;
