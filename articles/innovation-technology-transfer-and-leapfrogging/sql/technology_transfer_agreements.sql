CREATE TABLE technology_transfer_agreements (
    agreement_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    provider_name VARCHAR(255) NOT NULL,
    technology_name VARCHAR(255) NOT NULL,
    transfer_mode VARCHAR(255) NOT NULL,
    local_training_required BOOLEAN NOT NULL,
    supplier_localization_required BOOLEAN NOT NULL,
    standards_transfer_required BOOLEAN NOT NULL,
    signed_year INTEGER NOT NULL
);

INSERT INTO technology_transfer_agreements (
    agreement_id,
    country_name,
    sector_name,
    provider_name,
    technology_name,
    transfer_mode,
    local_training_required,
    supplier_localization_required,
    standards_transfer_required,
    signed_year
) VALUES
(1, 'Country A', 'Energy', 'Provider X', 'Distributed Solar Microgrid', 'licensing_and_training', 1, 1, 1, 2026),
(2, 'Country B', 'Payments', 'Provider Y', 'Digital Payments Platform', 'platform_access', 0, 0, 1, 2026),
(3, 'Country C', 'Agriculture', 'Provider Z', 'Precision Irrigation System', 'equipment_and_support', 1, 1, 0, 2026);
