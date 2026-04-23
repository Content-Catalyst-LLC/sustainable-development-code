CREATE TABLE capability_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    health_access_index DECIMAL(5,4),
    education_access_index DECIMAL(5,4),
    service_quality_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE capability_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    financial_hardship_risk_index DECIMAL(5,4),
    learning_deprivation_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    capability_transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE capability_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    life_course_vulnerability_index DECIMAL(5,4),
    inequality_exclusion_index DECIMAL(5,4),
    service_quality_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
