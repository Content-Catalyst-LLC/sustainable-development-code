use std::error::Error;
use std::fs;

#[derive(Debug)]
struct PovertyRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    income_poverty_index: f64,
    housing_deprivation_index: f64,
    sanitation_deprivation_index: f64,
    electricity_cooking_fuel_deprivation_index: f64,
    nutrition_deprivation_index: f64,
    learning_deprivation_index: f64,
    climate_exposure_index: f64,
    child_vulnerability_index: f64,
    public_goods_access_index: f64,
    governance_capacity_index: f64,
    poverty_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<PovertyRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(PovertyRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        income_poverty_index: parts[3].trim().parse()?,
        housing_deprivation_index: parts[4].trim().parse()?,
        sanitation_deprivation_index: parts[5].trim().parse()?,
        electricity_cooking_fuel_deprivation_index: parts[6].trim().parse()?,
        nutrition_deprivation_index: parts[7].trim().parse()?,
        learning_deprivation_index: parts[8].trim().parse()?,
        climate_exposure_index: parts[9].trim().parse()?,
        child_vulnerability_index: parts[10].trim().parse()?,
        public_goods_access_index: parts[11].trim().parse()?,
        governance_capacity_index: parts[12].trim().parse()?,
        poverty_transition_readiness_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &PovertyRecord) -> bool {
    out_of_range(record.income_poverty_index)
        || out_of_range(record.housing_deprivation_index)
        || out_of_range(record.sanitation_deprivation_index)
        || out_of_range(record.electricity_cooking_fuel_deprivation_index)
        || out_of_range(record.nutrition_deprivation_index)
        || out_of_range(record.learning_deprivation_index)
        || out_of_range(record.climate_exposure_index)
        || out_of_range(record.child_vulnerability_index)
        || out_of_range(record.public_goods_access_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.poverty_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "poverty_multidimensional_development_panel.csv";
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
