CREATE TABLE ai_governance_projects (
    project_id INTEGER PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    assessment_year INTEGER NOT NULL,
    data_quality_index DECIMAL(5,4) NOT NULL,
    institutional_capacity_index DECIMAL(5,4) NOT NULL,
    compute_infrastructure_index DECIMAL(5,4) NOT NULL,
    algorithmic_capability_index DECIMAL(5,4) NOT NULL,
    equity_accountability_index DECIMAL(5,4) NOT NULL,
    interoperability_index DECIMAL(5,4) NOT NULL,
    bias_risk_index DECIMAL(5,4) NOT NULL,
    opacity_risk_index DECIMAL(5,4) NOT NULL,
    surveillance_risk_index DECIMAL(5,4) NOT NULL,
    vendor_lockin_risk_index DECIMAL(5,4) NOT NULL
);

INSERT INTO ai_governance_projects (
    project_id,
    project_name,
    country_name,
    sector_name,
    assessment_year,
    data_quality_index,
    institutional_capacity_index,
    compute_infrastructure_index,
    algorithmic_capability_index,
    equity_accountability_index,
    interoperability_index,
    bias_risk_index,
    opacity_risk_index,
    surveillance_risk_index,
    vendor_lockin_risk_index
) VALUES
(1, 'Benefits Eligibility Triage', 'Country A', 'Social Protection', 2026, 0.76, 0.68, 0.61, 0.57, 0.66, 0.72, 0.28, 0.31, 0.34, 0.45),
(2, 'Tax Compliance Risk Scoring', 'Country A', 'Tax Administration', 2026, 0.70, 0.63, 0.65, 0.62, 0.51, 0.69, 0.42, 0.48, 0.39, 0.52),
(3, 'Hospital Triage Assistant', 'Country B', 'Health', 2026, 0.59, 0.55, 0.47, 0.58, 0.49, 0.50, 0.37, 0.41, 0.30, 0.44);

CREATE VIEW ai_governance_project_scores AS
SELECT
    project_id,
    project_name,
    country_name,
    sector_name,
    assessment_year,
    (
        0.22 * data_quality_index +
        0.22 * institutional_capacity_index +
        0.14 * compute_infrastructure_index +
        0.16 * algorithmic_capability_index +
        0.14 * equity_accountability_index +
        0.12 * interoperability_index
    ) AS readiness_score,
    (
        0.30 * bias_risk_index +
        0.25 * opacity_risk_index +
        0.25 * surveillance_risk_index +
        0.20 * vendor_lockin_risk_index
    ) AS governance_risk_score,
    (
        (
            0.22 * data_quality_index +
            0.22 * institutional_capacity_index +
            0.14 * compute_infrastructure_index +
            0.16 * algorithmic_capability_index +
            0.14 * equity_accountability_index +
            0.12 * interoperability_index
        ) - (
            0.50 * (
                0.30 * bias_risk_index +
                0.25 * opacity_risk_index +
                0.25 * surveillance_risk_index +
                0.20 * vendor_lockin_risk_index
            )
        )
    ) AS net_public_value_score
FROM ai_governance_projects;

SELECT
    country_name,
    sector_name,
    AVG(readiness_score) AS avg_readiness_score,
    AVG(governance_risk_score) AS avg_governance_risk_score,
    AVG(net_public_value_score) AS avg_net_public_value_score,
    COUNT(*) AS project_count
FROM ai_governance_project_scores
GROUP BY country_name, sector_name
ORDER BY avg_net_public_value_score DESC, country_name ASC, sector_name ASC;
