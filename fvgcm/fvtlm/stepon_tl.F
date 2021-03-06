#ifdef    SPMD
C                           DISCLAIMER
C
C   This file was generated by TAF version 1.6.1
C
C   FASTOPT DISCLAIMS  ALL  WARRANTIES,  EXPRESS  OR  IMPLIED,
C   INCLUDING (WITHOUT LIMITATION) ALL IMPLIED  WARRANTIES  OF
C   MERCHANTABILITY  OR FITNESS FOR A PARTICULAR PURPOSE, WITH
C   RESPECT TO THE SOFTWARE AND USER PROGRAMS.   IN  NO  EVENT
C   SHALL  FASTOPT BE LIABLE FOR ANY LOST OR ANTICIPATED PROF-
C   ITS, OR ANY INDIRECT, INCIDENTAL, EXEMPLARY,  SPECIAL,  OR
C   CONSEQUENTIAL  DAMAGES, WHETHER OR NOT FASTOPT WAS ADVISED
C   OF THE POSSIBILITY OF SUCH DAMAGES.
C
C                           Haftungsbeschraenkung
C   FastOpt gibt ausdruecklich keine Gewaehr, explizit oder indirekt,
C   bezueglich der Brauchbarkeit  der Software  fuer einen bestimmten
C   Zweck.   Unter  keinen  Umstaenden   ist  FastOpt   haftbar  fuer
C   irgendeinen Verlust oder nicht eintretenden erwarteten Gewinn und
C   allen indirekten,  zufaelligen,  exemplarischen  oder  speziellen
C   Schaeden  oder  Folgeschaeden  unabhaengig  von einer eventuellen
C   Mitteilung darueber an FastOpt.
!
!  14May2007  Todling   Introduced dyn_prog; global change.
!  31May2007  Todling   Add hook to transform between g5-pert and g4-pert
!  17Jul2007  Todling   Add routine stepon_g4tog5_tl
!  11Dec2009  Todling   Add tlfirst/last to allow incremental and
!                       single-shot integrations to be the same
C
      module     stepon_tl
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use precision
      use prognostics
      use prognostics_tl
      use mod_comm, only : gid,mp_exit, mp_init, y_decomp
      use mod_comm, only : numcpu
      use m_strtemplate
#ifdef TIMING
      use timingmodule, only : timing_init, timing_off, timing_on
#endif
      use stepon

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

      PRIVATE
      PUBLIC stepon_do_tl
      PUBLIC stepon_set_tl
      PUBLIC stepon_g4tog5_tl


      real(r8), pointer ::    u_tl(:,:,:)   ! zonal wind on D-grid
      real(r8), pointer ::    v_tl(:,:,:)   ! meridional wind
      real(r8), pointer ::   pt_tl(:,:,:)   ! virtual potential temperature
      real(r8), pointer :: delp_tl(:,:,:)   ! pressure thickness (pascal)
      real(r8), pointer ::    q_tl(:,:,:,:) ! specific humidity & tracer mixing ratios

      contains

      subroutine stepon_do_tl ( g5pert, tlfirst, tllast, prog, xpert, ypert )
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use m_iostate, only : getstate

      use fvcore, only : ns,fvcore_do
      use fvcore, only : fvcore_tape_rec
      use fvcore, only : dynpkg_n2,dynpkg_nsplit
      use fvcore, only : ng_c
      use hswf, only : hswf_do
      use hswf_tl, only : hswf_do_tl
      use fvcore_tl, only : fvcore_do_tl
      use m_physdrv1_tl, only : physdrv1_tl
      use mapz_module, only : te_map

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

C==============================================
C declare local variables
C==============================================
      real(kind=r8) :: ae
      real(kind=r8) :: akap
      real(kind=r8) :: cp
      character*255 :: fnametrj
      integer :: iinner
      integer :: iouter
      integer :: nhms_trj
      integer :: nymd_trj
      integer :: rmaptfrq
      integer :: nx
      integer :: ierr
      real(kind=r8) :: om
      real(kind=r8) :: rg
      real(kind=r8) :: te0
      logical       :: doremap, tlfirst, tllast

      logical, intent(in)     :: g5pert ! when .t. handles as if GEOS-5 perturbation on ways in and out
      type(dyn_prog), TARGET  :: prog
      type(dyn_prog)          :: xpert  ! input  perturbation 
      type(dyn_prog)          :: ypert  ! ouptut perturbation

      type(dyn_prog)          :: pert
      real(r8) ua_tl(imr,jfirst-1:jlast,nl) ! U-Wind on A-Grid
      real(r8) va_tl(imr,jfirst:jlast,nl)   ! V-Wind on A-Grid

      call prognostics_initial ( pert )

! Set pointers
! ------------
       call prognostics_dup ( xpert, pert )

       u_tl   => pert%u
       v_tl   => pert%v
      pt_tl   => pert%pt
      delp_tl => pert%delp
      q_tl    => pert%q

! Set pointers
! ------------
       u   => prog%u
       v   => prog%v
      pt   => prog%pt
      delp => prog%delp
      q    => prog%q

      if ( (jlast-jfirst+1)/numcpu >= 4 ) then
          nx = 1
      else
          nx = 4
      endif

!       If so, convert initial perturbation to GEOS-4 type perturbation
!       ---------------------------------------------------------------
        if ( g5pert .and. tlfirst ) then
            call getstate( nymd, nhms, prog, doremap )
!           call ps2delp_tl ( im, jfirst, jlast, nl, delp_tl )
            call t2th_tl ( delp, delp_tl, pt, pt_tl )
            ua_tl(:,jfirst-1:jlast,:) = pert%u(:,jfirst-1:jlast,:)
            va_tl(:,jfirst  :jlast,:) = pert%v(:,jfirst  :jlast,:)
            call a2d3d  ( ua_tl, va_tl, pert%u, pert%v,
     &                    imr, jnp, nl, jfirst, jlast, ng_d, ng_s, coslon, sinlon )
        endif

C----------------------------------------------
C TANGENT LINEAR AND FUNCTION STATEMENTS
C----------------------------------------------
      do iouter = 1, nouter
        nymd_trj = nymd
        nhms_trj = nhms
        call getstate( nymd_trj, nhms_trj, prog, doremap )

        if (doremap) then
           te0 = 1.0
           call te_map(.false., .false., ps, omga, pe, delp, pkz, pk, mpdt,
     &                  imr, jnp, nl, nx, jfirst, jlast, nq,  u,  v,
     &                  pt, q, phis,  cpair, cappa, kord, peln, te0,
     &                  ng_d, ng_s, 0 )
        endif

        call tick( nymd_trj,nhms_trj,pdt )


        do iinner = 1, ninner
          nstep = iinner-1+(iouter-1)*ninner
#ifdef TIMING
          call g_timing_on( 'FVCORE' )
#endif
          om = omega
          cp = cpair
          rg = rair
          ae = rearth
          call fvcore_do_tl( imr,jnp,nl,nc,jfirst,jlast,ng_d,ng_s,nq,ps,ps_tl,pe,pe_tl,delp,delp_tl,u,u_tl,v,v_tl,pt,pt_tl,q,q_tl,
     $pk,pk_tl,pkz,pkz_tl,phis,ptop,om,cp,rg,ae,iord,jord,kord,umax,omga,peln,consv,convt )
#ifdef TIMING
          call g_timing_off( 'FVCORE' )
#endif
          nstep = nstep+1
          call tick( nymd,nhms,pdt )
          call physdrv1_tl (ptrjtmpl,ptrjfrq,job,imr,jnp,nl,nc,jfirst,jlast, 
     $       coslon,sinlon,q,nymd,nhms,u_tl,v_tl,pt_tl,ng_d,ng_s)

          if (force_dycore) then
            akap = cappa
            call hswf_do_tl( imr,jnp,nl,jfirst,jlast,u,u_tl,v,v_tl,pt,pt_tl,pe,pe_tl,pkz,pkz_tl,pdt,akap,dcaf, .true. ,rayf,cosp,
     $coslon,sinlon,ng_s,ng_d )
          endif
          if (aoa) then
            model_time = nstep*pdt
            call age_of_air_tl( imr,nl,jfirst,jlast,ng_d,model_time,pe,pe_tl,q(1,jfirst-ng_d,1,nq),q_tl(1,jfirst-ng_d,1,nq) )
          endif
        end do

      end do
#ifdef TIMING
      call g_timing_off( 'TOTAL' )
#endif

!       If so, convert final perturbation to GEOS-5 type perturbation
!       ---------------------------------------------------------------
        if ( g5pert .and. tllast ) then
            call getstate( nymd, nhms, prog, doremap )
            call th2t_tl ( delp, delp_tl, pt, pt_tl )
            call d2a3d ( pert%u(:,jfirst:jlast+1,:), pert%v, ua_tl(:,jfirst:jlast,:), va_tl,
     &                   imr, jnp, nl, jfirst, jlast, ng_d, ng_s, coslon, sinlon )
            pert%u(:,jfirst-ng_d:jfirst-ng_d+2,:) = 0._r8
            pert%v(:,jfirst-ng_s:jfirst     -2,:) = 0._r8
            pert%v(:,jlast    +1:jlast   +ng_d,:) = 0._r8
            pert%u(:,jfirst-1:jlast,:) = ua_tl(:,jfirst-1:jlast,:)
            pert%v(:,jfirst  :jlast,:) = va_tl(:,jfirst  :jlast,:)
!           call delp2ps_tl ( im, jfirst, jlast, nl, delp_tl )
        endif


      call prognostics_dup   ( pert, ypert )
      call prognostics_final ( pert )

      end subroutine stepon_do_tl


      subroutine stepon_set_tl ( prog_tl )
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use prognostics_tl, only : ps_tl

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

      type(dyn_prog) :: prog_tl

C----------------------------------------------
C RESET TANGENT MODULE VARIABLES
C----------------------------------------------
      prog_tl%delp(:,:,:) = 0.
      prog_tl%pt(:,:,:) = 0.
      prog_tl%q(:,:,:,:) = 0.
      prog_tl%u(:,:,:) = 0.
      prog_tl%v(:,:,:) = 0.

      ps_tl(:,:) = 0.

      end subroutine stepon_set_tl

!-------------------------------------------------------------------------
!     NASA/GSFC, Global Modeling and Assimilation Office, Code 601.1     !
!-------------------------------------------------------------------------
!BOP
!
! !ROUTINE: stepon_g4tog5_tl:  Convert GEOS-4 perturbations to GEOS-5 like
!
! !INTERFACE:

      subroutine stepon_g4tog5_tl ( nymd_, nhms_, xpert )

! !USES:

      use m_iostate, only : getstate
      implicit none

! !INPUT PARAMETERS:

      integer, intent(in) :: nymd_, nhms_ ! current date/time

! !OUTPUT PARAMETERS:

      type(dyn_prog)      :: xpert        ! input perturbation at current date/time

! !DESCRIPTION: Convert GEOS-4 perturbation to GEOS-5 type perturbation
!
! !TO DO: Replace sequence of calls in step_tl by a call to this
!
! !REVISION HISTORY:
!
!  31May2007  Todling   Initial code (extracted from stepon_tl above).
!
!EOP
!-----------------------------------------------------------------------

      real(r8) ua_tl(imr,jfirst-1:jlast,nl) ! U-Wind on A-Grid
      real(r8) va_tl(imr,jfirst:jlast,nl)   ! V-Wind on A-Grid

      type(dyn_prog)  :: prog

      logical doremap     

! Set pointers
! ------------
       u_tl   => xpert%u
       v_tl   => xpert%v
      pt_tl   => xpert%pt
      delp_tl => xpert%delp
      q_tl    => xpert%q
                                                                                                                          
      call prognostics_initial ( prog )

! Set pointers
! ------------
       u   => prog%u
       v   => prog%v
      pt   => prog%pt
      delp => prog%delp
      q    => prog%q


! Read in current basic state
! ---------------------------
       call getstate( nymd, nhms, prog, doremap )

! Convert potential temperature to temperature
! --------------------------------------------
       call th2t_tl ( delp, delp_tl, pt, pt_tl )

! Convert D-grid winds to A-grid
! ------------------------------
       call d2a3d ( xpert%u(:,jfirst:jlast+1,:), xpert%v, ua_tl(:,jfirst:jlast,:), va_tl,
     &               imr, jnp, nl, jfirst, jlast, ng_d, ng_s, coslon, sinlon )
       u_tl(:,jfirst-ng_d:jfirst-ng_d+2,:) = 0._r8
       v_tl(:,jfirst-ng_s:jfirst     -2,:) = 0._r8
       v_tl(:,jlast    +1:jlast   +ng_d,:) = 0._r8
       u_tl(:,jfirst-1:jlast,:) = ua_tl(:,jfirst-1:jlast,:)
       v_tl(:,jfirst  :jlast,:) = va_tl(:,jfirst  :jlast,:)

!      call delp2ps_tl ( im, jfirst, jlast, nl, delp_tl )

      call prognostics_final ( prog )

      end subroutine stepon_g4tog5_tl

      end module     stepon_tl


#else  /* SPMD */
C                           DISCLAIMER
C
C   This file was generated by TAF version 1.6.1
C
C   FASTOPT DISCLAIMS  ALL  WARRANTIES,  EXPRESS  OR  IMPLIED,
C   INCLUDING (WITHOUT LIMITATION) ALL IMPLIED  WARRANTIES  OF
C   MERCHANTABILITY  OR FITNESS FOR A PARTICULAR PURPOSE, WITH
C   RESPECT TO THE SOFTWARE AND USER PROGRAMS.   IN  NO  EVENT
C   SHALL  FASTOPT BE LIABLE FOR ANY LOST OR ANTICIPATED PROF-
C   ITS, OR ANY INDIRECT, INCIDENTAL, EXEMPLARY,  SPECIAL,  OR
C   CONSEQUENTIAL  DAMAGES, WHETHER OR NOT FASTOPT WAS ADVISED
C   OF THE POSSIBILITY OF SUCH DAMAGES.
C
C                           Haftungsbeschraenkung
C   FastOpt gibt ausdruecklich keine Gewaehr, explizit oder indirekt,
C   bezueglich der Brauchbarkeit  der Software  fuer einen bestimmten
C   Zweck.   Unter  keinen  Umstaenden   ist  FastOpt   haftbar  fuer
C   irgendeinen Verlust oder nicht eintretenden erwarteten Gewinn und
C   allen indirekten,  zufaelligen,  exemplarischen  oder  speziellen
C   Schaeden  oder  Folgeschaeden  unabhaengig  von einer eventuellen
C   Mitteilung darueber an FastOpt.
C
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use precision
      use prognostics
      use prognostics_tl
      use reference
      use reference_tl
      use m_strtemplate
#ifdef TIMING
      use timingmodule, only : timing_init, timing_off, timing_on
#endif
      use stepon

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

      contains
      subroutine stepon_do_tl
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use m_iostate, only : getstate
      use m_iostate, only : putstate
      use m_trajmng, only : putpert

      use fvcore, only : ns,fvcore_do
      use fvcore, only : fvcore_tape_rec
      use fvcore, only : dynpkg_n2,dynpkg_nsplit
      use fvcore, only : ng_c
      use hswf, only : hswf_do
      use hswf_tl, only : hswf_do_tl
      use fvcore_tl, only : fvcore_do_tl
      use m_physdrv1_tl, only : physdrv1_tl
      use mapz_module, only: te_map

!
!  RME added next line:  Add module for polar filter of SVs
      use m_pftSV

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

C==============================================
C declare local variables
C==============================================
      real(kind=r8) :: ae
      real(kind=r8) :: akap
      real(kind=r8) :: cp
      character*255 :: fnametrj
      integer :: iinner
      integer :: iouter
      integer :: nhms_trj
      integer :: nymd_trj
      integer :: rmaptfrq
      integer :: nx
      integer :: ierr
      real(kind=r8) :: om
      real(kind=r8) :: rg
      real(kind=r8) :: te0

      character(len=*), parameter :: diagnlmrc = 'nlmstatetl.rc'
      character(len=*), parameter :: diagtlmrc = 'tlmstate.rc'

      logical       :: doremap
!
!  RME added next line:  Add array  for polar filter of SVs
      real(kind=r8), allocatable :: fields_pft(:,:,:,:)

C----------------------------------------------
C TANGENT LINEAR AND FUNCTION STATEMENTS
C----------------------------------------------
      do iouter = 1, nouter
        nymd_trj = nymd
        nhms_trj = nhms
        call tick( nymd_trj,nhms_trj,pdt )
        call getstate( nymd_trj, nhms_trj, prog, doremap)

        if (doremap) then
           nx = 4
           te0 = 1.0
           call te_map(.false., .false., ps, omga, pe, delp, pkz, pk, mpdt,
     &                  imr, jnp, nl, nx, jfirst, jlast, nq,  u,  v,
     &                  pt, q, phis,  cpair, cappa, kord, peln, te0,
     &                  ng_d, ng_s, 0 )
        endif

        do iinner = 1, ninner
          nstep = iinner-1+(iouter-1)*ninner
#ifdef TIMING
          call g_timing_on( 'FVCORE' )
#endif
          om = omega
          cp = cpair
          rg = rair
          ae = rearth

!         For diagnostic purposes ...
!         ---------------------------
          call putstate ( job, nymd, nhms, nstep, ptop, ks, ak, bk, Ts, oro,
     &                    diagnlmrc, stat=ierr )
          call putpert  ( job, nymd, nhms, nstep, ptop, ks, ak, bk, Ts, oro,
     &                    diagtlmrc, stat=ierr )
!
!
! RME: added for polar filter of initial SV fields
! This should only be added when computing SVs
! The copying to the temperary work field fields_pft is so this
! works with MPI when only a subset of lats is to be passed
          if (iouter.eq.1 .and. iinner.eq.1) then
            allocate (fields_pft(imr,jfirst:jlast,nl,4))
            fields_pft(:,:,:,1)=  pt_tl(:,jfirst:jlast,:)
            fields_pft(:,:,:,2)=delp_tl(:,jfirst:jlast,:)
            fields_pft(:,:,:,3)=   u_tl(:,jfirst:jlast,:)
            fields_pft(:,:,:,4)=   v_tl(:,jfirst:jlast,:)
            call pftSV (imr,jnp,nl,jfirst,jlast,
     &                  cosp(jfirst:jlast),cose(jfirst:jlast),
     &                  fields_pft(:,:,:,1),fields_pft(:,:,:,2),
     &                  fields_pft(:,:,:,3),fields_pft(:,:,:,4) )
              pt_tl(:,jfirst:jlast,:)=fields_pft(:,:,:,1)
            delp_tl(:,jfirst:jlast,:)=fields_pft(:,:,:,2)
               u_tl(:,jfirst:jlast,:)=fields_pft(:,:,:,3)
               v_tl(:,jfirst:jlast,:)=fields_pft(:,:,:,4)
            deallocate (fields_pft)
          endif
!
! end of RME added code
!
!
          call fvcore_do_tl( imr,jnp,nl,nc,jfirst,jlast,ng_d,ng_s,nq,ps,ps_tl,pe,pe_tl,delp,delp_tl,u,u_tl,v,v_tl,pt,pt_tl,q,q_tl,
     $pk,pk_tl,pkz,pkz_tl,phis,ptop,om,cp,rg,ae,iord,jord,kord,umax,omga,peln,consv,convt )
#ifdef TIMING
          call g_timing_off( 'FVCORE' )
#endif
          nstep = nstep+1
          call tick( nymd,nhms,pdt )

!         Call the physics: vertical diffusion for the default case
!         ---------------------------------------------------------
          call physdrv1_tl ( ptrjtmpl, ptrjfrq, job, imr, jnp, nl, nc, jfirst, jlast, 
     $                       coslon, sinlon,  q,  nymd,  nhms, u_tl,   v_tl,   pt_tl, 0, 0)

          if (force_dycore) then
            akap = cappa
            call hswf_do_tl( imr,jnp,nl,jfirst,jlast,u,u_tl,v,v_tl,pt,pt_tl,pe,pe_tl,pkz,pkz_tl,pdt,akap,dcaf, .true. ,rayf,cosp,
     $coslon,sinlon,ng_s,ng_d )
          endif
          if (aoa) then
            model_time = nstep*pdt
            call age_of_air_tl( imr,nl,jfirst,jlast,ng_d,model_time,pe,pe_tl,q(1,jfirst-ng_d,1,nq),q_tl(1,jfirst-ng_d,1,nq) )
          endif
        end do
      end do
#ifdef TIMING
      call g_timing_off( 'TOTAL' )
#endif

      end subroutine stepon_do_tl


      subroutine stepon_set_tl
C******************************************************************
C******************************************************************
C** This routine was generated by Automatic differentiation.     **
C** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
C******************************************************************
C******************************************************************
C==============================================
C referencing used modules
C==============================================
      use prognostics_tl

C==============================================
C all entries are defined explicitly
C==============================================
      implicit none

C----------------------------------------------
C RESET TANGENT MODULE VARIABLES
C----------------------------------------------
      delp_tl(:,:,:) = 0.
      ps_tl(:,:) = 0.
      pt_tl(:,:,:) = 0.
      q_tl(:,:,:,:) = 0.
      u_tl(:,:,:) = 0.
      v_tl(:,:,:) = 0.

      end subroutine stepon_set_tl


      end module     stepon_tl


#endif /* SPMD */
