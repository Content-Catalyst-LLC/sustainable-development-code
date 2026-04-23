library(readr)
library(dplyr)

input_file <- "development_viability_panel.csv"
output_file <- "development_viability_panel_summary.csv"

dev_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "year",
  "ecological_integrity_index",
  "resilience_index",
  "governance_capacity_index",
  "justice_equity_index",
  "technology_capability_index"
)

missing_cols <- setdiff(required_cols, names(dev_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

dev_df <- dev_df %>%
  mutate(
    viability_proxy = (
      ecological_integrity_index +
      resilience_index +
      governance_capacity_index +
      justice_equity_index +
      technology_capability_index
    ) / 5,
    institutional_resilience_gap = governance_capacity_index - resilience_index
  )

country_summary <- dev_df %>%
  group_by(country) %>%
  summarise(
    avg_viability_proxy = mean(viability_proxy, na.rm = TRUE),
    min_viability_proxy = min(viability_proxy, na.rm = TRUE),
    max_viability_proxy = max(viability_proxy, na.rm = TRUE),
    avg_institutional_resilience_gap = mean(institutional_resilience_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    viability_band = case_when(
      avg_viability_proxy >= 0.70 ~ "High Viability",
      avg_viability_proxy >= 0.50 ~ "Moderate Viability",
      avg_viability_proxy >= 0.35 ~ "Stressed Viability",
      TRUE ~ "Low Viability"
    )
  ) %>%
  arrange(desc(avg_viability_proxy))

write_csv(country_summary, output_file)

cat("Development viability panel summary exported to:", output_file, "\n")
print(country_summary)
