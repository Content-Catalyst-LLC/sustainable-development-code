CREATE TABLE industrial_policy_support_log (
    support_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    policy_instrument VARCHAR(255) NOT NULL,
    support_value_usd DECIMAL(20,2),
    conditionality_type VARCHAR(255),
    reporting_year INTEGER NOT NULL
);

CREATE TABLE standards_compliance_registry (
    compliance_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    standards_alignment_index DECIMAL(5,4),
    quality_infrastructure_index DECIMAL(5,4),
    compliance_readiness_index DECIMAL(5,4),
    reporting_year INTEGER NOT NULL
);

INSERT INTO industrial_policy_support_log (
    support_id,
    country_name,
    sector_name,
    policy_instrument,
    support_value_usd,
    conditionality_type,
    reporting_year
) VALUES
(1, 'Country A', 'Green Manufacturing', 'targeted_credit', 250000000.00, 'local_supplier_development', 2026),
(2, 'Country B', 'Digital Services', 'innovation_grant', 80000000.00, 'skills_and_export_upgrading', 2026),
(3, 'Country C', 'Critical Minerals Processing', 'infrastructure_support', 140000000.00, 'standards_and_local_linkages', 2026);
