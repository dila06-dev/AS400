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
     F* CHGDTAARA DTAARA(UNIQUE_F *ALL) VALUE(300082)            *
     F*              * letzte verwendete aus Datei               *
     F* CHGDTAARA DTAARA($AFR190626 *ALL) VALUE(1148)            *
     F*              * letzte verwendete aus Datei               *
     F* clrpfm cT_190629                                         *
     F* SELECT * FROM aful WHERE ULAFNR = '614608'               *
     F* für Unterposition                                        *
     F* 77 kein Aufbau mehr für CT (writes inaktiv)              *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  MobisPart interface zu Clifford Thames                       *
 MG01F*  Änderung:  11.02.2011                                   *
 MG01F*  Indicator = 'Y' wenn kein Positionswert bei D           *
     F*  N638:  252 ==> 'Y',  054 ==> 'A'                        *
     F*  immer jetzt  auf '00000000' initialisiert, da fehler    *
     F*  von Ford gemeldet und wird bei Mobis unterstellt        *
     F*  movel     '00000000'    #rkvada           8             *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#AFR190629up   e             disk    RENAME(#AFR190629:PHY01R)
     fcT_190629 if a e             disk    RENAME(cT_190629:PHY02R)
     fEDI_MOBIS if a e             disk    RENAME(EDI_mobisr:PHY03R)
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
     DxDate            S               D   DATFMT(*EUR)
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
     I              ct_190629                   sentence
     I
     I*-------------aus--#CT0501------------------------------------------------

     c                   seton                                        22

     c                   if        week   < 88
     c*                  if        week   = 4
     c                   if        status = '  '

     c                   seton                                        77
     c* JETZT ÜBER MOPBIS DIREKT
     c                   setoff                                       77
     C     *DTAARA       DEFINE                  $AFR190626       10 0
     C  n25*lock         IN        $AFR190626
     C  n25              eval      $AFR190626 =  $AFR190626  + 1
     C                   if        *in22      = '1'
     C  n25              out       $AFR190626
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
     c                   movea     '0000'        *IN(41)
     c                   eval      status = '10'
     c                   eval      #cc = $AFR190626
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
     c                   move      $AFR190626    ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'KSBA01WAEGERIMSGER'          +
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
     c   77              write     phy02r
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
      * :>>>>>>>>>>>>>>>>>>>>>>>
     c                   if        RKRGNR   <> '229506'
      * :>>>>>>>>>>>>>>>>>>>>>>>
     c                   clear                   phy02r
     c                   movel     '0'           typProd           1
     C                   eval      unique_f = unique_f + 1
     C                   move      unique_f      #unique_f        18
     C                   movel     'M'           Paym              1
     C                   movel     ALTENR        #ALTENR          12
     C*
     C* 15.03.2012
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
     c*****neu 31.08.2020
     c                   exsr      srmwst
     c                   if        MWSTSATZ   =  19,00000
     c                   movel     '1900'        mwst              4
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   movel     '1600'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c*****neu 06.08.2020
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
     c                   eval      sentence = 'KSBA01WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
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
     c* 15.03.2012
     c                             %subst(RPTENR:01:12)          +
     c                             'WAE'                         +
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
     c   77              write     phy02r
     c  n77              exsr      srCTneu
     c                   if        DEALER <> ' '
     c  n77              write     phy03r
     c                   endif
      * :>>>>>>>>>>>>>>>>>>>>>>>
     c                   endif
      * :>>>>>>>>>>>>>>>>>>>>>>>
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
     c*****neu 31.08.2020
     c                   exsr      srmwst2
     c                   if        MWSTSATZ   =  19,00000
     c                   movel     '1900'        mwst              4
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   movel     '1600'        mwst              4
     c                   endif
     c*****neu 31.08.2020
     c*****neu 06.08.2020
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
     c                   eval      sentence = 'KSBA01WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
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
     c                             'WAE'                         +
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
     c   77              write     phy02r
     c  n77              exsr      srCTneu
     c                   if        DEALER <> ' '
     c  n77              write     phy03r
     c                   endif
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
     c                   move      $AFR190626    ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'KSBA01WAEGERIMSGER'          +
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
     c********* Änderung gegenüber FORD
     c*********          kfld                    RKRAKD
     c                   kfld                    RKKDNR
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
     C* sr7000: Kunde Rechnung für MobisPart -1-   Mani
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
     c
     c     keysr7KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKKDNR
     c  n97keysr7KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrBill           7
     c   97              movel     KdrOrder      KdrBill
     c
     c     keysRKKDNR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKKDNR
     c*****              if        KdrBill    = *blank    24.04.2023
     c                   movel     RKRAKD        KdrBill
     c****** anja        movel     RKKDNR
     c  n97keysRKKDNR    chain     KDZR01                             97
     c   97              clear                   KDZRMIKD
     c  n97              movel     KDZRMIKD      KdrBill
     c*****              endif
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
     C+ SELECT substr(cT_190629, 333, 10)
     4+ into         :wert
     4+ from  cT_190629s
     C+ where substr(cT_190629, 82, 4) concat substr(cT_190629, 73, 9) =
     C+              :unique_ref
     c/end-exec
     C*
     C                   move      wert          #unique_fr       18

     C     ##8050        ENDSR

     C**************************************************************************
     C*Funktion *add
     C*-------------------------------------------------------------------------
     C*
     C     sr8055        BEGSR
     C*

     c     *LIKE         DEFINE    rkreda        #rkreda
     c                   eval      #rkreda = rkreda

     c/exec sql
     c+ whenever not found goto ##8055
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##8055
     c/end-exec
     c
     c/exec sql
     C+ select
     4+    (date(substr(char(:#rkreda), 1, 4) concat '-' concat
     4+          substr(char(:#rkreda), 5, 2) concat '-' concat
     C+          substr(char(:#rkreda), 7, 2)) +30 day)
     C+     into :xdate
     C+ FROM qsys2/qsqptabl
     c/end-exec
     C*
     C

     C     ##8055        ENDSR

     C**************************************************************************
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
     C+ SELECT substr(cT_190629, 333, 10)
     4+ into         :wert
     4+ from  cT_190629
     C+ where substr(cT_190629, 82, 4) concat substr(cT_190629, 73, 9) =
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
     C**************************************************************************
     C* srCTneu lesen aful für Unterpositionen über rechnungspositionen
     c*         sobald im Positionssatz der Rechnung eine Unterposition
     c*         gefüllt ist, muss der Unterpositionssatz gelesen werden,
     c*         da kein Lieferscheinsatz vorhanden ist
     C*-------------------------------------------------------------------------
     C*
     C     srCTneu       BEGSR
     C*
     c                   eval      DEALER       = KdrBill    +
     c                                            '         '
     c                   eval      ORDERNO      = %char(ALAFJJ)  +
     c                                            alafnr
     c                   evalr     LINECOUNT    = %char(ALAFPO)
     c     ' ':'0'       xlate     LINECOUNT     linecount
     c                   eval      ORDERDATE    =
     c                                     %subst(%char(alafda):07:02) +
     c                                     %subst(%char(alafda):05:02) +
     c                                     %subst(%char(alafda):01:04)
     c                   eval      DELIVERYNO   = %char(ALLIJJ)  +
     c                                            ALLINR
     c                   evalr     LINECOUNT2   = %char(ALlipo)
     c     ' ':'0'       xlate     LINECOUNT2    linecount2
     c                   eval      DELIVERYDA   =
     c                                     %subst(%char(allsda):07:02) +
     c                                     %subst(%char(allsda):05:02) +
     c                                     %subst(%char(allsda):01:04)
     c                   eval      INVOICENO    = %char(rkrgJJ)  +
     c                                            rkrgnr
     c                   eval      INVOICENO    = 'D082'               +
     c                                     %subst(%char(rkreda):03:06)
     c*
     c                   evalr     LINECOUNT3   = %char(RpLIpo)
     c     ' ':'0'       xlate     LINECOUNT3    linecount3
     c                   eval      INVOICEDAT   =
     c******                                     'L082'                +
     c******                                     'D082'                +
     c******                               %subst(%char(rkreda):01:04) +
     c******                               %subst(%char(rkreda):05:02) +
     c******                               %subst(%char(rkreda):07:02)
     c                                     %subst(%char(rkreda):07:02) +
     c                                     %subst(%char(rkreda):05:02) +
     c                                     %subst(%char(rkreda):01:04)
     c                   evalr     PARTSGROUP   = ALPRGR
     c     ' ':'0'       xlate     PARTSGROUP    PARTSGROUP
     c                   eval      PARTNO       = RPTENR
     c                   eval      DESCRIPTIO   = ALTBZ1 +
     c                                            ALTBZ2
     c                   if        ALPRGR    ='000'
     c                   eval      PARTNO       = ALTBZ1 +
     c                                            ALTBZ2
     c                   endif
     c*                  Sonderkosten auf Kopfebene
     c   41              z-add     1             m_faktor
     c   42              z-add     1             m_faktor
     c   43              z-add     1             m_faktor
     c   44              z-add     1             m_faktor
     c*                  Sonderkosten auf Kopfebene
     c   41              z-add     poswertn      RPBRSU
     c   42              z-add     poswertn      RPBRSU
     c   43              z-add     poswertn      RPBRSU
     c   44              z-add     poswertn      RPBRSU
     c                   clear                   x                13 0
     c                   eval      x            = menge*1
     c                   clear                   y                13 0
     c                   eval      y            = RPBRSU*100
     c                   clear                   z                13 0
     c                   if        x = 0
     c                   eval      x=100
     c                   endif
     c                   eval      z            = y/x*1
     c                   evalr     INVOICEQUA   = %char(x)
     c     ' ':'0'       xlate     INVOICEQUA    INVOICEQUA
     c                   evalr     DEALERNETU   = %char(z)
     c     ' ':'0'       xlate     DEALERNETU    DEALERNETU
     c     '-':'0'       xlate     DEALERNETU    DEALERNETU
     c                   evalr     DEALERNETS   = %char(y)
     c     ' ':'0'       xlate     DEALERNETS    DEALERNETS
     c     '-':'0'       xlate     DEALERNETS    DEALERNETS
     c                   eval      CURRENCY     = 'EUR'
     c                   if        CreditInit   = ' '
     c                   eval      CreditInit   = 'D'
     c                   endif
     c                   z-add     0,90          m_faktor          8 2
     c*                  Frachten
     c                   if        alprgr ='901'      or
     c                             alprgr ='905'      or
     c                             alprgr ='908'      or
     c                             alprgr ='909'      or
     c                             alprgr ='000'      or
     c                             %subst(alprgr:1:1) ='9'
     c                   z-add     1             m_faktor
     c                   endif
     c*                  Gutschriften
     c                   if        CreditInit   = 'C'
     c**************     z-add     1             m_faktor
     c                   endif
     c                   clear                   y2               13 0
     c                   eval      y2           = y*m_faktor
     c                   clear                   y3               13 0
     c                   eval      y3           = y2/x*1
     c                   evalr     MOBISNETU    = %char(y3)
     c     ' ':'0'       xlate     MOBISNETU     MOBISNETU
     c     '-':'0'       xlate     MOBISNETU     MOBISNETU
     c                   evalr     MOBISNETS    = %char(y2)
     c     ' ':'0'       xlate     MOBISNETS     MOBISNETS
     c     '-':'0'       xlate     MOBISNETS     MOBISNETS
     c                   eval      CURRENCY2    = 'EUR'
     c                   eval      REMARK       = AKREF1
     c                   eval      DEBITCREDI   = CreditInit
     c                   exsr      sr8055
     c                   clear                   INVDUEDATx       10
     c                   eval      INVDUEDATx   = %char(xdate:*iso)
     c
     c                   eval      INVDUEDATE   =
     c                                  %subst(INVDUEDATx:09:02) +
     c                                  %subst(INVDUEDATx:06:02) +
     c                                  %subst(INVDUEDATx:01:04)
     c
     c****                         %char (%date (#rkreda:*eur) :*iso)
     c*  ?????????                 %subst(%char(%date(rkreda)+30))
     c                   eval      FREE         = *blank
     c                   clear                   PARTSTYP
     c   41              if        RKKON1 ='ENT' or
     c                             RKKON1 ='F  ' or
     c                             RKKON1 ='POR' or
     c                             RKKON1 ='TRA' or
     c                             RKKON1 ='VER' or
     c                             RKKON1 ='VNK' or
     c                             RKKON1 ='VPK' or
     c                             RKKON1 ='LG3' or
     c                             RKKON1 ='VSK'
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c   42              if        RKKON2 ='ENT' or
     c                             RKKON2 ='F  ' or
     c                             RKKON2 ='POR' or
     c                             RKKON2 ='TRA' or
     c                             RKKON2 ='VER' or
     c                             RKKON2 ='VNK' or
     c                             RKKON2 ='VPK' or
     c                             RKKON2 ='LG3' or
     c                             RKKON2 ='VSK'
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c   43              if        RKKON3 ='ENT' or
     c                             RKKON3 ='F  ' or
     c                             RKKON3 ='POR' or
     c                             RKKON3 ='TRA' or
     c                             RKKON3 ='VER' or
     c                             RKKON3 ='VNK' or
     c                             RKKON3 ='VPK' or
     c                             RKKON3 ='LG3' or
     c                             RKKON3 ='VSK'
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c   44              if        RKKON4 ='ENT' or
     c                             RKKON4 ='F  ' or
     c                             RKKON4 ='POR' or
     c                             RKKON4 ='TRA' or
     c                             RKKON4 ='VER' or
     c                             RKKON4 ='VNK' or
     c                             RKKON4 ='VPK' or
     c                             RKKON4 ='LG3' or
     c                             RKKON4 ='VSK'
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   if        RPTENR ='LG3'
     c                   move      '0%          'free
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   if        RPTENR ='LG3'
     c                   move      '0%          'free
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   if        RPTENR ='LG3'
     c                   move      '0%          'free
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   if        RPTENR ='LG3'
     c                   move      '0%          'free
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   if        alprgr ='905'      or
     c                             alprgr ='909'      or
     c                             alprgr ='000'
     c                   eval      PARTSTYP     = 'F'
     c                   endif
     c                   eval      VAT          = mwst
     c                   eval      ORIGINV#     = %char(rkrgJJ)  +
     c                                            rkrgnr
     c                   eval      SUPPLIERC    = 'L082'
     c                   eval      SUPPLIERC    = 'D082'
     c*                  iso - 3166 3 stellig
     c                   eval      SUPPCOUNT    = 'DEU'
     c                   eval      BILLLOCAT    = 'DEU'
     c     code:konv     xlate     DESCRIPTIO    DESCRIPTIO
     C     ';':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     ',':'.'       xlate     DESCRIPTIO    DESCRIPTIO
     C     '"':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     '´':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     '`':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'ä':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'ü':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'ö':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'Ä':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'Ü':' '       xlate     DESCRIPTIO    DESCRIPTIO
     C     'Ö':' '       xlate     DESCRIPTIO    DESCRIPTIO
     c
     C*
     C     ##CTneu       ENDSR
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

