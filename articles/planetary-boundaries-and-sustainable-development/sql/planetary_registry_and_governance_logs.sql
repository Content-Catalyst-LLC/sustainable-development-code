CREATE TABLE planetary_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    climate_stress_index DECIMAL(5,4),
    biosphere_integrity_loss_index DECIMAL(5,4),
    freshwater_change_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE planetary_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    land_system_change_index DECIMAL(5,4),
    biogeochemical_pressure_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE planetary_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    novel_entities_burden_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    biosphere_integrity_loss_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
