CREATE TABLE integrity_registry (
    integrity_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    institutional_domain VARCHAR(255) NOT NULL,
    procurement_integrity_index DECIMAL(5,4),
    service_integrity_index DECIMAL(5,4),
    accountability_strength_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE accountability_log (
    accountability_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    complaint_access_index DECIMAL(5,4),
    audit_capacity_index DECIMAL(5,4),
    beneficial_ownership_visibility_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE corruption_risk_log (
    risk_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    institutional_domain VARCHAR(255) NOT NULL,
    capture_risk_index DECIMAL(5,4),
    selective_enforcement_risk_index DECIMAL(5,4),
    trust_support_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
