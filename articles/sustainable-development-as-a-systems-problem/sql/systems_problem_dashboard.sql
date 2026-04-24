CREATE VIEW systems_problem_core_dashboard AS
SELECT
    territory_name,
    AVG(interdependence_intensity_index) AS avg_interdependence_intensity,
    AVG(feedback_risk_index) AS avg_feedback_risk,
    AVG(delay_exposure_index) AS avg_delay_exposure
FROM systems_problem_registry
GROUP BY territory_name;

CREATE VIEW systems_problem_governance_dashboard AS
SELECT
    territory_name,
    AVG(path_dependence_index) AS avg_path_dependence,
    AVG(cross_scale_pressure_index) AS avg_cross_scale_pressure,
    AVG(earth_system_stress_index) AS avg_earth_system_stress,
    AVG(governance_fragmentation_index) AS avg_governance_fragmentation,
    AVG(coordination_capacity_index) AS avg_coordination_capacity,
    AVG(institutional_integration_index) AS avg_institutional_integration,
    AVG(leverage_point_capacity_index) AS avg_leverage_point_capacity
FROM systems_problem_governance_log
GROUP BY territory_name;

CREATE VIEW systems_problem_burden_dashboard AS
SELECT
    territory_name,
    AVG(interdependence_intensity_index) AS avg_interdependence_burden
FROM systems_problem_burden_log
GROUP BY territory_name;
