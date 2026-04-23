CREATE VIEW multilateral_capacity_dashboard AS
SELECT
    country_name,
    governance_domain,
    AVG(coordination_strength_index) AS avg_coordination_strength,
    AVG(knowledge_standards_index) AS avg_knowledge_standards,
    AVG(legitimacy_index) AS avg_legitimacy
FROM multilateral_governance_registry
GROUP BY country_name, governance_domain;

CREATE VIEW multilateral_finance_dashboard AS
SELECT
    country_name,
    governance_domain,
    AVG(financing_support_index) AS avg_financing_support,
    AVG(implementation_support_index) AS avg_implementation_support,
    AVG(resilience_coordination_index) AS avg_resilience_coordination
FROM multilateral_finance_log
GROUP BY country_name, governance_domain;

CREATE VIEW multilateral_risk_dashboard AS
SELECT
    country_name,
    governance_domain,
    AVG(fragmentation_risk_index) AS avg_fragmentation_risk,
    AVG(unequal_influence_risk_index) AS avg_unequal_influence_risk,
    AVG(institutional_lockin_risk_index) AS avg_institutional_lockin_risk
FROM multilateral_risk_log
GROUP BY country_name, governance_domain;
