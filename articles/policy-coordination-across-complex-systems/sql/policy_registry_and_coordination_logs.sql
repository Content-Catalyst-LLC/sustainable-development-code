CREATE TABLE policy_instrument_registry (
    policy_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    policy_domain VARCHAR(255) NOT NULL,
    implementation_level VARCHAR(100) NOT NULL,
    cross_sector_alignment_index DECIMAL(5,4),
    spillover_management_index DECIMAL(5,4),
    resilience_integration_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE agency_mandate_registry (
    agency_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    agency_name VARCHAR(255) NOT NULL,
    policy_domain VARCHAR(255) NOT NULL,
    coordination_capacity_index DECIMAL(5,4),
    data_visibility_index DECIMAL(5,4),
    implementation_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE coordination_event_log (
    coordination_event_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    policy_domain VARCHAR(255) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    tradeoff_visibility_index DECIMAL(5,4),
    synergy_capture_index DECIMAL(5,4),
    revision_followthrough_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
