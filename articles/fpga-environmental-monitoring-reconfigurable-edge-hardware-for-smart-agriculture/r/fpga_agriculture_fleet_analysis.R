library(readr)
library(dplyr)

input_file <- "fpga_agriculture_fleet_panel.csv"
output_file <- "fpga_agriculture_fleet_summary.csv"

fleet_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "scenario_name",
  "fleet_size",
  "service_visits_per_year",
  "service_trip_cost_index",
  "average_backhaul_load_mb_day",
  "local_processing_gain_index",
  "annual_failure_rate"
)

missing_cols <- setdiff(required_cols, names(fleet_df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- fleet_df %>%
  mutate(
    service_burden = fleet_size * service_visits_per_year * service_trip_cost_index,
    network_burden = fleet_size * average_backhaul_load_mb_day,
    failure_burden = fleet_size * annual_failure_rate,
    overall_burden_proxy = service_burden + network_burden + failure_burden - (fleet_size * local_processing_gain_index)
  ) %>%
  arrange(desc(overall_burden_proxy))

write_csv(summary_df, output_file)

cat("FPGA agriculture fleet summary exported to:", output_file, "\n")
print(summary_df)
