module CFDiffusionSchemes

export ThermoFluxScheme, ThermoFluxConsistent, ThermoFluxDowngradient
export salt_flux, heat_to_consvar, consvar_flux
export ViscosityScheme

include("julia/fine_grain.jl")
include("julia/thermoflux.jl")

end # module CFDiffusionSchemes
