CREATE TABLE industrial_ecosystem_registry (
    ecosystem_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    manufacturing_share_index DECIMAL(5,4),
    technology_upgrading_index DECIMAL(5,4),
    supplier_ecosystem_index DECIMAL(5,4),
    infrastructure_quality_index DECIMAL(5,4),
    green_transition_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
