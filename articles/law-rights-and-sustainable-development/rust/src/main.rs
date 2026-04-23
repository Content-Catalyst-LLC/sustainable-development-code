use std::error::Error;
use std::fs;

#[derive(Debug)]
struct LawRecord {
    country: String,
    region: String,
    legal_domain: String,
    rights_protection_index: f64,
    access_to_justice_index: f64,
    procedural_participation_index: f64,
    environmental_rights_integration_index: f64,
    accountability_structure_index: f64,
    non_discrimination_protection_index: f64,
    administrative_review_index: f64,
    enforcement_capacity_index: f64,
    legal_exclusion_risk_index: f64,
}

fn parse_record(line: &str) -> Result<LawRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(LawRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        legal_domain: parts[2].trim().to_string(),
        rights_protection_index: parts[3].trim().parse()?,
        access_to_justice_index: parts[4].trim().parse()?,
        procedural_participation_index: parts[5].trim().parse()?,
        environmental_rights_integration_index: parts[6].trim().parse()?,
        accountability_structure_index: parts[7].trim().parse()?,
        non_discrimination_protection_index: parts[8].trim().parse()?,
        administrative_review_index: parts[9].trim().parse()?,
        enforcement_capacity_index: parts[10].trim().parse()?,
        legal_exclusion_risk_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &LawRecord) -> bool {
    out_of_range(record.rights_protection_index)
        || out_of_range(record.access_to_justice_index)
        || out_of_range(record.procedural_participation_index)
        || out_of_range(record.environmental_rights_integration_index)
        || out_of_range(record.accountability_structure_index)
        || out_of_range(record.non_discrimination_protection_index)
        || out_of_range(record.administrative_review_index)
        || out_of_range(record.enforcement_capacity_index)
        || out_of_range(record.legal_exclusion_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "law_rights_development_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} legal_domain={}",
                record.country, record.legal_domain
            );
        } else {
            println!(
                "VALID: country={} legal_domain={}",
                record.country, record.legal_domain
            );
        }
    }

    Ok(())
}
