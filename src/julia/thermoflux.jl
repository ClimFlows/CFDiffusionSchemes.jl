# Flux laws of the thermodynamic tracers, shared by the anelastic and compressible models.
# Fluxes are per unit area, along the coordinate direction of the gradients passed in (positive along that direction).

"""
    flux = salt_flux(scheme, ρ, Γ, ∂q, ∂p)

Diffusive flux of composition -ρ k_q (∂q - Γ ∂p) [kg m⁻² s⁻¹], along the direction of the gradients: the density `ρ` [kg m⁻³],
the barodiffusion coefficient `Γ` [Pa⁻¹] with the pressure gradient `∂p` [Pa m⁻¹], and the composition gradient `∂q` [m⁻¹];
`k_q` [m² s⁻¹] is the diffusivity of `scheme`. The barodiffusion term is present for `ThermoFluxConsistent` only;
`ThermoFluxDowngradient` gives -ρ k_q ∂q.
"""
@inline salt_flux(hf::ThermoFluxConsistent, ρ, Γ, ∂q, ∂p) = - ρ * hf.k_q * (∂q - Γ * ∂p)
@inline salt_flux(hf::ThermoFluxDowngradient, ρ, Γ, ∂q, ∂p) = - ρ * hf.k_q * ∂q

"""
    flux = heat_to_consvar(scheme, JT, qflux, conj, ∂consvar_∂q)

Flux of consvar carrying the heat flux `JT` [W m⁻²] (the reduced heat flux): `JT / conj`, with `conj` the conjugate variable of consvar,
plus `∂consvar_∂q * qflux` for `ThermoFluxConsistent`, where `qflux` is the flux of composition and `∂consvar_∂q` the derivative of
consvar with respect to q at constant pressure and temperature. The energy delivered by the flux of consvar and the flux of composition
is then `conj * flux + chempot * qflux`, with `chempot` the modified chemical potential. `ThermoFluxDowngradient` gives `JT / conj`.
"""
@inline heat_to_consvar(::ThermoFluxConsistent, JT, qflux, conj, ∂consvar_∂q) = JT / conj + ∂consvar_∂q * qflux
@inline heat_to_consvar(::ThermoFluxDowngradient, JT, qflux, conj, ∂consvar_∂q) = JT / conj

"""
    flux = consvar_flux(scheme, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q)

Diffusive flux of consvar, along the direction of the gradients. `ThermoFluxConsistent` carries the heat flux -ρ Cp k_T ∂T [W m⁻²]
(density `ρ` [kg m⁻³], heat capacity `Cp` [J kg⁻¹ K⁻¹], temperature gradient `∂T` [K m⁻¹]), converted by `heat_to_consvar`
(arguments `qflux`, `conj`, `∂consvar_∂q`); `ThermoFluxDowngradient` goes down the gradient of consvar, -ρ k_T ∂cons, and ignores the other
arguments.
"""
@inline consvar_flux(hf::ThermoFluxConsistent, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q) =
    heat_to_consvar(hf, - ρ * Cp * hf.k_T * ∂T, qflux, conj, ∂consvar_∂q)
@inline consvar_flux(hf::ThermoFluxDowngradient, ρ, Cp, ∂T, ∂cons, qflux, conj, ∂consvar_∂q) = - ρ * hf.k_T * ∂cons
