use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ProjectRecord {
    project_name: String,
    country: String,
    sector: String,
    data_quality_index: f64,
    institutional_capacity_index: f64,
    compute_infrastructure_index: f64,
    algorithmic_capability_index: f64,
    equity_accountability_index: f64,
}

fn parse_record(line: &str) -> Result<ProjectRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 8 {
        return Err("Invalid record length".into());
    }

    Ok(ProjectRecord {
        project_name: parts[0].trim().to_string(),
        country: parts[1].trim().to_string(),
        sector: parts[2].trim().to_string(),
        data_quality_index: parts[3].trim().parse()?,
        institutional_capacity_index: parts[4].trim().parse()?,
        compute_infrastructure_index: parts[5].trim().parse()?,
        algorithmic_capability_index: parts[6].trim().parse()?,
        equity_accountability_index: parts[7].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ProjectRecord) -> bool {
    out_of_range(record.data_quality_index)
        || out_of_range(record.institutional_capacity_index)
        || out_of_range(record.compute_infrastructure_index)
        || out_of_range(record.algorithmic_capability_index)
        || out_of_range(record.equity_accountability_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "ai_governance_projects.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: project={} country={} sector={}",
                record.project_name, record.country, record.sector
            );
        } else {
            println!(
                "VALID: project={} country={} sector={}",
                record.project_name, record.country, record.sector
            );
        }
    }

    Ok(())
}
