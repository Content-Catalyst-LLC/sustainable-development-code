CREATE VIEW pollution_material_dashboard AS
SELECT
    territory_name,
    AVG(hazardous_material_throughput_index) AS avg_hazardous_throughput,
    AVG(waste_system_overload_index) AS avg_waste_overload,
    AVG(persistence_mobility_risk_index) AS avg_persistence_mobility_risk
FROM pollution_risk_registry
GROUP BY territory_name;

CREATE VIEW pollution_governance_dashboard AS
SELECT
    territory_name,
    AVG(assessment_lag_index) AS avg_assessment_lag,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(remediation_readiness_index) AS avg_remediation_readiness
FROM pollution_governance_log
GROUP BY territory_name;

CREATE VIEW pollution_burden_dashboard AS
SELECT
    territory_name,
    AVG(exposure_inequality_index) AS avg_exposure_inequality,
    AVG(ecosystem_toxicity_index) AS avg_ecosystem_toxicity,
    AVG(public_health_burden_index) AS avg_public_health_burden
FROM pollution_burden_log
GROUP BY territory_name;
