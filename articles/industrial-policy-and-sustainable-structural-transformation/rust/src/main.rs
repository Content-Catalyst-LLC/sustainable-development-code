use std::error::Error;
use std::fs;

#[derive(Debug)]
struct SectorRecord {
    country: String,
    region: String,
    sector: String,
    manufacturing_value_added_index: f64,
    services_productivity_index: f64,
    export_complexity_index: f64,
    technology_upgrading_index: f64,
    skills_depth_index: f64,
    infrastructure_quality_index: f64,
    supplier_ecosystem_index: f64,
    green_transition_readiness_index: f64,
    regional_inclusion_index: f64,
    institutional_coordination_index: f64,
    lock_in_risk_index: f64,
}

fn parse_record(line: &str) -> Result<SectorRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(SectorRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        sector: parts[2].trim().to_string(),
        manufacturing_value_added_index: parts[3].trim().parse()?,
        services_productivity_index: parts[4].trim().parse()?,
        export_complexity_index: parts[5].trim().parse()?,
        technology_upgrading_index: parts[6].trim().parse()?,
        skills_depth_index: parts[7].trim().parse()?,
        infrastructure_quality_index: parts[8].trim().parse()?,
        supplier_ecosystem_index: parts[9].trim().parse()?,
        green_transition_readiness_index: parts[10].trim().parse()?,
        regional_inclusion_index: parts[11].trim().parse()?,
        institutional_coordination_index: parts[12].trim().parse()?,
        lock_in_risk_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &SectorRecord) -> bool {
    out_of_range(record.manufacturing_value_added_index)
        || out_of_range(record.services_productivity_index)
        || out_of_range(record.export_complexity_index)
        || out_of_range(record.technology_upgrading_index)
        || out_of_range(record.skills_depth_index)
        || out_of_range(record.infrastructure_quality_index)
        || out_of_range(record.supplier_ecosystem_index)
        || out_of_range(record.green_transition_readiness_index)
        || out_of_range(record.regional_inclusion_index)
        || out_of_range(record.institutional_coordination_index)
        || out_of_range(record.lock_in_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "industrial_transformation_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} sector={}",
                record.country, record.sector
            );
        } else {
            println!(
                "VALID: country={} sector={}",
                record.country, record.sector
            );
        }
    }

    Ok(())
}
