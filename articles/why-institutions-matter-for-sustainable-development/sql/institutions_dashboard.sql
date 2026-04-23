CREATE VIEW institutional_capacity_dashboard AS
SELECT
    country_name,
    institutional_domain,
    AVG(implementation_capacity_index) AS avg_implementation_capacity,
    AVG(coordination_capacity_index) AS avg_coordination_capacity,
    AVG(accountability_strength_index) AS avg_accountability_strength
FROM institutional_capacity_registry
GROUP BY country_name, institutional_domain;

CREATE VIEW institutional_delivery_dashboard AS
SELECT
    country_name,
    institutional_domain,
    AVG(delivery_system_reliability_index) AS avg_delivery_reliability,
    AVG(trust_support_index) AS avg_trust_support,
    AVG(legal_administrative_clarity_index) AS avg_legal_administrative_clarity
FROM institutional_delivery_log
GROUP BY country_name, institutional_domain;

CREATE VIEW institutional_risk_dashboard AS
SELECT
    country_name,
    institutional_domain,
    AVG(fragmentation_risk_index) AS avg_fragmentation_risk,
    AVG(capture_risk_index) AS avg_capture_risk,
    AVG(learning_capacity_index) AS avg_learning_capacity
FROM institutional_risk_log
GROUP BY country_name, institutional_domain;
