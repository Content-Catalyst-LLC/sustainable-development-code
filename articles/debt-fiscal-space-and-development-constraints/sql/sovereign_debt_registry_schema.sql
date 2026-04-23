CREATE TABLE sovereign_debt_registry (
    debt_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    reporting_year INTEGER NOT NULL,
    instrument_name VARCHAR(255) NOT NULL,
    creditor_type VARCHAR(100) NOT NULL,
    currency_type VARCHAR(50) NOT NULL,
    principal_outstanding DECIMAL(20,2) NOT NULL,
    interest_rate DECIMAL(8,4) NOT NULL,
    maturity_years DECIMAL(8,2) NOT NULL,
    concessional_flag BOOLEAN NOT NULL,
    guaranteed_flag BOOLEAN NOT NULL
);
