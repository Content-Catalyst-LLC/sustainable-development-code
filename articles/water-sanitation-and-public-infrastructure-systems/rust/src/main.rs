use std::error::Error;
use std::fs;

#[derive(Debug)]
struct WaterQualityRecord {
    district: String,
    turbidity_ntu: f64,
    residual_chlorine_mg_l: f64,
    e_coli_cfu_100ml: i32,
}

fn parse_record(line: &str) -> Result<WaterQualityRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 4 {
        return Err("Invalid record length".into());
    }

    Ok(WaterQualityRecord {
        district: parts[0].trim().to_string(),
        turbidity_ntu: parts[1].trim().parse()?,
        residual_chlorine_mg_l: parts[2].trim().parse()?,
        e_coli_cfu_100ml: parts[3].trim().parse()?,
    })
}

fn is_high_risk(record: &WaterQualityRecord) -> bool {
    record.turbidity_ntu > 5.0 ||
    record.residual_chlorine_mg_l < 0.2 ||
    record.e_coli_cfu_100ml > 0
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "water_quality_telemetry.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if is_high_risk(&record) {
            println!(
                "ALERT: district={} turbidity={} chlorine={} e_coli={}",
                record.district,
                record.turbidity_ntu,
                record.residual_chlorine_mg_l,
                record.e_coli_cfu_100ml
            );
        } else {
            println!("OK: {}", record.district);
        }
    }

    Ok(())
}
