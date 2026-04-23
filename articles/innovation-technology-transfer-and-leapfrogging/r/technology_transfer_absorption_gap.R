library(readr)
library(dplyr)

input_file <- "technology_transfer_absorption_data.csv"
output_file <- "technology_transfer_absorption_gap_summary.csv"

transfer_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "technology_domain",
  "transfer_intensity_index",
  "absorption_capacity_index",
  "supplier_localization_index",
  "regulatory_readiness_index"
)

missing_cols <- setdiff(required_cols, names(transfer_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- transfer_df %>%
  mutate(
    transfer_absorption_gap = transfer_intensity_index - absorption_capacity_index,
    localized_transfer_score = (
      absorption_capacity_index +
      supplier_localization_index +
      regulatory_readiness_index
    ) / 3
  ) %>%
  group_by(country, technology_domain) %>%
  summarise(
    avg_transfer_intensity = mean(transfer_intensity_index, na.rm = TRUE),
    avg_absorption_capacity = mean(absorption_capacity_index, na.rm = TRUE),
    avg_transfer_absorption_gap = mean(transfer_absorption_gap, na.rm = TRUE),
    avg_localized_transfer_score = mean(localized_transfer_score, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(country, desc(avg_transfer_absorption_gap))

write_csv(summary_df, output_file)

cat("Technology transfer absorption gap summary exported to:", output_file, "\n")
print(summary_df)
