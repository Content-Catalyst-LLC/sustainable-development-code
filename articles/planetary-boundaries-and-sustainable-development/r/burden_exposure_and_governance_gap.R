library(readr)
library(dplyr)

input_file <- "planetary_inequality_panel.csv"
output_file <- "burden_exposure_and_governance_gap_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "climate_stress_index",
  "biosphere_integrity_loss_index",
  "freshwater_change_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_planetary_burden = (
      climate_stress_index * 0.20 +
      biosphere_integrity_loss_index * 0.20 +
      freshwater_change_index * 0.20 +
      justice_exposure_index * 0.25 +
      (1 - governance_capacity_index) * 0.15
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_planetary_burden = mean(unequal_planetary_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_planetary_burden >= 0.70 ~ "Severe unequal planetary burden",
      avg_unequal_planetary_burden >= 0.50 ~ "Elevated unequal planetary burden",
      avg_unequal_planetary_burden >= 0.30 ~ "Moderate unequal planetary burden",
      TRUE ~ "Lower unequal planetary burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_planetary_burden))

write_csv(summary_df, output_file)

cat("Burden exposure and governance gap summary exported to:", output_file, "\n")
print(summary_df)
