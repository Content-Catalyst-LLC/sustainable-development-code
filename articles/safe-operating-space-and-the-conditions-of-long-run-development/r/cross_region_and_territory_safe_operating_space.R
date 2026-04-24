library(readr)
library(dplyr)

input_file <- "safe_operating_space_long_run_development_country_panel.csv"
region_output_file <- "cross_region_safe_operating_space_summary.csv"
territory_output_file <- "cross_territory_safe_operating_space_summary.csv"

sos_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "climate_boundary_pressure_index",
  "biosphere_boundary_pressure_index",
  "land_system_pressure_index",
  "freshwater_pressure_index",
  "biogeochemical_pressure_index",
  "novel_entities_pressure_index",
  "ocean_acidification_pressure_index",
  "resilience_loss_index",
  "governability_strain_index",
  "adaptation_capacity_index",
  "justice_exposure_index"
)

missing_cols <- setdiff(required_cols, names(sos_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

sos_df <- sos_df %>%
  mutate(
    safe_operating_space_proxy = (
      climate_boundary_pressure_index +
      biosphere_boundary_pressure_index +
      land_system_pressure_index +
      freshwater_pressure_index +
      biogeochemical_pressure_index +
      novel_entities_pressure_index +
      ocean_acidification_pressure_index +
      resilience_loss_index +
      governability_strain_index +
      (1 - adaptation_capacity_index) +
      justice_exposure_index
    ) / 11
  )

region_summary <- sos_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_safe_operating_space_proxy = mean(safe_operating_space_proxy, na.rm = TRUE),
    avg_adaptation_capacity = mean(adaptation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_safe_operating_space_proxy >= 0.75 ~ "Extreme long-run development risk",
      avg_safe_operating_space_proxy >= 0.55 ~ "High long-run development risk",
      avg_safe_operating_space_proxy >= 0.35 ~ "Moderate long-run development risk",
      TRUE ~ "Lower long-run development risk"
    )
  ) %>%
  arrange(desc(avg_safe_operating_space_proxy))

territory_summary <- sos_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_safe_operating_space_proxy = mean(safe_operating_space_proxy, na.rm = TRUE),
    avg_adaptation_capacity = mean(adaptation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_safe_operating_space_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region safe operating space summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory safe operating space summary exported to:", territory_output_file, "\n")
print(territory_summary)
