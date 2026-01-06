module CFDiffusionSchemes

export HeatFluxScheme, HeatFluxConsistent, HeatFluxSimple
export ViscosityScheme

include("julia/fine_grain.jl")

end # module CFDiffusionSchemes
