use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ResilienceRecord {
    system_name: String,
    region: String,
    disturbance_exposure_index: f64,
    coping_capacity_index: f64,
    adaptive_capacity_index: f64,
    transformative_capacity_index: f64,
    institutional_learning_index: f64,
    ecological_buffer_index: f64,
    equity_protection_index: f64,
}

fn parse_record(line: &str) -> Result<ResilienceRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 9 {
        return Err("Invalid record length".into());
    }

    Ok(ResilienceRecord {
        system_name: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        disturbance_exposure_index: parts[2].trim().parse()?,
        coping_capacity_index: parts[3].trim().parse()?,
        adaptive_capacity_index: parts[4].trim().parse()?,
        transformative_capacity_index: parts[5].trim().parse()?,
        institutional_learning_index: parts[6].trim().parse()?,
        ecological_buffer_index: parts[7].trim().parse()?,
        equity_protection_index: parts[8].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ResilienceRecord) -> bool {
    out_of_range(record.disturbance_exposure_index)
        || out_of_range(record.coping_capacity_index)
        || out_of_range(record.adaptive_capacity_index)
        || out_of_range(record.transformative_capacity_index)
        || out_of_range(record.institutional_learning_index)
        || out_of_range(record.ecological_buffer_index)
        || out_of_range(record.equity_protection_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "resilience_system_data.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: system={} region={}",
                record.system_name, record.region
            );
        } else {
            println!(
                "VALID: system={} region={}",
                record.system_name, record.region
            );
        }
    }

    Ok(())
}
