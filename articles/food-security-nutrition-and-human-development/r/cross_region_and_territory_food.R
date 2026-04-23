library(readr)
library(dplyr)

input_file <- "food_security_nutrition_country_panel.csv"
region_output_file <- "cross_region_food_summary.csv"
territory_output_file <- "cross_territory_food_summary.csv"

food_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "food_access_index",
  "healthy_diet_affordability_stress_index",
  "nutrition_quality_index",
  "price_volatility_index",
  "food_system_fragility_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(food_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

food_df <- food_df %>%
  mutate(
    food_risk_proxy = (
      (1 - food_access_index) +
      healthy_diet_affordability_stress_index +
      (1 - nutrition_quality_index) +
      price_volatility_index +
      food_system_fragility_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- food_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_food_risk_proxy = mean(food_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_food_risk_proxy >= 0.75 ~ "Extreme food-development risk",
      avg_food_risk_proxy >= 0.55 ~ "High food-development risk",
      avg_food_risk_proxy >= 0.35 ~ "Moderate food-development risk",
      TRUE ~ "Lower food-development risk"
    )
  ) %>%
  arrange(desc(avg_food_risk_proxy))

territory_summary <- food_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_food_risk_proxy = mean(food_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_food_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region food summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory food summary exported to:", territory_output_file, "\n")
print(territory_summary)
