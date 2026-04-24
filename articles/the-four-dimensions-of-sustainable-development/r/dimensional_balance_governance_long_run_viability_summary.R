library(readr)
library(dplyr)

input_file <- "four_dimensions_sustainable_development_country_panel.csv"
output_file <- "dimensional_balance_governance_long_run_viability_summary.csv"

sd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "economic_prosperity_index",
  "social_inclusion_index",
  "environmental_sustainability_index",
  "good_governance_index",
  "inequality_pressure_index",
  "ecological_stress_index",
  "institutional_failure_index",
  "long_run_alignment_index"
)

missing_cols <- setdiff(required_cols, names(sd_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

sd_df <- sd_df %>%
  mutate(
    four_dimensions_proxy = (
      (1 - economic_prosperity_index) +
      (1 - social_inclusion_index) +
      (1 - environmental_sustainability_index) +
      (1 - good_governance_index) +
      inequality_pressure_index +
      ecological_stress_index +
      institutional_failure_index +
      (1 - long_run_alignment_index)
    ) / 8
  )

summary_df <- sd_df %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_four_dimensions_proxy = mean(four_dimensions_proxy, na.rm = TRUE),
    avg_balance = mean((economic_prosperity_index + social_inclusion_index + environmental_sustainability_index + good_governance_index) / 4, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_four_dimensions_proxy))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
