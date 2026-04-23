CREATE VIEW nutrient_surplus_dashboard AS
SELECT
    territory_name,
    AVG(nitrogen_surplus_index) AS avg_nitrogen_surplus,
    AVG(phosphorus_surplus_index) AS avg_phosphorus_surplus,
    AVG(runoff_leakage_index) AS avg_runoff_leakage
FROM nutrient_risk_registry
GROUP BY territory_name;

CREATE VIEW nutrient_governance_dashboard AS
SELECT
    territory_name,
    AVG(eutrophication_exposure_index) AS avg_eutrophication_exposure,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(monitoring_readiness_index) AS avg_monitoring_readiness
FROM nutrient_governance_log
GROUP BY territory_name;

CREATE VIEW nutrient_burden_dashboard AS
SELECT
    territory_name,
    AVG(soil_balance_stress_index) AS avg_soil_balance_stress,
    AVG(food_system_dependence_index) AS avg_food_system_dependence,
    AVG(water_quality_burden_index) AS avg_water_quality_burden
FROM nutrient_burden_log
GROUP BY territory_name;
