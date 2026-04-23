library(readr)
library(dplyr)

input_file <- "urbanization_housing_services_country_panel.csv"
region_output_file <- "cross_region_urban_summary.csv"
territory_output_file <- "cross_territory_urban_summary.csv"

urban_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "housing_adequacy_index",
  "housing_affordability_stress_index",
  "basic_services_access_index",
  "informality_exclusion_index",
  "resilience_weakness_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(urban_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

urban_df <- urban_df %>%
  mutate(
    urban_risk_proxy = (
      (1 - housing_adequacy_index) +
      housing_affordability_stress_index +
      (1 - basic_services_access_index) +
      informality_exclusion_index +
      resilience_weakness_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- urban_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_urban_risk_proxy = mean(urban_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_urban_risk_proxy >= 0.75 ~ "Extreme urban-development risk",
      avg_urban_risk_proxy >= 0.55 ~ "High urban-development risk",
      avg_urban_risk_proxy >= 0.35 ~ "Moderate urban-development risk",
      TRUE ~ "Lower urban-development risk"
    )
  ) %>%
  arrange(desc(avg_urban_risk_proxy))

territory_summary <- urban_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_urban_risk_proxy = mean(urban_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_urban_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region urban summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory urban summary exported to:", territory_output_file, "\n")
print(territory_summary)
