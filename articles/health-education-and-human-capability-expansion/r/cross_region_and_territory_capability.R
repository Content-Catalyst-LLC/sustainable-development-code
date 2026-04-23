library(readr)
library(dplyr)

input_file <- "health_education_capability_country_panel.csv"
region_output_file <- "cross_region_capability_summary.csv"
territory_output_file <- "cross_territory_capability_summary.csv"

cap_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "health_access_index",
  "education_access_index",
  "service_quality_index",
  "financial_hardship_risk_index",
  "learning_deprivation_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(cap_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

cap_df <- cap_df %>%
  mutate(
    capability_risk_proxy = (
      (1 - health_access_index) +
      (1 - education_access_index) +
      (1 - service_quality_index) +
      financial_hardship_risk_index +
      learning_deprivation_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- cap_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_capability_risk_proxy = mean(capability_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_capability_risk_proxy >= 0.75 ~ "Extreme capability risk",
      avg_capability_risk_proxy >= 0.55 ~ "High capability risk",
      avg_capability_risk_proxy >= 0.35 ~ "Moderate capability risk",
      TRUE ~ "Lower capability risk"
    )
  ) %>%
  arrange(desc(avg_capability_risk_proxy))

territory_summary <- cap_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_capability_risk_proxy = mean(capability_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_capability_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region capability summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory capability summary exported to:", territory_output_file, "\n")
print(territory_summary)
