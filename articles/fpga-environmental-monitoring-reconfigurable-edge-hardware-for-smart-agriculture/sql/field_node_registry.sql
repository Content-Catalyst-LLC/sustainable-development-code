CREATE TABLE field_node_registry (
    node_id VARCHAR(100) PRIMARY KEY,
    deployment_name VARCHAR(255) NOT NULL,
    sensor_count INTEGER,
    raw_samples_per_sec DECIMAL(12,4),
    edge_reduction_ratio DECIMAL(10,4),
    local_processing_latency_ms DECIMAL(12,4),
    uplink_latency_ms DECIMAL(12,4),
    power_budget_mw DECIMAL(12,4),
    reporting_year INTEGER NOT NULL
);
