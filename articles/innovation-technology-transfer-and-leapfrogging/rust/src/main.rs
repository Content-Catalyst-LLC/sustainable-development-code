use std::error::Error;
use std::fs;

#[derive(Debug)]
struct TransferRecord {
    country: String,
    sector: String,
    infrastructure_readiness_index: f64,
    skills_capacity_index: f64,
    institutional_capacity_index: f64,
    supplier_depth_index: f64,
    finance_access_index: f64,
    standards_capacity_index: f64,
    technology_access_index: f64,
    dependency_risk_index: f64,
}

fn parse_record(line: &str) -> Result<TransferRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 10 {
        return Err("Invalid record length".into());
    }

    Ok(TransferRecord {
        country: parts[0].trim().to_string(),
        sector: parts[1].trim().to_string(),
        infrastructure_readiness_index: parts[2].trim().parse()?,
        skills_capacity_index: parts[3].trim().parse()?,
        institutional_capacity_index: parts[4].trim().parse()?,
        supplier_depth_index: parts[5].trim().parse()?,
        finance_access_index: parts[6].trim().parse()?,
        standards_capacity_index: parts[7].trim().parse()?,
        technology_access_index: parts[8].trim().parse()?,
        dependency_risk_index: parts[9].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &TransferRecord) -> bool {
    out_of_range(record.infrastructure_readiness_index)
        || out_of_range(record.skills_capacity_index)
        || out_of_range(record.institutional_capacity_index)
        || out_of_range(record.supplier_depth_index)
        || out_of_range(record.finance_access_index)
        || out_of_range(record.standards_capacity_index)
        || out_of_range(record.technology_access_index)
        || out_of_range(record.dependency_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "technology_transfer_capability_data.csv";
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
