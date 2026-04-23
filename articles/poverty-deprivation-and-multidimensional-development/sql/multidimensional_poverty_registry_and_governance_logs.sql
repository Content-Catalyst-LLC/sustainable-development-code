CREATE TABLE multidimensional_poverty_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    income_poverty_index DECIMAL(5,4),
    housing_deprivation_index DECIMAL(5,4),
    sanitation_deprivation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE multidimensional_poverty_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    electricity_cooking_fuel_deprivation_index DECIMAL(5,4),
    nutrition_deprivation_index DECIMAL(5,4),
    learning_deprivation_index DECIMAL(5,4),
    public_goods_access_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE multidimensional_poverty_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    climate_exposure_index DECIMAL(5,4),
    child_vulnerability_index DECIMAL(5,4),
    poverty_transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
