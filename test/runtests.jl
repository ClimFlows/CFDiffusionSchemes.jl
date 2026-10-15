using CFDiffusionSchemes
using Test


k_T = 0.01
k_q = 0.005
dyn_visc = 0.1

@testset "CFDiffusionSchemes.jl" begin
    downgradient = ThermoFluxDowngradient(; k_T = k_T, k_q = k_q)
    @test downgradient.k_T == k_T
    @test downgradient.k_q == k_q

    consistent = ThermoFluxConsistent(; k_T = k_T, k_q = k_q)
    @test consistent.k_T == k_T
    @test consistent.k_q == k_q

    # former names still resolve
    @test CFDiffusionSchemes.HeatFluxSimple === ThermoFluxDowngradient
    @test CFDiffusionSchemes.HeatFluxConsistent === ThermoFluxConsistent
    @test CFDiffusionSchemes.HeatFluxScheme === ThermoFluxScheme

    viscosity_scheme = ViscosityScheme(; dyn_visc = dyn_visc)
    @test viscosity_scheme.dyn_visc == dyn_visc
end
