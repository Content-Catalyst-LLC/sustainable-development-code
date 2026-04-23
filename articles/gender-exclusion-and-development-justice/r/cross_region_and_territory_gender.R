library(readr)
library(dplyr)

input_file <- "gender_exclusion_development_justice_country_panel.csv"
region_output_file <- "cross_region_gender_summary.csv"
territory_output_file <- "cross_territory_gender_summary.csv"

gender_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "education_access_index",
  "health_autonomy_index",
  "economic_participation_index",
  "care_burden_index",
  "violence_exposure_index",
  "institutional_power_gap_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(gender_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

gender_df <- gender_df %>%
  mutate(
    gender_justice_risk_proxy = (
      (1 - education_access_index) +
      (1 - health_autonomy_index) +
      (1 - economic_participation_index) +
      care_burden_index +
      violence_exposure_index +
      institutional_power_gap_index +
      (1 - governance_capacity_index)
    ) / 7
  )

region_summary <- gender_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_gender_justice_risk_proxy = mean(gender_justice_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_gender_justice_risk_proxy >= 0.75 ~ "Extreme gender-justice risk",
      avg_gender_justice_risk_proxy >= 0.55 ~ "High gender-justice risk",
      avg_gender_justice_risk_proxy >= 0.35 ~ "Moderate gender-justice risk",
      TRUE ~ "Lower gender-justice risk"
    )
  ) %>%
  arrange(desc(avg_gender_justice_risk_proxy))

territory_summary <- gender_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_gender_justice_risk_proxy = mean(gender_justice_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_gender_justice_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region gender summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory gender summary exported to:", territory_output_file, "\n")
print(territory_summary)
