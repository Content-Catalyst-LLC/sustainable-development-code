CREATE TABLE legal_protection_registry (
    legal_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    legal_domain VARCHAR(255) NOT NULL,
    rights_protection_index DECIMAL(5,4),
    non_discrimination_protection_index DECIMAL(5,4),
    environmental_rights_integration_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE remedy_and_review_log (
    review_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    access_to_justice_index DECIMAL(5,4),
    administrative_review_index DECIMAL(5,4),
    enforcement_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE legal_risk_log (
    risk_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    legal_domain VARCHAR(255) NOT NULL,
    legal_exclusion_risk_index DECIMAL(5,4),
    procedural_participation_index DECIMAL(5,4),
    accountability_structure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
