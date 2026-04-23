CREATE VIEW sustainable_project_dashboard AS
SELECT
    country_name,
    sector_name,
    COUNT(*) AS projects_registered,
    AVG(development_need_index) AS avg_development_need,
    AVG(climate_resilience_index) AS avg_climate_resilience,
    AVG(inclusion_index) AS avg_inclusion,
    SUM(project_size_usd) AS total_project_size_usd
FROM sustainable_project_registry
GROUP BY country_name, sector_name;

CREATE VIEW sustainable_bond_dashboard AS
SELECT
    issuer_type,
    bond_label,
    COUNT(*) AS issuances,
    SUM(issuance_size_usd) AS total_issuance_usd
FROM sustainable_bond_issuance
GROUP BY issuer_type, bond_label;

CREATE VIEW blended_finance_dashboard AS
SELECT
    country_name,
    COUNT(*) AS instruments_count,
    AVG(public_anchor_share) AS avg_public_anchor_share,
    AVG(private_share) AS avg_private_share,
    AVG(guarantee_strength_index) AS avg_guarantee_strength,
    AVG(currency_risk_index) AS avg_currency_risk
FROM blended_finance_instruments
GROUP BY country_name;
