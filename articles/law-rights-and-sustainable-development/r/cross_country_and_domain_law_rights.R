library(readr)
library(dplyr)

input_file <- "law_rights_country_panel.csv"
country_output_file <- "cross_country_law_rights_summary.csv"
domain_output_file <- "cross_domain_law_rights_summary.csv"

law_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "legal_domain",
  "rights_protection_index",
  "access_to_justice_index",
  "procedural_participation_index",
  "environmental_rights_integration_index",
  "non_discrimination_protection_index",
  "legal_exclusion_risk_index"
)

missing_cols <- setdiff(required_cols, names(law_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

law_df <- law_df %>%
  mutate(
    legal_capacity_proxy = (
      rights_protection_index +
      access_to_justice_index +
      procedural_participation_index +
      non_discrimination_protection_index
    ) / 4,
    constrained_legal_proxy = (
      legal_capacity_proxy +
      environmental_rights_integration_index +
      (1 - legal_exclusion_risk_index)
    ) / 3
  )

country_summary <- law_df %>%
  group_by(country) %>%
  summarise(
    avg_legal_capacity_proxy = mean(legal_capacity_proxy, na.rm = TRUE),
    avg_constrained_legal = mean(constrained_legal_proxy, na.rm = TRUE),
    avg_exclusion_risk = mean(legal_exclusion_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    legal_band = case_when(
      avg_constrained_legal >= 0.75 ~ "High legal-development capacity",
      avg_constrained_legal >= 0.55 ~ "Moderate legal-development capacity",
      avg_constrained_legal >= 0.35 ~ "Emerging legal-development capacity",
      TRUE ~ "Low legal-development capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_legal))

domain_summary <- law_df %>%
  group_by(legal_domain) %>%
  summarise(
    avg_legal_capacity_proxy = mean(legal_capacity_proxy, na.rm = TRUE),
    avg_constrained_legal = mean(constrained_legal_proxy, na.rm = TRUE),
    avg_exclusion_risk = mean(legal_exclusion_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_legal))

write_csv(country_summary, country_output_file)
write_csv(domain_summary, domain_output_file)

cat("Cross-country law and rights summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-domain law and rights summary exported to:", domain_output_file, "\n")
print(domain_summary)
