library(readr)
library(dplyr)

input_file <- "sovereign_debt_fiscal_space_data.csv"
country_output_file <- "debt_fiscal_space_country_summary.csv"
region_output_file <- "debt_fiscal_space_region_summary.csv"

debt_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "public_debt_gdp_ratio",
  "debt_service_revenue_ratio",
  "interest_revenue_ratio",
  "gross_financing_needs_gdp_ratio",
  "public_investment_gdp_ratio",
  "social_spending_gdp_ratio",
  "climate_vulnerability_index",
  "market_access_index"
)

missing_cols <- setdiff(required_cols, names(debt_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

debt_df <- debt_df %>%
  mutate(
    fiscal_pressure_proxy = (
      public_debt_gdp_ratio / 100 +
      debt_service_revenue_ratio / 100 +
      interest_revenue_ratio / 100 +
      gross_financing_needs_gdp_ratio / 100
    ) / 4,
    development_space_proxy = (
      public_investment_gdp_ratio / 10 +
      social_spending_gdp_ratio / 20 +
      market_access_index +
      (1 - climate_vulnerability_index)
    ) / 4
  )

country_summary <- debt_df %>%
  group_by(country) %>%
  summarise(
    avg_fiscal_pressure = mean(fiscal_pressure_proxy, na.rm = TRUE),
    avg_development_space = mean(development_space_proxy, na.rm = TRUE),
    avg_debt_service_ratio = mean(debt_service_revenue_ratio, na.rm = TRUE),
    avg_public_investment = mean(public_investment_gdp_ratio, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    constraint_gap = avg_fiscal_pressure - avg_development_space,
    constraint_band = case_when(
      constraint_gap >= 0.30 ~ "Severe constraint",
      constraint_gap >= 0.15 ~ "Elevated constraint",
      constraint_gap >= 0.05 ~ "Moderate constraint",
      TRUE ~ "Lower constraint"
    )
  ) %>%
  arrange(desc(constraint_gap))

region_summary <- debt_df %>%
  group_by(region) %>%
  summarise(
    avg_fiscal_pressure = mean(fiscal_pressure_proxy, na.rm = TRUE),
    avg_development_space = mean(development_space_proxy, na.rm = TRUE),
    avg_debt_service_ratio = mean(debt_service_revenue_ratio, na.rm = TRUE),
    avg_interest_ratio = mean(interest_revenue_ratio, na.rm = TRUE),
    avg_climate_vulnerability = mean(climate_vulnerability_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_fiscal_pressure))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Country debt and fiscal-space summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegion debt and fiscal-space summary exported to:", region_output_file, "\n")
print(region_summary)
