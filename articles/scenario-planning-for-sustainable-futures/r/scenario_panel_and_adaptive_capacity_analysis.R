library(readr)
library(dplyr)

input_file <- "scenario_panel.csv"
output_file <- "scenario_panel_summary.csv"
adaptive_output_file <- "adaptive_capacity_trends.csv"

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

scenario_summary <- scenario_df %>%
  group_by(country, scenario_family) %>%
  summarise(
    avg_resilience_proxy = mean(composite_resilience_proxy, na.rm = TRUE),
    min_resilience_proxy = min(composite_resilience_proxy, na.rm = TRUE),
    max_resilience_proxy = max(composite_resilience_proxy, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(country, desc(avg_resilience_proxy))

adaptive_summary <- scenario_df %>%
  group_by(country) %>%
  summarise(
    start_adaptive_capacity = first(adaptive_capacity_index),
    end_adaptive_capacity = last(adaptive_capacity_index),
    start_learning = first(institutional_learning_index),
    end_learning = last(institutional_learning_index),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    adaptive_capacity_change = end_adaptive_capacity - start_adaptive_capacity,
    learning_change = end_learning - start_learning
  ) %>%
  arrange(desc(adaptive_capacity_change))

write_csv(scenario_summary, output_file)
write_csv(adaptive_summary, adaptive_output_file)

cat("Scenario panel summary exported to:", output_file, "\n")
print(scenario_summary)

cat("\nAdaptive capacity trends exported to:", adaptive_output_file, "\n")
print(adaptive_summary)
