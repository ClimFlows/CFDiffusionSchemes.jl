""" 
    HeatFluxScheme{F} 
Abstract type for heat flux schemes.
"""
abstract type HeatFluxScheme{F} end

"""
    HeatFluxSimple{F} 
Scheme with simple downgradient fluxes in consvar and q.
"""
struct HeatFluxSimple{F} <: HeatFluxScheme{F}     
    k_T::F
    k_q::F
end         
HeatFluxSimple(; k_T, k_q) = HeatFluxSimple(k_T, k_q)

"""
    HeatFluxConsistent{F}
Thermodynamically consistent fluxes in consvar and q.
"""
struct HeatFluxConsistent{F} <: HeatFluxScheme{F}
    k_T::F
    k_q::F
end
HeatFluxConsistent(; k_T, k_q) = HeatFluxConsistent(k_T, k_q)

"""
    ViscosityScheme{F} 
Viscosity scheme with dynamic and bulk viscosities.
"""
struct ViscosityScheme{F}     
    dyn_visc::F
    bulk_visc::F
end         
ViscosityScheme(; dyn_visc, bulk_visc) = ViscosityScheme(dyn_visc, bulk_visc)