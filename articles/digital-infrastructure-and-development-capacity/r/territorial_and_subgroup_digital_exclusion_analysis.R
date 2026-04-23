library(readr)
library(dplyr)

input_file <- "digital_exclusion_panel.csv"
output_file <- "territorial_and_subgroup_digital_exclusion_summary.csv"

exclusion_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region_name",
  "group_name",
  "offline_rate",
  "device_access_index",
  "digital_literacy_index",
  "service_usability_index",
  "trust_index",
  "accessibility_index"
)

missing_cols <- setdiff(required_cols, names(exclusion_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- exclusion_df %>%
  mutate(
    exclusion_risk_score = (
      offline_rate * 0.30 +
      (1 - device_access_index) * 0.20 +
      (1 - digital_literacy_index) * 0.20 +
      (1 - service_usability_index) * 0.15 +
      (1 - trust_index) * 0.10 +
      (1 - accessibility_index) * 0.05
    )
  ) %>%
  group_by(country, region_name, group_name) %>%
  summarise(
    avg_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    avg_service_usability = mean(service_usability_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_exclusion_risk >= 0.70 ~ "Severe exclusion risk",
      avg_exclusion_risk >= 0.50 ~ "Elevated exclusion risk",
      avg_exclusion_risk >= 0.30 ~ "Moderate exclusion risk",
      TRUE ~ "Lower exclusion risk"
    )
  ) %>%
  arrange(country, desc(avg_exclusion_risk))

write_csv(summary_df, output_file)

cat("Territorial and subgroup digital exclusion summary exported to:", output_file, "\n")
print(summary_df)
