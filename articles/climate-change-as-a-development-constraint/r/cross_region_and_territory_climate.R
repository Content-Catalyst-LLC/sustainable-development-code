library(readr)
library(dplyr)

input_file <- "climate_constraint_country_panel.csv"
region_output_file <- "cross_region_climate_summary.csv"
territory_output_file <- "cross_territory_climate_summary.csv"

climate_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "heat_stress_index",
  "hydrological_disruption_index",
  "food_livelihood_exposure_index",
  "health_burden_index",
  "infrastructure_vulnerability_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(climate_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

climate_df <- climate_df %>%
  mutate(
    climate_risk_proxy = (
      heat_stress_index +
      hydrological_disruption_index +
      food_livelihood_exposure_index +
      health_burden_index +
      infrastructure_vulnerability_index +
      justice_exposure_index +
      (1 - governance_capacity_index)
    ) / 7
  )

region_summary <- climate_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_climate_risk_proxy = mean(climate_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_climate_risk_proxy >= 0.75 ~ "Extreme climate-development risk",
      avg_climate_risk_proxy >= 0.55 ~ "High climate-development risk",
      avg_climate_risk_proxy >= 0.35 ~ "Moderate climate-development risk",
      TRUE ~ "Lower climate-development risk"
    )
  ) %>%
  arrange(desc(avg_climate_risk_proxy))

territory_summary <- climate_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_climate_risk_proxy = mean(climate_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_climate_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region climate summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory climate summary exported to:", territory_output_file, "\n")
print(territory_summary)
