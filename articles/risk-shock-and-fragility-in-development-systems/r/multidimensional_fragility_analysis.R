library(readr)
library(dplyr)

input_file <- "multidimensional_fragility_panel.csv"
country_output_file <- "multidimensional_fragility_country_summary.csv"
region_output_file <- "multidimensional_fragility_region_summary.csv"

fragility_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "region",
  "year",
  "economic_fragility_index",
  "environmental_fragility_index",
  "political_fragility_index",
  "security_fragility_index",
  "societal_fragility_index",
  "human_fragility_index",
  "institutional_capacity_index",
  "infrastructure_resilience_index"
)

missing_cols <- setdiff(required_cols, names(fragility_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

fragility_df <- fragility_df %>%
  mutate(
    multidimensional_fragility_proxy = (
      economic_fragility_index +
      environmental_fragility_index +
      political_fragility_index +
      security_fragility_index +
      societal_fragility_index +
      human_fragility_index
    ) / 6,
    institutional_resilience_gap = institutional_capacity_index - infrastructure_resilience_index
  )

country_summary <- fragility_df %>%
  group_by(country) %>%
  summarise(
    avg_fragility_proxy = mean(multidimensional_fragility_proxy, na.rm = TRUE),
    min_fragility_proxy = min(multidimensional_fragility_proxy, na.rm = TRUE),
    max_fragility_proxy = max(multidimensional_fragility_proxy, na.rm = TRUE),
    avg_institutional_resilience_gap = mean(institutional_resilience_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    fragility_band = case_when(
      avg_fragility_proxy >= 0.70 ~ "Severe fragility",
      avg_fragility_proxy >= 0.50 ~ "Elevated fragility",
      avg_fragility_proxy >= 0.30 ~ "Moderate fragility",
      TRUE ~ "Lower fragility"
    )
  ) %>%
  arrange(desc(avg_fragility_proxy))

region_summary <- fragility_df %>%
  group_by(region) %>%
  summarise(
    avg_fragility_proxy = mean(multidimensional_fragility_proxy, na.rm = TRUE),
    avg_economic_fragility = mean(economic_fragility_index, na.rm = TRUE),
    avg_environmental_fragility = mean(environmental_fragility_index, na.rm = TRUE),
    avg_political_fragility = mean(political_fragility_index, na.rm = TRUE),
    avg_security_fragility = mean(security_fragility_index, na.rm = TRUE),
    avg_societal_fragility = mean(societal_fragility_index, na.rm = TRUE),
    avg_human_fragility = mean(human_fragility_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_fragility_proxy))

write_csv(country_summary, country_output_file)
write_csv(region_summary, region_output_file)

cat("Country fragility summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nRegion fragility summary exported to:", region_output_file, "\n")
print(region_summary)
