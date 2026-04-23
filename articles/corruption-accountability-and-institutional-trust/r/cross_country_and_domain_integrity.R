library(readr)
library(dplyr)

input_file <- "corruption_accountability_country_panel.csv"
country_output_file <- "cross_country_integrity_summary.csv"
domain_output_file <- "cross_domain_integrity_summary.csv"

corr_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "institutional_domain",
  "procurement_integrity_index",
  "service_integrity_index",
  "accountability_strength_index",
  "audit_capacity_index",
  "trust_support_index",
  "capture_risk_index"
)

missing_cols <- setdiff(required_cols, names(corr_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

corr_df <- corr_df %>%
  mutate(
    integrity_proxy = (
      procurement_integrity_index +
      service_integrity_index +
      accountability_strength_index +
      audit_capacity_index
    ) / 4,
    constrained_integrity_proxy = (
      integrity_proxy +
      trust_support_index +
      (1 - capture_risk_index)
    ) / 3
  )

country_summary <- corr_df %>%
  group_by(country) %>%
  summarise(
    avg_integrity_proxy = mean(integrity_proxy, na.rm = TRUE),
    avg_constrained_integrity = mean(constrained_integrity_proxy, na.rm = TRUE),
    avg_capture_risk = mean(capture_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    integrity_band = case_when(
      avg_constrained_integrity >= 0.75 ~ "High integrity capacity",
      avg_constrained_integrity >= 0.55 ~ "Moderate integrity capacity",
      avg_constrained_integrity >= 0.35 ~ "Emerging integrity capacity",
      TRUE ~ "Low integrity capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_integrity))

domain_summary <- corr_df %>%
  group_by(institutional_domain) %>%
  summarise(
    avg_integrity_proxy = mean(integrity_proxy, na.rm = TRUE),
    avg_constrained_integrity = mean(constrained_integrity_proxy, na.rm = TRUE),
    avg_capture_risk = mean(capture_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_integrity))

write_csv(country_summary, country_output_file)
write_csv(domain_summary, domain_output_file)

cat("Cross-country integrity summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-domain integrity summary exported to:", domain_output_file, "\n")
print(domain_summary)
