CREATE VIEW infrastructure_access_dashboard AS
SELECT
    country_name,
    infrastructure_domain,
    AVG(access_index) AS avg_access,
    AVG(reliability_index) AS avg_reliability,
    AVG(climate_resilience_index) AS avg_climate_resilience
FROM infrastructure_asset_registry
GROUP BY country_name, infrastructure_domain;

CREATE VIEW maintenance_dashboard AS
SELECT
    asset_id,
    AVG(maintenance_capacity_index) AS avg_maintenance_capacity,
    AVG(inspection_quality_index) AS avg_inspection_quality,
    AVG(downtime_index) AS avg_downtime
FROM maintenance_log
GROUP BY asset_id;

CREATE VIEW outage_recovery_dashboard AS
SELECT
    asset_id,
    AVG(outage_duration_index) AS avg_outage_duration,
    AVG(population_impact_index) AS avg_population_impact,
    AVG(recovery_capacity_index) AS avg_recovery_capacity
FROM service_outage_log
GROUP BY asset_id;
