library(readr)
library(dplyr)

input_file <- "ai_governance_panel.csv"
output_file <- "ai_governance_panel_summary.csv"
sector_output_file <- "ai_governance_sector_summary.csv"

gov_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "year",
  "sector",
  "data_quality_index",
  "institutional_capacity_index",
  "compute_infrastructure_index",
  "equity_accountability_index",
  "interoperability_index"
)

missing_cols <- setdiff(required_cols, names(gov_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

gov_df <- gov_df %>%
  mutate(
    governance_readiness_proxy = (
      data_quality_index +
      institutional_capacity_index +
      compute_infrastructure_index +
      equity_accountability_index +
      interoperability_index
    ) / 5,
    institutional_data_gap = institutional_capacity_index - data_quality_index,
    inclusion_gap = interoperability_index - equity_accountability_index
  )

country_summary <- gov_df %>%
  group_by(country) %>%
  summarise(
    avg_governance_readiness = mean(governance_readiness_proxy, na.rm = TRUE),
    min_governance_readiness = min(governance_readiness_proxy, na.rm = TRUE),
    max_governance_readiness = max(governance_readiness_proxy, na.rm = TRUE),
    avg_institutional_data_gap = mean(institutional_data_gap, na.rm = TRUE),
    avg_inclusion_gap = mean(inclusion_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    readiness_band = case_when(
      avg_governance_readiness >= 0.70 ~ "High readiness",
      avg_governance_readiness >= 0.50 ~ "Moderate readiness",
      avg_governance_readiness >= 0.35 ~ "Stressed readiness",
      TRUE ~ "Low readiness"
    )
  ) %>%
  arrange(desc(avg_governance_readiness))

sector_summary <- gov_df %>%
  group_by(country, sector) %>%
  summarise(
    avg_sector_readiness = mean(governance_readiness_proxy, na.rm = TRUE),
    avg_sector_data_quality = mean(data_quality_index, na.rm = TRUE),
    avg_sector_institutional_capacity = mean(institutional_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(country, desc(avg_sector_readiness))

write_csv(country_summary, output_file)
write_csv(sector_summary, sector_output_file)

cat("AI governance readiness summary exported to:", output_file, "\n")
print(country_summary)

cat("\nSector summary exported to:", sector_output_file, "\n")
print(sector_summary)
