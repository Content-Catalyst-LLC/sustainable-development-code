library(readr)
library(dplyr)

input_file <- "local_governance_exclusion_panel.csv"
output_file <- "local_governance_and_exclusion_summary.csv"

local_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "territory_name",
  "group_name",
  "representation_quality_index",
  "local_capacity_index",
  "institutional_uptake_index",
  "tokenism_risk_index",
  "elite_capture_risk_index",
  "trust_support_index"
)

missing_cols <- setdiff(required_cols, names(local_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- local_df %>%
  mutate(
    exclusion_risk_score = (
      (1 - representation_quality_index) * 0.30 +
      (1 - local_capacity_index) * 0.20 +
      (1 - institutional_uptake_index) * 0.20 +
      tokenism_risk_index * 0.15 +
      elite_capture_risk_index * 0.15
    )
  ) %>%
  group_by(country, territory_name, group_name) %>%
  summarise(
    avg_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    avg_trust_support = mean(trust_support_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_exclusion_risk >= 0.70 ~ "Severe participatory exclusion",
      avg_exclusion_risk >= 0.50 ~ "Elevated participatory exclusion",
      avg_exclusion_risk >= 0.30 ~ "Moderate participatory exclusion",
      TRUE ~ "Lower participatory exclusion"
    )
  ) %>%
  arrange(country, desc(avg_exclusion_risk))

write_csv(summary_df, output_file)

cat("Local governance and exclusion summary exported to:", output_file, "\n")
print(summary_df)
