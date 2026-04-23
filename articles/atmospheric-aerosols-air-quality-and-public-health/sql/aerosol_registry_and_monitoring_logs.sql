CREATE TABLE aerosol_burden_registry (
    aerosol_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    ambient_pm25_index DECIMAL(5,4),
    ambient_pm10_index DECIMAL(5,4),
    household_energy_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE aerosol_source_log (
    source_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    transport_emissions_pressure_index DECIMAL(5,4),
    industrial_source_pressure_index DECIMAL(5,4),
    mitigation_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE aerosol_equity_log (
    risk_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    exposure_inequality_index DECIMAL(5,4),
    monitoring_readiness_index DECIMAL(5,4),
    health_sensitivity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
