library(readr)
library(dplyr)

input_file <- "growth_limits_overshoot_country_panel.csv"
region_output_file <- "cross_region_overshoot_summary.csv"
territory_output_file <- "cross_territory_overshoot_summary.csv"

overshoot_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
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

overshoot_df <- overshoot_df %>%
  mutate(
    overshoot_proxy = (
      growth_pressure_index +
      throughput_pressure_index +
      resource_depletion_index +
      waste_absorptive_stress_index +
      planetary_pressure_index +
      delay_recognition_risk_index +
      infrastructure_lockin_index +
      governance_fragility_index +
      (1 - adaptive_capacity_index) +
      (1 - welfare_conversion_index)
    ) / 10
  )

region_summary <- overshoot_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_overshoot_proxy = mean(overshoot_proxy, na.rm = TRUE),
    avg_adaptive_capacity = mean(adaptive_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_overshoot_proxy >= 0.75 ~ "Extreme overshoot risk",
      avg_overshoot_proxy >= 0.55 ~ "High overshoot risk",
      avg_overshoot_proxy >= 0.35 ~ "Moderate overshoot risk",
      TRUE ~ "Lower overshoot risk"
    )
  ) %>%
  arrange(desc(avg_overshoot_proxy))

territory_summary <- overshoot_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_overshoot_proxy = mean(overshoot_proxy, na.rm = TRUE),
    avg_adaptive_capacity = mean(adaptive_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_overshoot_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region overshoot summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory overshoot summary exported to:", territory_output_file, "\n")
print(territory_summary)
