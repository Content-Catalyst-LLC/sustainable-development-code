library(readr)
library(dplyr)

input_file <- "urban_inequality_panel.csv"
output_file <- "housing_inequality_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "housing_adequacy_index",
  "housing_affordability_stress_index",
  "basic_services_access_index",
  "informality_exclusion_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_urban_burden = (
      (1 - housing_adequacy_index) * 0.20 +
      housing_affordability_stress_index * 0.20 +
      (1 - basic_services_access_index) * 0.20 +
      informality_exclusion_index * 0.15 +
      justice_exposure_index * 0.15 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_urban_burden = mean(unequal_urban_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_urban_burden >= 0.70 ~ "Severe unequal urban burden",
      avg_unequal_urban_burden >= 0.50 ~ "Elevated unequal urban burden",
      avg_unequal_urban_burden >= 0.30 ~ "Moderate unequal urban burden",
      TRUE ~ "Lower unequal urban burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_urban_burden))

write_csv(summary_df, output_file)

cat("Housing inequality and governance gap summary exported to:", output_file, "\n")
print(summary_df)
