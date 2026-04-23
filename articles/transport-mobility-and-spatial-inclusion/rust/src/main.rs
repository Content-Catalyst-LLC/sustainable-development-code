use std::error::Error;
use std::fs;

#[derive(Debug)]
struct MobilityRecord {
    city_region: String,
    country: String,
    territory_type: String,
    public_transport_coverage_index: f64,
    jobs_access_index: f64,
    education_access_index: f64,
    healthcare_access_index: f64,
    fare_affordability_index: f64,
    travel_time_burden_index: f64,
    safety_index: f64,
    walkability_index: f64,
    universal_access_index: f64,
    multimodal_integration_index: f64,
    car_dependence_risk_index: f64,
    climate_alignment_index: f64,
}

fn parse_record(line: &str) -> Result<MobilityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 15 {
        return Err("Invalid record length".into());
    }

    Ok(MobilityRecord {
        city_region: parts[0].trim().to_string(),
        country: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        public_transport_coverage_index: parts[3].trim().parse()?,
        jobs_access_index: parts[4].trim().parse()?,
        education_access_index: parts[5].trim().parse()?,
        healthcare_access_index: parts[6].trim().parse()?,
        fare_affordability_index: parts[7].trim().parse()?,
        travel_time_burden_index: parts[8].trim().parse()?,
        safety_index: parts[9].trim().parse()?,
        walkability_index: parts[10].trim().parse()?,
        universal_access_index: parts[11].trim().parse()?,
        multimodal_integration_index: parts[12].trim().parse()?,
        car_dependence_risk_index: parts[13].trim().parse()?,
        climate_alignment_index: parts[14].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &MobilityRecord) -> bool {
    out_of_range(record.public_transport_coverage_index)
        || out_of_range(record.jobs_access_index)
        || out_of_range(record.education_access_index)
        || out_of_range(record.healthcare_access_index)
        || out_of_range(record.fare_affordability_index)
        || out_of_range(record.travel_time_burden_index)
        || out_of_range(record.safety_index)
        || out_of_range(record.walkability_index)
        || out_of_range(record.universal_access_index)
        || out_of_range(record.multimodal_integration_index)
        || out_of_range(record.car_dependence_risk_index)
        || out_of_range(record.climate_alignment_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "mobility_accessibility_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: city_region={} territory_type={}",
                record.city_region, record.territory_type
            );
        } else {
            println!(
                "VALID: city_region={} territory_type={}",
                record.city_region, record.territory_type
            );
        }
    }

    Ok(())
}
