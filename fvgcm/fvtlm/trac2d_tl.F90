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
subroutine trac2d_tl( dp1, dp1_tl, q, q_tm, nq, cx, cx_tl, cy, cy_tl, mfx, mfx_tl, mfy, mfy_tl, iord, jord, ng, sine, cosp, acosp, &
&acap, rcap, fill, im, jm, km, jfirst, jlast, va, va_tl, flx, flx_tl, trac2d_tape_rec )
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
use tp_core
use tp_core_tl
use fill_module
use fill_module_tl
use mod_comm, only : mp_barrier, mp_recv2_n, mp_recv3d_ns, mp_recv4d_ns, mp_reduce_max, mp_send2_s, mp_send3d_ns, mp_send4d_ns

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare parameters
!==============================================
real(kind=r8), parameter :: tiny = 1.e-10

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
integer :: km
integer :: ng
real(kind=r8) :: cx(im,jfirst-ng:jlast+ng,km)
real(kind=r8) :: cx_tl(im,jfirst-ng:jlast+ng,km)
real(kind=r8) :: cy(im,jfirst:jlast+1,km)
real(kind=r8) :: cy_tl(im,jfirst:jlast+1,km)
real(kind=r8) :: dp1(im,jfirst:jlast,km)
real(kind=r8) :: dp1_tl(im,jfirst:jlast,km)
logical :: fill
real(kind=r8) :: flx(im,jfirst:jlast,km)
real(kind=r8) :: flx_tl(im,jfirst:jlast,km)
integer :: iord
integer :: jord
real(kind=r8) :: mfx(im,jfirst:jlast,km)
real(kind=r8) :: mfx_tl(im,jfirst:jlast,km)
real(kind=r8) :: mfy(im,jfirst:jlast+1,km)
real(kind=r8) :: mfy_tl(im,jfirst:jlast+1,km)
integer :: nq
real(kind=r8) :: q(im,jfirst-ng:jlast+ng,km,nq)
real(kind=r8) :: q_tm(im,jfirst-ng:jlast+ng,km,nq)
real(kind=r8) :: rcap
real(kind=r8) :: sine(jm)
integer :: trac2d_tape_rec
real(kind=r8) :: va(im,jfirst:jlast,km)
real(kind=r8) :: va_tl(im,jfirst:jlast,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: a2(im,jfirst:jlast)
real(kind=r8) :: a2_tl(im,jfirst:jlast)
real(kind=r8) :: cmax
real(kind=r8) :: cmax_tl
real(kind=r8) :: cy_global
real(kind=r8) :: cy_global_tl
real(kind=r8) :: cymax(km)
real(kind=r8) :: cymax_tl(km)
real(kind=r8) :: dp2(im,jfirst:jlast,km)
real(kind=r8) :: dp2_tl(im,jfirst:jlast,km)
logical :: ffsl(jm,km)
real(kind=r8) :: frac
real(kind=r8) :: frac_tl
real(kind=r8) :: fx(im,jfirst:jlast)
#ifdef USE_OPENMP
real(kind=r8) :: fxm_tl(im,1+jlast-jfirst)
#else /* USE_OPENMP */
real(kind=r8) :: fxr_tl(im,1+jlast-jfirst)
#endif /* USE_OPENMP */
real(kind=r8) :: fy(im,jfirst:jlast+1)
#ifdef USE_OPENMP
real(kind=r8) :: fym_tl(im,1+1+jlast-jfirst)
#else /* USE_OPENMP */
real(kind=r8) :: fyr_tl(im,1+1+jlast-jfirst)
#endif /* USE_OPENMP */
integer :: i
integer :: iq
integer :: it
integer :: j
integer :: jn1g1
integer :: jn2g0
integer :: jn2gd
integer :: js2g0
integer :: js2gd
integer :: k
integer :: nsplt
real(kind=r8) :: sum1
real(kind=r8) :: sum1_tl
real(kind=r8) :: sum2
real(kind=r8) :: sum2_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
call mp_send3d_ns( im,jm,jfirst,jlast,1,km,ng,ng,cx_tl,1 )
call mp_send3d_ns( im,jm,jfirst,jlast,1,km,ng,ng,cx,1 )
call mp_send2_s( im,jm,jfirst,jlast,1,km,0,1,cy_tl,mfy_tl )
call mp_send2_s( im,jm,jfirst,jlast,1,km,0,1,cy,mfy )
js2g0 = max(2,jfirst)
jn2g0 = min(jm-1,jlast)
jn1g1 = min(jm,jlast+1)
js2gd = max(2,jfirst-ng)
jn2gd = min(jm-1,jlast+ng)
#ifdef USE_OPENMP
!$omp parallel do private(cmax,cmax_tl,i,j,k)
#endif /* ! USE_OPENMP */
do k = 1, km
  cymax_tl(k) = 0.d0
  cymax(k) = 0.
  do j = js2g0, jlast
    cmax_tl = 0.d0
    cmax = 0.
    do i = 1, im
      cmax_tl = cmax_tl*(0.5-sign(0.5d0,abs(cy(i,j,k))-cmax))+cy_tl(i,j,k)*(0.5+sign(0.5d0,abs(cy(i,j,k))-cmax))*sign(1.d0,cy(i,j,&
&k))
      cmax = max(abs(cy(i,j,k)),cmax)
    end do
    cymax_tl(k) = cmax_tl*(0.5-sign(0.5d0,cymax(k)-cmax*(1.+sine(j)**16)))*(1+sine(j)**16)+cymax_tl(k)*(0.5+sign(0.5d0,cymax(k)-&
&cmax*(1.+sine(j)**16)))
    cymax(k) = max(cymax(k),cmax*(1.+sine(j)**16))
  end do
end do
call mp_recv3d_ns( im,jm,jfirst,jlast,1,km,ng,ng,cx_tl,1 )
call mp_recv3d_ns( im,jm,jfirst,jlast,1,km,ng,ng,cx,1 )
call mp_recv2_n( im,jm,jfirst,jlast,1,km,0,1,cy_tl,mfy_tl )
call mp_recv2_n( im,jm,jfirst,jlast,1,km,0,1,cy,mfy )
call g_mp_reduce_max( km,cymax,cymax_tl )
call mp_send4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q_tm )
call mp_send4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q )
cy_global_tl = cymax_tl(1)
cy_global = cymax(1)
if (km .ne. 1) then
  do k = 2, km
    cy_global_tl = cy_global_tl*(0.5-sign(0.5d0,cymax(k)-cy_global))+cymax_tl(k)*(0.5+sign(0.5d0,cymax(k)-cy_global))
    cy_global = max(cymax(k),cy_global)
  end do
endif
nsplt = int(1.+cy_global)
frac_tl = 0.d0
frac = 1./float(nsplt)
do k = 1, km
  if (nsplt .ne. 1) then
    do j = js2gd, jn2gd
      do i = 1, im
        cx_tl(i,j,k) = cx_tl(i,j,k)*frac+frac_tl*cx(i,j,k)
        cx(i,j,k) = cx(i,j,k)*frac
      end do
    end do
    do j = js2g0, jn2g0
      do i = 1, im
        mfx_tl(i,j,k) = frac_tl*mfx(i,j,k)+mfx_tl(i,j,k)*frac
        mfx(i,j,k) = mfx(i,j,k)*frac
      end do
    end do
    do j = js2g0, jn1g1
      do i = 1, im
        cy_tl(i,j,k) = cy_tl(i,j,k)*frac+frac_tl*cy(i,j,k)
        cy(i,j,k) = cy(i,j,k)*frac
        mfy_tl(i,j,k) = frac_tl*mfy(i,j,k)+mfy_tl(i,j,k)*frac
        mfy(i,j,k) = mfy(i,j,k)*frac
      end do
    end do
  endif
  do j = js2g0, jn2g0
    do i = 1, im
      if (cy(i,j,k)*cy(i,j+1,k) .gt. 0.) then
        if (cy(i,j,k) .gt. 0.) then
          va_tl(i,j,k) = cy_tl(i,j,k)
          va(i,j,k) = cy(i,j,k)
        else
          va_tl(i,j,k) = cy_tl(i,j+1,k)
          va(i,j,k) = cy(i,j+1,k)
        endif
      else
        va_tl(i,j,k) = 0.d0
        va(i,j,k) = 0.
      endif
    end do
  end do
  do j = js2gd, jn2gd
    ffsl(j,k) =  .false. 
    do i = 1, im
      if (abs(cx(i,j,k)) .gt. 1.) then
        ffsl(j,k) =  .true. 
        exit
      endif
    end do
  end do
  do j = js2g0, jn2g0
    if (ffsl(j,k)) then
      do i = 1, im
        flx_tl(i,j,k) = (-(cx_tl(i,j,k)*(mfx(i,j,k)*(0.5+sign(0.5d0,abs(cx(i,j,k))-tiny))*sign(1.d0,cx(i,j,k))*sign(1.d0,cx(i,j,k))&
&*sign(1.d0,max(abs(cx(i,j,k)),tiny))/(sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))*sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k)))))&
&)+mfx_tl(i,j,k)/sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))
        flx(i,j,k) = mfx(i,j,k)/sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))
      end do
    else
      do i = 1, im
        flx_tl(i,j,k) = mfx_tl(i,j,k)
        flx(i,j,k) = mfx(i,j,k)
      end do
    endif
  end do
end do
do it = 1, nsplt
  if (it .ne. 1) then
    call mp_send4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q_tm )
    call mp_send4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q )
  endif
#ifdef USE_OPENMP
  !$omp parallel do private(i,j,k,sum1,sum1_tl,sum2,sum2_tl)
#endif /* ! USE_OPENMP */
  do k = 1, km
    do j = js2g0, jn2g0
      do i = 1, im-1
        dp2_tl(i,j,k) = dp1_tl(i,j,k)-mfx_tl(i+1,j,k)+mfx_tl(i,j,k)-mfy_tl(i,j+1,k)*acosp(j)+mfy_tl(i,j,k)*acosp(j)
        dp2(i,j,k) = dp1(i,j,k)+mfx(i,j,k)-mfx(i+1,j,k)+(mfy(i,j,k)-mfy(i,j+1,k))*acosp(j)
      end do
      dp2_tl(im,j,k) = dp1_tl(im,j,k)+mfx_tl(im,j,k)-mfx_tl(1,j,k)-mfy_tl(im,j+1,k)*acosp(j)+mfy_tl(im,j,k)*acosp(j)
      dp2(im,j,k) = dp1(im,j,k)+mfx(im,j,k)-mfx(1,j,k)+(mfy(im,j,k)-mfy(im,j+1,k))*acosp(j)
    end do
    if (jfirst .eq. 1) then
      sum1_tl = 0.d0
      sum1 = 0.
      do i = 1, im
        sum1_tl = mfy_tl(i,2,k)+sum1_tl
        sum1 = sum1+mfy(i,2,k)
      end do
      sum1_tl = -(sum1_tl*rcap)
      sum1 = -(sum1*rcap)
      do i = 1, im
        dp2_tl(i,1,k) = dp1_tl(i,1,k)+sum1_tl
        dp2(i,1,k) = dp1(i,1,k)+sum1
      end do
    endif
    if (jlast .eq. jm) then
      sum2_tl = 0.d0
      sum2 = 0.
      do i = 1, im
        sum2_tl = mfy_tl(i,jm,k)+sum2_tl
        sum2 = sum2+mfy(i,jm,k)
      end do
      sum2_tl = sum2_tl*rcap
      sum2 = sum2*rcap
      do i = 1, im
        dp2_tl(i,jm,k) = dp1_tl(i,jm,k)+sum2_tl
        dp2(i,jm,k) = dp1(i,jm,k)+sum2
      end do
    endif
  end do
  call mp_recv4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q_tm )
  call mp_recv4d_ns( im,jm,jfirst,jlast,1,km,nq,ng,ng,q )
#ifdef USE_OPENMP
  !$omp parallel do private(a2,a2_tl,fx,fxm_tl,fy,fym_tl,i,iq,j,k)
#endif /* ! USE_OPENMP */
  do k = 1, km
    do iq = 1, nq
      call tp2c_tl( a2,a2_tl,va(1,jfirst,k),va_tl(1,jfirst,k),q(1,jfirst-ng,k,iq),q_tm(1,jfirst-ng,k,iq),cx(1,jfirst-ng,k),cx_tl(1,&
#ifdef USE_OPENMP
&jfirst-ng,k),cy(1,jfirst,k),cy_tl(1,jfirst,k),im,jm,iord,jord,ng,fx,fxm_tl,fy,fym_tl,ffsl(1,k),rcap,acosp,flx(1,jfirst,k),&
#else /* USE_OPENMP */
&jfirst-ng,k),cy(1,jfirst,k),cy_tl(1,jfirst,k),im,jm,iord,jord,ng,fx,fxr_tl,fy,fyr_tl,ffsl(1,k),rcap,acosp,flx(1,jfirst,k),&
#endif /* USE_OPENMP */
&flx_tl(1,jfirst,k),mfy(1,jfirst,k),mfy_tl(1,jfirst,k),cosp,1,jfirst,jlast )
      do j = jfirst, jlast
        do i = 1, im
          q_tm(i,j,k,iq) = a2_tl(i,j)+dp1_tl(i,j,k)*q(i,j,k,iq)+q_tm(i,j,k,iq)*dp1(i,j,k)
          q(i,j,k,iq) = q(i,j,k,iq)*dp1(i,j,k)+a2(i,j)
        end do
      end do
      if (fill) then
        call fillxy_tl( q(1,jfirst,k,iq),q_tm(1,jfirst,k,iq),im,jm,jfirst,jlast,acap,cosp )
      endif
      do j = jfirst, jlast
        do i = 1, im
          q_tm(i,j,k,iq) = (-(dp2_tl(i,j,k)*(q(i,j,k,iq)/(dp2(i,j,k)*dp2(i,j,k)))))+q_tm(i,j,k,iq)/dp2(i,j,k)
          q(i,j,k,iq) = q(i,j,k,iq)/dp2(i,j,k)
        end do
      end do
    end do
    if (it .ne. nsplt) then
      do j = jfirst, jlast
        do i = 1, im
          dp1_tl(i,j,k) = dp2_tl(i,j,k)
          dp1(i,j,k) = dp2(i,j,k)
        end do
      end do
    endif
  end do
end do

end subroutine trac2d_tl


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
subroutine trac2d_tl( dp1, dp1_tl, q, q_tm, nq, cx, cx_tl, cy, cy_tl, mfx, mfx_tl, mfy, mfy_tl, iord, jord, ng, sine, cosp, acosp, &
&acap, rcap, fill, im, jm, km, jfirst, jlast, va, va_tl, flx, flx_tl, trac2d_tape_rec )
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
use tp_core
use tp_core_tl
use fill_module
use fill_module_tl

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare parameters
!==============================================
real(kind=r8), parameter :: tiny = 1.e-10

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
integer :: km
integer :: ng
real(kind=r8) :: cx(im,jfirst-ng:jlast+ng,km)
real(kind=r8) :: cx_tl(im,jfirst-ng:jlast+ng,km)
real(kind=r8) :: cy(im,jfirst:jlast+1,km)
real(kind=r8) :: cy_tl(im,jfirst:jlast+1,km)
real(kind=r8) :: dp1(im,jfirst:jlast,km)
real(kind=r8) :: dp1_tl(im,jfirst:jlast,km)
logical :: fill
real(kind=r8) :: flx(im,jfirst:jlast,km)
real(kind=r8) :: flx_tl(im,jfirst:jlast,km)
integer :: iord
integer :: jord
real(kind=r8) :: mfx(im,jfirst:jlast,km)
real(kind=r8) :: mfx_tl(im,jfirst:jlast,km)
real(kind=r8) :: mfy(im,jfirst:jlast+1,km)
real(kind=r8) :: mfy_tl(im,jfirst:jlast+1,km)
integer :: nq
real(kind=r8) :: q(im,jfirst-ng:jlast+ng,km,nq)
real(kind=r8) :: q_tm(im,jfirst-ng:jlast+ng,km,nq)
real(kind=r8) :: rcap
real(kind=r8) :: sine(jm)
integer :: trac2d_tape_rec
real(kind=r8) :: va(im,jfirst:jlast,km)
real(kind=r8) :: va_tl(im,jfirst:jlast,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: a2(im,jfirst:jlast)
real(kind=r8) :: a2_tl(im,jfirst:jlast)
real(kind=r8) :: cmax
real(kind=r8) :: cmax_tl
real(kind=r8) :: cy_global
real(kind=r8) :: cy_global_tl
real(kind=r8) :: cymax(km)
real(kind=r8) :: cymax_tl(km)
real(kind=r8) :: dp2(im,jfirst:jlast,km)
real(kind=r8) :: dp2_tl(im,jfirst:jlast,km)
logical :: ffsl(jm,km)
real(kind=r8) :: frac
real(kind=r8) :: frac_tl
real(kind=r8) :: fx(im,jfirst:jlast)
#ifdef USE_OPENMP
real(kind=r8) :: fxm_tl(im,1+jlast-jfirst)
#else /* USE_OPENMP */
real(kind=r8) :: fxr_tl(im,1+jlast-jfirst)
#endif /* USE_OPENMP */
real(kind=r8) :: fy(im,jfirst:jlast+1)
#ifdef USE_OPENMP
real(kind=r8) :: fym_tl(im,1+1+jlast-jfirst)
#else /* USE_OPENMP */
real(kind=r8) :: fyr_tl(im,1+1+jlast-jfirst)
#endif /* USE_OPENMP */
integer :: i
integer :: iq
integer :: it
integer :: j
integer :: jn1g1
integer :: jn2g0
integer :: jn2gd
integer :: js2g0
integer :: js2gd
integer :: k
integer :: nsplt
real(kind=r8) :: sum1
real(kind=r8) :: sum1_tl
real(kind=r8) :: sum2
real(kind=r8) :: sum2_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
js2g0 = max(2,jfirst)
jn2g0 = min(jm-1,jlast)
jn1g1 = min(jm,jlast+1)
js2gd = max(2,jfirst-ng)
jn2gd = min(jm-1,jlast+ng)
#ifdef USE_OPENMP
!$omp parallel do private(cmax,cmax_tl,i,j,k)
#endif /* ! USE_OPENMP */
do k = 1, km
  cymax_tl(k) = 0.d0
  cymax(k) = 0.
  do j = js2g0, jlast
    cmax_tl = 0.d0
    cmax = 0.
    do i = 1, im
      cmax_tl = cmax_tl*(0.5-sign(0.5d0,abs(cy(i,j,k))-cmax))+cy_tl(i,j,k)*(0.5+sign(0.5d0,abs(cy(i,j,k))-cmax))*sign(1.d0,cy(i,j,&
&k))
      cmax = max(abs(cy(i,j,k)),cmax)
    end do
    cymax_tl(k) = cmax_tl*(0.5-sign(0.5d0,cymax(k)-cmax*(1.+sine(j)**16)))*(1+sine(j)**16)+cymax_tl(k)*(0.5+sign(0.5d0,cymax(k)-&
&cmax*(1.+sine(j)**16)))
    cymax(k) = max(cymax(k),cmax*(1.+sine(j)**16))
  end do
end do
cy_global_tl = cymax_tl(1)
cy_global = cymax(1)
if (km .ne. 1) then
  do k = 2, km
    cy_global_tl = cy_global_tl*(0.5-sign(0.5d0,cymax(k)-cy_global))+cymax_tl(k)*(0.5+sign(0.5d0,cymax(k)-cy_global))
    cy_global = max(cymax(k),cy_global)
  end do
endif
nsplt = int(1.+cy_global)
frac_tl = 0.d0
frac = 1./float(nsplt)
do k = 1, km
  if (nsplt .ne. 1) then
    do j = js2gd, jn2gd
      do i = 1, im
        cx_tl(i,j,k) = cx_tl(i,j,k)*frac+frac_tl*cx(i,j,k)
        cx(i,j,k) = cx(i,j,k)*frac
      end do
    end do
    do j = js2g0, jn2g0
      do i = 1, im
        mfx_tl(i,j,k) = frac_tl*mfx(i,j,k)+mfx_tl(i,j,k)*frac
        mfx(i,j,k) = mfx(i,j,k)*frac
      end do
    end do
    do j = js2g0, jn1g1
      do i = 1, im
        cy_tl(i,j,k) = cy_tl(i,j,k)*frac+frac_tl*cy(i,j,k)
        cy(i,j,k) = cy(i,j,k)*frac
        mfy_tl(i,j,k) = frac_tl*mfy(i,j,k)+mfy_tl(i,j,k)*frac
        mfy(i,j,k) = mfy(i,j,k)*frac
      end do
    end do
  endif
  do j = js2g0, jn2g0
    do i = 1, im
      if (cy(i,j,k)*cy(i,j+1,k) .gt. 0.) then
        if (cy(i,j,k) .gt. 0.) then
          va_tl(i,j,k) = cy_tl(i,j,k)
          va(i,j,k) = cy(i,j,k)
        else
          va_tl(i,j,k) = cy_tl(i,j+1,k)
          va(i,j,k) = cy(i,j+1,k)
        endif
      else
        va_tl(i,j,k) = 0.d0
        va(i,j,k) = 0.
      endif
    end do
  end do
  do j = js2gd, jn2gd
    ffsl(j,k) =  .false. 
    do i = 1, im
      if (abs(cx(i,j,k)) .gt. 1.) then
        ffsl(j,k) =  .true. 
        exit
      endif
    end do
  end do
  do j = js2g0, jn2g0
    if (ffsl(j,k)) then
      do i = 1, im
        flx_tl(i,j,k) = (-(cx_tl(i,j,k)*(mfx(i,j,k)*(0.5+sign(0.5d0,abs(cx(i,j,k))-tiny))*sign(1.d0,cx(i,j,k))*sign(1.d0,cx(i,j,k))&
&*sign(1.d0,max(abs(cx(i,j,k)),tiny))/(sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))*sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k)))))&
&)+mfx_tl(i,j,k)/sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))
        flx(i,j,k) = mfx(i,j,k)/sign(max(abs(cx(i,j,k)),tiny),cx(i,j,k))
      end do
    else
      do i = 1, im
        flx_tl(i,j,k) = mfx_tl(i,j,k)
        flx(i,j,k) = mfx(i,j,k)
      end do
    endif
  end do
end do
do it = 1, nsplt
#ifdef USE_OPENMP
  !$omp parallel do private(i,j,k,sum1,sum1_tl,sum2,sum2_tl)
#endif /* ! USE_OPENMP */
  do k = 1, km
    do j = js2g0, jn2g0
      do i = 1, im-1
        dp2_tl(i,j,k) = dp1_tl(i,j,k)-mfx_tl(i+1,j,k)+mfx_tl(i,j,k)-mfy_tl(i,j+1,k)*acosp(j)+mfy_tl(i,j,k)*acosp(j)
        dp2(i,j,k) = dp1(i,j,k)+mfx(i,j,k)-mfx(i+1,j,k)+(mfy(i,j,k)-mfy(i,j+1,k))*acosp(j)
      end do
      dp2_tl(im,j,k) = dp1_tl(im,j,k)+mfx_tl(im,j,k)-mfx_tl(1,j,k)-mfy_tl(im,j+1,k)*acosp(j)+mfy_tl(im,j,k)*acosp(j)
      dp2(im,j,k) = dp1(im,j,k)+mfx(im,j,k)-mfx(1,j,k)+(mfy(im,j,k)-mfy(im,j+1,k))*acosp(j)
    end do
    if (jfirst .eq. 1) then
      sum1_tl = 0.d0
      sum1 = 0.
      do i = 1, im
        sum1_tl = mfy_tl(i,2,k)+sum1_tl
        sum1 = sum1+mfy(i,2,k)
      end do
      sum1_tl = -(sum1_tl*rcap)
      sum1 = -(sum1*rcap)
      do i = 1, im
        dp2_tl(i,1,k) = dp1_tl(i,1,k)+sum1_tl
        dp2(i,1,k) = dp1(i,1,k)+sum1
      end do
    endif
    if (jlast .eq. jm) then
      sum2_tl = 0.d0
      sum2 = 0.
      do i = 1, im
        sum2_tl = mfy_tl(i,jm,k)+sum2_tl
        sum2 = sum2+mfy(i,jm,k)
      end do
      sum2_tl = sum2_tl*rcap
      sum2 = sum2*rcap
      do i = 1, im
        dp2_tl(i,jm,k) = dp1_tl(i,jm,k)+sum2_tl
        dp2(i,jm,k) = dp1(i,jm,k)+sum2
      end do
    endif
  end do
#ifdef USE_OPENMP
  !$omp parallel do private(a2,a2_tl,fx,fxm_tl,fy,fym_tl,i,iq,j,k)
#endif /* ! USE_OPENMP */
  do k = 1, km
    do iq = 1, nq
      call tp2c_tl( a2,a2_tl,va(1,jfirst,k),va_tl(1,jfirst,k),q(1,jfirst-ng,k,iq),q_tm(1,jfirst-ng,k,iq),cx(1,jfirst-ng,k),cx_tl(1,&
#ifdef USE_OPENMP
&jfirst-ng,k),cy(1,jfirst,k),cy_tl(1,jfirst,k),im,jm,iord,jord,ng,fx,fxm_tl,fy,fym_tl,ffsl(1,k),rcap,acosp,flx(1,jfirst,k),&
#else /* USE_OPENMP */
&jfirst-ng,k),cy(1,jfirst,k),cy_tl(1,jfirst,k),im,jm,iord,jord,ng,fx,fxr_tl,fy,fyr_tl,ffsl(1,k),rcap,acosp,flx(1,jfirst,k),&
#endif /* USE_OPENMP */
&flx_tl(1,jfirst,k),mfy(1,jfirst,k),mfy_tl(1,jfirst,k),cosp,1,jfirst,jlast )
      do j = jfirst, jlast
        do i = 1, im
          q_tm(i,j,k,iq) = a2_tl(i,j)+dp1_tl(i,j,k)*q(i,j,k,iq)+q_tm(i,j,k,iq)*dp1(i,j,k)
          q(i,j,k,iq) = q(i,j,k,iq)*dp1(i,j,k)+a2(i,j)
        end do
      end do
      if (fill) then
        call fillxy_tl( q(1,jfirst,k,iq),q_tm(1,jfirst,k,iq),im,jm,jfirst,jlast,acap,cosp )
      endif
      do j = jfirst, jlast
        do i = 1, im
          q_tm(i,j,k,iq) = (-(dp2_tl(i,j,k)*(q(i,j,k,iq)/(dp2(i,j,k)*dp2(i,j,k)))))+q_tm(i,j,k,iq)/dp2(i,j,k)
          q(i,j,k,iq) = q(i,j,k,iq)/dp2(i,j,k)
        end do
      end do
    end do
    if (it .ne. nsplt) then
      do j = jfirst, jlast
        do i = 1, im
          dp1_tl(i,j,k) = dp2_tl(i,j,k)
          dp1(i,j,k) = dp2(i,j,k)
        end do
      end do
    endif
  end do
end do

end subroutine trac2d_tl


#endif /* SPMD */
