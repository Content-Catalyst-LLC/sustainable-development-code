CREATE TABLE repayment_schedule_log (
    schedule_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    payment_year INTEGER NOT NULL,
    creditor_type VARCHAR(100) NOT NULL,
    currency_type VARCHAR(50) NOT NULL,
    principal_due DECIMAL(20,2) NOT NULL,
    interest_due DECIMAL(20,2) NOT NULL,
    government_revenue DECIMAL(20,2) NOT NULL,
    export_earnings DECIMAL(20,2) NOT NULL
);

INSERT INTO repayment_schedule_log (
    schedule_id,
    country_name,
    payment_year,
    creditor_type,
    currency_type,
    principal_due,
    interest_due,
    government_revenue,
    export_earnings
) VALUES
(1, 'Country A', 2026, 'bondholders', 'USD', 420000000.00, 95000000.00, 3200000000.00, 2700000000.00),
(2, 'Country B', 2026, 'multilateral', 'USD', 180000000.00, 22000000.00, 2100000000.00, 1600000000.00),
(3, 'Country C', 2026, 'bilateral', 'EUR', 250000000.00, 38000000.00, 1900000000.00, 1250000000.00);
