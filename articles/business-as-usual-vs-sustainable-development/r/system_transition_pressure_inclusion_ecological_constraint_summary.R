library(readr)
library(dplyr)

input_file <- "business_as_usual_vs_sustainable_development_country_panel.csv"
output_file <- "system_transition_pressure_inclusion_ecological_constraint_summary.csv"

sd_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "fossil_dependence_index",
  "resource_throughput_pressure_index",
  "urban_lock_in_index",
  "inequality_pressure_index",
  "public_goods_inclusion_index",
  "ecological_stress_index",
  "governance_transition_capacity_index",
  "clean_technology_adoption_index",
  "sustainable_development_alignment_index"
)

missing_cols <- setdiff(required_cols, names(sd_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

sd_df <- sd_df %>%
  mutate(
    business_as_usual_proxy = (
      fossil_dependence_index +
      resource_throughput_pressure_index +
      urban_lock_in_index +
      inequality_pressure_index +
      ecological_stress_index +
      (1 - public_goods_inclusion_index) +
      (1 - governance_transition_capacity_index) +
      (1 - clean_technology_adoption_index) +
      (1 - sustainable_development_alignment_index)
    ) / 9
  )

summary_df <- sd_df %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_business_as_usual_proxy = mean(business_as_usual_proxy, na.rm = TRUE),
    avg_transition_capacity = mean((governance_transition_capacity_index + clean_technology_adoption_index + sustainable_development_alignment_index) / 3, na.rm = TRUE),
    avg_inclusion = mean(public_goods_inclusion_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_business_as_usual_proxy))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
