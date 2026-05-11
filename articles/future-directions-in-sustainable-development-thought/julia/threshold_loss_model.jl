# Julia Workflow: Nonlinear Threshold Loss for Future Development Pathways

using Dates

function nonlinear_loss(pressure, threshold, lambda_loss)
    pressure < threshold && return 0.0
    return lambda_loss * (pressure - threshold)^2
end

scenarios = [
    ("green_capability_state", 0.41, 0.32),
    ("fragmented_growth", 0.76, 0.68),
    ("extractive_ai_productivity", 0.79, 0.74),
    ("adaptive_public_capacity", 0.44, 0.29),
    ("debt_fragility_pathway", 0.70, 0.82),
]

mkpath("outputs")
open("outputs/threshold_loss_julia.csv", "w") do io
    println(io, "scenario,planetary_pressure,institutional_stress,ecological_loss,institutional_loss,total_threshold_loss")
    for (scenario, pressure, stress) in scenarios
        ecological_loss = nonlinear_loss(pressure, 0.65, 1.40)
        institutional_loss = nonlinear_loss(stress, 0.70, 1.20)
        total = ecological_loss + institutional_loss
        println(io, "$(scenario),$(pressure),$(stress),$(round(ecological_loss,digits=4)),$(round(institutional_loss,digits=4)),$(round(total,digits=4))")
    end
end

open("outputs/julia_manifest.txt", "w") do io
    println(io, "workflow=threshold-loss-model")
    println(io, "runtime=Julia")
    println(io, "julia_version=$(VERSION)")
    println(io, "run_time_utc=$(Dates.format(now(UTC), dateformat\"yyyy-mm-ddTHH:MM:SS.sZ\"))")
end

println("Julia threshold-loss model complete.")
