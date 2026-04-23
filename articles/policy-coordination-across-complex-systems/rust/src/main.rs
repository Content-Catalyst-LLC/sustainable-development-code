use std::error::Error;
use std::fs;

#[derive(Debug)]
struct PolicyRecord {
    country: String,
    region: String,
    policy_domain: String,
    cross_sector_alignment_index: f64,
    spillover_management_index: f64,
    tradeoff_visibility_index: f64,
    synergy_capture_index: f64,
    implementation_alignment_index: f64,
    multilevel_coordination_index: f64,
    data_visibility_index: f64,
    institutional_learning_index: f64,
    resilience_integration_index: f64,
    lock_in_risk_index: f64,
}

fn parse_record(line: &str) -> Result<PolicyRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(PolicyRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        policy_domain: parts[2].trim().to_string(),
        cross_sector_alignment_index: parts[3].trim().parse()?,
        spillover_management_index: parts[4].trim().parse()?,
        tradeoff_visibility_index: parts[5].trim().parse()?,
        synergy_capture_index: parts[6].trim().parse()?,
        implementation_alignment_index: parts[7].trim().parse()?,
        multilevel_coordination_index: parts[8].trim().parse()?,
        data_visibility_index: parts[9].trim().parse()?,
        institutional_learning_index: parts[10].trim().parse()?,
        resilience_integration_index: parts[11].trim().parse()?,
        lock_in_risk_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &PolicyRecord) -> bool {
    out_of_range(record.cross_sector_alignment_index)
        || out_of_range(record.spillover_management_index)
        || out_of_range(record.tradeoff_visibility_index)
        || out_of_range(record.synergy_capture_index)
        || out_of_range(record.implementation_alignment_index)
        || out_of_range(record.multilevel_coordination_index)
        || out_of_range(record.data_visibility_index)
        || out_of_range(record.institutional_learning_index)
        || out_of_range(record.resilience_integration_index)
        || out_of_range(record.lock_in_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "policy_coherence_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} policy_domain={}",
                record.country, record.policy_domain
            );
        } else {
            println!(
                "VALID: country={} policy_domain={}",
                record.country, record.policy_domain
            );
        }
    }

    Ok(())
}
