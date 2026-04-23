CREATE VIEW land_conversion_dashboard AS
SELECT
    territory_name,
    AVG(conversion_pressure_index) AS avg_conversion_pressure,
    AVG(land_degradation_index) AS avg_land_degradation,
    AVG(fragmentation_risk_index) AS avg_fragmentation_risk
FROM land_pathway_risk_registry
GROUP BY territory_name;

CREATE VIEW land_governance_dashboard AS
SELECT
    territory_name,
    AVG(biodiversity_function_loss_index) AS avg_biodiversity_function_loss,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(restoration_readiness_index) AS avg_restoration_readiness
FROM land_governance_log
GROUP BY territory_name;

CREATE VIEW land_burden_dashboard AS
SELECT
    territory_name,
    AVG(food_settlement_dependence_index) AS avg_food_settlement_dependence,
    AVG(justice_exposure_index) AS avg_justice_exposure,
    AVG(infrastructure_expansion_pressure_index) AS avg_infrastructure_expansion_pressure
FROM land_burden_log
GROUP BY territory_name;
