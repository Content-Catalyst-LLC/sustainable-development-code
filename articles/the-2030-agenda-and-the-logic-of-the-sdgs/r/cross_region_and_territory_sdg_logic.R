library(readr)
library(dplyr)

input_file <- "agenda_2030_sdg_logic_country_panel.csv"
region_output_file <- "cross_region_sdg_logic_summary.csv"
territory_output_file <- "cross_territory_sdg_logic_summary.csv"

sdg_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "universality_exposure_index",
  "integration_complexity_index",
  "implementation_capacity_index",
  "means_of_implementation_index",
  "partnership_readiness_index",
  "monitoring_capacity_index",
  "indicator_coverage_index",
  "review_responsiveness_index",
  "policy_fragmentation_index",
  "sdg_alignment_index"
)

missing_cols <- setdiff(required_cols, names(sdg_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

sdg_df <- sdg_df %>%
  mutate(
    sdg_logic_proxy = (
      universality_exposure_index +
      integration_complexity_index +
      (1 - implementation_capacity_index) +
      (1 - means_of_implementation_index) +
      (1 - partnership_readiness_index) +
      (1 - monitoring_capacity_index) +
      (1 - indicator_coverage_index) +
      (1 - review_responsiveness_index) +
      policy_fragmentation_index +
      (1 - sdg_alignment_index)
    ) / 10
  )

region_summary <- sdg_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_sdg_logic_proxy = mean(sdg_logic_proxy, na.rm = TRUE),
    avg_implementation_capacity = mean(implementation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_sdg_logic_proxy >= 0.75 ~ "Extreme SDG governance risk",
      avg_sdg_logic_proxy >= 0.55 ~ "High SDG governance risk",
      avg_sdg_logic_proxy >= 0.35 ~ "Moderate SDG governance risk",
      TRUE ~ "Lower SDG governance risk"
    )
  ) %>%
  arrange(desc(avg_sdg_logic_proxy))

territory_summary <- sdg_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_sdg_logic_proxy = mean(sdg_logic_proxy, na.rm = TRUE),
    avg_implementation_capacity = mean(implementation_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_sdg_logic_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region SDG logic summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory SDG logic summary exported to:", territory_output_file, "\n")
print(territory_summary)
