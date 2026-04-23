CREATE TABLE scenario_registry (
    scenario_id INTEGER PRIMARY KEY,
    scenario_name VARCHAR(255) NOT NULL,
    climate_path VARCHAR(100) NOT NULL,
    trade_order VARCHAR(100) NOT NULL,
    technology_diffusion VARCHAR(100) NOT NULL,
    governance_capacity VARCHAR(100) NOT NULL,
    narrative_summary TEXT
);

CREATE TABLE strategy_registry (
    strategy_id INTEGER PRIMARY KEY,
    strategy_name VARCHAR(255) NOT NULL,
    sector_name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE scenario_strategy_performance (
    record_id INTEGER PRIMARY KEY,
    scenario_id INTEGER NOT NULL,
    strategy_id INTEGER NOT NULL,
    assessment_year INTEGER NOT NULL,
    performance_score DECIMAL(5,4) NOT NULL,
    cost_score DECIMAL(5,4) NOT NULL,
    adaptability_score DECIMAL(5,4) NOT NULL,
    equity_score DECIMAL(5,4) NOT NULL,
    FOREIGN KEY (scenario_id) REFERENCES scenario_registry(scenario_id),
    FOREIGN KEY (strategy_id) REFERENCES strategy_registry(strategy_id)
);
