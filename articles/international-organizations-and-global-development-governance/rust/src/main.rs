use std::error::Error;
use std::fs;

#[derive(Debug)]
struct GovernanceRecord {
    country_or_regime: String,
    region: String,
    governance_domain: String,
    coordination_strength_index: f64,
    financing_support_index: f64,
    knowledge_standards_index: f64,
    implementation_support_index: f64,
    legitimacy_index: f64,
    resilience_coordination_index: f64,
    fragmentation_risk_index: f64,
    unequal_influence_risk_index: f64,
    institutional_lockin_risk_index: f64,
}

fn parse_record(line: &str) -> Result<GovernanceRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(GovernanceRecord {
        country_or_regime: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        governance_domain: parts[2].trim().to_string(),
        coordination_strength_index: parts[3].trim().parse()?,
        financing_support_index: parts[4].trim().parse()?,
        knowledge_standards_index: parts[5].trim().parse()?,
        implementation_support_index: parts[6].trim().parse()?,
        legitimacy_index: parts[7].trim().parse()?,
        resilience_coordination_index: parts[8].trim().parse()?,
        fragmentation_risk_index: parts[9].trim().parse()?,
        unequal_influence_risk_index: parts[10].trim().parse()?,
        institutional_lockin_risk_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &GovernanceRecord) -> bool {
    out_of_range(record.coordination_strength_index)
        || out_of_range(record.financing_support_index)
        || out_of_range(record.knowledge_standards_index)
        || out_of_range(record.implementation_support_index)
        || out_of_range(record.legitimacy_index)
        || out_of_range(record.resilience_coordination_index)
        || out_of_range(record.fragmentation_risk_index)
        || out_of_range(record.unequal_influence_risk_index)
        || out_of_range(record.institutional_lockin_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "global_development_governance_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country_or_regime={} governance_domain={}",
                record.country_or_regime, record.governance_domain
            );
        } else {
            println!(
                "VALID: country_or_regime={} governance_domain={}",
                record.country_or_regime, record.governance_domain
            );
        }
    }

    Ok(())
}
