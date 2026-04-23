use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ProjectRecord {
    project_id: String,
    country: String,
    region: String,
    sector: String,
    project_size_usd: f64,
    development_need_index: f64,
    climate_resilience_index: f64,
    inclusion_index: f64,
    bankability_index: f64,
    policy_alignment_index: f64,
    blended_finance_potential_index: f64,
    debt_space_constraint_index: f64,
    implementation_capacity_index: f64,
    taxonomy_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<ProjectRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(ProjectRecord {
        project_id: parts[0].trim().to_string(),
        country: parts[1].trim().to_string(),
        region: parts[2].trim().to_string(),
        sector: parts[3].trim().to_string(),
        project_size_usd: parts[4].trim().parse()?,
        development_need_index: parts[5].trim().parse()?,
        climate_resilience_index: parts[6].trim().parse()?,
        inclusion_index: parts[7].trim().parse()?,
        bankability_index: parts[8].trim().parse()?,
        policy_alignment_index: parts[9].trim().parse()?,
        blended_finance_potential_index: parts[10].trim().parse()?,
        debt_space_constraint_index: parts[11].trim().parse()?,
        implementation_capacity_index: parts[12].trim().parse()?,
        taxonomy_alignment_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ProjectRecord) -> bool {
    record.project_size_usd <= 0.0
        || out_of_range(record.development_need_index)
        || out_of_range(record.climate_resilience_index)
        || out_of_range(record.inclusion_index)
        || out_of_range(record.bankability_index)
        || out_of_range(record.policy_alignment_index)
        || out_of_range(record.blended_finance_potential_index)
        || out_of_range(record.debt_space_constraint_index)
        || out_of_range(record.implementation_capacity_index)
        || out_of_range(record.taxonomy_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "sustainable_finance_project_pipeline.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: project_id={} country={} sector={}",
                record.project_id, record.country, record.sector
            );
        } else {
            println!(
                "VALID: project_id={} country={} sector={}",
                record.project_id, record.country, record.sector
            );
        }
    }

    Ok(())
}
