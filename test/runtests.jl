using CFDiffusionSchemes
using Test


k_T = 0.01
k_q = 0.005
dyn_visc = 0.1
bulk_visc = 0.2

@testset "CFDiffusionSchemes.jl" begin
    heatflux_simple = HeatFluxSimple(; k_T = k_T, k_q = k_q)
    @test heatflux_simple.k_T == k_T
    @test heatflux_simple.k_q == k_q

    heatflux_consistent = HeatFluxConsistent(; k_T = k_T, k_q = k_q)
    @test heatflux_consistent.k_T == k_T
    @test heatflux_consistent.k_q == k_q

    viscosity_scheme = ViscosityScheme(; dyn_visc = dyn_visc, bulk_visc = bulk_visc)
    @test viscosity_scheme.dyn_visc == dyn_visc
    @test viscosity_scheme.bulk_visc == bulk_visc
end
