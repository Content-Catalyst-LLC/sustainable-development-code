library(readr)
library(dplyr)

input_file <- "anthropocene_planetary_boundaries_country_panel.csv"
output_file <- "boundary_transgression_earth_system_pressure_summary.csv"

pb_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "climate_forcing_index",
  "biosphere_integrity_stress_index",
  "land_system_change_index",
  "freshwater_change_index",
  "biogeochemical_disruption_index",
  "novel_entities_pressure_index",
  "ocean_acidification_pressure_index",
  "governance_response_capacity_index",
  "sustainable_development_alignment_index"
)

missing_cols <- setdiff(required_cols, names(pb_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

pb_df <- pb_df %>%
  mutate(
    planetary_pressure_proxy = (
      climate_forcing_index +
      biosphere_integrity_stress_index +
      land_system_change_index +
      freshwater_change_index +
      biogeochemical_disruption_index +
      novel_entities_pressure_index +
      ocean_acidification_pressure_index +
      (1 - governance_response_capacity_index) +
      (1 - sustainable_development_alignment_index)
    ) / 9
  )

summary_df <- pb_df %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_planetary_pressure_proxy = mean(planetary_pressure_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_response_capacity_index, na.rm = TRUE),
    avg_alignment = mean(sustainable_development_alignment_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_planetary_pressure_proxy))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
