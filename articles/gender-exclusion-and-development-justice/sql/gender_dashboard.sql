CREATE VIEW gender_capability_dashboard AS
SELECT
    territory_name,
    AVG(education_access_index) AS avg_education_access,
    AVG(health_autonomy_index) AS avg_health_autonomy,
    AVG(economic_participation_index) AS avg_economic_participation
FROM gender_risk_registry
GROUP BY territory_name;

CREATE VIEW gender_governance_dashboard AS
SELECT
    territory_name,
    AVG(care_burden_index) AS avg_care_burden,
    AVG(violence_exposure_index) AS avg_violence_exposure,
    AVG(institutional_power_gap_index) AS avg_institutional_power_gap,
    AVG(governance_capacity_index) AS avg_governance_capacity
FROM gender_governance_log
GROUP BY territory_name;

CREATE VIEW gender_transition_dashboard AS
SELECT
    territory_name,
    AVG(property_rights_gap_index) AS avg_property_rights_gap,
    AVG(gender_transition_readiness_index) AS avg_gender_transition_readiness,
    AVG(economic_participation_index) AS avg_economic_participation
FROM gender_burden_log
GROUP BY territory_name;
