CREATE TABLE sustainable_development_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    present_deprivation_index DECIMAL(5,4),
    human_wellbeing_support_index DECIMAL(5,4),
    ecological_stress_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE sustainable_development_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    future_burden_transfer_index DECIMAL(5,4),
    institutional_durability_index DECIMAL(5,4),
    systems_interdependence_risk_index DECIMAL(5,4),
    long_run_viability_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    planetary_constraint_exposure_index DECIMAL(5,4),
    development_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE sustainable_development_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    present_deprivation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
