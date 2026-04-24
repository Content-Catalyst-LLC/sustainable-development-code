CREATE TABLE development_indicator_registry (
    record_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    gdp_growth_index DECIMAL(10,4),
    health_capability_index DECIMAL(10,4),
    education_capability_index DECIMAL(10,4),
    institutional_quality_index DECIMAL(10,4),
    ecological_stability_index DECIMAL(10,4),
    inequality_pressure_index DECIMAL(10,4),
    reporting_year INTEGER NOT NULL
);
