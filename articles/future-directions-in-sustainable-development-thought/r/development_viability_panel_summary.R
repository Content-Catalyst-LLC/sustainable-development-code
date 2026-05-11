#!/usr/bin/env Rscript

# R Workflow: Tracking Viability, Inequality, and Institutional Resilience Indicators

panel <- read.csv("data/development_viability_panel.csv", stringsAsFactors = FALSE)

required_cols <- c(
  "country",
  "year",
  "income_index",
  "ecological_integrity_index",
  "resilience_index",
  "governance_capacity_index",
  "technology_capability_index",
  "justice_equity_index",
  "planetary_pressure_index",
  "institutional_stress_index"
)

missing_cols <- setdiff(required_cols, names(panel))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

panel$viability_proxy <- (
  0.16 * panel$income_index +
  0.22 * panel$ecological_integrity_index +
  0.18 * panel$resilience_index +
  0.16 * panel$governance_capacity_index +
  0.13 * panel$technology_capability_index +
  0.15 * panel$justice_equity_index
)

panel$system_pressure <- (
  0.55 * panel$planetary_pressure_index +
  0.45 * panel$institutional_stress_index
)

panel$viability_gap <- 1 - panel$viability_proxy

summary <- aggregate(
  cbind(viability_proxy, system_pressure, viability_gap) ~ country,
  data = panel,
  FUN = function(x) c(mean = mean(x), min = min(x), max = max(x))
)

summary <- do.call(data.frame, summary)

latest <- panel[panel$year == max(panel$year), ]
latest <- latest[order(-latest$viability_proxy), ]

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

write.csv(panel, "outputs/development_viability_panel_scored_r.csv", row.names = FALSE)
write.csv(summary, "outputs/development_viability_summary_r.csv", row.names = FALSE)
write.csv(latest, "outputs/latest_viability_rankings_r.csv", row.names = FALSE)

cat("Development viability panel summary complete.\n")
print(latest[, c("country", "year", "viability_proxy", "system_pressure", "viability_gap")])
