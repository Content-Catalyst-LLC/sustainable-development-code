use std::error::Error;
use std::fs;

#[derive(Debug)]
struct PollutionRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    hazardous_material_throughput_index: f64,
    waste_system_overload_index: f64,
    persistence_mobility_risk_index: f64,
    assessment_lag_index: f64,
    exposure_inequality_index: f64,
    governance_capacity_index: f64,
    remediation_readiness_index: f64,
    ecosystem_toxicity_index: f64,
    public_health_burden_index: f64,
}

fn parse_record(line: &str) -> Result<PollutionRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(PollutionRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        hazardous_material_throughput_index: parts[3].trim().parse()?,
        waste_system_overload_index: parts[4].trim().parse()?,
        persistence_mobility_risk_index: parts[5].trim().parse()?,
        assessment_lag_index: parts[6].trim().parse()?,
        exposure_inequality_index: parts[7].trim().parse()?,
        governance_capacity_index: parts[8].trim().parse()?,
        remediation_readiness_index: parts[9].trim().parse()?,
        ecosystem_toxicity_index: parts[10].trim().parse()?,
        public_health_burden_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &PollutionRecord) -> bool {
    out_of_range(record.hazardous_material_throughput_index)
        || out_of_range(record.waste_system_overload_index)
        || out_of_range(record.persistence_mobility_risk_index)
        || out_of_range(record.assessment_lag_index)
        || out_of_range(record.exposure_inequality_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.remediation_readiness_index)
        || out_of_range(record.ecosystem_toxicity_index)
        || out_of_range(record.public_health_burden_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "pollution_novel_entities_panel.csv";
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
