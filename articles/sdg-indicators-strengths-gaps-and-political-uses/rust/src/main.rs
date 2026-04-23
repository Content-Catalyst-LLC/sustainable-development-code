use std::error::Error;
use std::fs;

#[derive(Debug)]
struct IndicatorRecord {
    country: String,
    goal: String,
    indicator_code: String,
    actual_value: f64,
    target_value: f64,
    direction: String,
    lower_bound: f64,
    upper_bound: f64,
}

fn parse_record(line: &str) -> Result<IndicatorRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() < 8 {
        return Err("Invalid record length".into());
    }

    Ok(IndicatorRecord {
        country: parts[0].trim().to_string(),
        goal: parts[1].trim().to_string(),
        indicator_code: parts[2].trim().to_string(),
        actual_value: parts[4].trim().parse()?,
        target_value: parts[5].trim().parse()?,
        direction: parts[6].trim().to_string(),
        lower_bound: parts[7].trim().parse()?,
        upper_bound: parts[8].trim().parse()?,
    })
}

fn valid_direction(direction: &str) -> bool {
    direction == "higher_better" || direction == "lower_better"
}

fn invalid_record(record: &IndicatorRecord) -> bool {
    !valid_direction(&record.direction)
        || record.lower_bound >= record.upper_bound
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "sdg_indicator_values.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} goal={} indicator={}",
                record.country, record.goal, record.indicator_code
            );
        } else {
            println!(
                "VALID: country={} goal={} indicator={} actual={} target={}",
                record.country, record.goal, record.indicator_code, record.actual_value, record.target_value
            );
        }
    }

    Ok(())
}
