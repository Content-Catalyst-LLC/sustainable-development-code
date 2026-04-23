CREATE TABLE coastal_ocean_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    coastal_system_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    coastal_type VARCHAR(100) NOT NULL,
    acidification_pressure_index DECIMAL(5,4),
    warming_pressure_index DECIMAL(5,4),
    deoxygenation_pressure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE coastal_dependence_log (
    dependence_id INTEGER PRIMARY KEY,
    coastal_system_name VARCHAR(255) NOT NULL,
    marine_dependence_index DECIMAL(5,4),
    fisheries_livelihood_dependence_index DECIMAL(5,4),
    coastal_infrastructure_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE coastal_governance_log (
    governance_id INTEGER PRIMARY KEY,
    coastal_system_name VARCHAR(255) NOT NULL,
    governance_capacity_index DECIMAL(5,4),
    monitoring_readiness_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
