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
subroutine d2a3d_ad( u_ae, v_ae, ua_ad, va_ad, im, jm, km, jfirst, jlast, ng_d, ng_s, coslon, sinlon )
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
use mod_comm, only : mp_barrier, mp_recv_n, mp_recv_n_ad, mp_send_s, mp_send_s_ad,mp_send2_n,mp_recv2_s

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
integer :: im
real(kind=r8) :: coslon(im)
integer :: jfirst
integer :: jlast
integer :: jm
integer :: km
integer :: ng_d
integer :: ng_s
real(kind=r8) :: sinlon(im)
real(kind=r8) :: u_ae(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: ua_ad(im,jfirst-ng_d:jlast,km)
real(kind=r8) :: v_ae(im,jfirst-ng_s:jlast+ng_d,km)
real(kind=r8) :: va_ad(im,jfirst:jlast,km)

!==============================================
! declare local variables
!==============================================
integer :: i
integer :: k

!----------------------------------------------
! ROUTINE BODY
!----------------------------------------------
#ifdef SPMD
      call mp_barrier
      call mp_send2_n(im,jm,jfirst,jlast,1,km,ng_d,0,ua_ad,ua_ad)
      call mp_barrier
      call mp_recv2_s(im,jm,jfirst,jlast,1,km,ng_d,0,ua_ad,ua_ad)
#endif
#ifdef USE_OPENMP
!$omp parallel do shared(coslon,im,jfirst,jlast,jm,km,sinlon,u_ae,ua_ad,v_ae,va_ad) private(k)
#endif /* ! USE_OPENMP */
do k = 1, km
  call d2a2_ad(u_ae(:,jfirst:jlast,k),v_ae(:,jfirst:jlast,k),             &
       ua_ad(:,jfirst-ng_d:jlast,k),va_ad(:,jfirst:jlast,k),im,jm,jfirst,jlast,  &
       ng_d,coslon,sinlon)
end do

end subroutine d2a3d_ad


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
subroutine d2a3d_ad( u_ae, v_ae, ua_ad, va_ad, im, jm, km, jfirst, jlast, ng_d, ng_s, coslon, sinlon )
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

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
integer :: im
real(kind=r8) :: coslon(im)
integer :: jfirst
integer :: jlast
integer :: jm
integer :: km
integer :: ng_d
integer :: ng_s
real(kind=r8) :: sinlon(im)
real(kind=r8) :: u_ae(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: ua_ad(im,jfirst:jlast,km)
real(kind=r8) :: v_ae(im,jfirst-ng_s:jlast+ng_d,km)
real(kind=r8) :: va_ad(im,jfirst:jlast,km)

!==============================================
! declare local variables
!==============================================
integer :: k

!----------------------------------------------
! ROUTINE BODY
!----------------------------------------------
#ifdef USE_OPENMP
!$omp parallel do shared(coslon,im,jfirst,jlast,jm,km,sinlon,u_ae,ua_ad,v_ae,va_ad) private(k)
#endif /* ! USE_OPENMP */
do k = 1, km
  call d2a2_ad( u_ae(1,jfirst,k),v_ae(1,jfirst,k),ua_ad(1,jfirst,k),va_ad(1,jfirst,k),im,jm,jfirst,jlast,ng_d,coslon,sinlon )
end do

end subroutine d2a3d_ad


#endif /* SPMD */
