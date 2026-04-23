CREATE TABLE sustainable_project_registry (
    project_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    project_size_usd DECIMAL(20,2) NOT NULL,
    development_need_index DECIMAL(5,4),
    climate_resilience_index DECIMAL(5,4),
    inclusion_index DECIMAL(5,4),
    bankability_index DECIMAL(5,4),
    policy_alignment_index DECIMAL(5,4),
    taxonomy_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
