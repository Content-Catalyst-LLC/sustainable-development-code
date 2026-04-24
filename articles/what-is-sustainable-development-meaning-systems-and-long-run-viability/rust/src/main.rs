use std::error::Error;
use std::fs;

#[derive(Debug)]
struct SustainableDevelopmentRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    present_deprivation_index: f64,
    human_wellbeing_support_index: f64,
    ecological_stress_index: f64,
    future_burden_transfer_index: f64,
    institutional_durability_index: f64,
    systems_interdependence_risk_index: f64,
    long_run_viability_index: f64,
    governance_capacity_index: f64,
    planetary_constraint_exposure_index: f64,
    development_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<SustainableDevelopmentRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(SustainableDevelopmentRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        present_deprivation_index: parts[3].trim().parse()?,
        human_wellbeing_support_index: parts[4].trim().parse()?,
        ecological_stress_index: parts[5].trim().parse()?,
        future_burden_transfer_index: parts[6].trim().parse()?,
        institutional_durability_index: parts[7].trim().parse()?,
        systems_interdependence_risk_index: parts[8].trim().parse()?,
        long_run_viability_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        planetary_constraint_exposure_index: parts[11].trim().parse()?,
        development_alignment_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &SustainableDevelopmentRecord) -> bool {
    out_of_range(record.present_deprivation_index)
        || out_of_range(record.human_wellbeing_support_index)
        || out_of_range(record.ecological_stress_index)
        || out_of_range(record.future_burden_transfer_index)
        || out_of_range(record.institutional_durability_index)
        || out_of_range(record.systems_interdependence_risk_index)
        || out_of_range(record.long_run_viability_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.planetary_constraint_exposure_index)
        || out_of_range(record.development_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "what_is_sustainable_development_panel.csv";
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
