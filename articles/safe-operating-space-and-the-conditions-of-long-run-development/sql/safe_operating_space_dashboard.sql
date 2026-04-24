CREATE VIEW safe_operating_space_boundary_dashboard AS
SELECT
    territory_name,
    AVG(climate_boundary_pressure_index) AS avg_climate_boundary_pressure,
    AVG(biosphere_boundary_pressure_index) AS avg_biosphere_boundary_pressure,
    AVG(land_system_pressure_index) AS avg_land_system_pressure
FROM safe_operating_space_registry
GROUP BY territory_name;

CREATE VIEW safe_operating_space_governance_dashboard AS
SELECT
    territory_name,
    AVG(freshwater_pressure_index) AS avg_freshwater_pressure,
    AVG(biogeochemical_pressure_index) AS avg_biogeochemical_pressure,
    AVG(novel_entities_pressure_index) AS avg_novel_entities_pressure,
    AVG(ocean_acidification_pressure_index) AS avg_ocean_acidification_pressure,
    AVG(resilience_loss_index) AS avg_resilience_loss,
    AVG(governability_strain_index) AS avg_governability_strain,
    AVG(adaptation_capacity_index) AS avg_adaptation_capacity
FROM safe_operating_space_governance_log
GROUP BY territory_name;

CREATE VIEW safe_operating_space_justice_dashboard AS
SELECT
    territory_name,
    AVG(justice_exposure_index) AS avg_justice_exposure,
    AVG(adaptation_capacity_index) AS avg_adaptation_capacity
FROM safe_operating_space_burden_log
GROUP BY territory_name;
