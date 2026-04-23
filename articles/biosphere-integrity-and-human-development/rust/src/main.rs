use std::error::Error;
use std::fs;

#[derive(Debug)]
struct BiosphereRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    ecosystem_degradation_index: f64,
    fragmentation_risk_index: f64,
    ecological_service_erosion_index: f64,
    food_water_health_dependence_index: f64,
    livelihood_ecological_dependence_index: f64,
    justice_exposure_index: f64,
    governance_capacity_index: f64,
    restoration_readiness_index: f64,
    biosphere_function_loss_index: f64,
}

fn parse_record(line: &str) -> Result<BiosphereRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(BiosphereRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        ecosystem_degradation_index: parts[3].trim().parse()?,
        fragmentation_risk_index: parts[4].trim().parse()?,
        ecological_service_erosion_index: parts[5].trim().parse()?,
        food_water_health_dependence_index: parts[6].trim().parse()?,
        livelihood_ecological_dependence_index: parts[7].trim().parse()?,
        justice_exposure_index: parts[8].trim().parse()?,
        governance_capacity_index: parts[9].trim().parse()?,
        restoration_readiness_index: parts[10].trim().parse()?,
        biosphere_function_loss_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &BiosphereRecord) -> bool {
    out_of_range(record.ecosystem_degradation_index)
        || out_of_range(record.fragmentation_risk_index)
        || out_of_range(record.ecological_service_erosion_index)
        || out_of_range(record.food_water_health_dependence_index)
        || out_of_range(record.livelihood_ecological_dependence_index)
        || out_of_range(record.justice_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.restoration_readiness_index)
        || out_of_range(record.biosphere_function_loss_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "biosphere_integrity_panel.csv";
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
