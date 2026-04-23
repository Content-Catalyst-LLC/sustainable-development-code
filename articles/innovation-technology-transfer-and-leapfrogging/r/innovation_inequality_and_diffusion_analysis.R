library(readr)
library(dplyr)

input_file <- "innovation_diffusion_panel.csv"
country_output_file <- "innovation_diffusion_country_summary.csv"
sector_output_file <- "innovation_diffusion_sector_summary.csv"

innovation_df <- read_csv(input_file, show_col_types = FALSE)

required_cols <- c(
  "country",
  "sector",
  "year",
  "technology_access_index",
  "local_adaptation_index",
  "skills_capacity_index",
  "public_support_index",
  "dependency_risk_index"
)

missing_cols <- setdiff(required_cols, names(innovation_df))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

innovation_df <- innovation_df %>%
  mutate(
    capability_diffusion_proxy = (
      technology_access_index +
      local_adaptation_index +
      skills_capacity_index +
      public_support_index
    ) / 4,
    innovation_dependency_gap = capability_diffusion_proxy - dependency_risk_index
  )

country_summary <- innovation_df %>%
  group_by(country) %>%
  summarise(
    avg_capability_diffusion = mean(capability_diffusion_proxy, na.rm = TRUE),
    min_capability_diffusion = min(capability_diffusion_proxy, na.rm = TRUE),
    max_capability_diffusion = max(capability_diffusion_proxy, na.rm = TRUE),
    avg_dependency_gap = mean(innovation_dependency_gap, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  mutate(
    diffusion_band = case_when(
      avg_capability_diffusion >= 0.75 ~ "High diffusion capability",
      avg_capability_diffusion >= 0.55 ~ "Moderate diffusion capability",
      avg_capability_diffusion >= 0.35 ~ "Constrained diffusion capability",
      TRUE ~ "Low diffusion capability"
    )
  ) %>%
  arrange(desc(avg_capability_diffusion))

sector_summary <- innovation_df %>%
  group_by(country, sector) %>%
  summarise(
    avg_access = mean(technology_access_index, na.rm = TRUE),
    avg_local_adaptation = mean(local_adaptation_index, na.rm = TRUE),
    avg_dependency_risk = mean(dependency_risk_index, na.rm = TRUE),
    observations = n(),
    .groups = "drop"
  ) %>%
  arrange(country, desc(avg_local_adaptation))

write_csv(country_summary, country_output_file)
write_csv(sector_summary, sector_output_file)

cat("Innovation diffusion country summary exported to:", country_output_file, "\n")
print(country_summary)

cat("\nInnovation diffusion sector summary exported to:", sector_output_file, "\n")
print(sector_summary)
