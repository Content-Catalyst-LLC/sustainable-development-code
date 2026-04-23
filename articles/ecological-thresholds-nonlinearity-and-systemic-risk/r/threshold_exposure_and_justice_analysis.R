library(readr)
library(dplyr)

input_file <- "threshold_exposure_panel.csv"
output_file <- "threshold_exposure_and_justice_summary.csv"

exp_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "system_name",
  "territory_name",
  "group_name",
  "justice_exposure_index",
  "cascade_exposure_index",
  "resilience_buffer_index",
  "monitoring_readiness_index",
  "precaution_capacity_index"
)

missing_cols <- setdiff(required_cols, names(exp_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- exp_df %>%
  mutate(
    threshold_injustice_score = (
      justice_exposure_index * 0.35 +
      cascade_exposure_index * 0.25 +
      (1 - resilience_buffer_index) * 0.20 +
      (1 - monitoring_readiness_index) * 0.10 +
      (1 - precaution_capacity_index) * 0.10
    )
  ) %>%
  group_by(system_name, territory_name, group_name) %>%
  summarise(
    avg_threshold_injustice = mean(threshold_injustice_score, na.rm = TRUE),
    avg_resilience_buffer = mean(resilience_buffer_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    injustice_band = case_when(
      avg_threshold_injustice >= 0.70 ~ "Severe threshold injustice",
      avg_threshold_injustice >= 0.50 ~ "Elevated threshold injustice",
      avg_threshold_injustice >= 0.30 ~ "Moderate threshold injustice",
      TRUE ~ "Lower threshold injustice"
    )
  ) %>%
  arrange(system_name, desc(avg_threshold_injustice))

write_csv(summary_df, output_file)

cat("Threshold exposure and justice summary exported to:", output_file, "\n")
print(summary_df)
