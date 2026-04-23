CREATE TABLE institutional_capacity_registry (
    institution_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    institutional_domain VARCHAR(255) NOT NULL,
    implementation_capacity_index DECIMAL(5,4),
    coordination_capacity_index DECIMAL(5,4),
    accountability_strength_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE institutional_delivery_log (
    delivery_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    institutional_domain VARCHAR(255) NOT NULL,
    delivery_system_reliability_index DECIMAL(5,4),
    trust_support_index DECIMAL(5,4),
    legal_administrative_clarity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE institutional_risk_log (
    risk_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    institutional_domain VARCHAR(255) NOT NULL,
    fragmentation_risk_index DECIMAL(5,4),
    capture_risk_index DECIMAL(5,4),
    learning_capacity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
