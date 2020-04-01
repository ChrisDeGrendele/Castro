#ifndef _Castro_hybrid_H_
#define _Castro_hybrid_H_

#include "Castro_util.H"

using namespace amrex;

// Avoid the singularity in cylindrical coordinates
static AMREX_GPU_MANAGED Real R_min = std::numeric_limits<Real>::min();

AMREX_GPU_HOST_DEVICE AMREX_FORCE_INLINE
void linear_to_hybrid(const Real* loc, const Real* linear_mom, Real* hybrid_mom)
{
    // Convert a linear momentum into the "hybrid" scheme
    // that has radial and angular components.

    Real R = amrex::max(std::sqrt(loc[0] * loc[0] + loc[1] * loc[1]), R_min);
    Real RInv = 1.0_rt / R;

    // This conversion is Eqs. 25 and 26 in Byerly et al. 2014.
    // Note that we expect the linear momentum to be consistent
    // with which frame we're measuring the fluid quantities in.
    // So we're effectively always using the first form of those
    // equalities, not the second. If state_in_rotating_frame = 1,
    // then we're not including the centrifugal term in the angular
    // momentum anyway, and if state_in_rotating_frame = 0, then
    // the linear momenta are already expressed in the inertial frame,
    // so we don't need to explicitly take rotation into account.

    hybrid_mom[0] = linear_mom[0] * (loc[0] * RInv) + linear_mom[1] * (loc[1] * RInv);
    hybrid_mom[1] = linear_mom[1] * loc[0] - linear_mom[0] * loc[1];
    hybrid_mom[2] = linear_mom[2];
}


AMREX_GPU_HOST_DEVICE AMREX_FORCE_INLINE
void hybrid_to_linear(const Real* loc, const Real* hybrid_mom, Real* linear_mom)
{
    // Convert a "hybrid" momentum into a linear one.

    Real R = amrex::max(std::sqrt(loc[0] * loc[0] + loc[1] * loc[1]), R_min);
    Real RInv = 1.0_rt / R;

    // This is the inverse of Byerly et al., Equations 25 and 26.

    linear_mom[0] = hybrid_mom[0] * (loc[0] * RInv) - hybrid_mom[1] * (loc[1] * RInv * RInv);
    linear_mom[1] = hybrid_mom[1] * (loc[0] * RInv * RInv) + hybrid_mom[0] * (loc[1] * RInv);
    linear_mom[2] = hybrid_mom[2];
}


AMREX_GPU_HOST_DEVICE AMREX_FORCE_INLINE
void set_hybrid_momentum_source(const Real* loc, const Real* linear_source, Real* hybrid_source)
{
    Real R = amrex::max(std::sqrt(loc[0] * loc[0] + loc[1] * loc[1]), R_min);
    Real RInv = 1.0_rt / R;

    // This is analogous to the conversion of linear momentum to hybrid momentum.

    hybrid_source[0] = linear_source[0] * (loc[0] * RInv) + linear_source[1] * (loc[1] * RInv);
    hybrid_source[1] = linear_source[1] * loc[0] - linear_source[0] * loc[1];
    hybrid_source[2] = linear_source[2];
}


AMREX_GPU_HOST_DEVICE AMREX_FORCE_INLINE
void compute_hybrid_flux(const Real* state, const GeometryData& geomdata, const Real* center,
                         int idir, int i, int j, int k, Real* flux, bool cell_centered = false)
{
    bool ccx = true;
    bool ccy = true;
    bool ccz = true;

    if (idir == 0) {
        ccx = cell_centered;
    }
    else if (idir == 1) {
        ccy = cell_centered;
    }
    else {
        ccz = cell_centered;
    }

    Real loc[3];

    position(i, j, k, geomdata, loc, ccx, ccy, ccz);

    for (int dir = 0; dir < AMREX_SPACEDIM; ++dir)
        loc[dir] -= center[dir];

    Real linear_mom[3];

    for (int dir = 0; dir < 3; ++dir)
        linear_mom[dir] = state[GDRHO] * state[GDU + dir];

    Real hybrid_mom[3];

    linear_to_hybrid(loc, linear_mom, hybrid_mom);

    Real u_adv = state[GDU + idir];

    if (idir == 0) {
        flux[UMR] = hybrid_mom[0] * u_adv;
        flux[UML] = hybrid_mom[1] * u_adv - loc[1] * state[GDPRES];
        flux[UMP] = hybrid_mom[2] * u_adv;
    }
    else if (idir == 1) {
        flux[UMR] = hybrid_mom[0] * u_adv;
        flux[UML] = hybrid_mom[1] * u_adv + loc[0] * state[GDPRES];
        flux[UMP] = hybrid_mom[2] * u_adv;
    }
    else {
        flux[UMR] = hybrid_mom[0] * u_adv;
        flux[UML] = hybrid_mom[1] * u_adv;
        flux[UMP] = hybrid_mom[2] * u_adv + state[GDPRES];
    }

}

#endif