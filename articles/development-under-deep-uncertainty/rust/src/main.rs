use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ScenarioRecord {
    strategy_name: String,
    scenario_name: String,
    performance_score: f64,
    cost_score: f64,
    adaptability_score: f64,
    equity_score: f64,
}

fn parse_record(line: &str) -> Result<ScenarioRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 6 {
        return Err("Invalid record length".into());
    }

    Ok(ScenarioRecord {
        strategy_name: parts[0].trim().to_string(),
        scenario_name: parts[1].trim().to_string(),
        performance_score: parts[2].trim().parse()?,
        cost_score: parts[3].trim().parse()?,
        adaptability_score: parts[4].trim().parse()?,
        equity_score: parts[5].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ScenarioRecord) -> bool {
    out_of_range(record.performance_score)
        || out_of_range(record.cost_score)
        || out_of_range(record.adaptability_score)
        || out_of_range(record.equity_score)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "development_pathway_scenarios.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: strategy={} scenario={}",
                record.strategy_name, record.scenario_name
            );
        } else {
            println!(
                "VALID: strategy={} scenario={}",
                record.strategy_name, record.scenario_name
            );
        }
    }

    Ok(())
}
