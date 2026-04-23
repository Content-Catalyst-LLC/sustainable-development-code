library(readr)
library(dplyr)

input_file <- "institutions_country_panel.csv"
country_output_file <- "cross_country_institutions_summary.csv"
domain_output_file <- "cross_domain_institutions_summary.csv"

inst_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "institutional_domain",
  "implementation_capacity_index",
  "coordination_capacity_index",
  "trust_support_index",
  "accountability_strength_index",
  "delivery_system_reliability_index",
  "fragmentation_risk_index"
)

missing_cols <- setdiff(required_cols, names(inst_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

inst_df <- inst_df %>%
  mutate(
    institutional_capacity_proxy = (
      implementation_capacity_index +
      coordination_capacity_index +
      trust_support_index +
      accountability_strength_index +
      delivery_system_reliability_index
    ) / 5,
    constrained_institutional_proxy = (
      institutional_capacity_proxy +
      (1 - fragmentation_risk_index)
    ) / 2
  )

country_summary <- inst_df %>%
  group_by(country) %>%
  summarise(
    avg_institutional_capacity_proxy = mean(institutional_capacity_proxy, na.rm = TRUE),
    avg_constrained_institutional = mean(constrained_institutional_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    institutional_band = case_when(
      avg_constrained_institutional >= 0.75 ~ "High institutional capacity",
      avg_constrained_institutional >= 0.55 ~ "Moderate institutional capacity",
      avg_constrained_institutional >= 0.35 ~ "Emerging institutional capacity",
      TRUE ~ "Low institutional capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_institutional))

domain_summary <- inst_df %>%
  group_by(institutional_domain) %>%
  summarise(
    avg_institutional_capacity_proxy = mean(institutional_capacity_proxy, na.rm = TRUE),
    avg_constrained_institutional = mean(constrained_institutional_proxy, na.rm = TRUE),
    avg_fragmentation_risk = mean(fragmentation_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_institutional))

write_csv(country_summary, country_output_file)
write_csv(domain_summary, domain_output_file)

cat("Cross-country institutions summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nCross-domain institutions summary exported to:", domain_output_file, "\n")
print(domain_summary)
