CREATE TABLE blended_finance_instruments (
    instrument_id INTEGER PRIMARY KEY,
    project_id VARCHAR(100) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    public_anchor_share DECIMAL(5,4) NOT NULL,
    private_share DECIMAL(5,4) NOT NULL,
    guarantee_strength_index DECIMAL(5,4),
    policy_stability_index DECIMAL(5,4),
    currency_risk_index DECIMAL(5,4),
    social_inclusion_index DECIMAL(5,4)
);

CREATE TABLE taxonomy_disclosure_log (
    disclosure_id INTEGER PRIMARY KEY,
    project_id VARCHAR(100) NOT NULL,
    taxonomy_name VARCHAR(255) NOT NULL,
    alignment_status VARCHAR(100) NOT NULL,
    disclosure_quality_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);
