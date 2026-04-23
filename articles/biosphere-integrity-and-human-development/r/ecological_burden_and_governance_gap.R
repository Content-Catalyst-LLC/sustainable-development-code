library(readr)
library(dplyr)

input_file <- "biosphere_inequality_panel.csv"
output_file <- "ecological_burden_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "ecosystem_degradation_index",
  "fragmentation_risk_index",
  "ecological_service_erosion_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_ecological_burden = (
      ecosystem_degradation_index * 0.25 +
      fragmentation_risk_index * 0.20 +
      ecological_service_erosion_index * 0.20 +
      justice_exposure_index * 0.25 +
      (1 - governance_capacity_index) * 0.10
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_ecological_burden = mean(unequal_ecological_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_ecological_burden >= 0.70 ~ "Severe unequal ecological burden",
      avg_unequal_ecological_burden >= 0.50 ~ "Elevated unequal ecological burden",
      avg_unequal_ecological_burden >= 0.30 ~ "Moderate unequal ecological burden",
      TRUE ~ "Lower unequal ecological burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_ecological_burden))

write_csv(summary_df, output_file)

cat("Ecological burden and governance gap summary exported to:", output_file, "\n")
print(summary_df)
