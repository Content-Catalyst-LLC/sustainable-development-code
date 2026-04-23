use std::error::Error;
use std::fs;

#[derive(Debug)]
struct CapacityRecord {
    country: String,
    region: String,
    sector: String,
    connectivity_index: f64,
    digital_identity_index: f64,
    payments_rail_index: f64,
    data_exchange_index: f64,
    registry_integrity_index: f64,
    service_delivery_index: f64,
    cybersecurity_index: f64,
    public_trust_index: f64,
    inclusion_access_index: f64,
    compute_cloud_index: f64,
    interoperability_index: f64,
    institutional_use_capacity_index: f64,
    lock_in_risk_index: f64,
}

fn parse_record(line: &str) -> Result<CapacityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 16 {
        return Err("Invalid record length".into());
    }

    Ok(CapacityRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        sector: parts[2].trim().to_string(),
        connectivity_index: parts[3].trim().parse()?,
        digital_identity_index: parts[4].trim().parse()?,
        payments_rail_index: parts[5].trim().parse()?,
        data_exchange_index: parts[6].trim().parse()?,
        registry_integrity_index: parts[7].trim().parse()?,
        service_delivery_index: parts[8].trim().parse()?,
        cybersecurity_index: parts[9].trim().parse()?,
        public_trust_index: parts[10].trim().parse()?,
        inclusion_access_index: parts[11].trim().parse()?,
        compute_cloud_index: parts[12].trim().parse()?,
        interoperability_index: parts[13].trim().parse()?,
        institutional_use_capacity_index: parts[14].trim().parse()?,
        lock_in_risk_index: parts[15].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &CapacityRecord) -> bool {
    out_of_range(record.connectivity_index)
        || out_of_range(record.digital_identity_index)
        || out_of_range(record.payments_rail_index)
        || out_of_range(record.data_exchange_index)
        || out_of_range(record.registry_integrity_index)
        || out_of_range(record.service_delivery_index)
        || out_of_range(record.cybersecurity_index)
        || out_of_range(record.public_trust_index)
        || out_of_range(record.inclusion_access_index)
        || out_of_range(record.compute_cloud_index)
        || out_of_range(record.interoperability_index)
        || out_of_range(record.institutional_use_capacity_index)
        || out_of_range(record.lock_in_risk_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "digital_infrastructure_capacity_panel.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} sector={}",
                record.country, record.sector
            );
        } else {
            println!(
                "VALID: country={} sector={}",
                record.country, record.sector
            );
        }
    }

    Ok(())
}
