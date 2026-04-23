CREATE TABLE pathway_decision_log (
    decision_id INTEGER PRIMARY KEY,
    strategy_name VARCHAR(255) NOT NULL,
    scenario_name VARCHAR(255) NOT NULL,
    decision_date DATE NOT NULL,
    decision_owner VARCHAR(255) NOT NULL,
    rationale TEXT,
    revision_trigger TEXT,
    review_interval_months INTEGER NOT NULL
);

INSERT INTO pathway_decision_log (
    decision_id,
    strategy_name,
    scenario_name,
    decision_date,
    decision_owner,
    rationale,
    revision_trigger,
    review_interval_months
) VALUES
(1, 'Adaptive Infrastructure', 'moderate / cooperative / broad / strong', '2026-04-22', 'Planning Unit', 'Chosen for robustness across climate and trade uncertainty', 'Extreme climate signal or debt shock', 12),
(2, 'Industrial Export Push', 'severe / fragmented / concentrated / stressed', '2026-04-22', 'Economic Strategy Unit', 'Conditional strategy with high sensitivity to geopolitical fragmentation', 'Trade disruption or technology denial', 6);
