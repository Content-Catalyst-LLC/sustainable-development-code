library(readr)
library(dplyr)

input_file <- "trust_delivery_panel.csv"
output_file <- "trust_and_delivery_variation_summary.csv"

trust_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "territory_name",
  "group_name",
  "trust_support_index",
  "delivery_system_reliability_index",
  "accountability_strength_index",
  "fragmentation_risk_index",
  "capture_risk_index"
)

missing_cols <- setdiff(required_cols, names(trust_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- trust_df %>%
  mutate(
    institutional_exclusion_score = (
      (1 - trust_support_index) * 0.30 +
      (1 - delivery_system_reliability_index) * 0.25 +
      (1 - accountability_strength_index) * 0.20 +
      fragmentation_risk_index * 0.15 +
      capture_risk_index * 0.10
    )
  ) %>%
  group_by(country, territory_name, group_name) %>%
  summarise(
    avg_institutional_exclusion = mean(institutional_exclusion_score, na.rm = TRUE),
    avg_trust_support = mean(trust_support_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_institutional_exclusion >= 0.70 ~ "Severe institutional exclusion",
      avg_institutional_exclusion >= 0.50 ~ "Elevated institutional exclusion",
      avg_institutional_exclusion >= 0.30 ~ "Moderate institutional exclusion",
      TRUE ~ "Lower institutional exclusion"
    )
  ) %>%
  arrange(country, desc(avg_institutional_exclusion))

write_csv(summary_df, output_file)

cat("Trust and delivery variation summary exported to:", output_file, "\n")
print(summary_df)
