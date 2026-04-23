use std::error::Error;
use std::fs;

#[derive(Debug)]
struct IntegrityRecord {
    country: String,
    region: String,
    institutional_domain: String,
    procurement_integrity_index: f64,
    accountability_strength_index: f64,
    service_integrity_index: f64,
    beneficial_ownership_visibility_index: f64,
    audit_capacity_index: f64,
    complaint_access_index: f64,
    trust_support_index: f64,
    capture_risk_index: f64,
    selective_enforcement_risk_index: f64,
    corruption_visibility_gap_index: f64,
}

fn parse_record(line: &str) -> Result<IntegrityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(IntegrityRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        institutional_domain: parts[2].trim().to_string(),
        procurement_integrity_index: parts[3].trim().parse()?,
        accountability_strength_index: parts[4].trim().parse()?,
        service_integrity_index: parts[5].trim().parse()?,
        beneficial_ownership_visibility_index: parts[6].trim().parse()?,
        audit_capacity_index: parts[7].trim().parse()?,
        complaint_access_index: parts[8].trim().parse()?,
        trust_support_index: parts[9].trim().parse()?,
        capture_risk_index: parts[10].trim().parse()?,
        selective_enforcement_risk_index: parts[11].trim().parse()?,
        corruption_visibility_gap_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &IntegrityRecord) -> bool {
    out_of_range(record.procurement_integrity_index)
        || out_of_range(record.accountability_strength_index)
        || out_of_range(record.service_integrity_index)
        || out_of_range(record.beneficial_ownership_visibility_index)
        || out_of_range(record.audit_capacity_index)
        || out_of_range(record.complaint_access_index)
        || out_of_range(record.trust_support_index)
        || out_of_range(record.capture_risk_index)
        || out_of_range(record.selective_enforcement_risk_index)
        || out_of_range(record.corruption_visibility_gap_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "corruption_integrity_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} institutional_domain={}",
                record.country, record.institutional_domain
            );
        } else {
            println!(
                "VALID: country={} institutional_domain={}",
                record.country, record.institutional_domain
            );
        }
    }

    Ok(())
}
