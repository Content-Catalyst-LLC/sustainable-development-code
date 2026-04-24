CREATE VIEW sdg_logic_core_dashboard AS
SELECT
    territory_name,
    AVG(universality_exposure_index) AS avg_universality_exposure,
    AVG(integration_complexity_index) AS avg_integration_complexity,
    AVG(implementation_capacity_index) AS avg_implementation_capacity
FROM sdg_logic_registry
GROUP BY territory_name;

CREATE VIEW sdg_logic_governance_dashboard AS
SELECT
    territory_name,
    AVG(means_of_implementation_index) AS avg_means_of_implementation,
    AVG(partnership_readiness_index) AS avg_partnership_readiness,
    AVG(monitoring_capacity_index) AS avg_monitoring_capacity,
    AVG(indicator_coverage_index) AS avg_indicator_coverage,
    AVG(review_responsiveness_index) AS avg_review_responsiveness,
    AVG(policy_fragmentation_index) AS avg_policy_fragmentation,
    AVG(sdg_alignment_index) AS avg_sdg_alignment
FROM sdg_logic_governance_log
GROUP BY territory_name;

CREATE VIEW sdg_logic_burden_dashboard AS
SELECT
    territory_name,
    AVG(integration_complexity_index) AS avg_integration_burden
FROM sdg_logic_burden_log
GROUP BY territory_name;
