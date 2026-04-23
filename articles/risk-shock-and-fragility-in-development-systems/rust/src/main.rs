use std::error::Error;
use std::fs;

#[derive(Debug)]
struct FragilityRecord {
    country: String,
    region: String,
    shock_exposure_index: f64,
    climate_risk_index: f64,
    food_system_stress_index: f64,
    institutional_capacity_index: f64,
    infrastructure_resilience_index: f64,
    social_protection_index: f64,
    inequality_burden_index: f64,
    fiscal_space_index: f64,
}

fn parse_record(line: &str) -> Result<FragilityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 10 {
        return Err("Invalid record length".into());
    }

    Ok(FragilityRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        shock_exposure_index: parts[2].trim().parse()?,
        climate_risk_index: parts[3].trim().parse()?,
        food_system_stress_index: parts[4].trim().parse()?,
        institutional_capacity_index: parts[5].trim().parse()?,
        infrastructure_resilience_index: parts[6].trim().parse()?,
        social_protection_index: parts[7].trim().parse()?,
        inequality_burden_index: parts[8].trim().parse()?,
        fiscal_space_index: parts[9].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &FragilityRecord) -> bool {
    out_of_range(record.shock_exposure_index)
        || out_of_range(record.climate_risk_index)
        || out_of_range(record.food_system_stress_index)
        || out_of_range(record.institutional_capacity_index)
        || out_of_range(record.infrastructure_resilience_index)
        || out_of_range(record.social_protection_index)
        || out_of_range(record.inequality_burden_index)
        || out_of_range(record.fiscal_space_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "development_fragility_risk_data.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} region={}",
                record.country, record.region
            );
        } else {
            println!(
                "VALID: country={} region={}",
                record.country, record.region
            );
        }
    }

    Ok(())
}
