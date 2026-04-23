library(readr)
library(dplyr)

input_file <- "pollution_novel_entities_country_panel.csv"
region_output_file <- "cross_region_pollution_summary.csv"
territory_output_file <- "cross_territory_pollution_summary.csv"

poll_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "hazardous_material_throughput_index",
  "waste_system_overload_index",
  "persistence_mobility_risk_index",
  "exposure_inequality_index",
  "governance_capacity_index",
  "public_health_burden_index"
)

missing_cols <- setdiff(required_cols, names(poll_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

poll_df <- poll_df %>%
  mutate(
    pollution_risk_proxy = (
      hazardous_material_throughput_index +
      waste_system_overload_index +
      persistence_mobility_risk_index +
      exposure_inequality_index +
      public_health_burden_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- poll_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_pollution_risk_proxy = mean(pollution_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_pollution_risk_proxy >= 0.75 ~ "Extreme pollution-development risk",
      avg_pollution_risk_proxy >= 0.55 ~ "High pollution-development risk",
      avg_pollution_risk_proxy >= 0.35 ~ "Moderate pollution-development risk",
      TRUE ~ "Lower pollution-development risk"
    )
  ) %>%
  arrange(desc(avg_pollution_risk_proxy))

territory_summary <- poll_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_pollution_risk_proxy = mean(pollution_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_pollution_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region pollution summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory pollution summary exported to:", territory_output_file, "\n")
print(territory_summary)
