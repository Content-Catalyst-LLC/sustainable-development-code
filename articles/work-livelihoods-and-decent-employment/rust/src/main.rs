use std::error::Error;
use std::fs;

#[derive(Debug)]
struct WorkRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    employment_access_index: f64,
    informality_risk_index: f64,
    precarity_risk_index: f64,
    income_security_index: f64,
    social_protection_coverage_index: f64,
    labour_rights_exposure_index: f64,
    youth_exclusion_index: f64,
    gender_livelihood_gap_index: f64,
    transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<WorkRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(WorkRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        employment_access_index: parts[3].trim().parse()?,
        informality_risk_index: parts[4].trim().parse()?,
        precarity_risk_index: parts[5].trim().parse()?,
        income_security_index: parts[6].trim().parse()?,
        social_protection_coverage_index: parts[7].trim().parse()?,
        labour_rights_exposure_index: parts[8].trim().parse()?,
        youth_exclusion_index: parts[9].trim().parse()?,
        gender_livelihood_gap_index: parts[10].trim().parse()?,
        transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &WorkRecord) -> bool {
    out_of_range(record.employment_access_index)
        || out_of_range(record.informality_risk_index)
        || out_of_range(record.precarity_risk_index)
        || out_of_range(record.income_security_index)
        || out_of_range(record.social_protection_coverage_index)
        || out_of_range(record.labour_rights_exposure_index)
        || out_of_range(record.youth_exclusion_index)
        || out_of_range(record.gender_livelihood_gap_index)
        || out_of_range(record.transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "work_livelihoods_panel.csv";
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
