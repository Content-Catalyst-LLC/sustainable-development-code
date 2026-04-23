library(readr)
library(dplyr)

input_file <- "pollution_inequality_panel.csv"
output_file <- "toxic_inequality_and_systemic_burden_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "waste_system_overload_index",
  "persistence_mobility_risk_index",
  "exposure_inequality_index",
  "governance_capacity_index",
  "public_health_burden_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_toxic_burden = (
      waste_system_overload_index * 0.20 +
      persistence_mobility_risk_index * 0.20 +
      exposure_inequality_index * 0.30 +
      public_health_burden_index * 0.20 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_toxic_burden = mean(unequal_toxic_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_toxic_burden >= 0.70 ~ "Severe unequal toxic burden",
      avg_unequal_toxic_burden >= 0.50 ~ "Elevated unequal toxic burden",
      avg_unequal_toxic_burden >= 0.30 ~ "Moderate unequal toxic burden",
      TRUE ~ "Lower unequal toxic burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_toxic_burden))

write_csv(summary_df, output_file)

cat("Toxic inequality and systemic burden summary exported to:", output_file, "\n")
print(summary_df)
