use std::error::Error;
use std::fs;

#[derive(Debug)]
struct UrbanRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    housing_adequacy_index: f64,
    housing_affordability_stress_index: f64,
    basic_services_access_index: f64,
    informality_exclusion_index: f64,
    mobility_access_index: f64,
    resilience_weakness_index: f64,
    justice_exposure_index: f64,
    governance_capacity_index: f64,
    urban_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<UrbanRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(UrbanRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        housing_adequacy_index: parts[3].trim().parse()?,
        housing_affordability_stress_index: parts[4].trim().parse()?,
        basic_services_access_index: parts[5].trim().parse()?,
        informality_exclusion_index: parts[6].trim().parse()?,
        mobility_access_index: parts[7].trim().parse()?,
        resilience_weakness_index: parts[8].trim().parse()?,
        justice_exposure_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        urban_transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &UrbanRecord) -> bool {
    out_of_range(record.housing_adequacy_index)
        || out_of_range(record.housing_affordability_stress_index)
        || out_of_range(record.basic_services_access_index)
        || out_of_range(record.informality_exclusion_index)
        || out_of_range(record.mobility_access_index)
        || out_of_range(record.resilience_weakness_index)
        || out_of_range(record.justice_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.urban_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "urbanization_housing_services_panel.csv";
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
