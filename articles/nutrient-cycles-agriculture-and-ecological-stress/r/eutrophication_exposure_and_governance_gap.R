library(readr)
library(dplyr)

input_file <- "nutrient_inequality_panel.csv"
output_file <- "eutrophication_exposure_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "runoff_leakage_index",
  "eutrophication_exposure_index",
  "water_quality_burden_index",
  "governance_capacity_index",
  "food_system_dependence_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_nutrient_burden = (
      runoff_leakage_index * 0.20 +
      eutrophication_exposure_index * 0.30 +
      water_quality_burden_index * 0.25 +
      food_system_dependence_index * 0.15 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_nutrient_burden = mean(unequal_nutrient_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_nutrient_burden >= 0.70 ~ "Severe unequal nutrient burden",
      avg_unequal_nutrient_burden >= 0.50 ~ "Elevated unequal nutrient burden",
      avg_unequal_nutrient_burden >= 0.30 ~ "Moderate unequal nutrient burden",
      TRUE ~ "Lower unequal nutrient burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_nutrient_burden))

write_csv(summary_df, output_file)

cat("Eutrophication exposure and governance gap summary exported to:", output_file, "\n")
print(summary_df)
