library(readr)
library(dplyr)

input_file <- "local_governance_country_panel.csv"
country_output_file <- "cross_country_local_governance_summary.csv"
territory_output_file <- "cross_territory_local_governance_summary.csv"

local_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "city_or_region",
  "country",
  "territory_type",
  "service_reach_index",
  "land_housing_coordination_index",
  "infrastructure_mobility_integration_index",
  "resilience_capacity_index",
  "spatial_justice_index",
  "fragmentation_risk_index"
)

missing_cols <- setdiff(required_cols, names(local_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

local_df <- local_df %>%
  mutate(
    territorial_capacity_proxy = (
      service_reach_index +
      land_housing_coordination_index +
      infrastructure_mobility_integration_index +
      resilience_capacity_index +
      spatial_justice_index
    ) / 5,
    constrained_territorial_proxy = (
      territorial_capacity_proxy +
      (1 - fragmentation_risk_index)
    ) / 2
  )

country_summary <- local_df %>%
  group_by(country) %>%
  summarise(
    avg_territorial_capacity_proxy = mean(territorial_capacity_proxy, na.rm = TRUE),
    avg_constrained_territorial = mean(constrained_territorial_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    governance_band = case_when(
      avg_constrained_territorial >= 0.75 ~ "High territorial-governance capacity",
      avg_constrained_territorial >= 0.55 ~ "Moderate territorial-governance capacity",
      avg_constrained_territorial >= 0.35 ~ "Emerging territorial-governance capacity",
      TRUE ~ "Low territorial-governance capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_territorial))

territory_summary <- local_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_territorial_capacity_proxy = mean(territorial_capacity_proxy, na.rm = TRUE),
    avg_constrained_territorial = mean(constrained_territorial_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_territorial))

write_csv(country_summary, country_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-country local governance summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-territory local governance summary exported to:", territory_output_file, "\n")
print(territory_summary)
