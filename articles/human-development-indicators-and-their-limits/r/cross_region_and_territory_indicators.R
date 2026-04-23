library(readr)
library(dplyr)

input_file <- "human_development_indicator_country_panel.csv"
region_output_file <- "cross_region_indicator_summary.csv"
territory_output_file <- "cross_territory_indicator_summary.csv"

ind_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "hdi_attainment_index",
  "inequality_penalty_index",
  "gender_gap_index",
  "multidimensional_poverty_index",
  "subnational_variation_index",
  "data_quality_confidence_index"
)

missing_cols <- setdiff(required_cols, names(ind_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

ind_df <- ind_df %>%
  mutate(
    indicator_limit_proxy = (
      (1 - hdi_attainment_index) +
      inequality_penalty_index +
      gender_gap_index +
      multidimensional_poverty_index +
      subnational_variation_index +
      (1 - data_quality_confidence_index)
    ) / 6
  )

region_summary <- ind_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_indicator_limit_proxy = mean(indicator_limit_proxy, na.rm = TRUE),
    avg_data_quality_confidence = mean(data_quality_confidence_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_indicator_limit_proxy >= 0.75 ~ "Extreme indicator-limit risk",
      avg_indicator_limit_proxy >= 0.55 ~ "High indicator-limit risk",
      avg_indicator_limit_proxy >= 0.35 ~ "Moderate indicator-limit risk",
      TRUE ~ "Lower indicator-limit risk"
    )
  ) %>%
  arrange(desc(avg_indicator_limit_proxy))

territory_summary <- ind_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_indicator_limit_proxy = mean(indicator_limit_proxy, na.rm = TRUE),
    avg_data_quality_confidence = mean(data_quality_confidence_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_indicator_limit_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region indicator summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory indicator summary exported to:", territory_output_file, "\n")
print(territory_summary)
