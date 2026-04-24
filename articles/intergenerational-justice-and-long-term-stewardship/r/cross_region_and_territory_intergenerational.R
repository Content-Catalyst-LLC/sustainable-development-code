library(readr)
library(dplyr)

input_file <- "intergenerational_justice_long_term_stewardship_country_panel.csv"
region_output_file <- "cross_region_intergenerational_summary.csv"
territory_output_file <- "cross_territory_intergenerational_summary.csv"

ij_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "future_burden_transfer_index",
  "ecological_degradation_index",
  "institutional_erosion_index",
  "public_debt_lock_in_index",
  "infrastructure_lock_in_index",
  "climate_risk_transfer_index",
  "future_representation_gap_index",
  "governance_capacity_index",
  "precautionary_planning_index",
  "resilience_preservation_index",
  "justice_exposure_index"
)

missing_cols <- setdiff(required_cols, names(ij_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

ij_df <- ij_df %>%
  mutate(
    intergenerational_justice_proxy = (
      future_burden_transfer_index +
      ecological_degradation_index +
      institutional_erosion_index +
      public_debt_lock_in_index +
      infrastructure_lock_in_index +
      climate_risk_transfer_index +
      future_representation_gap_index +
      (1 - governance_capacity_index) +
      (1 - precautionary_planning_index) +
      (1 - resilience_preservation_index) +
      justice_exposure_index
    ) / 11
  )

region_summary <- ij_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_intergenerational_justice_proxy = mean(intergenerational_justice_proxy, na.rm = TRUE),
    avg_stewardship_capacity = mean((governance_capacity_index + precautionary_planning_index + resilience_preservation_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_intergenerational_justice_proxy >= 0.75 ~ "Extreme intergenerational justice risk",
      avg_intergenerational_justice_proxy >= 0.55 ~ "High intergenerational justice risk",
      avg_intergenerational_justice_proxy >= 0.35 ~ "Moderate intergenerational justice risk",
      TRUE ~ "Lower intergenerational justice risk"
    )
  ) %>%
  arrange(desc(avg_intergenerational_justice_proxy))

territory_summary <- ij_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_intergenerational_justice_proxy = mean(intergenerational_justice_proxy, na.rm = TRUE),
    avg_stewardship_capacity = mean((governance_capacity_index + precautionary_planning_index + resilience_preservation_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_intergenerational_justice_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region intergenerational summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory intergenerational summary exported to:", territory_output_file, "\n")
print(territory_summary)
