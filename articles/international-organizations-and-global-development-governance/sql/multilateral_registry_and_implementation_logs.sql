CREATE TABLE multilateral_governance_registry (
    governance_id VARCHAR(100) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    governance_domain VARCHAR(255) NOT NULL,
    coordination_strength_index DECIMAL(5,4),
    knowledge_standards_index DECIMAL(5,4),
    legitimacy_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE multilateral_finance_log (
    finance_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    governance_domain VARCHAR(255) NOT NULL,
    financing_support_index DECIMAL(5,4),
    implementation_support_index DECIMAL(5,4),
    resilience_coordination_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE multilateral_risk_log (
    risk_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    governance_domain VARCHAR(255) NOT NULL,
    fragmentation_risk_index DECIMAL(5,4),
    unequal_influence_risk_index DECIMAL(5,4),
    institutional_lockin_risk_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
