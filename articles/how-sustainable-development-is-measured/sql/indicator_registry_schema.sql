CREATE TABLE development_indicator_registry (
    registry_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    goal VARCHAR(50) NOT NULL,
    indicator_code VARCHAR(50) NOT NULL,
    indicator_name TEXT NOT NULL,
    actual_value DECIMAL(18,6),
    target_value DECIMAL(18,6),
    direction VARCHAR(50) NOT NULL,
    lower_bound DECIMAL(18,6) NOT NULL,
    upper_bound DECIMAL(18,6) NOT NULL,
    weight DECIMAL(10,6) NOT NULL,
    source_name VARCHAR(255),
    metadata_version VARCHAR(100),
    reporting_year INTEGER NOT NULL
);
