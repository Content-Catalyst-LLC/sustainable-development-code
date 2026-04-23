CREATE TABLE land_pathway_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    conversion_pressure_index DECIMAL(5,4),
    land_degradation_index DECIMAL(5,4),
    fragmentation_risk_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE land_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    biodiversity_function_loss_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    restoration_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE land_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    food_settlement_dependence_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    infrastructure_expansion_pressure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
