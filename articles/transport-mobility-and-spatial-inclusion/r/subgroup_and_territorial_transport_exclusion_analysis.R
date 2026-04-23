library(readr)
library(dplyr)

input_file <- "transport_exclusion_panel.csv"
output_file <- "subgroup_and_territorial_transport_exclusion_summary.csv"

exclusion_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region_name",
  "group_name",
  "fare_affordability_index",
  "safety_index",
  "disability_access_index",
  "service_reliability_index",
  "trip_burden_index",
  "peripherality_index"
)

missing_cols <- setdiff(required_cols, names(exclusion_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- exclusion_df %>%
  mutate(
    exclusion_risk_score = (
      (1 - fare_affordability_index) * 0.20 +
      (1 - safety_index) * 0.20 +
      (1 - disability_access_index) * 0.20 +
      (1 - service_reliability_index) * 0.15 +
      trip_burden_index * 0.15 +
      peripherality_index * 0.10
    )
  ) %>%
  group_by(country, region_name, group_name) %>%
  summarise(
    avg_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    avg_service_reliability = mean(service_reliability_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_exclusion_risk >= 0.70 ~ "Severe transport exclusion",
      avg_exclusion_risk >= 0.50 ~ "Elevated transport exclusion",
      avg_exclusion_risk >= 0.30 ~ "Moderate transport exclusion",
      TRUE ~ "Lower transport exclusion"
    )
  ) %>%
  arrange(country, desc(avg_exclusion_risk))

write_csv(summary_df, output_file)

cat("Subgroup and territorial transport exclusion summary exported to:", output_file, "\n")
print(summary_df)
