CREATE VIEW participation_quality_dashboard AS
SELECT
    country_name,
    program_domain,
    AVG(participatory_depth_index) AS avg_participatory_depth,
    AVG(representation_quality_index) AS avg_representation_quality,
    AVG(community_control_index) AS avg_community_control
FROM participation_registry
GROUP BY country_name, program_domain;

CREATE VIEW accountability_dashboard AS
SELECT
    country_name,
    program_domain,
    AVG(accountability_channel_index) AS avg_accountability_channel,
    AVG(feedback_closure_index) AS avg_feedback_closure,
    AVG(institutional_uptake_index) AS avg_institutional_uptake
FROM accountability_log
GROUP BY country_name, program_domain;

CREATE VIEW participation_risk_dashboard AS
SELECT
    country_name,
    AVG(elite_capture_risk_index) AS avg_elite_capture_risk,
    AVG(tokenism_risk_index) AS avg_tokenism_risk,
    AVG(trust_support_index) AS avg_trust_support
FROM participation_risk_log
GROUP BY country_name;
