library(readr)
library(dplyr)

input_file <- "nutrient_cycles_country_panel.csv"
region_output_file <- "cross_region_nutrient_summary.csv"
territory_output_file <- "cross_territory_nutrient_summary.csv"

nutr_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "nitrogen_surplus_index",
  "phosphorus_surplus_index",
  "runoff_leakage_index",
  "eutrophication_exposure_index",
  "governance_capacity_index",
  "water_quality_burden_index"
)

missing_cols <- setdiff(required_cols, names(nutr_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

nutr_df <- nutr_df %>%
  mutate(
    nutrient_risk_proxy = (
      nitrogen_surplus_index +
      phosphorus_surplus_index +
      runoff_leakage_index +
      eutrophication_exposure_index +
      water_quality_burden_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- nutr_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_nutrient_risk_proxy = mean(nutrient_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_nutrient_risk_proxy >= 0.75 ~ "Extreme nutrient-development stress",
      avg_nutrient_risk_proxy >= 0.55 ~ "High nutrient-development stress",
      avg_nutrient_risk_proxy >= 0.35 ~ "Moderate nutrient-development stress",
      TRUE ~ "Lower nutrient-development stress"
    )
  ) %>%
  arrange(desc(avg_nutrient_risk_proxy))

territory_summary <- nutr_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_nutrient_risk_proxy = mean(nutrient_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_nutrient_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region nutrient summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory nutrient summary exported to:", territory_output_file, "\n")
print(territory_summary)
