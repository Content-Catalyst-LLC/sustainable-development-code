CREATE TABLE technology_registry (
    technology_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    technology_name VARCHAR(255) NOT NULL,
    technology_domain VARCHAR(255) NOT NULL,
    adoption_status VARCHAR(100) NOT NULL,
    local_adaptation_index DECIMAL(5,4),
    dependency_risk_index DECIMAL(5,4),
    standards_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
