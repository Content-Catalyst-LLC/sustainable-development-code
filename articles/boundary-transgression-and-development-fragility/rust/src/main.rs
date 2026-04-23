use std::error::Error;
use std::fs;

#[derive(Debug)]
struct BoundaryRecord {
    country: String,
    region: String,
    climate_pressure_index: f64,
    freshwater_pressure_index: f64,
    biosphere_pressure_index: f64,
    land_system_pressure_index: f64,
    nutrient_pressure_index: f64,
    adaptive_capacity_index: f64,
    infrastructure_resilience_index: f64,
    equity_protection_index: f64,
    institutional_capacity_index: f64,
}

fn parse_record(line: &str) -> Result<BoundaryRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 11 {
        return Err("Invalid record length".into());
    }

    Ok(BoundaryRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        climate_pressure_index: parts[2].trim().parse()?,
        freshwater_pressure_index: parts[3].trim().parse()?,
        biosphere_pressure_index: parts[4].trim().parse()?,
        land_system_pressure_index: parts[5].trim().parse()?,
        nutrient_pressure_index: parts[6].trim().parse()?,
        adaptive_capacity_index: parts[7].trim().parse()?,
        infrastructure_resilience_index: parts[8].trim().parse()?,
        equity_protection_index: parts[9].trim().parse()?,
        institutional_capacity_index: parts[10].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &BoundaryRecord) -> bool {
    out_of_range(record.climate_pressure_index)
        || out_of_range(record.freshwater_pressure_index)
        || out_of_range(record.biosphere_pressure_index)
        || out_of_range(record.land_system_pressure_index)
        || out_of_range(record.nutrient_pressure_index)
        || out_of_range(record.adaptive_capacity_index)
        || out_of_range(record.infrastructure_resilience_index)
        || out_of_range(record.equity_protection_index)
        || out_of_range(record.institutional_capacity_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "boundary_pressure_fragility_data.csv";
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
