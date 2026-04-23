library(readr)
library(dplyr)

input_file <- "land_system_change_country_panel.csv"
region_output_file <- "cross_region_land_system_summary.csv"
territory_output_file <- "cross_territory_land_system_summary.csv"

land_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "conversion_pressure_index",
  "land_degradation_index",
  "fragmentation_risk_index",
  "biodiversity_function_loss_index",
  "justice_exposure_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(land_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

land_df <- land_df %>%
  mutate(
    land_pathway_risk_proxy = (
      conversion_pressure_index +
      land_degradation_index +
      fragmentation_risk_index +
      biodiversity_function_loss_index +
      justice_exposure_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- land_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_land_pathway_risk_proxy = mean(land_pathway_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_land_pathway_risk_proxy >= 0.75 ~ "Extreme land-pathway risk",
      avg_land_pathway_risk_proxy >= 0.55 ~ "High land-pathway risk",
      avg_land_pathway_risk_proxy >= 0.35 ~ "Moderate land-pathway risk",
      TRUE ~ "Lower land-pathway risk"
    )
  ) %>%
  arrange(desc(avg_land_pathway_risk_proxy))

territory_summary <- land_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_land_pathway_risk_proxy = mean(land_pathway_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_land_pathway_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region land-system summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory land-system summary exported to:", territory_output_file, "\n")
print(territory_summary)
