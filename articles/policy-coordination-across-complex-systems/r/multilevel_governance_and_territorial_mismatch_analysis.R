library(readr)
library(dplyr)

input_file <- "multilevel_coordination_panel.csv"
output_file <- "multilevel_governance_and_territorial_mismatch_summary.csv"

multi_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "territory_name",
  "policy_domain",
  "national_alignment_index",
  "regional_alignment_index",
  "local_capacity_index",
  "territorial_fit_index",
  "implementation_gap_index",
  "data_visibility_index"
)

missing_cols <- setdiff(required_cols, names(multi_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- multi_df %>%
  mutate(
    multilevel_fit_score = (
      national_alignment_index +
      regional_alignment_index +
      local_capacity_index +
      territorial_fit_index +
      data_visibility_index
    ) / 5,
    territorial_mismatch_score = (
      implementation_gap_index * 0.40 +
      (1 - territorial_fit_index) * 0.30 +
      (1 - local_capacity_index) * 0.30
    )
  ) %>%
  group_by(country, territory_name, policy_domain) %>%
  summarise(
    avg_multilevel_fit = mean(multilevel_fit_score, na.rm = TRUE),
    avg_territorial_mismatch = mean(territorial_mismatch_score, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    mismatch_band = case_when(
      avg_territorial_mismatch >= 0.70 ~ "Severe coordination mismatch",
      avg_territorial_mismatch >= 0.50 ~ "Elevated coordination mismatch",
      avg_territorial_mismatch >= 0.30 ~ "Moderate coordination mismatch",
      TRUE ~ "Lower coordination mismatch"
    )
  ) %>%
  arrange(country, desc(avg_territorial_mismatch))

write_csv(summary_df, output_file)

cat("Multilevel governance and territorial mismatch summary exported to:", output_file, "\n")
print(summary_df)
