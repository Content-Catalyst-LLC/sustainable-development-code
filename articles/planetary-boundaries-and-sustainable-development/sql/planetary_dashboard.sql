CREATE VIEW planetary_stress_dashboard AS
SELECT
    territory_name,
    AVG(climate_stress_index) AS avg_climate_stress,
    AVG(biosphere_integrity_loss_index) AS avg_biosphere_integrity_loss,
    AVG(freshwater_change_index) AS avg_freshwater_change
FROM planetary_risk_registry
GROUP BY territory_name;

CREATE VIEW planetary_governance_dashboard AS
SELECT
    territory_name,
    AVG(land_system_change_index) AS avg_land_system_change,
    AVG(biogeochemical_pressure_index) AS avg_biogeochemical_pressure,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(transition_readiness_index) AS avg_transition_readiness
FROM planetary_governance_log
GROUP BY territory_name;

CREATE VIEW planetary_burden_dashboard AS
SELECT
    territory_name,
    AVG(novel_entities_burden_index) AS avg_novel_entities_burden,
    AVG(justice_exposure_index) AS avg_justice_exposure,
    AVG(biosphere_integrity_loss_index) AS avg_biosphere_integrity_loss
FROM planetary_burden_log
GROUP BY territory_name;
