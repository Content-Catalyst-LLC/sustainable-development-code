library(readr)
library(dplyr)

input_file <- "global_governance_country_panel.csv"
country_output_file <- "cross_country_global_governance_summary.csv"
domain_output_file <- "cross_domain_global_governance_summary.csv"

gov_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country_or_regime",
  "region",
  "governance_domain",
  "coordination_strength_index",
  "financing_support_index",
  "knowledge_standards_index",
  "implementation_support_index",
  "legitimacy_index",
  "fragmentation_risk_index"
)

missing_cols <- setdiff(required_cols, names(gov_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

gov_df <- gov_df %>%
  mutate(
    governance_capacity_proxy = (
      coordination_strength_index +
      financing_support_index +
      knowledge_standards_index +
      implementation_support_index +
      legitimacy_index
    ) / 5,
    constrained_governance_proxy = (
      governance_capacity_proxy +
      (1 - fragmentation_risk_index)
    ) / 2
  )

country_summary <- gov_df %>%
  group_by(country_or_regime) %>%
  summarise(
    avg_governance_capacity_proxy = mean(governance_capacity_proxy, na.rm = TRUE),
    avg_constrained_governance = mean(constrained_governance_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    governance_band = case_when(
      avg_constrained_governance >= 0.75 ~ "High multilateral capacity",
      avg_constrained_governance >= 0.55 ~ "Moderate multilateral capacity",
      avg_constrained_governance >= 0.35 ~ "Emerging multilateral capacity",
      TRUE ~ "Low multilateral capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_governance))

domain_summary <- gov_df %>%
  group_by(governance_domain) %>%
  summarise(
    avg_governance_capacity_proxy = mean(governance_capacity_proxy, na.rm = TRUE),
    avg_constrained_governance = mean(constrained_governance_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_governance))

write_csv(country_summary, country_output_file)
write_csv(domain_summary, domain_output_file)

cat("Cross-country global governance summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-domain global governance summary exported to:", domain_output_file, "\n")
print(domain_summary)
