CREATE TABLE nutrient_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    nitrogen_surplus_index DECIMAL(5,4),
    phosphorus_surplus_index DECIMAL(5,4),
    runoff_leakage_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE nutrient_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    eutrophication_exposure_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    monitoring_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE nutrient_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    soil_balance_stress_index DECIMAL(5,4),
    food_system_dependence_index DECIMAL(5,4),
    water_quality_burden_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
