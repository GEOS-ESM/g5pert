* ------------------------ code history ---------------------------
* source file:       lsmtv.h
* purpose:           lsmtv common block for time-varying (restart) variables
* date last revised: March 1996 - lsm version 1
* author:            Gordon Bonan
* standardized:      J. Truesdale, Feb 1996
* reviewed:          G. Bonan, Feb 1996
* -----------------------------------------------------------------

* main land surface variables needed for restart

      real h2osno(kpt)      !snow water (mm h2o / m**2)
      real h2ocan(kpt)      !canopy water (mm h2o / m**2)
      real h2osoi(msl,kpt)  !volumetric soil water content (0<=h2osoi<=watsat)
      real tv(kpt)          !vegetation temperature (kelvin)
      real tg(kpt)          !ground temperature (kelvin)
      real tsoi(msl,kpt)    !soil temperature (kelvin)
      real moz(kpt)         !monon-obukhov stability parameter
      real eah(kpt)         !canopy air vapor pressure (pa)
      real soot(kpt)        !soot content of snow
      real hsno(kpt)        !snow height (m)
      real fsno(kpt)        !fraction of ground covered with snow (0 to 1)
      real fwet(kpt)        !fraction of canopy that is wet (0 to 1)

      common /lsmtv_r/ h2osno ,h2ocan ,h2osoi ,tv   ,tg   ,tsoi ,
     &                 moz    ,eah    ,soot   ,hsno ,fsno ,fwet

* vegetation for next time step

      real htop(kpt)        !vegetation height, top (m)
      real tlai(kpt)        !total leaf area index, one-sided
      real tsai(kpt)        !total stem area index, one-sided
      real elai(kpt)        !exposed leaf area index, one-sided
      real esai(kpt)        !exposed stem area index, one-sided
      real foln(kpt)        !foliage nitrogen (%)
      real stemb(kpt)       !stem biomass (kg /m**2)
      real rootb(kpt)       !root biomass (kg /m**2)
      real soilc(kpt)       !soil carbon (kg c /m**2)
      real igs(kpt)         !growing season index (0=off, 1=on)

      common /lsmtv_r/ htop ,tlai  ,tsai  ,elai  ,esai , 
     &                 foln ,stemb ,rootb ,soilc ,igs    

* albedo calculation for next time step 
 
      real albd(mband,kpt)     !surface albedo (direct)
      real albi(mband,kpt)     !surface albedo (diffuse)
      real albgrd(mband,kpt)   !ground albedo (direct)
      real albgri(mband,kpt)   !ground albedo (diffuse)
      real fabd(mband,kpt)     !flux absorbed by veg (per unit direct flux) 
      real fabi(mband,kpt)     !flux absorbed by veg (per unit diffuse flux) 
      real ftdd(mband,kpt)     !down direct flux below veg (per unit dir flux) 
      real ftid(mband,kpt)     !down diffuse flux below veg (per unit dir flux) 
      real ftii(mband,kpt)     !down diffuse flux below veg (per unit dif flux) 
      real fsun(kpt)           !sunlit fraction of canopy

      common /lsmtv_r/ albd ,albi ,albgrd ,albgri ,fabd ,
     &                 fabi ,ftdd ,ftid   ,ftii   ,fsun    

* need to save a total of [mlsf] single-level lsm variables for 
* [kpt] points from one time step to next. equivalence these variables 
* with the [lsf] array so can just write [lsf] to restart file rather 
* than each individual array.

      real lsf(kpt*mlsf)       !lsm variables saved from one time step to next
#if ( defined SUN )
      static lsf
#endif
      equivalence (h2osno, lsf)

* ------------------------ end lsmtv.h ----------------------------
 
