library(readr)
library(dplyr)

input_file <- "overshoot_burden_panel.csv"
output_file <- "throughput_pressure_delay_risk_and_governance_fragility_summary.csv"

overshoot_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "growth_pressure_index",
  "throughput_pressure_index",
  "resource_depletion_index",
  "waste_absorptive_stress_index",
  "planetary_pressure_index",
  "delay_recognition_risk_index",
  "infrastructure_lockin_index",
  "governance_fragility_index",
  "adaptive_capacity_index",
  "welfare_conversion_index"
)

missing_cols <- setdiff(required_cols, names(overshoot_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- overshoot_df %>%
  mutate(
    unequal_overshoot_burden = (
      growth_pressure_index * 0.10 +
      throughput_pressure_index * 0.14 +
      resource_depletion_index * 0.12 +
      waste_absorptive_stress_index * 0.12 +
      planetary_pressure_index * 0.12 +
      delay_recognition_risk_index * 0.12 +
      infrastructure_lockin_index * 0.10 +
      governance_fragility_index * 0.10 +
      (1 - adaptive_capacity_index) * 0.05 +
      (1 - welfare_conversion_index) * 0.03
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_overshoot_burden = mean(unequal_overshoot_burden, na.rm = TRUE),
    avg_adaptive_capacity = mean(adaptive_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_overshoot_burden >= 0.70 ~ "Severe overshoot burden",
      avg_unequal_overshoot_burden >= 0.50 ~ "Elevated overshoot burden",
      avg_unequal_overshoot_burden >= 0.30 ~ "Moderate overshoot burden",
      TRUE ~ "Lower overshoot burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_overshoot_burden))

write_csv(summary_df, output_file)

cat("Throughput-pressure, delay-risk, and governance-fragility summary exported to:", output_file, "\n")
print(summary_df)
