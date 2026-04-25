#[derive(Debug)]
struct FreshwaterInputs {
    streamflow_stress: f64,
    soil_moisture_stress: f64,
    water_quality_burden: f64,
    wastewater_treatment_deficit: f64,
    freshwater_ecosystem_decline: f64,
    food_livelihood_dependence: f64,
    health_sanitation_exposure: f64,
    governance_capacity: f64,
    monitoring_readiness: f64,
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

fn hydrological_stress_score(inputs: &FreshwaterInputs) -> f64 {
    clamp_01(
        0.22 * inputs.streamflow_stress
            + 0.20 * inputs.soil_moisture_stress
            + 0.18 * inputs.water_quality_burden
            + 0.20 * inputs.wastewater_treatment_deficit
            + 0.20 * inputs.freshwater_ecosystem_decline,
    )
}

fn development_exposure_score(inputs: &FreshwaterInputs) -> f64 {
    clamp_01(
        0.45 * inputs.food_livelihood_dependence
            + 0.35 * inputs.health_sanitation_exposure
            + 0.20 * inputs.water_quality_burden,
    )
}

fn governance_readiness_score(inputs: &FreshwaterInputs) -> f64 {
    clamp_01(
        0.55 * inputs.governance_capacity
            + 0.45 * inputs.monitoring_readiness,
    )
}

fn constrained_freshwater_risk_score(inputs: &FreshwaterInputs) -> f64 {
    let hydrological = hydrological_stress_score(inputs);
    let exposure = development_exposure_score(inputs);
    let governance = governance_readiness_score(inputs);

    clamp_01(
        0.42 * hydrological
            + 0.28 * exposure
            + 0.15 * inputs.health_sanitation_exposure
            + 0.15 * (1.0 - governance),
    )
}

fn risk_band(score: f64) -> &'static str {
    if score >= 0.80 {
        "Extreme freshwater-development risk"
    } else if score >= 0.60 {
        "High freshwater-development risk"
    } else if score >= 0.40 {
        "Moderate freshwater-development risk"
    } else {
        "Lower freshwater-development risk"
    }
}

fn main() {
    let inputs = FreshwaterInputs {
        streamflow_stress: 0.81,
        soil_moisture_stress: 0.78,
        water_quality_burden: 0.63,
        wastewater_treatment_deficit: 0.55,
        freshwater_ecosystem_decline: 0.69,
        food_livelihood_dependence: 0.88,
        health_sanitation_exposure: 0.72,
        governance_capacity: 0.41,
        monitoring_readiness: 0.39,
    };

    let score = constrained_freshwater_risk_score(&inputs);

    println!("Constrained freshwater-development risk score: {:.3}", score);
    println!("Risk band: {}", risk_band(score));
}
