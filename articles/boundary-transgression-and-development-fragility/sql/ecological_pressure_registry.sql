CREATE TABLE ecological_pressure_registry (
    registry_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    year INTEGER NOT NULL,
    climate_pressure_index DECIMAL(5,4) NOT NULL,
    freshwater_pressure_index DECIMAL(5,4) NOT NULL,
    biosphere_pressure_index DECIMAL(5,4) NOT NULL,
    land_system_pressure_index DECIMAL(5,4) NOT NULL,
    nutrient_pressure_index DECIMAL(5,4) NOT NULL,
    adaptive_capacity_index DECIMAL(5,4) NOT NULL,
    infrastructure_resilience_index DECIMAL(5,4) NOT NULL,
    equity_protection_index DECIMAL(5,4) NOT NULL,
    institutional_capacity_index DECIMAL(5,4) NOT NULL
);
