CREATE TABLE pollution_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    hazardous_material_throughput_index DECIMAL(5,4),
    waste_system_overload_index DECIMAL(5,4),
    persistence_mobility_risk_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE pollution_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    assessment_lag_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    remediation_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE pollution_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    exposure_inequality_index DECIMAL(5,4),
    ecosystem_toxicity_index DECIMAL(5,4),
    public_health_burden_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
