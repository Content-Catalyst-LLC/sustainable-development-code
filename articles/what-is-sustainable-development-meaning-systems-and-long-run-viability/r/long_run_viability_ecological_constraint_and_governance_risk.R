library(readr)
library(dplyr)

input_file <- "sustainable_development_burden_panel.csv"
output_file <- "long_run_viability_ecological_constraint_and_governance_risk_summary.csv"

sd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
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

summary_df <- sd_df %>%
  mutate(
    unequal_sustainable_development_burden = (
      present_deprivation_index * 0.16 +
      (1 - human_wellbeing_support_index) * 0.12 +
      ecological_stress_index * 0.14 +
      future_burden_transfer_index * 0.12 +
      (1 - institutional_durability_index) * 0.12 +
      systems_interdependence_risk_index * 0.10 +
      (1 - long_run_viability_index) * 0.10 +
      (1 - governance_capacity_index) * 0.08 +
      planetary_constraint_exposure_index * 0.04 +
      (1 - development_alignment_index) * 0.02
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_sustainable_development_burden = mean(unequal_sustainable_development_burden, na.rm = TRUE),
    avg_viability_capacity = mean((institutional_durability_index + long_run_viability_index + governance_capacity_index) / 3, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_sustainable_development_burden >= 0.70 ~ "Severe sustainable development burden",
      avg_unequal_sustainable_development_burden >= 0.50 ~ "Elevated sustainable development burden",
      avg_unequal_sustainable_development_burden >= 0.30 ~ "Moderate sustainable development burden",
      TRUE ~ "Lower sustainable development burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_sustainable_development_burden))

write_csv(summary_df, output_file)

cat("Long-run viability, ecological-constraint, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
