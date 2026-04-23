CREATE VIEW debt_service_dashboard AS
SELECT
    country_name,
    payment_year,
    SUM(principal_due + interest_due) AS total_service_due,
    AVG((principal_due + interest_due) / government_revenue) AS avg_service_revenue_ratio,
    AVG((principal_due + interest_due) / export_earnings) AS avg_service_export_ratio
FROM repayment_schedule_log
GROUP BY country_name, payment_year;

CREATE VIEW creditor_composition_dashboard AS
SELECT
    country_name,
    reporting_year,
    creditor_type,
    currency_type,
    SUM(principal_outstanding) AS total_principal_outstanding,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(maturity_years) AS avg_maturity_years
FROM sovereign_debt_registry
GROUP BY country_name, reporting_year, creditor_type, currency_type;
