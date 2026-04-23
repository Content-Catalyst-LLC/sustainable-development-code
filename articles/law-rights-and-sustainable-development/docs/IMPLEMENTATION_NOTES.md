# Implementation Notes

This module is designed around five linked legal-development questions:

1. Which settings have the strongest legal protection and remedy capacity?
2. Where do exclusion, underenforcement, and weak review constrain rights realization?
3. Which legal domains show the strongest or weakest legal-development capacity?
4. Where are justice access and procedural participation weakest for affected groups?
5. How can rights protection, remedy access, and exclusion risk be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and justice-access analysis.
- Use SQL tables and views to maintain legal, remedy, and risk registries.
- Use Go for lightweight legal-capacity scoring integration.
