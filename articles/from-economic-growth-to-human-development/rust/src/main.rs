use std::error::Error;
use std::fs;

#[derive(Debug)]
struct HumanDevelopmentRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    output_growth_index: f64,
    health_capability_index: f64,
    education_capability_index: f64,
    income_conversion_index: f64,
    public_goods_conversion_index: f64,
    distribution_constraint_index: f64,
    institutional_support_index: f64,
    ecological_durability_index: f64,
    agency_freedom_index: f64,
    human_development_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<HumanDevelopmentRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(HumanDevelopmentRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        output_growth_index: parts[3].trim().parse()?,
        health_capability_index: parts[4].trim().parse()?,
        education_capability_index: parts[5].trim().parse()?,
        income_conversion_index: parts[6].trim().parse()?,
        public_goods_conversion_index: parts[7].trim().parse()?,
        distribution_constraint_index: parts[8].trim().parse()?,
        institutional_support_index: parts[9].trim().parse()?,
        ecological_durability_index: parts[10].trim().parse()?,
        agency_freedom_index: parts[11].trim().parse()?,
        human_development_alignment_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &HumanDevelopmentRecord) -> bool {
    out_of_range(record.output_growth_index)
        || out_of_range(record.health_capability_index)
        || out_of_range(record.education_capability_index)
        || out_of_range(record.income_conversion_index)
        || out_of_range(record.public_goods_conversion_index)
        || out_of_range(record.distribution_constraint_index)
        || out_of_range(record.institutional_support_index)
        || out_of_range(record.ecological_durability_index)
        || out_of_range(record.agency_freedom_index)
        || out_of_range(record.human_development_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "economic_growth_to_human_development_panel.csv";
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
