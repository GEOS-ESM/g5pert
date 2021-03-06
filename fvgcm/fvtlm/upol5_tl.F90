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
subroutine upol5_tl( u, u_tm, v, v_tm, im, jm, coslon, sinlon, cosl5, sinl5, jfirst, jlast )
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
real(kind=r8) :: cosl5(im)
real(kind=r8) :: coslon(im)
integer :: jfirst
integer :: jlast
integer :: jm
real(kind=r8) :: sinl5(im)
real(kind=r8) :: sinlon(im)
real(kind=r8) :: u(im,jfirst:jlast)
real(kind=r8) :: u_tm(im,jfirst:jlast)
real(kind=r8) :: v(im,jfirst:jlast)
real(kind=r8) :: v_tm(im,jfirst:jlast)

!==============================================
! declare local variables
!==============================================
integer :: i
integer :: imh
real(kind=r8) :: r2im
real(kind=r8) :: uanp(im)
real(kind=r8) :: uanp_tl(im)
real(kind=r8) :: uasp(im)
real(kind=r8) :: uasp_tl(im)
real(kind=r8) :: un
real(kind=r8) :: un_tl
real(kind=r8) :: us
real(kind=r8) :: us_tl
real(kind=r8) :: vanp(im)
real(kind=r8) :: vanp_tl(im)
real(kind=r8) :: vasp(im)
real(kind=r8) :: vasp_tl(im)
real(kind=r8) :: vn
real(kind=r8) :: vn_tl
real(kind=r8) :: vs
real(kind=r8) :: vs_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
imh = im/2
r2im = 0.5d0/dble(im)
if (jfirst .eq. 1) then
  do i = 1, im-1
    uasp_tl(i) = u_tm(i+1,2)+u_tm(i,2)
    uasp(i) = u(i,2)+u(i+1,2)
  end do
  uasp_tl(im) = u_tm(im,2)+u_tm(1,2)
  uasp(im) = u(im,2)+u(1,2)
  do i = 1, im
    vasp_tl(i) = v_tm(i,3)+v_tm(i,2)
    vasp(i) = v(i,2)+v(i,3)
  end do
  us_tl = 0.d0
  us = 0.
  vs_tl = 0.d0
  vs = 0.
  do i = 1, imh
    us_tl = uasp_tl(i+imh)*sinlon(i)-uasp_tl(i)*sinlon(i)+us_tl-vasp_tl(i+imh)*coslon(i)+vasp_tl(i)*coslon(i)
    us = us+(uasp(i+imh)-uasp(i))*sinlon(i)+(vasp(i)-vasp(i+imh))*coslon(i)
    vs_tl = uasp_tl(i+imh)*coslon(i)-uasp_tl(i)*coslon(i)+vasp_tl(i+imh)*sinlon(i)-vasp_tl(i)*sinlon(i)+vs_tl
    vs = vs+(uasp(i+imh)-uasp(i))*coslon(i)+(vasp(i+imh)-vasp(i))*sinlon(i)
  end do
  us_tl = us_tl*r2im
  us = us*r2im
  vs_tl = vs_tl*r2im
  vs = vs*r2im
  do i = 1, imh
    u_tm(i,1) = (-(us_tl*sinl5(i)))-vs_tl*cosl5(i)
    u(i,1) = (-(us*sinl5(i)))-vs*cosl5(i)
    u_tm(i+imh,1) = -u_tm(i,1)
    u(i+imh,1) = -u(i,1)
  end do
endif
if (jlast .eq. jm) then
  do i = 1, im-1
    uanp_tl(i) = u_tm(i+1,jm-1)+u_tm(i,jm-1)
    uanp(i) = u(i,jm-1)+u(i+1,jm-1)
  end do
  uanp_tl(im) = u_tm(im,jm-1)+u_tm(1,jm-1)
  uanp(im) = u(im,jm-1)+u(1,jm-1)
  do i = 1, im
    vanp_tl(i) = v_tm(i,jm-1)+v_tm(i,jm)
    vanp(i) = v(i,jm-1)+v(i,jm)
  end do
  un_tl = 0.d0
  un = 0.
  vn_tl = 0.d0
  vn = 0.
  do i = 1, imh
    un_tl = uanp_tl(i+imh)*sinlon(i)-uanp_tl(i)*sinlon(i)+un_tl+vanp_tl(i+imh)*coslon(i)-vanp_tl(i)*coslon(i)
    un = un+(uanp(i+imh)-uanp(i))*sinlon(i)+(vanp(i+imh)-vanp(i))*coslon(i)
    vn_tl = (-(uanp_tl(i+imh)*coslon(i)))+uanp_tl(i)*coslon(i)+vanp_tl(i+imh)*sinlon(i)-vanp_tl(i)*sinlon(i)+vn_tl
    vn = vn+(uanp(i)-uanp(i+imh))*coslon(i)+(vanp(i+imh)-vanp(i))*sinlon(i)
  end do
  un_tl = un_tl*r2im
  un = un*r2im
  vn_tl = vn_tl*r2im
  vn = vn*r2im
  do i = 1, imh
    u_tm(i,jm) = (-(un_tl*sinl5(i)))+vn_tl*cosl5(i)
    u(i,jm) = (-(un*sinl5(i)))+vn*cosl5(i)
    u_tm(i+imh,jm) = -u_tm(i,jm)
    u(i+imh,jm) = -u(i,jm)
  end do
endif

end subroutine upol5_tl


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
subroutine upol5_tl( u, u_tm, v, v_tm, im, jm, coslon, sinlon, cosl5, sinl5, jfirst, jlast )
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
real(kind=r8) :: cosl5(im)
real(kind=r8) :: coslon(im)
integer :: jfirst
integer :: jlast
integer :: jm
real(kind=r8) :: sinl5(im)
real(kind=r8) :: sinlon(im)
real(kind=r8) :: u(im,jfirst:jlast)
real(kind=r8) :: u_tm(im,jfirst:jlast)
real(kind=r8) :: v(im,jfirst:jlast)
real(kind=r8) :: v_tm(im,jfirst:jlast)

!==============================================
! declare local variables
!==============================================
integer :: i
integer :: imh
real(kind=r8) :: r2im
real(kind=r8) :: uanp(im)
real(kind=r8) :: uanp_tl(im)
real(kind=r8) :: uasp(im)
real(kind=r8) :: uasp_tl(im)
real(kind=r8) :: un
real(kind=r8) :: un_tl
real(kind=r8) :: us
real(kind=r8) :: us_tl
real(kind=r8) :: vanp(im)
real(kind=r8) :: vanp_tl(im)
real(kind=r8) :: vasp(im)
real(kind=r8) :: vasp_tl(im)
real(kind=r8) :: vn
real(kind=r8) :: vn_tl
real(kind=r8) :: vs
real(kind=r8) :: vs_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
imh = im/2
r2im = 0.5d0/dble(im)
if (jfirst .eq. 1) then
  do i = 1, im-1
    uasp_tl(i) = u_tm(i+1,2)+u_tm(i,2)
    uasp(i) = u(i,2)+u(i+1,2)
  end do
  uasp_tl(im) = u_tm(im,2)+u_tm(1,2)
  uasp(im) = u(im,2)+u(1,2)
  do i = 1, im
    vasp_tl(i) = v_tm(i,3)+v_tm(i,2)
    vasp(i) = v(i,2)+v(i,3)
  end do
  us_tl = 0.d0
  us = 0.
  vs_tl = 0.d0
  vs = 0.
  do i = 1, imh
    us_tl = uasp_tl(i+imh)*sinlon(i)-uasp_tl(i)*sinlon(i)+us_tl-vasp_tl(i+imh)*coslon(i)+vasp_tl(i)*coslon(i)
    us = us+(uasp(i+imh)-uasp(i))*sinlon(i)+(vasp(i)-vasp(i+imh))*coslon(i)
    vs_tl = uasp_tl(i+imh)*coslon(i)-uasp_tl(i)*coslon(i)+vasp_tl(i+imh)*sinlon(i)-vasp_tl(i)*sinlon(i)+vs_tl
    vs = vs+(uasp(i+imh)-uasp(i))*coslon(i)+(vasp(i+imh)-vasp(i))*sinlon(i)
  end do
  us_tl = us_tl*r2im
  us = us*r2im
  vs_tl = vs_tl*r2im
  vs = vs*r2im
  do i = 1, imh
    u_tm(i,1) = (-(us_tl*sinl5(i)))-vs_tl*cosl5(i)
    u(i,1) = (-(us*sinl5(i)))-vs*cosl5(i)
    u_tm(i+imh,1) = -u_tm(i,1)
    u(i+imh,1) = -u(i,1)
  end do
endif
if (jlast .eq. jm) then
  do i = 1, im-1
    uanp_tl(i) = u_tm(i+1,jm-1)+u_tm(i,jm-1)
    uanp(i) = u(i,jm-1)+u(i+1,jm-1)
  end do
  uanp_tl(im) = u_tm(im,jm-1)+u_tm(1,jm-1)
  uanp(im) = u(im,jm-1)+u(1,jm-1)
  do i = 1, im
    vanp_tl(i) = v_tm(i,jm-1)+v_tm(i,jm)
    vanp(i) = v(i,jm-1)+v(i,jm)
  end do
  un_tl = 0.d0
  un = 0.
  vn_tl = 0.d0
  vn = 0.
  do i = 1, imh
    un_tl = uanp_tl(i+imh)*sinlon(i)-uanp_tl(i)*sinlon(i)+un_tl+vanp_tl(i+imh)*coslon(i)-vanp_tl(i)*coslon(i)
    un = un+(uanp(i+imh)-uanp(i))*sinlon(i)+(vanp(i+imh)-vanp(i))*coslon(i)
    vn_tl = (-(uanp_tl(i+imh)*coslon(i)))+uanp_tl(i)*coslon(i)+vanp_tl(i+imh)*sinlon(i)-vanp_tl(i)*sinlon(i)+vn_tl
    vn = vn+(uanp(i)-uanp(i+imh))*coslon(i)+(vanp(i+imh)-vanp(i))*sinlon(i)
  end do
  un_tl = un_tl*r2im
  un = un*r2im
  vn_tl = vn_tl*r2im
  vn = vn*r2im
  do i = 1, imh
    u_tm(i,jm) = (-(un_tl*sinl5(i)))+vn_tl*cosl5(i)
    u(i,jm) = (-(un*sinl5(i)))+vn*cosl5(i)
    u_tm(i+imh,jm) = -u_tm(i,jm)
    u(i+imh,jm) = -u(i,jm)
  end do
endif

end subroutine upol5_tl


#endif /* SPMD */
