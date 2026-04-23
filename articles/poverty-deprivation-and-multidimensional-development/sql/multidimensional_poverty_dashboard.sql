CREATE VIEW multidimensional_poverty_access_dashboard AS
SELECT
    territory_name,
    AVG(income_poverty_index) AS avg_income_poverty,
    AVG(housing_deprivation_index) AS avg_housing_deprivation,
    AVG(sanitation_deprivation_index) AS avg_sanitation_deprivation
FROM multidimensional_poverty_registry
GROUP BY territory_name;

CREATE VIEW multidimensional_poverty_governance_dashboard AS
SELECT
    territory_name,
    AVG(electricity_cooking_fuel_deprivation_index) AS avg_energy_deprivation,
    AVG(nutrition_deprivation_index) AS avg_nutrition_deprivation,
    AVG(learning_deprivation_index) AS avg_learning_deprivation,
    AVG(public_goods_access_index) AS avg_public_goods_access,
    AVG(governance_capacity_index) AS avg_governance_capacity
FROM multidimensional_poverty_governance_log
GROUP BY territory_name;

CREATE VIEW multidimensional_poverty_burden_dashboard AS
SELECT
    territory_name,
    AVG(climate_exposure_index) AS avg_climate_exposure,
    AVG(child_vulnerability_index) AS avg_child_vulnerability,
    AVG(poverty_transition_readiness_index) AS avg_poverty_transition_readiness
FROM multidimensional_poverty_burden_log
GROUP BY territory_name;
