CREATE TABLE climate_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    heat_stress_index DECIMAL(5,4),
    hydrological_disruption_index DECIMAL(5,4),
    disaster_recurrence_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE climate_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    infrastructure_vulnerability_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    resilience_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE climate_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    food_livelihood_exposure_index DECIMAL(5,4),
    health_burden_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
