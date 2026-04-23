use std::error::Error;
use std::fs;

#[derive(Debug)]
struct CoastalRecord {
    coastal_system_name: String,
    country_or_region: String,
    coastal_type: String,
    acidification_pressure_index: f64,
    warming_pressure_index: f64,
    deoxygenation_pressure_index: f64,
    marine_dependence_index: f64,
    fisheries_livelihood_dependence_index: f64,
    coastal_infrastructure_exposure_index: f64,
    governance_capacity_index: f64,
    justice_exposure_index: f64,
    monitoring_readiness_index: f64,
}

fn parse_record(line: &str) -> Result<CoastalRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(CoastalRecord {
        coastal_system_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        coastal_type: parts[2].trim().to_string(),
        acidification_pressure_index: parts[3].trim().parse()?,
        warming_pressure_index: parts[4].trim().parse()?,
        deoxygenation_pressure_index: parts[5].trim().parse()?,
        marine_dependence_index: parts[6].trim().parse()?,
        fisheries_livelihood_dependence_index: parts[7].trim().parse()?,
        coastal_infrastructure_exposure_index: parts[8].trim().parse()?,
        governance_capacity_index: parts[9].trim().parse()?,
        justice_exposure_index: parts[10].trim().parse()?,
        monitoring_readiness_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &CoastalRecord) -> bool {
    out_of_range(record.acidification_pressure_index)
        || out_of_range(record.warming_pressure_index)
        || out_of_range(record.deoxygenation_pressure_index)
        || out_of_range(record.marine_dependence_index)
        || out_of_range(record.fisheries_livelihood_dependence_index)
        || out_of_range(record.coastal_infrastructure_exposure_index)
        || out_of_range(record.governance_capacity_index)
        || out_of_range(record.justice_exposure_index)
        || out_of_range(record.monitoring_readiness_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "ocean_acidification_coastal_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: coastal_system_name={} coastal_type={}",
                record.coastal_system_name, record.coastal_type
            );
        } else {
            println!(
                "VALID: coastal_system_name={} coastal_type={}",
                record.coastal_system_name, record.coastal_type
            );
        }
    }

    Ok(())
}
