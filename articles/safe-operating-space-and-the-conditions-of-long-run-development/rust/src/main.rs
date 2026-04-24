use std::error::Error;
use std::fs;

#[derive(Debug)]
struct SafeOperatingSpaceRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    climate_boundary_pressure_index: f64,
    biosphere_boundary_pressure_index: f64,
    land_system_pressure_index: f64,
    freshwater_pressure_index: f64,
    biogeochemical_pressure_index: f64,
    novel_entities_pressure_index: f64,
    ocean_acidification_pressure_index: f64,
    resilience_loss_index: f64,
    governability_strain_index: f64,
    adaptation_capacity_index: f64,
    justice_exposure_index: f64,
}

fn parse_record(line: &str) -> Result<SafeOperatingSpaceRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(SafeOperatingSpaceRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        climate_boundary_pressure_index: parts[3].trim().parse()?,
        biosphere_boundary_pressure_index: parts[4].trim().parse()?,
        land_system_pressure_index: parts[5].trim().parse()?,
        freshwater_pressure_index: parts[6].trim().parse()?,
        biogeochemical_pressure_index: parts[7].trim().parse()?,
        novel_entities_pressure_index: parts[8].trim().parse()?,
        ocean_acidification_pressure_index: parts[9].trim().parse()?,
        resilience_loss_index: parts[10].trim().parse()?,
        governability_strain_index: parts[11].trim().parse()?,
        adaptation_capacity_index: parts[12].trim().parse()?,
        justice_exposure_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &SafeOperatingSpaceRecord) -> bool {
    out_of_range(record.climate_boundary_pressure_index)
        || out_of_range(record.biosphere_boundary_pressure_index)
        || out_of_range(record.land_system_pressure_index)
        || out_of_range(record.freshwater_pressure_index)
        || out_of_range(record.biogeochemical_pressure_index)
        || out_of_range(record.novel_entities_pressure_index)
        || out_of_range(record.ocean_acidification_pressure_index)
        || out_of_range(record.resilience_loss_index)
        || out_of_range(record.governability_strain_index)
        || out_of_range(record.adaptation_capacity_index)
        || out_of_range(record.justice_exposure_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "safe_operating_space_long_run_development_panel.csv";
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
