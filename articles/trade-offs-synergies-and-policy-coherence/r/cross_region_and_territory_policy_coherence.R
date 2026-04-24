library(readr)
library(dplyr)

input_file <- "tradeoffs_synergies_policy_coherence_country_panel.csv"
region_output_file <- "cross_region_policy_coherence_summary.csv"
territory_output_file <- "cross_territory_policy_coherence_summary.csv"

pc_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
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

pc_df <- pc_df %>%
  mutate(
    policy_coherence_proxy = (
      tradeoff_intensity_index +
      sectoral_spillover_index +
      transboundary_spillover_index +
      intergenerational_spillover_index +
      governance_fragmentation_index +
      (1 - policy_alignment_index) +
      (1 - coordination_capacity_index) +
      (1 - impact_assessment_index) +
      (1 - monitoring_review_index) +
      (1 - sequencing_capacity_index) +
      (1 - synergy_realization_index)
    ) / 11
  )

region_summary <- pc_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_policy_coherence_proxy = mean(policy_coherence_proxy, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_policy_coherence_proxy >= 0.75 ~ "Extreme policy coherence risk",
      avg_policy_coherence_proxy >= 0.55 ~ "High policy coherence risk",
      avg_policy_coherence_proxy >= 0.35 ~ "Moderate policy coherence risk",
      TRUE ~ "Lower policy coherence risk"
    )
  ) %>%
  arrange(desc(avg_policy_coherence_proxy))

territory_summary <- pc_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_policy_coherence_proxy = mean(policy_coherence_proxy, na.rm = TRUE),
    avg_coordination_capacity = mean(coordination_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_policy_coherence_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region policy coherence summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory policy coherence summary exported to:", territory_output_file, "\n")
print(territory_summary)
