CREATE VIEW transport_accessibility_dashboard AS
SELECT
    city_region,
    mode_type,
    AVG(service_frequency_index) AS avg_service_frequency,
    AVG(route_coverage_index) AS avg_route_coverage,
    AVG(accessibility_compliance_index) AS avg_accessibility_compliance
FROM transport_route_registry
GROUP BY city_region, mode_type;

CREATE VIEW stop_safety_dashboard AS
SELECT
    city_region,
    stop_type,
    AVG(disability_access_index) AS avg_disability_access,
    AVG(safety_index) AS avg_safety,
    AVG(lighting_index) AS avg_lighting
FROM stop_and_station_registry
GROUP BY city_region, stop_type;

CREATE VIEW service_reliability_dashboard AS
SELECT
    city_region,
    mode_type,
    AVG(on_time_performance_index) AS avg_on_time_performance,
    AVG(uptime_index) AS avg_uptime,
    AVG(crowding_index) AS avg_crowding
FROM service_reliability_log
GROUP BY city_region, mode_type;
