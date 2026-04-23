library(readr)
library(dplyr)

input_file <- "infrastructure_country_panel.csv"
country_output_file <- "cross_country_infrastructure_summary.csv"
region_output_file <- "regional_infrastructure_summary.csv"

infra_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "transport_access_index",
  "water_access_index",
  "electricity_access_index",
  "digital_connectivity_index",
  "public_service_reach_index",
  "territorial_equity_index",
  "reliability_index"
)

missing_cols <- setdiff(required_cols, names(infra_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

infra_df <- infra_df %>%
  mutate(
    access_proxy = (
      transport_access_index +
      water_access_index +
      electricity_access_index +
      digital_connectivity_index +
      territorial_equity_index
    ) / 5,
    constrained_infrastructure_proxy = (
      access_proxy +
      public_service_reach_index +
      reliability_index
    ) / 3
  )

country_summary <- infra_df %>%
  group_by(country) %>%
  summarise(
    avg_access_proxy = mean(access_proxy, na.rm = TRUE),
    avg_constrained_infrastructure = mean(constrained_infrastructure_proxy, na.rm = TRUE),
    avg_reliability = mean(reliability_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    infrastructure_band = case_when(
      avg_constrained_infrastructure >= 0.75 ~ "High infrastructure capacity",
      avg_constrained_infrastructure >= 0.55 ~ "Moderate infrastructure capacity",
      avg_constrained_infrastructure >= 0.35 ~ "Emerging infrastructure capacity",
      TRUE ~ "Low infrastructure capacity"
    )
  ) %>%
  arrange(desc(avg_constrained_infrastructure))

region_summary <- infra_df %>%
  group_by(region) %>%
  summarise(
    avg_access_proxy = mean(access_proxy, na.rm = TRUE),
    avg_constrained_infrastructure = mean(constrained_infrastructure_proxy, na.rm = TRUE),
    avg_reliability = mean(reliability_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_constrained_infrastructure))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Cross-country infrastructure summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegional infrastructure summary exported to:", region_output_file, "\n")
print(region_summary)
