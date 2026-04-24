library(readr)
library(dplyr)

input_file <- "sdg_logic_burden_panel.csv"
output_file <- "sdg_integration_monitoring_capacity_and_governance_risk_summary.csv"

sdg_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "universality_exposure_index",
  "integration_complexity_index",
  "implementation_capacity_index",
  "means_of_implementation_index",
  "partnership_readiness_index",
  "monitoring_capacity_index",
  "indicator_coverage_index",
  "review_responsiveness_index",
  "policy_fragmentation_index",
  "sdg_alignment_index"
)

missing_cols <- setdiff(required_cols, names(sdg_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- sdg_df %>%
  mutate(
    unequal_sdg_governance_burden = (
      universality_exposure_index * 0.08 +
      integration_complexity_index * 0.14 +
      (1 - implementation_capacity_index) * 0.14 +
      (1 - means_of_implementation_index) * 0.12 +
      (1 - partnership_readiness_index) * 0.10 +
      (1 - monitoring_capacity_index) * 0.12 +
      (1 - indicator_coverage_index) * 0.08 +
      (1 - review_responsiveness_index) * 0.08 +
      policy_fragmentation_index * 0.08 +
      (1 - sdg_alignment_index) * 0.06
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_sdg_governance_burden = mean(unequal_sdg_governance_burden, na.rm = TRUE),
    avg_implementation_capacity = mean(implementation_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_sdg_governance_burden >= 0.70 ~ "Severe SDG governance burden",
      avg_unequal_sdg_governance_burden >= 0.50 ~ "Elevated SDG governance burden",
      avg_unequal_sdg_governance_burden >= 0.30 ~ "Moderate SDG governance burden",
      TRUE ~ "Lower SDG governance burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_sdg_governance_burden))

write_csv(summary_df, output_file)

cat("SDG integration, monitoring capacity, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
