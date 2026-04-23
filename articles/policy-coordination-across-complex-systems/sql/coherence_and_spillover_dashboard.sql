CREATE VIEW policy_coherence_dashboard AS
SELECT
    country_name,
    policy_domain,
    AVG(cross_sector_alignment_index) AS avg_cross_sector_alignment,
    AVG(spillover_management_index) AS avg_spillover_management,
    AVG(resilience_integration_index) AS avg_resilience_integration
FROM policy_instrument_registry
GROUP BY country_name, policy_domain;

CREATE VIEW agency_coordination_dashboard AS
SELECT
    country_name,
    policy_domain,
    AVG(coordination_capacity_index) AS avg_coordination_capacity,
    AVG(data_visibility_index) AS avg_data_visibility,
    AVG(implementation_alignment_index) AS avg_implementation_alignment
FROM agency_mandate_registry
GROUP BY country_name, policy_domain;

CREATE VIEW coordination_event_dashboard AS
SELECT
    country_name,
    policy_domain,
    AVG(tradeoff_visibility_index) AS avg_tradeoff_visibility,
    AVG(synergy_capture_index) AS avg_synergy_capture,
    AVG(revision_followthrough_index) AS avg_revision_followthrough
FROM coordination_event_log
GROUP BY country_name, policy_domain;
