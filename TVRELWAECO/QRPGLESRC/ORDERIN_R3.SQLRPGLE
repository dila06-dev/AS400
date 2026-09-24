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
     F*  Schritt 1 Inhalt übergeben aus Datei Formmuster         *             
     F*  "       2 Call aus ORDERNAV_C                           *
     F*  "       3 Buchungsprogramm Standardschnittstelle        *
     F*  neu ORH230 für zip                                     *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     H*datfmt(*iso) timfmt(*iso)

     fpwinorh   uf   e             disk
     fpwinord   uf   e             disk
     fpwinortl1 if   e           k disk

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

     I*-------------------------------------------------------------------------
     d d_head          DS                  INZ
     D  §orh310                1      2
     D  §orh315                3      4
     D  §orh316                5      9
     D  §orh400               10     10
     D  §orh420               11     13
     D  §orh430               14     18
     D  §orh440               19     23
     D  §orh410               24     31
     D  §orh450               32     37
     D  §orh460               38     43
     D  §orh470               44     49
     D*                                    prefix('§')

     I*-------------------------------------------------------------------------

     C                   setoff                                       55
     C                   DO        *HIVAL
     C                   READ      pwinord                                95
     C                   IF        *in95 = '1'
     C***                          EDIH030  <>  #EDIH030
     c                   unlock    pwinord
     C                   leave
     C                   else
     c                   exsr      srline
     c                   write     line
     c   55              delete    pwinord
     C                   endif
     C                   enddo

     C                   DO        *HIVAL
     C                   READ      pwinorh                                95
     C                   IF        *in95 = '1'
     C***                          EDIH030  <>  #EDIH030
     c                   unlock    pwinorh
     C                   leave
     C                   else
     c                   exsr      srheader
     c                   write     header
     c   55              delete    pwinorh
     c** 45              update    ORH00R1
     C                   endif
     C                   enddo

     C*
     C                   EXSR      RETURN

     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     srheader      BEGSR
      *

     c                   clear                   error           512
     c                   clear                   header
     c                   seton                                        45
     c                   exsr      sr8000
     c
     c                   setoff                                       20

     c                   eval      H010 = 'H'
     c                   clear                   H020
     c                   movel     ORH010        H030
     c                   clear                   H050
     c                   move      ORH010        H040
     c                   clear                   xp               10 0
     c                   eval      xp = (orh040*1000)+orh045
     c                   move      xp            H050
     C*date
     c                   movel     orh060        #edih060          8
     c                   clear                   #h060            10
     c                   eval      #H060 = %subst(#edih060:1:4) + '-' +
     c                                     %subst(#edih060:5:2) + '-' +
     c                                     %subst(#edih060:7:2)
     c                   eval      h060      = %date(#h060)
     C*time
     c                   movel     orh060        #edih070          6
     c                   clear                   #h070             8
     c                   eval      #H070 = %subst(#edih070:1:2) + '.' +
     c                                     %subst(#edih070:3:2) + '.' +
     c                                     %subst(#edih070:5:2)
     c                   setoff                                       20
      /Free
         MONITOR;
            Test(ET) *EUR #h070;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     #h070         h070
     c   20              clear                   h070
     c
     c                   clear                   H080
     c                   clear                   H090
     c                   movel     orh210        H100
     c                   movel     orh220        H110
     c*****20211118      movel     orh230        H120  Rücksprache mit Michael wird orh230 füllen
     c                   movel     orh240        H130
     c                   movel     orh250        H140
     c                   movel     orh260        H150
     c                   if        h150   < 10000 and h140 <> 'DE '
     c*****              ZIP CODE  orh260 5 stellig numerisch, h150 numerisch
     c*****              orh260 5 stellig numerisch       01360
     c                   movel     orh260        ##H150            5
     c                   eval      %subst(h310:501:04) =
     c                             %subst(##h150:002:04)
     c                   endif
     c*****20211118
     c                   if        orh230  <> *blank
     c                   eval      %subst(h310:501:10) =
     c                             %subst(orh230:001:10)
     c                   endif
     c                   movel     orh270        H160

     c* b für header and warehouse Mail ab 7.5.2012
     c* ORH030 = 300117  keine Sonderübergabe mehr
     c                   if        ORH030 = 300117
     c                   z-add     ORH030        h020
     c                   endif
     c                   if        ORH030 = 220034
     c                   z-add     ORH030        h020
     c                   endif

     c                   movel     orh280        H170
     c                   movel     'B'           H180
     c                   movel     orh290        H190
     c                   eval      h190   =      %trim(orh290) +
     c                                           %trim(orh080) +
     c                                           ' '           +
     c                                           %trim(orh085)
     c                   movel     'B'           H200
     c                   if        orh250    = 'GB'
     c                   eval      %subst(h310:501:10) =
     c                             %subst(orh290:001:10)
     c                   endif
     c
     c*****              movel     orh300        H210
     c                   movel     'H'           H220
     c                   movel     orh310        H230
     c                   movel     H050          H240
     c*****              movel     ORH085        h300
     c* eMail ab 7.5.2012
     c*****              movel     orh350        h300
     c                   movel     orh300        h300
     c                   if        orh340 = 'J'
     c                   movel     'N'           H260
     c                   endif
     c                   if        orh340 = 'N'
     c                   movel     'J'           H260
     c                   endif
      *                 26.04.2018 VORLAUFTAGEKENNUNG
     c                   if        orh514 = 'J'
     c                   movel     'J'           H340
     c                   endif
     c                   movel     '0'           H270
      *                 27.09.2024 deaktiviert:
      *                 H280 und h290 sind nicht für forwarder
      *                 und stören Prozess in LFS
      *                 gehen jetzt über h190
     c                   eval      h280   =      %trim(orh080) +
     c                                           ' '           +
     c                                           %trim(orh085)
      *                 17.10.2024 h280 wieder aktiviert:
     c                   movel     orh316        h290
      *                 Nachnahmewerte
     c                   clear                   d_head
     c                   movel     orh310        §orh310
     c                   movel     orh315        §orh315
     c                   movel     orh316        §orh316
     c                   movel     orh400        §orh400
     c                   movel     orh420        §orh420
     c                   movel     orh430        §orh430
     c                   movel     orh440        §orh440
     c                   movel     orh410        §orh410
     c                   movel     orh450        §orh450
     c                   movel     orh460        §orh460
     c                   movel     orh470        §orh470
     c                   movel     orh511        H250
     c                   eval      %subst(h310:420:49) = d_head
     c                   eval      h370   =      tstampi
     c                   eval      h360   =      datum

     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*
     c                   seton                                        46
     c                   clear                   line
     c                   exsr      sr8000
     c                   eval      L010 = 'L'
     c                   clear                   L020
     c                   clear                   L030
     c                   clear                   xp               10 0
     c                   eval      xp = (ord040*1000)+ord045
     c                   move      xp            l040
     c                   move      ord050        L050
     c                   movel     ord400        #ord400           8
     c                   clear                   #h090            10
     c                   clear                   #l060            10
     c                   eval      #H090 = %subst(#ord400:1:4) + '-' +
     c                                     %subst(#ord400:5:2) + '-' +
     c                                     %subst(#ord400:7:2)
     c                   eval      l060      = %date(#h090)
     c
     c                   move      ord010        l250

     C*fixtermin
     C*20101222: wenn in ord430 gültiger Eintrag dann Fixtermin
     c                   movel     ORd430        #ORd430           8
     c                   clear                   #l070            10
     c                   eval      #l070 = %subst(#ORd430:1:4) + '-' +
     c                                     %subst(#ORd430:5:2) + '-' +
     c                                     %subst(#ORd430:7:2)
     c                   setoff                                       20
      /Free
         MONITOR;
            Test(DE) *iso #l070;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c  n20              movel     '1'           l070
     c  n20              movel     #l070         #l060
     c   20              movel     '0'           l070
     C*Fixtermin hat Vorrang
     c                   setoff                                       20
      /Free
         MONITOR;
            Test(DE) *iso #l060;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c                   if        l070      = '0'
     c                   eval      l060      = %date(#h090)
     c                   else
     c  n20              eval      #l060  = %char (%date (#l060:*iso) :*eur)
     c                   movel     #l060         l060
     c                   endif
     c
     c                   movel     ord220        L080
     c                   z-add     ord240        L100
     c                   movel     ord230        L110
     c                   movel     ord235        L120
      *                 Nachnahmewerte
     c                   clear                   ##pwinord        18
     c                   movel     ord450        ##pwinord
     c                   move      ord460        ##pwinord
     c                   eval      %subst(l150:481:18) = ##pwinord
     c                   eval      l190   =      tstampi
     c                   eval      l180   =      datum
     c*
     C     ##line        ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*
     c   45              eval      §ORT010 = ORh010
     c   45              eval      §ORT020 = ORh020
     c   45              eval      §ORT030 = ORh030
     c   45              eval      §ORT040 = ORh040
     c   45              eval      §ORT045 = ORh045
     c   45              eval      §ORT050 = 999
     c   45              eval      §ORT050 = 0
     c
     c   46              eval      §ORT010 = ORd010
     c   46              eval      §ORT020 = ORd020
     c   46              eval      §ORT030 = ORd030
     c   46              eval      §ORT040 = ORd040
     c   46              eval      §ORT045 = ORd045
     c   46              eval      §ORT050 = 0
     c
     c     key8000       klist
     c                   kfld                    §ORT010
     c                   kfld                    §ORT020
     c                   kfld                    §ORT030
     c                   kfld                    §ORT040
     c                   kfld                    §ORT045
     c                   kfld                    §ORT050

     C     *LIKE         DEFINE    ORT010        §ORT010
     C     *LIKE         DEFINE    ORT020        §ORT020
     C     *LIKE         DEFINE    ORT030        §ORT030
     C     *LIKE         DEFINE    ORT040        §ORT040
     C     *LIKE         DEFINE    ORT045        §ORT045
     C     *LIKE         DEFINE    ORT050        §ORT050
     C     *LIKE         DEFINE    h310          §x
     c                   z-add     1             z                 3 0

     C     key8000       SETLL     PWINORTL1                          99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      PWINORTL1                              99
     c                   if        *in99 ='1'                        or
     c                             §ORT010  <> ORT010               or
     c                             §ORT020  <> ORT020               or
     c                             §ORT030  <> ORT030               or
     c                             §ORT040  <> ORT040               or
     c                             §ORT045  <> ORT045
     C                   LEAVE
     C                   else
     c   45              if        ORT050  > 900 or ORT050  < 1
     c*******            movel     h310          §x
     c*******            eval      h310   =      %trimr(§x) +
     c*******                                    ' '        +
     c*******                                    %trimr(ORT080)
     c                   if        ort080 <> *blank and z < 422
     c                   eval      %subst(h310:z:60) = ORT080
     c                   eval      z = z + 60
     c                   endif
     c                   endif
     c   46              z-add     ORT050        xxp               3 0
     c   46              if        ORT050  < 900 and ORT050  > 1 and
     c                             ORd050  = xxp
     c*******            movel     l150          §x
     c*******            eval      l150   =      %trimr(§x) +
     c*******                                    ' '        +
     c*******                                    %trimr(ORT080)
     c                   if        z+60 < 480
     c                   eval      %subst(l150:z:60) = ORT080
     c                   endif
     c                   eval      z = z + 60
     c                   endif
     C                   endif
     c                   enddo
     C                   endif
     C                   setoff                                       4546

     C*
     C     ##8000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##9999
     c/end-exec
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   bar_kalk/kalk_file
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C*
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *
     c                   exsr      sr9999
     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     C                   ENDSR

