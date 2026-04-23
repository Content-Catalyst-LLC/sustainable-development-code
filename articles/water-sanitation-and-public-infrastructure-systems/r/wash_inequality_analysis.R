library(readr)
library(dplyr)

input_file <- "district_wash_data.csv"
output_file <- "district_wash_inequality_summary.csv"

wash_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "district",
  "population",
  "safe_water_access_rate",
  "safe_sanitation_access_rate",
  "basic_hygiene_access_rate",
  "region"
)

missing_cols <- setdiff(required_cols, names(wash_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

wash_df <- wash_df %>%
  mutate(
    people_without_safe_water = round(population * (1 - safe_water_access_rate)),
    people_without_safe_sanitation = round(population * (1 - safe_sanitation_access_rate)),
    people_without_basic_hygiene = round(population * (1 - basic_hygiene_access_rate)),
    average_service_rate = (
      safe_water_access_rate +
      safe_sanitation_access_rate +
      basic_hygiene_access_rate
    ) / 3
  )

regional_summary <- wash_df %>%
  group_by(region) %>%
  summarise(
    total_population = sum(population, na.rm = TRUE),
    weighted_safe_water = weighted.mean(safe_water_access_rate, population, na.rm = TRUE),
    weighted_safe_sanitation = weighted.mean(safe_sanitation_access_rate, population, na.rm = TRUE),
    weighted_basic_hygiene = weighted.mean(basic_hygiene_access_rate, population, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    regional_average_service = (
      weighted_safe_water +
      weighted_safe_sanitation +
      weighted_basic_hygiene
    ) / 3
  )

district_summary <- wash_df %>%
  left_join(regional_summary, by = "region") %>%
  mutate(
    district_vs_region_gap = average_service_rate - regional_average_service,
    deprivation_flag = case_when(
      average_service_rate < 0.50 ~ "Severe deprivation",
      average_service_rate < 0.70 ~ "Moderate deprivation",
      TRUE ~ "Lower deprivation"
    )
  ) %>%
  arrange(desc(people_without_safe_water), desc(people_without_safe_sanitation))

write_csv(district_summary, output_file)

cat("District inequality summary exported to:", output_file, "\n")
print(head(district_summary, 10))
