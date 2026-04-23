library(readr)
library(dplyr)

input_file <- "justice_access_exclusion_panel.csv"
output_file <- "justice_access_and_exclusion_summary.csv"

justice_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "territory_name",
  "group_name",
  "access_to_justice_index",
  "procedural_participation_index",
  "enforcement_capacity_index",
  "non_discrimination_protection_index",
  "legal_exclusion_risk_index"
)

missing_cols <- setdiff(required_cols, names(justice_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- justice_df %>%
  mutate(
    exclusion_risk_score = (
      (1 - access_to_justice_index) * 0.30 +
      (1 - procedural_participation_index) * 0.20 +
      (1 - enforcement_capacity_index) * 0.20 +
      (1 - non_discrimination_protection_index) * 0.15 +
      legal_exclusion_risk_index * 0.15
    )
  ) %>%
  group_by(country, territory_name, group_name) %>%
  summarise(
    avg_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    avg_justice_access = mean(access_to_justice_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    exclusion_band = case_when(
      avg_exclusion_risk >= 0.70 ~ "Severe legal exclusion",
      avg_exclusion_risk >= 0.50 ~ "Elevated legal exclusion",
      avg_exclusion_risk >= 0.30 ~ "Moderate legal exclusion",
      TRUE ~ "Lower legal exclusion"
    )
  ) %>%
  arrange(country, desc(avg_exclusion_risk))

write_csv(summary_df, output_file)

cat("Justice access and exclusion summary exported to:", output_file, "\n")
print(summary_df)
