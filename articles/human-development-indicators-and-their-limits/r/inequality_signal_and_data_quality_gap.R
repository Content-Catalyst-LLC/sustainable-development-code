library(readr)
library(dplyr)

input_file <- "indicator_inequality_panel.csv"
output_file <- "inequality_signal_and_data_quality_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "inequality_penalty_index",
  "gender_gap_index",
  "multidimensional_poverty_index",
  "subnational_variation_index",
  "data_quality_confidence_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_indicator_burden = (
      inequality_penalty_index * 0.25 +
      gender_gap_index * 0.20 +
      multidimensional_poverty_index * 0.25 +
      subnational_variation_index * 0.15 +
      (1 - data_quality_confidence_index) * 0.15
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_indicator_burden = mean(unequal_indicator_burden, na.rm = TRUE),
    avg_data_quality_confidence = mean(data_quality_confidence_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_indicator_burden >= 0.70 ~ "Severe unequal indicator burden",
      avg_unequal_indicator_burden >= 0.50 ~ "Elevated unequal indicator burden",
      avg_unequal_indicator_burden >= 0.30 ~ "Moderate unequal indicator burden",
      TRUE ~ "Lower unequal indicator burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_indicator_burden))

write_csv(summary_df, output_file)

cat("Inequality signal and data-quality gap summary exported to:", output_file, "\n")
print(summary_df)
