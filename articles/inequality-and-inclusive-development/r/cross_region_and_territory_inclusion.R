library(readr)
library(dplyr)

input_file <- "inequality_inclusive_development_country_panel.csv"
region_output_file <- "cross_region_inclusion_summary.csv"
territory_output_file <- "cross_territory_inclusion_summary.csv"

ineq_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "education_access_index",
  "health_access_index",
  "income_security_index",
  "public_goods_access_index",
  "opportunity_blockage_index",
  "institutional_capture_index",
  "governance_capacity_index"
)

missing_cols <- setdiff(required_cols, names(ineq_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

ineq_df <- ineq_df %>%
  mutate(
    inclusion_risk_proxy = (
      (1 - education_access_index) +
      (1 - health_access_index) +
      (1 - income_security_index) +
      (1 - public_goods_access_index) +
      opportunity_blockage_index +
      institutional_capture_index +
      (1 - governance_capacity_index)
    ) / 7
  )

region_summary <- ineq_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_inclusion_risk_proxy = mean(inclusion_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_inclusion_risk_proxy >= 0.75 ~ "Extreme inclusion risk",
      avg_inclusion_risk_proxy >= 0.55 ~ "High inclusion risk",
      avg_inclusion_risk_proxy >= 0.35 ~ "Moderate inclusion risk",
      TRUE ~ "Lower inclusion risk"
    )
  ) %>%
  arrange(desc(avg_inclusion_risk_proxy))

territory_summary <- ineq_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_inclusion_risk_proxy = mean(inclusion_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_inclusion_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region inclusion summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory inclusion summary exported to:", territory_output_file, "\n")
print(territory_summary)
