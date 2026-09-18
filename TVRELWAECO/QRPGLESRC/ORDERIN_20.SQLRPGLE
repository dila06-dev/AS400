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
     F*          AU# 26403 prüfen                                *
     F*          AU# 083069 richtig ==> 0083006 ohne die 9       *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     fnavhead   uf   e             disk
     fnavline   uf   e             disk
     fnavhead3  if   e           k disk    RENAME(NAVHEADR:header3)
     fteccom    if   e           k disk
     FWAEEDIhPl1if   E           k DISK    RENAME(EDIhPF0:log02r)
     F                                     prefix('Q')
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
     d*d_record      E DS                  INZ
     D*                                    prefix('#')

     I*-------------------------------------------------------------------------

     C                   setoff                                       55
     C                   DO        *HIVAL
     C                   READ      navline                                95
     C                   IF        *in95 = '1'
     C***                          EDIH030  <>  #EDIH030
     c                   unlock    navline
     C                   leave
     C                   else
     c                   exsr      srline
     c                   write     line
     c   55              delete    navline
     C                   endif
     C                   enddo

     C                   DO        *HIVAL
     C                   READ      navhead                                95
     C                   IF        *in95 = '1'
     C***                          EDIH030  <>  #EDIH030
     c                   unlock    navhead
     C                   leave
     C                   else
     c                   exsr      srheader
     c                   write     header
     c   55              delete    navhead
     c   45              update    NAVHEADR
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
     c                   clear                   header
     c                   setoff                                       45
     c     edih010       chain     teccom                             94
     c  n94              seton                                        45
     c                   seton                                        45
     c   45              exsr      sr8000
     c****               Warenempfänger aus shippment
     c****               WE wird vermutl. abgeschnitten 22.07.2026
     c                   movel     EDIH030##     H210


     c                   clear                   error           512
     c     ' ':'0'       xlate     EDIH010       EDIH010
     c                   testn                   EDIH010              20
     c  n20              eval         error = 'EDIH010'
     c  n20              movel     '0000000'     EDIH010
     c
     c     ' ':'0'       xlate     EDIH020       EDIH020
     c                   testn                   EDIH020              20
     c  n20              eval         error = error + %triml (' EDIH020')
     c  n20              movel     '0000000'     EDIH020
     c
     c     ' ':'0'       xlate     EDIH030       EDIH030
     c                   testn                   EDIH030              20
     c  n20              eval         error = error + %triml (' EDIH030')
     c  n20              movel     '0000000'     EDIH030
     c
     c*    ' ':'0'       xlate     EDIH040       EDIH040
     c*                  testn                   EDIH040              20
     c* n20              eval         error = error + %triml (' EDIH040')
     c* n20              movel     '0000000'     EDIH040
     c
     c*    ' ':'0'       xlate     EDIH050       EDIH050
     c*                  testn                   EDIH050              20
     c* n20              eval         error = error + %triml (' EDIH050')
     c* n20              movel     '00000'       EDIH050
     c
     c     ' ':'0'       xlate     EDIH060       EDIH060
     c                   testn                   EDIH060              20
     c  n20              eval         error = error + %triml (' EDIH060')
     c  n20              movel     '00000000'    EDIH060
     c
     c     ' ':'0'       xlate     EDIH070       EDIH070
     c                   testn                   EDIH070              20
     c  n20              eval         error = error + %triml (' EDIH070')
     c  n20              movel     '000000'      EDIH070
     c
     c     ' ':'0'       xlate     EDIH090       EDIH090
     c                   testn                   EDIH090              20
     c  n20              eval         error = error + %triml (' EDIH090')
     c  n20              movel     '00000000'    EDIH090
     C*wegen daten in Promotion Code hier Datum initialisieren 20200804 Barenkamp/Gang
     c                   movel     '00000000'    EDIH090
     c
     c     ' ':'0'       xlate     EDIH260       EDIH260
     c                   testn                   EDIH260              20
     c  n20              eval         error = error + %triml (' EDIH260')
     c  n20              movel     '00000'       EDIH260
     c
     c     ' ':'0'       xlate     EDIH380       EDIH380
     c                   testn                   EDIH380              20
     c  n20              eval         error = error + %triml (' EDIH380')
     c  n20              movel     '000000'      EDIH380
     c
     c*    ' ':'0'       xlate     EDIH390       EDIH390
     c*                  testn                   EDIH390              20
     c* n20              eval         error = error + %triml (' EDIH390')
     c* n20              movel     '00'          EDIH390
     c                   setoff                                       20

     c                   eval      H010 = 'H'
     c                   clear                   H020
     c                   movel     EDIH010       H030
     c                   clear                   H040
     c***                movel     EDIH040       H040
     c                   clear                   H050
     c                   movel     EDIH040       H050
     C*orderreferenz jetzt original
     c                   if        EDIH030  =  '0078678'
     c                   movel     EDIH080       H050
     c                   endif
     C*Änderung jahr vor der originalauftragsnummer 20160122 Berenbrock
     c                   eval      h050      =   %trim(%subst(%char(jahr):3:2))
     c                                           + '-' +
     c                                           %trim(h050)
     C*bei teccom (*in45 = '1')
     c   45              clear                   H030
     c   45              move      '03'          H030
     c                   move      EDIH010       H040
     C*date
     c                   movel     edih060       #edih060          8
     c                   clear                   #h060            10
     c                   eval      #H060 = %subst(#edih060:1:4) + '-' +
     c                                     %subst(#edih060:5:2) + '-' +
     c                                     %subst(#edih060:7:2)
     c                   eval      h060      = %date(#h060)
     C*time
     c                   movel     edih070       #edih070          6
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
     c                   if        EDIH010  = '  55278'
     c                   if        EDIH250  = 'I '
     c                   movel     'IT'          EDIH250
     c                   endif
     c                   movel     EDIH230       EDIH240
     c                   clear                   EDIH230
     c                   endif
     c                   movel     EDIH210       H100
     c                   movel     EDIH220       H110
     c                   movel     EDIH230       H120
     c                   movel     EDIH240       H130
     c                   movel     EDIH250       H140
     c                   movel     EDIH260       H150
     c                   movel     EDIH270       H160
     c                   if        EDIH250  = 'IE'
     c                   movel     '00000'       H150
     c                   endif

     c                   movel     EDIH320       H170
     c                   movel     'H'           H180
     c                   movel     EDIH310       H230
     c                   movel     EDIH080       H240
     c
     c                   if        h240    = ' '
     c                   eval      h240    = %triml(edih040)
     c                   endif
     c
     c                   eval      H250 = %subst(edih370:1:1)
     c                   eval      H260 = %subst(edih370:2:1)
     c*                  eval      %subst(edih370:3:1)
     c                   movel     '0'           H270
     c*                  Priority                 EDIH370x Byte 1
     c*                  Full / partial delivery  EDIH370x Byte 2
     c*                  Fixed date               EDIH370x Byte 3
     c                   eval      h370   =      tstampi
     c                   eval      h360   =      datum
     c                   exsr      SR5850

     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*
     c                   clear                   line
     c                   setoff                                       45
     c     edil010       chain     teccom                             94
     c  n94              seton                                        45
     c                   seton                                        45

     c                   movel     EDIL010       $EDIL010          7
     c                   clear                   error           512
     c     ' ':'0'       xlate     EDIL010       EDIL010
     c                   testn                   EDIL010              20
     c  n20              eval         error = 'EDIL010'
     c  n20              movel     '0000000'     EDIL010
     c
     c     ' ':'0'       xlate     EDIL020       EDIL020
     c                   testn                   EDIL020              20
     c  n20              eval         error = error + %triml (' EDIL020')
     c  n20              movel     '0000000'     EDIL020
     c
     c     ' ':'0'       xlate     EDIL030       EDIL030
     c                   testn                   EDIL030              20
     c  n20              eval         error = error + %triml (' EDIL030')
     c  n20              movel     '0000000'     EDIL030
     c   20              movel     edil030       #edil030          7 0
     c
     c*    ' ':'0'       xlate     EDIL040       EDIL040
     c*                  testn                   EDIL040              20
     c* n20              eval         error = error + %triml (' EDIL040')
     c* n20              movel     '0000000'     EDIL040
     c*  20              movel     edil040       #edil040          7 0
     c                   exsr      sr1500
     c
     c                   if        *in45 = '1'
     c                   clear                   d                 1
     c                   endif
     c
     c   45              evalr     edil050 = %trimr(edil050)
     c   45              evalr     edil050 = %triml(edil050)
     c     ' ':'0'       xlate     EDIL050       EDIL050
     c                   testn                   EDIL050              20
     c  n20              eval         error = error + %triml (' EDIL050')
     c  n20              movel     '00000'       EDIL050
     c                   if        edil050 = *zero
     c                   eval      ##edil050 = ##edil050 +1
     c                   movel     ##edil050     edil050
     c                   else
     c                   movel     edil050       ##edil050         5 0
     c                   endif
     c                   if        ##edil050   > 1000
     c                   eval      ##edil050   = ##edil050 /1000
     c                   movel     ##edil050     edil050
     c                   endif
     c                   z-add     ##edil050     l050
     c
     c     ' ':'0'       xlate     EDIL060       EDIL060
     c                   testn                   EDIL060              20
     c  n20              eval         error = error + %triml (' EDIL060')
     c  n20              movel     '00000000'    EDIL060
     c
     c     ' ':'0'       xlate     EDIL070       EDIL070
     c                   testn                   EDIL070              20
     c  n20              eval         error = error + %triml (' EDIL070')
     c  n20              movel     '000000'      EDIL070
     c
     c                   testn                   EDIl240              20
     c  n20              eval      EDIL240 = %triml(edil240)
     c  n20              if        %subst(edil240:5:1) = '    '
     c                   eval      EDIL240 ='0000' + %subst(edil240:1:4)
     c                   endif
     c  n20              if        %subst(edil240:6:1) = '    '
     c                   eval      EDIL240 ='000' + %subst(edil240:1:5)
     c                   endif
     c  n20              if        %subst(edil240:7:1) = '    '
     c                   eval      EDIL240 ='00' + %subst(edil240:1:6)
     c                   endif
     c  n20              if        %subst(edil240:8:1) = '    '
     c                   eval      EDIL240 ='0' + %subst(edil240:1:7)
     c                   endif
     c     ' ':'0'       xlate     EDIL240       EDIL240
     c                   testn                   EDIl240              20
     c  n20              eval         error = error + %triml (' EDIl240')
     c  n20              movel     '00000000'    EDIl240
     c
     c     ' ':'0'       xlate     EDIL320       EDIL320
     c                   testn                   EDIl320              20
     c  n20              eval         error = error + %triml (' EDIl320')
     c  n20              movel     '00'          EDIl320
     c
     c     ' ':'0'       xlate     EDIL340       EDIL340
     c                   testn                   EDIl340              20
     c  n20              eval         error = error + %triml (' EDIl340')
     c  n20              movel     '000000'      EDIl340
     c
     c     ' ':'0'       xlate     EDIL350       EDIL350
     c                   testn                   EDIl350              20
     c  n20              eval         error = error + %triml (' EDIl350')
     c  n20              movel     '000'         EDIl350

     c                   eval      L010 = 'L'
     c                   clear                   L020
     c                   movel     EDIl010       l250
     c   45              clear                   l250
     c   45              move      '03'          l250
     c                   clear                   L030
     c                   movel     EDIl040       L040
     C*orderreferenz jetzt original für Polen aus Routine sr1500
     c                   if        EDIL030  =  '0078678'
     c                   movel     $EDIH080      L040
     c                   endif
     C*Änderung jahr vor der originalauftragsnummer 20160122 Berenbrock
     c                   eval      l040      =   %trim(%subst(%char(jahr):3:2))
     c                                           + '-' +
     c                                           %trim(l040)

     C*date delivery aus header
     c     ' ':'0'       xlate     $edih090      $edih090
     c                   testn                   $edih090             20
     c  n20              movel     '20100101'    $edih090
     c                   movel     '00000000'    $edih090
     c                   if        $edih090  =  '00000000'
     c                   movel     '20200814'    $edih090
     c                   endif
     c                   clear                   #h090            10
     c                   eval      #H090 = %subst($edih090:1:4) + '-' +
     c                                     %subst($edih090:5:2) + '-' +
     c                                     %subst($edih090:7:2)
     c*                  movel     #h090         l060
     c                   eval      l060      = %date(#h090)
     C*Kennung aus header
     c                   eval      l070 = %subst($edih370:3:1)
     C*
     c                   movel     EDIl220       L080
     c                   movel     EDIl230       L090
     c                   movel     EDIL240       L100
     c                   movel     EDIL300       L110
     c                   movel     EDIL230       L120
     c                   eval      l190   =      tstampi
     c                   eval      l180   =      datum

     c*
     C     ##line        ENDSR

     C**************************************************************************
     C* SR5850: Speditionsdaten QEDIH400, QEDIH410
     C*         Warehousdaten   QEDIH290, QEDIH300
     C*-------------------------------------------------------------------------
     C*
     C     SR5850        BEGSR
     C*
     c     KEY5850       klist
     c                   kfld                    qEDIH030
     c                   kfld                    qEDIH080
     C*
     C                   move      EDIH030       qEDIH030
     C                   movel     EDIH080       qEDIH080
     C*
     c***  KEY5850       chain     WAEEDIhPl1                         92
     c  n92              movel     QEDIH400      H280
     c  n92              movel     QEDIH410      H290
     C*
     c  n92              movel     QEDIH290      H190
     c**n92              movel     QEDIH300      H210    gang 20150130
     C  n92              if        QEDIH290  <> ' '
     C                   movel     'W'           H200
     C                   endif
     C  n92              if        QEDIH300  <> ' '
     C                   movel     'W'           H220
     C                   endif
     C  n92              if        QEDIH420  <> ' '
     C                   movel     QEDIH420      H300
     C                   endif
     C*
     C     ##5850        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*
     C                   clear                   $edih370          3
     C                   clear                   $EDIH090          8
     C                   clear                   $EDIH080         30

     c/exec sql
     c+ whenever not found goto ##1500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1500
     c/end-exec

     c/exec sql
     C+ select  EDIH370,
     C+         EDIH090,
     C+         EDIH080
     C+ into    :$edih370, :$edih090, :$EDIH080
     C+ FROM    tvrelwaeco/navhead
     C+ WHERE   edih040               = :edil040 and
     C+         edih010               = :$EDIL010
     c/end-exec
     C*

     C     ##1500        ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*

     c     EDIH040       chain     navhead3                           94
     c                   clear                   EDIH030##        07
     c  n94              movel     EDIH030       EDIH030##
     c   94              clear                   EDIH370
     c   94              clear                   EDIH210
     c   94              clear                   EDIH220
     c   94              clear                   EDIH260
     c   94              clear                   EDIH270
     c   94              clear                   EDIH240
     c   94              clear                   EDIH230
     c   94              clear                   EDIH280
     c   94              clear                   EDIH290
     c   94              clear                   EDIH300
     c   94              clear                   EDIH250
     c   94              clear                   EDIH030

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

