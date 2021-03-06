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
module     fill_module_ttl
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use fill_module

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine filew_ttl( q, q_ttm, im, jm, jfirst, jlast, acap, ipx, tiny, cosp2 )
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
real(kind=r8) :: acap
real(kind=r8) :: cosp2
integer :: im
integer :: ipx
integer :: jfirst
integer :: jlast
integer :: jm
real(kind=r8) :: q(im,jfirst:jlast)
real(kind=r8) :: q_ttm(im,jfirst:jlast)
real(kind=r8) :: tiny

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: d0
real(kind=r8) :: d0_ttl
real(kind=r8) :: d1
real(kind=r8) :: d1_ttl
real(kind=r8) :: d2
real(kind=r8) :: d2_ttl
integer :: i
integer :: ip2
integer :: j
integer :: j1
integer :: j2
integer :: jm1
real(kind=r8) :: qtmp(jfirst:jlast,im)
real(kind=r8) :: qtmp_ttl(jfirst:jlast,im)

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
j1 = max(jfirst,2)
j2 = min(jlast,jm-1)
jm1 = jm-1
ipx = 0
do i = 1, im
  do j = j1, j2
    qtmp_ttl(j,i) = q_ttm(i,j)
    qtmp(j,i) = q(i,j)
  end do
end do
do i = 2, im-1
  do j = j1, j2
    if (qtmp(j,i) .lt. 0.) then
      ipx = 1
      d0_ttl = qtmp_ttl(j,i-1)*(0.5-sign(0.5d0,0._8-qtmp(j,i-1)))
      d0 = max(0._8,qtmp(j,i-1))
      d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
      d1 = min(-qtmp(j,i),d0)
      qtmp_ttl(j,i-1) = (-d1_ttl)+qtmp_ttl(j,i-1)
      qtmp(j,i-1) = qtmp(j,i-1)-d1
      qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
      qtmp(j,i) = qtmp(j,i)+d1
      d0_ttl = qtmp_ttl(j,i+1)*(0.5-sign(0.5d0,0._8-qtmp(j,i+1)))
      d0 = max(0._8,qtmp(j,i+1))
      d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
      d2 = min(-qtmp(j,i),d0)
      qtmp_ttl(j,i+1) = (-d2_ttl)+qtmp_ttl(j,i+1)
      qtmp(j,i+1) = qtmp(j,i+1)-d2
      qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
      qtmp(j,i) = qtmp(j,i)+d2+tiny
    endif
  end do
end do
i = 1
do j = j1, j2
  if (qtmp(j,i) .lt. 0.) then
    ipx = 1
    d0_ttl = qtmp_ttl(j,im)*(0.5-sign(0.5d0,0._8-qtmp(j,im)))
    d0 = max(0._8,qtmp(j,im))
    d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d1 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,im) = (-d1_ttl)+qtmp_ttl(j,im)
    qtmp(j,im) = qtmp(j,im)-d1
    qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d1
    d0_ttl = qtmp_ttl(j,i+1)*(0.5-sign(0.5d0,0._8-qtmp(j,i+1)))
    d0 = max(0._8,qtmp(j,i+1))
    d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d2 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,i+1) = (-d2_ttl)+qtmp_ttl(j,i+1)
    qtmp(j,i+1) = qtmp(j,i+1)-d2
    qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d2+tiny
  endif
end do
i = im
do j = j1, j2
  if (qtmp(j,i) .lt. 0.) then
    ipx = 1
    d0_ttl = qtmp_ttl(j,i-1)*(0.5-sign(0.5d0,0._8-qtmp(j,i-1)))
    d0 = max(0._8,qtmp(j,i-1))
    d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d1 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,i-1) = (-d1_ttl)+qtmp_ttl(j,i-1)
    qtmp(j,i-1) = qtmp(j,i-1)-d1
    qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d1
    d0_ttl = qtmp_ttl(j,1)*(0.5-sign(0.5d0,0._8-qtmp(j,1)))
    d0 = max(0._8,qtmp(j,1))
    d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d2 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,1) = (-d2_ttl)+qtmp_ttl(j,1)
    qtmp(j,1) = qtmp(j,1)-d2
    qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d2+tiny
  endif
end do
if (ipx .ne. 0) then
  do i = 1, im-1
    do j = j1, j2
      if (qtmp(j,i) .lt. 0.) then
        qtmp_ttl(j,i+1) = qtmp_ttl(j,i+1)+qtmp_ttl(j,i)
        qtmp(j,i+1) = qtmp(j,i+1)+qtmp(j,i)
        qtmp_ttl(j,i) = 0.d0
        qtmp(j,i) = 0.
      endif
    end do
  end do
  do i = im, 2, -1
    do j = j1, j2
      if (qtmp(j,i) .lt. 0.) then
        qtmp_ttl(j,i-1) = qtmp_ttl(j,i-1)+qtmp_ttl(j,i)
        qtmp(j,i-1) = qtmp(j,i-1)+qtmp(j,i)
        qtmp_ttl(j,i) = 0.d0
        qtmp(j,i) = 0.
      endif
    end do
  end do
  do j = j1, j2
    do i = 1, im
      q_ttm(i,j) = qtmp_ttl(j,i)
      q(i,j) = qtmp(j,i)
    end do
  end do
endif
if (jfirst .eq. 1) then
  if (q(1,1) .lt. 0.) then
    call pfix_ttl( q(1,2),q_ttm(1,2),q(1,1),q_ttm(1,1),im,ipx,acap,cosp2 )
  else
    ip2 = 0
    do i = 1, im
      if (q(i,2) .lt. 0.) then
        ip2 = 1
        exit
      endif
    end do
    if (ip2 .ne. 0) then
      call pfix_ttl( q(1,2),q_ttm(1,2),q(1,1),q_ttm(1,1),im,ipx,acap,cosp2 )
    endif
  endif
endif
if (jlast .eq. jm) then
  if (q(1,jm) .lt. 0.) then
    call pfix_ttl( q(1,jm1),q_ttm(1,jm1),q(1,jm),q_ttm(1,jm),im,ipx,acap,cosp2 )
  else
    ip2 = 0
    do i = 1, im
      if (q(i,jm1) .lt. 0.) then
        ip2 = 1
        exit
      endif
    end do
    if (ip2 .ne. 0) then
      call pfix_ttl( q(1,jm1),q_ttm(1,jm1),q(1,jm),q_ttm(1,jm),im,ipx,acap,cosp2 )
    endif
  endif
endif

end subroutine filew_ttl


subroutine fillxy_ttl( q, q_ttm, im, jm, jfirst, jlast, acap, cosp, acosp )
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
! declare parameters
!==============================================
real(kind=r8), parameter :: tiny = 1.e-20

!==============================================
! declare arguments
!==============================================
real(kind=r8) :: acap
integer :: jm
real(kind=r8) :: acosp(jm)
real(kind=r8) :: cosp(jm)
integer :: im
integer :: jfirst
integer :: jlast
real(kind=r8) :: q(im,jfirst:jlast)
real(kind=r8) :: q_ttm(im,jfirst:jlast)

!==============================================
! declare local variables
!==============================================
integer :: ipx

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
call filew_ttl( q,q_ttm,im,jm,jfirst,jlast,acap,ipx,tiny,cosp(2) )

end subroutine fillxy_ttl


subroutine pfix_ttl( q, q_ttm, qp, qp_ttl, im, ipx, acap, cosp2 )
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
real(kind=r8) :: acap
real(kind=r8) :: cosp2
integer :: im
integer :: ipx
real(kind=r8) :: q(im)
real(kind=r8) :: q_ttm(im)
real(kind=r8) :: qp(im)
real(kind=r8) :: qp_ttl(im)

!==============================================
! declare local variables
!==============================================
integer :: i
real(kind=r8) :: pmean
real(kind=r8) :: pmean_ttl
real(kind=r8) :: summ
real(kind=r8) :: summ_ttl
real(kind=r8) :: sump
real(kind=r8) :: sump_ttl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
summ_ttl = 0.d0
summ = 0.
sump_ttl = 0.d0
sump = 0.
do i = 1, im
  summ_ttl = q_ttm(i)+summ_ttl
  summ = summ+q(i)
  sump_ttl = qp_ttl(i)+sump_ttl
  sump = sump+qp(i)
end do
sump_ttl = sump_ttl/dble(im)
sump = sump/im
pmean_ttl = summ_ttl*(cosp2/(acap+cosp2*im))+sump_ttl*(acap/(acap+cosp2*im))
pmean = (sump*acap+summ*cosp2)/(acap+cosp2*im)
do i = 1, im
  q_ttm(i) = pmean_ttl
  q(i) = pmean
  qp_ttl(i) = pmean_ttl
  qp(i) = pmean
end do

end subroutine pfix_ttl


end module     fill_module_ttl


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
module     fill_module_ttl
!******************************************************************
!******************************************************************
!** This routine was generated by Automatic differentiation.     **
!** FastOpt: Transformation of Algorithm in Fortran, TAF 1.6.1   **
!******************************************************************
!******************************************************************
!==============================================
! referencing used modules
!==============================================
use fill_module

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine filew_ttl( q, q_ttm, im, jm, jfirst, jlast, acap, ipx, tiny, cosp2 )
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
real(kind=r8) :: acap
real(kind=r8) :: cosp2
integer :: im
integer :: ipx
integer :: jfirst
integer :: jlast
integer :: jm
real(kind=r8) :: q(im,jfirst:jlast)
real(kind=r8) :: q_ttm(im,jfirst:jlast)
real(kind=r8) :: tiny

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: d0
real(kind=r8) :: d0_ttl
real(kind=r8) :: d1
real(kind=r8) :: d1_ttl
real(kind=r8) :: d2
real(kind=r8) :: d2_ttl
integer :: i
integer :: ip2
integer :: j
integer :: j1
integer :: j2
integer :: jm1
real(kind=r8) :: qtmp(jfirst:jlast,im)
real(kind=r8) :: qtmp_ttl(jfirst:jlast,im)

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
j1 = max(jfirst,2)
j2 = min(jlast,jm-1)
jm1 = jm-1
ipx = 0
do i = 1, im
  do j = j1, j2
    qtmp_ttl(j,i) = q_ttm(i,j)
    qtmp(j,i) = q(i,j)
  end do
end do
do i = 2, im-1
  do j = j1, j2
    if (qtmp(j,i) .lt. 0.) then
      ipx = 1
      d0_ttl = qtmp_ttl(j,i-1)*(0.5-sign(0.5d0,0._8-qtmp(j,i-1)))
      d0 = max(0._8,qtmp(j,i-1))
      d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
      d1 = min(-qtmp(j,i),d0)
      qtmp_ttl(j,i-1) = (-d1_ttl)+qtmp_ttl(j,i-1)
      qtmp(j,i-1) = qtmp(j,i-1)-d1
      qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
      qtmp(j,i) = qtmp(j,i)+d1
      d0_ttl = qtmp_ttl(j,i+1)*(0.5-sign(0.5d0,0._8-qtmp(j,i+1)))
      d0 = max(0._8,qtmp(j,i+1))
      d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
      d2 = min(-qtmp(j,i),d0)
      qtmp_ttl(j,i+1) = (-d2_ttl)+qtmp_ttl(j,i+1)
      qtmp(j,i+1) = qtmp(j,i+1)-d2
      qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
      qtmp(j,i) = qtmp(j,i)+d2+tiny
    endif
  end do
end do
i = 1
do j = j1, j2
  if (qtmp(j,i) .lt. 0.) then
    ipx = 1
    d0_ttl = qtmp_ttl(j,im)*(0.5-sign(0.5d0,0._8-qtmp(j,im)))
    d0 = max(0._8,qtmp(j,im))
    d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d1 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,im) = (-d1_ttl)+qtmp_ttl(j,im)
    qtmp(j,im) = qtmp(j,im)-d1
    qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d1
    d0_ttl = qtmp_ttl(j,i+1)*(0.5-sign(0.5d0,0._8-qtmp(j,i+1)))
    d0 = max(0._8,qtmp(j,i+1))
    d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d2 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,i+1) = (-d2_ttl)+qtmp_ttl(j,i+1)
    qtmp(j,i+1) = qtmp(j,i+1)-d2
    qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d2+tiny
  endif
end do
i = im
do j = j1, j2
  if (qtmp(j,i) .lt. 0.) then
    ipx = 1
    d0_ttl = qtmp_ttl(j,i-1)*(0.5-sign(0.5d0,0._8-qtmp(j,i-1)))
    d0 = max(0._8,qtmp(j,i-1))
    d1_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d1 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,i-1) = (-d1_ttl)+qtmp_ttl(j,i-1)
    qtmp(j,i-1) = qtmp(j,i-1)-d1
    qtmp_ttl(j,i) = d1_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d1
    d0_ttl = qtmp_ttl(j,1)*(0.5-sign(0.5d0,0._8-qtmp(j,1)))
    d0 = max(0._8,qtmp(j,1))
    d2_ttl = d0_ttl*(0.5-sign(0.5d0,d0-(-qtmp(j,i))))-qtmp_ttl(j,i)*(0.5+sign(0.5d0,d0-(-qtmp(j,i))))
    d2 = min(-qtmp(j,i),d0)
    qtmp_ttl(j,1) = (-d2_ttl)+qtmp_ttl(j,1)
    qtmp(j,1) = qtmp(j,1)-d2
    qtmp_ttl(j,i) = d2_ttl+qtmp_ttl(j,i)
    qtmp(j,i) = qtmp(j,i)+d2+tiny
  endif
end do
if (ipx .ne. 0) then
  do i = 1, im-1
    do j = j1, j2
      if (qtmp(j,i) .lt. 0.) then
        qtmp_ttl(j,i+1) = qtmp_ttl(j,i+1)+qtmp_ttl(j,i)
        qtmp(j,i+1) = qtmp(j,i+1)+qtmp(j,i)
        qtmp_ttl(j,i) = 0.d0
        qtmp(j,i) = 0.
      endif
    end do
  end do
  do i = im, 2, -1
    do j = j1, j2
      if (qtmp(j,i) .lt. 0.) then
        qtmp_ttl(j,i-1) = qtmp_ttl(j,i-1)+qtmp_ttl(j,i)
        qtmp(j,i-1) = qtmp(j,i-1)+qtmp(j,i)
        qtmp_ttl(j,i) = 0.d0
        qtmp(j,i) = 0.
      endif
    end do
  end do
  do j = j1, j2
    do i = 1, im
      q_ttm(i,j) = qtmp_ttl(j,i)
      q(i,j) = qtmp(j,i)
    end do
  end do
endif
if (jfirst .eq. 1) then
  if (q(1,1) .lt. 0.) then
    call pfix_ttl( q(1,2),q_ttm(1,2),q(1,1),q_ttm(1,1),im,ipx,acap,cosp2 )
  else
    ip2 = 0
    do i = 1, im
      if (q(i,2) .lt. 0.) then
        ip2 = 1
        exit
      endif
    end do
    if (ip2 .ne. 0) then
      call pfix_ttl( q(1,2),q_ttm(1,2),q(1,1),q_ttm(1,1),im,ipx,acap,cosp2 )
    endif
  endif
endif
if (jlast .eq. jm) then
  if (q(1,jm) .lt. 0.) then
    call pfix_ttl( q(1,jm1),q_ttm(1,jm1),q(1,jm),q_ttm(1,jm),im,ipx,acap,cosp2 )
  else
    ip2 = 0
    do i = 1, im
      if (q(i,jm1) .lt. 0.) then
        ip2 = 1
        exit
      endif
    end do
    if (ip2 .ne. 0) then
      call pfix_ttl( q(1,jm1),q_ttm(1,jm1),q(1,jm),q_ttm(1,jm),im,ipx,acap,cosp2 )
    endif
  endif
endif

end subroutine filew_ttl


subroutine fillxy_ttl( q, q_ttm, im, jm, jfirst, jlast, acap, cosp, acosp )
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
! declare parameters
!==============================================
real(kind=r8), parameter :: tiny = 1.e-20

!==============================================
! declare arguments
!==============================================
real(kind=r8) :: acap
integer :: jm
real(kind=r8) :: acosp(jm)
real(kind=r8) :: cosp(jm)
integer :: im
integer :: jfirst
integer :: jlast
real(kind=r8) :: q(im,jfirst:jlast)
real(kind=r8) :: q_ttm(im,jfirst:jlast)

!==============================================
! declare local variables
!==============================================
integer :: ipx

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
call filew_ttl( q,q_ttm,im,jm,jfirst,jlast,acap,ipx,tiny,cosp(2) )

end subroutine fillxy_ttl


subroutine pfix_ttl( q, q_ttm, qp, qp_ttl, im, ipx, acap, cosp2 )
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
real(kind=r8) :: acap
real(kind=r8) :: cosp2
integer :: im
integer :: ipx
real(kind=r8) :: q(im)
real(kind=r8) :: q_ttm(im)
real(kind=r8) :: qp(im)
real(kind=r8) :: qp_ttl(im)

!==============================================
! declare local variables
!==============================================
integer :: i
real(kind=r8) :: pmean
real(kind=r8) :: pmean_ttl
real(kind=r8) :: summ
real(kind=r8) :: summ_ttl
real(kind=r8) :: sump
real(kind=r8) :: sump_ttl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
summ_ttl = 0.d0
summ = 0.
sump_ttl = 0.d0
sump = 0.
do i = 1, im
  summ_ttl = q_ttm(i)+summ_ttl
  summ = summ+q(i)
  sump_ttl = qp_ttl(i)+sump_ttl
  sump = sump+qp(i)
end do
sump_ttl = sump_ttl/dble(im)
sump = sump/im
pmean_ttl = summ_ttl*(cosp2/(acap+cosp2*im))+sump_ttl*(acap/(acap+cosp2*im))
pmean = (sump*acap+summ*cosp2)/(acap+cosp2*im)
do i = 1, im
  q_ttm(i) = pmean_ttl
  q(i) = pmean
  qp_ttl(i) = pmean_ttl
  qp(i) = pmean
end do

end subroutine pfix_ttl


end module     fill_module_ttl


#endif /* SPMD */
