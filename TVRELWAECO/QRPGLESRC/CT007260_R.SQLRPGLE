     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F* ganz wichtig: fortlaufende Nummer wird gefordert         *
     F* Clr 22              out       unique_f                   *
     F*                                                          *
     F* update #afrk_f set status = ' ', #cc= 0 whERE #CC = 1149 *
     F*                                                          *
     F* CHGDTAARA DTAARA(UNIQUE_F *ALL) VALUE(339973)            *
     F*              * letzte verwendete aus Datei               *
     F* CHGDTAARA DTAARA($AFRK_FORD *ALL) VALUE(1148)            *
     F*              * letzte verwendete aus Datei               *
     F* clrpfm ct_ford                                           *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  Ford interface zu Clifford Thames                       *
 MG01F*  Änderung:  11.02.2011                                   *
 MG01F*  Indicator = 'Y' wenn kein Positionswert bei D           *
     F*  N638:  252 ==> 'Y',  054 ==> 'A'                        *
     F*  immer jetzt  auf '00000000' initialisiert, da fehler    *
     F*  von Ford gemeldet                                       *
     F*  movel     '00000000'    #rkvada           8             *
     F*                                                          *
     F*  15.03.2012 AFUL implementieren wegen Auflösung Stück-   *
     F*             listenauflösung                              *
     F*Analyse Ford Zentrallager                                 *
     F*SELECT AKKDNR, KDNAM1,KDWORT,APTENR, APTBZ1, APPRGR
     F*,dec(sum(apglmg), 13, 2) Absatz , AKAFAT,substr(char(rkreda), 1, 4)
     F*jahr, dec(sum(RPBRSU), 13, 2) Umsatz FROM statistik , kund01 WHERE
     F*AKKDNR in ('098749', '098750') and substr(char(rkreda), 1, 4) in
     F*('2012','2011')and akkdnr=kdkdnr and kdfirm = '01' GROUP BY
     F*AKKDNR,KDNAM1,KDWORT , APTENR, APTBZ1,
     F*APPRGR,AKAFAT,substr(char(rkreda), 1, 4) ORDER BY
     F*substr(char(rkreda), 1, 4),AKKDNR, APTENR
     F*Datei FORDDIREKT in TVRELWAECO wurde erstellt.            *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*Analyse Ford Central billing                              *
     F*                                                          *
     F*SELECT APTENR, APTBZ1, APPRGR, dec(sum(apglmg), 13, 2) Absatz ,
     F*AKAFAT,substr(char(rkreda), 1, 4) jahr, dec(sum(RPBRSU), 13, 2)
     F*Umsatz FROM statistik WHERE AKDBKD in ('007260', '007260') and
     F*substr(char(rkreda), 1, 4) in ('2012','2011') GROUP BY APTENR,
     F*APTBZ1, APPRGR,AKAFAT,substr(char(rkreda), 1, 4) ORDER BY
     F*substr(char(rkreda), 1, 4) , APTENR
     F*Datei CT_BILLING in TVRELWAECO wurde erstellt.            *
     F*__________________________________________________________*
     F*1.) Vergleichsdaten holen                                 *
     F*                                                          *
     F* insert into ct_ford                                      *
     F* SELECT * FROM ct_fords WHERE CT_FORD like '%0001421'     *
     F*                                                          *
     F*2.) um eins erhöhen je record                             *
     F*    CHGDTAARA DTAARA(UNIQUE_F *ALL) VALUE(329997)         *
     F*    um eins erhöhen je batchlauf                          *
     F*    CHGDTAARA DTAARA($AFRK_FORD *ALL) VALUE(1468)         *
     F*                                                          *
     F*3.) Daten anpassen in ct_ford                             *
     F*                                                          *
     F*4.) übertragen mit Option:    order by   ct_ford          *
     F*                                                          *
     F*5.) in Sicherung übernehmen                               *
     F*    insert into ct_fords                                  *
     F*    SELECT * FROM ct_ford                                 *
     F*    order by   ct_ford                                    *
     F*                                                          *
     F*6.) Sicherung datei clearen                               *
     F*    clrpfm ct_ford                                        *
     F*                                                          *
     F*7.) Übertragunsoption rausnehmen order by ct_ford         *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#afrk_f   up   e             disk    RENAME(#afrk_f:PHY01R)
     fcT_ford   if a e             disk    RENAME(cT_ford:PHY02R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     f#afulL1   if   e           k disk
     fafko01    if   e           k disk
     fkund01    if   e           k disk
     fKDZR01    if   e           k disk
     ftxbe01    if   e           k disk
     ftrtp01    if   e           k disk
     fteil01    if   e           k disk
     fmwst01    if   e           k disk

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
     Dweek             s              1s 0
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

     c                   seton                                        22

     c                   if        week   = 5
     c                   if        status = '  '
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *DTAARA       DEFINE                  $AFRK_FORD       10 0
     C  n25*lock         IN        $AFRK_FORD
     C  n25              eval      $AFRK_FORD =  $AFRK_FORD  + 1
     C                   if        *in22      = '1'
     C  n25              out       $AFRK_FORD
     C                   endif
     C  n25              exsr      sr_001
     c                   seton                                        25
     c                   exsr      sr1000
     c                   if        rkerg1 <> *zero
     c                   movea     '1000'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg2 <> *zero
     c                   movea     '0100'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg3 <> *zero
     c                   movea     '0010'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg4 <> *zero
     c                   movea     '0001'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   eval      status = '10'
     c                   eval      #cc = $AFRK_FORD
     c   22              update    phy01r

     c                   endif
     c                   endif
     Clr                 exsr      sr_003
     Clr 22              out       unique_f

     C**************************************************************************
     C* sr_001: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $AFRK_ford    ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201DOMGERIMSGER'          +
     c****                         'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'A'                           +
     c                             %subst(##tst:01:04)           +
     c                             %subst(##tst:06:02)           +
     c                             %subst(##tst:09:02)           +
     c                             %subst(##tst:12:02)           +
     c                             %subst(##tst:15:02)           +
     c                             %subst(##tst:18:02)           +
     c                             %subst(##tst:21:02)           +
     c                             'Manfred Gang Dometic WAECO Int.GmbH     ' +
     c                             '+49 (0)2572 879 - 419   '                 +
     c                             'E-Mail: gang@dometic-waeco.de '           +
     c                             'Internet: http://www.dometic-waeco.de   ' +
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
     c                   movel     '0'           typProd           1
     C                   eval      unique_f = unique_f + 1
     C                   move      unique_f      #unique_f        18
     C                   movel     'M'           Paym              1
     C                   movel     ALTENR        #ALTENR          12
     C*
     c* 15.03.2012                                               +
     C                   if        RPUPOS  <> 0
     C                   z-add     RPNESU        ALNESU
     C                   exsr      sr9020
     C                   endif
     C*
     c                   eval      typRecord = 'B'
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 '
     c                   movel     'D'           typRecord         1
     c****               Achtung da Gewährleistung typProd = 'A'
     c                   movel     'A'           typProd           1
     c                   endif
     c                   if        AKAFAT    = '50 ' or AKAFAT    = '70 ' or
     c                             AKAFAT    = '71 ' or AKAFAT    = '82 '
     c                   eval      typRecord = 'C'
     c                   endif
     c
     c                   if        ALMWCD  = '16'
     c                   movel     '1900'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c                   exsr      srmwst
     c                   if        MWSTSATZ   =  19,00000
     c                   movel     '1900'        mwst              4
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   movel     '1600'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c*****neu 29.07.2020
     c                   clear                   p                11 2
     c                   eval      p = (rkmws1*1)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c
     c
     c     ALKOW1        mult      100           kon1              4 0
     c     ALKOW2        mult      100           kon2              4 0
     c     ALKOW3        mult      100           kon3              4 0
     c     ALKOW4        mult      100           kon4              4 0
     c     kon1          mult      -1            kon1
     c     kon2          mult      -1            kon2
     c     kon3          mult      -1            kon3
     c     kon4          mult      -1            kon4
     c                   movel     kon1          #kon1             4
     c                   movel     kon2          #kon2             4
     c                   movel     kon3          #kon3             4
     c                   movel     kon4          #kon4             4
     c     ' ':'0'       xlate     #kon1         #kon1
     c     ' ':'0'       xlate     #kon2         #kon2
     c     ' ':'0'       xlate     #kon3         #kon3
     c     ' ':'0'       xlate     #kon4         #kon4
     c
     c                   movel     rkvada        #rkvada           8
     c                   movel     '00000000'    #rkvada           8
     c     ' ':'0'       xlate     #rkvada       #rkvada
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
     C     ' ':'0'       xlate     #b#           #b#
     C     ' ':'0'       xlate     #c#           #c#
     C     ' ':'0'       xlate     #d#           #d#
     C     ' ':'0'       xlate     #s#           #s#
     C     ' ':'0'       xlate     #v#           #v#
     C     ' ':'0'       xlate     #x#           #x#
     C     ' ':'0'       xlate     #k#           #k#
     C     ' ':'0'       xlate     #p#           #p#
     c
     c                   clear                   artikelq2        10
     c                   clear                   artikelq3        12
     c                   clear                   artikelq4        10
     c                   movel     '0000'        weight            4
     c                   z-add     alglmg        menge             5 0
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   move      menge         #menge            5
     c                   z-add     ALPREI        lpreis            9 2
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   z-add     ALNTSK        poswertn         11 2
     c                   z-add     ALNESU        poswertn         11 2
     c                   if        poswertn   < 0
     c                   eval      poswertn=poswertn   * -1
     c                   endif
     c                   move      poswertn      #poswertn        11
 MG01c                   movel     'N'           indicator         1
 MG01c                   if        poswertn = 0
 MG01c                   movel     'Y'           indicator         1
 MG01c                   endif
     c                   clear                   unitpnetto        9 2
     c                   eval      unitpnetto = (poswertn/alglmg)
     c                   if        unitpnetto < 0
     c                   eval      unitpnetto = unitpnetto * -1
     c                   endif
     c                   move      unitpnetto    #unitpnetto       9
     c                   movel     ' '           CreditInit        1
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '71 ' or
     c                             AKAFAT    = '82 ' or AKAFAT    = '71 '
     c                   movel     'C'           CreditInit        1
     c*                  CreditInit = ' '  bei gutschrift 'C'
     c                   endif
     c                   clear                   filler01         50
     c                   clear                   kiaHyundai       10
     c
     c                   exsr      sr5000
     c                   exsr      sr6000
     c                   exsr      sr7000
     c                   if        KdrOrder  = KdrDelev
     c                   clear                   KdrDelev
     c                   endif
     c
     c                   movel     '5000'        rab01             4
     c                   movel     '2500'        rab02             4
     c                   movel     '1000'        rab03             4
     c                   movel     ALAFPO        #alafpo           4
     c                   movel     ALlipo        #allipo           4
     c
     C                   clear                   #unique_fr       18
     c                   if        typRecord = 'C'
     c                   exsr      sr8000
     c                   clear                   xpos              2 0
     c                   clear                   ypos              2 0
     c                   movel     '0000000000'  wert             10
     c                   eval      xpos = %scan(' ': unique_fr)
     c                   eval      xpos = xpos - 1
     c                   eval      ypos = 10 - xpos
     c                   eval      ypos = ypos + 1
     c                   if        xpos <> 0 and xpos <> -1
     c                   eval      %subst(wert: ypos: xpos) =
     c                             %subst(unique_fr: 1: xpos)
     C                   endif
     C                   move      wert          #unique_fr       18
     c                   exsr      sr8050
     c                   if        wert = '0000000000' or
     c                             wert = '          '
     c                   exsr      sr8060
     c                   endif
     c***                Korrektur auf 'D', wenn keine C-Referenz
 MG02c                   if        wert = '0000000000' or
 MG02c                             wert = '          '
 MG02c                   movel     'D'           typRecord         1
 MG02c                   movel     'A'           typProd           1
 MG02C                   clear                   #unique_fr       18
     c                   movel     'C'           CreditInit        1
 MG02c                   endif
     c                   endif
     c
     c                   if        AKREF1 = ' ' and
     c                             %subst(AKREF2:01:20) = ' ' and
     c                             typRecord = 'C'
     c                   movel     'Gutschrift'  AKREF1
     c                   endif
     c
     c                   eval      sentence = 'SBP201DOMGERIMSGER' +
     c***                eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'DOMGER'                      +
     c****                         'WAEGER'                      +
     c                             KdrBill                       +
     c                             KdrOrder                      +
     c                             KdrDelev                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             alafnr                        +
     c                             %subst(#ALAFPO:2:3)           +
     c                             %char(alafda)                 +
     c                             ALLINR                        +
     c                             %subst(#ALlipo:2:3)           +
     c*******                      %subst(%char(allipo):1:3)     +
     c                             %char(allsda)                 +
     c                             rkrgnr                        +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c* 15.03.2012                                               +
     c                             %subst(RPTENR:01:12)          +
     c                             'DOM'                         +
     c***                          'WAE'                         +
     c                             ALTBZ1                        +
     c                             '          '                  +
     c                             ALPRGR                        +
     c                             '      '                      +
     c                             artikelq2                     +
     c                             artikelq3                     +
     c                             artikelq4                     +
     c                             weight                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             #kon1                         +
     c                             #kon2                         +
     c                             #kon3                         +
     c                             mwst                          +
     c                             #poswertn                     +
 MG01c                             indicator                     +
     c                             AKREF1                        +
     c                             %subst(AKREF2:01:20)          +
     c                             #kon4                         +
     c                             #unitpnetto                   +
     c                             CreditInit                    +
     c                             #rkvada                       +
     c                             #unique_f                     +
     c                             filler01                      +
     c****************************************
     c                             kiaHyundai                    +
     c                             #unique_fR
     c                   write     phy02r
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Zu.- und Abschläge nicht positionsgebunden
     C*-------------------------------------------------------------------------
     C*
     C     sr_002b       BEGSR
     C*
     c                   clear                   phy02r
     c   41              movel     rkkon1        #rkkon           10
     c   42              movel     rkkon2        #rkkon           10
     c   43              movel     rkkon3        #rkkon           10
     c   44              movel     rkkon4        #rkkon           10
     c                   exsr      sr8250
     c                   movel     'B'           typRecord         1
     c                   movel     '0'           typProd           1
     C                   eval      unique_f = unique_f + 1
     C                   move      unique_f      #unique_f        18
     C                   movel     'M'           Paym              1
     C*
     c
     c   41              if        rkerg1 <    0
     c   41              movel     'D'           typRecord         1
     c   41              movel     'A'           typProd           1
     c                   endif
     c   42              if        rkerg2 <    0
     c   42              movel     'D'           typRecord         1
     c   42              movel     'A'           typProd           1
     c                   endif
     c   43              if        rkerg3 <    0
     c   43              movel     'D'           typRecord         1
     c   43              movel     'A'           typProd           1
     c                   endif
     c   44              if        rkerg4 <    0
     c   44              movel     'D'           typRecord         1
     c   44              movel     'A'           typProd           1
     c                   endif
     c
     c
     c                   if        ALMWCD  = '16'
     c                   movel     '1900'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c                   exsr      srmwst2
     c                   if        MWSTSATZ   =  19,00000
     c                   movel     '1900'        mwst              4
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   movel     '1600'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c*****neu 29.07.2020
     c                   clear                   p                11 2
     c                   eval      p = (rkmws1*1)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c
     c
     c                   movel     rkvada        #rkvada           8
     c                   movel     '00000000'    #rkvada           8
     c     ' ':'0'       xlate     #rkvada       #rkvada
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
     C     ' ':'0'       xlate     #b#           #b#
     C     ' ':'0'       xlate     #c#           #c#
     C     ' ':'0'       xlate     #d#           #d#
     C     ' ':'0'       xlate     #s#           #s#
     C     ' ':'0'       xlate     #v#           #v#
     C     ' ':'0'       xlate     #x#           #x#
     C     ' ':'0'       xlate     #k#           #k#
     C     ' ':'0'       xlate     #p#           #p#
     c
     c                   clear                   artikelq2        10
     c                   clear                   artikelq3        12
     c                   clear                   artikelq4        10
     c                   movel     '0000'        weight            4
     c                   z-add     1             menge             5 0
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   move      menge         #menge            5
     c                   z-add     ALPREI        lpreis            9 2
     c   41              z-add     rkerg1        lpreis
     c   42              z-add     rkerg2        lpreis
     c   43              z-add     rkerg3        lpreis
     c   44              z-add     rkerg4        lpreis
     c                   if        lpreis< 0
     c                   eval      lpreis= lpreis * -1
     c                   endif
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   z-add     ALNTSK        poswertn         11 2
     c                   z-add     ALNESU        poswertn         11 2
     c   41              z-add     rkerg1        poswertn
     c   42              z-add     rkerg2        poswertn
     c   43              z-add     rkerg3        poswertn
     c   44              z-add     rkerg4        poswertn
     c                   if        poswertn   < 0
     c                   eval      poswertn=poswertn   * -1
     c                   movel     'C'           CreditInit        1
     c                   endif
     c                   move      poswertn      #poswertn        11
 MG01c                   movel     'N'           indicator         1
 MG01c                   if        poswertn = 0
 MG01c                   movel     'Y'           indicator         1
 MG01c                   endif
     c                   clear                   unitpnetto        9 2
     c                   eval      unitpnetto = (poswertn/ 00001)
     c                   if        unitpnetto < 0
     c                   eval      unitpnetto = unitpnetto * -1
     c                   endif
     c                   move      unitpnetto    #unitpnetto       9
     c                   clear                   filler01         50
     c                   clear                   kiaHyundai       10
     c
     c                   exsr      sr5000
     c                   exsr      sr6000
     c                   exsr      sr7000
     c                   if        KdrOrder  = KdrDelev
     c                   clear                   KdrDelev
     c                   endif
     c
     c                   movel     '5000'        rab01             4
     c                   movel     '2500'        rab02             4
     c                   movel     '1000'        rab03             4
     c   41              movel     '0001'        #alafpo           4
     c   41              movel     '0001'        #allipo           4
     c   42              movel     '0002'        #alafpo           4
     c   42              movel     '0002'        #allipo           4
     c   43              movel     '0003'        #alafpo           4
     c   43              movel     '0003'        #allipo           4
     c   44              movel     '0004'        #alafpo           4
     c   44              movel     '0004'        #allipo           4
     c
     C                   clear                   #unique_fr       18
     c                   if        typRecord = 'C'
     c                   exsr      sr8000
     c                   clear                   xpos              2 0
     c                   clear                   ypos              2 0
     c                   movel     '0000000000'  wert             10
     c                   eval      xpos = %scan(' ': unique_fr)
     c                   eval      xpos = xpos - 1
     c                   eval      ypos = 10 - xpos
     c                   eval      ypos = ypos + 1
     c                   if        xpos <> 0 and xpos <> -1
     c                   eval      %subst(wert: ypos: xpos) =
     c                             %subst(unique_fr: 1: xpos)
     C                   endif
     C                   move      wert          #unique_fr       18
     c                   exsr      sr8050
     c                   if        wert = '0000000000' or
     c                             wert = '          '
     c                   exsr      sr8060
     c                   endif
     c***                Korrektur auf 'D', wenn keine C-Referenz
 MG02c                   if        wert = '0000000000' or
 MG02c                             wert = '          '
 MG02c                   movel     'D'           typRecord         1
 MG02c                   movel     'A'           typProd           1
     c                   movel     'C'           CreditInit        1
 MG02C                   clear                   #unique_fr       18
 MG02c                   endif
     c                   endif
     c
     c                   movel     TPTTXT        ALTBZ1
     c                   movel     '000'         ALPRGR
     c                   clear                   #kon1
     c                   clear                   #kon2
     c                   clear                   #kon3
     c                   clear                   #kon4
     c     ' ':'0'       xlate     #kon1         #kon1
     c     ' ':'0'       xlate     #kon2         #kon2
     c     ' ':'0'       xlate     #kon3         #kon3
     c     ' ':'0'       xlate     #kon4         #kon4
     c
     c                   if        AKREF1 = ' ' and
     c                             %subst(AKREF2:01:20) = ' ' and
     c                             typRecord = 'C'
     c                   movel     'Gutschrift'  AKREF1
     c                   endif
     c
     c*25.10.2012 creditInit immer *blank bei typ 'B'
     c*sind bei Ford durchgelaufen, soll aber lt. CT nicht sein
     c*bei Mobis liefen sie stattdessen auf eine Fehlermeldung
     c                   if        typRecord = 'B'
     c                   clear                   CreditInit
     c                   endif
     c
     c                   eval      sentence = 'SBP201DOMGERIMSGER' +
     c***                eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'DOMGER'                      +
     c***                          'WAEGER'                      +
     c                             KdrBill                       +
     c                             KdrOrder                      +
     c                             KdrDelev                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             alafnr                        +
     c                             %subst(#ALAFPO:2:3)           +
     c                             %char(alafda)                 +
     c                             ALLINR                        +
     c                             %subst(#ALlipo:2:3)           +
     c*******                      %subst(%char(allipo):1:3)     +
     c                             %char(allsda)                 +
     c                             rkrgnr                        +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c                             %subst(TPTTXT:01:12)          +
     c                             'DOM'                         +
     c****                         'WAE'                         +
     c                             ALTBZ1                        +
     c                             '          '                  +
     c                             ALPRGR                        +
     c                             '      '                      +
     c                             artikelq2                     +
     c                             artikelq3                     +
     c                             artikelq4                     +
     c                             weight                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             #kon1                         +
     c                             #kon2                         +
     c                             #kon3                         +
     c                             mwst                          +
     c                             #poswertn                     +
 MG01c                             indicator                     +
     c                             AKREF1                        +
     c                             %subst(AKREF2:01:20)          +
     c                             #kon4                         +
     c                             #unitpnetto                   +
     c                             CreditInit                    +
     c                             #rkvada                       +
     c                             #unique_f                     +
     c                             filler01                      +
     c****************************************
     c                             kiaHyundai                    +
     c                             #unique_fR
     c                   write     phy02r
     C*
     C     ##_002b       ENDSR
     C*
     C**************************************************************************
     C* sr_003: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_003        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $AFRK_ford    ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201DOMGERIMSGER'          +
     c***                          'SBP201WAEGERIMSGER'          +
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
     C* sr5000: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     keysr5kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRAKD
     c
     c     keysr5kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr5KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDKDNR
     c
     c  n97keysr5KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrOrder          7
     c   97              clear                   KdrOrder
     c
     C*
     C     ##5000        ENDSR
     C*
     C**************************************************************************
     C* sr6000: direkter Warenempfänger  -3-
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c     keysr6kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKSTKD
     c
     c     keysr6kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr6KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDKDNR
     c
     c  n97keysr6KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrDelev          7
     c   97              clear                   KdrDelev
     c
     C*
     C     ##6000        ENDSR
     C*
     C**************************************************************************
     C* sr7000: Kunde Rechnung für Ford -1-
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
     C*
     c     keysr7kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRAKD
     c
     c     keysr7kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr7KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDRAKD
     c
     c  n97keysr7KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrBill           7
     c   97              movel     KdrOrder      KdrBill
     c
     C*
     C     ##7000        ENDSR
     C*
     C**************************************************************************
     C* sr8000: unique ziehen über text
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*
     c     keysr_txbe    klist
     c                   kfld                    RKFIRM
     c                   kfld                    TBTXAR
     c                   kfld                    RPAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     c                   kfld                    TBUPOS
     c                   kfld                    TBTCDE
     c
     c
     c                   movel     'AFDA      '  TBTXAR
     c                   clear                   TBUPOS
     c                   movel     'TXPO      '  TBTcde
     c
     c     keysr_txbe    chain     txbe01                             97
     c   97              clear                   txbe1
     c
     c  n97              movel     TBTEXT        unique_fr        10
     c  n97              movel     TBTEXT        unique_ref       13
     c   97              clear                   unique_fr
     c   97              clear                   unique_ref
     c
     C*
     C     ##8000        ENDSR
     C*
     C**************************************************************************
     C*Funktion *insert unique#
     C*-------------------------------------------------------------------------
     C*
     C     sr8050        BEGSR
     C*

     c                   movel     '0000000000'  wert             10

     c/exec sql
     c+ whenever not found goto ##8050
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##8050
     c/end-exec

     c/exec sql
     C+ SELECT substr(CT_FORD, 333, 10)
     4+ into         :wert
     4+ from  ct_fords
     C+ where substr( CT_FORD, 82, 4) concat substr( CT_FORD, 73, 9) =
     C+              :unique_ref
     c/end-exec
     C*
     C                   move      wert          #unique_fr       18

     C     ##8050        ENDSR

     C**************************************************************************
     C**************************************************************************
     C*Funktion *insert unique#
     C*-------------------------------------------------------------------------
     C*
     C     sr8060        BEGSR
     C*

     c                   movel     '0000000000'  wert             10

     c/exec sql
     c+ whenever not found goto ##8060
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##8060
     c/end-exec

     c/exec sql
     C+ SELECT substr(CT_FORD, 333, 10)
     4+ into         :wert
     4+ from  ct_ford
     C+ where substr( CT_FORD, 82, 4) concat substr( CT_FORD, 73, 9) =
     C+              :unique_ref
     c/end-exec
     C*
     C                   move      wert          #unique_fr       18

     C     ##8060        ENDSR

     C**************************************************************************
     C* sr8250: lesen trtp
     C*-------------------------------------------------------------------------
     C*
     C     sr8250        BEGSR
     C*
     c     keysr_trtp    klist
     c                   kfld                    RKFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c
     c                   movel     'D'           TPSPCD
     c                   movel     'RBAT      '  TPTART
     c                   movel     #rkkon        TPTCDE
     c
     c     keysr_trtp    chain     trtp01                             97
     c   97              clear                   TPTTXT
     c
     C*
     C     ##8250        ENDSR
     C*
     C**************************************************************************
     C* sr9020: lesen aful für Unterpositionen über rechnungspositionen
     c*         sobald im Positionssatz der Rechnung eine Unterposition
     c*         gefüllt ist, muss der Unterpositionssatz gelesen werden,
     c*         da kein Lieferscheinsatz vorhanden ist
     C*-------------------------------------------------------------------------
     C*
     C     sr9020        BEGSR
     C*
     c     keysr_aful    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPLIJJ
     c                   kfld                    RPLINR
     c                   kfld                    RPLIPO
     c                   kfld                    RPUPOS
     c
     c     keysr_aful    chain     #AFULL1                            91
     c  n91              z-add     ulglmg        alglmg
     c  n91              z-add     ULPREI        ALPREI
     c
     c     KEY2030       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     rptenr        TETENR
     C*
     c     KEY2030       chain     teil01                             98
     c  n98              movel     TETBZ1        ALTBZ1
     C*
     C     ##9020        ENDSR
     C*
     C**************************************************************************
     C* srmwst: lesen mwst
     C*-------------------------------------------------------------------------
     C*
     C     srmwst        BEGSR
     C*
     c     keysr_mwst    klist
     c                   kfld                    MWSTFIRM
     c                   kfld                    MWSTMWCD
     c                   kfld                    MWSTGADA
     c
     c                   movel     '01'          MWSTFIRM
     c                   movel     RPMWCD        MWSTMWCD
     c                   z-add     ALLSDA        MWSTGADA
     c
     c     keysr_mwst    SETgt     MWST01                             95
     c     *IN95         IFEQ      '0'
     c                   DO        *HIVAL
     c                   READp     MWST01                                 95
     c                   IF        *in95 = '1' or
     c                             RPMWCD   <>   MWSTMWCD
     c                   leave
     c                   else
     c                   z-add     MWSTSATZ      MWSTSATZ
     c                   leave
     c                   endif
     c                   enddo
     c                   endif
     C*
     C     ##mwst        ENDSR
     C*
     C**************************************************************************
     C* srmwst: lesen mwst2
     C*-------------------------------------------------------------------------
     C*
     C     srmwst2       BEGSR
     C*
     c                   movel     '01'          MWSTFIRM
     c   41              movel     RKMWC1        MWSTMWCD
     c   42              movel     RKMWC2        MWSTMWCD
     c   43              movel     RKMWC3        MWSTMWCD
     c   44              movel     RKMWC1        MWSTMWCD
     c                   z-add     ALLSDA        MWSTGADA
     c
     c     keysr_mwst    SETgt     MWST01                             95
     c     *IN95         IFEQ      '0'
     c                   DO        *HIVAL
     c                   READp     MWST01                                 95
     c                   IF        *in95 = '1' or
     c                             RPMWCD   <>   MWSTMWCD
     c                   leave
     c                   else
     c                   z-add     MWSTSATZ      MWSTSATZ
     c                   leave
     c                   endif
     c                   enddo
     c                   endif
     C*
     C     ##mwst2       ENDSR
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
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0)
     c+ into   :tstampi, :datum, :datum2, :zeit, :week
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

