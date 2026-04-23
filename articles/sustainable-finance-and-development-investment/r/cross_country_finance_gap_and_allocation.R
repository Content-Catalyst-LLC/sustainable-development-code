library(readr)
library(dplyr)

input_file <- "sustainable_finance_country_panel.csv"
country_output_file <- "cross_country_finance_gap_summary.csv"
region_output_file <- "regional_finance_gap_summary.csv"

finance_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "public_finance_usd",
  "private_finance_usd",
  "blended_finance_usd",
  "infrastructure_need_usd",
  "adaptation_need_usd",
  "resilience_need_usd",
  "debt_constraint_index",
  "investment_absorption_index"
)

missing_cols <- setdiff(required_cols, names(finance_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

finance_df <- finance_df %>%
  mutate(
    total_finance_usd = public_finance_usd + private_finance_usd + blended_finance_usd,
    total_need_usd = infrastructure_need_usd + adaptation_need_usd + resilience_need_usd,
    finance_gap_usd = pmax(total_need_usd - total_finance_usd, 0),
    finance_coverage_ratio = if_else(total_need_usd > 0, total_finance_usd / total_need_usd, 0),
    constrained_development_finance_score = (
      finance_coverage_ratio * 0.45 +
      investment_absorption_index * 0.35 +
      (1 - debt_constraint_index) * 0.20
    )
  )

country_summary <- finance_df %>%
  group_by(country) %>%
  summarise(
    avg_total_finance = mean(total_finance_usd, na.rm = TRUE),
    avg_total_need = mean(total_need_usd, na.rm = TRUE),
    avg_finance_gap = mean(finance_gap_usd, na.rm = TRUE),
    avg_coverage_ratio = mean(finance_coverage_ratio, na.rm = TRUE),
    avg_constrained_finance_score = mean(constrained_development_finance_score, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    finance_band = case_when(
      avg_constrained_finance_score >= 0.75 ~ "High effective alignment",
      avg_constrained_finance_score >= 0.55 ~ "Moderate effective alignment",
      avg_constrained_finance_score >= 0.35 ~ "Constrained alignment",
      TRUE ~ "Low effective alignment"
    )
  ) %>%
  arrange(desc(avg_finance_gap))

region_summary <- finance_df %>%
  group_by(region) %>%
  summarise(
    avg_total_finance = mean(total_finance_usd, na.rm = TRUE),
    avg_total_need = mean(total_need_usd, na.rm = TRUE),
    avg_finance_gap = mean(finance_gap_usd, na.rm = TRUE),
    avg_coverage_ratio = mean(finance_coverage_ratio, na.rm = TRUE),
    avg_debt_constraint = mean(debt_constraint_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_finance_gap))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Cross-country finance gap summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegional finance gap summary exported to:", region_output_file, "\n")
print(region_summary)
