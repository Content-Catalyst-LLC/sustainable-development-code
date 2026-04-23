library(readr)
library(dplyr)

input_file <- "ecological_thresholds_country_panel.csv"
region_output_file <- "cross_region_threshold_summary.csv"
ecosystem_output_file <- "cross_ecosystem_threshold_summary.csv"

thr_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "system_name",
  "country_or_region",
  "ecosystem_type",
  "cumulative_pressure_index",
  "feedback_intensity_index",
  "cascade_exposure_index",
  "resilience_buffer_index",
  "justice_exposure_index"
)

missing_cols <- setdiff(required_cols, names(thr_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

thr_df <- thr_df %>%
  mutate(
    threshold_risk_proxy = (
      cumulative_pressure_index +
      feedback_intensity_index +
      cascade_exposure_index +
      justice_exposure_index +
      (1 - resilience_buffer_index)
    ) / 5
  )

region_summary <- thr_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_threshold_risk_proxy = mean(threshold_risk_proxy, na.rm = TRUE),
    avg_resilience_buffer = mean(resilience_buffer_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    threshold_band = case_when(
      avg_threshold_risk_proxy >= 0.75 ~ "Extreme threshold risk",
      avg_threshold_risk_proxy >= 0.55 ~ "High threshold risk",
      avg_threshold_risk_proxy >= 0.35 ~ "Moderate threshold risk",
      TRUE ~ "Lower threshold risk"
    )
  ) %>%
  arrange(desc(avg_threshold_risk_proxy))

ecosystem_summary <- thr_df %>%
  group_by(ecosystem_type) %>%
  summarise(
    avg_threshold_risk_proxy = mean(threshold_risk_proxy, na.rm = TRUE),
    avg_resilience_buffer = mean(resilience_buffer_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_threshold_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(ecosystem_summary, ecosystem_output_file)

cat("Cross-region threshold summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-ecosystem threshold summary exported to:", ecosystem_output_file, "\n")
print(ecosystem_summary)
