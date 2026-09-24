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

     f#AFRK01887up   e             disk    RENAME(#AFRK01887:PHY01R)
     fDOMINV_DK if a e             disk    RENAME(DOMINVF1:PHY02R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     fafko01    if   e           k disk
     fafad01    if   e           k disk
     fifap02    if   e           k disk

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

     c                   if        status = '  '

     C     *DTAARA       DEFINE                  $AFRK01887       10 0
     C  n25*lock         IN        $AFRK01887
     C  n25              eval      $AFRK01887 = $AFRK01887 + 1
     C  n25              out       $AFRK01887
     c                   seton                                        25
     C                   setoff                                       47
     c                   exsr      sr1000
     C                   exsr      sr_003
     c                   eval      status = '10'
     c                   eval      #cc = $AFRK01887
     c                   update    phy01r

     c                   endif
     Clr                 out       unique_f

     C**************************************************************************
     C* sr_001: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   EXPSTRING
     c
     c                   movel     'INVH      '  LineType         10
     c                   movel     '1.00      '  Version          10
     c                   clear                   Invoice#         20
     c                   evalr     Invoice#   = RKRGNR
     c                   movel     rkvada        #rkvada           8
     c     ' ':' '       xlate     #rkvada       #rkvada
     c                   movel     RKWACD        currency         10
     c                   movel     '100'         Vendor           20
     c                   movel     '0'           VatCalcl          1
     c                   movel     '1'           invCalcl          1
     c                   movel     RKKDNR        shipcode         20
     c                   movel     ADNAM1        name             50
     c                   movel     ADNAM2        name2            50
     c                   movel     ADSTRA        strasse          50
     c                   clear                   adr              50
     c                   movel     ADPOLZ        postCode         20
     c                   movel     ADWORT        city             30
     c                   movel     ADPOLD        country          50
     c                   clear                   ref              50
     c                   eval      ref =
     c                             'E-Mail: gang@dometic-waeco.de        '
     c                   move      $AFRK01887    ref
     c                   movel     'I '          invtyp            2
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '15 ' or AKAFAT    = '17 ' or
     c                             AKAFAT    = '20 '
     c                   movel     'G '          invtyp            2
     c                   endif
     c                   if        AKAFAT    = '10 ' or AKAFAT    = '10 '
     c                   movel     'R '          invtyp            2
     c                   endif
     c
     c                   eval      EXPSTRING =
     c                             LineType                      +
     c                             Version                       +
     c                             Invoice#                      +
     c                             %char(rkreda)                 +
     c                             #RKVADA                       +
     c                             %char(rkreda)                 +
     c                             currency                      +
     c                             Vendor                        +
     c                             VatCalcl                      +
     c                             invCalcl                      +
     c                             shipcode                      +
     c                             name                          +
     c                             name2                         +
     c                             strasse                       +
     c                             adr                           +
     c                             postCode                      +
     c                             city                          +
     c                             country                       +
     c                             ref                           +
     c                             invtyp
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
     C*
      * :Lieferadresse/Adresse bill
     c     keysr_afad    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR
     c                   kfld                    adposi
     c                   kfld                    adaart

     c                   clear                   adposi
     c                   movel     'ADAG'        adaart

     c     keysr_afad    chain     afad01                             97
     c   97              clear                   afad1
     C*
      * :lesen bezug Interface ifap -3-
     c     keysr_ifap    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_ifap    chain     ifap02                             97
     c   97              clear                   ifap1
     c   97              clear                   IFAPIFPO
     c   97              clear                   IFAPIFNR
      * :in jedem Fall lt. Trend
     C*
     C  n47              exsr      sr_001
     C                   seton                                        47
     c                   clear                   EXPSTRING
     C*
     c*******            z-add     ALPREI        unitprice         9 2
     c
     c********           evalr     OrderNr = %triml(lordernr : '0')
     c********           evalr     OrderNr = %trim(OrderNr)
     c
     c                   movel     'INVL      '  LineType         10
     c                   movel     '1.00      '  Version          10
     c                   move      RKRGNR        Invoice#         20
     c                   move      rplipo        position         10
     c****
      * :Position aus Interface
     c                   move      IFAPIFPO      position         10
     c****
     c                   clear                   shipment         20
     c                   move      almaaf        orderFR          20
     c                   clear                   orderFR          20
     c                   movel     ' '           IFAPIFNR
     c                   evalr     orderFR = %trim(IFAPIFNR)
     c                   if        almaaf  <> *blank
     c                   exsr      srbgfs
     c                   evalr     orderFR = %trim(a)
     c                   endif
     c
     c                   movel     '2  '         typ               3
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '71 ' or
     c                             AKAFAT    = '50 '
     c                   movel     '0  '         typ               3
     c                   endif
     c                   movel     RPTENR        artnum           20
     c                   movel     ALTBZ1        artdesc          50
     c                   z-add     100000        colli            13 0
     c                   clear                   menge            13 0
     c                   eval      menge=(alglmg*100000)
     c                   clear                   q1               13
     c                   clear                   q2               13
     c                   clear                   q3               13
     c                   evalr     q1     =      %char(menge)
     c                   evalr     q2     =      %char(colli)
     c                   evalr     q3     =      %char(menge)
     c                   clear                   price            13 0
     c                   clear                   #price           13
     c                   eval      price=(ALPREI*100000)
     c                   evalr     #price     = %char(price)
     c                   clear                   discountp        13
     c                   evalr     discountp = %char(0*100000)
     c                   clear                   discounta        13
     c
     c                   eval      #zb=(alwawt-alntsk)*100
     c                   clear                   discounta        13
     c                   evalr     discounta = %char(#zb)
     c******
     c     100           mult      ALNTSK        #zb              13 0
     c                   clear                   #poswertn        13
     c                   evalr     #poswertn = %char(#zb)
     c******
      * :abrechnung nicht in Line
     c                   clear                   linebill         13
     c                   evalr     linebill  = %char(0*100000)
     c******
     c     100           mult      ALNTSK        #zb              13 0
     c                   clear                   #amount          13
     c                   evalr     #amount   = %char(#zb)
     c******
      * :abrechnung nicht in Line
     c                   clear                   vatp             13
     c                   evalr     vatp      = %char(0*100000)
     c                   clear                   vatamount        13
     c                   evalr     vatamount = %char(0*100)
     c
     c     100           mult      ALNTSK        #zb              13 0
     c                   clear                   total            13
     c                   evalr     total     = %char(#zb)
     c
     c                   eval      EXPSTRING=
     c                             LineType                      +
     c                             Version                       +
     c                             Invoice#                      +
     c                             position                      +
     c                             shipment                      +
     c                             orderFR                       +
     c                             typ                           +
     c                             artnum                        +
     c                             artdesc                       +
     c                             q1                            +
     c                             q2                            +
     c                             q3                            +
     c                             #price                        +
     c                             discountp                     +
     c                             discounta                     +
     c                             #poswertn                     +
     c                             linebill                      +
     c                             #amount                       +
     c                             vatp                          +
     c                             vatamount                     +
     c                             total
     c                   write     phy02r
     c     linecount     add       1             linecount        10 0
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
     C* sr_003: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_003        BEGSR
     C*
     c                   clear                   EXPSTRING
     c                   movel     'INVT      '  LineType         10
     c                   movel     '1.00      '  Version          10
     c                   move      RKRGNR        Invoice#         20
     c                   clear                   #LineCount       10
     c                   evalr     #LineCount= %char(LineCount)
     c
     c                   eval      #zb =(RknesU+RKNES2+
     c                                   RKNES3) *100
     c                   clear                   lamount          13
     c                   evalr     lamount   = %char(#zb)
     C*
     c                   eval      #zb=(rkerg1+rkerg2+rkerg3+
     c                                  rkerg4)*100
     c                   clear                   discount         13
     c                   evalr     discount  = %char(#zb)
     C*
     c                   eval      #zb =(RknesU+RKNES2+
     c                                   RKNES3) *100
     c                   clear                   totalmount       13
     c                   evalr     totalmount= %char(#zb)
     C*
     C*          kann mehrere Sätze geben
     c     10000         mult      0             #zb              13 0
     c                   clear                   vatproz          13
     c                   evalr     vatproz   = %char(#zb)
     C*
     c                   eval      #zb =(RKMWS1+RKMWS2+
     c                                   RKMWS3) *100
     c                   evalr     vatamount = %char(#zb)
     C*
     c                   eval      #zb=(RKBRSU*100)
     c                   clear                   totalbill        13
     c                   evalr     totalbill = %char(#zb)
     C*
     c                   eval      EXPSTRING =
     c                             LineType                      +
     c                             Version                       +
     c                             Invoice#                      +
     c                             #LineCount                    +
     c                             lamount                       +
     c                             discount                      +
     c                             totalmount                    +
     c                             vatproz                       +
     c                             vatamount                     +
     c                             totalbill
     c   40              write     phy02r
     c                   clear                   LineCount
     C*
     C     ##_003        ENDSR
     C*
     C**************************************************************************
     C*Funktion *insert
     C*-------------------------------------------------------------------------
     C*
     C     srbgfs        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##bgfs
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##bgfs
     c/end-exec

     c                   clear                   a                 6
     c/exec sql
     C+ SELECT substr(AU3090, 1, 6)
     4+        into :a
     4+ FROM sbgau300
     C+ WHERE AU3030 = :almaaf
     c/end-exec
     C*

     C     ##bgfs        ENDSR

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
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
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

