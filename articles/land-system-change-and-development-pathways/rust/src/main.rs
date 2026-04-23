use std::error::Error;
use std::fs;

#[derive(Debug)]
struct LandRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    conversion_pressure_index: f64,
    land_degradation_index: f64,
    fragmentation_risk_index: f64,
    biodiversity_function_loss_index: f64,
    food_settlement_dependence_index: f64,
    infrastructure_expansion_pressure_index: f64,
    justice_exposure_index: f64,
    governance_capacity_index: f64,
    restoration_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<LandRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(LandRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        conversion_pressure_index: parts[3].trim().parse()?,
        land_degradation_index: parts[4].trim().parse()?,
        fragmentation_risk_index: parts[5].trim().parse()?,
        biodiversity_function_loss_index: parts[6].trim().parse()?,
        food_settlement_dependence_index: parts[7].trim().parse()?,
        infrastructure_expansion_pressure_index: parts[8].trim().parse()?,
        justice_exposure_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        restoration_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &LandRecord) -> bool {
    out_of_range(record.conversion_pressure_index)
        || out_of_range(record.land_degradation_index)
        || out_of_range(record.fragmentation_risk_index)
        || out_of_range(record.biodiversity_function_loss_index)
        || out_of_range(record.food_settlement_dependence_index)
        || out_of_range(record.infrastructure_expansion_pressure_index)
        || out_of_range(record.justice_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.restoration_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "land_system_change_panel.csv";
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
