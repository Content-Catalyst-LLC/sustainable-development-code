use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ThresholdRecord {
    system_name: String,
    country_or_region: String,
    ecosystem_type: String,
    cumulative_pressure_index: f64,
    slow_variable_deterioration_index: f64,
    feedback_intensity_index: f64,
    cascade_exposure_index: f64,
    resilience_buffer_index: f64,
    recovery_difficulty_index: f64,
    monitoring_readiness_index: f64,
    precaution_capacity_index: f64,
    justice_exposure_index: f64,
}

fn parse_record(line: &str) -> Result<ThresholdRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(ThresholdRecord {
        system_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        ecosystem_type: parts[2].trim().to_string(),
        cumulative_pressure_index: parts[3].trim().parse()?,
        slow_variable_deterioration_index: parts[4].trim().parse()?,
        feedback_intensity_index: parts[5].trim().parse()?,
        cascade_exposure_index: parts[6].trim().parse()?,
        resilience_buffer_index: parts[7].trim().parse()?,
        recovery_difficulty_index: parts[8].trim().parse()?,
        monitoring_readiness_index: parts[9].trim().parse()?,
        precaution_capacity_index: parts[10].trim().parse()?,
        justice_exposure_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ThresholdRecord) -> bool {
    out_of_range(record.cumulative_pressure_index)
        || out_of_range(record.slow_variable_deterioration_index)
        || out_of_range(record.feedback_intensity_index)
        || out_of_range(record.cascade_exposure_index)
        || out_of_range(record.resilience_buffer_index)
        || out_of_range(record.recovery_difficulty_index)
        || out_of_range(record.monitoring_readiness_index)
        || out_of_range(record.precaution_capacity_index)
        || out_of_range(record.justice_exposure_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "ecological_thresholds_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: system_name={} ecosystem_type={}",
                record.system_name, record.ecosystem_type
            );
        } else {
            println!(
                "VALID: system_name={} ecosystem_type={}",
                record.system_name, record.ecosystem_type
            );
        }
    }

    Ok(())
}
