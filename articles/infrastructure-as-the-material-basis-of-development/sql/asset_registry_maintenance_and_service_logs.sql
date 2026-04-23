CREATE TABLE infrastructure_asset_registry (
    asset_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    infrastructure_domain VARCHAR(100) NOT NULL,
    service_area_type VARCHAR(100) NOT NULL,
    access_index DECIMAL(5,4),
    reliability_index DECIMAL(5,4),
    climate_resilience_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE maintenance_log (
    maintenance_id INTEGER PRIMARY KEY,
    asset_id VARCHAR(100) NOT NULL,
    maintenance_status VARCHAR(100) NOT NULL,
    maintenance_capacity_index DECIMAL(5,4),
    inspection_quality_index DECIMAL(5,4),
    downtime_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE service_outage_log (
    outage_id INTEGER PRIMARY KEY,
    asset_id VARCHAR(100) NOT NULL,
    outage_duration_index DECIMAL(5,4),
    population_impact_index DECIMAL(5,4),
    recovery_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
