library(readr)
library(dplyr)

input_file <- "food_inequality_panel.csv"
output_file <- "inequality_affordability_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "food_access_index",
  "healthy_diet_affordability_stress_index",
  "nutrition_quality_index",
  "poverty_exposure_index",
  "child_maternal_risk_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_food_burden = (
      (1 - food_access_index) * 0.20 +
      healthy_diet_affordability_stress_index * 0.20 +
      (1 - nutrition_quality_index) * 0.15 +
      poverty_exposure_index * 0.20 +
      child_maternal_risk_index * 0.15 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_food_burden = mean(unequal_food_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_food_burden >= 0.70 ~ "Severe unequal food burden",
      avg_unequal_food_burden >= 0.50 ~ "Elevated unequal food burden",
      avg_unequal_food_burden >= 0.30 ~ "Moderate unequal food burden",
      TRUE ~ "Lower unequal food burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_food_burden))

write_csv(summary_df, output_file)

cat("Inequality, affordability, and governance gap summary exported to:", output_file, "\n")
print(summary_df)
