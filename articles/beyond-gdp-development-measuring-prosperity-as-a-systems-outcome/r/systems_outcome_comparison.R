library(readr)
library(dplyr)

input_file <- "beyond_gdp_development_country_panel.csv"
output_file <- "systems_outcome_comparison_summary.csv"

bgdp_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "gdp_growth_index",
  "health_capability_index",
  "education_capability_index",
  "institutional_quality_index",
  "ecological_stability_index",
  "inequality_pressure_index"
)

missing_cols <- setdiff(required_cols, names(bgdp_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

bgdp_df <- bgdp_df %>%
  mutate(
    systems_outcome_proxy = (
      gdp_growth_index +
      health_capability_index +
      education_capability_index +
      institutional_quality_index +
      ecological_stability_index +
      (1 - inequality_pressure_index)
    ) / 6,
    gdp_distortion_gap = gdp_growth_index - systems_outcome_proxy
  )

summary_df <- bgdp_df %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_systems_outcome_proxy = mean(systems_outcome_proxy, na.rm = TRUE),
    avg_gdp_only = mean(gdp_growth_index, na.rm = TRUE),
    avg_distortion_gap = mean(gdp_distortion_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_distortion_gap))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
