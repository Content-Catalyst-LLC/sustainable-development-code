library(readr)
library(dplyr)

input_file <- "regional_scenarios.csv"
output_file <- "regional_robustness_summary.csv"

regional_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "region",
  "scenario_name",
  "robustness_score",
  "adaptability_score",
  "equity_score"
)

missing_cols <- setdiff(required_cols, names(regional_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- regional_df %>%
  group_by(region) %>%
  summarise(
    avg_robustness_score = mean(robustness_score, na.rm = TRUE),
    avg_adaptability_score = mean(adaptability_score, na.rm = TRUE),
    avg_equity_score = mean(equity_score, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_robustness_score))

write_csv(summary_df, output_file)

cat("Regional robustness summary exported to:", output_file, "\n")
print(summary_df)
