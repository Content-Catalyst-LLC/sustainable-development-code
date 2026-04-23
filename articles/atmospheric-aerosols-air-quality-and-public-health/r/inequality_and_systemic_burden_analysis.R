library(readr)
library(dplyr)

input_file <- "air_quality_inequality_panel.csv"
output_file <- "inequality_and_systemic_burden_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "ambient_pm25_index",
  "household_energy_exposure_index",
  "exposure_inequality_index",
  "mitigation_capacity_index",
  "health_sensitivity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_burden_score = (
      ambient_pm25_index * 0.25 +
      household_energy_exposure_index * 0.20 +
      exposure_inequality_index * 0.25 +
      health_sensitivity_index * 0.20 +
      (1 - mitigation_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_burden = mean(unequal_burden_score, na.rm = TRUE),
    avg_mitigation_capacity = mean(mitigation_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_burden >= 0.70 ~ "Severe unequal aerosol burden",
      avg_unequal_burden >= 0.50 ~ "Elevated unequal aerosol burden",
      avg_unequal_burden >= 0.30 ~ "Moderate unequal aerosol burden",
      TRUE ~ "Lower unequal aerosol burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_burden))

write_csv(summary_df, output_file)

cat("Inequality and systemic burden summary exported to:", output_file, "\n")
print(summary_df)
