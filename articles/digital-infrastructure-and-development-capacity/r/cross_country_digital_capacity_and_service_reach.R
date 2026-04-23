library(readr)
library(dplyr)

input_file <- "digital_capacity_country_panel.csv"
country_output_file <- "cross_country_digital_capacity_summary.csv"
region_output_file <- "regional_digital_capacity_summary.csv"

digital_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "connectivity_index",
  "digital_identity_index",
  "payments_rail_index",
  "data_exchange_index",
  "service_delivery_index",
  "inclusion_access_index",
  "public_trust_index",
  "lock_in_risk_index"
)

missing_cols <- setdiff(required_cols, names(digital_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

digital_df <- digital_df %>%
  mutate(
    dpi_proxy = (
      digital_identity_index +
      payments_rail_index +
      data_exchange_index +
      service_delivery_index
    ) / 4,
    constrained_capacity_proxy = (
      connectivity_index +
      dpi_proxy +
      inclusion_access_index +
      public_trust_index +
      (1 - lock_in_risk_index)
    ) / 5
  )

country_summary <- digital_df %>%
  group_by(country) %>%
  summarise(
    avg_dpi_proxy = mean(dpi_proxy, na.rm = TRUE),
    avg_constrained_capacity = mean(constrained_capacity_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    capacity_band = case_when(
      avg_constrained_capacity >= 0.75 ~ "High digital capacity",
      avg_constrained_capacity >= 0.55 ~ "Moderate digital capacity",
      avg_constrained_capacity >= 0.35 ~ "Emerging digital capacity",
      TRUE ~ "Low digital capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_capacity))

region_summary <- digital_df %>%
  group_by(region) %>%
  summarise(
    avg_dpi_proxy = mean(dpi_proxy, na.rm = TRUE),
    avg_constrained_capacity = mean(constrained_capacity_proxy, na.rm = TRUE),
    avg_lock_in_risk = mean(lock_in_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_capacity))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Cross-country digital capacity summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegional digital capacity summary exported to:", region_output_file, "\n")
print(region_summary)
