use std::error::Error;
use std::fs;

#[derive(Debug)]
struct IntergenerationalRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    future_burden_transfer_index: f64,
    ecological_degradation_index: f64,
    institutional_erosion_index: f64,
    public_debt_lock_in_index: f64,
    infrastructure_lock_in_index: f64,
    climate_risk_transfer_index: f64,
    future_representation_gap_index: f64,
    governance_capacity_index: f64,
    precautionary_planning_index: f64,
    resilience_preservation_index: f64,
    justice_exposure_index: f64,
}

fn parse_record(line: &str) -> Result<IntergenerationalRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(IntergenerationalRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        future_burden_transfer_index: parts[3].trim().parse()?,
        ecological_degradation_index: parts[4].trim().parse()?,
        institutional_erosion_index: parts[5].trim().parse()?,
        public_debt_lock_in_index: parts[6].trim().parse()?,
        infrastructure_lock_in_index: parts[7].trim().parse()?,
        climate_risk_transfer_index: parts[8].trim().parse()?,
        future_representation_gap_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        precautionary_planning_index: parts[11].trim().parse()?,
        resilience_preservation_index: parts[12].trim().parse()?,
        justice_exposure_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &IntergenerationalRecord) -> bool {
    out_of_range(record.future_burden_transfer_index)
        || out_of_range(record.ecological_degradation_index)
        || out_of_range(record.institutional_erosion_index)
        || out_of_range(record.public_debt_lock_in_index)
        || out_of_range(record.infrastructure_lock_in_index)
        || out_of_range(record.climate_risk_transfer_index)
        || out_of_range(record.future_representation_gap_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.precautionary_planning_index)
        || out_of_range(record.resilience_preservation_index)
        || out_of_range(record.justice_exposure_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "intergenerational_justice_long_term_stewardship_panel.csv";
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
