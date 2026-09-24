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
     F*  mg01  Anpassung auf Rel 1.2 (Dateierweiterung)          *
     F*        Übergabe von max. 3 Zu.- oder Abschlägen          *
     F*        Änderung: 07.02.2011                              *
     F*        keine nagativen Rabatte möglich                   *
     F*                                                          *
     F*        edvaludatu   initialisiert Berthold 24.03.11      *
     F*        edformatvd    "                                   *
     F*  Korrektur                                               *
     F*  _________                                               *
     F*  SELECT * FROM edi_techps where substr(EDLSNUMMER, 10, 6)*
     F*  in (select rklinr from #afrk11016 where #cc = 8         *
     F*  and rklijj = substr(EDLSNUMMER, 6, 4)                   *
     F*  and rklinr = substr(EDLSNUMMER, 10, 6)                  *
     F*  and RKRGNR = substr(EDBELEGNR, 10, 6)                   *
     F*  and RKRGJJ = substr(EDBELEGNR, 6, 4))                   *
     F*                                                          *
     F*
     F* SELECT RPRGNR ,akrakd, EDI_TECHPS.EDDART, EDI_TECHPS.EDBELEGNR,
     F* EDI_TECHPS.EDRECHNR FROM statistik , edi_techps WHERE (AKAFAT =
     F* '82' and AKRAKD ='011016' ) and rprgnr = substr(edrechnr, 10, 6)
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#afrk11016up   e             disk    RENAME(#afrk11016:PHY01R)
     fEdi_techp if a e             disk    RENAME(EDI_TECHPR:PHY02R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     fafko01    if   e           k disk
     fkund01    if   e           k disk
     fKDZR01    if   e           k disk
     ftxbe01    if   e           k disk
     fafad01    if   e           k disk
     ftrtp01    if   e           k disk
     f#afulL1   if   e           k disk
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

     I*-------------aus--#CT0501------------------------------------------------

     c                   if        week   = 5
     c                   if        status = '  '
     c*                  if        rKRGNR = '159362' or
     c*                            rKRGNR = '159362' or
     c*                            rKRGNR = '159362' or
     c*                            rKRGNR = '152261' or
     c*                            rKRGNR = '152261' or
     c*                            rKRGNR = '165746'

     C     *DTAARA       DEFINE                  $AFRK11016       10 0
     C  n25*lock         IN        $AFRK11016
     C  n25              eval      $AFRK11016 =  $AFRK11016  + 1
     C  n25              out       $AFRK11016
     c                   seton                                        25
     c                   exsr      sr1000
     c                   if        rkerg1 <> *zero
     c                   movea     '1000'        *IN(41)
     c                   exsr      sr3050
     c                   endif
     c                   if        rkerg2 <> *zero
     c                   movea     '0100'        *IN(41)
     c                   exsr      sr3050
     c                   endif
     c                   if        rkerg3 <> *zero
     c                   movea     '0010'        *IN(41)
     c                   exsr      sr3050
     c                   endif
     c                   if        rkerg4 <> *zero
     c                   movea     '0001'        *IN(41)
     c                   exsr      sr3050
     c                   endif
     c                   eval      status = '10'
     c                   eval      #cc = $AFRK11016
     c                   seton                                        22
     c   22              update    phy01r

     c                   endif
     c*                  endif
     c                   endif
     Clr                 out       unique_f

     C**************************************************************************
     C* sr_001: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $AFRK11016    ##afrk            7
     c                   clear                   #filler01       350
     c                   eval      #filler01   =
     c                             'Manfred Gang Dometic WAECO Int.GmbH     ' +
     c                             '+49 (0)2572 879 - 419   '                 +
     c                             'E-Mail: gang@dometic-waeco.de '           +
     c                             'Internet: http://www.dometic-waeco.de   '
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
     C                   eval      unique_f = unique_f + 1
     c                   exsr      sr3000
     C                   move      unique_f      #unique_f        18
     c
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*

     C                   clear                   PHY02R
     C                   movel     'R'           eddart
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '71 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '82 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '99 ' or
     c                             AKAFAT    = '86 ' or AKAFAT    = '99 '
     C                   movel     'G'           eddart
     c                   endif
     C                   movel     ' '           edtestk
     C**** '1' = Test
     C*********          movel     '1'           edtestk
     C                   movel     RKRGJJ        #beleg           10
     C                   move      RKRGNR        #beleg
     C                   move      #beleg        EDBELEGNR
     C                   if        #beleg   <>   $beleg
     C                   clear                   m                 4 0
     C                   endif
     C                   move      #beleg        $beleg           10
     C     ' ':' '       xlate     EDBELEGNR     EDBELEGNR
     C                   movel     '    '        EDBELEGNR
     c                   eval      edbldatum  =  %char(RKREDA)
     C                   if        eddart =  'G'
     C                   move      #beleg        edrechnr
     C                   movel     RKREDA        edrechda
     c                   endif
      *     *** K ä u f e r   5000 Adressfelder gelesen über 5000            */
     c*  K ä u f e r
     c                   exsr      sr5000
     C                   movel     ALKDNR        edkaufer
     C                   movel     KdrOrder      edkaufer
     C
     C                   movel     '1058'        edtlnummer
     C                   eval      edglntechn = '4026765000006'
     C                   eval      edustidtec = 'DE220465473 '
     C
     C*    ' ':' '       xlate     edvaludatu    edvaludatu
     C*                  move      '804'         edformatvd
     C                   clear                   edvaludatu
     C                   clear                   edformatvd
     C
     C                   if        RKVADA   <> *zero
     C                   move      RKVADA        edvaludatu
     C     ' ':' '       xlate     edvaludatu    edvaludatu
     C                   move      '102'         edformatvd
     C                   endif
     c** R e ch n u n g s e m p f ä n g e r
     c**                 exsr      sr7000
      *     *** K ä u f e r   5000 Adressfelder gelesen über 5000            */
     C                   movel     KDNAM1        EDNAMEKAUF
     C                   movel     KDNAM2        EDNAMEKAU2
     C                   movel     KDSTRA        edstrhaunr
     C                   movel     kDWORT        edortnkauf
     C                   movel     kDPOLZ        edplzkaufe
     C                   movel     kDPOLD        edlandkauf
     C                   move      'EUR'         edwahrunre
     C                   clear                   edwahrunza
     C                   eval      m = m +1
     C                   move      m             edpositinr
     c                   move      rplipo        edpositinr
     c                   if        rplipo      < -0,001
     c                   eval      rplipo     = rplipo     * -1
     c                   endif
     c                   evalr     edpositinr =  %char(rplipo)
     c                   movel     ALTENR        edartiknrl
     c*** Änderung 30.03.2012
     C                   if        RPUPOS  <> 0
     C                   movel     rptenr        edartiknrl
     C                   z-add     RPNESU        ALNESU
     C                   exsr      sr9020
     C                   endif
     c***
     C                   if        edartiknrl =  *blank
     C                   movel     *blank        edartiknrl
     C                   endif
     c                   movel     ALTBZ1        edartklbez
     c                   if        ALGLMG      < -0,001
     c                   eval      ALGLMG     = ALGLMG     * -1
     c                   endif
     c                   evalr     edbermenge =  %char(ALGLMG)
     C                   movel     'PCE'         edmaseinhe
     c                   clear                   p                11 2
     c                   eval      p = (ALNTSK*1,19/ALGLMG)
      * 001 Besonderheit: Einzelpreis nur, wenn max eine Rabatthinterlegung  */
      * 001               sonst alle Rabatte abziehen und als Listenpreis    */
      * 001               ausweisen ohne Rabattsätze zu hinterlegen          */
 MG01c*****              if        alkow2 =  0  and
 MG01c*****                        alkow3 =  0  and
 MG01c*****                        alkow4 =  0
     c                   eval      p = (ALPREI)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c                   evalr     EDEINZELPR =  %char(P)
 MG01c*****              else
 MG01c*****              eval      p =  ALNESU / ALGLMG
 MG01c*****              if        p < - 0,01
 MG01c*****              eval      p = p * -1
 MG01c*****              endif
 MG01c*****              evalr     EDEINZELPR =  %char(P)
 MG01c*****              endif
      * 001 Besonderheit: Ende                                               */
     c                   movel     '        1'   ednettopre
     C                   movel     'PCE'         edpreisein
     c                   movel     ALLIJJ        #beleg
     c                   move      ALLINR        #beleg
     C                   move      #beleg        edlsnummer
     c                   movel     ALLSDA        edlsdatum
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   if        RKMWC1     = '19'
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   endif
     c                   if        RKMWC1     = '16'
     c                   eval      edustsatz =
     c                             '            16.00'
     c                   endif
     c                   eval      p         = (ALNTSK*1,19-ALNTSK)
     c                   eval      p         = (ALNESU*1,19-ALNESU)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c*****neu 29.07.2020
     c                   eval      p = (rkmws1*1)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c                   move      *zero         x                 2 0
     c                   move      *zero         xx               11 4
     c                   if        alnesu = 0
     c                   eval      alnesu = 1
     c                   move      1             xd                1
     c                   endif
     c                   eval(h)   xx= p*100/alnesu
     c                   if        xd ='1'
     c                   eval      alnesu = 0
     c                   move      *blank        xd                1
     c                   endif
     c                   if        xx > 99  or
     c                             xx < -99
     c                   eval      xx = 19
     c                   endif
     c                   eval(h)   x= xx
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   if        x          =  19
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   endif
     c                   if        x          =  16
     c                   eval      edustsatz =
     c                             '            16.00'
     c                   endif
     c*****neu 31.08.2020
     c                   exsr      srmwst
     c                   if        MWSTSATZ   =  19,00000
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   eval      edustsatz =
     c                             '            16.00'
     c                   endif
     c*****neu 31.08.2020
     c
     c                   evalr     edustbetr = %char(p)
     c                   if        ALNTSK      < -0,001
     c                   eval      ALNTSK     = ALNTSK     * -1
     c                   endif
     c                   evalr     EDPOSIBETR =  %char(ALNTSK)
     c                   evalr     EDPOSIBETR =  %char(ALNESU)
     c                   movel     almaaf        edbnrkaeuf
     c                   movel     '        '    edbestdatu
     c                   movel     akbeda        edbestdatu
     c                   if        edbnrkaeuf = *blank
     c                   movel     AKREF1        edbnrkaeuf
     c                   endif
     c                   if        edbnrkaeuf = *blank
     c                   movel     'unbekannt'   edbnrkaeuf
     c                   endif
     c                   clear                   edbestdatu
     c                   movel     akbeda        edbestdatu
     c                   eval      edstsatzat  =
     c                             '             0.00'
     c                   clear                   edstsatzat
     c                   eval      edstbetrat   =
     c                             '             0.00'
     c                   clear                   edstbetrat
     c*  hat ware als lieferadresse erhalten ( auftragsbezogen)
     c                   exsr      sr8010
     c                   movel     adNAM1        EDNAMEEMPF
     c                   movel     adNAM2        EDNAMEEMP2
     c                   movel     adSTRA        EDSTRHNRES
     c                   movel     adWORT        EDORTNAMES
     c                   movel     adPOLZ        EDPLZENDES
     c                   movel     ADPOLD        EDLANDENES
     c
     c                   if        EDNAMEEMPF       = *blank
     c*  w a r e n e m p f ä n g e r
     c                   exsr      sr6000
     c                   movel     KDNAM1        EDNAMEEMPF
     c                   movel     KDNAM2        EDNAMEEMP2
     c                   movel     KDSTRA        EDSTRHNRES
     c                   movel     kDWORT        EDORTNAMES
     c                   movel     kDPOLZ        EDPLZENDES
     c                   movel     kDPOLD        EDLANDENES
     c                   endif
     c
     c                   clear                   EDABPROSAZ
      * 001 Besonderheit: rabatt nur dann, wenn max eine Rabatthinterregung  */
      * 001               sonst keine zeigen                                 */
 mg01 * 001 ab: Rel 1.2 Übergabe von max.3 Zu oder Abschlägen 07.02.11       */
 mg01c*******            if        alkow1 <> 0  and
 mg01c*******                      alkow2 =  0  and
 mg01c*******                      alkow3 =  0  and
 mg01c*******                      alkow4 =  0
 mg01c*******            evalr     EDABPROSAZ = %char(ALKOW1*-1)
 mg01c*******            endif
     c
 mg01c                   clear                   EDCOD#1
 mg01c                   clear                   EDPRO#1
 mg01c                   clear                   EDBET#1
 mg01c                   if        alkow1 <> 0
 mg01c                   movel     'A'           EDCOD#1
 mg01c                   evalr     EDPRO#1    = %char(ALKOW1*-1)
 mg01c                   if        RPERG1 < 0,00
 mg01c                   eval      p = RPERG1 * -1
 mg01c                   endif
 mg01c                   evalr     EDBET#1    = %char(p)
 mg01c                   endif
     c
 mg01c                   clear                   EDCOD#2
 mg01c                   clear                   EDPRO#2
 mg01c                   clear                   EDBET#2
 mg01c                   if        alkow2 <> 0
 mg01c                   movel     'A'           EDCOD#2
 mg01c                   evalr     EDPRO#2    = %char(ALKOW2*-1)
 mg01c                   if        RPERG2 < 0,00
 mg01c                   eval      p = RPERG2 * -1
 mg01c                   endif
 mg01c                   evalr     EDBET#2    = %char(p)
 mg01c                   endif
     c
 mg01c                   clear                   EDCOD#3
 mg01c                   clear                   EDPRO#3
 mg01c                   clear                   EDBET#3
 mg01c                   if        alkow3 <> 0
 mg01c                   movel     'A'           EDCOD#3
 mg01c                   evalr     EDPRO#3    = %char(ALKOW3*-1)
 mg01c                   if        RPERG3 < 0,00
 mg01c                   eval      p = RPERG3 * -1
 mg01c                   endif
 mg01c                   evalr     EDBET#3    = %char(p)
 mg01c                   endif
     c
 mg01c                   clear                   EDCOD#4
 mg01c                   clear                   EDPRO#4
 mg01c                   clear                   EDBET#4
 mg01c                   clear                   EDCOD#5
 mg01c                   clear                   EDPRO#5
 mg01c                   clear                   EDBET#5
 mg01c                   clear                   EDCOD#6
 mg01c                   clear                   EDPRO#6
 mg01c                   clear                   EDBET#6
     c* Warengruppe neu
 mg01c                   clear                   EDWAEGRP
     c
     c                   clear                   EDABBETRAG
 mg01c*******            if        alkow1 <> 0  and
 mg01c*******                      alkow2 =  0  and
 mg01c*******                      alkow3 =  0  and
 mg01c*******                      alkow4 =  0
 mg01c*******            eval      p          =      (ALWAWT - ALNESU)
 mg01c*******            if        p < - 0,01
 mg01c*******            eval      p = p * -1
 mg01c*******            endif
 mg01c*******            evalr     EDABBETRAG = %char(P)
 mg01c*******            endif
      * 001 Besonderheit: Ende                                               */
     c                   clear                   EDZUPROSAZ
     c                   clear                   EDZUBETRAG
     c                   if        Rknesu      < -0,001
     c                   eval      Rknesu     = Rknesu     * -1
     c                   endif
     c                   evalr     EDGESAMTRE =  %char(Rknesu)
     c                   evalr     EDGESAMTRE =  %char(Rkwawt)
     c                   clear                   p                11 2
     c                   eval      p = (RKNESU*19,00/100)
     c                   eval      p = (rkmws1*1)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c                   evalr     EDUMSSTBET =  %char(P)
     c*
 mg01c*******            clear                   EDFILLER
     C                   write     PHY02R

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Zu. und Abschläge Ebene Kopf
     C*-------------------------------------------------------------------------
     C*
     C     sr3050        BEGSR
     C*

     C                   clear                   PHY02R
     C*    lt. Berthold Übernahme aus Kopf
     C*    Menge evtl negativieren
     C*****              movel     'R'           eddart
     c*****              if        rkerg1    <   0
     C*****              movel     'G'           eddart
     c*****              endif
     C                   movel     'R'           eddart
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '71 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '82 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '99 ' or
     c                             AKAFAT    = '86 ' or AKAFAT    = '99 '
     C                   movel     'G'           eddart
     c                   endif
     C                   movel     ' '           edtestk
     C**** '1' = Test
     C*********          movel     '1'           edtestk
     C                   movel     RKRGJJ        #beleg           10
     C                   move      RKRGNR        #beleg
     C                   move      #beleg        EDBELEGNR
     C                   if        #beleg   <>   $beleg
     C                   clear                   m                 4 0
     C                   endif
     C                   move      #beleg        $beleg           10
     C     ' ':' '       xlate     EDBELEGNR     EDBELEGNR
     C                   movel     '    '        EDBELEGNR
     c                   eval      edbldatum  =  %char(RKREDA)
     C                   if        eddart =  'G'
     C                   move      #beleg        edrechnr
     C                   movel     RKREDA        edrechda
     c                   endif
      *     *** K ä u f e r   5000 Adressfelder gelesen über 5000            */
     c*  K ä u f e r
     c                   exsr      sr5000
     C                   movel     ALKDNR        edkaufer
     C                   movel     KdrOrder      edkaufer
     C
     C                   movel     '1058'        edtlnummer
     C                   eval      edglntechn = '4026765000006'
     C                   eval      edustidtec = 'DE220465473 '
     C                   move      '30'          edvaludatu
     C     ' ':' '       xlate     edvaludatu    edvaludatu
     C                   move      '804'         edformatvd
     C                   clear                   edvaludatu
     C                   clear                   edformatvd
     c** R e ch n u n g s e m p f ä n g e r
     c**                 exsr      sr7000
      *     *** K ä u f e r   5000 Adressfelder gelesen über 5000            */
     C                   movel     KDNAM1        EDNAMEKAUF
     C                   movel     KDNAM2        EDNAMEKAU2
     C                   movel     KDSTRA        edstrhaunr
     C                   movel     kDWORT        edortnkauf
     C                   movel     kDPOLZ        edplzkaufe
     C                   movel     kDPOLD        edlandkauf
     C                   move      'EUR'         edwahrunre
     C                   clear                   edwahrunza
     C                   eval      m = m +1
     C                   move      m             edpositinr
     c                   z-add     000           #rplipo           4 0
     c                   move      #rplipo       edpositinr
     c                   if        #rplipo      < -0,001
     c                   eval      #rplipo     = #rplipo     * -1
     c                   endif
     c                   evalr     edpositinr =  %char(#rplipo)
     c                   movel     ALTENR        edartiknrl
     c   41              movel     rkkon1        #rkkon           10
     c   42              movel     rkkon2        #rkkon           10
     c   43              movel     rkkon3        #rkkon           10
     c   44              movel     rkkon4        #rkkon           10
     c                   exsr      sr8250
     c                   movel     TPTTXT        edartiknrl
     C                   if        edartiknrl =  *blank
     C                   movel     *blank        edartiknrl
     C                   endif
     c                   movel     TPTTXT        edartklbez
     c                   z-add     1             #alglmg           8 2
     c                   evalr     edbermenge =  %char(#ALGLMG)
     c                   if        rkerg1    <   0
     c                   eval      #alglmg   =   #alglmg * -1
     c                   evalr     edbermenge =  %char(#ALGLMG)
     c                   eval      #alglmg   =   #alglmg * -1
     c                   endif
     C                   movel     'PCE'         edmaseinhe
     c                   clear                   p                11 2
     c                   exsr      srmwst2
     c                   if        MWSTSATZ   =  19,00000
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   endif
     c                   if        MWSTSATZ   =  16,00000
     c                   eval      edustsatz =
     c                             '            16.00'
     c                   endif
     c   41              eval      p = (rkerg1*MWSTSATZ/100/#ALGLMG)
     c*  41 old          if        RKMWC1     = '19'
     c*  41 old          eval      p = (rkerg1*1,19/#ALGLMG)
     c*     old          endif
     c   42              eval      p = (rkerg2*MWSTSATZ/100/#ALGLMG)
     c   43              eval      p = (rkerg3*MWSTSATZ/100/#ALGLMG)
     c   44              eval      p = (rkerg4*MWSTSATZ/100/#ALGLMG)
      * 001 Besonderheit: Einzelpreis nur, wenn max eine Rabatthinterlegung  */
      * 001               sonst alle Rabatte abziehen und als Listenpreis    */
      * 001               ausweisen ohne Rabattsätze zu hinterlegen          */
     c   41              eval      p = (rkerg1)
     c   42              eval      p = (rkerg2)
     c   43              eval      p = (rkerg3)
     c   44              eval      p = (rkerg4)
     c*neu 20121108 77 Gutschrift mit interner Belastung
     c                   setoff                                       77
     c                   if        eddart =  'G' and p >  0,00
     c                   seton                                        77
     c                   endif
     c*neu 20121108
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c   77              eval      p = p * -1
     c
     c                   evalr     EDEINZELPR =  %char(P)
      * 001 Besonderheit: Ende                                               */
     c                   movel     '        1'   ednettopre
     C                   movel     'PCE'         edpreisein
     c                   movel     RKRGJJ        #beleg
     c                   move      RKRGNR        #beleg
     c*                  hier jetzt auch Lieferscheinnummer
     c                   move      ALLINR        #beleg
     C                   move      #beleg        edlsnummer
     c                   movel     ALLSDA        edlsdatum
     c                   exsr      srmwst2
     c
     c   41              eval      p         = (rkerg1*MWSTSATZ/100)
     c***41  alt         eval      p         = (rkerg1*MWSTSATZ/100-rkerg1)
     c   42              eval      p         = (rkerg2*MWSTSATZ/100)
     c   43              eval      p         = (rkerg3*MWSTSATZ/100)
     c   44              eval      p         = (rkerg4*MWSTSATZ/100)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c                   evalr     edustbetr = %char(p)
     c   41              z-add     rkerg1        #rkerg           12 2
     c   42              z-add     rkerg2        #rkerg           12 2
     c   43              z-add     rkerg3        #rkerg           12 2
     c   44              z-add     rkerg4        #rkerg           12 2
     c                   if        #rkerg      < -0,001
     c                   eval      #rkerg     = #rkerg     * -1
     c                   endif
     c                   evalr     EDPOSIBETR =  %char(#rkerg)
     c                   movel     #beleg        edbnrkaeuf
     c                   movel     '        '    edbestdatu
     c                   movel     akbeda        edbestdatu
     c                   if        edbnrkaeuf = *blank
     c                   movel     AKREF1        edbnrkaeuf
     c                   endif
     c                   if        edbnrkaeuf = *blank
     c                   movel     'unbekannt'   edbnrkaeuf
     c                   endif
     c                   clear                   edbestdatu
     c                   movel     akbeda        edbestdatu
     c                   eval      edstsatzat  =
     c                             '             0.00'
     c                   clear                   edstsatzat
     c                   eval      edstbetrat   =
     c                             '             0.00'
     c                   clear                   edstbetrat
     c*  hat ware als lieferadresse erhalten ( auftragsbezogen)
     c                   exsr      sr8010
     c                   movel     adNAM1        EDNAMEEMPF
     c                   movel     adNAM2        EDNAMEEMP2
     c                   movel     adSTRA        EDSTRHNRES
     c                   movel     adWORT        EDORTNAMES
     c                   movel     adPOLZ        EDPLZENDES
     c                   movel     ADPOLD        EDLANDENES
     c
     c                   if        EDNAMEEMPF       = *blank
     c*  w a r e n e m p f ä n g e r
     c                   exsr      sr6000
     c                   movel     KDNAM1        EDNAMEEMPF
     c                   movel     KDNAM2        EDNAMEEMP2
     c                   movel     KDSTRA        EDSTRHNRES
     c                   movel     kDWORT        EDORTNAMES
     c                   movel     kDPOLZ        EDPLZENDES
     c                   movel     kDPOLD        EDLANDENES
     c                   endif
     c
     c                   clear                   EDABPROSAZ
     c
     c* Warengruppe neu
 mg01c                   clear                   EDCOD#4
 mg01c                   clear                   EDPRO#4
 mg01c                   clear                   EDBET#4
 mg01c                   clear                   EDCOD#5
 mg01c                   clear                   EDPRO#5
 mg01c                   clear                   EDBET#5
 mg01c                   clear                   EDCOD#6
 mg01c                   clear                   EDPRO#6
 mg01c                   clear                   EDBET#6
 mg01c                   clear                   EDWAEGRP
     c
     c                   clear                   EDABBETRAG
     c                   clear                   EDZUPROSAZ
     c                   clear                   EDZUBETRAG
     c                   if        Rknesu      < -0,001
     c                   eval      Rknesu     = Rknesu     * -1
     c                   endif
     c                   evalr     EDGESAMTRE =  %char(Rknesu)
     c                   evalr     EDGESAMTRE =  %char(rkwawt)
     c                   clear                   p                11 2
     c                   eval      p = (RKNESU*19,00/100)
     c                   eval      p = (rkmws1*1)
     c                   if        p < - 0,01
     c                   eval      p = p * -1
     c                   endif
     c                   evalr     EDUMSSTBET =  %char(P)
     c*
 mg01c*******            clear                   EDFILLER
 mg01c*******            Korrektur
     C                   if        ( edpositinr='     0'
     C                               and eddart='G'
     C                               and edbermenge= '            -1.00')
     c                   eval      #rkerg = #rkerg *-1
     c                   evalr     edbermenge= '             1.00'
     c                   evalr     EDPOSIBETR =  %char(#rkerg)
     C                   endif
     C                   write     PHY02R

     C*
     C     ##3050        ENDSR
     C*
     C**************************************************************************
     C* sr5000: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     keysr5kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKKDNR
     c***** ford         kfld                    RKRAKD
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
     c   97              clear                   unique_fr
     c
     C*
     C     ##8000        ENDSR
     C*
     C**************************************************************************
     C* sr8100: lesen adresse, wo geliefert wurde
     C*-------------------------------------------------------------------------
     C*
     C     sr8010        BEGSR
     C*
     c     keysr_afad    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ADPOSI
     c                   kfld                    ADAART
     c
     c                   clear                   ADPOSI
     c                   movel     'ADVS      '  ADAART
     c
     c     keysr_afad    chain     afad01                             97
     c   97              clear                   afad1
     c
     c   97              clear                   ADNAM1
     c   97              clear                   ADNAM2
     c   97              clear                   ADNAM3
     c   97              clear                   ADSTRA
     c   97              clear                   ADPOLD
     c   97              clear                   ADPOLZ
     c   97              clear                   ADWORT
     c   97              clear                   ADPOFA
     C*
     C     ##8010        ENDSR
     C*
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
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0)
     c+ into   :tstampi, :datum, :datum2, :zeit, :week
     c+ from   qsys2/qsqptabl
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

     c




