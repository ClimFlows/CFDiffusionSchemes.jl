"""
    ThermoFluxScheme{F}
Abstract type for schemes of the diffusive fluxes of the thermodynamic tracers: the conservative variable (consvar)
and the composition q.
"""
abstract type ThermoFluxScheme{F} end

"""
    ThermoFluxDowngradient(; k_T, k_q)
Downgradient fluxes of consvar and q: each is diffused down its own gradient, with diffusivity `k_T` for consvar
and `k_q` for q [m² s⁻¹].
"""
struct ThermoFluxDowngradient{F} <: ThermoFluxScheme{F}
    k_T::F
    k_q::F
end
ThermoFluxDowngradient(; k_T, k_q) = ThermoFluxDowngradient(k_T, k_q)

"""
    ThermoFluxConsistent(; k_T, k_q)
Thermodynamically consistent fluxes of consvar and q: a heat flux down the temperature gradient, with thermal
diffusivity `k_T`, and a composition flux down the gradient of q corrected for barodiffusion, with diffusivity `k_q`
[m² s⁻¹].
"""
struct ThermoFluxConsistent{F} <: ThermoFluxScheme{F}
    k_T::F
    k_q::F
end
ThermoFluxConsistent(; k_T, k_q) = ThermoFluxConsistent(k_T, k_q)

# former names
Base.@deprecate_binding HeatFluxScheme ThermoFluxScheme
Base.@deprecate_binding HeatFluxSimple ThermoFluxDowngradient
Base.@deprecate_binding HeatFluxConsistent ThermoFluxConsistent

"""
    ViscosityScheme(; dyn_visc)
Newtonian viscosity with a constant dynamic viscosity μ = `dyn_visc` [Pa s] and the Stokes hypothesis (zero bulk
viscosity): the stress is τ = 2μ (S - (∇·u) I / 3), with S the strain rate.
"""
struct ViscosityScheme{F}
    dyn_visc::F
end
ViscosityScheme(; dyn_visc) = ViscosityScheme(dyn_visc)
