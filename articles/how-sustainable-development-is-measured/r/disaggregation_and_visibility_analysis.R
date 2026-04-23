library(readr)
library(dplyr)

input_file <- "disaggregated_development_measurement_data.csv"
gap_output_file <- "disaggregation_gap_summary.csv"
visibility_output_file <- "indicator_visibility_summary.csv"

sdg_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "goal",
  "indicator_code",
  "indicator_name",
  "group_type",
  "group_name",
  "indicator_value"
)

missing_cols <- setdiff(required_cols, names(sdg_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

group_summary <- sdg_df %>%
  group_by(country, goal, indicator_code, indicator_name, group_type) %>%
  summarise(
    min_group_value = min(indicator_value, na.rm = TRUE),
    max_group_value = max(indicator_value, na.rm = TRUE),
    avg_group_value = mean(indicator_value, na.rm = TRUE),
    subgroup_count = n_distinct(group_name),
    .groups = "drop"
  ) %>%
  mutate(
    inequality_gap = max_group_value - min_group_value,
    visibility_band = case_when(
      inequality_gap >= 0.40 ~ "High hidden inequality",
      inequality_gap >= 0.20 ~ "Moderate hidden inequality",
      inequality_gap >= 0.10 ~ "Visible inequality",
      TRUE ~ "Low measured inequality"
    )
  ) %>%
  arrange(desc(inequality_gap))

visibility_summary <- group_summary %>%
  group_by(country, goal) %>%
  summarise(
    indicators_reviewed = n(),
    avg_indicator_value = mean(avg_group_value, na.rm = TRUE),
    avg_inequality_gap = mean(inequality_gap, na.rm = TRUE),
    max_inequality_gap = max(inequality_gap, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    averaging_risk_band = case_when(
      avg_inequality_gap >= 0.30 ~ "High averaging risk",
      avg_inequality_gap >= 0.15 ~ "Moderate averaging risk",
      avg_inequality_gap >= 0.05 ~ "Limited averaging risk",
      TRUE ~ "Low averaging risk"
    )
  ) %>%
  arrange(country, desc(avg_inequality_gap))

write_csv(group_summary, gap_output_file)
write_csv(visibility_summary, visibility_output_file)

cat("Disaggregation gap summary exported to:", gap_output_file, "\n")
print(group_summary)

cat("\nIndicator visibility summary exported to:", visibility_output_file, "\n")
print(visibility_summary)
