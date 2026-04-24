CREATE TABLE policy_coherence_registry (
    risk_id VARCHAR(100) PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    country_or_region VARCHAR(255) NOT NULL,
    territory_type VARCHAR(100) NOT NULL,
    tradeoff_intensity_index DECIMAL(5,4),
    synergy_realization_index DECIMAL(5,4),
    sectoral_spillover_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE policy_coherence_governance_log (
    governance_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    transboundary_spillover_index DECIMAL(5,4),
    intergenerational_spillover_index DECIMAL(5,4),
    coordination_capacity_index DECIMAL(5,4),
    impact_assessment_index DECIMAL(5,4),
    monitoring_review_index DECIMAL(5,4),
    sequencing_capacity_index DECIMAL(5,4),
    governance_fragmentation_index DECIMAL(5,4),
    policy_alignment_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE policy_coherence_burden_log (
    burden_id INTEGER PRIMARY KEY,
    territory_name VARCHAR(255) NOT NULL,
    tradeoff_intensity_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
