CREATE VIEW overshoot_core_dashboard AS
SELECT
    territory_name,
    AVG(growth_pressure_index) AS avg_growth_pressure,
    AVG(throughput_pressure_index) AS avg_throughput_pressure,
    AVG(resource_depletion_index) AS avg_resource_depletion
FROM overshoot_registry
GROUP BY territory_name;

CREATE VIEW overshoot_governance_dashboard AS
SELECT
    territory_name,
    AVG(waste_absorptive_stress_index) AS avg_waste_absorptive_stress,
    AVG(planetary_pressure_index) AS avg_planetary_pressure,
    AVG(delay_recognition_risk_index) AS avg_delay_recognition_risk,
    AVG(infrastructure_lockin_index) AS avg_infrastructure_lockin,
    AVG(governance_fragility_index) AS avg_governance_fragility,
    AVG(adaptive_capacity_index) AS avg_adaptive_capacity,
    AVG(welfare_conversion_index) AS avg_welfare_conversion
FROM overshoot_governance_log
GROUP BY territory_name;

CREATE VIEW overshoot_burden_dashboard AS
SELECT
    territory_name,
    AVG(growth_pressure_index) AS avg_growth_pressure_burden
FROM overshoot_burden_log
GROUP BY territory_name;
