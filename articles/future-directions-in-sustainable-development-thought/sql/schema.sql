CREATE TABLE IF NOT EXISTS scenario_scores (
    scenario TEXT PRIMARY KEY,
    income_index REAL NOT NULL CHECK (income_index BETWEEN 0 AND 1),
    ecological_integrity_index REAL NOT NULL CHECK (ecological_integrity_index BETWEEN 0 AND 1),
    resilience_index REAL NOT NULL CHECK (resilience_index BETWEEN 0 AND 1),
    governance_capacity_index REAL NOT NULL CHECK (governance_capacity_index BETWEEN 0 AND 1),
    technology_capability_index REAL NOT NULL CHECK (technology_capability_index BETWEEN 0 AND 1),
    justice_equity_index REAL NOT NULL CHECK (justice_equity_index BETWEEN 0 AND 1),
    planetary_pressure_index REAL NOT NULL CHECK (planetary_pressure_index BETWEEN 0 AND 1),
    institutional_stress_index REAL NOT NULL CHECK (institutional_stress_index BETWEEN 0 AND 1)
);

CREATE TABLE IF NOT EXISTS development_panel (
    country TEXT NOT NULL,
    year INTEGER NOT NULL,
    income_index REAL NOT NULL CHECK (income_index BETWEEN 0 AND 1),
    ecological_integrity_index REAL NOT NULL CHECK (ecological_integrity_index BETWEEN 0 AND 1),
    resilience_index REAL NOT NULL CHECK (resilience_index BETWEEN 0 AND 1),
    governance_capacity_index REAL NOT NULL CHECK (governance_capacity_index BETWEEN 0 AND 1),
    technology_capability_index REAL NOT NULL CHECK (technology_capability_index BETWEEN 0 AND 1),
    justice_equity_index REAL NOT NULL CHECK (justice_equity_index BETWEEN 0 AND 1),
    planetary_pressure_index REAL NOT NULL CHECK (planetary_pressure_index BETWEEN 0 AND 1),
    institutional_stress_index REAL NOT NULL CHECK (institutional_stress_index BETWEEN 0 AND 1),
    PRIMARY KEY (country, year)
);

CREATE TABLE IF NOT EXISTS policy_levers (
    lever_id TEXT PRIMARY KEY,
    lever_name TEXT NOT NULL,
    target_dimension TEXT NOT NULL,
    expected_effect REAL NOT NULL,
    risk_reduction_logic TEXT NOT NULL,
    implementation_horizon TEXT NOT NULL
);
