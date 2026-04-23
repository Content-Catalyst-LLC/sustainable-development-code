CREATE TABLE disturbance_event_log (
    event_id INTEGER PRIMARY KEY,
    system_name VARCHAR(255) NOT NULL,
    event_year INTEGER NOT NULL,
    disturbance_type VARCHAR(255) NOT NULL,
    severity_index DECIMAL(5,4) NOT NULL,
    coping_response_index DECIMAL(5,4) NOT NULL,
    adaptation_response_index DECIMAL(5,4) NOT NULL,
    notes TEXT
);

INSERT INTO disturbance_event_log (
    event_id,
    system_name,
    event_year,
    disturbance_type,
    severity_index,
    coping_response_index,
    adaptation_response_index,
    notes
) VALUES
(1, 'Urban Water Network', 2026, 'Drought', 0.71, 0.58, 0.46, 'Extended drought stressed water allocation and treatment capacity'),
(2, 'Regional Food System', 2026, 'Price Shock', 0.64, 0.52, 0.41, 'Input costs and trade bottlenecks intensified market stress'),
(3, 'Coastal Settlement System', 2026, 'Flood', 0.83, 0.47, 0.36, 'Major flood event exposed infrastructure and social protection gaps');
