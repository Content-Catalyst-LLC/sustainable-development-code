CREATE VIEW integrity_quality_dashboard AS
SELECT
    country_name,
    institutional_domain,
    AVG(procurement_integrity_index) AS avg_procurement_integrity,
    AVG(service_integrity_index) AS avg_service_integrity,
    AVG(accountability_strength_index) AS avg_accountability_strength
FROM integrity_registry
GROUP BY country_name, institutional_domain;

CREATE VIEW accountability_dashboard AS
SELECT
    country_name,
    AVG(complaint_access_index) AS avg_complaint_access,
    AVG(audit_capacity_index) AS avg_audit_capacity,
    AVG(beneficial_ownership_visibility_index) AS avg_beneficial_ownership_visibility
FROM accountability_log
GROUP BY country_name;

CREATE VIEW corruption_risk_dashboard AS
SELECT
    country_name,
    institutional_domain,
    AVG(capture_risk_index) AS avg_capture_risk,
    AVG(selective_enforcement_risk_index) AS avg_selective_enforcement_risk,
    AVG(trust_support_index) AS avg_trust_support
FROM corruption_risk_log
GROUP BY country_name, institutional_domain;
