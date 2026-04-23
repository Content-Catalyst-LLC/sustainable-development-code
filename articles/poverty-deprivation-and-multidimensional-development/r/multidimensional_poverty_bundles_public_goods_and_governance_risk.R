library(readr)
library(dplyr)

input_file <- "poverty_burden_panel.csv"
output_file <- "multidimensional_poverty_bundles_public_goods_and_governance_risk_summary.csv"

poverty_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "housing_deprivation_index",
  "sanitation_deprivation_index",
  "electricity_cooking_fuel_deprivation_index",
  "nutrition_deprivation_index",
  "learning_deprivation_index",
  "child_vulnerability_index",
  "climate_exposure_index",
  "public_goods_access_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(poverty_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- poverty_df %>%
  mutate(
    unequal_poverty_burden = (
      housing_deprivation_index * 0.12 +
      sanitation_deprivation_index * 0.12 +
      electricity_cooking_fuel_deprivation_index * 0.12 +
      nutrition_deprivation_index * 0.12 +
      learning_deprivation_index * 0.12 +
      child_vulnerability_index * 0.15 +
      climate_exposure_index * 0.10 +
      (1 - public_goods_access_index) * 0.10 +
      (1 - governance_capacity_index) * 0.05
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_poverty_burden = mean(unequal_poverty_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_poverty_burden >= 0.70 ~ "Severe multidimensional poverty burden",
      avg_unequal_poverty_burden >= 0.50 ~ "Elevated multidimensional poverty burden",
      avg_unequal_poverty_burden >= 0.30 ~ "Moderate multidimensional poverty burden",
      TRUE ~ "Lower multidimensional poverty burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_poverty_burden))

write_csv(summary_df, output_file)

cat("Multidimensional-poverty bundles, public-goods, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
