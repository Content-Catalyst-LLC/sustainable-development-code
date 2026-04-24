use std::error::Error;
use std::fs;

#[derive(Debug)]
struct PolicyCoherenceRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    tradeoff_intensity_index: f64,
    synergy_realization_index: f64,
    sectoral_spillover_index: f64,
    transboundary_spillover_index: f64,
    intergenerational_spillover_index: f64,
    coordination_capacity_index: f64,
    impact_assessment_index: f64,
    monitoring_review_index: f64,
    sequencing_capacity_index: f64,
    governance_fragmentation_index: f64,
    policy_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<PolicyCoherenceRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(PolicyCoherenceRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        tradeoff_intensity_index: parts[3].trim().parse()?,
        synergy_realization_index: parts[4].trim().parse()?,
        sectoral_spillover_index: parts[5].trim().parse()?,
        transboundary_spillover_index: parts[6].trim().parse()?,
        intergenerational_spillover_index: parts[7].trim().parse()?,
        coordination_capacity_index: parts[8].trim().parse()?,
        impact_assessment_index: parts[9].trim().parse()?,
        monitoring_review_index: parts[10].trim().parse()?,
        sequencing_capacity_index: parts[11].trim().parse()?,
        governance_fragmentation_index: parts[12].trim().parse()?,
        policy_alignment_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &PolicyCoherenceRecord) -> bool {
    out_of_range(record.tradeoff_intensity_index)
        || out_of_range(record.synergy_realization_index)
        || out_of_range(record.sectoral_spillover_index)
        || out_of_range(record.transboundary_spillover_index)
        || out_of_range(record.intergenerational_spillover_index)
        || out_of_range(record.coordination_capacity_index)
        || out_of_range(record.impact_assessment_index)
        || out_of_range(record.monitoring_review_index)
        || out_of_range(record.sequencing_capacity_index)
        || out_of_range(record.governance_fragmentation_index)
        || out_of_range(record.policy_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "tradeoffs_synergies_policy_coherence_panel.csv";
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
