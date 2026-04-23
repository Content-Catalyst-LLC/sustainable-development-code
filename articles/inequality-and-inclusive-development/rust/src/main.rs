use std::error::Error;
use std::fs;

#[derive(Debug)]
struct InclusionRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    education_access_index: f64,
    health_access_index: f64,
    income_security_index: f64,
    public_goods_access_index: f64,
    opportunity_blockage_index: f64,
    risk_exposure_index: f64,
    institutional_capture_index: f64,
    governance_capacity_index: f64,
    inclusive_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<InclusionRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(InclusionRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        education_access_index: parts[3].trim().parse()?,
        health_access_index: parts[4].trim().parse()?,
        income_security_index: parts[5].trim().parse()?,
        public_goods_access_index: parts[6].trim().parse()?,
        opportunity_blockage_index: parts[7].trim().parse()?,
        risk_exposure_index: parts[8].trim().parse()?,
        institutional_capture_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        inclusive_transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &InclusionRecord) -> bool {
    out_of_range(record.education_access_index)
        || out_of_range(record.health_access_index)
        || out_of_range(record.income_security_index)
        || out_of_range(record.public_goods_access_index)
        || out_of_range(record.opportunity_blockage_index)
        || out_of_range(record.risk_exposure_index)
        || out_of_range(record.institutional_capture_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.inclusive_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "inequality_inclusive_development_panel.csv";
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
