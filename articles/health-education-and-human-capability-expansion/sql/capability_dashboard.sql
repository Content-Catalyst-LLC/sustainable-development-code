CREATE VIEW capability_access_dashboard AS
SELECT
    territory_name,
    AVG(health_access_index) AS avg_health_access,
    AVG(education_access_index) AS avg_education_access,
    AVG(service_quality_index) AS avg_service_quality
FROM capability_risk_registry
GROUP BY territory_name;

CREATE VIEW capability_governance_dashboard AS
SELECT
    territory_name,
    AVG(financial_hardship_risk_index) AS avg_financial_hardship_risk,
    AVG(learning_deprivation_index) AS avg_learning_deprivation,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(capability_transition_readiness_index) AS avg_capability_transition_readiness
FROM capability_governance_log
GROUP BY territory_name;

CREATE VIEW capability_burden_dashboard AS
SELECT
    territory_name,
    AVG(life_course_vulnerability_index) AS avg_life_course_vulnerability,
    AVG(inequality_exclusion_index) AS avg_inequality_exclusion,
    AVG(service_quality_index) AS avg_service_quality
FROM capability_burden_log
GROUP BY territory_name;
