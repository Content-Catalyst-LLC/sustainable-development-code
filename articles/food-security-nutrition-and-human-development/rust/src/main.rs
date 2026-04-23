use std::error::Error;
use std::fs;

#[derive(Debug)]
struct FoodRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    food_access_index: f64,
    healthy_diet_affordability_stress_index: f64,
    nutrition_quality_index: f64,
    price_volatility_index: f64,
    child_maternal_risk_index: f64,
    food_system_fragility_index: f64,
    poverty_exposure_index: f64,
    governance_capacity_index: f64,
    nutrition_transition_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<FoodRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(FoodRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        food_access_index: parts[3].trim().parse()?,
        healthy_diet_affordability_stress_index: parts[4].trim().parse()?,
        nutrition_quality_index: parts[5].trim().parse()?,
        price_volatility_index: parts[6].trim().parse()?,
        child_maternal_risk_index: parts[7].trim().parse()?,
        food_system_fragility_index: parts[8].trim().parse()?,
        poverty_exposure_index: parts[9].trim().parse()?,
        governance_capacity_index: parts[10].trim().parse()?,
        nutrition_transition_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &FoodRecord) -> bool {
    out_of_range(record.food_access_index)
        || out_of_range(record.healthy_diet_affordability_stress_index)
        || out_of_range(record.nutrition_quality_index)
        || out_of_range(record.price_volatility_index)
        || out_of_range(record.child_maternal_risk_index)
        || out_of_range(record.food_system_fragility_index)
        || out_of_range(record.poverty_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.nutrition_transition_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "food_security_nutrition_panel.csv";
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
