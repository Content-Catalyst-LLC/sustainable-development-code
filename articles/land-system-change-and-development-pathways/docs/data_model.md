# Data Model

Each observation represents a territory, landscape, land-use zone, region, corridor, watershed, or other spatial unit.

## Required Fields

- `territory_name`
- `country_or_region`
- `territory_type`
- `conversion_pressure_index`
- `land_degradation_index`
- `fragmentation_risk_index`
- `biodiversity_function_loss_index`
- `food_settlement_dependence_index`
- `infrastructure_expansion_pressure_index`
- `justice_exposure_index`
- `governance_capacity_index`
- `restoration_readiness_index`

## Index Scale

All index fields use a 0-1 scale.

Governance and restoration fields are capacity variables, so they reduce the final pathway-risk score.
