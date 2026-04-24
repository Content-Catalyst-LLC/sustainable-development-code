CREATE TABLE safe_operating_space_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    climate_boundary_pressure_index DECIMAL(5,4),
    biosphere_boundary_pressure_index DECIMAL(5,4),
    land_system_pressure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE safe_operating_space_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    freshwater_pressure_index DECIMAL(5,4),
    biogeochemical_pressure_index DECIMAL(5,4),
    novel_entities_pressure_index DECIMAL(5,4),
    ocean_acidification_pressure_index DECIMAL(5,4),
    resilience_loss_index DECIMAL(5,4),
    governability_strain_index DECIMAL(5,4),
    adaptation_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE safe_operating_space_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    justice_exposure_index DECIMAL(5,4),
    adaptation_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
