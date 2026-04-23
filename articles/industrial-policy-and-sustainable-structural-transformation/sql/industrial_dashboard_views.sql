CREATE VIEW industrial_ecosystem_dashboard AS
SELECT
    country_name,
    region_name,
    sector_name,
    AVG(manufacturing_share_index) AS avg_manufacturing_share,
    AVG(technology_upgrading_index) AS avg_technology_upgrading,
    AVG(supplier_ecosystem_index) AS avg_supplier_ecosystem,
    AVG(green_transition_readiness_index) AS avg_green_transition_readiness
FROM industrial_ecosystem_registry
GROUP BY country_name, region_name, sector_name;

CREATE VIEW industrial_policy_support_dashboard AS
SELECT
    country_name,
    sector_name,
    COUNT(*) AS support_instruments,
    SUM(support_value_usd) AS total_support_value_usd
FROM industrial_policy_support_log
GROUP BY country_name, sector_name;

CREATE VIEW standards_compliance_dashboard AS
SELECT
    country_name,
    sector_name,
    AVG(standards_alignment_index) AS avg_standards_alignment,
    AVG(quality_infrastructure_index) AS avg_quality_infrastructure,
    AVG(compliance_readiness_index) AS avg_compliance_readiness
FROM standards_compliance_registry
GROUP BY country_name, sector_name;
