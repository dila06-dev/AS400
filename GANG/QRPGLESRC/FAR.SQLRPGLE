      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fPDIAUF00  ip   f  256        disk
     F
     F
     Ff1        uf a e             disk
     F                                     RENAME(f1:phy01r)
     Ff2        uf a e             disk
     F                                     RENAME(f2:phy02r)
     Ff3        uf a e             disk
     F                                     RENAME(f3:phy03r)
     Ff5        uf a e             disk
     F                                     RENAME(f5:phy05r)
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------
     D*                                                                     ----
     IPDIAUF00  kf  01   16 d0   17 d1
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I                             A   21   21  FAK1070
     I                             A   22   22  FAK1080
     I                             S   23   27 0FAK1090
     I                             A   28   52  FAK1100
     I                             A   53   77  FAK1110
     I                             A   78  102  FAK1120
     I                             A  103  127  FAK1130
     I                             A  128  130  FAK1140
     I                             A  131  135  FAK1150
     I                             A  136  160  FAK1160
     I                             A  161  248  FAK1170
     I                             A  249  249  FAK1730
     I                             A  250  250  FAK1740
     I                             S  251  256 0FAK1750
     I
     I*                                                                     ----
     I          kf  02   16 d0   17 d2  249 d0
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I                             A   21   21  FAK1070
     I                             S   22   26 0FAK2080
     I                             A   27   51  FAK2090
     I                             S   52   52 0FAK2100
     I                             A   53   53  FAK2110
     I                             A   54   54  ###2120
     I                             S   55   59 0FAK2130
     I                             S   60   64 0FAK2140
     I                             S   65   70 0FAK2150
     I                             A   71   73  FAK2160
     I                             A   74   76  FAK2170
     I                             S   77   78 0FAK2180
     I                             S   79   80 0FAK2190
     I                             A   81   83  FAK2200
     I                             S   84   85 0FAK2210
     I                             S   86   86 0FAK2220
     I                             S   87   87 0FAK2230
     I                             S   88   89 0FAK2240
     I                             S   90   91 0FAK2250
     I                             A   92   92  FAK2260
     I                             S   93   94 0FAK2270
     I                             S   95   96 0FAK2280
     I                             S   97   98 0FAK2290
     I                             A   99  101  FAK2300
     I                             A  102  103  FAK2310
     I                             S  104  109 0FAK2320
     I                             A  110  110  FAK2330
     I                             A  111  111  FAK2340
     I                             A  112  112  FAK2350
     I                             A  113  113  FAK2360
     I                             A  114  114  FAK2370
     I                             A  115  121  FAK2380
     I                             P  122  125 6FAK2390
     I                             P  126  130 2FAK2400
     I                             P  131  135 2FAK2410
     I                             P  136  141 2FAK2420
     I                             P  142  146 2FAK2430
     I                             P  147  152 2FAK2440
     I                             A  153  155  FAK2450
     I                             A  156  163  FAK2460
     I                             A  164  175  FAK2470
     I                             P  176  181 2FAK2480
     I                             A  182  248  FAK2490
     I                             A  249  249  FAK1730
     I                             A  250  250  FAK1740
     I                             S  251  256 0FAK1750
     I
     I*
     I          kf  03   16 d0   17 d3
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I                             A   21   21  FAK1070
     I                             A   22   22  ###3080
     I                             A   23   43  FAK3090
     I                             S   44   49 0FAK3100
     I                             A   50   61  FAK3110
     I                             S   62   67 0FAK3120
     I                             S   68   69 0FAK3130
     I                             S   70   71 0FAK3140
     I                             S   72   77 0FAK3150
     I                             A   78   78  ###3160
     I                             S   79   84 0FAK3170
     I                             S   85   87 0FAK3180
     I                             S   88   90 2FAK3190
     I                             S   91   93 0FAK3200
     I                             S   94   96 2FAK3210
     I                             S   97   99 0FAK3220
     I                             S  100  102 2FAK3230
     I                             P  103  107 3FAK3240
     I                             P  108  111 3FAK3250
     I                             P  112  114 0FAK3260
     I                             A  115  115  FAK3270
     I                             S  116  116 0FAK3280
     I                             A  117  117  ###3290
     I                             S  118  118 0FAK3300
     I                             S  119  124 0FAK3310
     I                             S  125  130 0FAK3320
     I                             A  131  131  FAK3330
     I                             S  132  133 0FAK3340
     I                             A  134  134  FAK3350
     I                             S  135  140 0FAK3360
     I                             A  141  141  ###3370
     I                             S  142  147 0FAK3380
     I                             S  148  153 0FAK3390
     I                             A  154  154  ###3400
     I                             P  155  160 2FAK3410
     I                             S  161  161 0FAK3420
     I                             S  162  163 0FAK3430
     I                             S  164  165 0FAK3440
     I                             S  166  171 0FAK3450
     I                             S  172  177 0FAK3460
     I                             S  178  180 2FAK3470
     I                             P  181  185 2FAK3480
     I                             P  186  190 2FAK3490
     I                             P  191  195 2FAK3500
     I                             A  196  200  FAK3510
     I                             S  201  201 0FAK3520
     I                             S  202  202 0FAK3530
     I                             S  203  206 2FAK3540
     I                             S  207  208 0FAK3550
     I                             S  209  212 2FAK3560
     I                             S  213  214 0FAK3570
     I                             P  215  220 2FAK3580
     I                             A  221  248  FAK3590
     I                             A  249  249  FAK1730
     I                             A  250  250  FAK1740
     I                             S  251  256 0FAK1750
     I*                                                                     ----
      * :läuft durch, Fehler bereinigt
     I          KF  05   16 C1   21 CN  249 C0
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I                             A   21   21  FAK1070
     I                             A   22   24  FAK5080
     I                             A   25   39  FAK5090
     I                             A   40   42  FAK5100
     I                             A   43   45  FAK5110
     I                             P   46   49 3FAK5120
     I                             P   50   52 3FAK5130
     I                             P   53   54 0FAK5140
     I                             A   55   55  FAK5150
     I                             A   56   56  FAK5160
     I                             A   57   57  FAK5170
     I                             A   58   58  FAK5180
     I                             A   59   59  FAK5190
     I                             A   60   60  FAK5200
     I                             A   61   61  FAK5210
     I                             A   62   62  FAK5220
     I                             A   63   63  FAK5230
     I                             A   64   64  FAK5240
     I                             A   65   65  FAK5250
     I                             A   66   66  FAK5260
     I                             A   67   67  FAK5270
     I                             A   68   68  FAK5280
     I                             A   69   69  FAK5290
     I                             A   70   70  FAK5300
     I                             A   71   72  FAK5310
     I                             P   73   75 0FAK5320
     I                             P   76   78 0FAK5330
     I                             P   79   81 0FAK5340
     I                             P   82   84 0FAK5350
     I                             P   85   89 2FAK5370
     I                             P   90   94 2FAK5380
     I                             S   95   95 0FAK5390
     I                             S   96   96 0FAK5400
     I                             P   97   99 2FAK5410
     I                             P  100  102 2FAK5420
     I                             P  103  105 2FAK5430
     I                             P  106  108 0FAK5440
     I                             A  109  111  FAK5450
     I                             A  112  114  FAK5460
     I                             A  115  129  FAK5470
     I                             S  130  135 0FAK5480
     I                             A  136  136  FAK5490
     I                             A  137  137  FAK5500
     I                             A  138  138  FAK5510
     I                             A  139  139  FAK5520
     I                             A  140  140  FAK5530
     I                             A  141  141  FAK5540
     I                             P  142  146 2FAK5550
     I                             P  147  151 2FAK5560
     I                             P  152  156 2FAK5570
     I                             P  157  161 2FAK5580
     I                             A  162  191  FAK5590
     I                             A  192  197  FAK5600
     I                             A  198  198  FAK5610
     I                             A  199  199  FAK5620
     I                             a  200  200  ###5630
     I                             S  201  201 0FAK5640
     I                             S  202  202 0FAK5650
     I                             S  203  206 2FAK5660
     I                             a  207  208  ###5670
     I                             a  209  212  ###5680
     I                             a  213  214  ###5690
     I                             P  215  220 2FAK5700
     I                             A  221  223  FAK5710
     I                             A  224  226  FAK5720
     I                             A  227  227  FAK5730
     I                             A  228  228  FAK5740
     I                             P  229  233 2FAK5750
     I                             A  234  248  FAK5760
     I                             A  249  249  FAK1730
     I                             A  250  250  FAK1740
     I                             S  251  256 0FAK1750
     I*                                                                     ----
      * :ERROR in 10Satzart Sonderrabatte
     I          KF  98   16 C1   21 CN  249NC0
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I*                                                                     ----
     I          kf  06   16 d1   17 d0   21 cT
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     I*                                                                     ----
     I          kf  99
     I                             S    1    2 0FAK1010
     I                             S    3    7 0FAK1020
     I                             S    8   13 0FAK1030
     I                             S   14   15 0FAK1040
     I                             S   16   17 0FAK1050
     I                             S   18   20 0FAK1060
     D*-------------------------------------------------------------------------
     C*
     C                   setoff                                       10
     C                   if        *in10  = '0'
     C   01              exsr      sr3000
     C   02              exsr      sr3000
     C   03              exsr      sr3000
     C   05              exsr      sr3000
     C                   endif
     C*
     C**************************************************************************
     C*Berechnungen
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c   01              write     phy01r
     C*
     c   02              clear                   FAK2120           1 0
     c   02              write     phy02r
     c*
     c   03              exsr      sr3500
     c   03              clear                   FAK3160           1 0
     c   03              clear                   FAK3290           1 0
     c   03              clear                   FAK3370           1 0
     c   03              clear                   FAK3400           1 0
     c   03              write     phy03r
     C*
     c   05              clear                   FAK5630           1 0
     c   05              clear                   FAK5670           2 0
     c   05              clear                   FAK5680           4 2
     c   05              clear                   FAK5690           2 0
     c   05              write     phy05r
     C*
     C     ##3000        ENDSR

     C**************************************************************************
     C*check auf KW-Datum und Korrektur FAK3120 ==> FAK3110 left
     C*-------------------------------------------------------------------------
     C*
     C     sr3500        BEGSR
     C*
     c                   movel     fak3110       #AK3110           6
     c                   testn                   #AK3110              30
     C                   if        *in30  = '0'
     c                   movel     FAK3120       FAK3110
     c                   endif
     C*
     c                   movel     FAK3110       fak3110tt         2 0
     c                   if        fak3110tt > 31
     c                   movel     FAK3120       FAK3110
     c                   endif
     c                   clear                   aAK3110           2
     c                   eval      aAK3110 = (%subst(fak3110:03:02))
     c                   movel     aAK3110       fak3110mm         2 0
     c                   if        fak3110mm > 12
     c                   movel     FAK3120       FAK3110
     c                   endif
     c                   eval      aAK3110 = (%subst(fak3110:05:02))
     c                   move      aAK3110       fak3110jj         2 0
     c                   if        fak3110jj > 20
     c                   movel     FAK3120       FAK3110
     c                   endif
     c                   if        ( fak3110mm = 02 ) and ( fak3110tt > 29 )
     c                   movel     FAK3120       FAK3110
     c                   endif
     c                   if        ( fak3110mm = 04 or fak3110mm = 06 or
     c                               fak3110mm = 09 or fak3110mm = 11 )
     c                              and ( fak3110tt > 30 )
     c                   movel     FAK3120       FAK3110
     c                   endif
     C*
     C     ##3500        ENDSR
     C*
     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   z-add     1             p01               1 0
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
