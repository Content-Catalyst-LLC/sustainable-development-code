CREATE TABLE food_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    food_access_index DECIMAL(5,4),
    healthy_diet_affordability_stress_index DECIMAL(5,4),
    nutrition_quality_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE food_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    price_volatility_index DECIMAL(5,4),
    food_system_fragility_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    nutrition_transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE food_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    child_maternal_risk_index DECIMAL(5,4),
    poverty_exposure_index DECIMAL(5,4),
    healthy_diet_affordability_stress_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
