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

    viscosity_scheme = ViscosityScheme(; dyn_visc = dyn_visc)
    @test viscosity_scheme.dyn_visc == dyn_visc

    # flux laws, against hand-computed values
    @testset "thermodynamic fluxes" begin
        ρ, Γ, ∂q, ∂p = 2.0, 0.5, 3.0, 4.0
        @test salt_flux(consistent, ρ, Γ, ∂q, ∂p) ≈ -0.01                  # -2 (0.005) (3 - 0.5 4)
        @test salt_flux(downgradient, ρ, Γ, ∂q, ∂p) ≈ -0.03                # -2 (0.005) 3
        @test salt_flux(consistent, ρ, 0.0, ∂q, ∂p) == salt_flux(downgradient, ρ, Γ, ∂q, ∂p)

        JT, qflux, conj, ∂consvar_∂q = 6.0, -4.0, 2.0, 0.5
        @test heat_to_consvar(consistent, JT, qflux, conj, ∂consvar_∂q) ≈ 1.0   # 6/2 + 0.5 (-4)
        @test heat_to_consvar(downgradient, JT, qflux, conj, ∂consvar_∂q) ≈ 3.0

        Cp, ∂T, ∂cons = 4.0, 5.0, 7.0
        @test consvar_flux(consistent, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q) ≈ -2.2   # (-2 4 0.01 5)/2 + 0.5 (-4)
        @test consvar_flux(downgradient, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q) ≈ -0.14  # -2 0.01 7
        # the fluxes are allocation-free (explicit wrappers: @allocated on untyped globals or splatted calls counts boxing)
        alloc_salt(s, ρ, Γ, ∂q, ∂p) = @allocated salt_flux(s, ρ, Γ, ∂q, ∂p)
        alloc_heat(s, JT, qflux, conj, ∂c∂q) = @allocated heat_to_consvar(s, JT, qflux, conj, ∂c∂q)
        alloc_cons(s, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂c∂q) = @allocated consvar_flux(s, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂c∂q)
        for scheme in (consistent, downgradient)
            alloc_salt(scheme, ρ, Γ, ∂q, ∂p); alloc_heat(scheme, JT, qflux, conj, ∂consvar_∂q)           # compile
            alloc_cons(scheme, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q)
            @test alloc_salt(scheme, ρ, Γ, ∂q, ∂p) == 0
            @test alloc_heat(scheme, JT, qflux, conj, ∂consvar_∂q) == 0
            @test alloc_cons(scheme, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q) == 0
        end
    end
end
