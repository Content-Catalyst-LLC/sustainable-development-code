use std::error::Error;
use std::fs;

#[derive(Debug)]
struct CapabilityRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    health_access_index: f64,
    education_access_index: f64,
    service_quality_index: f64,
    financial_hardship_risk_index: f64,
    learning_deprivation_index: f64,
    life_course_vulnerability_index: f64,
    inequality_exclusion_index: f64,
    governance_capacity_index: f64,
    capability_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<CapabilityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(CapabilityRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        health_access_index: parts[3].trim().parse()?,
        education_access_index: parts[4].trim().parse()?,
        service_quality_index: parts[5].trim().parse()?,
        financial_hardship_risk_index: parts[6].trim().parse()?,
        learning_deprivation_index: parts[7].trim().parse()?,
        life_course_vulnerability_index: parts[8].trim().parse()?,
        inequality_exclusion_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        capability_transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &CapabilityRecord) -> bool {
    out_of_range(record.health_access_index)
        || out_of_range(record.education_access_index)
        || out_of_range(record.service_quality_index)
        || out_of_range(record.financial_hardship_risk_index)
        || out_of_range(record.learning_deprivation_index)
        || out_of_range(record.life_course_vulnerability_index)
        || out_of_range(record.inequality_exclusion_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.capability_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "health_education_capability_panel.csv";
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
