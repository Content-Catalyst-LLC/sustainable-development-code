CREATE TABLE transport_route_registry (
    route_id VARCHAR(100) PRIMARY KEY,
    city_region VARCHAR(255) NOT NULL,
    mode_type VARCHAR(100) NOT NULL,
    service_frequency_index DECIMAL(5,4),
    route_coverage_index DECIMAL(5,4),
    accessibility_compliance_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE stop_and_station_registry (
    stop_id VARCHAR(100) PRIMARY KEY,
    city_region VARCHAR(255) NOT NULL,
    stop_type VARCHAR(100) NOT NULL,
    disability_access_index DECIMAL(5,4),
    safety_index DECIMAL(5,4),
    lighting_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE fare_and_affordability_log (
    fare_id INTEGER PRIMARY KEY,
    city_region VARCHAR(255) NOT NULL,
    mode_type VARCHAR(100) NOT NULL,
    fare_affordability_index DECIMAL(5,4),
    transfer_penalty_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE service_reliability_log (
    service_event_id INTEGER PRIMARY KEY,
    city_region VARCHAR(255) NOT NULL,
    mode_type VARCHAR(100) NOT NULL,
    on_time_performance_index DECIMAL(5,4),
    uptime_index DECIMAL(5,4),
    crowding_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
