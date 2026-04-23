# Implementation Notes

This module is designed around five linked territorial-governance questions:

1. Which settings have the strongest territorial coordination and service capacity?
2. Where do fragmentation, informality, and hazard exposure constrain local development?
3. Which territory types show the strongest or weakest local-governance capacity?
4. Where are service reach and spatial justice weakest relative to need?
5. How can service, resilience, and fragmentation be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and spatial-justice analysis.
- Use SQL tables and views to maintain territorial, service, and risk registries.
- Use Go for lightweight territorial-capacity scoring integration.
