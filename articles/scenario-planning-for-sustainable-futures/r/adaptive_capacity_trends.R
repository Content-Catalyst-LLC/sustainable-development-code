library(readr)
library(dplyr)

input_file <- "adaptive_capacity_panel.csv"
output_file <- "adaptive_capacity_trends.csv"

cap_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "year",
  "adaptive_capacity_index",
  "institutional_learning_index",
  "policy_flexibility_index"
)

missing_cols <- setdiff(required_cols, names(cap_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

summary_df <- cap_df %>%
  group_by(country) %>%
  summarise(
    start_adaptive_capacity = first(adaptive_capacity_index),
    end_adaptive_capacity = last(adaptive_capacity_index),
    start_policy_flexibility = first(policy_flexibility_index),
    end_policy_flexibility = last(policy_flexibility_index),
    avg_institutional_learning = mean(institutional_learning_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    adaptive_capacity_change = end_adaptive_capacity - start_adaptive_capacity,
    policy_flexibility_change = end_policy_flexibility - start_policy_flexibility
  ) %>%
  arrange(desc(adaptive_capacity_change))

write_csv(summary_df, output_file)

cat("Adaptive capacity trends exported to:", output_file, "\n")
print(summary_df)
