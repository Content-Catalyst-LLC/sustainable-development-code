use std::error::Error;
use std::fs;

#[derive(Debug)]
struct InstitutionRecord {
    country: String,
    region: String,
    institutional_domain: String,
    implementation_capacity_index: f64,
    coordination_capacity_index: f64,
    trust_support_index: f64,
    accountability_strength_index: f64,
    delivery_system_reliability_index: f64,
    learning_capacity_index: f64,
    legal_administrative_clarity_index: f64,
    fragmentation_risk_index: f64,
    capture_risk_index: f64,
}

fn parse_record(line: &str) -> Result<InstitutionRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(InstitutionRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        institutional_domain: parts[2].trim().to_string(),
        implementation_capacity_index: parts[3].trim().parse()?,
        coordination_capacity_index: parts[4].trim().parse()?,
        trust_support_index: parts[5].trim().parse()?,
        accountability_strength_index: parts[6].trim().parse()?,
        delivery_system_reliability_index: parts[7].trim().parse()?,
        learning_capacity_index: parts[8].trim().parse()?,
        legal_administrative_clarity_index: parts[9].trim().parse()?,
        fragmentation_risk_index: parts[10].trim().parse()?,
        capture_risk_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &InstitutionRecord) -> bool {
    out_of_range(record.implementation_capacity_index)
        || out_of_range(record.coordination_capacity_index)
        || out_of_range(record.trust_support_index)
        || out_of_range(record.accountability_strength_index)
        || out_of_range(record.delivery_system_reliability_index)
        || out_of_range(record.learning_capacity_index)
        || out_of_range(record.legal_administrative_clarity_index)
        || out_of_range(record.fragmentation_risk_index)
        || out_of_range(record.capture_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "institutions_development_panel.csv";
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
