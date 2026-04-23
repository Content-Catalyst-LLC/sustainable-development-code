CREATE TABLE participation_registry (
    participation_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    program_domain VARCHAR(255) NOT NULL,
    participatory_depth_index DECIMAL(5,4),
    representation_quality_index DECIMAL(5,4),
    community_control_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE accountability_log (
    accountability_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    program_domain VARCHAR(255) NOT NULL,
    accountability_channel_index DECIMAL(5,4),
    feedback_closure_index DECIMAL(5,4),
    institutional_uptake_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE participation_risk_log (
    risk_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    territory_name VARCHAR(255) NOT NULL,
    elite_capture_risk_index DECIMAL(5,4),
    tokenism_risk_index DECIMAL(5,4),
    trust_support_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
