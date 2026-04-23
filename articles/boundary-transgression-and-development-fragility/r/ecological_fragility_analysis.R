library(readr)
library(dplyr)

input_file <- "ecological_fragility_panel.csv"
country_output_file <- "ecological_fragility_country_summary.csv"
region_output_file <- "ecological_fragility_region_summary.csv"

fragility_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "climate_pressure_index",
  "freshwater_pressure_index",
  "biosphere_pressure_index",
  "land_system_pressure_index",
  "nutrient_pressure_index",
  "adaptive_capacity_index",
  "institutional_capacity_index"
)

missing_cols <- setdiff(required_cols, names(fragility_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

fragility_df <- fragility_df %>%
  mutate(
    multidimensional_boundary_pressure = (
      climate_pressure_index +
      freshwater_pressure_index +
      biosphere_pressure_index +
      land_system_pressure_index +
      nutrient_pressure_index
    ) / 5,
    pressure_capacity_gap = multidimensional_boundary_pressure - (
      (adaptive_capacity_index + institutional_capacity_index) / 2
    )
  )

country_summary <- fragility_df %>%
  group_by(country) %>%
  summarise(
    avg_boundary_pressure = mean(multidimensional_boundary_pressure, na.rm = TRUE),
    min_boundary_pressure = min(multidimensional_boundary_pressure, na.rm = TRUE),
    max_boundary_pressure = max(multidimensional_boundary_pressure, na.rm = TRUE),
    avg_pressure_capacity_gap = mean(pressure_capacity_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    fragility_band = case_when(
      avg_boundary_pressure >= 0.75 ~ "Severe ecological pressure",
      avg_boundary_pressure >= 0.55 ~ "Elevated ecological pressure",
      avg_boundary_pressure >= 0.35 ~ "Moderate ecological pressure",
      TRUE ~ "Lower ecological pressure"
    )
  ) %>%
  arrange(desc(avg_boundary_pressure))

region_summary <- fragility_df %>%
  group_by(region) %>%
  summarise(
    avg_boundary_pressure = mean(multidimensional_boundary_pressure, na.rm = TRUE),
    avg_climate_pressure = mean(climate_pressure_index, na.rm = TRUE),
    avg_freshwater_pressure = mean(freshwater_pressure_index, na.rm = TRUE),
    avg_biosphere_pressure = mean(biosphere_pressure_index, na.rm = TRUE),
    avg_land_system_pressure = mean(land_system_pressure_index, na.rm = TRUE),
    avg_nutrient_pressure = mean(nutrient_pressure_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_boundary_pressure))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Country ecological fragility summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegion ecological fragility summary exported to:", region_output_file, "\n")
print(region_summary)
