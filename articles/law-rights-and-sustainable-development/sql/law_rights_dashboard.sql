CREATE VIEW legal_protection_dashboard AS
SELECT
    country_name,
    legal_domain,
    AVG(rights_protection_index) AS avg_rights_protection,
    AVG(non_discrimination_protection_index) AS avg_non_discrimination,
    AVG(environmental_rights_integration_index) AS avg_environmental_rights_integration
FROM legal_protection_registry
GROUP BY country_name, legal_domain;

CREATE VIEW remedy_dashboard AS
SELECT
    country_name,
    AVG(access_to_justice_index) AS avg_access_to_justice,
    AVG(administrative_review_index) AS avg_administrative_review,
    AVG(enforcement_capacity_index) AS avg_enforcement_capacity
FROM remedy_and_review_log
GROUP BY country_name;

CREATE VIEW legal_risk_dashboard AS
SELECT
    country_name,
    legal_domain,
    AVG(legal_exclusion_risk_index) AS avg_legal_exclusion_risk,
    AVG(procedural_participation_index) AS avg_procedural_participation,
    AVG(accountability_structure_index) AS avg_accountability_structure
FROM legal_risk_log
GROUP BY country_name, legal_domain;
