use std::error::Error;
use std::fs;

#[derive(Debug)]
struct GenderRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    education_access_index: f64,
    health_autonomy_index: f64,
    economic_participation_index: f64,
    care_burden_index: f64,
    violence_exposure_index: f64,
    institutional_power_gap_index: f64,
    property_rights_gap_index: f64,
    governance_capacity_index: f64,
    gender_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<GenderRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(GenderRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        education_access_index: parts[3].trim().parse()?,
        health_autonomy_index: parts[4].trim().parse()?,
        economic_participation_index: parts[5].trim().parse()?,
        care_burden_index: parts[6].trim().parse()?,
        violence_exposure_index: parts[7].trim().parse()?,
        institutional_power_gap_index: parts[8].trim().parse()?,
        property_rights_gap_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        gender_transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &GenderRecord) -> bool {
    out_of_range(record.education_access_index)
        || out_of_range(record.health_autonomy_index)
        || out_of_range(record.economic_participation_index)
        || out_of_range(record.care_burden_index)
        || out_of_range(record.violence_exposure_index)
        || out_of_range(record.institutional_power_gap_index)
        || out_of_range(record.property_rights_gap_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.gender_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "gender_exclusion_development_justice_panel.csv";
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
