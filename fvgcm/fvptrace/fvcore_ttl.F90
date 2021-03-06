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
module     fvcore_ttl
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
use fvcore

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine fvcore_do_ttl( im, jm, km, nc, jfirst, jlast, ng_d, ng_s, nq, ps, pe, delp, u, v, pt, q, q_ttm, pk, pkz, phis, ns0, ndt,&
& ptop, om, cp, rg, ae, iord, jord, kord, umax, omga, peln, consv, convt )
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use mapz_module, only : te_map
use mapz_module_ttl, only : te_map_ttl
use cd_core, only : cd_core_do, cd_core_initialize
use cd_core_ttl, only : cd_core_do_ttl
use benergy, only : benergy_do
use cd_core, only : cd_core_tape_rec
use precision
use timingmodule

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
real(kind=r8), intent(in) :: ae
logical, intent(in) :: consv
logical, intent(in) :: convt
real(kind=r8), intent(in) :: cp
integer, intent(in) :: im
integer, intent(in) :: jfirst
integer, intent(in) :: jlast
integer, intent(in) :: km
real(kind=r8), intent(inout) :: delp(im,jfirst:jlast,km)
integer, intent(in) :: iord
integer, intent(in) :: jm
integer, intent(in) :: jord
integer, intent(in) :: kord
integer, intent(in) :: nc
integer, intent(in) :: ndt
integer, intent(in) :: ng_d
integer, intent(in) :: ng_s
integer, intent(in) :: nq
integer, intent(in) :: ns0
real(kind=r8), intent(in) :: om
real(kind=r8), intent(out) :: omga(im,km,jfirst:jlast)
real(kind=r8), intent(inout) :: pe(im,km+1,jfirst:jlast)
real(kind=r8), intent(out) :: peln(im,km+1,jfirst:jlast)
real(kind=r8), intent(in) :: phis(im,jfirst:jlast)
real(kind=r8), intent(inout) :: pk(im,jfirst:jlast,km+1)
real(kind=r8), intent(inout) :: pkz(im,jfirst:jlast,km)
real(kind=r8), intent(inout) :: ps(im,jfirst:jlast)
real(kind=r8), intent(inout) :: pt(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8), intent(in) :: ptop
real(kind=r8), intent(inout) :: q(im,jfirst-ng_d:jlast+ng_d,km,nc)
real(kind=r8), intent(inout) :: q_ttm(im,jfirst-ng_d:jlast+ng_d,km,nc)
real(kind=r8), intent(in) :: rg
real(kind=r8), intent(inout) :: u(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8), intent(in) :: umax
real(kind=r8), intent(inout) :: v(im,jfirst-ng_s:jlast+ng_d,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: cappa
integer :: cd_tape_rec_n
real(kind=r8), allocatable :: cx(:,:,:)
real(kind=r8), allocatable :: cy(:,:,:)
real(kind=r8), allocatable :: delpf(:,:,:)
real(kind=r8), allocatable :: dp0(:,:,:)
real(kind=r8), allocatable :: dpt(:,:,:)
real(kind=r8), allocatable :: dwz(:,:,:)
logical :: fill
logical :: filter
integer :: i
integer :: icd
integer :: ipe
integer :: it
integer :: j
integer :: jcd
integer :: k
real(kind=r8), allocatable :: mfx(:,:,:)
real(kind=r8), allocatable :: mfy(:,:,:)
integer :: n
real(kind=r8), allocatable :: pkc(:,:,:)
real(kind=r8) :: te0
integer :: te_map_tape_rec
real(kind=r8), allocatable :: uc(:,:,:)
real(kind=r8), allocatable :: vc(:,:,:)
real(kind=r8), allocatable :: worka(:,:,:)
real(kind=r8), allocatable :: wz(:,:,:)

!==============================================
! declare data
!==============================================
data filter/ .true. /
data fill/ .true. /

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
cappa = rg/cp
if (iord .le. 2) then
  icd = 1
else
  icd = -2
endif
if (jord .le. 2) then
  jcd = 1
else
  jcd = -2
endif
allocate( worka(im,jfirst:jlast,km) )
allocate( dp0(im,jfirst:jlast,km) )
allocate( mfx(im,jfirst:jlast,km) )
allocate( mfy(im,jfirst:jlast+1,km) )
allocate( cx(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( cy(im,jfirst:jlast+1,km) )
allocate( delpf(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( uc(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( vc(im,jfirst-2:jlast+2,km) )
allocate( dpt(im,jfirst-1:jlast+1,km) )
allocate( dwz(im,jfirst-1:jlast,km+1) )
allocate( pkc(im,jfirst-1:jlast+1,km+1) )
allocate( wz(im,jfirst-1:jlast+1,km+1) )
delpf = 0.
te0 = 0.
if (km .gt. 1) then
  if (consv) then
    call g_timing_on( 'BENERGY' )
    call benergy_do( im,jm,km,u,v,pt,delp,pe,pk,pkz,phis,ng_d,ng_s,cp,te0,mfx,dp0,jfirst,jlast )
    call g_timing_off( 'BENERGY' )
  endif
endif
do n = 1, n2
  if (nq .gt. 0) then
#ifdef USE_OPENMP
    !$omp parallel do private(i,j,k)
#endif /* ! USE_OPENMP */
    do k = 1, km
      do j = jfirst, jlast
        do i = 1, im
          dp0(i,j,k) = delp(i,j,k)
          cx(i,j,k) = 0.
          cy(i,j,k) = 0.
          mfx(i,j,k) = 0.
          mfy(i,j,k) = 0.
        end do
      end do
    end do
  endif
  call cd_core_initialize( im,jm,km,jfirst,jlast,ng_c,ng_d,ng_s,dt,ae,om,ptop,umax,sinp,cosp,cose,acosp,cappa )
  do it = 1, nsplit
    if (it .eq. nsplit .and. n .eq. n2) then
      ipe = 1
    else if (it .eq. 1 .and. n .eq. 1) then
      ipe = -1
    else
      ipe = 0
    endif
    call g_timing_on( 'CD_CORE' )
    call cd_core_do_ttl( im,jm,km,nq,nx,jfirst,jlast,u,v,pt,delp,pe,pk,ns,dt,ptop,umax,fill,filter,acap,ae,rcap,cp,cappa,icd,jcd,&
&iord,jord,ng_c,ng_d,ng_s,ipe,om,phis,sinp,cosp,cose,acosp,sinlon,coslon,cosl5,sinl5,cx,cy,mfx,mfy,delpf,uc,vc,pkz,dpt,worka,&
&dwz,pkc,wz )
    call g_timing_off( 'CD_CORE' )
  end do
  if (nq .ne. 0) then
    call g_timing_on( 'TRAC2D' )
    call trac2d_ttl( dp0,q,q_ttm,nq,cx,cy,mfx,mfy,iord,jord,ng_d,sine,cosp,acosp,acap,rcap,fill,im,jm,km,jfirst,jlast,pkz,worka,&
&cd_tape_rec_n )
    call g_timing_off( 'TRAC2D' )
  endif
end do
if (km .gt. 1) then
  call g_timing_on( 'TE_MAP' )
  call te_map_ttl( consv,convt,ps,omga,pe,delp,pkz,pk,ndt,im,jm,km,nx,jfirst,jlast,nq,u,v,pt,q,q_ttm,phis,cp,cappa,kord,peln,te0,&
&ng_d,ng_s,te_map_tape_rec )
  call g_timing_off( 'TE_MAP' )
endif
deallocate( mfy )
deallocate( mfx )
deallocate( cy )
deallocate( cx )
deallocate( dp0 )
deallocate( delpf )

end subroutine fvcore_do_ttl


end module     fvcore_ttl


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
module     fvcore_ttl
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
use fvcore

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine fvcore_do_ttl( im, jm, km, nc, jfirst, jlast, ng_d, ng_s, nq, ps, pe, delp, u, v, pt, q, q_ttm, pk, pkz, phis, ns0, ndt,&
& ptop, om, cp, rg, ae, iord, jord, kord, umax, omga, peln, consv, convt )
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use mapz_module, only : te_map
use mapz_module_ttl, only : te_map_ttl
use cd_core, only : cd_core_do, cd_core_initialize
use cd_core_ttl, only : cd_core_do_ttl
use benergy, only : benergy_do
use cd_core, only : cd_core_tape_rec
use precision
use timingmodule

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
real(kind=r8), intent(in) :: ae
logical, intent(in) :: consv
logical, intent(in) :: convt
real(kind=r8), intent(in) :: cp
integer, intent(in) :: im
integer, intent(in) :: jfirst
integer, intent(in) :: jlast
integer, intent(in) :: km
real(kind=r8), intent(inout) :: delp(im,jfirst:jlast,km)
integer, intent(in) :: iord
integer, intent(in) :: jm
integer, intent(in) :: jord
integer, intent(in) :: kord
integer, intent(in) :: nc
integer, intent(in) :: ndt
integer, intent(in) :: ng_d
integer, intent(in) :: ng_s
integer, intent(in) :: nq
integer, intent(in) :: ns0
real(kind=r8), intent(in) :: om
real(kind=r8), intent(out) :: omga(im,km,jfirst:jlast)
real(kind=r8), intent(inout) :: pe(im,km+1,jfirst:jlast)
real(kind=r8), intent(out) :: peln(im,km+1,jfirst:jlast)
real(kind=r8), intent(in) :: phis(im,jfirst:jlast)
real(kind=r8), intent(inout) :: pk(im,jfirst:jlast,km+1)
real(kind=r8), intent(inout) :: pkz(im,jfirst:jlast,km)
real(kind=r8), intent(inout) :: ps(im,jfirst:jlast)
real(kind=r8), intent(inout) :: pt(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8), intent(in) :: ptop
real(kind=r8), intent(inout) :: q(im,jfirst-ng_d:jlast+ng_d,km,nc)
real(kind=r8), intent(inout) :: q_ttm(im,jfirst-ng_d:jlast+ng_d,km,nc)
real(kind=r8), intent(in) :: rg
real(kind=r8), intent(inout) :: u(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8), intent(in) :: umax
real(kind=r8), intent(inout) :: v(im,jfirst-ng_s:jlast+ng_d,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: cappa
integer :: cd_tape_rec_n
real(kind=r8), allocatable :: cx(:,:,:)
real(kind=r8), allocatable :: cy(:,:,:)
real(kind=r8), allocatable :: delpf(:,:,:)
real(kind=r8), allocatable :: dp0(:,:,:)
real(kind=r8), allocatable :: dpt(:,:,:)
real(kind=r8), allocatable :: dwz(:,:,:)
logical :: fill
logical :: filter
integer :: i
integer :: icd
integer :: ipe
integer :: it
integer :: j
integer :: jcd
integer :: k
real(kind=r8), allocatable :: mfx(:,:,:)
real(kind=r8), allocatable :: mfy(:,:,:)
integer :: n
real(kind=r8), allocatable :: pkc(:,:,:)
real(kind=r8) :: te0
integer :: te_map_tape_rec
real(kind=r8), allocatable :: uc(:,:,:)
real(kind=r8), allocatable :: vc(:,:,:)
real(kind=r8), allocatable :: worka(:,:,:)
real(kind=r8), allocatable :: wz(:,:,:)

!==============================================
! declare data
!==============================================
data filter/ .true. /
data fill/ .true. /

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
cappa = rg/cp
if (iord .le. 2) then
  icd = 1
else
  icd = -2
endif
if (jord .le. 2) then
  jcd = 1
else
  jcd = -2
endif
allocate( worka(im,jfirst:jlast,km) )
allocate( dp0(im,jfirst:jlast,km) )
allocate( mfx(im,jfirst:jlast,km) )
allocate( mfy(im,jfirst:jlast+1,km) )
allocate( cx(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( cy(im,jfirst:jlast+1,km) )
allocate( delpf(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( uc(im,jfirst-ng_d:jlast+ng_d,km) )
allocate( vc(im,jfirst-2:jlast+2,km) )
allocate( dpt(im,jfirst-1:jlast+1,km) )
allocate( dwz(im,jfirst-1:jlast,km+1) )
allocate( pkc(im,jfirst-1:jlast+1,km+1) )
allocate( wz(im,jfirst-1:jlast+1,km+1) )
delpf = 0.
te0 = 0.
if (km .gt. 1) then
  if (consv) then
    call g_timing_on( 'BENERGY' )
    call benergy_do( im,jm,km,u,v,pt,delp,pe,pk,pkz,phis,ng_d,ng_s,cp,te0,mfx,dp0,jfirst,jlast )
    call g_timing_off( 'BENERGY' )
  endif
endif
do n = 1, n2
  if (nq .gt. 0) then
#ifdef USE_OPENMP
    !$omp parallel do private(i,j,k)
#endif /* ! USE_OPENMP */
    do k = 1, km
      do j = jfirst, jlast
        do i = 1, im
          dp0(i,j,k) = delp(i,j,k)
          cx(i,j,k) = 0.
          cy(i,j,k) = 0.
          mfx(i,j,k) = 0.
          mfy(i,j,k) = 0.
        end do
      end do
    end do
  endif
  call cd_core_initialize( im,jm,km,jfirst,jlast,ng_c,ng_d,ng_s,dt,ae,om,ptop,umax,sinp,cosp,cose,acosp,cappa )
  do it = 1, nsplit
    if (it .eq. nsplit .and. n .eq. n2) then
      ipe = 1
    else if (it .eq. 1 .and. n .eq. 1) then
      ipe = -1
    else
      ipe = 0
    endif
    call g_timing_on( 'CD_CORE' )
    call cd_core_do_ttl( im,jm,km,nq,nx,jfirst,jlast,u,v,pt,delp,pe,pk,ns,dt,ptop,umax,fill,filter,acap,ae,rcap,cp,cappa,icd,jcd,&
&iord,jord,ng_c,ng_d,ng_s,ipe,om,phis,sinp,cosp,cose,acosp,sinlon,coslon,cosl5,sinl5,cx,cy,mfx,mfy,delpf,uc,vc,pkz,dpt,worka,&
&dwz,pkc,wz )
    call g_timing_off( 'CD_CORE' )
  end do
  if (nq .ne. 0) then
    call g_timing_on( 'TRAC2D' )
    call trac2d_ttl( dp0,q,q_ttm,nq,cx,cy,mfx,mfy,iord,jord,ng_d,sine,cosp,acosp,acap,rcap,fill,im,jm,km,jfirst,jlast,pkz,worka,&
&cd_tape_rec_n )
    call g_timing_off( 'TRAC2D' )
  endif
end do
if (km .gt. 1) then
  call g_timing_on( 'TE_MAP' )
  call te_map_ttl( consv,convt,ps,omga,pe,delp,pkz,pk,ndt,im,jm,km,nx,jfirst,jlast,nq,u,v,pt,q,q_ttm,phis,cp,cappa,kord,peln,te0,&
&ng_d,ng_s,te_map_tape_rec )
  call g_timing_off( 'TE_MAP' )
endif
deallocate( mfy )
deallocate( mfx )
deallocate( cy )
deallocate( cx )
deallocate( dp0 )
deallocate( delpf )

end subroutine fvcore_do_ttl


end module     fvcore_ttl


#endif /* SPMD */
