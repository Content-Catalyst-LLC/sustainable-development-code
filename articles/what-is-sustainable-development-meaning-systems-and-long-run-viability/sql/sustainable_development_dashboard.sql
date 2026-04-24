CREATE VIEW sustainable_development_core_dashboard AS
SELECT
    territory_name,
    AVG(present_deprivation_index) AS avg_present_deprivation,
    AVG(human_wellbeing_support_index) AS avg_human_wellbeing_support,
    AVG(ecological_stress_index) AS avg_ecological_stress
FROM sustainable_development_registry
GROUP BY territory_name;

CREATE VIEW sustainable_development_governance_dashboard AS
SELECT
    territory_name,
    AVG(future_burden_transfer_index) AS avg_future_burden_transfer,
    AVG(institutional_durability_index) AS avg_institutional_durability,
    AVG(systems_interdependence_risk_index) AS avg_systems_interdependence_risk,
    AVG(long_run_viability_index) AS avg_long_run_viability,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(planetary_constraint_exposure_index) AS avg_planetary_constraint_exposure,
    AVG(development_alignment_index) AS avg_development_alignment
FROM sustainable_development_governance_log
GROUP BY territory_name;

CREATE VIEW sustainable_development_burden_dashboard AS
SELECT
    territory_name,
    AVG(present_deprivation_index) AS avg_present_burden
FROM sustainable_development_burden_log
GROUP BY territory_name;
