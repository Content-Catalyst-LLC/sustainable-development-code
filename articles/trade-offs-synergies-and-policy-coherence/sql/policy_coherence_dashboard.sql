CREATE VIEW policy_coherence_core_dashboard AS
SELECT
    territory_name,
    AVG(tradeoff_intensity_index) AS avg_tradeoff_intensity,
    AVG(synergy_realization_index) AS avg_synergy_realization,
    AVG(sectoral_spillover_index) AS avg_sectoral_spillover
FROM policy_coherence_registry
GROUP BY territory_name;

CREATE VIEW policy_coherence_governance_dashboard AS
SELECT
    territory_name,
    AVG(transboundary_spillover_index) AS avg_transboundary_spillover,
    AVG(intergenerational_spillover_index) AS avg_intergenerational_spillover,
    AVG(coordination_capacity_index) AS avg_coordination_capacity,
    AVG(impact_assessment_index) AS avg_impact_assessment,
    AVG(monitoring_review_index) AS avg_monitoring_review,
    AVG(sequencing_capacity_index) AS avg_sequencing_capacity,
    AVG(governance_fragmentation_index) AS avg_governance_fragmentation,
    AVG(policy_alignment_index) AS avg_policy_alignment
FROM policy_coherence_governance_log
GROUP BY territory_name;

CREATE VIEW policy_coherence_burden_dashboard AS
SELECT
    territory_name,
    AVG(tradeoff_intensity_index) AS avg_tradeoff_burden
FROM policy_coherence_burden_log
GROUP BY territory_name;
