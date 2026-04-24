CREATE TABLE embedded_fleet_registry (
    device_id VARCHAR(100) PRIMARY KEY,
    deployment_name VARCHAR(255) NOT NULL,
    device_name VARCHAR(255) NOT NULL,
    active_current_ma DECIMAL(10,4),
    sleep_current_ua DECIMAL(10,4),
    active_time_ms DECIMAL(10,4),
    wakeups_per_hour DECIMAL(10,4),
    battery_capacity_mah DECIMAL(10,4),
    inference_trigger_rate DECIMAL(10,4),
    reporting_year INTEGER NOT NULL
);
