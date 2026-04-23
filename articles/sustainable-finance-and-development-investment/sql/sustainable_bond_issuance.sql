CREATE TABLE sustainable_bond_issuance (
    issuance_id INTEGER PRIMARY KEY,
    issuer_name VARCHAR(255) NOT NULL,
    issuer_type VARCHAR(100) NOT NULL,
    country_name VARCHAR(255),
    bond_label VARCHAR(100) NOT NULL,
    issuance_size_usd DECIMAL(20,2) NOT NULL,
    use_of_proceeds_sector VARCHAR(255) NOT NULL,
    reporting_year INTEGER NOT NULL
);

INSERT INTO sustainable_bond_issuance (
    issuance_id,
    issuer_name,
    issuer_type,
    country_name,
    bond_label,
    issuance_size_usd,
    use_of_proceeds_sector,
    reporting_year
) VALUES
(1, 'Development Bank A', 'multilateral', NULL, 'sustainability_bond', 1500000000.00, 'resilient_infrastructure', 2026),
(2, 'Sovereign B', 'sovereign', 'Country B', 'green_bond', 850000000.00, 'energy_transition', 2026),
(3, 'City C', 'subnational', 'Country C', 'social_bond', 220000000.00, 'inclusive_transport', 2026);
