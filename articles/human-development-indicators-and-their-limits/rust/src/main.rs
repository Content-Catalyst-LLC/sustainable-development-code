use std::error::Error;
use std::fs;

#[derive(Debug)]
struct IndicatorRecord {
    territory_name: String,
    country_or_region: String,
    territory_type: String,
    hdi_attainment_index: f64,
    inequality_penalty_index: f64,
    gender_gap_index: f64,
    multidimensional_poverty_index: f64,
    planetary_pressure_penalty_index: f64,
    data_quality_confidence_index: f64,
    subnational_variation_index: f64,
    security_exclusion_index: f64,
    indicator_coverage_index: f64,
}

fn parse_record(line: &str) -> Result<IndicatorRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 12 {
        return Err("Invalid record length".into());
    }

    Ok(IndicatorRecord {
        territory_name: parts[0].trim().to_string(),
        country_or_region: parts[1].trim().to_string(),
        territory_type: parts[2].trim().to_string(),
        hdi_attainment_index: parts[3].trim().parse()?,
        inequality_penalty_index: parts[4].trim().parse()?,
        gender_gap_index: parts[5].trim().parse()?,
        multidimensional_poverty_index: parts[6].trim().parse()?,
        planetary_pressure_penalty_index: parts[7].trim().parse()?,
        data_quality_confidence_index: parts[8].trim().parse()?,
        subnational_variation_index: parts[9].trim().parse()?,
        security_exclusion_index: parts[10].trim().parse()?,
        indicator_coverage_index: parts[11].trim().parse()?,
    })
}

fn out_of_range(value: f64) -> bool {
    value < 0.0 || value > 1.0
}

fn invalid_record(record: &IndicatorRecord) -> bool {
    out_of_range(record.hdi_attainment_index)
        || out_of_range(record.inequality_penalty_index)
        || out_of_range(record.gender_gap_index)
        || out_of_range(record.multidimensional_poverty_index)
        || out_of_range(record.planetary_pressure_penalty_index)
        || out_of_range(record.data_quality_confidence_index)
        || out_of_range(record.subnational_variation_index)
        || out_of_range(record.security_exclusion_index)
        || out_of_range(record.indicator_coverage_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "human_development_indicators_panel.csv";
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
