CREATE TABLE development_viability_metrics (
    record_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    report_year INTEGER NOT NULL,
    ecological_integrity_index DECIMAL(5,4) NOT NULL,
    resilience_index DECIMAL(5,4) NOT NULL,
    governance_capacity_index DECIMAL(5,4) NOT NULL,
    justice_equity_index DECIMAL(5,4) NOT NULL,
    technology_capability_index DECIMAL(5,4) NOT NULL,
    shock_exposure_index DECIMAL(5,4) NOT NULL,
    institutional_fragility_index DECIMAL(5,4) NOT NULL
);

INSERT INTO development_viability_metrics (
    record_id,
    country_name,
    report_year,
    ecological_integrity_index,
    resilience_index,
    governance_capacity_index,
    justice_equity_index,
    technology_capability_index,
    shock_exposure_index,
    institutional_fragility_index
) VALUES
(1, 'Country A', 2026, 0.62, 0.58, 0.65, 0.51, 0.60, 0.42, 0.33),
(2, 'Country B', 2026, 0.48, 0.46, 0.52, 0.39, 0.44, 0.61, 0.57),
(3, 'Country C', 2026, 0.71, 0.68, 0.73, 0.59, 0.66, 0.35, 0.29);

SELECT
    country_name,
    report_year,
    ecological_integrity_index,
    resilience_index,
    governance_capacity_index,
    justice_equity_index,
    technology_capability_index,
    shock_exposure_index,
    institutional_fragility_index,
    (
        0.16 * 1.0 +
        0.20 * ecological_integrity_index +
        0.17 * resilience_index +
        0.16 * governance_capacity_index +
        0.13 * technology_capability_index +
        0.18 * justice_equity_index
    ) - (
        0.35 * ((0.55 * shock_exposure_index) + (0.45 * institutional_fragility_index))
    ) AS net_viability_score
FROM development_viability_metrics
WHERE report_year >= 2025
ORDER BY net_viability_score DESC, country_name ASC;
