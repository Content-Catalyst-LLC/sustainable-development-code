CREATE VIEW territorial_capacity_dashboard AS
SELECT
    city_or_region,
    AVG(service_reach_index) AS avg_service_reach,
    AVG(land_housing_coordination_index) AS avg_land_housing_coordination,
    AVG(spatial_justice_index) AS avg_spatial_justice
FROM territorial_governance_registry
GROUP BY city_or_region;

CREATE VIEW territorial_infrastructure_dashboard AS
SELECT
    city_or_region,
    AVG(infrastructure_mobility_integration_index) AS avg_infrastructure_mobility_integration,
    AVG(resilience_capacity_index) AS avg_resilience_capacity,
    AVG(multilevel_alignment_index) AS avg_multilevel_alignment
FROM territorial_infrastructure_log
GROUP BY city_or_region;

CREATE VIEW territorial_risk_dashboard AS
SELECT
    city_or_region,
    AVG(fragmentation_risk_index) AS avg_fragmentation_risk,
    AVG(informality_pressure_index) AS avg_informality_pressure,
    AVG(hazard_exposure_index) AS avg_hazard_exposure
FROM territorial_risk_log
GROUP BY city_or_region;
