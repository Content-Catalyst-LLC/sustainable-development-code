library(readr)
library(dplyr)

input_file <- "trust_service_distortion_panel.csv"
output_file <- "trust_and_service_distortion_summary.csv"

trust_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "territory_name",
  "group_name",
  "service_integrity_index",
  "accountability_strength_index",
  "trust_support_index",
  "capture_risk_index",
  "selective_enforcement_risk_index"
)

missing_cols <- setdiff(required_cols, names(trust_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- trust_df %>%
  mutate(
    distortion_risk_score = (
      (1 - service_integrity_index) * 0.30 +
      (1 - accountability_strength_index) * 0.25 +
      (1 - trust_support_index) * 0.20 +
      capture_risk_index * 0.15 +
      selective_enforcement_risk_index * 0.10
    )
  ) %>%
  group_by(country, territory_name, group_name) %>%
  summarise(
    avg_distortion_risk = mean(distortion_risk_score, na.rm = TRUE),
    avg_trust_support = mean(trust_support_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    distortion_band = case_when(
      avg_distortion_risk >= 0.70 ~ "Severe institutional distortion",
      avg_distortion_risk >= 0.50 ~ "Elevated institutional distortion",
      avg_distortion_risk >= 0.30 ~ "Moderate institutional distortion",
      TRUE ~ "Lower institutional distortion"
    )
  ) %>%
  arrange(country, desc(avg_distortion_risk))

write_csv(summary_df, output_file)

cat("Trust and service distortion summary exported to:", output_file, "\n")
print(summary_df)
