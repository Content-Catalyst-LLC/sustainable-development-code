library(readr)
library(dplyr)

input_file <- "adaptive_capacity_panel.csv"
output_file <- "adaptive_capacity_summary.csv"
year_output_file <- "adaptive_capacity_year_summary.csv"

cap_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "year",
  "institutional_learning_index",
  "adaptive_capacity_index",
  "resilience_index",
  "policy_flexibility_index",
  "equity_protection_index"
)

missing_cols <- setdiff(required_cols, names(cap_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

cap_df <- cap_df %>%
  mutate(
    robustness_proxy = (
      institutional_learning_index +
      adaptive_capacity_index +
      resilience_index +
      policy_flexibility_index +
      equity_protection_index
    ) / 5,
    learning_resilience_gap = institutional_learning_index - resilience_index
  )

country_summary <- cap_df %>%
  group_by(country) %>%
  summarise(
    avg_robustness_proxy = mean(robustness_proxy, na.rm = TRUE),
    min_robustness_proxy = min(robustness_proxy, na.rm = TRUE),
    max_robustness_proxy = max(robustness_proxy, na.rm = TRUE),
    avg_learning_resilience_gap = mean(learning_resilience_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    robustness_band = case_when(
      avg_robustness_proxy >= 0.70 ~ "High robustness",
      avg_robustness_proxy >= 0.50 ~ "Moderate robustness",
      avg_robustness_proxy >= 0.35 ~ "Stressed robustness",
      TRUE ~ "Low robustness"
    )
  ) %>%
  arrange(desc(avg_robustness_proxy))

year_summary <- cap_df %>%
  group_by(year) %>%
  summarise(
    avg_robustness_proxy = mean(robustness_proxy, na.rm = TRUE),
    avg_adaptive_capacity = mean(adaptive_capacity_index, na.rm = TRUE),
    avg_policy_flexibility = mean(policy_flexibility_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(year)

write_csv(country_summary, output_file)
write_csv(year_summary, year_output_file)

cat("Adaptive capacity summary exported to:", output_file, "\n")
print(country_summary)

cat("\nYear summary exported to:", year_output_file, "\n")
print(year_summary)
