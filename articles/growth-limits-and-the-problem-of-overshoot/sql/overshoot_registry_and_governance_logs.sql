CREATE TABLE overshoot_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    growth_pressure_index DECIMAL(5,4),
    throughput_pressure_index DECIMAL(5,4),
    resource_depletion_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE overshoot_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    waste_absorptive_stress_index DECIMAL(5,4),
    planetary_pressure_index DECIMAL(5,4),
    delay_recognition_risk_index DECIMAL(5,4),
    infrastructure_lockin_index DECIMAL(5,4),
    governance_fragility_index DECIMAL(5,4),
    adaptive_capacity_index DECIMAL(5,4),
    welfare_conversion_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE overshoot_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    growth_pressure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
