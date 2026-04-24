CREATE TABLE systems_problem_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    interdependence_intensity_index DECIMAL(5,4),
    feedback_risk_index DECIMAL(5,4),
    delay_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE systems_problem_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    path_dependence_index DECIMAL(5,4),
    cross_scale_pressure_index DECIMAL(5,4),
    earth_system_stress_index DECIMAL(5,4),
    governance_fragmentation_index DECIMAL(5,4),
    coordination_capacity_index DECIMAL(5,4),
    institutional_integration_index DECIMAL(5,4),
    leverage_point_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE systems_problem_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    interdependence_intensity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
