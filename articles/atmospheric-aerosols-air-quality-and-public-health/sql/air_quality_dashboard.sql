CREATE VIEW aerosol_exposure_dashboard AS
SELECT
    territory_name,
    AVG(ambient_pm25_index) AS avg_pm25,
    AVG(ambient_pm10_index) AS avg_pm10,
    AVG(household_energy_exposure_index) AS avg_household_exposure
FROM aerosol_burden_registry
GROUP BY territory_name;

CREATE VIEW aerosol_source_dashboard AS
SELECT
    territory_name,
    AVG(transport_emissions_pressure_index) AS avg_transport_pressure,
    AVG(industrial_source_pressure_index) AS avg_industrial_pressure,
    AVG(mitigation_capacity_index) AS avg_mitigation_capacity
FROM aerosol_source_log
GROUP BY territory_name;

CREATE VIEW aerosol_equity_dashboard AS
SELECT
    territory_name,
    AVG(exposure_inequality_index) AS avg_exposure_inequality,
    AVG(monitoring_readiness_index) AS avg_monitoring_readiness,
    AVG(health_sensitivity_index) AS avg_health_sensitivity
FROM aerosol_equity_log
GROUP BY territory_name;
