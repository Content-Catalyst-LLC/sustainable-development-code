library(readr)
library(dplyr)

input_file <- "disaggregated_development_measurement_data.csv"
output_file <- "group_reporting_coverage_summary.csv"

sdg_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "goal",
  "indicator_code",
  "group_type",
  "group_name",
  "indicator_value"
)

missing_cols <- setdiff(required_cols, names(sdg_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

coverage_summary <- sdg_df %>%
  mutate(is_reported = !is.na(indicator_value)) %>%
  group_by(country, goal, indicator_code, group_type) %>%
  summarise(
    groups_expected = n_distinct(group_name),
    groups_reported = n_distinct(group_name[is_reported]),
    coverage_rate = groups_reported / groups_expected,
    .groups = "drop"
  ) %>%
  mutate(
    coverage_band = case_when(
      coverage_rate >= 0.90 ~ "High coverage",
      coverage_rate >= 0.70 ~ "Moderate coverage",
      coverage_rate >= 0.40 ~ "Low coverage",
      TRUE ~ "Very low coverage"
    )
  ) %>%
  arrange(country, goal, indicator_code, coverage_rate)

write_csv(coverage_summary, output_file)

cat("Group reporting coverage exported to:", output_file, "\n")
print(coverage_summary)
