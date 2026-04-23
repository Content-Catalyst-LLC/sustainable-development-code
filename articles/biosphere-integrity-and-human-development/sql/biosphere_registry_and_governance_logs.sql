CREATE TABLE biosphere_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    ecosystem_degradation_index DECIMAL(5,4),
    fragmentation_risk_index DECIMAL(5,4),
    ecological_service_erosion_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE biosphere_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    biosphere_function_loss_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    restoration_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE biosphere_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    food_water_health_dependence_index DECIMAL(5,4),
    livelihood_ecological_dependence_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
