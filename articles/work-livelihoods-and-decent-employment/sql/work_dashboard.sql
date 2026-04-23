CREATE VIEW work_security_dashboard AS
SELECT
    territory_name,
    AVG(employment_access_index) AS avg_employment_access,
    AVG(informality_risk_index) AS avg_informality_risk,
    AVG(precarity_risk_index) AS avg_precarity_risk
FROM work_risk_registry
GROUP BY territory_name;

CREATE VIEW work_governance_dashboard AS
SELECT
    territory_name,
    AVG(income_security_index) AS avg_income_security,
    AVG(social_protection_coverage_index) AS avg_social_protection,
    AVG(labour_rights_exposure_index) AS avg_labour_rights_exposure
FROM work_governance_log
GROUP BY territory_name;

CREATE VIEW work_exclusion_dashboard AS
SELECT
    territory_name,
    AVG(youth_exclusion_index) AS avg_youth_exclusion,
    AVG(gender_livelihood_gap_index) AS avg_gender_livelihood_gap,
    AVG(transition_readiness_index) AS avg_transition_readiness
FROM work_burden_log
GROUP BY territory_name;
