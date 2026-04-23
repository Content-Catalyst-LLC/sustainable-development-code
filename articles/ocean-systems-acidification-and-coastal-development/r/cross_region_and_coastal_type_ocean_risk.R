library(readr)
library(dplyr)

input_file <- "ocean_acidification_country_panel.csv"
region_output_file <- "cross_region_ocean_acidification_summary.csv"
coast_output_file <- "cross_coastal_type_ocean_acidification_summary.csv"

ocean_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "coastal_system_name",
  "country_or_region",
  "coastal_type",
  "acidification_pressure_index",
  "warming_pressure_index",
  "deoxygenation_pressure_index",
  "marine_dependence_index",
  "fisheries_livelihood_dependence_index",
  "coastal_infrastructure_exposure_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ocean_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

ocean_df <- ocean_df %>%
  mutate(
    coastal_ocean_risk_proxy = (
      acidification_pressure_index +
      warming_pressure_index +
      deoxygenation_pressure_index +
      marine_dependence_index +
      fisheries_livelihood_dependence_index +
      coastal_infrastructure_exposure_index +
      justice_exposure_index +
      (1 - governance_capacity_index)
    ) / 8
  )

region_summary <- ocean_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_coastal_ocean_risk_proxy = mean(coastal_ocean_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_coastal_ocean_risk_proxy >= 0.75 ~ "Extreme coastal-ocean risk",
      avg_coastal_ocean_risk_proxy >= 0.55 ~ "High coastal-ocean risk",
      avg_coastal_ocean_risk_proxy >= 0.35 ~ "Moderate coastal-ocean risk",
      TRUE ~ "Lower coastal-ocean risk"
    )
  ) %>%
  arrange(desc(avg_coastal_ocean_risk_proxy))

coast_summary <- ocean_df %>%
  group_by(coastal_type) %>%
  summarise(
    avg_coastal_ocean_risk_proxy = mean(coastal_ocean_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_coastal_ocean_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(coast_summary, coast_output_file)

cat("Cross-region ocean acidification summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-coastal-type ocean acidification summary exported to:", coast_output_file, "\n")
print(coast_summary)
