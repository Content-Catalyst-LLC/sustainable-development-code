CREATE TABLE gender_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    education_access_index DECIMAL(5,4),
    health_autonomy_index DECIMAL(5,4),
    economic_participation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE gender_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    care_burden_index DECIMAL(5,4),
    violence_exposure_index DECIMAL(5,4),
    institutional_power_gap_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE gender_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    property_rights_gap_index DECIMAL(5,4),
    gender_transition_readiness_index DECIMAL(5,4),
    economic_participation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
