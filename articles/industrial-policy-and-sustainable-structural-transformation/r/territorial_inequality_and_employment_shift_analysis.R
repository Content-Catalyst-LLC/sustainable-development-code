library(readr)
library(dplyr)

input_file <- "territorial_industrial_shift_data.csv"
output_file <- "territorial_inequality_and_employment_shift_summary.csv"

territory_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region_name",
  "legacy_sector_exposure_index",
  "new_sector_readiness_index",
  "employment_shift_capacity_index",
  "skills_transition_index",
  "infrastructure_gap_index",
  "regional_support_index"
)

missing_cols <- setdiff(required_cols, names(territory_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- territory_df %>%
  mutate(
    territorial_transition_capacity = (
      new_sector_readiness_index +
      employment_shift_capacity_index +
      skills_transition_index +
      regional_support_index
    ) / 4,
    territorial_transition_constraint = (
      legacy_sector_exposure_index +
      infrastructure_gap_index +
      (1 - regional_support_index)
    ) / 3
  ) %>%
  group_by(country, region_name) %>%
  summarise(
    avg_transition_capacity = mean(territorial_transition_capacity, na.rm = TRUE),
    avg_transition_constraint = mean(territorial_transition_constraint, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    territorial_band = case_when(
      avg_transition_capacity >= 0.75 ~ "Strong territorial transition",
      avg_transition_capacity >= 0.55 ~ "Moderate territorial transition",
      avg_transition_capacity >= 0.35 ~ "Fragile territorial transition",
      TRUE ~ "High territorial vulnerability"
    )
  ) %>%
  arrange(country, desc(avg_transition_constraint))

write_csv(summary_df, output_file)

cat("Territorial inequality and employment-shift summary exported to:", output_file, "\n")
print(summary_df)
