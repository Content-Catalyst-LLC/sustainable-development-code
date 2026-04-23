library(readr)
library(dplyr)

input_file <- "scenario_panel.csv"
output_file <- "scenario_panel_summary.csv"

scenario_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "year",
  "scenario_family",
  "robustness_index",
  "adaptive_capacity_index",
  "institutional_learning_index",
  "equity_protection_index"
)

missing_cols <- setdiff(required_cols, names(scenario_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

scenario_df <- scenario_df %>%
  mutate(
    composite_resilience_proxy = (
      robustness_index +
      adaptive_capacity_index +
      institutional_learning_index +
      equity_protection_index
    ) / 4
  )

summary_df <- scenario_df %>%
  group_by(country, scenario_family) %>%
  summarise(
    avg_resilience_proxy = mean(composite_resilience_proxy, na.rm = TRUE),
    min_resilience_proxy = min(composite_resilience_proxy, na.rm = TRUE),
    max_resilience_proxy = max(composite_resilience_proxy, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(country, desc(avg_resilience_proxy))

write_csv(summary_df, output_file)

cat("Scenario panel summary exported to:", output_file, "\n")
print(summary_df)
