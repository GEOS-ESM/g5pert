DSET  ^fv_rout
options big_endian
TITLE  dycore32
UNDEF  1.e25 
XDEF  144  LINEAR      0   2.5
YDEF   91  LINEAR    -90   2.0
ZDEF  55 LEVELS
  0.015   0.0263  0.0401 0.0568  0.0777 
 0.1045   0.1396  0.1854 0.2449 0.3218
 0.4204   0.5463 0.7060 0.9073 1.1600
 1.4756   1.8679 2.3526 2.9483 3.6765
4.5617    5.6318 6.9183  8.4564 10.2849
12.4601  15.0502 18.1243 21.7610  26.0491
31.0889  36.9927  43.9097  52.0159  61.4957
72.5578  85.4390 100.5145 118.2502 139.1150
163.6615 192.5395 226.5130  266.4810 313.5010
368.8180 433.8950 510.4550  600.5240 696.7955 
787.7020 867.161 929.649 970.5549  992.5559
TDEF  999 LINEAR  00:00Z22NOV1996  06hr
VARS  12
wz    55   0 geop-height
zs    0    0 surface height
slp   0    0 sea-level pressure
ps    0    0 surface pressure
ua    55   0 u (m/s)
va    55   0 v (m/s)
ta    55   0 temperature (K)
epv   55   0 Ertel Potential vorticity
q     55   0 water vapor
tg     0   0 ground temperature
precp  0   0 instant precp rate at output time
omega 55   0 pressure vertical velocity
ENDVARS

