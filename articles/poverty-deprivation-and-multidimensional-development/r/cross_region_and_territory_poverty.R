library(readr)
library(dplyr)

input_file <- "poverty_multidimensional_development_country_panel.csv"
region_output_file <- "cross_region_poverty_summary.csv"
territory_output_file <- "cross_territory_poverty_summary.csv"

poverty_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "income_poverty_index",
  "housing_deprivation_index",
  "sanitation_deprivation_index",
  "electricity_cooking_fuel_deprivation_index",
  "nutrition_deprivation_index",
  "learning_deprivation_index",
  "public_goods_access_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(poverty_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

poverty_df <- poverty_df %>%
  mutate(
    multidimensional_poverty_proxy = (
      income_poverty_index +
      housing_deprivation_index +
      sanitation_deprivation_index +
      electricity_cooking_fuel_deprivation_index +
      nutrition_deprivation_index +
      learning_deprivation_index +
      (1 - public_goods_access_index) +
      (1 - governance_capacity_index)
    ) / 8
  )

region_summary <- poverty_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_multidimensional_poverty_proxy = mean(multidimensional_poverty_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_multidimensional_poverty_proxy >= 0.75 ~ "Extreme multidimensional poverty risk",
      avg_multidimensional_poverty_proxy >= 0.55 ~ "High multidimensional poverty risk",
      avg_multidimensional_poverty_proxy >= 0.35 ~ "Moderate multidimensional poverty risk",
      TRUE ~ "Lower multidimensional poverty risk"
    )
  ) %>%
  arrange(desc(avg_multidimensional_poverty_proxy))

territory_summary <- poverty_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_multidimensional_poverty_proxy = mean(multidimensional_poverty_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_multidimensional_poverty_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region poverty summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory poverty summary exported to:", territory_output_file, "\n")
print(territory_summary)
