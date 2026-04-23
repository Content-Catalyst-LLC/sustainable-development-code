CREATE TABLE digital_identity_registry (
    identity_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    resident_status VARCHAR(100) NOT NULL,
    identity_verification_status VARCHAR(100) NOT NULL,
    accessibility_flag BOOLEAN NOT NULL,
    reporting_year INTEGER NOT NULL
);

CREATE TABLE digital_payments_log (
    payment_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    service_program VARCHAR(255) NOT NULL,
    payment_channel VARCHAR(100) NOT NULL,
    transaction_success_rate DECIMAL(5,4),
    fraud_risk_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE service_delivery_registry (
    service_event_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    authenticated_access_rate DECIMAL(5,4),
    grievance_resolution_rate DECIMAL(5,4),
    service_uptime_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
