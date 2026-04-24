library(readr)
library(dplyr)

input_file <- "population_growth_global_economy_country_panel.csv"
output_file <- "population_growth_urbanization_public_system_pressure_summary.csv"

pop_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "territory_name",
  "country_or_region",
  "territory_type",
  "youth_dependency_index",
  "old_age_dependency_index",
  "working_age_share_index",
  "labor_absorption_capacity_index",
  "human_capital_investment_index",
  "urbanization_pressure_index",
  "infrastructure_capacity_index",
  "ecological_throughput_pressure_index",
  "governance_capacity_index",
  "demographic_transition_alignment_index"
)

missing_cols <- setdiff(required_cols, names(pop_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- pop_df %>%
  mutate(
    demographic_development_proxy = (
      youth_dependency_index +
      old_age_dependency_index +
      (1 - labor_absorption_capacity_index) +
      (1 - human_capital_investment_index) +
      urbanization_pressure_index +
      (1 - infrastructure_capacity_index) +
      ecological_throughput_pressure_index +
      (1 - governance_capacity_index) +
      (1 - demographic_transition_alignment_index)
    ) / 9
  ) %>%
  group_by(country_or_region, territory_type) %>%
  summarise(
    avg_demographic_development_proxy = mean(demographic_development_proxy, na.rm = TRUE),
    avg_working_age_share = mean(working_age_share_index, na.rm = TRUE),
    avg_governance_capacity = mean(governance_capacity_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_demographic_development_proxy))

write_csv(summary_df, output_file)
cat("Exported:", output_file, "\n")
print(summary_df)
