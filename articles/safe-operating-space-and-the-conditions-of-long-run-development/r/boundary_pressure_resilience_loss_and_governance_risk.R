library(readr)
library(dplyr)

input_file <- "safe_operating_space_burden_panel.csv"
output_file <- "boundary_pressure_resilience_loss_and_governance_risk_summary.csv"

sos_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
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

summary_df <- sos_df %>%
  mutate(
    unequal_safe_operating_space_burden = (
      climate_boundary_pressure_index * 0.12 +
      biosphere_boundary_pressure_index * 0.12 +
      land_system_pressure_index * 0.10 +
      freshwater_pressure_index * 0.10 +
      biogeochemical_pressure_index * 0.10 +
      novel_entities_pressure_index * 0.10 +
      ocean_acidification_pressure_index * 0.08 +
      resilience_loss_index * 0.12 +
      governability_strain_index * 0.08 +
      (1 - adaptation_capacity_index) * 0.05 +
      justice_exposure_index * 0.03
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_safe_operating_space_burden = mean(unequal_safe_operating_space_burden, na.rm = TRUE),
    avg_adaptation_capacity = mean(adaptation_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_safe_operating_space_burden >= 0.70 ~ "Severe safe-operating-space burden",
      avg_unequal_safe_operating_space_burden >= 0.50 ~ "Elevated safe-operating-space burden",
      avg_unequal_safe_operating_space_burden >= 0.30 ~ "Moderate safe-operating-space burden",
      TRUE ~ "Lower safe-operating-space burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_safe_operating_space_burden))

write_csv(summary_df, output_file)

cat("Boundary-pressure, resilience-loss, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
