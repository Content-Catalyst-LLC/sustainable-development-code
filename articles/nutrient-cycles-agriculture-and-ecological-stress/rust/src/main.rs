use std::error::Error;
use std::fs;

#[derive(Debug)]
struct NutrientRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    nitrogen_surplus_index: f64,
    phosphorus_surplus_index: f64,
    runoff_leakage_index: f64,
    eutrophication_exposure_index: f64,
    soil_balance_stress_index: f64,
    food_system_dependence_index: f64,
    governance_capacity_index: f64,
    monitoring_readiness_index: f64,
    water_quality_burden_index: f64,
}

fn parse_record(line: &str) -> Result<NutrientRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(NutrientRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        nitrogen_surplus_index: parts[3].trim().parse()?,
        phosphorus_surplus_index: parts[4].trim().parse()?,
        runoff_leakage_index: parts[5].trim().parse()?,
        eutrophication_exposure_index: parts[6].trim().parse()?,
        soil_balance_stress_index: parts[7].trim().parse()?,
        food_system_dependence_index: parts[8].trim().parse()?,
        governance_capacity_index: parts[9].trim().parse()?,
        monitoring_readiness_index: parts[10].trim().parse()?,
        water_quality_burden_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &NutrientRecord) -> bool {
    out_of_range(record.nitrogen_surplus_index)
        || out_of_range(record.phosphorus_surplus_index)
        || out_of_range(record.runoff_leakage_index)
        || out_of_range(record.eutrophication_exposure_index)
        || out_of_range(record.soil_balance_stress_index)
        || out_of_range(record.food_system_dependence_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.monitoring_readiness_index)
        || out_of_range(record.water_quality_burden_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "nutrient_cycles_agriculture_panel.csv";
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
