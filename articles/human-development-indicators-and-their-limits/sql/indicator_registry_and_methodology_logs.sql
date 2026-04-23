CREATE TABLE indicator_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    hdi_attainment_index DECIMAL(5,4),
    inequality_penalty_index DECIMAL(5,4),
    gender_gap_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE indicator_methodology_log (
    methodology_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    multidimensional_poverty_index DECIMAL(5,4),
    subnational_variation_index DECIMAL(5,4),
    data_quality_confidence_index DECIMAL(5,4),
    indicator_coverage_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE indicator_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    security_exclusion_index DECIMAL(5,4),
    planetary_pressure_penalty_index DECIMAL(5,4),
    hdi_attainment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
