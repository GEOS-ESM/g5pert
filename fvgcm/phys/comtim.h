!
! $Id$
! $Author$
!
!
! Model time variables
!
      common/comtim/calday  ,dtime   ,twodt   ,divdampn,nrstrt  
      common/comtim/nstep   ,nstepr  ,nestep  ,nelapse ,nstop   
      common/comtim/mdbase  ,msbase  ,mdcur   ,mscur   ,mbdate  
      common/comtim/mbsec   ,mcdate  ,mcsec   ,nndbas  ,nnsbas  
      common/comtim/nnbdat  ,nnbsec  ,doabsems,dosw    ,dolw    
!
      real calday       ! Current calendar day = julian day + fraction
      real dtime        ! Time step in seconds (delta t)
      real twodt        ! 2 * delta t 
      real divdampn     ! Number of days to invoke divergence damper
      integer nrstrt    ! Starting time step of restart run (constant) 
      integer nstep     ! Current time step
      integer nstepr    ! Current time step of restart (updated w/nstep)
      integer nestep    ! Time step on which to stop run
      integer nelapse   ! Requested elapsed time for model run
      integer nstop     ! nestep + 1
      integer mdbase    ! Base day of run
      integer msbase    ! Base seconds of base day
      integer mdcur     ! Current day of run
      integer mscur     ! Current seconds of current day
      integer mbdate    ! Base date of run (yymmdd format)
      integer mbsec     ! Base seconds of base date
      integer mcdate    ! Current date of run (yymmdd format)
      integer mcsec     ! Current seconds of current date
      integer nndbas    ! User input base day
      integer nnsbas    ! User input base seconds of input base day
      integer nnbdat    ! User input base date (yymmdd format)
      integer nnbsec    ! User input base seconds of input base date
      logical doabsems  ! True => abs/emiss calculation this timestep
      logical dosw      ! True => shortwave calculation this timestep
      logical dolw      ! True => longwave calculation this timestep
