library(readr)
library(dplyr)

input_file <- "geography_global_poverty_country_panel.csv"
output_file <- "rural_urban_territorial_poverty_pressure_summary.csv"

gp_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "income_deprivation_index",
  "rural_ecological_vulnerability_index",
  "urban_informal_settlement_pressure_index",
  "health_burden_index",
  "infrastructure_exclusion_index",
  "regional_isolation_index",
  "conflict_fragility_exposure_index",
  "basic_services_access_index",
  "territorial_governance_capacity_index",
  "poverty_reduction_alignment_index"
)

missing_cols <- setdiff(required_cols, names(gp_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

gp_df <- gp_df %>%
  mutate(
    geographic_poverty_proxy = (
      income_deprivation_index +
      rural_ecological_vulnerability_index +
      urban_informal_settlement_pressure_index +
      health_burden_index +
      infrastructure_exclusion_index +
      regional_isolation_index +
      conflict_fragility_exposure_index +
      (1 - basic_services_access_index) +
      (1 - territorial_governance_capacity_index) +
      (1 - poverty_reduction_alignment_index)
    ) / 10
  )

summary_df <- gp_df %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_geographic_poverty_proxy = mean(geographic_poverty_proxy, na.rm = TRUE),
    avg_service_access = mean(basic_services_access_index, na.rm = TRUE),
    avg_governance_capacity = mean(territorial_governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_geographic_poverty_proxy))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
