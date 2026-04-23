CREATE TABLE work_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    employment_access_index DECIMAL(5,4),
    informality_risk_index DECIMAL(5,4),
    precarity_risk_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE work_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    income_security_index DECIMAL(5,4),
    social_protection_coverage_index DECIMAL(5,4),
    labour_rights_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE work_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    youth_exclusion_index DECIMAL(5,4),
    gender_livelihood_gap_index DECIMAL(5,4),
    transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
