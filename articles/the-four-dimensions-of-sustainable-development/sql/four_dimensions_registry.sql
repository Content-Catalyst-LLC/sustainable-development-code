CREATE TABLE four_dimensions_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    economic_prosperity_index DECIMAL(5,4),
    social_inclusion_index DECIMAL(5,4),
    environmental_sustainability_index DECIMAL(5,4),
    good_governance_index DECIMAL(5,4),
    inequality_pressure_index DECIMAL(5,4),
    ecological_stress_index DECIMAL(5,4),
    institutional_failure_index DECIMAL(5,4),
    long_run_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
