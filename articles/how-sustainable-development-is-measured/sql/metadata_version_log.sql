CREATE TABLE metadata_version_log (
    change_id INTEGER PRIMARY KEY,
    indicator_code VARCHAR(50) NOT NULL,
    change_year INTEGER NOT NULL,
    metadata_version VARCHAR(100) NOT NULL,
    change_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL
);

INSERT INTO metadata_version_log (
    change_id,
    indicator_code,
    change_year,
    metadata_version,
    change_type,
    description
) VALUES
(1, '1.1.1', 2025, 'v2025.1', 'methodology_update', 'Updated comparability guidance for poverty reporting'),
(2, '4.1.1', 2025, 'v2025.1', 'metadata_clarification', 'Clarified learning outcome measurement notes'),
(3, '16.6.2', 2025, 'v2025.1', 'classification_update', 'Adjusted transparency and institutional reporting guidance');
