#include <params.h>
      subroutine pbinti(gravx)
C-----------------------------------------------------------------------
C
C Initialize time independent variables of pbl package.
C
C---------------------------Code history--------------------------------
C
C Original version:  B. Boville
C Standardized:      J. Rosinski, June 1992
C Reviewed:          B. Boville, P. Rasch, August 1992
C Reviewed:          B. Boville, P. Rasch, April 1996
C
C-----------------------------------------------------------------------
c
c $Id$
c $Author$
c
#include <implicit.h>
C------------------------------Commons----------------------------------
#include <compbl.h>
C------------------------------Arguments--------------------------------
C
C Input arguments
C
      real gravx     !  acceleration of gravity
C
C Basic constants
C
      g    = gravx
      onet = 1./3.
C
C Derived constants
C
      ccon = fak*sffrac*vk
      binm = betam*sffrac
      binh = betah*sffrac
C
      return
      end
 
