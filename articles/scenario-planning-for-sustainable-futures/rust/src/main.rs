use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ScenarioRecord {
    scenario_name: String,
    climate_path: String,
    trade_order: String,
    technology_diffusion: String,
    governance_capacity: String,
}

fn parse_record(line: &str) -> Result<ScenarioRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 5 {
        return Err("Invalid record length".into());
    }

    Ok(ScenarioRecord {
        scenario_name: parts[0].trim().to_string(),
        climate_path: parts[1].trim().to_string(),
        trade_order: parts[2].trim().to_string(),
        technology_diffusion: parts[3].trim().to_string(),
        governance_capacity: parts[4].trim().to_string(),
    })
}

fn is_empty_field(value: &str) -> bool {
    value.trim().is_empty()
}

fn invalid_record(record: &ScenarioRecord) -> bool {
    is_empty_field(&record.scenario_name)
        || is_empty_field(&record.climate_path)
        || is_empty_field(&record.trade_order)
        || is_empty_field(&record.technology_diffusion)
        || is_empty_field(&record.governance_capacity)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "scenario_matrix.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!("INVALID: scenario={}", record.scenario_name);
        } else {
            println!("VALID: scenario={}", record.scenario_name);
        }
    }

    Ok(())
}
