use std::error::Error;
use std::fs;

#[derive(Debug)]
struct SDGRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    universality_exposure_index: f64,
    integration_complexity_index: f64,
    implementation_capacity_index: f64,
    means_of_implementation_index: f64,
    partnership_readiness_index: f64,
    monitoring_capacity_index: f64,
    indicator_coverage_index: f64,
    review_responsiveness_index: f64,
    policy_fragmentation_index: f64,
    sdg_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<SDGRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(SDGRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        universality_exposure_index: parts[3].trim().parse()?,
        integration_complexity_index: parts[4].trim().parse()?,
        implementation_capacity_index: parts[5].trim().parse()?,
        means_of_implementation_index: parts[6].trim().parse()?,
        partnership_readiness_index: parts[7].trim().parse()?,
        monitoring_capacity_index: parts[8].trim().parse()?,
        indicator_coverage_index: parts[9].trim().parse()?,
        review_responsiveness_index: parts[10].trim().parse()?,
        policy_fragmentation_index: parts[11].trim().parse()?,
        sdg_alignment_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &SDGRecord) -> bool {
    out_of_range(record.universality_exposure_index)
        || out_of_range(record.integration_complexity_index)
        || out_of_range(record.implementation_capacity_index)
        || out_of_range(record.means_of_implementation_index)
        || out_of_range(record.partnership_readiness_index)
        || out_of_range(record.monitoring_capacity_index)
        || out_of_range(record.indicator_coverage_index)
        || out_of_range(record.review_responsiveness_index)
        || out_of_range(record.policy_fragmentation_index)
        || out_of_range(record.sdg_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "agenda_2030_sdg_logic_panel.csv";
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
