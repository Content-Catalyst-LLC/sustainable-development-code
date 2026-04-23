library(readr)
library(dplyr)

input_file <- "participation_governance_country_panel.csv"
country_output_file <- "cross_country_participation_summary.csv"
domain_output_file <- "cross_domain_participation_summary.csv"

part_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "program_domain",
  "participatory_depth_index",
  "representation_quality_index",
  "institutional_uptake_index",
  "community_control_index",
  "trust_support_index",
  "tokenism_risk_index"
)

missing_cols <- setdiff(required_cols, names(part_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

part_df <- part_df %>%
  mutate(
    participation_proxy = (
      participatory_depth_index +
      representation_quality_index +
      institutional_uptake_index +
      community_control_index
    ) / 4,
    constrained_participation_proxy = (
      participation_proxy +
      trust_support_index +
      (1 - tokenism_risk_index)
    ) / 3
  )

country_summary <- part_df %>%
  group_by(country) %>%
  summarise(
    avg_participation_proxy = mean(participation_proxy, na.rm = TRUE),
    avg_constrained_participation = mean(constrained_participation_proxy, na.rm = TRUE),
    avg_tokenism_risk = mean(tokenism_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    participation_band = case_when(
      avg_constrained_participation >= 0.75 ~ "High participatory capacity",
      avg_constrained_participation >= 0.55 ~ "Moderate participatory capacity",
      avg_constrained_participation >= 0.35 ~ "Emerging participatory capacity",
      TRUE ~ "Low participatory capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_participation))

domain_summary <- part_df %>%
  group_by(program_domain) %>%
  summarise(
    avg_participation_proxy = mean(participation_proxy, na.rm = TRUE),
    avg_constrained_participation = mean(constrained_participation_proxy, na.rm = TRUE),
    avg_tokenism_risk = mean(tokenism_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_participation))

write_csv(country_summary, country_output_file)
write_csv(domain_summary, domain_output_file)

cat("Cross-country participation summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-domain participation summary exported to:", domain_output_file, "\n")
print(domain_summary)
