CREATE VIEW coastal_habitability_dashboard AS
SELECT
    coastal_system_name,
    AVG(acidification_pressure_index) AS avg_acidification_pressure,
    AVG(warming_pressure_index) AS avg_warming_pressure,
    AVG(deoxygenation_pressure_index) AS avg_deoxygenation_pressure
FROM coastal_ocean_risk_registry
GROUP BY coastal_system_name;

CREATE VIEW coastal_dependence_dashboard AS
SELECT
    coastal_system_name,
    AVG(marine_dependence_index) AS avg_marine_dependence,
    AVG(fisheries_livelihood_dependence_index) AS avg_fisheries_dependence,
    AVG(coastal_infrastructure_exposure_index) AS avg_infrastructure_exposure
FROM coastal_dependence_log
GROUP BY coastal_system_name;

CREATE VIEW coastal_governance_dashboard AS
SELECT
    coastal_system_name,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(monitoring_readiness_index) AS avg_monitoring_readiness,
    AVG(justice_exposure_index) AS avg_justice_exposure
FROM coastal_governance_log
GROUP BY coastal_system_name;
