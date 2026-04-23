CREATE VIEW urban_housing_dashboard AS
SELECT
    territory_name,
    AVG(housing_adequacy_index) AS avg_housing_adequacy,
    AVG(housing_affordability_stress_index) AS avg_housing_affordability_stress,
    AVG(basic_services_access_index) AS avg_basic_services_access
FROM urban_risk_registry
GROUP BY territory_name;

CREATE VIEW urban_governance_dashboard AS
SELECT
    territory_name,
    AVG(informality_exclusion_index) AS avg_informality_exclusion,
    AVG(resilience_weakness_index) AS avg_resilience_weakness,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(urban_transition_readiness_index) AS avg_urban_transition_readiness
FROM urban_governance_log
GROUP BY territory_name;

CREATE VIEW urban_exposure_dashboard AS
SELECT
    territory_name,
    AVG(mobility_access_index) AS avg_mobility_access,
    AVG(justice_exposure_index) AS avg_justice_exposure,
    AVG(housing_affordability_stress_index) AS avg_housing_affordability_stress
FROM urban_burden_log
GROUP BY territory_name;
