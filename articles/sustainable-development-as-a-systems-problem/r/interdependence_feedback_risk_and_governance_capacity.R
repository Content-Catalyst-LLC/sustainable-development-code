library(readr)
library(dplyr)

input_file <- "systems_problem_burden_panel.csv"
output_file <- "interdependence_feedback_risk_and_governance_capacity_summary.csv"

systems_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "interdependence_intensity_index",
  "feedback_risk_index",
  "delay_exposure_index",
  "path_dependence_index",
  "cross_scale_pressure_index",
  "earth_system_stress_index",
  "governance_fragmentation_index",
  "coordination_capacity_index",
  "institutional_integration_index",
  "leverage_point_capacity_index"
)

missing_cols <- setdiff(required_cols, names(systems_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- systems_df %>%
  mutate(
    unequal_systems_burden = (
      interdependence_intensity_index * 0.14 +
      feedback_risk_index * 0.14 +
      delay_exposure_index * 0.12 +
      path_dependence_index * 0.10 +
      cross_scale_pressure_index * 0.10 +
      earth_system_stress_index * 0.12 +
      governance_fragmentation_index * 0.10 +
      (1 - coordination_capacity_index) * 0.08 +
      (1 - institutional_integration_index) * 0.06 +
      (1 - leverage_point_capacity_index) * 0.04
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_systems_burden = mean(unequal_systems_burden, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_systems_burden >= 0.70 ~ "Severe systems burden",
      avg_unequal_systems_burden >= 0.50 ~ "Elevated systems burden",
      avg_unequal_systems_burden >= 0.30 ~ "Moderate systems burden",
      TRUE ~ "Lower systems burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_systems_burden))

write_csv(summary_df, output_file)

cat("Interdependence, feedback-risk, and governance-capacity summary exported to:", output_file, "\n")
print(summary_df)
