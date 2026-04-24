library(readr)
library(dplyr)

input_file <- "economic_growth_to_human_development_country_panel.csv"
region_output_file <- "cross_region_human_development_summary.csv"
territory_output_file <- "cross_territory_human_development_summary.csv"

hd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "output_growth_index",
  "health_capability_index",
  "education_capability_index",
  "income_conversion_index",
  "public_goods_conversion_index",
  "distribution_constraint_index",
  "institutional_support_index",
  "ecological_durability_index",
  "agency_freedom_index",
  "human_development_alignment_index"
)

missing_cols <- setdiff(required_cols, names(hd_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

hd_df <- hd_df %>%
  mutate(
    human_development_proxy = (
      output_growth_index +
      (1 - income_conversion_index) +
      (1 - public_goods_conversion_index) +
      distribution_constraint_index +
      (1 - institutional_support_index) +
      (1 - ecological_durability_index) +
      (1 - agency_freedom_index) +
      (1 - human_development_alignment_index)
    ) / 8
  )

region_summary <- hd_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_human_development_proxy = mean(human_development_proxy, na.rm = TRUE),
    avg_capability_expansion = mean((health_capability_index + education_capability_index + agency_freedom_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_human_development_proxy >= 0.75 ~ "Extreme human development risk",
      avg_human_development_proxy >= 0.55 ~ "High human development risk",
      avg_human_development_proxy >= 0.35 ~ "Moderate human development risk",
      TRUE ~ "Lower human development risk"
    )
  ) %>%
  arrange(desc(avg_human_development_proxy))

territory_summary <- hd_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_human_development_proxy = mean(human_development_proxy, na.rm = TRUE),
    avg_capability_expansion = mean((health_capability_index + education_capability_index + agency_freedom_index) / 3, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_human_development_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region human development summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory human development summary exported to:", territory_output_file, "\n")
print(territory_summary)
