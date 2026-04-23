library(readr)
library(dplyr)

input_file <- "work_livelihoods_country_panel.csv"
region_output_file <- "cross_region_work_summary.csv"
territory_output_file <- "cross_territory_work_summary.csv"

work_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "employment_access_index",
  "informality_risk_index",
  "precarity_risk_index",
  "income_security_index",
  "social_protection_coverage_index",
  "labour_rights_exposure_index"
)

missing_cols <- setdiff(required_cols, names(work_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

work_df <- work_df %>%
  mutate(
    decent_work_risk_proxy = (
      (1 - employment_access_index) +
      informality_risk_index +
      precarity_risk_index +
      (1 - income_security_index) +
      (1 - social_protection_coverage_index) +
      labour_rights_exposure_index
    ) / 6
  )

region_summary <- work_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_decent_work_risk_proxy = mean(decent_work_risk_proxy, na.rm = TRUE),
    avg_social_protection = mean(social_protection_coverage_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_decent_work_risk_proxy >= 0.75 ~ "Extreme decent-employment risk",
      avg_decent_work_risk_proxy >= 0.55 ~ "High decent-employment risk",
      avg_decent_work_risk_proxy >= 0.35 ~ "Moderate decent-employment risk",
      TRUE ~ "Lower decent-employment risk"
    )
  ) %>%
  arrange(desc(avg_decent_work_risk_proxy))

territory_summary <- work_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_decent_work_risk_proxy = mean(decent_work_risk_proxy, na.rm = TRUE),
    avg_social_protection = mean(social_protection_coverage_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_decent_work_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region work summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory work summary exported to:", territory_output_file, "\n")
print(territory_summary)
