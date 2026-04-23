library(readr)
library(dplyr)

input_file <- "spatial_justice_service_panel.csv"
output_file <- "spatial_justice_and_service_reach_summary.csv"

space_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "city_or_region",
  "territory_name",
  "group_name",
  "service_reach_index",
  "spatial_justice_index",
  "land_housing_coordination_index",
  "fragmentation_risk_index",
  "hazard_exposure_index"
)

missing_cols <- setdiff(required_cols, names(space_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- space_df %>%
  mutate(
    territorial_exclusion_score = (
      (1 - service_reach_index) * 0.30 +
      (1 - spatial_justice_index) * 0.25 +
      (1 - land_housing_coordination_index) * 0.20 +
      fragmentation_risk_index * 0.15 +
      hazard_exposure_index * 0.10
    )
  ) %>%
  group_by(city_or_region, territory_name, group_name) %>%
  summarise(
    avg_territorial_exclusion = mean(territorial_exclusion_score, na.rm = TRUE),
    avg_service_reach = mean(service_reach_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_territorial_exclusion >= 0.70 ~ "Severe territorial exclusion",
      avg_territorial_exclusion >= 0.50 ~ "Elevated territorial exclusion",
      avg_territorial_exclusion >= 0.30 ~ "Moderate territorial exclusion",
      TRUE ~ "Lower territorial exclusion"
    )
  ) %>%
  arrange(city_or_region, desc(avg_territorial_exclusion))

write_csv(summary_df, output_file)

cat("Spatial justice and service reach summary exported to:", output_file, "\n")
print(summary_df)
