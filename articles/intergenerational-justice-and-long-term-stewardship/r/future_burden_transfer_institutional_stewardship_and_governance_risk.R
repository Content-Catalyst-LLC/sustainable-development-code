library(readr)
library(dplyr)

input_file <- "intergenerational_burden_panel.csv"
output_file <- "future_burden_transfer_institutional_stewardship_and_governance_risk_summary.csv"

ij_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "group_name",
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

summary_df <- ij_df %>%
  mutate(
    unequal_future_burden = (
      future_burden_transfer_index * 0.16 +
      ecological_degradation_index * 0.14 +
      institutional_erosion_index * 0.12 +
      public_debt_lock_in_index * 0.10 +
      infrastructure_lock_in_index * 0.10 +
      climate_risk_transfer_index * 0.14 +
      future_representation_gap_index * 0.10 +
      (1 - governance_capacity_index) * 0.06 +
      (1 - precautionary_planning_index) * 0.04 +
      (1 - resilience_preservation_index) * 0.02 +
      justice_exposure_index * 0.02
    )
  ) %>%
  group_by(territory_name, country_or_region, group_name) %>%
  summarise(
    avg_unequal_future_burden = mean(unequal_future_burden, na.rm = TRUE),
    avg_stewardship_capacity = mean((governance_capacity_index + precautionary_planning_index + resilience_preservation_index) / 3, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    burden_band = case_when(
      avg_unequal_future_burden >= 0.70 ~ "Severe future burden transfer",
      avg_unequal_future_burden >= 0.50 ~ "Elevated future burden transfer",
      avg_unequal_future_burden >= 0.30 ~ "Moderate future burden transfer",
      TRUE ~ "Lower future burden transfer"
    )
  ) %>%
  arrange(territory_name, desc(avg_unequal_future_burden))

write_csv(summary_df, output_file)

cat("Future-burden transfer, institutional-stewardship, and governance-risk summary exported to:", output_file, "\n")
print(summary_df)
