CREATE TABLE inclusion_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    education_access_index DECIMAL(5,4),
    health_access_index DECIMAL(5,4),
    income_security_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE inclusion_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    public_goods_access_index DECIMAL(5,4),
    opportunity_blockage_index DECIMAL(5,4),
    institutional_capture_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE inclusion_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    risk_exposure_index DECIMAL(5,4),
    inclusive_transition_readiness_index DECIMAL(5,4),
    income_security_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
