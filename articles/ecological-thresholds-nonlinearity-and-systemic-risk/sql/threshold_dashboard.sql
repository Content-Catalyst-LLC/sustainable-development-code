CREATE VIEW threshold_sensitivity_dashboard AS
SELECT
    system_name,
    ecosystem_type,
    AVG(cumulative_pressure_index) AS avg_cumulative_pressure,
    AVG(slow_variable_deterioration_index) AS avg_slow_variable_deterioration,
    AVG(feedback_intensity_index) AS avg_feedback_intensity
FROM threshold_risk_registry
GROUP BY system_name, ecosystem_type;

CREATE VIEW resilience_readiness_dashboard AS
SELECT
    system_name,
    AVG(resilience_buffer_index) AS avg_resilience_buffer,
    AVG(monitoring_readiness_index) AS avg_monitoring_readiness,
    AVG(precaution_capacity_index) AS avg_precaution_capacity
FROM resilience_monitoring_log
GROUP BY system_name;

CREATE VIEW cascade_justice_dashboard AS
SELECT
    system_name,
    AVG(cascade_exposure_index) AS avg_cascade_exposure,
    AVG(justice_exposure_index) AS avg_justice_exposure,
    AVG(recovery_difficulty_index) AS avg_recovery_difficulty
FROM cascade_justice_log
GROUP BY system_name;
