library(readr)
library(dplyr)

input_file <- "human_development_burden_panel.csv"
output_file <- "capability_expansion_hdi_translation_and_governance_risk_summary.csv"

hd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "output_growth_index",
  "health_capability_index",
  "education_capability_index",
  "income_conversion_index",
  "public_goods_conversion_index",
  "distribution_constraint_index",
  "institutional_support_index",
  "ecological_durability_index",
  "agency_freedom_index",
  "human_development_alignment_index"
)

missing_cols <- setdiff(required_cols, names(hd_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- hd_df %>%
  mutate(
    unequal_human_development_burden = (
      output_growth_index * 0.08 +
      (1 - income_conversion_index) * 0.14 +
      (1 - public_goods_conversion_index) * 0.14 +
      distribution_constraint_index * 0.14 +
      (1 - institutional_support_index) * 0.12 +
      (1 - ecological_durability_index) * 0.12 +
      (1 - agency_freedom_index) * 0.12 +
      (1 - human_development_alignment_index) * 0.14
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_human_development_burden = mean(unequal_human_development_burden, na.rm = TRUE),
    avg_capability_expansion = mean((health_capability_index + education_capability_index + agency_freedom_index) / 3, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_human_development_burden >= 0.70 ~ "Severe human development burden",
      avg_unequal_human_development_burden >= 0.50 ~ "Elevated human development burden",
      avg_unequal_human_development_burden >= 0.30 ~ "Moderate human development burden",
      TRUE ~ "Lower human development burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_human_development_burden))

write_csv(summary_df, output_file)

cat("Capability-expansion, HDI-translation, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
