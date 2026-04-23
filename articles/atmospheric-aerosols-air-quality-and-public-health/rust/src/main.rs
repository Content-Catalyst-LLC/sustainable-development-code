use std::error::Error;
use std::fs;

#[derive(Debug)]
struct AerosolRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    ambient_pm25_index: f64,
    ambient_pm10_index: f64,
    household_energy_exposure_index: f64,
    transport_emissions_pressure_index: f64,
    industrial_source_pressure_index: f64,
    health_sensitivity_index: f64,
    mitigation_capacity_index: f64,
    exposure_inequality_index: f64,
    monitoring_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<AerosolRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(AerosolRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        ambient_pm25_index: parts[3].trim().parse()?,
        ambient_pm10_index: parts[4].trim().parse()?,
        household_energy_exposure_index: parts[5].trim().parse()?,
        transport_emissions_pressure_index: parts[6].trim().parse()?,
        industrial_source_pressure_index: parts[7].trim().parse()?,
        health_sensitivity_index: parts[8].trim().parse()?,
        mitigation_capacity_index: parts[9].trim().parse()?,
        exposure_inequality_index: parts[10].trim().parse()?,
        monitoring_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &AerosolRecord) -> bool {
    out_of_range(record.ambient_pm25_index)
        || out_of_range(record.ambient_pm10_index)
        || out_of_range(record.household_energy_exposure_index)
        || out_of_range(record.transport_emissions_pressure_index)
        || out_of_range(record.industrial_source_pressure_index)
        || out_of_range(record.health_sensitivity_index)
        || out_of_range(record.mitigation_capacity_index)
        || out_of_range(record.exposure_inequality_index)
        || out_of_range(record.monitoring_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "aerosols_air_quality_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: territory_name={} territory_type={}",
                record.territory_name, record.territory_type
            );
        } else {
            println!(
                "VALID: territory_name={} territory_type={}",
                record.territory_name, record.territory_type
            );
        }
    }

    Ok(())
}
