CREATE VIEW intergenerational_justice_core_dashboard AS
SELECT
    territory_name,
    AVG(future_burden_transfer_index) AS avg_future_burden_transfer,
    AVG(ecological_degradation_index) AS avg_ecological_degradation,
    AVG(institutional_erosion_index) AS avg_institutional_erosion
FROM intergenerational_justice_registry
GROUP BY territory_name;

CREATE VIEW intergenerational_stewardship_governance_dashboard AS
SELECT
    territory_name,
    AVG(public_debt_lock_in_index) AS avg_public_debt_lock_in,
    AVG(infrastructure_lock_in_index) AS avg_infrastructure_lock_in,
    AVG(climate_risk_transfer_index) AS avg_climate_risk_transfer,
    AVG(future_representation_gap_index) AS avg_future_representation_gap,
    AVG(governance_capacity_index) AS avg_governance_capacity,
    AVG(precautionary_planning_index) AS avg_precautionary_planning,
    AVG(resilience_preservation_index) AS avg_resilience_preservation
FROM intergenerational_stewardship_governance_log
GROUP BY territory_name;

CREATE VIEW intergenerational_justice_burden_dashboard AS
SELECT
    territory_name,
    AVG(justice_exposure_index) AS avg_justice_exposure
FROM intergenerational_justice_burden_log
GROUP BY territory_name;
