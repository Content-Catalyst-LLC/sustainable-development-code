CREATE TABLE shock_event_log (
    event_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    event_year INTEGER NOT NULL,
    shock_type VARCHAR(255) NOT NULL,
    severity_index DECIMAL(5,4) NOT NULL,
    infrastructure_impact_index DECIMAL(5,4) NOT NULL,
    livelihood_impact_index DECIMAL(5,4) NOT NULL,
    response_capacity_index DECIMAL(5,4) NOT NULL,
    notes TEXT
);

INSERT INTO shock_event_log (
    event_id,
    country_name,
    event_year,
    shock_type,
    severity_index,
    infrastructure_impact_index,
    livelihood_impact_index,
    response_capacity_index,
    notes
) VALUES
(1, 'Country A', 2026, 'Flood', 0.74, 0.68, 0.59, 0.52, 'Severe regional flood with infrastructure disruption'),
(2, 'Country B', 2026, 'Food Price Shock', 0.61, 0.34, 0.71, 0.43, 'Imported food inflation intensified household stress'),
(3, 'Country C', 2026, 'Conflict Escalation', 0.82, 0.73, 0.77, 0.31, 'Security deterioration with major displacement impacts');
