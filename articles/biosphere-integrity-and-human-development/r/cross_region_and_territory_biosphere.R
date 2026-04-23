library(readr)
library(dplyr)

input_file <- "biosphere_integrity_country_panel.csv"
region_output_file <- "cross_region_biosphere_summary.csv"
territory_output_file <- "cross_territory_biosphere_summary.csv"

bio_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "ecosystem_degradation_index",
  "fragmentation_risk_index",
  "ecological_service_erosion_index",
  "justice_exposure_index",
  "governance_capacity_index",
  "biosphere_function_loss_index"
)

missing_cols <- setdiff(required_cols, names(bio_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

bio_df <- bio_df %>%
  mutate(
    biosphere_risk_proxy = (
      ecosystem_degradation_index +
      fragmentation_risk_index +
      ecological_service_erosion_index +
      justice_exposure_index +
      biosphere_function_loss_index +
      (1 - governance_capacity_index)
    ) / 6
  )

region_summary <- bio_df %>%
  group_by(country_or_region) %>%
  summarise(
    avg_biosphere_risk_proxy = mean(biosphere_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    risk_band = case_when(
      avg_biosphere_risk_proxy >= 0.75 ~ "Extreme biosphere-development risk",
      avg_biosphere_risk_proxy >= 0.55 ~ "High biosphere-development risk",
      avg_biosphere_risk_proxy >= 0.35 ~ "Moderate biosphere-development risk",
      TRUE ~ "Lower biosphere-development risk"
    )
  ) %>%
  arrange(desc(avg_biosphere_risk_proxy))

territory_summary <- bio_df %>%
  group_by(territory_type) %>%
  summarise(
    avg_biosphere_risk_proxy = mean(biosphere_risk_proxy, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_biosphere_risk_proxy))

write_csv(region_summary, region_output_file)
write_csv(territory_summary, territory_output_file)

cat("Cross-region biosphere summary exported to:", region_output_file, "\n")
print(region_summary)

cat("\nCross-territory biosphere summary exported to:", territory_output_file, "\n")
print(territory_summary)
