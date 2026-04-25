#[derive(Debug)]
struct LandSystemInputs {
    conversion_pressure: f64,
    land_degradation: f64,
    fragmentation_risk: f64,
    biodiversity_function_loss: f64,
    food_settlement_dependence: f64,
    infrastructure_pressure: f64,
    justice_exposure: f64,
    governance_capacity: f64,
    restoration_readiness: f64,
}

fn clamp_01(value: f64) -> f64 {
    if value < 0.0 {
        0.0
    } else if value > 1.0 {
        1.0
    } else {
        value
    }
}

fn territorial_stress_score(inputs: &LandSystemInputs) -> f64 {
    clamp_01(
        0.22 * inputs.conversion_pressure
            + 0.22 * inputs.land_degradation
            + 0.18 * inputs.fragmentation_risk
            + 0.18 * inputs.biodiversity_function_loss
            + 0.20 * inputs.infrastructure_pressure,
    )
}

fn development_dependence_score(inputs: &LandSystemInputs) -> f64 {
    clamp_01(
        0.55 * inputs.food_settlement_dependence
            + 0.25 * inputs.justice_exposure
            + 0.20 * inputs.biodiversity_function_loss,
    )
}

fn governance_readiness_score(inputs: &LandSystemInputs) -> f64 {
    clamp_01(
        0.55 * inputs.governance_capacity
            + 0.45 * inputs.restoration_readiness,
    )
}

fn constrained_land_pathway_risk_score(inputs: &LandSystemInputs) -> f64 {
    let territorial = territorial_stress_score(inputs);
    let dependence = development_dependence_score(inputs);
    let governance = governance_readiness_score(inputs);

    clamp_01(
        0.40 * territorial
            + 0.25 * dependence
            + 0.20 * inputs.justice_exposure
            + 0.15 * (1.0 - governance),
    )
}

fn risk_band(score: f64) -> &'static str {
    if score >= 0.80 {
        "Extreme land-pathway risk"
    } else if score >= 0.60 {
        "High land-pathway risk"
    } else if score >= 0.40 {
        "Moderate land-pathway risk"
    } else {
        "Lower land-pathway risk"
    }
}

fn main() {
    let inputs = LandSystemInputs {
        conversion_pressure: 0.72,
        land_degradation: 0.61,
        fragmentation_risk: 0.58,
        biodiversity_function_loss: 0.66,
        food_settlement_dependence: 0.88,
        infrastructure_pressure: 0.63,
        justice_exposure: 0.71,
        governance_capacity: 0.42,
        restoration_readiness: 0.38,
    };

    let score = constrained_land_pathway_risk_score(&inputs);

    println!("Constrained land-pathway risk score: {:.3}", score);
    println!("Risk band: {}", risk_band(score));
}
