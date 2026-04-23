library(readr)
library(dplyr)

input_file <- "planetary_boundaries_country_panel.csv"
region_output_file <- "cross_region_planetary_summary.csv"
territory_output_file <- "cross_territory_planetary_summary.csv"

pb_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "climate_stress_index",
  "biosphere_integrity_loss_index",
  "freshwater_change_index",
  "land_system_change_index",
  "biogeochemical_pressure_index",
  "novel_entities_burden_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(pb_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

pb_df <- pb_df %>%
  mutate(
    planetary_risk_proxy = (
      climate_stress_index +
      biosphere_integrity_loss_index +
      freshwater_change_index +
      land_system_change_index +
      biogeochemical_pressure_index +
      novel_entities_burden_index +
      justice_exposure_index +
      (1 - governance_capacity_index)
    ) / 8
  )

region_summary <- pb_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_planetary_risk_proxy = mean(planetary_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_planetary_risk_proxy >= 0.75 ~ "Extreme planetary-development risk",
      avg_planetary_risk_proxy >= 0.55 ~ "High planetary-development risk",
      avg_planetary_risk_proxy >= 0.35 ~ "Moderate planetary-development risk",
      TRUE ~ "Lower planetary-development risk"
    )
  ) %>%
  arrange(desc(avg_planetary_risk_proxy))

territory_summary <- pb_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_planetary_risk_proxy = mean(planetary_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_planetary_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region planetary summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory planetary summary exported to:", territory_output_file, "\n")
print(territory_summary)
