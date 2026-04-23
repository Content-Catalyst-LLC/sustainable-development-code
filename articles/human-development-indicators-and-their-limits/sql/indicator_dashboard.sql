CREATE VIEW indicator_attainment_dashboard AS
SELECT
    territory_name,
    AVG(hdi_attainment_index) AS avg_hdi_attainment,
    AVG(inequality_penalty_index) AS avg_inequality_penalty,
    AVG(gender_gap_index) AS avg_gender_gap
FROM indicator_risk_registry
GROUP BY territory_name;

CREATE VIEW indicator_methodology_dashboard AS
SELECT
    territory_name,
    AVG(multidimensional_poverty_index) AS avg_multidimensional_poverty,
    AVG(subnational_variation_index) AS avg_subnational_variation,
    AVG(data_quality_confidence_index) AS avg_data_quality_confidence,
    AVG(indicator_coverage_index) AS avg_indicator_coverage
FROM indicator_methodology_log
GROUP BY territory_name;

CREATE VIEW indicator_burden_dashboard AS
SELECT
    territory_name,
    AVG(security_exclusion_index) AS avg_security_exclusion,
    AVG(planetary_pressure_penalty_index) AS avg_planetary_pressure_penalty,
    AVG(hdi_attainment_index) AS avg_hdi_attainment_signal
FROM indicator_burden_log
GROUP BY territory_name;
