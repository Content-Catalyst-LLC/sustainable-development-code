CREATE TABLE fragility_registry (
    registry_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    year INTEGER NOT NULL,
    shock_exposure_index DECIMAL(5,4) NOT NULL,
    climate_risk_index DECIMAL(5,4) NOT NULL,
    food_system_stress_index DECIMAL(5,4) NOT NULL,
    institutional_capacity_index DECIMAL(5,4) NOT NULL,
    infrastructure_resilience_index DECIMAL(5,4) NOT NULL,
    social_protection_index DECIMAL(5,4) NOT NULL,
    inequality_burden_index DECIMAL(5,4) NOT NULL,
    fiscal_space_index DECIMAL(5,4) NOT NULL
);
