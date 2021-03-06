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
module     benergy_tl
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
use benergy

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine benergy_do_tl( im, jm, km, u, u_tm, v, v_tm, pt, pt_tm, delp, delp_tm, pe, pe_tm, pk, pk_tm, pkz, pkz_tm, phis, ng_d, &
&ng_s, cp, te0, te0_tl, te, te_tl, dz, dz_tl, jfirst, jlast )
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
use mod_comm, only : mp_barrier, mp_recv_n, mp_send_s

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

!==============================================
! declare arguments
!==============================================
real(kind=r8) :: cp
integer :: im
integer :: jfirst
integer :: jlast
integer :: km
real(kind=r8) :: delp(im,jfirst:jlast,km)
real(kind=r8) :: delp_tm(im,jfirst:jlast,km)
real(kind=r8) :: dz(im,jfirst:jlast,km)
real(kind=r8) :: dz_tl(im,jfirst:jlast,km)
integer :: jm
integer :: ng_d
integer :: ng_s
real(kind=r8) :: pe(im,km+1,jfirst:jlast)
real(kind=r8) :: pe_tm(im,km+1,jfirst:jlast)
real(kind=r8) :: phis(im,jfirst:jlast)
real(kind=r8) :: pk(im,jfirst:jlast,km+1)
real(kind=r8) :: pk_tm(im,jfirst:jlast,km+1)
real(kind=r8) :: pkz(im,jfirst:jlast,km)
real(kind=r8) :: pkz_tm(im,jfirst:jlast,km)
real(kind=r8) :: pt(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8) :: pt_tm(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8) :: te(im,jfirst:jlast,km)
real(kind=r8) :: te0
real(kind=r8) :: te0_tl
real(kind=r8) :: te_tl(im,jfirst:jlast,km)
real(kind=r8) :: u(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: u_tm(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: v(im,jfirst-ng_s:jlast+ng_d,km)
real(kind=r8) :: v_tm(im,jfirst-ng_s:jlast+ng_d,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: bte(im)
real(kind=r8) :: bte_tl(im)
real(kind=r8) :: gztop(im)
real(kind=r8) :: gztop_tl(im)
integer :: i
integer :: j
integer :: jn2g0
integer :: js2g0
integer :: k
real(kind=r8) :: te_np
real(kind=r8) :: te_np_tl
real(kind=r8) :: te_sp
real(kind=r8) :: te_sp_tl
real(kind=r8) :: tte(jfirst:jlast)
real(kind=r8) :: tte_tl(jfirst:jlast)
real(kind=r8) :: u2(im,jfirst:jlast+1)
real(kind=r8) :: u2_tl(im,jfirst:jlast+1)
real(kind=r8) :: v2(im,jfirst:jlast)
real(kind=r8) :: v2_tl(im,jfirst:jlast)
real(kind=r8) :: xsum
real(kind=r8) :: xsum_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
js2g0 = max(2,jfirst)
jn2g0 = min(jm-1,jlast)
call mp_send_s( im,jm,jfirst,jlast,1,km,ng_d,ng_s,u_tm )
call mp_send_s( im,jm,jfirst,jlast,1,km,ng_d,ng_s,u )
call mp_recv_n( im,jm,jfirst,jlast,1,km,ng_d,ng_s,u_tm )
call mp_recv_n( im,jm,jfirst,jlast,1,km,ng_d,ng_s,u )
#ifdef USE_OPENMP
!$omp parallel do private(i,j,k,te_np,te_np_tl,te_sp,te_sp_tl,u2,u2_tl,v2,v2_tl)
#endif /* ! USE_OPENMP */
do k = 1, km
  do j = js2g0, min(jlast+1,jm)
    do i = 1, im
      u2_tl(i,j) = 2*u_tm(i,j,k)*u(i,j,k)
      u2(i,j) = u(i,j,k)**2
    end do
  end do
  do j = js2g0, jn2g0
    do i = 1, im
      v2_tl(i,j) = 2*v_tm(i,j,k)*v(i,j,k)
      v2(i,j) = v(i,j,k)**2
    end do
  end do
  do j = js2g0, jn2g0
    do i = 1, im-1
      te_tl(i,j,k) = 0.25*u2_tl(i,j+1)+0.25*u2_tl(i,j)+0.25*v2_tl(i+1,j)+0.25*v2_tl(i,j)
      te(i,j,k) = 0.25*(u2(i,j)+u2(i,j+1)+v2(i,j)+v2(i+1,j))
    end do
    te_tl(im,j,k) = 0.25*u2_tl(im,j+1)+0.25*u2_tl(im,j)+0.25*v2_tl(im,j)+0.25*v2_tl(1,j)
    te(im,j,k) = 0.25*(u2(im,j)+u2(im,j+1)+v2(im,j)+v2(1,j))
  end do
  do j = js2g0, jn2g0
    do i = 1, im
      te_tl(i,j,k) = delp_tm(i,j,k)*(te(i,j,k)+cp*pt(i,j,k)*pkz(i,j,k))+pkz_tm(i,j,k)*delp(i,j,k)*cp*pt(i,j,k)+pt_tm(i,j,k)*delp(i,&
&j,k)*cp*pkz(i,j,k)+te_tl(i,j,k)*delp(i,j,k)
      te(i,j,k) = delp(i,j,k)*(te(i,j,k)+cp*pt(i,j,k)*pkz(i,j,k))
    end do
  end do
  if (jfirst .eq. 1) then
    te_sp_tl = 0.d0
    te_sp = 0.
    do i = 1, im
      te_sp_tl = te_sp_tl+u2_tl(i,2)+v2_tl(i,2)
      te_sp = te_sp+u2(i,2)+v2(i,2)
    end do
    te_sp_tl = delp_tm(1,1,k)*(0.5*te_sp/float(im)+cp*pt(1,1,k)*pkz(1,1,k))+pkz_tm(1,1,k)*delp(1,1,k)*cp*pt(1,1,k)+pt_tm(1,1,k)*&
&delp(1,1,k)*cp*pkz(1,1,k)+te_sp_tl*delp(1,1,k)*(0.5/float(im))
    te_sp = delp(1,1,k)*(0.5*te_sp/float(im)+cp*pt(1,1,k)*pkz(1,1,k))
    do i = 1, im
      te_tl(i,1,k) = te_sp_tl
      te(i,1,k) = te_sp
    end do
  endif
  if (jlast .eq. jm) then
    te_np_tl = 0.d0
    te_np = 0.
    do i = 1, im
      te_np_tl = te_np_tl+u2_tl(i,jm)+v2_tl(i,jm-1)
      te_np = te_np+u2(i,jm)+v2(i,jm-1)
    end do
    te_np_tl = delp_tm(1,jm,k)*(0.5*te_np/float(im)+cp*pt(1,jm,k)*pkz(1,jm,k))+pkz_tm(1,jm,k)*delp(1,jm,k)*cp*pt(1,jm,k)+pt_tm(1,&
&jm,k)*delp(1,jm,k)*cp*pkz(1,jm,k)+te_np_tl*delp(1,jm,k)*(0.5/float(im))
    te_np = delp(1,jm,k)*(0.5*te_np/float(im)+cp*pt(1,jm,k)*pkz(1,jm,k))
    do i = 1, im
      te_tl(i,jm,k) = te_np_tl
      te(i,jm,k) = te_np
    end do
  endif
  do j = jfirst, jlast
    do i = 1, im
      dz_tl(i,j,k) = pk_tm(i,j,k+1)*cp*pt(i,j,k)-pk_tm(i,j,k)*cp*pt(i,j,k)+pt_tm(i,j,k)*cp*(pk(i,j,k+1)-pk(i,j,k))
      dz(i,j,k) = cp*pt(i,j,k)*(pk(i,j,k+1)-pk(i,j,k))
    end do
  end do
end do
#ifdef USE_OPENMP
!$omp parallel do private(bte,bte_tl,gztop,gztop_tl,i,j,k,xsum,xsum_tl)
#endif /* ! USE_OPENMP */
do j = jfirst, jlast
  do i = 1, im
    gztop_tl(i) = 0.d0
    gztop(i) = phis(i,j)
    do k = 1, km
      gztop_tl(i) = dz_tl(i,j,k)+gztop_tl(i)
      gztop(i) = gztop(i)+dz(i,j,k)
    end do
  end do
  if (j .eq. 1) then
    tte_tl(1) = (-(gztop_tl(1)*pe(1,1,1)))+pe_tm(1,km+1,1)*phis(1,1)-pe_tm(1,1,1)*gztop(1)
    tte(1) = pe(1,km+1,1)*phis(1,1)-pe(1,1,1)*gztop(1)
    do k = 1, km
      tte_tl(1) = te_tl(1,1,k)+tte_tl(1)
      tte(1) = tte(1)+te(1,1,k)
    end do
    tte_tl(1) = tte_tl(1)*acap
    tte(1) = acap*tte(1)
  else if (j .eq. jm) then
    tte_tl(jm) = (-(gztop_tl(1)*pe(1,1,jm)))+pe_tm(1,km+1,jm)*phis(1,jm)-pe_tm(1,1,jm)*gztop(1)
    tte(jm) = pe(1,km+1,jm)*phis(1,jm)-pe(1,1,jm)*gztop(1)
    do k = 1, km
      tte_tl(jm) = te_tl(1,jm,k)+tte_tl(jm)
      tte(jm) = tte(jm)+te(1,jm,k)
    end do
    tte_tl(jm) = tte_tl(jm)*acap
    tte(jm) = acap*tte(jm)
  else
    do i = 1, im
      bte_tl(i) = (-(gztop_tl(i)*pe(i,1,j)))+pe_tm(i,km+1,j)*phis(i,j)-pe_tm(i,1,j)*gztop(i)
      bte(i) = pe(i,km+1,j)*phis(i,j)-pe(i,1,j)*gztop(i)
    end do
    do k = 1, km
      do i = 1, im
        bte_tl(i) = bte_tl(i)+te_tl(i,j,k)
        bte(i) = bte(i)+te(i,j,k)
      end do
    end do
    xsum_tl = 0.d0
    xsum = 0.
    do i = 1, im
      xsum_tl = bte_tl(i)+xsum_tl
      xsum = xsum+bte(i)
    end do
    tte_tl(j) = xsum_tl*cosp(j)
    tte(j) = xsum*cosp(j)
  endif
end do
call par_vecsum_tl( jm,jfirst,jlast,tte,tte_tl,te0,te0_tl )

end subroutine benergy_do_tl


end module     benergy_tl


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
module     benergy_tl
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
use benergy

!==============================================
! all entries are defined explicitly
!==============================================
implicit none

contains
subroutine benergy_do_tl( im, jm, km, u, u_tm, v, v_tm, pt, pt_tm, delp, delp_tm, pe, pe_tm, pk, pk_tm, pkz, pkz_tm, phis, ng_d, &
&ng_s, cp, te0, te0_tl, te, te_tl, dz, dz_tl, jfirst, jlast )
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
real(kind=r8) :: cp
integer :: im
integer :: jfirst
integer :: jlast
integer :: km
real(kind=r8) :: delp(im,jfirst:jlast,km)
real(kind=r8) :: delp_tm(im,jfirst:jlast,km)
real(kind=r8) :: dz(im,jfirst:jlast,km)
real(kind=r8) :: dz_tl(im,jfirst:jlast,km)
integer :: jm
integer :: ng_d
integer :: ng_s
real(kind=r8) :: pe(im,km+1,jfirst:jlast)
real(kind=r8) :: pe_tm(im,km+1,jfirst:jlast)
real(kind=r8) :: phis(im,jfirst:jlast)
real(kind=r8) :: pk(im,jfirst:jlast,km+1)
real(kind=r8) :: pk_tm(im,jfirst:jlast,km+1)
real(kind=r8) :: pkz(im,jfirst:jlast,km)
real(kind=r8) :: pkz_tm(im,jfirst:jlast,km)
real(kind=r8) :: pt(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8) :: pt_tm(im,jfirst-ng_d:jlast+ng_d,km)
real(kind=r8) :: te(im,jfirst:jlast,km)
real(kind=r8) :: te0
real(kind=r8) :: te0_tl
real(kind=r8) :: te_tl(im,jfirst:jlast,km)
real(kind=r8) :: u(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: u_tm(im,jfirst-ng_d:jlast+ng_s,km)
real(kind=r8) :: v(im,jfirst-ng_s:jlast+ng_d,km)
real(kind=r8) :: v_tm(im,jfirst-ng_s:jlast+ng_d,km)

!==============================================
! declare local variables
!==============================================
real(kind=r8) :: bte(im)
real(kind=r8) :: bte_tl(im)
real(kind=r8) :: gztop(im)
real(kind=r8) :: gztop_tl(im)
integer :: i
integer :: j
integer :: jn2g0
integer :: js2g0
integer :: k
real(kind=r8) :: te_np
real(kind=r8) :: te_np_tl
real(kind=r8) :: te_sp
real(kind=r8) :: te_sp_tl
real(kind=r8) :: tte(jfirst:jlast)
real(kind=r8) :: tte_tl(jfirst:jlast)
real(kind=r8) :: u2(im,jfirst:jlast+1)
real(kind=r8) :: u2_tl(im,jfirst:jlast+1)
real(kind=r8) :: v2(im,jfirst:jlast)
real(kind=r8) :: v2_tl(im,jfirst:jlast)
real(kind=r8) :: xsum
real(kind=r8) :: xsum_tl

!----------------------------------------------
! TANGENT LINEAR AND FUNCTION STATEMENTS
!----------------------------------------------
js2g0 = max(2,jfirst)
jn2g0 = min(jm-1,jlast)
#ifdef USE_OPENMP
!$omp parallel do private(i,j,k,te_np,te_np_tl,te_sp,te_sp_tl,u2,u2_tl,v2,v2_tl)
#endif /* ! USE_OPENMP */
do k = 1, km
  do j = js2g0, min(jlast+1,jm)
    do i = 1, im
      u2_tl(i,j) = 2*u_tm(i,j,k)*u(i,j,k)
      u2(i,j) = u(i,j,k)**2
    end do
  end do
  do j = js2g0, jn2g0
    do i = 1, im
      v2_tl(i,j) = 2*v_tm(i,j,k)*v(i,j,k)
      v2(i,j) = v(i,j,k)**2
    end do
  end do
  do j = js2g0, jn2g0
    do i = 1, im-1
      te_tl(i,j,k) = 0.25*u2_tl(i,j+1)+0.25*u2_tl(i,j)+0.25*v2_tl(i+1,j)+0.25*v2_tl(i,j)
      te(i,j,k) = 0.25*(u2(i,j)+u2(i,j+1)+v2(i,j)+v2(i+1,j))
    end do
    te_tl(im,j,k) = 0.25*u2_tl(im,j+1)+0.25*u2_tl(im,j)+0.25*v2_tl(im,j)+0.25*v2_tl(1,j)
    te(im,j,k) = 0.25*(u2(im,j)+u2(im,j+1)+v2(im,j)+v2(1,j))
  end do
  do j = js2g0, jn2g0
    do i = 1, im
      te_tl(i,j,k) = delp_tm(i,j,k)*(te(i,j,k)+cp*pt(i,j,k)*pkz(i,j,k))+pkz_tm(i,j,k)*delp(i,j,k)*cp*pt(i,j,k)+pt_tm(i,j,k)*delp(i,&
&j,k)*cp*pkz(i,j,k)+te_tl(i,j,k)*delp(i,j,k)
      te(i,j,k) = delp(i,j,k)*(te(i,j,k)+cp*pt(i,j,k)*pkz(i,j,k))
    end do
  end do
  if (jfirst .eq. 1) then
    te_sp_tl = 0.d0
    te_sp = 0.
    do i = 1, im
      te_sp_tl = te_sp_tl+u2_tl(i,2)+v2_tl(i,2)
      te_sp = te_sp+u2(i,2)+v2(i,2)
    end do
    te_sp_tl = delp_tm(1,1,k)*(0.5*te_sp/float(im)+cp*pt(1,1,k)*pkz(1,1,k))+pkz_tm(1,1,k)*delp(1,1,k)*cp*pt(1,1,k)+pt_tm(1,1,k)*&
&delp(1,1,k)*cp*pkz(1,1,k)+te_sp_tl*delp(1,1,k)*(0.5/float(im))
    te_sp = delp(1,1,k)*(0.5*te_sp/float(im)+cp*pt(1,1,k)*pkz(1,1,k))
    do i = 1, im
      te_tl(i,1,k) = te_sp_tl
      te(i,1,k) = te_sp
    end do
  endif
  if (jlast .eq. jm) then
    te_np_tl = 0.d0
    te_np = 0.
    do i = 1, im
      te_np_tl = te_np_tl+u2_tl(i,jm)+v2_tl(i,jm-1)
      te_np = te_np+u2(i,jm)+v2(i,jm-1)
    end do
    te_np_tl = delp_tm(1,jm,k)*(0.5*te_np/float(im)+cp*pt(1,jm,k)*pkz(1,jm,k))+pkz_tm(1,jm,k)*delp(1,jm,k)*cp*pt(1,jm,k)+pt_tm(1,&
&jm,k)*delp(1,jm,k)*cp*pkz(1,jm,k)+te_np_tl*delp(1,jm,k)*(0.5/float(im))
    te_np = delp(1,jm,k)*(0.5*te_np/float(im)+cp*pt(1,jm,k)*pkz(1,jm,k))
    do i = 1, im
      te_tl(i,jm,k) = te_np_tl
      te(i,jm,k) = te_np
    end do
  endif
  do j = jfirst, jlast
    do i = 1, im
      dz_tl(i,j,k) = pk_tm(i,j,k+1)*cp*pt(i,j,k)-pk_tm(i,j,k)*cp*pt(i,j,k)+pt_tm(i,j,k)*cp*(pk(i,j,k+1)-pk(i,j,k))
      dz(i,j,k) = cp*pt(i,j,k)*(pk(i,j,k+1)-pk(i,j,k))
    end do
  end do
end do
#ifdef USE_OPENMP
!$omp parallel do private(bte,bte_tl,gztop,gztop_tl,i,j,k,xsum,xsum_tl)
#endif /* ! USE_OPENMP */
do j = jfirst, jlast
  do i = 1, im
    gztop_tl(i) = 0.d0
    gztop(i) = phis(i,j)
    do k = 1, km
      gztop_tl(i) = dz_tl(i,j,k)+gztop_tl(i)
      gztop(i) = gztop(i)+dz(i,j,k)
    end do
  end do
  if (j .eq. 1) then
    tte_tl(1) = (-(gztop_tl(1)*pe(1,1,1)))+pe_tm(1,km+1,1)*phis(1,1)-pe_tm(1,1,1)*gztop(1)
    tte(1) = pe(1,km+1,1)*phis(1,1)-pe(1,1,1)*gztop(1)
    do k = 1, km
      tte_tl(1) = te_tl(1,1,k)+tte_tl(1)
      tte(1) = tte(1)+te(1,1,k)
    end do
    tte_tl(1) = tte_tl(1)*acap
    tte(1) = acap*tte(1)
  else if (j .eq. jm) then
    tte_tl(jm) = (-(gztop_tl(1)*pe(1,1,jm)))+pe_tm(1,km+1,jm)*phis(1,jm)-pe_tm(1,1,jm)*gztop(1)
    tte(jm) = pe(1,km+1,jm)*phis(1,jm)-pe(1,1,jm)*gztop(1)
    do k = 1, km
      tte_tl(jm) = te_tl(1,jm,k)+tte_tl(jm)
      tte(jm) = tte(jm)+te(1,jm,k)
    end do
    tte_tl(jm) = tte_tl(jm)*acap
    tte(jm) = acap*tte(jm)
  else
    do i = 1, im
      bte_tl(i) = (-(gztop_tl(i)*pe(i,1,j)))+pe_tm(i,km+1,j)*phis(i,j)-pe_tm(i,1,j)*gztop(i)
      bte(i) = pe(i,km+1,j)*phis(i,j)-pe(i,1,j)*gztop(i)
    end do
    do k = 1, km
      do i = 1, im
        bte_tl(i) = bte_tl(i)+te_tl(i,j,k)
        bte(i) = bte(i)+te(i,j,k)
      end do
    end do
    xsum_tl = 0.d0
    xsum = 0.
    do i = 1, im
      xsum_tl = bte_tl(i)+xsum_tl
      xsum = xsum+bte(i)
    end do
    tte_tl(j) = xsum_tl*cosp(j)
    tte(j) = xsum*cosp(j)
  endif
end do
call par_vecsum_tl( jm,jfirst,jlast,tte,tte_tl,te0,te0_tl )

end subroutine benergy_do_tl


end module     benergy_tl


#endif /* SPMD */
