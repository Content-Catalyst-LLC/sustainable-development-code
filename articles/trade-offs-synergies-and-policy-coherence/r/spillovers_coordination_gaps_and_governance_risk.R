library(readr)
library(dplyr)

input_file <- "policy_coherence_burden_panel.csv"
output_file <- "spillovers_coordination_gaps_and_governance_risk_summary.csv"

pc_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "tradeoff_intensity_index",
  "synergy_realization_index",
  "sectoral_spillover_index",
  "transboundary_spillover_index",
  "intergenerational_spillover_index",
  "coordination_capacity_index",
  "impact_assessment_index",
  "monitoring_review_index",
  "sequencing_capacity_index",
  "governance_fragmentation_index",
  "policy_alignment_index"
)

missing_cols <- setdiff(required_cols, names(pc_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- pc_df %>%
  mutate(
    unequal_policy_coherence_burden = (
      tradeoff_intensity_index * 0.14 +
      sectoral_spillover_index * 0.14 +
      transboundary_spillover_index * 0.12 +
      intergenerational_spillover_index * 0.12 +
      governance_fragmentation_index * 0.14 +
      (1 - policy_alignment_index) * 0.10 +
      (1 - coordination_capacity_index) * 0.08 +
      (1 - impact_assessment_index) * 0.06 +
      (1 - monitoring_review_index) * 0.04 +
      (1 - sequencing_capacity_index) * 0.03 +
      (1 - synergy_realization_index) * 0.03
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_policy_coherence_burden = mean(unequal_policy_coherence_burden, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_policy_coherence_burden >= 0.70 ~ "Severe policy coherence burden",
      avg_unequal_policy_coherence_burden >= 0.50 ~ "Elevated policy coherence burden",
      avg_unequal_policy_coherence_burden >= 0.30 ~ "Moderate policy coherence burden",
      TRUE ~ "Lower policy coherence burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_policy_coherence_burden))

write_csv(summary_df, output_file)

cat("Spillovers, coordination gaps, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
