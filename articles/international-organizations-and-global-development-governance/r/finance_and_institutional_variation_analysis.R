library(readr)
library(dplyr)

input_file <- "multilateral_finance_variation_panel.csv"
output_file <- "finance_and_institutional_variation_summary.csv"

finance_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country_or_regime",
  "territory_name",
  "group_name",
  "financing_support_index",
  "implementation_support_index",
  "legitimacy_index",
  "fragmentation_risk_index",
  "unequal_influence_risk_index"
)

missing_cols <- setdiff(required_cols, names(finance_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- finance_df %>%
  mutate(
    governance_constraint_score = (
      (1 - financing_support_index) * 0.30 +
      (1 - implementation_support_index) * 0.25 +
      (1 - legitimacy_index) * 0.20 +
      fragmentation_risk_index * 0.15 +
      unequal_influence_risk_index * 0.10
    )
  ) %>%
  group_by(country_or_regime, territory_name, group_name) %>%
  summarise(
    avg_governance_constraint = mean(governance_constraint_score, na.rm = TRUE),
    avg_financing_support = mean(financing_support_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    constraint_band = case_when(
      avg_governance_constraint >= 0.70 ~ "Severe multilateral constraint",
      avg_governance_constraint >= 0.50 ~ "Elevated multilateral constraint",
      avg_governance_constraint >= 0.30 ~ "Moderate multilateral constraint",
      TRUE ~ "Lower multilateral constraint"
    )
  ) %>%
  arrange(country_or_regime, desc(avg_governance_constraint))

write_csv(summary_df, output_file)

cat("Finance and institutional variation summary exported to:", output_file, "\n")
print(summary_df)
