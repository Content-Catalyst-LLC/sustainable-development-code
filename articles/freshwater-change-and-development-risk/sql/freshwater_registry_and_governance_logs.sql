CREATE TABLE freshwater_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    streamflow_stress_index DECIMAL(5,4),
    soil_moisture_stress_index DECIMAL(5,4),
    water_quality_burden_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE freshwater_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    wastewater_treatment_deficit_index DECIMAL(5,4),
    freshwater_ecosystem_decline_index DECIMAL(5,4),
    governance_capacity_index DECIMAL(5,4),
    monitoring_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE freshwater_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    food_livelihood_dependence_index DECIMAL(5,4),
    health_sanitation_exposure_index DECIMAL(5,4),
    water_quality_burden_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
