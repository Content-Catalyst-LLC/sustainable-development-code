CREATE TABLE geographic_poverty_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    income_deprivation_index DECIMAL(5,4),
    rural_ecological_vulnerability_index DECIMAL(5,4),
    urban_informal_settlement_pressure_index DECIMAL(5,4),
    health_burden_index DECIMAL(5,4),
    infrastructure_exclusion_index DECIMAL(5,4),
    regional_isolation_index DECIMAL(5,4),
    conflict_fragility_exposure_index DECIMAL(5,4),
    basic_services_access_index DECIMAL(5,4),
    territorial_governance_capacity_index DECIMAL(5,4),
    poverty_reduction_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
