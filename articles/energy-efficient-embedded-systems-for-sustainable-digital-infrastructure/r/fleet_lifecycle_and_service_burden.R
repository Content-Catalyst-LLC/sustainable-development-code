library(readr)
library(dplyr)

input_file <- "embedded_fleet_lifecycle_panel.csv"
output_file <- "embedded_fleet_lifecycle_summary.csv"

# Expected columns:
# scenario_name, fleet_size, average_device_power_mw,
# battery_life_days, service_trip_emissions_kg,
# annual_failure_rate, replacement_material_factor

fleet_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "scenario_name",
  "fleet_size",
  "average_device_power_mw",
  "battery_life_days",
  "service_trip_emissions_kg",
  "annual_failure_rate",
  "replacement_material_factor"
)

missing_cols <- setdiff(required_cols, names(fleet_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- fleet_df %>%
  mutate(
    annual_replacements_per_device = 365 / battery_life_days,
    annual_service_emissions_kg = fleet_size * annual_replacements_per_device * service_trip_emissions_kg,
    annual_failure_burden = fleet_size * annual_failure_rate * replacement_material_factor,
    fleet_energy_burden_index = fleet_size * average_device_power_mw,
    lifecycle_burden_proxy = annual_service_emissions_kg + annual_failure_burden + fleet_energy_burden_index
  ) %>%
  arrange(desc(lifecycle_burden_proxy))

write_csv(summary_df, output_file)

cat("Fleet lifecycle summary exported to:", output_file, "\n")
print(summary_df)
