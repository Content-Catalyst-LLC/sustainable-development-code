CREATE TABLE planetary_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    climate_forcing_index DECIMAL(5,4),
    biosphere_integrity_stress_index DECIMAL(5,4),
    land_system_change_index DECIMAL(5,4),
    freshwater_change_index DECIMAL(5,4),
    biogeochemical_disruption_index DECIMAL(5,4),
    novel_entities_pressure_index DECIMAL(5,4),
    ocean_acidification_pressure_index DECIMAL(5,4),
    governance_response_capacity_index DECIMAL(5,4),
    sustainable_development_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
