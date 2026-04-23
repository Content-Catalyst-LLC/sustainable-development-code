library(readr)
library(dplyr)

input_file <- "capability_inequality_panel.csv"
output_file <- "capability_gaps_public_systems_and_governance_risk_summary.csv"

cap_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "health_access_index",
  "education_access_index",
  "service_quality_index",
  "financial_hardship_risk_index",
  "learning_deprivation_index",
  "inequality_exclusion_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(cap_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- cap_df %>%
  mutate(
    unequal_capability_burden = (
      (1 - health_access_index) * 0.15 +
      (1 - education_access_index) * 0.15 +
      (1 - service_quality_index) * 0.15 +
      financial_hardship_risk_index * 0.20 +
      learning_deprivation_index * 0.15 +
      inequality_exclusion_index * 0.15 +
      (1 - governance_capacity_index) * 0.05
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_capability_burden = mean(unequal_capability_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_capability_burden >= 0.70 ~ "Severe unequal capability burden",
      avg_unequal_capability_burden >= 0.50 ~ "Elevated unequal capability burden",
      avg_unequal_capability_burden >= 0.30 ~ "Moderate unequal capability burden",
      TRUE ~ "Lower unequal capability burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_capability_burden))

write_csv(summary_df, output_file)

cat("Capability-gaps, public-systems, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
