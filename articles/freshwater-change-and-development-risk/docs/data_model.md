# Data Model

Each observation represents a territory, watershed, river corridor, basin, settlement region, agricultural zone, or other spatial unit exposed to freshwater-development risk.

## Required Fields

- `territory_name`
- `country_or_region`
- `territory_type`
- `streamflow_stress_index`
- `soil_moisture_stress_index`
- `water_quality_burden_index`
- `wastewater_treatment_deficit_index`
- `freshwater_ecosystem_decline_index`
- `food_livelihood_dependence_index`
- `health_sanitation_exposure_index`
- `governance_capacity_index`
- `monitoring_readiness_index`

## Index Scale

All index fields use a 0-1 scale.

Governance and monitoring fields are capacity variables, so they reduce the final freshwater-development risk score.
