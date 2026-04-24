CREATE VIEW human_development_core_dashboard AS
SELECT
    territory_name,
    AVG(output_growth_index) AS avg_output_growth,
    AVG(health_capability_index) AS avg_health_capability,
    AVG(education_capability_index) AS avg_education_capability
FROM human_development_registry
GROUP BY territory_name;

CREATE VIEW human_development_governance_dashboard AS
SELECT
    territory_name,
    AVG(income_conversion_index) AS avg_income_conversion,
    AVG(public_goods_conversion_index) AS avg_public_goods_conversion,
    AVG(distribution_constraint_index) AS avg_distribution_constraint,
    AVG(institutional_support_index) AS avg_institutional_support,
    AVG(ecological_durability_index) AS avg_ecological_durability,
    AVG(agency_freedom_index) AS avg_agency_freedom,
    AVG(human_development_alignment_index) AS avg_human_development_alignment
FROM human_development_governance_log
GROUP BY territory_name;

CREATE VIEW human_development_burden_dashboard AS
SELECT
    territory_name,
    AVG(output_growth_index) AS avg_growth_pressure
FROM human_development_burden_log
GROUP BY territory_name;
