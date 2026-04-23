CREATE TABLE threshold_risk_registry (
    threshold_id VARCHAR(100) PRIMARY KEY,
    system_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    ecosystem_type VARCHAR(255) NOT NULL,
    cumulative_pressure_index DECIMAL(5,4),
    slow_variable_deterioration_index DECIMAL(5,4),
    feedback_intensity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE resilience_monitoring_log (
    monitoring_id INTEGER PRIMARY KEY,
    system_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    resilience_buffer_index DECIMAL(5,4),
    monitoring_readiness_index DECIMAL(5,4),
    precaution_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE cascade_justice_log (
    risk_id INTEGER PRIMARY KEY,
    system_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    cascade_exposure_index DECIMAL(5,4),
    justice_exposure_index DECIMAL(5,4),
    recovery_difficulty_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
