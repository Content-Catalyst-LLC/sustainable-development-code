CREATE TABLE transgression_event_log (
    event_id INTEGER PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    event_year INTEGER NOT NULL,
    transgression_type VARCHAR(255) NOT NULL,
    severity_index DECIMAL(5,4) NOT NULL,
    food_system_impact_index DECIMAL(5,4) NOT NULL,
    water_system_impact_index DECIMAL(5,4) NOT NULL,
    health_system_impact_index DECIMAL(5,4) NOT NULL,
    notes TEXT
);

INSERT INTO transgression_event_log (
    event_id,
    country_name,
    event_year,
    transgression_type,
    severity_index,
    food_system_impact_index,
    water_system_impact_index,
    health_system_impact_index,
    notes
) VALUES
(1, 'Country A', 2026, 'Freshwater Stress', 0.76, 0.63, 0.81, 0.44, 'Persistent freshwater depletion affecting agriculture and water access'),
(2, 'Country B', 2026, 'Land-System Change', 0.68, 0.57, 0.42, 0.39, 'Rapid land conversion and habitat loss affecting ecosystem stability'),
(3, 'Country C', 2026, 'Climate Pressure', 0.84, 0.71, 0.67, 0.58, 'Heat and flood pressures intensifying across settlement and service systems');
