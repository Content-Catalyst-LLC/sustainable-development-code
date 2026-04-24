library(readr)
library(dplyr)

input_file <- "what_is_sustainable_development_country_panel.csv"
region_output_file <- "cross_region_sustainable_development_summary.csv"
territory_output_file <- "cross_territory_sustainable_development_summary.csv"

sd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "present_deprivation_index",
  "human_wellbeing_support_index",
  "ecological_stress_index",
  "future_burden_transfer_index",
  "institutional_durability_index",
  "systems_interdependence_risk_index",
  "long_run_viability_index",
  "governance_capacity_index",
  "planetary_constraint_exposure_index",
  "development_alignment_index"
)

missing_cols <- setdiff(required_cols, names(sd_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

sd_df <- sd_df %>%
  mutate(
    sustainable_development_proxy = (
      present_deprivation_index +
      (1 - human_wellbeing_support_index) +
      ecological_stress_index +
      future_burden_transfer_index +
      (1 - institutional_durability_index) +
      systems_interdependence_risk_index +
      (1 - long_run_viability_index) +
      (1 - governance_capacity_index) +
      planetary_constraint_exposure_index +
      (1 - development_alignment_index)
    ) / 10
  )

region_summary <- sd_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_sustainable_development_proxy = mean(sustainable_development_proxy, na.rm = TRUE),
    avg_viability_capacity = mean((institutional_durability_index + long_run_viability_index + governance_capacity_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_sustainable_development_proxy >= 0.75 ~ "Extreme sustainable development risk",
      avg_sustainable_development_proxy >= 0.55 ~ "High sustainable development risk",
      avg_sustainable_development_proxy >= 0.35 ~ "Moderate sustainable development risk",
      TRUE ~ "Lower sustainable development risk"
    )
  ) %>%
  arrange(desc(avg_sustainable_development_proxy))

territory_summary <- sd_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_sustainable_development_proxy = mean(sustainable_development_proxy, na.rm = TRUE),
    avg_viability_capacity = mean((institutional_durability_index + long_run_viability_index + governance_capacity_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_sustainable_development_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region sustainable development summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory sustainable development summary exported to:", territory_output_file, "\n")
print(territory_summary)
