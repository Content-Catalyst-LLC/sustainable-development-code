use std::error::Error;
use std::fs;

#[derive(Debug)]
struct SystemsRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    interdependence_intensity_index: f64,
    feedback_risk_index: f64,
    delay_exposure_index: f64,
    path_dependence_index: f64,
    cross_scale_pressure_index: f64,
    earth_system_stress_index: f64,
    governance_fragmentation_index: f64,
    coordination_capacity_index: f64,
    institutional_integration_index: f64,
    leverage_point_capacity_index: f64,
}

fn parse_record(line: &str) -> Result<SystemsRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 13 {
        return Err("Invalid record length".into());
    }

    Ok(SystemsRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        interdependence_intensity_index: parts[3].trim().parse()?,
        feedback_risk_index: parts[4].trim().parse()?,
        delay_exposure_index: parts[5].trim().parse()?,
        path_dependence_index: parts[6].trim().parse()?,
        cross_scale_pressure_index: parts[7].trim().parse()?,
        earth_system_stress_index: parts[8].trim().parse()?,
        governance_fragmentation_index: parts[9].trim().parse()?,
        coordination_capacity_index: parts[10].trim().parse()?,
        institutional_integration_index: parts[11].trim().parse()?,
        leverage_point_capacity_index: parts[12].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &SystemsRecord) -> bool {
    out_of_range(record.interdependence_intensity_index)
        || out_of_range(record.feedback_risk_index)
        || out_of_range(record.delay_exposure_index)
        || out_of_range(record.path_dependence_index)
        || out_of_range(record.cross_scale_pressure_index)
        || out_of_range(record.earth_system_stress_index)
        || out_of_range(record.governance_fragmentation_index)
        || out_of_range(record.coordination_capacity_index)
        || out_of_range(record.institutional_integration_index)
        || out_of_range(record.leverage_point_capacity_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "sustainable_development_systems_problem_panel.csv";
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
