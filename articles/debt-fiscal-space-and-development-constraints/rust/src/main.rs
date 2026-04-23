use std::error::Error;
use std::fs;

#[derive(Debug)]
struct DebtRecord {
    country: String,
    region: String,
    year: i32,
    public_debt_gdp_ratio: f64,
    external_debt_export_ratio: f64,
    debt_service_revenue_ratio: f64,
    interest_revenue_ratio: f64,
    gross_financing_needs_gdp_ratio: f64,
    avg_maturity_years: f64,
    share_fx_debt: f64,
    share_concessional_debt: f64,
    tax_revenue_gdp_ratio: f64,
    public_investment_gdp_ratio: f64,
    social_spending_gdp_ratio: f64,
    climate_vulnerability_index: f64,
    market_access_index: f64,
    growth_rate: f64,
}

fn parse_record(line: &str) -> Result<DebtRecord, Box<dyn Error>> {
    let parts: Vec<&str> = line.split(',').collect();

    if parts.len() != 17 {
        return Err("Invalid record length".into());
    }

    Ok(DebtRecord {
        country: parts[0].trim().to_string(),
        region: parts[1].trim().to_string(),
        year: parts[2].trim().parse()?,
        public_debt_gdp_ratio: parts[3].trim().parse()?,
        external_debt_export_ratio: parts[4].trim().parse()?,
        debt_service_revenue_ratio: parts[5].trim().parse()?,
        interest_revenue_ratio: parts[6].trim().parse()?,
        gross_financing_needs_gdp_ratio: parts[7].trim().parse()?,
        avg_maturity_years: parts[8].trim().parse()?,
        share_fx_debt: parts[9].trim().parse()?,
        share_concessional_debt: parts[10].trim().parse()?,
        tax_revenue_gdp_ratio: parts[11].trim().parse()?,
        public_investment_gdp_ratio: parts[12].trim().parse()?,
        social_spending_gdp_ratio: parts[13].trim().parse()?,
        climate_vulnerability_index: parts[14].trim().parse()?,
        market_access_index: parts[15].trim().parse()?,
        growth_rate: parts[16].trim().parse()?,
    })
}

fn invalid_ratio(value: f64) -> bool {
    value.is_nan() || value < 0.0
}

fn invalid_share(value: f64) -> bool {
    value.is_nan() || value < 0.0 || value > 1.0
}

fn invalid_record(record: &DebtRecord) -> bool {
    invalid_ratio(record.public_debt_gdp_ratio)
        || invalid_ratio(record.external_debt_export_ratio)
        || invalid_ratio(record.debt_service_revenue_ratio)
        || invalid_ratio(record.interest_revenue_ratio)
        || invalid_ratio(record.gross_financing_needs_gdp_ratio)
        || record.avg_maturity_years <= 0.0
        || invalid_share(record.share_fx_debt)
        || invalid_share(record.share_concessional_debt)
        || invalid_ratio(record.tax_revenue_gdp_ratio)
        || invalid_ratio(record.public_investment_gdp_ratio)
        || invalid_ratio(record.social_spending_gdp_ratio)
        || invalid_share(record.climate_vulnerability_index)
        || invalid_share(record.market_access_index)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "sovereign_debt_fiscal_space_data.csv";
    let contents = fs::read_to_string(file_path)?;

    for (index, line) in contents.lines().enumerate() {
        if index == 0 {
            continue;
        }

        let record = parse_record(line)?;

        if invalid_record(&record) {
            println!(
                "INVALID: country={} region={} year={}",
                record.country, record.region, record.year
            );
        } else {
            println!(
                "VALID: country={} region={} year={} growth={}",
                record.country, record.region, record.year, record.growth_rate
            );
        }
    }

    Ok(())
}
