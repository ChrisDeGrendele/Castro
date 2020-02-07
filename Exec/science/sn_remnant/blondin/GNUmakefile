PRECISION  = DOUBLE
PROFILE    = FALSE

DEBUG      = FALSE

DIM        =  1

COMP	   = gnu

USE_MPI    = TRUE
USE_OMP    = FALSE

DIMENSION_AGNOSTIC = TRUE
GPU_COMPATIBLE_PROBLEM = TRUE

# define the location of the CASTRO top directory
CASTRO_HOME  := ../../../..
AMREX_HOME   := ../../../../../amrex/
HYPRE_DIR    := /home/cdegrendele/codes/hypre/src/hypre/

# This sets the EOS directory in Castro/EOS
EOS_DIR     := gamma_law_general
USE_RAD = TRUE

Opacity_dir := rad_power_law


# This sets the network directory in Castro/Networks
NETWORK_DIR := general_null
GENERAL_NET_INPUTS = $(CASTRO_HOME)/Microphysics/networks/$(NETWORK_DIR)/gammalaw.net

Bpack   := ./Make.package
Blocs   := .

include $(CASTRO_HOME)/Exec/Make.Castro
