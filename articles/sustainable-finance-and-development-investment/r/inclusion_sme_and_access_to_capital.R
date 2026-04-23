library(readr)
library(dplyr)

input_file <- "inclusive_finance_access_data.csv"
output_file <- "sme_and_inclusion_finance_summary.csv"

access_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "firm_type",
  "group_name",
  "capital_access_index",
  "loan_rejection_rate",
  "blended_finance_access_index",
  "public_guarantee_access_index",
  "inclusion_priority_index"
)

missing_cols <- setdiff(required_cols, names(access_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- access_df %>%
  mutate(
    exclusion_risk_score = (
      (1 - capital_access_index) * 0.35 +
      loan_rejection_rate * 0.25 +
      (1 - blended_finance_access_index) * 0.20 +
      (1 - public_guarantee_access_index) * 0.20
    )
  ) %>%
  group_by(country, firm_type, group_name) %>%
  summarise(
    avg_capital_access = mean(capital_access_index, na.rm = TRUE),
    avg_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    avg_inclusion_priority = mean(inclusion_priority_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    access_band = case_when(
      avg_capital_access >= 0.75 ~ "Strong access",
      avg_capital_access >= 0.55 ~ "Moderate access",
      avg_capital_access >= 0.35 ~ "Weak access",
      TRUE ~ "Severe access constraint"
    )
  ) %>%
  arrange(country, desc(avg_exclusion_risk))

write_csv(summary_df, output_file)

cat("SME and inclusion finance summary exported to:", output_file, "\n")
print(summary_df)
