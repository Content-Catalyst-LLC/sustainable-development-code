library(readr)
library(dplyr)

input_file <- "brundtland_burden_panel.csv"
output_file <- "intergenerational_need_ecological_constraint_and_governance_risk_summary.csv"

br_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
  "present_need_pressure_index",
  "poverty_reduction_support_index",
  "ecological_degradation_index",
  "future_burden_transfer_index",
  "institutional_durability_index",
  "intergenerational_stewardship_index",
  "absorptive_capacity_stress_index",
  "technology_organisation_constraint_index",
  "development_legitimacy_alignment_index"
)

missing_cols <- setdiff(required_cols, names(br_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- br_df %>%
  mutate(
    unequal_brundtland_burden = (
      present_need_pressure_index * 0.16 +
      (1 - poverty_reduction_support_index) * 0.12 +
      ecological_degradation_index * 0.16 +
      future_burden_transfer_index * 0.14 +
      (1 - institutional_durability_index) * 0.12 +
      (1 - intergenerational_stewardship_index) * 0.12 +
      absorptive_capacity_stress_index * 0.10 +
      technology_organisation_constraint_index * 0.04 +
      (1 - development_legitimacy_alignment_index) * 0.04
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_brundtland_burden = mean(unequal_brundtland_burden, na.rm = TRUE),
    avg_stewardship_capacity = mean((institutional_durability_index + intergenerational_stewardship_index + development_legitimacy_alignment_index) / 3, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_brundtland_burden >= 0.70 ~ "Severe Brundtland burden",
      avg_unequal_brundtland_burden >= 0.50 ~ "Elevated Brundtland burden",
      avg_unequal_brundtland_burden >= 0.30 ~ "Moderate Brundtland burden",
      TRUE ~ "Lower Brundtland burden"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_brundtland_burden))

write_csv(summary_df, output_file)

cat("Intergenerational-need, ecological-constraint, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
