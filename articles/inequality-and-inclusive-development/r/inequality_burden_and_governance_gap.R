library(readr)
library(dplyr)

input_file <- "inequality_burden_panel.csv"
output_file <- "inequality_burden_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "education_access_index",
  "health_access_index",
  "income_security_index",
  "public_goods_access_index",
  "risk_exposure_index",
  "institutional_capture_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_inclusion_burden = (
      (1 - education_access_index) * 0.15 +
      (1 - health_access_index) * 0.15 +
      (1 - income_security_index) * 0.15 +
      (1 - public_goods_access_index) * 0.15 +
      risk_exposure_index * 0.20 +
      institutional_capture_index * 0.15 +
      (1 - governance_capacity_index) * 0.05
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_inclusion_burden = mean(unequal_inclusion_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_inclusion_burden >= 0.70 ~ "Severe unequal inclusion burden",
      avg_unequal_inclusion_burden >= 0.50 ~ "Elevated unequal inclusion burden",
      avg_unequal_inclusion_burden >= 0.30 ~ "Moderate unequal inclusion burden",
      TRUE ~ "Lower unequal inclusion burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_inclusion_burden))

write_csv(summary_df, output_file)

cat("Inequality-burden and governance-gap summary exported to:", output_file, "\n")
print(summary_df)
