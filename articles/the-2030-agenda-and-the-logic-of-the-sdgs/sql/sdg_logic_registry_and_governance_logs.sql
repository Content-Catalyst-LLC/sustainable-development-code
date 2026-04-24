CREATE TABLE sdg_logic_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    universality_exposure_index DECIMAL(5,4),
    integration_complexity_index DECIMAL(5,4),
    implementation_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE sdg_logic_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    means_of_implementation_index DECIMAL(5,4),
    partnership_readiness_index DECIMAL(5,4),
    monitoring_capacity_index DECIMAL(5,4),
    indicator_coverage_index DECIMAL(5,4),
    review_responsiveness_index DECIMAL(5,4),
    policy_fragmentation_index DECIMAL(5,4),
    sdg_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE sdg_logic_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    integration_complexity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
