CREATE VIEW inclusion_capability_dashboard AS
SELECT
    territory_name,
    AVG(education_access_index) AS avg_education_access,
    AVG(health_access_index) AS avg_health_access,
    AVG(income_security_index) AS avg_income_security
FROM inclusion_risk_registry
GROUP BY territory_name;

CREATE VIEW inclusion_governance_dashboard AS
SELECT
    territory_name,
    AVG(public_goods_access_index) AS avg_public_goods_access,
    AVG(opportunity_blockage_index) AS avg_opportunity_blockage,
    AVG(institutional_capture_index) AS avg_institutional_capture,
    AVG(governance_capacity_index) AS avg_governance_capacity
FROM inclusion_governance_log
GROUP BY territory_name;

CREATE VIEW inclusion_transition_dashboard AS
SELECT
    territory_name,
    AVG(risk_exposure_index) AS avg_risk_exposure,
    AVG(inclusive_transition_readiness_index) AS avg_inclusive_transition_readiness,
    AVG(income_security_index) AS avg_income_security
FROM inclusion_burden_log
GROUP BY territory_name;
