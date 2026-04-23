use std::error::Error;
use std::fs;

#[derive(Debug)]
struct LocalRecord {
    city_or_region: String,
    country: String,
    territory_type: String,
    service_reach_index: f64,
    land_housing_coordination_index: f64,
    infrastructure_mobility_integration_index: f64,
    resilience_capacity_index: f64,
    spatial_justice_index: f64,
    participatory_local_governance_index: f64,
    multilevel_alignment_index: f64,
    data_learning_capacity_index: f64,
    fragmentation_risk_index: f64,
}

fn parse_record(line: &str) -> Result<LocalRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(LocalRecord {
        city_or_region: parts[0].trim().to_string(),
        country: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        service_reach_index: parts[3].trim().parse()?,
        land_housing_coordination_index: parts[4].trim().parse()?,
        infrastructure_mobility_integration_index: parts[5].trim().parse()?,
        resilience_capacity_index: parts[6].trim().parse()?,
        spatial_justice_index: parts[7].trim().parse()?,
        participatory_local_governance_index: parts[8].trim().parse()?,
        multilevel_alignment_index: parts[9].trim().parse()?,
        data_learning_capacity_index: parts[10].trim().parse()?,
        fragmentation_risk_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &LocalRecord) -> bool {
    out_of_range(record.service_reach_index)
        || out_of_range(record.land_housing_coordination_index)
        || out_of_range(record.infrastructure_mobility_integration_index)
        || out_of_range(record.resilience_capacity_index)
        || out_of_range(record.spatial_justice_index)
        || out_of_range(record.participatory_local_governance_index)
        || out_of_range(record.multilevel_alignment_index)
        || out_of_range(record.data_learning_capacity_index)
        || out_of_range(record.fragmentation_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "local_governance_territorial_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: city_or_region={} territory_type={}",
                record.city_or_region, record.territory_type
            );
        } else {
            println!(
                "VALID: city_or_region={} territory_type={}",
                record.city_or_region, record.territory_type
            );
        }
    }

    Ok(())
}
