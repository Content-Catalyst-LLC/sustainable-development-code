CREATE TABLE resilience_registry (
    registry_id INTEGER PRIMARY KEY,
    system_name VARCHAR(255) NOT NULL,
    region_name VARCHAR(255) NOT NULL,
    year INTEGER NOT NULL,
    disturbance_exposure_index DECIMAL(5,4) NOT NULL,
    coping_capacity_index DECIMAL(5,4) NOT NULL,
    adaptive_capacity_index DECIMAL(5,4) NOT NULL,
    transformative_capacity_index DECIMAL(5,4) NOT NULL,
    institutional_learning_index DECIMAL(5,4) NOT NULL,
    ecological_buffer_index DECIMAL(5,4) NOT NULL,
    equity_protection_index DECIMAL(5,4) NOT NULL
);
