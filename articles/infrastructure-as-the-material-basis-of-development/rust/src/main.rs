use std::error::Error;
use std::fs;

#[derive(Debug)]
struct InfrastructureRecord {
    country: String,
    region: String,
    territory_type: String,
    transport_access_index: f64,
    water_access_index: f64,
    sanitation_access_index: f64,
    electricity_access_index: f64,
    digital_connectivity_index: f64,
    public_service_reach_index: f64,
    reliability_index: f64,
    maintenance_capacity_index: f64,
    territorial_equity_index: f64,
    climate_resilience_index: f64,
    lock_in_risk_index: f64,
}

fn parse_record(line: &str) -> Result<InfrastructureRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 14 {
        return Err("Invalid record length".into());
    }

    Ok(InfrastructureRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        transport_access_index: parts[3].trim().parse()?,
        water_access_index: parts[4].trim().parse()?,
        sanitation_access_index: parts[5].trim().parse()?,
        electricity_access_index: parts[6].trim().parse()?,
        digital_connectivity_index: parts[7].trim().parse()?,
        public_service_reach_index: parts[8].trim().parse()?,
        reliability_index: parts[9].trim().parse()?,
        maintenance_capacity_index: parts[10].trim().parse()?,
        territorial_equity_index: parts[11].trim().parse()?,
        climate_resilience_index: parts[12].trim().parse()?,
        lock_in_risk_index: parts[13].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &InfrastructureRecord) -> bool {
    out_of_range(record.transport_access_index)
        || out_of_range(record.water_access_index)
        || out_of_range(record.sanitation_access_index)
        || out_of_range(record.electricity_access_index)
        || out_of_range(record.digital_connectivity_index)
        || out_of_range(record.public_service_reach_index)
        || out_of_range(record.reliability_index)
        || out_of_range(record.maintenance_capacity_index)
        || out_of_range(record.territorial_equity_index)
        || out_of_range(record.climate_resilience_index)
        || out_of_range(record.lock_in_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "infrastructure_access_capability_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} territory_type={}",
                record.country, record.territory_type
            );
        } else {
            println!(
                "VALID: country={} territory_type={}",
                record.country, record.territory_type
            );
        }
    }

    Ok(())
}
