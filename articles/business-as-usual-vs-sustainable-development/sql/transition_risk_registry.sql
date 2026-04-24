CREATE TABLE transition_risk_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    fossil_dependence_index DECIMAL(5,4),
    resource_throughput_pressure_index DECIMAL(5,4),
    urban_lock_in_index DECIMAL(5,4),
    inequality_pressure_index DECIMAL(5,4),
    public_goods_inclusion_index DECIMAL(5,4),
    ecological_stress_index DECIMAL(5,4),
    governance_transition_capacity_index DECIMAL(5,4),
    clean_technology_adoption_index DECIMAL(5,4),
    sustainable_development_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
