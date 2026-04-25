library(readr)
library(dplyr)

input_file <- "articles/freshwater-change-and-development-risk/data/freshwater_change_panel.csv"
region_output_file <- "articles/freshwater-change-and-development-risk/data/cross_region_freshwater_summary.csv"
territory_output_file <- "articles/freshwater-change-and-development-risk/data/cross_territory_freshwater_summary.csv"

water_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "streamflow_stress_index",
  "soil_moisture_stress_index",
  "water_quality_burden_index",
  "wastewater_treatment_deficit_index",
  "freshwater_ecosystem_decline_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(water_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

water_df <- water_df %>%
  mutate(
    freshwater_risk_proxy = (
      streamflow_stress_index +
        soil_moisture_stress_index +
        water_quality_burden_index +
        wastewater_treatment_deficit_index +
        freshwater_ecosystem_decline_index +
        (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- water_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_freshwater_risk_proxy = mean(freshwater_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_freshwater_risk_proxy >= 0.75 ~ "Extreme freshwater-development risk",
      avg_freshwater_risk_proxy >= 0.55 ~ "High freshwater-development risk",
      avg_freshwater_risk_proxy >= 0.35 ~ "Moderate freshwater-development risk",
      TRUE ~ "Lower freshwater-development risk"
    )
  ) %>%
  arrange(desc(avg_freshwater_risk_proxy))

territory_summary <- water_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_freshwater_risk_proxy = mean(freshwater_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_freshwater_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region freshwater summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory freshwater summary exported to:", territory_output_file, "\n")
print(territory_summary)
