library(readr)
library(dplyr)

input_file <- "industrial_transition_country_panel.csv"
country_output_file <- "cross_country_industrial_transition_summary.csv"
region_output_file <- "regional_industrial_transition_summary.csv"

transition_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "manufacturing_share_index",
  "services_productivity_index",
  "technology_upgrading_index",
  "supplier_ecosystem_index",
  "green_transition_readiness_index",
  "regional_inclusion_index",
  "lock_in_risk_index"
)

missing_cols <- setdiff(required_cols, names(transition_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

transition_df <- transition_df %>%
  mutate(
    capability_proxy = (
      technology_upgrading_index +
      supplier_ecosystem_index +
      green_transition_readiness_index +
      regional_inclusion_index
    ) / 4,
    constrained_transition_proxy = (
      manufacturing_share_index +
      services_productivity_index +
      capability_proxy +
      (1 - lock_in_risk_index)
    ) / 4
  )

country_summary <- transition_df %>%
  group_by(country) %>%
  summarise(
    avg_capability_proxy = mean(capability_proxy, na.rm = TRUE),
    avg_transition_proxy = mean(constrained_transition_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    transition_band = case_when(
      avg_transition_proxy >= 0.75 ~ "High transition capacity",
      avg_transition_proxy >= 0.55 ~ "Moderate transition capacity",
      avg_transition_proxy >= 0.35 ~ "Emerging transition capacity",
      TRUE ~ "Low transition capacity"
    )
  ) %>%
  arrange(desc(avg_transition_proxy))

region_summary <- transition_df %>%
  group_by(region) %>%
  summarise(
    avg_capability_proxy = mean(capability_proxy, na.rm = TRUE),
    avg_transition_proxy = mean(constrained_transition_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_transition_proxy))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Cross-country industrial transition summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegional industrial transition summary exported to:", region_output_file, "\n")
print(region_summary)
