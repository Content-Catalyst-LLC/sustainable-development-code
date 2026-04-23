library(readr)
library(dplyr)

input_file <- "coastal_exposure_panel.csv"
output_file <- "coastal_exposure_and_compound_ocean_risk_summary.csv"

exp_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "coastal_system_name",
  "territory_name",
  "group_name",
  "acidification_pressure_index",
  "marine_dependence_index",
  "justice_exposure_index",
  "coastal_infrastructure_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(exp_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- exp_df %>%
  mutate(
    unequal_coastal_ocean_burden = (
      acidification_pressure_index * 0.20 +
      marine_dependence_index * 0.25 +
      justice_exposure_index * 0.25 +
      coastal_infrastructure_exposure_index * 0.20 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(coastal_system_name, territory_name, group_name) %>%
  summarise(
    avg_unequal_coastal_ocean_burden = mean(unequal_coastal_ocean_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_coastal_ocean_burden >= 0.70 ~ "Severe unequal coastal-ocean burden",
      avg_unequal_coastal_ocean_burden >= 0.50 ~ "Elevated unequal coastal-ocean burden",
      avg_unequal_coastal_ocean_burden >= 0.30 ~ "Moderate unequal coastal-ocean burden",
      TRUE ~ "Lower unequal coastal-ocean burden"
    )
  ) %>%
  arrange(coastal_system_name, desc(avg_unequal_coastal_ocean_burden))

write_csv(summary_df, output_file)

cat("Coastal exposure and compound ocean-risk summary exported to:", output_file, "\n")
print(summary_df)
