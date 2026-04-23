library(readr)
library(dplyr)

input_file <- "policy_coherence_country_panel.csv"
country_output_file <- "cross_country_policy_coherence_summary.csv"
sector_output_file <- "cross_sector_policy_coherence_summary.csv"

policy_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "policy_domain",
  "cross_sector_alignment_index",
  "spillover_management_index",
  "implementation_alignment_index",
  "multilevel_coordination_index",
  "resilience_integration_index",
  "lock_in_risk_index"
)

missing_cols <- setdiff(required_cols, names(policy_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

policy_df <- policy_df %>%
  mutate(
    coherence_proxy = (
      cross_sector_alignment_index +
      spillover_management_index +
      implementation_alignment_index +
      multilevel_coordination_index
    ) / 4,
    constrained_governance_proxy = (
      coherence_proxy +
      resilience_integration_index +
      (1 - lock_in_risk_index)
    ) / 3
  )

country_summary <- policy_df %>%
  group_by(country) %>%
  summarise(
    avg_coherence_proxy = mean(coherence_proxy, na.rm = TRUE),
    avg_constrained_governance = mean(constrained_governance_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    coherence_band = case_when(
      avg_constrained_governance >= 0.75 ~ "High coordination capacity",
      avg_constrained_governance >= 0.55 ~ "Moderate coordination capacity",
      avg_constrained_governance >= 0.35 ~ "Emerging coordination capacity",
      TRUE ~ "Low coordination capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_governance))

sector_summary <- policy_df %>%
  group_by(policy_domain) %>%
  summarise(
    avg_coherence_proxy = mean(coherence_proxy, na.rm = TRUE),
    avg_constrained_governance = mean(constrained_governance_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_governance))

write_csv(country_summary, country_output_file)
write_csv(sector_summary, sector_output_file)

cat("Cross-country policy coherence summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-sector policy coherence summary exported to:", sector_output_file, "\n")
print(sector_summary)
