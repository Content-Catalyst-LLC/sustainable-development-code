use std::error::Error;
use std::fs;

#[derive(Debug)]
struct OvershootRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    growth_pressure_index: f64,
    throughput_pressure_index: f64,
    resource_depletion_index: f64,
    waste_absorptive_stress_index: f64,
    planetary_pressure_index: f64,
    delay_recognition_risk_index: f64,
    infrastructure_lockin_index: f64,
    governance_fragility_index: f64,
    adaptive_capacity_index: f64,
    welfare_conversion_index: f64,
}

fn parse_record(line: &str) -> Result<OvershootRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(OvershootRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        growth_pressure_index: parts[3].trim().parse()?,
        throughput_pressure_index: parts[4].trim().parse()?,
        resource_depletion_index: parts[5].trim().parse()?,
        waste_absorptive_stress_index: parts[6].trim().parse()?,
        planetary_pressure_index: parts[7].trim().parse()?,
        delay_recognition_risk_index: parts[8].trim().parse()?,
        infrastructure_lockin_index: parts[9].trim().parse()?,
        governance_fragility_index: parts[10].trim().parse()?,
        adaptive_capacity_index: parts[11].trim().parse()?,
        welfare_conversion_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &OvershootRecord) -> bool {
    out_of_range(record.growth_pressure_index)
        || out_of_range(record.throughput_pressure_index)
        || out_of_range(record.resource_depletion_index)
        || out_of_range(record.waste_absorptive_stress_index)
        || out_of_range(record.planetary_pressure_index)
        || out_of_range(record.delay_recognition_risk_index)
        || out_of_range(record.infrastructure_lockin_index)
        || out_of_range(record.governance_fragility_index)
        || out_of_range(record.adaptive_capacity_index)
        || out_of_range(record.welfare_conversion_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "growth_limits_overshoot_panel.csv";
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
