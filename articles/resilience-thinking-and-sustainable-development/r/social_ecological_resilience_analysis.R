library(readr)
library(dplyr)

input_file <- "social_ecological_resilience_panel.csv"
system_output_file <- "social_ecological_resilience_system_summary.csv"
region_output_file <- "social_ecological_resilience_region_summary.csv"

resilience_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "system_name",
  "region",
  "year",
  "coping_capacity_index",
  "adaptive_capacity_index",
  "transformative_capacity_index",
  "institutional_learning_index",
  "ecological_buffer_index",
  "equity_protection_index"
)

missing_cols <- setdiff(required_cols, names(resilience_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

resilience_df <- resilience_df %>%
  mutate(
    multidimensional_resilience_proxy = (
      coping_capacity_index +
      adaptive_capacity_index +
      transformative_capacity_index +
      institutional_learning_index +
      ecological_buffer_index +
      equity_protection_index
    ) / 6,
    governance_ecology_gap = institutional_learning_index - ecological_buffer_index
  )

system_summary <- resilience_df %>%
  group_by(system_name) %>%
  summarise(
    avg_resilience_proxy = mean(multidimensional_resilience_proxy, na.rm = TRUE),
    min_resilience_proxy = min(multidimensional_resilience_proxy, na.rm = TRUE),
    max_resilience_proxy = max(multidimensional_resilience_proxy, na.rm = TRUE),
    avg_governance_ecology_gap = mean(governance_ecology_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    resilience_band = case_when(
      avg_resilience_proxy >= 0.75 ~ "High resilience",
      avg_resilience_proxy >= 0.55 ~ "Moderate resilience",
      avg_resilience_proxy >= 0.35 ~ "Stressed resilience",
      TRUE ~ "Low resilience"
    )
  ) %>%
  arrange(desc(avg_resilience_proxy))

region_summary <- resilience_df %>%
  group_by(region) %>%
  summarise(
    avg_resilience_proxy = mean(multidimensional_resilience_proxy, na.rm = TRUE),
    avg_coping_capacity = mean(coping_capacity_index, na.rm = TRUE),
    avg_adaptive_capacity = mean(adaptive_capacity_index, na.rm = TRUE),
    avg_transformative_capacity = mean(transformative_capacity_index, na.rm = TRUE),
    avg_institutional_learning = mean(institutional_learning_index, na.rm = TRUE),
    avg_ecological_buffer = mean(ecological_buffer_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_resilience_proxy))

write_csv(system_summary, system_output_file)
write_csv(region_summary, region_output_file)

cat("System resilience summary exported to:", system_output_file, "\n")
print(system_summary)

cat("\nRegion resilience summary exported to:", region_output_file, "\n")
print(region_summary)
