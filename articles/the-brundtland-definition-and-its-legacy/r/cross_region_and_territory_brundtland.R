library(readr)
library(dplyr)

input_file <- "brundtland_definition_legacy_country_panel.csv"
region_output_file <- "cross_region_brundtland_summary.csv"
territory_output_file <- "cross_territory_brundtland_summary.csv"

br_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
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

br_df <- br_df %>%
  mutate(
    brundtland_proxy = (
      present_need_pressure_index +
      (1 - poverty_reduction_support_index) +
      ecological_degradation_index +
      future_burden_transfer_index +
      (1 - institutional_durability_index) +
      (1 - intergenerational_stewardship_index) +
      absorptive_capacity_stress_index +
      technology_organisation_constraint_index +
      (1 - development_legitimacy_alignment_index)
    ) / 9
  )

region_summary <- br_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_brundtland_proxy = mean(brundtland_proxy, na.rm = TRUE),
    avg_stewardship_capacity = mean((institutional_durability_index + intergenerational_stewardship_index + development_legitimacy_alignment_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_brundtland_proxy >= 0.75 ~ "Extreme Brundtland legitimacy risk",
      avg_brundtland_proxy >= 0.55 ~ "High Brundtland legitimacy risk",
      avg_brundtland_proxy >= 0.35 ~ "Moderate Brundtland legitimacy risk",
      TRUE ~ "Lower Brundtland legitimacy risk"
    )
  ) %>%
  arrange(desc(avg_brundtland_proxy))

territory_summary <- br_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_brundtland_proxy = mean(brundtland_proxy, na.rm = TRUE),
    avg_stewardship_capacity = mean((institutional_durability_index + intergenerational_stewardship_index + development_legitimacy_alignment_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_brundtland_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region Brundtland summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory Brundtland summary exported to:", territory_output_file, "\n")
print(territory_summary)
