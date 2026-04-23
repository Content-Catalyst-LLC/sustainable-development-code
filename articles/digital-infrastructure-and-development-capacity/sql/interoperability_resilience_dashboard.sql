CREATE TABLE interoperability_exchange_log (
    exchange_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    platform_domain VARCHAR(255) NOT NULL,
    interoperability_index DECIMAL(5,4),
    registry_integrity_index DECIMAL(5,4),
    vendor_dependency_index DECIMAL(5,4),
    open_standards_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE VIEW dpi_service_dashboard AS
SELECT
    country_name,
    COUNT(*) AS service_events,
    AVG(authenticated_access_rate) AS avg_authenticated_access_rate,
    AVG(grievance_resolution_rate) AS avg_grievance_resolution_rate,
    AVG(service_uptime_index) AS avg_service_uptime_index
FROM service_delivery_registry
GROUP BY country_name;

CREATE VIEW interoperability_dashboard AS
SELECT
    country_name,
    platform_domain,
    AVG(interoperability_index) AS avg_interoperability,
    AVG(registry_integrity_index) AS avg_registry_integrity,
    AVG(vendor_dependency_index) AS avg_vendor_dependency,
    AVG(open_standards_index) AS avg_open_standards
FROM interoperability_exchange_log
GROUP BY country_name, platform_domain;
