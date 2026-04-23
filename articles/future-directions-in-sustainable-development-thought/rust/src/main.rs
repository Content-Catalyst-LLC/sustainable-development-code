use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ScenarioRecord {
    scenario: String,
    income_index: f64,
    ecological_integrity_index: f64,
    resilience_index: f64,
    governance_capacity_index: f64,
    technology_capability_index: f64,
    justice_equity_index: f64,
}

fn parse_record(line: &str) -> Result<ScenarioRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 7 {
        return Err("Invalid record length".into());
    }

    Ok(ScenarioRecord {
        scenario: parts[0].trim().to_string(),
        income_index: parts[1].trim().parse()?,
        ecological_integrity_index: parts[2].trim().parse()?,
        resilience_index: parts[3].trim().parse()?,
        governance_capacity_index: parts[4].trim().parse()?,
        technology_capability_index: parts[5].trim().parse()?,
        justice_equity_index: parts[6].trim().parse()?,
    })
}

fn is_out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn is_invalid(record: &ScenarioRecord) -> bool {
    is_out_of_range(record.income_index)
        || is_out_of_range(record.ecological_integrity_index)
        || is_out_of_range(record.resilience_index)
        || is_out_of_range(record.governance_capacity_index)
        || is_out_of_range(record.technology_capability_index)
        || is_out_of_range(record.justice_equity_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "future_development_scenarios.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if is_invalid(&record) {
            println!("INVALID: scenario={}", record.scenario);
        } else {
            println!("VALID: scenario={}", record.scenario);
        }
    }

    Ok(())
}
