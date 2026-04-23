CREATE TABLE territorial_governance_registry (
    governance_id VARCHAR(100) PRIMARY KEY,
    city_or_region VARCHAR(255) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    service_reach_index DECIMAL(5,4),
    land_housing_coordination_index DECIMAL(5,4),
    spatial_justice_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE territorial_infrastructure_log (
    infra_id INTEGER PRIMARY KEY,
    city_or_region VARCHAR(255) NOT NULL,
    infrastructure_mobility_integration_index DECIMAL(5,4),
    resilience_capacity_index DECIMAL(5,4),
    multilevel_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE territorial_risk_log (
    risk_id INTEGER PRIMARY KEY,
    city_or_region VARCHAR(255) NOT NULL,
    fragmentation_risk_index DECIMAL(5,4),
    informality_pressure_index DECIMAL(5,4),
    hazard_exposure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
