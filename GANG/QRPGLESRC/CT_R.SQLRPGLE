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
     F*  BENGDSSONR Schnittstelle                                *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#afrk     up   e             disk    RENAME(#afrk:PHY01R)
     fcT_ford   if a e             disk    RENAME(cT_ford:PHY02R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     fafko01    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------
     Iphy02r
     I              ct_ford                     sentence
     I
     I*-------------aus--#CT0501------------------------------------------------

     c                   if        status = '  '

     C     *DTAARA       DEFINE                  $AFRK            10 0
     C  n25*lock         IN        $AFRK
     C  n25              eval      $AFRK   = $AFRK   + 1
     C  n25              out       $AFRK
     C  n25              exsr      sr_001
     c                   seton                                        25
     c                   exsr      sr1000
     c                   eval      status = '10'
     c                   update    phy01r

     c                   endif
     Clr                 exsr      sr_003
     Clr                 out       unique_f

     C**************************************************************************
     C* sr_001: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $AFRK         ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'A'                           +
     c                             %subst(##tst:01:04)           +
     c                             %subst(##tst:06:02)           +
     c                             %subst(##tst:09:02)           +
     c                             %subst(##tst:12:02)           +
     c                             %subst(##tst:15:02)           +
     c                             '00'                          +
     c                             'Manfred Gang '               +
     c                             'Dometic WAECO International GmbH     ' +
     c                             'Fon: +49 (0)2572 879 - 419l          ' +
     c                             'E-Mail: gang@dometic-waeco.de        ' +
     c                             'Internet: http://www.dometic-waeco.de '+
     c                             #filler01
     c                   seton                                        40
     c                   write     phy02r
     C*
     C     ##_001        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_afrk    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     C*
      * :Rechnungskopf  -1-
     c     keysr_afrk    chain     AFRK01                             92
     C*
      * :Rechnungspositionen -2-
     c                   if        *in92 = '0'
     C     keysr_afrk    SETLL     AFRP01                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      AFRP01                                 95
     C                   IF        *in95 = '1'            or
     C                             RKFIRM   <>  RpFIRM    or
     C                             RKRGJJ   <>  RpRGJJ    or
     C                             RKRGNR   <>  RpRGNR    or
     C                             RKLIJJ   <>  RpLIJJ    or
     C                             RKLINR   <>  RpLINR
     C                   leave
     C                   else
     c                   exsr      sr_002
     c                   endif
     c                   enddo
     c                   endif
     c                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_002        BEGSR
     C*
      * :lesen ob Position im Lieferschein vorhanden ( nicht bei
      * :Gutschriften oder Nichlagerführungsartikel )
      * :Auftragslieferpositionen -3-
     c     keysr_aflp    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     c                   kfld                    Rplipo
     c     keysr_aflp    chain     #aflpl1                            96
     c   96              clear                   aflp1
     C*
      * :Kopfdaten Auftrag
     c     keysr_afko    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR

     c     keysr_afko    chain     afko01                             96
     c   96              clear                   afko1
     C*
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     C                   eval      unique_f = unique_f + 1
     C                   move      unique_f      #unique_f        10
     C                   movel     'M'           Paym              1
     C                   movel     ALTENR        #ALTENR          12
     C*
     c                   eval      typRecord = 'B'
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 '
     c                   movel     'D'           typRecord         1
     c                   endif
     c                   if        AKAFAT    = '50 ' or AKAFAT    = '70 ' or
     c                             AKAFAT    = '71 '
     c                   eval      typRecord = 'C'
     c                   endif
     c
     c
     C                   select
     C                   when      typRecord = 'B'
     C     #b            add       1             #b                5 0
     C                   movel     #b            #b#               5
     C                   when      typRecord = 'C'
     C     #c            add       1             #c                5 0
     C                   movel     #c            #c#               5
     C                   when      typRecord = 'D'
     C     #d            add       1             #d                5 0
     C                   movel     #d            #d#               5
     C                   when      typRecord = 'S'
     C     #s            add       1             #s                5 0
     C                   movel     #s            #s#               5
     C                   when      typRecord = 'V'
     C     #v            add       1             #v                5 0
     C                   movel     #v            #v#               5
     C                   when      typRecord = 'X'
     C     #x            add       1             #x                5 0
     C                   movel     #x            #x#               5
     C                   when      typRecord = 'K'
     C     #k            add       1             #k                5 0
     C                   movel     #k            #k#               5
     C                   when      typRecord = 'P'
     C     #p            add       1             #p                5 0
     C                   movel     #p            #p#               5
     C                   other
     C                   endsl
     c
     c                   clear                   typProd           1
     c                   eval      typProd   = '0'
     c****               eval      typProd   = 'A'
     c****                         Gewährleistungen?
     c                   clear                   artikelq1        10
     c                   clear                   artikelq2        10
     c                   clear                   artikelq3        12
     c                   clear                   artikelq4        10
     c                   z-add     alglmg        menge             5 0
     c                   move      menge         #menge            5
     c                   z-add     ALPREI        lpreis            9 2
     c                   move      lpreis        #lpreis           9
     c                   z-add     RPNESU        poswertn         11 2
     c                   move      poswertn      #poswertn        11
     c                   z-add     ALPREI        unitprice         9 2
     c                   move      unitprice     #unitprice        9
     c                   movel     ' '           CreditInit        1
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '71 '
     c                   movel     'C'           CreditInit        1
     c*                  CreditInit = ' '  bei gutschrift 'C'
     c                   endif
     c                   clear                   filler01         50
     c                   clear                   filler02         10
     C                   clear                   unique_fr        10 0
     c                   movel     '1Z880  '     KdrBill           7
     c                   movel     '1Z880  '     KdrOrder          7
     c                   movel     '1Z880  '     KdrDelev          7
     c
     c                   movel     '5000'        rab01             4
     c                   movel     '2500'        rab02             4
     c                   movel     '1000'        rab03             4
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
     c                             KdrBill                       +
     c                             KdrOrder                      +
     c                             KdrDelev                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             '0'                           +
     c                             alafnr                        +
     c                             '/01'                         +
     c                             %char(alafda)                 +
     c                             rklinr                        +
     c                             '/01'                         +
     c                             %char(allsda)                 +
     c                             rkrgnr                        +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c                             #ALTENR                       +
     c                             'WAE'                         +
     c                             ALTBZ1                        +
     c                             '          '                  +
     c                             artikelq1                     +
     c                             artikelq2                     +
     c                             artikelq3                     +
     c                             artikelq4                     +
     c                             '0000'                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             rab01                         +
     c                             rab02                         +
     c                             rab03                         +
     c                             '1900'                        +
     c                             #poswertn                     +
     c                             'N'                           +
     c                             AKREF1                        +
     c                             %subst(AKREF2:01:20)          +
     c                             '0000'                        +
     c                             #unitprice                    +
     c                             CreditInit                    +
     c                             %char(RKREDA)                 +
     c                             '00000000'                    +
     c                             #unique_f                     +
     c                             filler01                      +
     c                             filler02                      +
     c                             '00000000'                    +
     c                             %char(unique_fR)
     c                   write     phy02r
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
     C* sr_003: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_003        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $AFRK         ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'Z'                           +
     c                             #b#                           +
     c                             #c#                           +
     c                             #d#                           +
     c                             #s#                           +
     c                             #v#                           +
     c                             #x#                           +
     c                             #k#                           +
     c                             #p#                           +
     c                             #filler01
     c   40              write     phy02r
     C*
     C     ##_003        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C     *DTAARA       DEFINE                  unique_f         10 0
     C     *lock         IN        unique_f
     C
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

