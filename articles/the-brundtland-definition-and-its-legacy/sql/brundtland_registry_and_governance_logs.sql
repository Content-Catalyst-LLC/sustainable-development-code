CREATE TABLE brundtland_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    present_need_pressure_index DECIMAL(5,4),
    poverty_reduction_support_index DECIMAL(5,4),
    ecological_degradation_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE brundtland_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    future_burden_transfer_index DECIMAL(5,4),
    institutional_durability_index DECIMAL(5,4),
    intergenerational_stewardship_index DECIMAL(5,4),
    absorptive_capacity_stress_index DECIMAL(5,4),
    technology_organisation_constraint_index DECIMAL(5,4),
    development_legitimacy_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE brundtland_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    present_need_pressure_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
