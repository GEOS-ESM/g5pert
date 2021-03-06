#ifdef    SPMD
!                           DISCLAIMER
!
!   This file was generated by TAF version 1.6.1
!
!   FASTOPT DISCLAIMS  ALL  WARRANTIES,  EXPRESS  OR  IMPLIED,
!   INCLUDING (WITHOUT LIMITATION) ALL IMPLIED  WARRANTIES  OF
!   MERCHANTABILITY  OR FITNESS FOR A PARTICULAR PURPOSE, WITH
!   RESPECT TO THE SOFTWARE AND USER PROGRAMS.   IN  NO  EVENT
!   SHALL  FASTOPT BE LIABLE FOR ANY LOST OR ANTICIPATED PROF-
!   ITS, OR ANY INDIRECT, INCIDENTAL, EXEMPLARY,  SPECIAL,  OR
!   CONSEQUENTIAL  DAMAGES, WHETHER OR NOT FASTOPT WAS ADVISED
!   OF THE POSSIBILITY OF SUCH DAMAGES.
!
!                           Haftungsbeschraenkung
!   FastOpt gibt ausdruecklich keine Gewaehr, explizit oder indirekt,
!   bezueglich der Brauchbarkeit  der Software  fuer einen bestimmten
!   Zweck.   Unter  keinen  Umstaenden   ist  FastOpt   haftbar  fuer
!   irgendeinen Verlust oder nicht eintretenden erwarteten Gewinn und
!   allen indirekten,  zufaelligen,  exemplarischen  oder  speziellen
!   Schaeden  oder  Folgeschaeden  unabhaengig  von einer eventuellen
!   Mitteilung darueber an FastOpt.
!
! !REVISION HISTORY:
!
!  14May2007 Todling Introduced dyn_prog; global change.
!  17May2007 Todling Largely revampped from original code:
!                    - turned into model
!                    - interfaces 1 and 2
!
!  31May2007 Todling Add hooks to handle g5 perturbations
!  11Dec2009 Todling Add adfirst/last to allow incremental and
!                    single-shot integrations to be the same
!
!
module m_model_ad

!==============================================
! referencing used modules
!==============================================
use precision
use prognostics
use prognostics_ad, only : prognostics_initial_ad
use prognostics_ad, only : prognostics_final_ad
use stepon, only : nymd,nhms,nouter,ninner,nstep,stepon_do,stepon_set
use control, only : control_number
use control, only : cont2mod
use control, only : mod2cont
use stepon, only : stepon_tape_rec,mstep
use fvcore, only : dynpkg_n2,dynpkg_nsplit
use mod_comm, only : gid, mp_bcst_n_real, mpi_bcst_n_real_ad
use dependent_ad, only : model2dependent_ad
use stepon_ad, only : stepon_do_ad
use mapz_module_ad, only : mapz_module_initial_ad
use mapz_module_ad, only : mapz_module_final_ad
use m_zeit, only : zeit_ci
use m_zeit, only : zeit_co

implicit none

PRIVATE

PUBLIC amodel_ad
PUBLIC initial_ad
PUBLIC final_ad

interface amodel_ad; module procedure &
          model_ad1_,&
          model_ad2_
end interface amodel_ad

contains

subroutine model_ad1_( pert_ad, nymdi, nhmsi, ntsteps, g5pert, adfirst, adlast, checkpoint )

implicit none

!==============================================
! declare arguments
!==============================================
type(dyn_prog) :: pert_ad
integer, optional, intent(in) :: nymdi
integer, optional, intent(in) :: nhmsi
integer, optional, intent(in) :: ntsteps
logical, optional, intent(in) :: g5pert
logical, optional, intent(in) :: adfirst
logical, optional, intent(in) :: adlast
integer, optional, intent(in) :: checkpoint

type(dyn_prog) :: xpert
type(dyn_prog) :: ypert
integer i,nymds,nhmss,nouters,nstepsv
logical, save :: setup = .true.
logical reset

!----------------------------------------------
! RESET TIME IN ADM
!----------------------------------------------
reset = present(nymdi) .and. present(nhmsi) .and. present(ntsteps)
if ( reset ) then
     nstepsv= ninner+(nouter-1)*ninner
     nymds  = nymd ; nhmss=nhms ; nouters= nouter
     nymd   = nymdi; nhms =nhmsi; nouter = ntsteps
     setup  = .false.
endif

!----------------------------------------------
! DEFFINE AUXILIAR VECTORS
!----------------------------------------------
call prognostics_initial ( xpert )  
call prognostics_initial ( ypert )  

!----------------------------------------------
! ROUTINE BODY
!----------------------------------------------

call prognostics_dup ( pert_ad, ypert )  

call model_ad2_ ( xpert, ypert, setup=setup, g5pert=g5pert, adfirst=adfirst, adlast=adlast, checkpoint=checkpoint )

call prognostics_dup ( xpert, pert_ad )  

!----------------------------------------------
! CLEAN UP
!----------------------------------------------
call prognostics_final ( ypert )  
call prognostics_final ( xpert )  

!----------------------------------------------
! RESET TIME BACK TO ORIGINAL IN TLM
!----------------------------------------------
if ( reset ) then
     nstep = nstepsv
     nymd  = nymds; nhms =nhmss; nouter =nouters
     setup = .true.
endif

end subroutine model_ad1_

subroutine model_ad2_( xpert, ypert, setup, g5pert, adfirst, adlast, checkpoint )

implicit none

!==============================================
! declare arguments
!==============================================
type(dyn_prog) :: ypert  ! input  perturbation
type(dyn_prog) :: xpert  ! output perturbation
logical,optional,intent(in) :: setup
logical,optional,intent(in) :: g5pert
logical,optional,intent(in) :: adfirst
logical,optional,intent(in) :: adlast
integer,optional,intent(in) :: checkpoint

type(dyn_prog) :: myprog
real,allocatable::y_ad(:)
logical, save :: setup_  = .true.
logical, save :: g5pert_ = .false.
logical, save :: adfirst_= .true.
logical, save :: adlast_ = .true.
integer, save :: checkpoint_ = 0 ! default: don't preserve inner trajectory
integer i,ndim

if (present(setup)) then
    setup_ = setup
endif
if (present(g5pert)) then
    g5pert_ = g5pert
endif
if (present(checkpoint)) then
    checkpoint_ = checkpoint
endif
if (present(adfirst)) then
    adfirst_ = adfirst
endif
if (present(adlast)) then
    adlast_ = adlast
endif

!----------------------------------------------
! RESET GLOBAL ADJOINT VARIABLES
!----------------------------------------------
call prognostics_initial ( myprog )
if(setup_) call initial_ad
call prognostics_zero ( xpert )

!----------------------------------------------
! PROPERLY DISTRIBUTE INCOMING PERTURBATION
!----------------------------------------------
call control_number( ndim )
allocate ( y_ad(ndim) )
!!_RTcall model2dependent_ad ( ndim, y_ad, ypert )
call mod2cont ( ndim, y_ad, ypert )
if (gid .ne. 0) then
    y_ad(:) = 0._r8
endif
call prognostics_cnst ( 0._r8, ypert )
call model2dependent_ad ( ndim, y_ad, ypert )
deallocate ( y_ad )

!----------------------------------------------
! ROUTINE BODY
!----------------------------------------------
!_RT stepon_tape_rec = 0
if(setup_) call stepon_set ( myprog )
   call zeit_ci('stpadm')
call stepon_do_ad ( g5pert_, adfirst_, adlast_, checkpoint_, myprog, xpert, ypert )
   call zeit_co('stpadm')

!----------------------------------------------
! FINALIZE GLOBAL ADJOINT VARIABLES
!----------------------------------------------
if ( setup_ ) then
      call final_ad
endif
call prognostics_final ( myprog )

end subroutine model_ad2_

#ifdef _OUT_
subroutine modelmd( n, x, prog )
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use control, only : cont2mod
use stepon, only : stepon_tape_rec
use stepon_ad, only : stepon_domd

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
integer :: n
real(kind=r8) :: x(n)
type(dyn_prog) :: prog

!**********************************************
! executable statements of routine
!**********************************************

stepon_tape_rec = 0
call stepon_set ( prog )
call mp_bcst_n_real( x,n )
call cont2mod( n,x,prog )
call stepon_domd ( prog )

end subroutine modelmd
#endif


subroutine initial_ad
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!----------------------------------------------
! reset adjoint module variables
!----------------------------------------------
call prognostics_initial_ad
call mapz_module_initial_ad

end subroutine initial_ad


subroutine final_ad (release)
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

logical, optional, intent(in) :: release
!----------------------------------------------
! reset adjoint module variables
!----------------------------------------------
if(.not.present(release))then
call mapz_module_final_ad
else
if(release) call mapz_module_final_ad
endif
call prognostics_final_ad

end subroutine final_ad

end module m_model_ad


#else  /* SPMD */
!                           DISCLAIMER
!
!   This file was generated by TAF version 1.6.1
!
!   FASTOPT DISCLAIMS  ALL  WARRANTIES,  EXPRESS  OR  IMPLIED,
!   INCLUDING (WITHOUT LIMITATION) ALL IMPLIED  WARRANTIES  OF
!   MERCHANTABILITY  OR FITNESS FOR A PARTICULAR PURPOSE, WITH
!   RESPECT TO THE SOFTWARE AND USER PROGRAMS.   IN  NO  EVENT
!   SHALL  FASTOPT BE LIABLE FOR ANY LOST OR ANTICIPATED PROF-
!   ITS, OR ANY INDIRECT, INCIDENTAL, EXEMPLARY,  SPECIAL,  OR
!   CONSEQUENTIAL  DAMAGES, WHETHER OR NOT FASTOPT WAS ADVISED
!   OF THE POSSIBILITY OF SUCH DAMAGES.
!
!                           Haftungsbeschraenkung
!   FastOpt gibt ausdruecklich keine Gewaehr, explizit oder indirekt,
!   bezueglich der Brauchbarkeit  der Software  fuer einen bestimmten
!   Zweck.   Unter  keinen  Umstaenden   ist  FastOpt   haftbar  fuer
!   irgendeinen Verlust oder nicht eintretenden erwarteten Gewinn und
!   allen indirekten,  zufaelligen,  exemplarischen  oder  speziellen
!   Schaeden  oder  Folgeschaeden  unabhaengig  von einer eventuellen
!   Mitteilung darueber an FastOpt.
!
subroutine model_ad( n, x, x_ad, fc, fc_ad )
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use precision
use prognostics
use prognostics_ad
use stepon, only : nouter,stepon_do, stepon_set
use control, only : cont2mod
use stepon, only : stepon_tape_rec
use fvcore, only : dynpkg_n2,dynpkg_nsplit
#ifdef TIMING
use timingmodule
#endif
use stepon_ad, only : stepon_do_ad, stepon_domd, stepon_set_ad
use control_ad, only : cont2mod_ad

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
real(kind=r8) :: fc
real(kind=r8) :: fc_ad
integer :: n
real(kind=r8) :: x(n)
real(kind=r8) :: x_ad(n)

!----------------------------------------------
! RESET GLOBAL ADJOINT VARIABLES
!----------------------------------------------
call zero_ad

!----------------------------------------------
! ROUTINE BODY
!----------------------------------------------
!----------------------------------------------
! OPEN TAPE dummytape
!----------------------------------------------
call xxopen( 'dummytape_1_model_delp',22,24,1,8,1 )
call xxopen( 'dummytape_2_model_pe',20,24,2,8,1 )
call xxopen( 'dummytape_3_model_pk',20,24,3,8,1 )
call xxopen( 'dummytape_4_model_pkz',21,24,4,8,1 )
call xxopen( 'dummytape_5_model_ps',20,24,5,8,1 )
call xxopen( 'dummytape_6_model_pt',20,24,6,8,1 )
call xxopen( 'dummytape_7_model_q',19,24,7,8,1 )
call xxopen( 'dummytape_8_model_u',19,24,8,8,1 )
call xxopen( 'dummytape_9_model_v',19,24,9,8,1 )

stepon_tape_rec = 0
call stepon_set
call cont2mod( n,x )
call stepon_do
#ifdef TIMING
call adtiming_off( 'TOTAL' )
#endif
call cost_ad( fc_ad )
#ifdef TIMING
call adtiming_off( 'stepon' )
#endif
call stepon_set
call stepon_do_ad
#ifdef TIMING
call adtiming_on( 'stepon' )
#endif
call stepon_set
call cont2mod_ad( n,x_ad )
call stepon_set_ad
#ifdef TIMING
call adtiming_on( 'TOTAL' )
#endif
!----------------------------------------------
! CLOSE TAPE dummytape
!----------------------------------------------
call xxclose( 'dummytape_1_model_delp',22,24,1,8,1 )
call xxclose( 'dummytape_2_model_pe',20,24,2,8,1 )
call xxclose( 'dummytape_3_model_pk',20,24,3,8,1 )
call xxclose( 'dummytape_4_model_pkz',21,24,4,8,1 )
call xxclose( 'dummytape_5_model_ps',20,24,5,8,1 )
call xxclose( 'dummytape_6_model_pt',20,24,6,8,1 )
call xxclose( 'dummytape_7_model_q',19,24,7,8,1 )
call xxclose( 'dummytape_8_model_u',19,24,8,8,1 )
call xxclose( 'dummytape_9_model_v',19,24,9,8,1 )


!----------------------------------------------
! FINALIZE GLOBAL ADJOINT VARIABLES
!----------------------------------------------
call final_ad

end subroutine model_ad


subroutine modelmd( n, x, fc )
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use precision
use prognostics
use stepon, only : stepon_do, stepon_set
use control, only : cont2mod
use stepon, only : stepon_tape_rec
use fvcore, only : dynpkg_n2,dynpkg_nsplit
#ifdef TIMING
use timingmodule
#endif
use stepon_ad, only : stepon_domd

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
real(kind=r8) :: fc
integer :: n
real(kind=r8) :: x(n)

!**********************************************
! executable statements of routine
!**********************************************
!----------------------------------------------
! OPEN TAPE dummytape
!----------------------------------------------
call xxopen( 'dummytape_1_model_delp',22,24,1,8,1 )
call xxopen( 'dummytape_2_model_pe',20,24,2,8,1 )
call xxopen( 'dummytape_3_model_pk',20,24,3,8,1 )
call xxopen( 'dummytape_4_model_pkz',21,24,4,8,1 )
call xxopen( 'dummytape_5_model_ps',20,24,5,8,1 )
call xxopen( 'dummytape_6_model_pt',20,24,6,8,1 )
call xxopen( 'dummytape_7_model_q',19,24,7,8,1 )
call xxopen( 'dummytape_8_model_u',19,24,8,8,1 )
call xxopen( 'dummytape_9_model_v',19,24,9,8,1 )

stepon_tape_rec = 0
call stepon_set
call cont2mod( n,x )
call stepon_domd
call cost( fc )
!----------------------------------------------
! CLOSE TAPE dummytape
!----------------------------------------------
call xxclose( 'dummytape_1_model_delp',22,24,1,8,1 )
call xxclose( 'dummytape_2_model_pe',20,24,2,8,1 )
call xxclose( 'dummytape_3_model_pk',20,24,3,8,1 )
call xxclose( 'dummytape_4_model_pkz',21,24,4,8,1 )
call xxclose( 'dummytape_5_model_ps',20,24,5,8,1 )
call xxclose( 'dummytape_6_model_pt',20,24,6,8,1 )
call xxclose( 'dummytape_7_model_q',19,24,7,8,1 )
call xxclose( 'dummytape_8_model_u',19,24,8,8,1 )
call xxclose( 'dummytape_9_model_v',19,24,9,8,1 )

end subroutine modelmd


subroutine zero_ad
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use precision
use prognostics
use stepon, only : stepon_do, stepon_set
use control, only : cont2mod
use stepon, only : stepon_tape_rec
use fvcore, only : dynpkg_n2,dynpkg_nsplit
#ifdef TIMING
use timingmodule
#endif
use stepon_ad, only : stepon_domd
use prognostics_ad, only : prognostics_initial_ad

!==============================================
! all entries are defined explicitly
!==============================================
implicit none


!----------------------------------------------
! reset adjoint module variables
!----------------------------------------------
call prognostics_initial_ad

end subroutine zero_ad


subroutine final_ad
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use precision
use prognostics
use stepon, only : stepon_do, stepon_set
use control, only : cont2mod
use stepon, only : stepon_tape_rec
use fvcore, only : dynpkg_n2,dynpkg_nsplit
#ifdef TIMING
use timingmodule
#endif
use stepon_ad, only : stepon_domd
use prognostics_ad, only : prognostics_final_ad

!==============================================
! all entries are defined explicitly
!==============================================
implicit none


!----------------------------------------------
! reset adjoint module variables
!----------------------------------------------
call prognostics_final_ad

end subroutine final_ad


#endif /* SPMD */
