library(readr)
library(dplyr)

input_file <- "work_inequality_panel.csv"
output_file <- "informality_exclusion_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "informality_risk_index",
  "precarity_risk_index",
  "income_security_index",
  "youth_exclusion_index",
  "gender_livelihood_gap_index",
  "social_protection_coverage_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_work_burden = (
      informality_risk_index * 0.20 +
      precarity_risk_index * 0.20 +
      (1 - income_security_index) * 0.20 +
      youth_exclusion_index * 0.20 +
      gender_livelihood_gap_index * 0.10 +
      (1 - social_protection_coverage_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_work_burden = mean(unequal_work_burden, na.rm = TRUE),
    avg_social_protection = mean(social_protection_coverage_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_work_burden >= 0.70 ~ "Severe unequal work burden",
      avg_unequal_work_burden >= 0.50 ~ "Elevated unequal work burden",
      avg_unequal_work_burden >= 0.30 ~ "Moderate unequal work burden",
      TRUE ~ "Lower unequal work burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_work_burden))

write_csv(summary_df, output_file)

cat("Informality, exclusion, and governance gap summary exported to:", output_file, "\n")
print(summary_df)
