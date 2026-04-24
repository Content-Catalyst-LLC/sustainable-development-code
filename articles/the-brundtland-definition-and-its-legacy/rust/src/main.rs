use std::error::Error;
use std::fs;

#[derive(Debug)]
struct BrundtlandRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    present_need_pressure_index: f64,
    poverty_reduction_support_index: f64,
    ecological_degradation_index: f64,
    future_burden_transfer_index: f64,
    institutional_durability_index: f64,
    intergenerational_stewardship_index: f64,
    absorptive_capacity_stress_index: f64,
    technology_organisation_constraint_index: f64,
    development_legitimacy_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<BrundtlandRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(BrundtlandRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        present_need_pressure_index: parts[3].trim().parse()?,
        poverty_reduction_support_index: parts[4].trim().parse()?,
        ecological_degradation_index: parts[5].trim().parse()?,
        future_burden_transfer_index: parts[6].trim().parse()?,
        institutional_durability_index: parts[7].trim().parse()?,
        intergenerational_stewardship_index: parts[8].trim().parse()?,
        absorptive_capacity_stress_index: parts[9].trim().parse()?,
        technology_organisation_constraint_index: parts[10].trim().parse()?,
        development_legitimacy_alignment_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &BrundtlandRecord) -> bool {
    out_of_range(record.present_need_pressure_index)
        || out_of_range(record.poverty_reduction_support_index)
        || out_of_range(record.ecological_degradation_index)
        || out_of_range(record.future_burden_transfer_index)
        || out_of_range(record.institutional_durability_index)
        || out_of_range(record.intergenerational_stewardship_index)
        || out_of_range(record.absorptive_capacity_stress_index)
        || out_of_range(record.technology_organisation_constraint_index)
        || out_of_range(record.development_legitimacy_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "brundtland_definition_legacy_panel.csv";
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
