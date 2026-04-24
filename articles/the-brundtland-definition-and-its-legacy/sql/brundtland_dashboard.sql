CREATE VIEW brundtland_core_dashboard AS
SELECT
    territory_name,
    AVG(present_need_pressure_index) AS avg_present_need_pressure,
    AVG(poverty_reduction_support_index) AS avg_poverty_reduction_support,
    AVG(ecological_degradation_index) AS avg_ecological_degradation
FROM brundtland_registry
GROUP BY territory_name;

CREATE VIEW brundtland_governance_dashboard AS
SELECT
    territory_name,
    AVG(future_burden_transfer_index) AS avg_future_burden_transfer,
    AVG(institutional_durability_index) AS avg_institutional_durability,
    AVG(intergenerational_stewardship_index) AS avg_intergenerational_stewardship,
    AVG(absorptive_capacity_stress_index) AS avg_absorptive_capacity_stress,
    AVG(technology_organisation_constraint_index) AS avg_technology_organisation_constraint,
    AVG(development_legitimacy_alignment_index) AS avg_development_legitimacy_alignment
FROM brundtland_governance_log
GROUP BY territory_name;

CREATE VIEW brundtland_burden_dashboard AS
SELECT
    territory_name,
    AVG(present_need_pressure_index) AS avg_need_burden
FROM brundtland_burden_log
GROUP BY territory_name;
