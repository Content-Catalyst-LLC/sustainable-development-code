CREATE TABLE district_wash_metrics (
    district_id INTEGER PRIMARY KEY,
    district_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    report_year INTEGER NOT NULL,
    population INTEGER NOT NULL,
    safe_water_access_rate DECIMAL(5,4) NOT NULL,
    safe_sanitation_access_rate DECIMAL(5,4) NOT NULL,
    basic_hygiene_access_rate DECIMAL(5,4) NOT NULL,
    wastewater_treatment_rate DECIMAL(5,4) NOT NULL,
    non_revenue_water_rate DECIMAL(5,4) NOT NULL,
    annual_maintenance_gap_usd DECIMAL(18,2) NOT NULL,
    flood_risk_index DECIMAL(5,4) NOT NULL
);

INSERT INTO district_wash_metrics (
    district_id,
    district_name,
    region_name,
    report_year,
    population,
    safe_water_access_rate,
    safe_sanitation_access_rate,
    basic_hygiene_access_rate,
    wastewater_treatment_rate,
    non_revenue_water_rate,
    annual_maintenance_gap_usd,
    flood_risk_index
) VALUES
(1, 'North Valley', 'Highlands', 2026, 540000, 0.82, 0.61, 0.70, 0.45, 0.29, 4200000.00, 0.52),
(2, 'River Plain', 'Lowlands', 2026, 780000, 0.68, 0.49, 0.55, 0.31, 0.37, 6100000.00, 0.73),
(3, 'South Urban Edge', 'Metro Fringe', 2026, 920000, 0.76, 0.58, 0.63, 0.40, 0.33, 5100000.00, 0.64);

SELECT
    district_name,
    region_name,
    report_year,
    population,
    ROUND((1 - safe_water_access_rate) * population) AS people_without_safe_water,
    ROUND((1 - safe_sanitation_access_rate) * population) AS people_without_safe_sanitation,
    ROUND((1 - basic_hygiene_access_rate) * population) AS people_without_basic_hygiene,
    wastewater_treatment_rate,
    (
        ((1 - safe_water_access_rate) +
         (1 - safe_sanitation_access_rate) +
         (1 - basic_hygiene_access_rate)) / 3.0
    ) AS combined_gap_score
FROM district_wash_metrics
WHERE report_year = 2026
  AND (
      ((1 - safe_water_access_rate) +
       (1 - safe_sanitation_access_rate) +
       (1 - basic_hygiene_access_rate)) / 3.0
  ) >= 0.30
ORDER BY combined_gap_score DESC, population DESC;
