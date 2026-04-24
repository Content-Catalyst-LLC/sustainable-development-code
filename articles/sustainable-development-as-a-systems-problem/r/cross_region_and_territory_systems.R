library(readr)
library(dplyr)

input_file <- "sustainable_development_systems_problem_country_panel.csv"
region_output_file <- "cross_region_systems_summary.csv"
territory_output_file <- "cross_territory_systems_summary.csv"

systems_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
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

systems_df <- systems_df %>%
  mutate(
    systems_problem_proxy = (
      interdependence_intensity_index +
      feedback_risk_index +
      delay_exposure_index +
      path_dependence_index +
      cross_scale_pressure_index +
      earth_system_stress_index +
      governance_fragmentation_index +
      (1 - coordination_capacity_index) +
      (1 - institutional_integration_index) +
      (1 - leverage_point_capacity_index)
    ) / 10
  )

region_summary <- systems_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_systems_problem_proxy = mean(systems_problem_proxy, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_systems_problem_proxy >= 0.75 ~ "Extreme systems fragility",
      avg_systems_problem_proxy >= 0.55 ~ "High systems fragility",
      avg_systems_problem_proxy >= 0.35 ~ "Moderate systems fragility",
      TRUE ~ "Lower systems fragility"
    )
  ) %>%
  arrange(desc(avg_systems_problem_proxy))

territory_summary <- systems_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_systems_problem_proxy = mean(systems_problem_proxy, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_systems_problem_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region systems summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory systems summary exported to:", territory_output_file, "\n")
print(territory_summary)
