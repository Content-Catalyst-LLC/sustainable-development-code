CREATE VIEW climate_stress_dashboard AS
SELECT
    territory_name,
    AVG(heat_stress_index) AS avg_heat_stress,
    AVG(hydrological_disruption_index) AS avg_hydrological_disruption,
    AVG(disaster_recurrence_index) AS avg_disaster_recurrence
FROM climate_risk_registry
GROUP BY territory_name;

CREATE VIEW climate_governance_dashboard AS
SELECT
    territory_name,
    AVG(infrastructure_vulnerability_index) AS avg_infrastructure_vulnerability,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(resilience_readiness_index) AS avg_resilience_readiness
FROM climate_governance_log
GROUP BY territory_name;

CREATE VIEW climate_burden_dashboard AS
SELECT
    territory_name,
    AVG(food_livelihood_exposure_index) AS avg_food_livelihood_exposure,
    AVG(health_burden_index) AS avg_health_burden,
    AVG(justice_exposure_index) AS avg_justice_exposure
FROM climate_burden_log
GROUP BY territory_name;
