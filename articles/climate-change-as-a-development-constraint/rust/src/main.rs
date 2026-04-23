use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ClimateRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    heat_stress_index: f64,
    hydrological_disruption_index: f64,
    food_livelihood_exposure_index: f64,
    health_burden_index: f64,
    infrastructure_vulnerability_index: f64,
    justice_exposure_index: f64,
    governance_capacity_index: f64,
    resilience_readiness_index: f64,
    disaster_recurrence_index: f64,
}

fn parse_record(line: &str) -> Result<ClimateRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(ClimateRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        heat_stress_index: parts[3].trim().parse()?,
        hydrological_disruption_index: parts[4].trim().parse()?,
        food_livelihood_exposure_index: parts[5].trim().parse()?,
        health_burden_index: parts[6].trim().parse()?,
        infrastructure_vulnerability_index: parts[7].trim().parse()?,
        justice_exposure_index: parts[8].trim().parse()?,
        governance_capacity_index: parts[9].trim().parse()?,
        resilience_readiness_index: parts[10].trim().parse()?,
        disaster_recurrence_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ClimateRecord) -> bool {
    out_of_range(record.heat_stress_index)
        || out_of_range(record.hydrological_disruption_index)
        || out_of_range(record.food_livelihood_exposure_index)
        || out_of_range(record.health_burden_index)
        || out_of_range(record.infrastructure_vulnerability_index)
        || out_of_range(record.justice_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.resilience_readiness_index)
        || out_of_range(record.disaster_recurrence_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "climate_constraint_panel.csv";
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
