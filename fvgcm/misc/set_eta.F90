      subroutine set_eta(km, ks, ptop, pint, ak, bk)

      use precision
      implicit none

! Choices for vertical resolutions are as follows:
! NCAR: 18, 26, and 30
! NASA DAO: smoothed version of CCM4's 30-level, 32, 55, 64, and 96 
! Revised 32-layer setup with top at 0.4 mb for high horizontal
! resolution runs. (sjl: 04/01/2002)
! Revised 55-level eta with pint at 176.93 mb  SJL: 2000-03-20
!
!   17Apr2006  Elena N. fixed a bug in ks definition for 72-eta levels
!                       analogous to other vertical resolutions
!                       ks is defined as "2 levels above the first non-zero Bk


! NCAR specific
      real(r8) a18(19),b18(19)              ! CCM3
      real(r8) a26(27),b26(27)              ! CCM4
      real(r8) a30(31),b30(31)              ! CCM4

! NASA only
      real(r8) a30m(31),b30m(31)            ! smoothed CCM4 30-L
      real(r8) a32(33),b32(33)
      real(r8) a55(56),b55(56)
      real(r8) a64(65),b64(65)
      real(r8) a72(73),b72(73) ! GEOS-5 levels
      real(r8) a96(97),b96(97)

      integer ks, k, km
      real(r8) ak(km+1),bk(km+1)
      real(r8) ptop                      ! model top (Pa)
      real(r8) pint                      ! transition to p (Pa)

! *** NCAR settings ***

      data a18 /291.70,  792.92,  2155.39,  4918.34,  8314.25,      &
               7993.08, 7577.38,  7057.52,  6429.63,  5698.38,      &
               4879.13, 3998.95,  3096.31,  2219.02,  1420.39,      &
               754.13,  268.38,   0.0000,   0.0000 /

      data b18 /0.0000,    0.0000,    0.0000,   0.0000,   0.0000,   &
                0.0380541, 0.0873088, 0.1489307, 0.2232996,         &
                0.3099406, 0.4070096, 0.5112977, 0.6182465,         &
                0.7221927, 0.8168173, 0.8957590, 0.9533137,         &
                0.9851122, 1.0  /
     
      data a26 /219.4067,  489.5209,   988.2418,   1805.201,        &
                2983.724,  4462.334,   6160.587,   7851.243,        &
                7731.271,  7590.131,   7424.086,   7228.744,        &
                6998.933,  6728.574,   6410.509,   6036.322,        &
                5596.111,  5078.225,   4468.96,    3752.191,        &
                2908.949,  2084.739,   1334.443,   708.499,         &
                252.136,   0.,         0. /

      data b26 /0.,         0.,         0.,         0.,             &
                0.,         0.,         0.,         0.,             &
                0.01505309, 0.03276228, 0.05359622, 0.07810627,     &
                0.1069411,  0.14086370, 0.180772,   0.227722,       &
                0.2829562,  0.3479364,  0.4243822,  0.5143168,      &
                0.6201202,  0.7235355,  0.8176768,  0.8962153,      &
                0.9534761,  0.9851122,  1.        /

      data a30 /225.523952394724, 503.169186413288, 1015.79474285245, &
               1855.53170740604, 3066.91229343414,  4586.74766123295, &
               6332.34828710556, 8070.14182209969,  9494.10423636436, &
              11169.321089983,  13140.1270627975,  15458.6806893349,  &
              18186.3352656364, 17459.799349308,   16605.0657629967,  &
              15599.5160341263, 14416.541159153,   13024.8308181763,  &
              11387.5567913055,  9461.38575673103,  7534.44507718086, &
               5765.89405536652, 4273.46378564835,  3164.26791250706, &
               2522.12174236774, 1919.67375576496,  1361.80268600583, &
                853.108894079924, 397.881818935275,    0.,            &
                  0.  /

      data b30 /0.,                 0.,                                  &
                0.,                 0.,                0.,               &
                0.,                 0.,                0.,               &
                0.,                 0.,                0.,               &
                0.,                 0.,                0.03935482725501, &
                0.085653759539127,  0.140122056007385, 0.20420117676258, &
                0.279586911201477,  0.368274360895157, 0.47261056303978, &
                0.576988518238068,  0.672786951065063, 0.75362843275070, &
                0.813710987567902,  0.848494648933411, 0.88112789392471, &
                0.911346435546875,  0.938901245594025, 0.96355980634689, &
                0.985112190246582,  1.   /

! *** NASA DAO settings ***

! Smoothed CCM4's 30-Level setup
      data a30m / 300.00000,     725.00000,    1500.00000,       &
             2600.00000,    3800.00000,    5050.00000,           &
             6350.00000,    7750.00000,    9300.00000,           &
            11100.00000,   13140.00000,   15458.00000,           &
            18186.33580,   20676.23761,   22275.23783,           &
            23025.65071,   22947.33569,   22038.21991,           &
            20274.24578,   17684.31619,   14540.98138,           &
            11389.69990,    8795.97971,    6962.67963,           &
             5554.86684,    4376.83633,    3305.84967,           &     
             2322.63910,    1437.78398,     660.76994,           &
                0.00000 /

      data b30m / 0.00000,       0.00000,       0.00000,         &
                  0.00000,       0.00000,       0.00000,         &
                  0.00000,       0.00000,       0.00000,         &
                  0.00000,       0.00000,       0.00000,         &
                  0.00000,       0.00719,       0.02895,         &
                  0.06586,       0.11889,       0.18945,         &
                  0.27941,       0.38816,       0.50692,         &
                  0.61910,       0.70840,       0.77037,         &
                  0.81745,       0.85656,       0.89191,         &
                  0.92421,       0.95316,       0.97850,         &
                  1.00000 /

      data a32/40.00000,     106.00000,     224.00000,       &
              411.00000,     685.00000,    1065.00000,       &
             1565.00000,    2179.80000,    2900.00000,       &
             3680.00000,    4550.00000,    5515.00000,       &
             6607.00000,    7844.00000,    9236.56616,       &
            10866.34280,   12783.70000,   15039.29900,       &
            17693.00000,   20815.20900,   24487.49020,       &
            28808.28710,   32368.63870,   33739.96480,       &
            32958.54300,   30003.29880,   24930.12700,       &
            18568.89060,   12249.20510,    6636.21191,       &
             2391.51416,       0.00000,       0.00000 /

      data b32/ 0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.00000,       0.00000,       &
                0.00000,       0.01523,       0.06132,       &
                0.13948,       0.25181,       0.39770,       &
                0.55869,       0.70853,       0.83693,       &
                0.93208,       0.98511,       1.00000 /

      data a55/ 1.00000,       2.00000,       3.27000,                   &
              4.75850,       6.60000,       8.93450,                     &
             11.97030,      15.94950,      21.13490,                     &
             27.85260,      36.50410,      47.58060,                     &
             61.67790,      79.51340,     101.94420,                     &
            130.05080,     165.07920,     208.49720,                     &
            262.02120,     327.64330,     407.65670,                     &
            504.68050,     621.68000,     761.98390,                     &
            929.29430,    1127.68880,    1364.33920,                     &
           1645.70720,    1979.15540,    2373.03610,                     &
           2836.78160,    3380.99550,    4017.54170,                     &
           4764.39320,    5638.79380,    6660.33770,                     &
           7851.22980,    9236.56610,   10866.34270,                     &
          12783.70000,   15039.30000,   17693.00000,                     &
          20119.20876,   21686.49129,   22436.28749,                     &
          22388.46844,   21541.75227,   19873.78342,                     &
          17340.31831,   13874.44006,   10167.16551,                     &
           6609.84274,    3546.59643,    1270.49390,                     &
              0.00000,       0.00000   /

      data b55 /0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           & 
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00000,       0.00000,       0.00000,           &
                0.00696,       0.02801,       0.06372,           &
                0.11503,       0.18330,       0.27033,           &
                0.37844,       0.51046,       0.64271,           &
                0.76492,       0.86783,       0.94329,           &
                0.98511,       1.00000  /

      data a64/1.00000,       3.90000,       8.70000,      &
              15.42000,      24.00000,      34.50000,      &
              47.00000,      61.50000,      78.60000,      &
              99.13500,     124.12789,     154.63770,      &
             191.69700,     236.49300,     290.38000,      &
             354.91000,     431.82303,     523.09300,      &
             630.92800,     757.79000,     906.45000,      &
            1079.85000,    1281.00000,    1515.00000,      &
            1788.00000,    2105.00000,    2470.00000,      &
            2889.00000,    3362.00000,    3890.00000,      &
            4475.00000,    5120.00000,    5830.00000,      &
            6608.00000,    7461.00000,    8395.00000,      &
            9424.46289,   10574.46880,   11864.80270,      &
           13312.58890,   14937.03710,   16759.70700,      &
           18804.78710,   21099.41210,   23674.03710,      &
           26562.82810,   29804.11720,   32627.31640,      &
           34245.89840,   34722.28910,   34155.19920,      &
           32636.50390,   30241.08200,   27101.44920,      &
           23362.20700,   19317.05270,   15446.17090,      &
           12197.45210,    9496.39941,    7205.66992,      &
            5144.64307,    3240.79346,    1518.62134,      &
               0.00000,       0.00000 /

      data b64/0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00000,      &
               0.00000,       0.00000,       0.00813,      &
               0.03224,       0.07128,       0.12445,      &
               0.19063,       0.26929,       0.35799,      &
               0.45438,       0.55263,       0.64304,      &
               0.71703,       0.77754,       0.82827,      &
               0.87352,       0.91502,       0.95235,      &
               0.98511,       1.00000 /

        data a72 / &
         1.0000000,       2.0000002,       3.2700005,       4.7585009,       6.6000011, &
         8.9345014,       11.970302,       15.949503,       21.134903,       27.852606, &
         36.504108,       47.580610,       61.677911,       79.513413,       101.94402, &
         130.05102,       165.07903,       208.49704,       262.02105,       327.64307, &
         407.65710,       504.68010,       621.68012,       761.98417,       929.29420, &
         1127.6902,       1364.3402,       1645.7103,       1979.1604,       2373.0405, &
         2836.7806,       3381.0007,       4017.5409,       4764.3911,       5638.7912, &
         6660.3412,       7851.2316,       9236.5722,       10866.302,       12783.703, &
         15039.303,       17693.003,       20119.201,       21686.501,       22436.301, &
         22389.800,       21877.598,       21214.998,       20325.898,       19309.696, &
         18161.897,       16960.896,       15625.996,       14290.995,       12869.594, &
         11895.862,       10918.171,       9936.5219,       8909.9925,       7883.4220, &
         7062.1982,       6436.2637,       5805.3211,       5169.6110,       4533.9010, &
         3898.2009,       3257.0809,       2609.2006,       1961.3106,       1313.4804, &
         659.37527,       4.8048257,       0.0000000 /
              
              
        data b72 / &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,       0.0000000,       0.0000000,       0.0000000,       0.0000000, &
         0.0000000,   8.1754130e-09,    0.0069600246,     0.028010041,     0.063720063, &
        0.11360208,      0.15622409,      0.20035011,      0.24674112,      0.29440312, &
        0.34338113,      0.39289115,      0.44374018,      0.49459020,      0.54630418, &
        0.58104151,      0.61581843,      0.65063492,      0.68589990,      0.72116594, &
        0.74937819,      0.77063753,      0.79194696,      0.81330397,      0.83466097, &
        0.85601798,      0.87742898,      0.89890800,      0.92038701,      0.94186501, &
        0.96340602,      0.98495195,       1.0000000 /
              
      data a96/1.00000,       2.32782,       3.34990,            &
               4.49484,       5.62336,       6.93048,            &
               8.41428,      10.06365,      11.97630,            &
              14.18138,      16.70870,      19.58824,            &
              22.84950,      26.52080,      30.62845,            &
              35.19588,      40.24273,      45.78375,            &
              51.82793,      58.43583,      65.62319,            &
              73.40038,      81.77154,      90.73373,            &
             100.27628,     110.82243,     122.47773,            &
             135.35883,     149.59464,     165.32764,            &
             182.71530,     201.93164,     223.16899,            &
             246.63988,     272.57922,     301.24661,            &
             332.92902,     367.94348,     406.64044,            &
             449.40720,     496.67181,     548.90723,            &
             606.63629,     670.43683,     740.94727,            &
             818.87329,     904.99493,    1000.17395,            &
            1105.36304,    1221.61499,    1350.09326,            &
            1492.08362,    1649.00745,    1822.43469,            &
            2014.10168,    2225.92627,    2460.02905,            &
            2718.75195,    3004.68530,    3320.69092,            &
            3669.93066,    4055.90015,    4482.46240,            &
            4953.88672,    5474.89111,    6050.68994,            &
            6687.04492,    7390.32715,    8167.57373,            &
            9026.56445,    9975.89648,   11025.06934,            &
           12184.58398,   13466.04785,   14882.28320,            &
           16447.46289,   18177.25781,   20088.97461,            &
           21886.89453,   23274.16602,   24264.66602,            &
           24868.31641,   25091.15430,   24935.41016,            &
           24399.52148,   23478.13281,   22162.01758,            &
           20438.00586,   18288.83984,   15693.01172,            &
           12624.54199,    9584.35352,    6736.55713,            &
            4231.34326,    2199.57910,     747.11890,            &
              0.00000 /

      data b96/0.00000,       0.00000,       0.00000,            &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00000,       0.00000,       0.00000,             &
              0.00315,       0.01263,       0.02853,             &
              0.05101,       0.08030,       0.11669,             &
              0.16055,       0.21231,       0.27249,             &
              0.34169,       0.42062,       0.51005,             &
              0.61088,       0.70748,       0.79593,             &
              0.87253,       0.93400,       0.97764,             &
              1.00000 /

      select case (km)

! *** Original CCM3 18-Level setup ***
        case (18)
          ks = 4
          do k=1,km+1
            ak(k) = a18(k)
            bk(k) = b18(k)
          enddo

        case (26)
! CCM4 26-Level setup ***
          ks = 7
          do k=1,km+1
            ak(k) = a26(k)
            bk(k) = b26(k)
          enddo

        case (30)
! CCM4 30-Level setup ***
          ks = 12
          do k=1,km+1
            ak(k) = a30(k)
            bk(k) = b30(k)
          enddo

! *** Revised 32-L setup with ptop at 0.4 mb ***
! SJL: 04/01/2002
        case (32)
          ks = 21
          do k=1,km+1
            ak(k) = a32(k)
            bk(k) = b32(k)
          enddo

! *** Revised 55-L setup with ptop at 0.01 mb ***
        case (55)
          ks = 41
          do k=1,km+1
            ak(k) = a55(k)
            bk(k) = b55(k)
          enddo

! *** Others ***
        case (64)
          ks = 46
          do k=1,km+1
            ak(k) = a64(k)
            bk(k) = b64(k)
          enddo

! *** GEOS-5
        case (72)
          ks = 40
          do k=1,km+1
            ak(k) = a72(k)
            bk(k) = b72(k)
          enddo

        case (96)
          ks = 77
          do k=1,km+1
            ak(k) = a96(k)
            bk(k) = b96(k)
          enddo

      end select

          ptop = ak(1)
          pint = ak(ks+1) 

      return
      end
