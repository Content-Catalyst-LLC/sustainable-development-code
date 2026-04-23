library(readr)
library(dplyr)

input_file <- "freshwater_inequality_panel.csv"
output_file <- "hydrological_exposure_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "streamflow_stress_index",
  "water_quality_burden_index",
  "health_sanitation_exposure_index",
  "freshwater_ecosystem_decline_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_freshwater_burden = (
      streamflow_stress_index * 0.20 +
      water_quality_burden_index * 0.20 +
      health_sanitation_exposure_index * 0.25 +
      freshwater_ecosystem_decline_index * 0.20 +
      (1 - governance_capacity_index) * 0.15
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_freshwater_burden = mean(unequal_freshwater_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_freshwater_burden >= 0.70 ~ "Severe unequal freshwater burden",
      avg_unequal_freshwater_burden >= 0.50 ~ "Elevated unequal freshwater burden",
      avg_unequal_freshwater_burden >= 0.30 ~ "Moderate unequal freshwater burden",
      TRUE ~ "Lower unequal freshwater burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_freshwater_burden))

write_csv(summary_df, output_file)

cat("Hydrological exposure and governance gap summary exported to:", output_file, "\n")
print(summary_df)
