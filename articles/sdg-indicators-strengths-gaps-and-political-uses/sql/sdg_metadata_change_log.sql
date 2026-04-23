CREATE TABLE sdg_metadata_change_log (
    change_id INTEGER PRIMARY KEY,
    indicator_code VARCHAR(50) NOT NULL,
    change_year INTEGER NOT NULL,
    metadata_version VARCHAR(100) NOT NULL,
    change_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL
);

INSERT INTO sdg_metadata_change_log (
    change_id,
    indicator_code,
    change_year,
    metadata_version,
    change_type,
    description
) VALUES
(1, '1.1.1', 2025, 'v2025.1', 'methodology_update', 'Updated estimation guidance for poverty reporting comparability'),
(2, '5.4.1', 2025, 'v2025.1', 'disaggregation_update', 'Expanded reporting guidance for unpaid care distribution'),
(3, '13.1.1', 2025, 'v2025.1', 'metadata_clarification', 'Clarified institutional risk-reduction reporting definitions');
