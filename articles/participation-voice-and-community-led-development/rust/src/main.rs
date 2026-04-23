use std::error::Error;
use std::fs;

#[derive(Debug)]
struct ParticipationRecord {
    country: String,
    region: String,
    program_domain: String,
    participatory_depth_index: f64,
    voice_effectiveness_index: f64,
    representation_quality_index: f64,
    institutional_uptake_index: f64,
    community_control_index: f64,
    accountability_channel_index: f64,
    local_knowledge_integration_index: f64,
    trust_support_index: f64,
    tokenism_risk_index: f64,
}

fn parse_record(line: &str) -> Result<ParticipationRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(ParticipationRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        program_domain: parts[2].trim().to_string(),
        participatory_depth_index: parts[3].trim().parse()?,
        voice_effectiveness_index: parts[4].trim().parse()?,
        representation_quality_index: parts[5].trim().parse()?,
        institutional_uptake_index: parts[6].trim().parse()?,
        community_control_index: parts[7].trim().parse()?,
        accountability_channel_index: parts[8].trim().parse()?,
        local_knowledge_integration_index: parts[9].trim().parse()?,
        trust_support_index: parts[10].trim().parse()?,
        tokenism_risk_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &ParticipationRecord) -> bool {
    out_of_range(record.participatory_depth_index)
        || out_of_range(record.voice_effectiveness_index)
        || out_of_range(record.representation_quality_index)
        || out_of_range(record.institutional_uptake_index)
        || out_of_range(record.community_control_index)
        || out_of_range(record.accountability_channel_index)
        || out_of_range(record.local_knowledge_integration_index)
        || out_of_range(record.trust_support_index)
        || out_of_range(record.tokenism_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "participation_and_cld_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} program_domain={}",
                record.country, record.program_domain
            );
        } else {
            println!(
                "VALID: country={} program_domain={}",
                record.country, record.program_domain
            );
        }
    }

    Ok(())
}
