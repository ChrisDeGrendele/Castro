subroutine PROBINIT (init,name,namlen,problo,probhi)

  use eos_module
  use eos_type_module
  use bl_error_module
  use network
  use probdata_module

  implicit none

  integer init, namlen
  integer name(namlen)
  double precision problo(1), probhi(1)
  double precision xn(nspec)
  
  integer untin,i

  type (eos_t) :: eos_state

  namelist /fortin/ pert_frac, rho_fuel, T_fuel

  !
  !     Build "probin" filename -- the name of file containing fortin namelist.
  !     
  integer, parameter :: maxlen = 256
  character probin*(maxlen)

  if (namlen .gt. maxlen) then
     call bl_error("probin file name too long")
  end if

  do i = 1, namlen
     probin(i:i) = char(name(i))
  end do
         
  ! set namelist defaults
  pert_frac = 0.2d0
  rho_fuel = 1.0d0
  T_fuel = 1.0d0

  ! Read namelists
  open(newunit=untin, file=probin(1:namlen), form='formatted', status='old')
  read(untin, fortin)
  close(untin)
  
  ! compute the internal energy (erg/cc) for the left and right state

end subroutine PROBINIT


! ::: -----------------------------------------------------------
! ::: This routine is called at problem setup time and is used
! ::: to initialize data on each grid.  
! ::: 
! ::: NOTE:  all arrays have one cell of ghost zones surrounding
! :::        the grid interior.  Values in these cells need not
! :::        be set here.
! ::: 
! ::: INPUTS/OUTPUTS:
! ::: 
! ::: level     => amr level of grid
! ::: time      => time at which to init data             
! ::: lo,hi     => index limits of grid interior (cell centered)
! ::: nstate    => number of state components.  You should know
! :::		   this already!
! ::: state     <=  Scalar array
! ::: delta     => cell size
! ::: xlo,xhi   => physical locations of lower left and upper
! :::              right hand corner of grid.  (does not include
! :::		   ghost region).
! ::: -----------------------------------------------------------
subroutine ca_initdata(level,time,lo,hi,nscal, &
                      state,state_l1,state_h1,delta,xlo,xhi)

  use network, only: nspec
  use probdata_module
  use prob_params_module, only: problo, probhi
  use extern_probin_module, only : specific_q_burn
  use meth_params_module, only : NVAR, URHO, UMX, UMZ, UEDEN, UEINT, UTEMP, UFS
  use eos_type_module
  use eos_module

  implicit none

  integer level, nscal
  integer lo(1), hi(1)
  integer state_l1,state_h1
  double precision state(state_l1:state_h1,NVAR)
  double precision time, delta(1)
  double precision xlo(1), xhi(1)
  
  double precision xx, x_int, L
  integer i

  double precision :: e_fuel
  double precision :: rho_ash, T_ash, e_ash
  double precision :: xn_fuel(nspec), xn_ash(nspec)

  type (eos_t) :: eos_state

  integer :: ifuel, iash

  ifuel = network_species_index("fuel")
  iash = network_species_index("ash")

  L = probhi(1) - problo(1)
  x_int = problo(1) + pert_frac*L

  ! fuel state
  xn_fuel(:) = 0.0d0
  xn_fuel(ifuel) = 1.0d0
  
  eos_state%rho = rho_fuel
  eos_state%T = T_fuel
  eos_state%xn(:) = xn_fuel(:)

  call eos(eos_input_rt, eos_state)

  e_fuel = eos_state%e
  
  ! compute the ash state
  rho_ash = rho_fuel / (1.0d0 + specific_q_burn/e_fuel)
  e_ash = e_fuel + specific_q_burn
  xn_ash(:) = 0.0d0
  xn_ash(iash) = 1.0d0

  eos_state%rho = rho_ash
  eos_state%e = e_ash
  eos_state%xn(:) = xn_ash(:)

  call eos(eos_input_re, eos_state)

  T_ash = eos_state%T

  print *, 'fuel: ', rho_fuel, T_fuel, xn_fuel
  print *, 'ash: ', rho_ash, T_ash, xn_ash

  do i = lo(1), hi(1)
     xx = problo(1) + delta(1)*(dble(i) + 0.5d0)
     
     if (xx <= x_int) then

        ! ash
        state(i,URHO ) = rho_ash
        state(i,UMX:UMZ) = 0.0d0
        state(i,UEDEN) = rho_ash*e_ash
        state(i,UEINT) = rho_ash*e_ash
        state(i,UTEMP) = T_ash
        state(i,UFS:UFS-1+nspec) = rho_ash*xn_ash(:)
     else

        ! fuel
        state(i,URHO ) = rho_fuel
        state(i,UMX:UMZ) = 0.0d0
        state(i,UEDEN) = rho_fuel*e_fuel
        state(i,UEINT) = rho_fuel*e_fuel
        state(i,UTEMP) = T_fuel
        state(i,UFS:UFS-1+nspec) = rho_fuel*xn_fuel(:)
     endif
     
  enddo

end subroutine ca_initdata

