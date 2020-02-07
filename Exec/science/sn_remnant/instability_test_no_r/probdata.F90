module probdata_module

  ! Ensman test variables -- we set the defaults here
  use amrex_fort_module, only : rt => amrex_real
  real(rt), save :: rho0 = 5.0e-13_rt
  real(rt), save :: T0 = 100.e0_rt
  real(rt), save :: v0 = 235435.371882e0_rt
  real(rt), save :: rho1 = 1.2e-12_rt
  real(rt), save :: T1 = 207.756999533e0_rt
!  real(rt), save :: v1 = 102986.727159e0_rt
  real(rt), save :: v1 = 0.0e0_rt
  real(rt), save :: e1 = 10.0e0_rt
  real(rt), save :: e0 = 24.0e0_rt
  real(rt), save :: rho_bump = 4.8e-12_rt 
  real(rt), save :: e_bump = 2.5e0_rt
  


  integer, save :: idir = 1   ! Direction integer x, y ,z = 1,2,3

  namelist /fortin/ rho0, T0, v0, rho1, T1, v1, idir, e0, e1, rho_bump, e_bump

  ! for convenience
  real(rt), save :: xmin, xmax, ymin, ymax, zmin, zmax

  real(rt), save :: eint0, etot0, eint1, etot1

end module probdata_module
