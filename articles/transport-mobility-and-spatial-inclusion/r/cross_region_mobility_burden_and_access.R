library(readr)
library(dplyr)

input_file <- "transport_access_country_panel.csv"
country_output_file <- "cross_country_transport_access_summary.csv"
region_output_file <- "regional_transport_access_summary.csv"

transport_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "public_transport_coverage_index",
  "jobs_access_index",
  "healthcare_access_index",
  "fare_affordability_index",
  "travel_time_burden_index",
  "safety_index",
  "car_dependence_risk_index"
)

missing_cols <- setdiff(required_cols, names(transport_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

transport_df <- transport_df %>%
  mutate(
    accessibility_proxy = (
      public_transport_coverage_index +
      jobs_access_index +
      healthcare_access_index +
      fare_affordability_index +
      safety_index
    ) / 5,
    constrained_mobility_proxy = (
      accessibility_proxy +
      (1 - travel_time_burden_index) +
      (1 - car_dependence_risk_index)
    ) / 3
  )

country_summary <- transport_df %>%
  group_by(country) %>%
  summarise(
    avg_accessibility_proxy = mean(accessibility_proxy, na.rm = TRUE),
    avg_constrained_mobility = mean(constrained_mobility_proxy, na.rm = TRUE),
    avg_car_dependence = mean(car_dependence_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    access_band = case_when(
      avg_constrained_mobility >= 0.75 ~ "High access inclusion",
      avg_constrained_mobility >= 0.55 ~ "Moderate access inclusion",
      avg_constrained_mobility >= 0.35 ~ "Emerging access inclusion",
      TRUE ~ "Low access inclusion"
    )
  ) %>%
  arrange(desc(avg_constrained_mobility))

region_summary <- transport_df %>%
  group_by(region) %>%
  summarise(
    avg_accessibility_proxy = mean(accessibility_proxy, na.rm = TRUE),
    avg_constrained_mobility = mean(constrained_mobility_proxy, na.rm = TRUE),
    avg_car_dependence = mean(car_dependence_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_mobility))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Cross-country transport access summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegional transport access summary exported to:", region_output_file, "\n")
print(region_summary)
