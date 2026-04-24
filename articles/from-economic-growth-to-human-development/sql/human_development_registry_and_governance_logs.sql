CREATE TABLE human_development_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    output_growth_index DECIMAL(5,4),
    health_capability_index DECIMAL(5,4),
    education_capability_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE human_development_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    income_conversion_index DECIMAL(5,4),
    public_goods_conversion_index DECIMAL(5,4),
    distribution_constraint_index DECIMAL(5,4),
    institutional_support_index DECIMAL(5,4),
    ecological_durability_index DECIMAL(5,4),
    agency_freedom_index DECIMAL(5,4),
    human_development_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE human_development_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    output_growth_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
