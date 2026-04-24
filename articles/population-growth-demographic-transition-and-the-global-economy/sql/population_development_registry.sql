CREATE TABLE population_development_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    youth_dependency_index DECIMAL(5,4),
    old_age_dependency_index DECIMAL(5,4),
    working_age_share_index DECIMAL(5,4),
    labor_absorption_capacity_index DECIMAL(5,4),
    urbanization_pressure_index DECIMAL(5,4),
    ecological_throughput_pressure_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
