CREATE TABLE intergenerational_justice_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    future_burden_transfer_index DECIMAL(5,4),
    ecological_degradation_index DECIMAL(5,4),
    institutional_erosion_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE intergenerational_stewardship_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    public_debt_lock_in_index DECIMAL(5,4),
    infrastructure_lock_in_index DECIMAL(5,4),
    climate_risk_transfer_index DECIMAL(5,4),
    future_representation_gap_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    precautionary_planning_index DECIMAL(5,4),
    resilience_preservation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE intergenerational_justice_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    justice_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
