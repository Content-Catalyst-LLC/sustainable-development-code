library(readr)
library(dplyr)

input_file <- "gender_inequality_panel.csv"
output_file <- "capability_gap_care_burden_and_governance_risk_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "education_access_index",
  "health_autonomy_index",
  "economic_participation_index",
  "care_burden_index",
  "violence_exposure_index",
  "institutional_power_gap_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- ineq_df %>%
  mutate(
    unequal_gender_burden = (
      (1 - education_access_index) * 0.15 +
      (1 - health_autonomy_index) * 0.15 +
      (1 - economic_participation_index) * 0.15 +
      care_burden_index * 0.20 +
      violence_exposure_index * 0.20 +
      institutional_power_gap_index * 0.10 +
      (1 - governance_capacity_index) * 0.05
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_gender_burden = mean(unequal_gender_burden, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_gender_burden >= 0.70 ~ "Severe unequal gender burden",
      avg_unequal_gender_burden >= 0.50 ~ "Elevated unequal gender burden",
      avg_unequal_gender_burden >= 0.30 ~ "Moderate unequal gender burden",
      TRUE ~ "Lower unequal gender burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_gender_burden))

write_csv(summary_df, output_file)

cat("Capability-gap, care-burden, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
