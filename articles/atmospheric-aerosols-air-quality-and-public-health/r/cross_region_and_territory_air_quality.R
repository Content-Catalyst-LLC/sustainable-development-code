library(readr)
library(dplyr)

input_file <- "aerosols_air_quality_country_panel.csv"
region_output_file <- "cross_region_air_quality_summary.csv"
territory_output_file <- "cross_territory_air_quality_summary.csv"

air_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "ambient_pm25_index",
  "ambient_pm10_index",
  "household_energy_exposure_index",
  "transport_emissions_pressure_index",
  "industrial_source_pressure_index",
  "exposure_inequality_index",
  "mitigation_capacity_index"
)

missing_cols <- setdiff(required_cols, names(air_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

air_df <- air_df %>%
  mutate(
    aerosol_burden_proxy = (
      ambient_pm25_index +
      ambient_pm10_index +
      household_energy_exposure_index +
      transport_emissions_pressure_index +
      industrial_source_pressure_index +
      exposure_inequality_index +
      (1 - mitigation_capacity_index)
    ) / 7
  )

region_summary <- air_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_aerosol_burden_proxy = mean(aerosol_burden_proxy, na.rm = TRUE),
    avg_mitigation_capacity = mean(mitigation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_aerosol_burden_proxy >= 0.75 ~ "Extreme aerosol-health burden",
      avg_aerosol_burden_proxy >= 0.55 ~ "High aerosol-health burden",
      avg_aerosol_burden_proxy >= 0.35 ~ "Moderate aerosol-health burden",
      TRUE ~ "Lower aerosol-health burden"
    )
  ) %>%
  arrange(desc(avg_aerosol_burden_proxy))

territory_summary <- air_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_aerosol_burden_proxy = mean(aerosol_burden_proxy, na.rm = TRUE),
    avg_mitigation_capacity = mean(mitigation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_aerosol_burden_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region air-quality summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory air-quality summary exported to:", territory_output_file, "\n")
print(territory_summary)
