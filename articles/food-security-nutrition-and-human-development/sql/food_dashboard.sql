CREATE VIEW food_access_dashboard AS
SELECT
    territory_name,
    AVG(food_access_index) AS avg_food_access,
    AVG(healthy_diet_affordability_stress_index) AS avg_healthy_diet_affordability_stress,
    AVG(nutrition_quality_index) AS avg_nutrition_quality
FROM food_risk_registry
GROUP BY territory_name;

CREATE VIEW food_governance_dashboard AS
SELECT
    territory_name,
    AVG(price_volatility_index) AS avg_price_volatility,
    AVG(food_system_fragility_index) AS avg_food_system_fragility,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(nutrition_transition_readiness_index) AS avg_nutrition_transition_readiness
FROM food_governance_log
GROUP BY territory_name;

CREATE VIEW food_burden_dashboard AS
SELECT
    territory_name,
    AVG(child_maternal_risk_index) AS avg_child_maternal_risk,
    AVG(poverty_exposure_index) AS avg_poverty_exposure,
    AVG(healthy_diet_affordability_stress_index) AS avg_healthy_diet_affordability_stress
FROM food_burden_log
GROUP BY territory_name;
