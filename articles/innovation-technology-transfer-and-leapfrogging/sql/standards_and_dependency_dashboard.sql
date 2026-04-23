CREATE VIEW technology_dependency_dashboard AS
SELECT
    country_name,
    sector_name,
    COUNT(*) AS technologies_registered,
    AVG(local_adaptation_index) AS avg_local_adaptation,
    AVG(dependency_risk_index) AS avg_dependency_risk,
    AVG(standards_alignment_index) AS avg_standards_alignment
FROM technology_registry
GROUP BY country_name, sector_name;

CREATE VIEW transfer_agreement_requirements_dashboard AS
SELECT
    country_name,
    sector_name,
    COUNT(*) AS agreements_signed,
    AVG(CASE WHEN local_training_required THEN 1.0 ELSE 0.0 END) AS local_training_rate,
    AVG(CASE WHEN supplier_localization_required THEN 1.0 ELSE 0.0 END) AS supplier_localization_rate,
    AVG(CASE WHEN standards_transfer_required THEN 1.0 ELSE 0.0 END) AS standards_transfer_rate
FROM technology_transfer_agreements
GROUP BY country_name, sector_name;
