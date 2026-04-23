CREATE TABLE urban_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    housing_adequacy_index DECIMAL(5,4),
    housing_affordability_stress_index DECIMAL(5,4),
    basic_services_access_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE urban_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    informality_exclusion_index DECIMAL(5,4),
    resilience_weakness_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    urban_transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE urban_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    mobility_access_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    housing_affordability_stress_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
