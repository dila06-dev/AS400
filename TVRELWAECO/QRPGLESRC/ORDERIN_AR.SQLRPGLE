     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  SC     Schnittstelle                                    *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     fsbgau100  ip   e             disk
     fsbgau300  if   e           k disk
     Fsbgau500  if   E           k DISK
     Fsbgau600  if   E           k DISK
     Fsbgau200  if   E           k DISK

     forderh    if a e             disk    RENAME(orderhpf:header)
     forderl    if a e             disk    RENAME(orderlpf:line  )

     D*-------------------------------------------------------------------------
     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T

     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')
     D orderhx         DS
     D  #H010                  1      1
     D  #H020                  2      8
     D  #H030                  9     15
     D  #H040                 16     25
     D  #H050                 26     35
     D  #H060                 36     45
     D  #H070                 46     53
     D  #H080                 54     54
     D  #H090                 55     55
     D  #H100                 56     85
     D  #H110                 86    115
     D  #H120                116    145
     D  #H130                146    175
     D  #H140                176    178
     D  #H150                179    183
     D  #H160                184    213
     D  #H170                214    313
     D  #H180                314    314
     D  #H190                315    414
     D  #H200                415    415
     D  #H210                416    515
     D  #H220                516    516
     D  #H230                517    518
     D  #H240                519    539
     D  #H250                540    540
     D  #H260                541    541
     D  #H270                542    542
     D  #H280                543    642
     D  #H290                643    742
     D  #H300                743    802
     D  #H310                803   1314
     D  #H320               1315   1324
     D  #H330               1325   1334
     D  #H340               1335   1335
     D  #H350               1336   1345
     D  #H360               1346   1355
     D  #H370               1356   1381
     D*
     D orderlx         DS
     D  #L010                  1      1
     D  #L020                  2      5
     D  #L030                  6     11
     D  #L040                 12     21
     D  #L050                 22     26
     D  #L060                 27     36
     D  #L070                 37     37
     D  #L080                 38     52
     D  #L090                 53     92
     D  #L100                 93    100
     D  #L110                101    120
     D  #L120                121    150
     D  #L130                151    151
     D  #L140                152    152
     D  #L150                153    664
     D  #L160                665    674
     D  #L170                675    675
     D  #L180                676    685
     D  #L190                686    711
     D  #L200                712    721
     D  #L210                722    729
     D  #L220                730    733
     D  #L230                734    739
     D  #L240                740    749
     D  #L250                750    756
     D  #L990                757   1381

     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #AU1020           5

     I*-------------------------------------------------------------------------

     C                   movel     AU1020        ##AU120           5
     C                   if        #AU1020   =   ##AU120
     c                   setoff                                       30
     c                   if        AU1030    =   614956
     c                   clear                   uz                1
     c                   endif
     c                   exsr      sr5802
     c                   endif

     C**************************************************************************
     C* lesen daten aus Auftrag grunddaten
     C*-------------------------------------------------------------------------
     C*
     C     sr5802        BEGSR
     C*
     C     KEY5802       KLIST
     C                   KFLD                    AU3010
     C                   KFLD                    AU3020
     C                   KFLD                    AU3030
     C                   KFLD                    AU3040
     C                   KFLD                    AU3050
     C*
     C                   eval      AU3010   =    AU1010
     C                   eval      AU3020   =    AU1020
     C                   eval      AU3030   =    AU1030
     C                   eval      AU3040   =    AU1040
     C                   eval      AU3050   =    '03'

     C     KEY5802       SETLL     sbgau300                           99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      sbgau300                               99
     c                   if        *in99 ='1'                        or
     c                             AU3010   <> AU1010                or
     C                             AU3020   <> AU1020                or
     C                             AU3030   <> AU1030                or
     C                             AU3040   <> AU1040                or
     C                             AU3050   <> '03'
     C                   LEAVE
     C                   else
     C                   exsr      sr5802D
     C                   endif
     C*
     c                   enddo
     C                   endif
     C*
     C     ##5802        ENDSR
     C*
     C**************************************************************************
     C* lesen daten aus Auftrag Detail
     C*-------------------------------------------------------------------------
     C*
     C     sr5802d       BEGSR
     C*
     C     KEY5802d      KLIST
     C                   KFLD                    AU5010
     C                   KFLD                    AU5020
     C                   KFLD                    AU5030
     C                   KFLD                    AU5040
     C                   KFLD                    AU5050
     C                   KFLD                    AU5060
     C
     C                   eval      AU5010   =    AU1010
     C                   eval      AU5020   =    AU1020
     C                   eval      AU5030   =    AU1030
     C                   eval      AU5040   =    AU1040
     C                   eval      AU5050   =    '10'

     C                   clear                   au5060

     C     KEY5802d      SETLL     sbgau500                           99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      sbgau500                               99
     c                   if        *in99 ='1'                       or
     c                             AU5010   <> AU1010               or
     C                             AU5020   <> AU1020               or
     C                             AU5030   <> AU1030               or
     C                             AU5040   <> AU1040               or
     C                             AU5050   <> '10'
     C                   LEAVE
     C                   else
     c  n30              exsr      srheader
     c  n30              write     header
     c                   seton                                        30
     c                   exsr      srline
     c                   write     line
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##5802d       ENDSR
     C*
     C**************************************************************************
     C* lesen daten Text header
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     C     KEY6000       KLIST
     C                   KFLD                    AU1010
     C                   KFLD                    AU1020
     C                   KFLD                    AU1030
     C                   KFLD                    AU1040
     C                   KFLD                    AU6050
     C                   KFLD                    AU6060
     C                   KFLD                    AU6070

     C                   movel     '10'          AU6050
     C                   z-add     1             AU6060
     C                   movel     'T'           AU6070

     c     KEY6000       chain     sbgau600                           93
     C   93              clear                   AU6130
     C*
     C     ##6000        ENDSR
     C*
     C**************************************************************************
     C* lesen daten Text line
     C*-------------------------------------------------------------------------
     C*
     C     sr60002       BEGSR
     C*
     C     KEY60002      KLIST
     C                   KFLD                    AU1010
     C                   KFLD                    AU1020
     C                   KFLD                    AU1030
     C                   KFLD                    AU1040
     C                   KFLD                    AU6050
     C                   KFLD                    AU6060
     C                   KFLD                    AU6070

     C                   movel     '10'          AU6050
     C                   z-add     AU5060        AU6060
     C                   movel     'T'           AU6070

     c     KEY60002      chain     sbgau600                           93
     C   93              clear                   AU6130
     C*
     C     ##60002       ENDSR
     C*
     C**************************************************************************
     C* lesen daten Text sbgau200
     C*-------------------------------------------------------------------------
     C*
     C     sr6050        BEGSR
     C*
     C     KEY6050       KLIST
     C                   KFLD                    AU1010
     C                   KFLD                    AU1020
     C                   KFLD                    AU1030
     C                   KFLD                    AU1040
     C                   KFLD                    AU2050
     C                   KFLD                    AU2060
     C                   KFLD                    AU2070

     C                   movel     '02'          AU2050
     C                   z-add     0             AU2060
     C                   movel     '0'           AU2070

     c     KEY6050       chain     sbgau200                           93
     C   93              clear                   AU2180
     C   93              clear                   AU2190
     C*
     C     ##6050        ENDSR
     C*
     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     srheader      BEGSR
      *
     c                   clear                   header


     c                   eval      H010 = 'H'
     c                   z-add     AU1090        h020
     c                   z-add     99999         h030
     c                   z-add     AU1090        h040
     c****************   movel     AU3090        h050
     C*20101222
     c                   movel     AU1030        h050
     C*eingangsdatum
     c                   movel     AU3100        #AU3100           6
     c                   clear                   #check           10
     c                   eval      #check = %subst(#AU3100:1:2) + '.'  +
     c                                      %subst(#AU3100:3:2) + '.'  +
     c                                                            '20' +
     c                                      %subst(#AU3100:5:2)
     c                   SETOFF                                       20
      /Free
         MONITOR;
            Test(DE) *eur #check;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     #check        h060
     c   20              movel     date          h060
     c
     c                   movel     '01.01.00'    h070
     c                   clear                   h080
     c                   clear                   h090
     c
     c                   movel     AU1100        h100
     c                   movel     AU1110        h110
     c                   movel     AU1120        h120
     c                   movel     AU1130        h130
     c                   movel     AU1140        h140
     c                   movel     AU1150        h150
     c                   movel     AU1160        h160
     c                   exsr      sr6050
     c                   if        AU2180  =  50 or
     c                             AU2190  =  50 or
     c                             AU2180  =  51 or
     c                             AU2190  =  51
     c                   eval      h140 = %trim(AU1140)
     c                   else
     c                   movel     'DE '         h140
     c                   endif
     c                   If        h140  = 'A  '
     c                   movel     'AT '         h140
     c                   endif
     c                   If        h140  = 'B  '
     c                   movel     'BE '         h140
     c                   endif
     c                   If        h140  = 'F  '
     c                   movel     'FR '         h140
     c                   endif
     c                   If        h140  = 'H  '
     c                   movel     'HU '         h140
     c                   endif
     c                   If        h140  = 'I  '
     c                   movel     'IT '         h140
     c                   endif
     c                   If        h140  = 'J  '
     c                   movel     'JP '         h140
     c                   endif
     c                   If        h140  = 'L  '
     c                   movel     'LU '         h140
     c                   endif
     c                   If        h140  = 'N  '
     c                   movel     'NO '         h140
     c                   endif
     c                   If        h140  = 'S  '
     c                   movel     'SE '         h140
     c                   endif
     c
     c
     c
     c                   exsr      sr6000
     c                   movel     AU6130        h170
     c                   movel     'H'           h180
     c                   clear                   h190
     c                   clear                   h200
     c                   clear                   h210
     c                   clear                   h220
     c                   clear                   h230
     c                   movel     AU1030        h240
     c                   move      'BGFS'        h240
     c                   clear                   h250
     c                   clear                   h260
     c                   clear                   h270
     c                   clear                   h280
     c                   clear                   h290
     c                   clear                   h300
     c                   movel     AU3090        h300
     c                   move      'BGFS'        h300
     c                   if        AU1040 = 12
     c                   movel     '14'          AU1040
     c                   endif
     c                   movel     AU1040        h320
     c
     c                   eval      h360   =      datum
     c                   eval      h370   =      tstampi
     c

     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*
     c                   clear                   line
     c                   eval      L010 = 'L'
     c                   clear                   l020
     c                   clear                   l030
     c*************      movel     AU3090        l040
     C*20101222
     c                   movel     AU1030        l040
     c                   z-add     AU5060        l050
     C*Auftrag von
     c                   movel     AU3100        #AU3100           6
     c                   clear                   #check           10
     c                   eval      #check = %subst(#AU3100:1:2) + '.'  +
     c                                      %subst(#AU3100:3:2) + '.'  +
     c                                                            '20' +
     c                                      %subst(#AU3100:5:2)
     c                   SETOFF                                       20
      /Free
         MONITOR;
            Test(DE) *eur #check;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     #check        l060
     c   20              movel     date          l060
     c
     C*lieferzeit kundenwunsch
     c                   movel     AU3110        #AU3110           6
     c                   clear                   #check           10
     c                   eval      #check = %subst(#AU3110:1:2) + '.'  +
     c                                      %subst(#AU3110:3:2) + '.'  +
     c                                                            '20' +
     c                                      %subst(#AU3110:5:2)
     c                   SETOFF                                       20
      /Free
         MONITOR;
            Test(DE) *eur #check;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     #check        l060
     c   20              clear                   l060
     c
     c
     C*fixed date
     c                   movel     AU3120        #AU3120           6
     c                   clear                   #check           10
     c                   eval      #check = %subst(#AU3120:1:2) + '.'  +
     c                                      %subst(#AU3120:3:2) + '.'  +
     c                                                            '20' +
     c                                      %subst(#AU3120:5:2)
     c                   SETOFF                                       20
      /Free
         MONITOR;
            Test(DE) *eur #check;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     #check        l060
     c  n20              movel     '1'           l070
     c
     c
     c                   movel     AU5090        l080
     c                   clear                   l090
     c                   z-add     AU5310        l100
     c                   movel     AU5290        l150
     c                   movel     AU3120        #au3120           6
     c                   clear                   l120
     c                   eval      %subst(l120:01:06) =  #au3120
     c                   eval      %subst(l120:07:01) =  au5290
     c
     c                   exsr      sr60002
     c                   eval      %subst(l150:61:60) =  AU6130
     c
     c                   eval      l190   =      tstampi
     c                   eval      l180   =      datum
     c                   z-add     99999         l250

     c*
     C     ##line        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   orderh
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     C                   exsr      sr9999

     C                   ENDSR

