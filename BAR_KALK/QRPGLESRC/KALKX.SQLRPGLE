     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*  update  teew set teewskun =                             *
     F*  (select artsku from bar_kalk/kalk_file                  *
     F*  WHERE version = '$$EL_PS_DB' and TEEWSKUN<> ARTSKU      *
     F*        and  artnr  = TEEWTENR )                          *
     F*  where exists                                            *
     F*  (select artsku from bar_kalk/kalk_file                  *
     F*  WHERE version = '$$EL_PS_DB' and TEEWSKUN<> ARTSKU      *
     F*        and  artnr  = TEEWTENR )                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F************************************************************
     F*                                                          *
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  Kalkulation ausführen                                   *
     F*  lpif01  unser Artikel - Artikel des Lieferanten        *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     fTEIL00    ip   e           k disk
     fLAND01    if   e           k disk
     fPREI02    if   e           k disk
     fTEOS01    if   e           k disk
     fTEEW01    uf a e           k disk
     f#teew     if   e           k disk    rename(TEEW1:#teew1)

     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
     fARTNR_KALKif   e           k disk    prefix('Z')
     fFRACHTKS  if   e           k disk
     fZollta2lf if   e           k disk
     fSLAZSlf   if   e           k disk
     f#pr0011l1 if   e           k disk
     fsystempf  if   e           k disk
     ftrtp00    if   e           k disk
     fbbep09    if   e           k disk
     f#kp0105l1 if   e           k disk
     fTeuf00    if   e           k disk
     fwaehrungk if   e           k disk
     fpauk02    if   e           k disk
     f#PREIL1   uf a e           k disk    RENAME(prei1:phy01r)
     f#PREIL2   uf a e           k disk    RENAME(prei1:phy02r)

     fKALK_FILE uf a e           k disk
     F                                     USROPN

     dfirma            s                   like(slazfirm)
     dpekpr            s                   like(ekpr)
     dbegr             s                   like(prbegr)
     dtenr             s                   like(PRTENR)
     dprozent          s                   like(icss)

     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------
     IKALKSZUF1
     I              lieferant                   §lieferant
     I
     I*-------------------------------------------------bot---------------------
     IKSCHEMA_F1
     I              lieferant                   §lieferant
     I
     I*-------------------------------------------------bot---------------------

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    Liefnr
     c                   kfld                    TETENR

     c*  Schlüsselliste für teil00
     c     teilkey       klist
     c                   kfld                    firma
     c                   kfld                    TETENR

     c*  Schlüsselliste für prei02
     c     preikey       klist
     c                   kfld                    FIRMA
     c                   kfld                    BEGR
     c                   kfld                    TETENR

     c*  Schlüsselliste für KSchemata
     c     keyschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    KSCHEMA
     c                   kfld                    §lieferant

     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    StatNr
     c                   kfld                    §lieferant

     c*  Schlüsselliste für SLAZSlf
     c     keyslazs      klist
     c                   kfld                    firma
     c                   kfld                    TETENR

     C     *ENTRY        PLIST
     C                   PARM                    version

     c*********              clear                   KALK_F1

     c                   movel     TEPRGR        StatNr
     c                   IF        teabc1<>'<' and
     c                             teabc1<>'<' and
     c                             teabc1<>'<'

     c                   z-add     nxt_jahr      Jahr
     c                   movel     '999'         LiefNr
     c                   movel     TETENR        ArtNr
     c                   if        TETENR = '4442700316' or
     c                             TETENR = '4442700317' or
     c                             TETENR = '9106300025'
     c                   clear                   ewrwer            1
     c                   endif
     c                   movel     TEMAGR        ArtGrp
     c                   movel     TEPRGR        StatNr
     c                   clear                   ERSETZ
     c                   clear                   PREISKDU
     c                   movel     teabc1        ABC
     c                   movel     TETBZ1        ARTBEZ
     c                   clear                   WACDVK
     c                   clear                   EVP_A_BR
     c                   eval      EVP_NEU1 = ( EVP_A_BR * 1,03 )
     c                   eval      EVP_NEU2 = ( EVP_A_BR * 1,05 )
     c                   eval      EVP_AJ = EVP_A_BR/1,19
     c                   movel     TEZOTN        ZOLLNR
     c                   clear                   ARTZ1
     c
     c
     C     KEYpauk       KLIST
     C                   KFLD                    teFIRM
     C                   KFLD                    teTENR
     c
     c                   clear                   kon               4 0
     c                   clear                   eig               4 0
     C     KEYpauk       SETLL     pauk02                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      pauk02                                 95
     C     *IN95         IFEQ      '1'
     c     teFIRM        orne      UkFIRM
     c     teTENR        orne      UkTENR
     C                   leave
     C                   else
     c                   if        UKPPAT   = '300'  or
     c                             UKPPAT   = '200'
     c                   eval      kon = kon + 1
     c                   ENDIF                                                  %found(FRACHTKS)
     c                   if        UKPPAT   = '100'
     c                   eval      eig = eig + 1
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   endif
     C                   enddo
     C                   endif
     c                   if        kon > eig
     c                   movel     'KON   '      ARTZ1
     c                   endif
     c                   if        eig > kon
     c                   movel     'EIPROD'      ARTZ1
     c                   endif
     c
     c
     c                   clear                   ARTZ2
     c                   clear                   ARTZ3
     c                   clear                   ARTGEW
     c                   eval      anldat  = teerda

      * alter Preis und gültig ab Datum
     c*                  movel     '19'          ##ART280B
      * derzeit gültiger Preis und ab Datum
     c*                  movel     '19'          ##ART300B
      * neuer gültiger Preis und gültig ab Datum
     c*                  z-add     art310        ##art310
     c*                  z-add     art320        ##art320
     c*                  movel     '19'          ##ART320B

     c                   if        ARTZ1='EIPROD' or ARTZ1='EIPRO'
     c                   eval      GKSatz = 0.1
     c                   else
     c                   eval      GKSatz = 0
     c                   endif

     c* Fixfelder
     c                   eval      WERKZEUG   = 0
     c                   eval      ENTWICKLUN = 0
     c                   eval      PRODUKTION = 0
     c                   eval      BEISTELL   = 0
     c                   eval      KONFEKTION = 0
     c                   eval      CWSTCK2W   = 0
     c                   eval      PREIS_PM   = 0
      *
     c                   eval      WAKURS     = 1

     c                   z-add     testpr        COSTPRS_AR
     c                   z-add     0             VKMENGE_VJ
     c                   z-add     0             VKMENGE_AJ
     c                   z-add     TESTPR        STK_LCP
     c                   z-add     TESTPR        STK_LCP_a
     C                   clear                   b001
     C                   clear                   b002
     C                   clear                   b003
     C                   clear                   b004
     C                   clear                   b005
     C                   clear                   c001
     C*                  Inventur  Menge                b001
     C*                  Einkauf  Menge                 b002
     C*                  Verkauf  Menge                 b003
     C*                  Mengen  Kundenrückstellungen   b004
     C*                  Mengen         Bestellungen offen + Abrufaufträge

     c                   exsr      sr2550

     c                   clear                   #TESAAV
     c                   clear                   #TEDIAV
     c                   clear                   #TEVOZ1
     c                   clear                   #TEVOA1
     c                   movel     TESTLF        lieferant1
     c                   eval      §lieferant  = lieferant1
     c                   movel     *blanks       lieferant2
     c                   movel     *blanks       uland
     c                   z-add     0             FRACHTSATZ
     c                   movel     TESAEK        #TESAAV
     c                   movel     TEDIEK        #TEDIAV
     c                   z-add     TELVZ1        #TEVOZ1
     c                   movel     TELVA1        #TEVOA1
     c                   movel     TEMPEK        TEMPEK#
     c* Ursprungsland bestimmen
     c     teurld        chain     land1
     c                   IF        %found(land01)
     c                   movel     LNLISO        uland

     c* Frachtsatz bestimmen
     c     LNLISO        chain     frachtf0
     c                   IF        %found(FRACHTKS)
     c                   z-add     SATZ          FRACHTSATZ
     c                   ENDIF                                                  %found(FRACHTKS)

     c                   IF        LNLDGR = '0001'
     c                   eval      ZOLLSATZ = 0
     c                   ELSE                                                   LNLDGR = '0001'
     c* Zollsatz bestimmen
     c     ZOLLNR        chain     Zollta2
     c                   IF        %found(zollta2lf)
     c                   eval      ZOLLSATZ = satz1
     c                   else
     c                   eval      ZOLLSATZ = 0
     c                   ENDIF                                                  %found(zollta2lf)
     c                   ENDIF                                                  LNLDGR = '0001'
     c                   if        statnr = '342'
     c                   eval      ZOLLSATZ = 0
     c                   ENDIF                                                  LNLDGR = '0001'

     c* EKP bestimmen
     c                   eval      WACDEK = 'EUR'
     c                   eval      wekpr  = 0
     c                   z-add     TESTPR        WEKPR
     c                   exsr      sr5500
     c                   exsr      sr5600
     c                   exsr      sr5800
     c                   exsr      sr5888
     c                   if        wekpr = *zero
     c                   if        ( %subst(ARTZ1: 01: 3) =  'KON'  or
     c                               %subst(ARTZ1: 01: 3) =  'CON' )
     c                   else
     c                   if        lieferant1 <> *blank
     c                   z-add     TESTPR        WEKPR
     c                   ENDIF                                                  %found(TEIL00)
     c                   ENDIF                                                  %found(TEIL00)
     c                   ENDIF                                                  %found(TEIL00)

     c                   ENDIF                                                  %found(TEIL00)

     c* Kalkulationsschema bestimmen und eigentliches Standardschema
     c                   eval      KSCHEMA    = 0
     c                   eval      KSCHEMASTD = 0
     c*
     c     akkey         chain     ARTNRKF0
     c* Schema holen aus Artikelreferenz
     c                   IF        %found(ARTNR_KALK)
     c                   eval      KSCHEMA    = ZSCHEMA
     c* Standard-Schema holen aus Artikelreferenz
     c                   exsr      sr2201
     c                   ELSE
     c                   exsr      sr2202
     c                   ENDIF                                                  %found(ARTNR_KALK)

     c* SCHEMA
     c***** 04.10.2010   eval      KWAKURS    = 1
     c                   eval      RISIKOSATZ = 0
     c                   eval      ICSS       = 0
     c                   eval      ICNS       = 0
     c                   eval      EXSS       = 0
     c                   eval      EXNS       = 0
     c                   eval      OEMS       = 0
     c                   eval      GHNETS     = 0
     c                   eval      GHRABS     = 0
     c                   eval      STK_LCPGKZ = 0
     c                   eval      RZ_RABATTS = 0
     c                   eval      RZ_WERT    = 0
     c                   eval      LCP_GKZ_W  = 0

     c* Kalkulationsschema bestimmen
     c     keySCHEMA     chain     KSCHEMA_F1
     c                   IF        %found(KSchemata)

     c* SCHEMA
     c******* 04.10.2010 eval      KWAKURS    = yKURS
     c                   eval      RISIKOSATZ = yRISIKO
     c                   eval      ICSS       = yICS
     c                   eval      ICNS       = yICN
     c                   eval      EXSS       = yEXS
     c                   eval      EXNS       = yEXN
     c                   eval      OEMS       = yOEM
     c                   eval      GHNETS     = yGHNETTO
     c                   eval      GHRABS     = yGHRAB

     c                   ENDIF                                                  %found(KSchemata)

     c                   if        kwakurs = 0
     c                   eval      kwakurs = 1
     c                   endif

      * HINWEIS: Wenn im feld WEKPR ein Wert über Trend vorliegt,
      *          aber auch in nachfolgenden Stücklisten, liegt eine
      *          Beistellung vor.
      *          Dieses bedeutet: wekpr + wekpr aus Stücklisten
      *          = neuer WEKPR
      *          wekpr aus Stückliste = Beistellung
      *          Beistellung nicht korrekt 30.04.2010
      *          Umrechnung bei Währungen in der Stückliste angepasst

     c                   clear                   pekpr
     c                   clear                   CCSTCK
     c                   clear                   CWSTCK
     c                   clear                   CWSTCK2W
     c                   clear                   beistell
     c                   clear                   xpp              13 2
     c                   if        version <> '$$$$$$$$$$'
     c     keyslazs      chain     slaz1
     c                   IF        %found(SLAZSLF)
     c                   call      'KALK_STCKN'
     c                   parm                    JAHR
     c                   parm                    LIEFNR
     c                   parm                    ARTNR
     c                   parm      0             PEKPR
     c                   parm      0             CCSTCK
     c                   parm      0             CWSTCK
     c                   parm      '$$$$$$$$$$'  p_version        10
     c                   parm                    artz1

     c                   z-add     PEKPR         CWSTCK2W
      *                 Beistellung  :beistell (verlängerte WB)               
     c                   if        %subst(ARTZ1: 01: 3) <> 'KON'     and
     c                             %subst(ARTZ1: 01: 3) <> 'CON'     and
     c                             %subst(ARTZ1: 01: 6) <> 'EIPROD'  and
     c                             CCSTCK > 0
     c                   z-add     pekpr         beistell
     c                   clear                   pekpr
     c                   endif
      *                 Konfektion   :xpp      (verlängerte WB)               
     c                   if        ( %subst(ARTZ1: 01: 3) =  'KON'   or
     c                               %subst(ARTZ1: 01: 3) =  'CON' ) and
     c                             CCSTCK > 0
     c                   z-add     pekpr         xpp              13 2
     c                   clear                   pekpr
     c                   endif
      *                 Eigenprod.   : nur Wert aus Liste                     
     c                   if        %subst(ARTZ1: 01: 6) =  'EIPROD'  and
     c                             CCSTCK > 0
     c                   clear                   wekpr
     c                   endif
      *                 Wert entspricht dem Stücklistenwert Sonderartikel,    
      *                 haben keine Einkaufswerte bis auf Stückliste          
     c                   if        %subst(ARTZ1: 01: 6) =  '      '  and
     c                             CCSTCK > 0                        and
     c                             wekpr  = 0
     c                   z-add     CWSTCK2W      wekpr
     c                   clear                   beistell
     c                   endif
      ******             $$$$$$$$$$  ende
     c                   seton                                        77
      *                 Im Fall der Stücklisten bei Beistellung muß der       
      *                 Hauptartikel u.U. umgerechnet werden, d.h., der       
      *                 anteilige Einkaufswert ohne Beistellung               
      *                 Währungsumrechnung muß wieder erlaubt werden          
     c                   if        beistell  <> *zero
     c                   seton                                        78
     c                   endif
     c                   ENDIF                                                  %found(SLAZSLF)

     c  n78              eval      wekpr =  wekpr + pekpr + beistell + xpp
     c   78              eval      wekpr =  wekpr + pekpr            + xpp
     c                   ENDIF                                                  %found(SLAZSLF)

      *sollte der wekpr immer noch *zero sein dann Standardwert
     c                   if        wekpr = *zero
     c                   z-add     TESTPR        WEKPR
     c                   endif
      ****** 77 = '1' kommt aus Stückliste Währung bereits umgerechnet
     c
     c                   if        kwakurs = 0
     c                   eval      kwakurs = 1
     c                   endif
     c                   if        WACDEK = 'EUR'
     c                   eval      EKPR   = WEKPR
     c                   else
     c   77              eval      EKPR   = WEKPR
     c  n77              eval      EKPR   = WEKPR / KWAKURS
     c                   ENDIF
     c                   setoff                                       77

      ****** 78 = '1' beistellung wurde umgerechnet in den Werten
      *               in der jeweiligen frendwährung. Nun kann der
      *               neue Artikel vom Einkauf her (verl. WB) in
      *               einer Fremdwährung abgerechnet werden. (ANTEIL)

     c   78              if        WACDEK = 'EUR'
     c   78              eval      wekpr  = WEKPR + beistell
     c   78              eval      EKPR   = WEKPR
     c                   else
     c   78              eval      wekpr  = (WEKPR) / kwakurs
     c                                      + beistell
     c   78              eval      EKPR   = WEKPR
     c                   endif
     c                   setoff                                       78

     c* Hause 16.03.2010
     c                   if        stk_lcp = 1 and ekpr > stk_lcp
     c                   z-add     ekpr          stk_lcp
     c                   eval      %subst(BUCHUNG: 15: 1) = 'H'
     c                   endif
     c
     c* Berechnungsfelder
     c                   eval      stk_lcpgkz = (stk_Lcp * ygk)/ 100
     c                   eval      LCP_GKZ_W =(stk_lcp+stk_lcpgkz)
     c                   eval      RZ_rabatts = yrisiko
     c                   eval      rz_wert = (lcp_gkz_w * yrisiko)/ 100

     c                   eval      FRACHT     = EKPR * FRACHTSATZ / 100
     c* Wenn "präfix" bei ARTZ1 = "KON" dann keine zusätzlichen Kosten, da
     c* bereits in Berechnung bei FRACHT, ZOLL, VERSICHERU, RISIKOZ
     c                   if        %subst(artz1: 1: 3) = 'KON'
     c                   z-add     *zero         FRACHT
     c                   endif

     c                   eval      ZOLL       = EKPR * zollsatz
     c                   if        %subst(artz1: 1: 3) = 'KON'
     c                   z-add     *zero         Zoll
     c                   endif

     c                   eval      VERSICHERU = (EKPR + FRACHT + ZOLL) * 0,0004
     c                   if        %subst(artz1: 1: 3) = 'KON'
     c                   z-add     *zero         versicheru
     c                   endif

     c                   eval      GK         = EKPR * GKSATZ / 100
     c                   eval      COSTPRS_N  = EKPR+FRACHT+ZOLL+VERSICHERU+GK

      * Bei Artikeln anlagedatum > 20090000, und der nicht in der Excel-File
      * E_stk_lcp steht, erfolgt Sonderbedingung
      * Damit muss auch das Vorfeld COSTPRS_AR aktualisiert werden
      *               o d e r
      * Achtung: STK_LCP wird überschrieben Simulation mit EINKAUFSPREIS
     c                   if        ( anldat > 20090000 and stk_lcp_a = 0 )
     c                             or
     c                             %subst(version: 1: 2) = 'EK'
     c                   z-add     stk_lcp       STK_LCP_a
     c                   z-add     COSTPRS_N     STK_LCP
     c                   eval      stk_lcpgkz = (stk_Lcp * ygk)/ 100
     c                   eval      LCP_GKZ_W =(stk_lcp+stk_lcpgkz)
     c                   eval      RZ_rabatts = yrisiko
     c                   eval      rz_wert = (lcp_gkz_w * yrisiko)/ 100
     c                   endif

     c                   eval      RISIKOZ    = COSTPRS_N * RISIKOSATZ / 100
     c                   if        %subst(artz1: 1: 3) = 'KON'
     c                   z-add     *zero         risikoz
     c                   endif

     c                   eval      KALKBASIS  = RISIKOZ + COSTPRS_N
     c                   eval      KALKBASIS  = RZ_wert + lcp_gkz_w
     c                   eval      GHNET      = (KALKBASIS * 100)   /
     c                                          (100 - GHNETS)
     c                   eval      GHRAB      = (GHNET     * 100)   /
     c                                          (100 - GHRABS)
     c                   eval      EVP_N      = GHRAB
     c                   eval      EVP_N_BR   = EVP_N  * 1,19

     c                   if        EVP_N<>0
     c                   eval      ROHS_N     = ((EVP_N *
     c                                          (1-(GHRABS/100))-KALKBASIS))/
     c                                          (EVP_N * (1-(GHRABS/100))) * 100
     c                   else
     c                   eval      ROHS_N     = 0
     c                   endif                                                  EVP_N<>0
     c                   clear                   P                12 4
     c                   clear                   marge_neu1
     c                   clear                   marge_neu2
     c*
     c                   eval      p=
     c                             (EVP_NEU1/1,19 *
     c                             (1-(GHRABS/100))/100)
     c*
     c
     c                   eval      p=
     c                             ((EVP_NEU2/1,19) *
     c                             (1-(GHRABS/100))/100)
     c*
 mg01 * Wert costpr_n ersetzt durch LCP_GKZ_W
     c* Kalkulation ICS, ICN, EXS, EXN, OEM
     c                   eval      prozent = (1,00000-(ICSS/100))
 mg01c                   eval      ICS        = LCP_GKZ_W / prozent
     c                   eval      prozent = (1,00000-(ICNS/100))
 mg01c                   eval      ICN        = LCP_GKZ_W / prozent
     c                   eval      prozent = (1,00000-(EXSS/100))
 mg01c                   eval      EXS        = LCP_GKZ_W / prozent
     c                   eval      prozent = (1,00000-(EXNS/100))
 mg01c                   eval      EXN        = LCP_GKZ_W / prozent
     c                   eval      prozent = (1,00000-(OEMS/100))
 mg01c                   eval      OEM        = LCP_GKZ_W / prozent
 mg01c                   move      date          pdate
     c                   exsr      sr2500
     c                   exsr      sr2501

      * fred 21.10.2009
     c                   if        ics_aj = 0                                   %found(WAECOLCP)
     c                   if        %subst(statnr: 1: 1) = '3' or                %found(WAECOLCP)
     c                             statnr= '208' or                             %found(WAECOLCP)
     c                             statnr= '209' or                             %found(WAECOLCP)
     c                             statnr= '210' or                             %found(WAECOLCP)
     c                             statnr= '212'                                %found(WAECOLCP)
     c                   z-add     ics           ics_aj                         %found(WAECOLCP)
     c                   endif                                                  %found(WAECOLCP)
     c                   endif                                                  %found(WAECOLCP)

     c                   eval      tstamp   =  tstampi
     c                   exsr      sr3000
     c                   eval      %subst(BUCHUNG: 09: 1) = ' '
     c                   if        (CWSTCK2 > 0 and ARTZ1 <>'EIPROD')
     c                   eval      %subst(BUCHUNG: 09: 1) = '1'
     c                   endif
     c                   exsr      SR5850
     c                   exsr      SR5950
     c                   exsr      sr6000

     c                   seton                                        30
      *                 ## = Neuanlagen                                       
     c                   if        %subst(version: 1: 2) = '##' and
     c                             (anldat > DATUM_AB    )
     c                   if        anldat  >     ##anldat
     c                   z-add     anldat        ##anldat          8 0
     c                   endif
     c                   seton                                        30
     c                   else
     c                   setoff                                       30
     c                   endif
     c                   if        %subst(version: 1: 2) <> '##'
     c                   seton                                        30
      *                 gleich X akzeptieren nur mit Beständen                
     c                   if        teabc1 = 'X' and
     c                             ( C001 > *zero or b001 > *zero or
     c                               B002 > *zero or b003 > *zero or
     c                               B004 > *zero or b005 > *zero )
     c                   else
     c                   setoff                                       30
     C                   if        %subst(version: 1: 2) = '$$' or
     c                             %subst(version: 1: 2) =  'KW'
     c                   seton                                        30
     c                   endif
     c                   endif
      *                 ungleich X akzeptieren ohne Einschränkung             
     c                   if        teabc1 <> 'X'
     c                   seton                                        30
     c                   endif
     c                   endif
     c                   if
     c                             ArtGrp= 'GAR' and ArtGrp= 'WER' and
     c                             ArtGrp= 'FWK' and ArtGrp= 'PRO' and
     c                             ArtGrp= 'DRU'
     c                   setoff                                       30
     C                   if        %subst(version: 1: 2) = '$$' or
     c                             %subst(version: 1: 2) =  'KW'
     c                   seton                                        30
     c                   endif
     c                   endif
     c                   IF        %found(KALK_FILE)
     c   30              update    KALK_F1
     c                   ELSE
     c   30              write     KALK_F1
     c                   ENDIF                                                  %found(KALK_FILE)
     c                   clear                   BUCHUNG                        %found(WAECOLCP)

     c                   ENDIF

     C     next          tag

     Clr                 seton                                        40
     Clr                 if        *in40 = '1'
     clr                 setoff                                       40
     Clr                 endif
     Clr                 if        %subst(version: 1: 2) = '##'
     clr                 z-add     ##anldat      datum_ab
     Clr                 out       datum_ab
     Clr                 endif
     Clr                 out       #sku
     Clr                 close     kalk_file

     C**************************************************************************
     C* SR2201: KSCHEMASTD Standardschema ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     SR2201        BEGSR
     C*
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMASTD = KALKSCHEMA
     c                   else
     C*
     c                   eval      §lieferant = *blank
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMASTD = KALKSCHEMA
     c                   ENDIF                                                  %found(Kalkschzu)
     C*
     c                   endif
     C*
     C     ##2201        ENDSR
     C*
     C**************************************************************************
     C* SR2202: KSCHEMA Schema ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     SR2202        BEGSR
     C*
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   else
     C*
     c                   eval      §lieferant = *blank
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   ENDIF                                                  %found(Kalkschzu)
     C*
     c                   endif
     C*
     C     ##2202        ENDSR
     C*
     C**************************************************************************
     C* SR2500: EAN-Code lesen aus sbgfan99
     C*-------------------------------------------------------------------------
     C*
     C     SR2500        BEGSR
     C*
     C                   movel     TEEANR        ARTEAN
     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C* SR2500: sku#     lesen aus teew01
     C*-------------------------------------------------------------------------
     C*
     C     SR2501        BEGSR
     C*
     C*
     C                   clear                   ARTSKU
     c     key2501       klist
     c                   kfld                    tefirm
     c                   kfld                    tetenr
     c     KEY2501       chain     #teew                              93
     C*
     c     KEY2501       chain     teew01
     c                   IF        %found(teew01)
     c                   movel     TEEWSKUN      artsku
     c                   if        artsku  <> *blank
     c                   unlock    teew01
     c                   ELSE                                                   %found(WAECOLCP)
     c                                                                          %found(WAECOLCP)
     c                   if        ( %subst(ARTNR: 1: 3) = '444' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '888' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '910' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '991' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '992' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '958' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '913'   )            %found(WAECOLCP)
     c                               and *in93 = '1'                            %found(WAECOLCP)
     c                   movel     artnr         artsku                         %found(WAECOLCP)
     c                   movel     artnr         TEEWSKUN                       %found(WAECOLCP)
     c                   else                                                   %found(WAECOLCP)
     c                   add       1             #sku                           %found(WAECOLCP)
     c                   movel     #sku          TEEWSKUN                       %found(WAECOLCP)
     c                   movel     TEEWSKUN      artsku
     c                   endif                                                  %found(WAECOLCP)
     c                   update    TEEW1                                        %found(WAECOLCP)
     c                                                                          %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)
     c                   Else                                                   %found(WAECOLCP)
     c                   exsr      sr2501b                                      %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)
     c                                                                          %found(WAECOLCP)
     C*
     C     ##2501        ENDSR
     C*
     C**************************************************************************
     C* SR2501b: sku#    update  teew01, da Satz fehlt
     C*-------------------------------------------------------------------------
     C*
     C     SR2501b       BEGSR
     C*
     C*
     C                   clear                   ARTSKU
     c     key2501b      klist
     c                   kfld                    tefirm
     c                   kfld                    artnr
     c     KEY2501b      chain     #teew                              93
     C*
     c                   if        ( %subst(ARTNR: 1: 3) = '444' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '888' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '910' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '991' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '992' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '958' or             %found(WAECOLCP)
     c                               %subst(ARTNR: 1: 3) = '913'   )            %found(WAECOLCP)
     c                               and *in93 = '1'                            %found(WAECOLCP)
     c                   clear                   TEEW1                          %found(WAECOLCP)
     c                   movel     tefirm        TEEWFIRM                       %found(WAECOLCP)
     c                   movel     artnr         TEEWTENR                       %found(WAECOLCP)
     c                   movel     artnr         artsku                         %found(WAECOLCP)
     c                   movel     artnr         TEEWSKUN                       %found(WAECOLCP)
     c                   clear                   TEEWPRGR                       %found(WAECOLCP)
     c                   else                                                   %found(WAECOLCP)
     c                   clear                   TEEW1                          %found(WAECOLCP)
     c                   movel     tefirm        TEEWFIRM                       %found(WAECOLCP)
     c                   movel     artnr         TEEWTENR                       %found(WAECOLCP)
     c                   add       1             #sku                           %found(WAECOLCP)
     c                   movel     #sku          TEEWSKUN                       %found(WAECOLCP)
     c                   movel     TEEWSKUN      artsku
     c                   clear                   TEEWPRGR                       %found(WAECOLCP)
     c                   endif                                                  %found(WAECOLCP)
     c                   write     TEEW1                                        %found(WAECOLCP)
     c                                                                          %found(WAECOLCP)
     C*
     C     ##2501b       ENDSR
     C*
     C**************************************************************************
     C* SR2550: lesen Lagermengen aus #kp0105l1
     C*         mengenaddition aus sbgart00
     C*-------------------------------------------------------------------------
     C*
     C     SR2550        BEGSR
     C*
     C                   clear                   a001
     C                   clear                   a002
     C                   clear                   a003
     C                   clear                   a004
     C*
     c     artnr         chain     #kp0105l1
     c                   IF        %found(#kp0105l1)
     C                   select
     C                   when      LBBSLANR = '001'
     c                   eval      a001 = a001 + AMOUNT
     c                   when      LBBSLANR = '500'
     c                   eval      a002 = a002 + AMOUNT
     c                   when      LBBSLANR = '510'
     c                   eval      a003 = a003 + AMOUNT
     c                   when      LBBSLANR = '590'
     c                   eval      a004 = a004 + AMOUNT
     c                   other
     c                   ENDsl                                                  %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C*
     C     ##2550        ENDSR
     C*
     C*
     C**************************************************************************
     C* SR3000: lesen anteilige arbeitskosten für den Artikel
     C*-------------------------------------------------------------------------
     C*
     C     SR3000        BEGSR
     C*
     C
     C                   clear                   CCSTCK2
     C                   clear                   CWSTCK2
     C
     C     KEY3000       KLIST
     C                   KFLD                    TETENR
     C*
     C     KEY3000       SETLL     #pr0011l1                          95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #pr0011l1                              95
     C     *IN95         IFEQ      '1'
     c     TETENR        orne      UPTENR
     C                   leave
     C                   else
     C                   eval      CCSTCK2=(1     +CCSTCK2)
     C                   eval      CWSTCK2=(UPSTZT+CWSTCK2)
     C                   endif
     C                   enddo
     C                   endif
     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C* SR3050: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR3050        BEGSR
     C*
     C
     C                   clear                   $key1
     C                   clear                   $key2
     C                   clear                   $key3
     C                   movel     nxt_jahr      $key1
     C                   movel     '      '      $key2
     C                   movel     '      '      $key3
     C
     C     KEY3050       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c     KEY3050       chain     systempf
     c                   IF        %found(systempf)
     c*
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##3050        ENDSR
     C*
     C**************************************************************************
     C* SR3060: Teilestamm lesen Ermittlung des korrekten Preises
     C*-------------------------------------------------------------------------
     C*
     C     SR3060        BEGSR
     C*
     C*
     C     ##3060        ENDSR
     C*
     C**************************************************************************
     C* SR5500: lesen trtp00, um zu ermitteln, ob ein Lieferant mit 90733
     C*         gelesen werden musse
     C*-------------------------------------------------------------------------
     C*
     C     SR5500        BEGSR
     C*
     c     KEY5500       klist
     c                   kfld                    tpfirm
     c                   kfld                    tpspcd
     c                   kfld                    tptart
     c                   kfld                    tptcde
     C*
     c                   movel     testlf        #testlf          10
     c                   clear                   sabe              3
     c                   eval      sabe = %subst(testlf: 03: 3)
     C*
     C                   movel     '01'          tpfirm
     C                   movel     'D'           tpspcd
     C                   movel     'SABE      '  tptart
     C                   clear                   tptcde
     C                   movel     sabe          tptcde
     C*
     c     KEY5500       chain     trtp00
     c                   IF        %found(trtp00)
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5500        ENDSR
     C*
     C**************************************************************************
     C* SR5600: lesen prei1 über SABE
     C*-------------------------------------------------------------------------
     C*
     C     SR5600        BEGSR
     C*
     c                   IF        %found(trtp00)
     c                   movel     '90733'       testlf
     c                   movel     'SABE'        lieferant2
     c                   move      sabe          lieferant2
     c                   ENDIF                                                  %found(WAECOLCP)
     c                   movel     TESTLF        lieferant1
     c                   eval      %subst(BUCHUNG: 10: 1) = '1'
     c     preikey       setll     prei1
     c                   DOU       %eof(prei02)
     c     preikey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = testlf
     c                   eval      %subst(BUCHUNG: 10: 1) = ' '
     c                   eval      WACDEK   = prwacd

     c                   z-add     1             faktor            5 0
     c                   if        prpdvk='1'
     c                   z-add     1             faktor
     c                   endif                                                  prpdvk=1
     c                   if        prpdvk='2'
     c                   z-add     10            faktor
     c                   endif                                                  prpdvk=2
     c                   if        prpdvk='3'
     c                   z-add     100           faktor
     c                   endif                                                  prpdvk=3
     c                   if        prpdvk='4'
     c                   z-add     1000          faktor
     c                   endif                                                  prpdvk=4
     c                   if        prpdvk='5'
     c                   z-add     10000         faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='6'
     c                   z-add     100000        faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='7'
     c                   z-add     5             faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='8'
     c                   z-add     25            faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='9'
     c                   z-add     500           faktor
     c                   endif                                                  prpdvk=5
     C                   movel     prpdvk        FAKTOR#
     C                   movel     PRMEPR        PRMEPR#

     c                   z-add     PRGADA        datumv
     c                   z-add     PRGBDA        datumb
     c                   z-add     PREZPR        WEKPR
     c                   eval      wekpr = wekpr/faktor
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   eval      wekpr=wekpr/TUUFAK
     c                   IF        tuufak <> 1
     c                   eval      %subst(BUCHUNG: 08: 1) = '$'                 %found(WAECOLCP)
     c                   ENDIF
     c                   ENDIF

     c                   ENDIF                                                  not %eof(prei02)
     C                   ENDDO                                                  %eof(prei02)
     C*
     C                   movel     TEPDEK        FAKTOR#ek
     C*
     c                   if        %subst(BUCHUNG: 10: 1) = '1'
     c                   exsr      sr5700
     c                   endif
     C*  ek immer noch *zero  druchschn EK  dimension TEPDEK
     c                   if        %subst(BUCHUNG: 10: 1) = '1'
     c                   z-add     1             faktor            5 0
     c                   if        TEPDEK='1'
     c                   z-add     1             faktor
     c                   endif                                                  prpdvk=1
     c                   if        TEPDEK='2'
     c                   z-add     10            faktor
     c                   endif                                                  prpdvk=2
     c                   if        TEPDEK='3'
     c                   z-add     100           faktor
     c                   endif                                                  prpdvk=3
     c                   if        TEPDEK='4'
     c                   z-add     1000          faktor
     c                   endif                                                  prpdvk=4
     c                   if        TEPDEK='5'
     c                   z-add     10000         faktor
     c                   endif                                                  prpdvk=5
     c                   if        TEPDEK='6'
     c                   z-add     100000        faktor
     c                   endif                                                  prpdvk=5
     c                   if        TEPDEK='7'
     c                   z-add     5             faktor
     c                   endif                                                  prpdvk=5
     c                   if        TEPDEK='8'
     c                   z-add     25            faktor
     c                   endif                                                  prpdvk=5
     c                   if        TEPDEK='9'
     c                   z-add     500           faktor
     c                   endif                                                  prpdvk=5
     C                   movel     TEPDEK        FAKTOR#
     C                   movel     PRMEPR        PRMEPR#

     c**********         z-add     PRGADA        datumv
     c**********         z-add     PRGBDA        datumb
     c                   z-add     tedupr        WEKPR
     c                   eval      wekpr = wekpr/faktor
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   eval      wekpr=wekpr/TUUFAK
     c                   IF        tuufak <> 1
     c                   eval      %subst(BUCHUNG: 08: 1) = '$'                 %found(WAECOLCP)
     c                   ENDIF
     c                   ENDIF
     c                   eval      %subst(BUCHUNG: 10: 1) = 'P'
     c                   endif
     C*
     C     ##5600        ENDSR
     C*
     C**************************************************************************
     C* SR5700: lesen prei1 II
     C*-------------------------------------------------------------------------
     C*
     C     SR5700        BEGSR
     C*
     c                   movel     #TESTLF       testlf
     c                   movel     TESTLF        lieferant1
     c                   eval      %subst(BUCHUNG: 10: 1) = '1'
     c     preikey       setll     prei1
     c                   DOU       %eof(prei02)
     c     preikey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = testlf
     c                   eval      %subst(BUCHUNG: 10: 1) = ' '
     c                   eval      WACDEK   = prwacd

     c                   z-add     1             faktor            5 0
     c                   if        prpdvk='1'
     c                   z-add     1             faktor
     c                   endif                                                  prpdvk=1
     c                   if        prpdvk='2'
     c                   z-add     10            faktor
     c                   endif                                                  prpdvk=2
     c                   if        prpdvk='3'
     c                   z-add     100           faktor
     c                   endif                                                  prpdvk=3
     c                   if        prpdvk='4'
     c                   z-add     1000          faktor
     c                   endif                                                  prpdvk=4
     c                   if        prpdvk='5'
     c                   z-add     10000         faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='6'
     c                   z-add     100000        faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='7'
     c                   z-add     5             faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='8'
     c                   z-add     25            faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='9'
     c                   z-add     500           faktor
     c                   endif                                                  prpdvk=5
     C                   movel     prpdvk        FAKTOR#
     C                   movel     PRMEPR        PRMEPR#

     c                   z-add     PRGADA        datumv
     c                   z-add     PRGBDA        datumb
     c                   z-add     PREZPR        WEKPR
     c                   eval      wekpr = wekpr/faktor

     c                   ENDIF                                                  not %eof(prei02)
     C                   ENDDO                                                  %eof(prei02)
     C*
     C     ##5700        ENDSR
     C*
     C**************************************************************************
     C* SR5800: BBEP09
     C*-------------------------------------------------------------------------
     C*
     C     SR5800        BEGSR
     C*
     c     KEY5800       klist
     c                   kfld                    EPFIRM
     c                   kfld                    eptenr
     C*
     C                   movel     '01'          EPFIRM
     c                   movel     artnr         eptenr
     C*
     c                   eval      %subst(BUCHUNG: 11: 1) = ' '                 %found(WAECOLCP)
     c     KEY5800       chain     bbep09
     c                   IF        %found(BBEP09)
     c                   else                                                   %found(WAECOLCP)
     c                   eval      %subst(BUCHUNG: 11: 1) = 'D'                 %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5800        ENDSR
     C*

     C**************************************************************************
     C* SR5850: TEOS01
     C*-------------------------------------------------------------------------
     C*
     C     SR5850        BEGSR
     C*
     c     KEY5850       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '1000'        TEOSKLCD
     c                   movel     artnr         TEOSTENR
     C*
     c     KEY5850       chain     TEOS01
     c                   IF        %found(TEOS01)
     c                   movel     TEOSMM01      ##u              10 0
     c     ##u           div       10            laenge
     c                   movel     TEOSMM02      ##u              10 0
     c     ##u           div       10            breite
     c                   movel     TEOSMM03      ##u              10 0
     c     ##u           div       10            hoehe
     c                   movel     TEOSMM04      ##u              10 0
     c     ##u           div       1000          gewicht
     c                   movel     TEOSMM05      ##u              10 0
     c     ##u           div       10            vlaenge
     c                   movel     TEOSMM06      ##u              10 0
     c     ##u           div       10            vbreite
     c                   movel     TEOSMM07      ##u              10 0
     c     ##u           div       10            vhoehe
     c                   movel     TEOSMM08      ##u              10 0
     c     ##u           div       1000          vgewicht
     c                   movel     TEOSMM09      ##u              10 0
     c     ##u           div       1             veh
     c                   else                                                   %found(WAECOLCP)
     c                   eval      %subst(BUCHUNG: 13: 1) = 'E'                 %found(WAECOLCP)
     c                   clear                   laenge
     c                   clear                   breite
     c                   clear                   hoehe
     c                   clear                   gewicht
     c                   clear                   vlaenge
     c                   clear                   vbreite
     c                   clear                   vhoehe
     c                   clear                   vgewicht
     c                   clear                   veh
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5850        ENDSR
     C*
     C**************************************************************************
     C* SR5888: waehrung
     C*-------------------------------------------------------------------------
     C*
     C     SR5888        BEGSR
     C*
     c     KEY5888       klist
     c                   kfld                    nxt_jahr
     c                   kfld                    wacdek
     C*
     c     KEY5888       chain     waehrungk
     c                   IF        %found(WAEHRUNGk)
     c                   eval      KWAKURS    = KWAKURS                         %found(WAECOLCP)
     c                   else                                                   %found(WAECOLCP)
     c*********          eval      %subst(BUCHUNG: 11: 1) = 'D'                 %found(WAECOLCP)
     c                   eval      KWAKURS    = 1                               %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5888        ENDSR
     C*

     C**************************************************************************
     C* SR5900: teuf00 Mengeneinheiten
     C*-------------------------------------------------------------------------
     C*
     C     SR5900        BEGSR
     C*
     c*  Schlüsselliste für teuf00
     c     key5900       klist
     c                   kfld                    FIRMA
     c                   kfld                    tuTENR
     c                   kfld                    tumein

     C                   movel     '01'          FIRMA
     c                   movel     artnr         tuTENR
     c                   movel     temeek        tumein
     c                   movel     temeek        temeek#

     c     KEY5900       chain     teuf00
     c                   IF        %found(teuf00)
     c                   ENDIF

     C*
     C     ##5900        ENDSR

     C**************************************************************************
     C* SR5950: es fehlt immer noch der stk_LCP, daher Error
     C*-------------------------------------------------------------------------
     C*
     C     SR5950        BEGSR
     C*
      *                  wenn kein Preis vorhanden, stk_lcp über Artikeldate
     c                   if        stk_lcp = *zero
     c                   eval      %subst(BUCHUNG: 12: 1) = 'E'                 %found(WAECOLCP)
     c                   endif
     C*
     C     ##5950        ENDSR
     C*
     C**************************************************************************
     C* SR6000: Druckausgabesteuerung
     C*-------------------------------------------------------------------------
     C*
     C     SR6000        BEGSR
     C*
     C                   clear                   DRUCK001
     C                   clear                   DRUCK002
     C                   clear                   DRUCK003
     C                   if        STATNR <> '201' and STATNR <> '202' and      PROTECTED
     C                             STATNR <> '203' and STATNR <> '204' and      PROTECTED
     C                             STATNR <> '207' and STATNR <> '211' and      PROTECTED
     C                             STATNR <> '290' and STATNR <> '299' and      PROTECTED
     C                             STATNR <> '301' and STATNR <> '302' and      PROTECTED
     C                             STATNR <> '311' and STATNR <> '321' and      PROTECTED
     C                             STATNR <> '322' and STATNR <> '409' and      PROTECTED
     C                             STATNR <> '413' and STATNR <> '414' and      PROTECTED
     C                             STATNR <> '416' and STATNR <> '417' and      PROTECTED
     C                             STATNR <> '418' and STATNR <> '419' and      PROTECTED
     C                             STATNR <> '420' and STATNR <> '422' and      PROTECTED
     C                             STATNR <> '423' and STATNR <> '426' and      PROTECTED
     C                             STATNR <> '490' and STATNR <> '499' and      PROTECTED
     C                             STATNR <> '420' and STATNR <> '422'          PROTECTED
     C                   if        %subst(statnr: 1: 1) <> '1' and              PROTECTED
     C***************              %subst(statnr: 1: 1) <> '6' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '8' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '9'                  PROTECTED
     C                   movel     '1'           DRUCK001
     C                   ENDif
     C                   ENDif
     C                   if        %subst(statnr: 1: 1) =  '2'  and             PROTECTED
     C                             druck001 = '1'
     C                   movel     ' '           DRUCK001
     C                   else
      *                 30032010  Zeitfenster 1.4. d.J                        
     C                   if        %subst(statnr: 1: 1) =  '1' or               PROTECTED
     C                             %subst(statnr: 1: 1) =  '2'                  PROTECTED
     C                   movel     '1'           DRUCK001
     C                   else
     C                   movel     ' '           DRUCK001
     C                   endif
     C                   endif
      *                 Anlage neue Artikel immer in Preisliste über Kalku.   
     c                   if        %subst(version: 1: 2) = '##'
     C                   movel     '1'           DRUCK001
     C                   endif
     C
     C* Brunne/Päge  über Druck002
     C                   if        STATNR <> '190' and STATNR <> '290' and      PROTECTED
     C                             STATNR <> '301' and STATNR <> '302' and      PROTECTED
     C                             STATNR <> '321' and STATNR <> '322' and      PROTECTED
     C                             STATNR <> '324' and STATNR <> '409' and      PROTECTED
     C                             STATNR <> '413' and STATNR <> '414' and      PROTECTED
     C                             STATNR <> '416' and STATNR <> '417' and      PROTECTED
     C                             STATNR <> '418' and STATNR <> '419' and      PROTECTED
     C                             STATNR <> '420' and STATNR <> '421' and      PROTECTED
     c                             STATNR <> '422' and STATNR <> '423' and      PROTECTED
     c                             STATNR <> '426' and STATNR <> '490' and      PROTECTED
     c                             STATNR <> 'xxx' and                          PROTECTED
     C                             %subst(statnr: 1: 1) <> '6' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '8' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '9'                  PROTECTED
     C                   movel     '1'           DRUCK002
     C                   ENDif
     C*
     C     ##6000        ENDSR
     C*
     C**************************************************************************
     C* SR7000:
     C*-------------------------------------------------------------------------
     C*
     C     SR7000        BEGSR
     C*
     c     key7000       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA
     c                   kfld                    PRKDLG

     c                   movel     '01'          PRFIRM
     c                   movel     'PKG'         PRBEGR
     c                   movel     tetenr        PRTENR
     c                   movel     'EUR'         PRWACD
     c                   movel     '071'         PRGADA
     c                   movel                   PRKDLG

     C     KEY7000       SETLL     #PREIL1                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL1                                92
     C     *IN95         IFEQ      '1'
     c     TETENR        orne      PRTENR
     C                   leave
     C                   else
     C                   eval      ICS_    =      PREZPR
     C                   endif
     C                   enddo
     C                   endif

     C   93              clear                   phy01r
     C*
     C     ##7000        ENDSR
     C*
     C**************************************************************************
     C* *inzsr  Druckausgabesteuerung
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     c                   move      '01'          firma
     c                   movel     'XYZ3454354'  tenr
     c                   movel     'LP1'         begr
     c                   movel     '001'         lager             3

     c                   if        %subst(version: 1: 2) = '##'
     C*                  Gültigkeitsdatum
     C     *DTAARA       DEFINE                  DATUM_AB          8 0
     C     *lock         IN        DATUM_AB
     C                   endif

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   kalk_file
     c/end-exec
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   eval      nxt_jahr = pjahr
     C
     c                   if        %subst(version: 1: 4) = '2011'
     C                   eval      nxt_jahr = pjahr + 1
     c                   endif
     C
     C                   movel     nxt_jahr      #hlp001           4
     C                   movea(p)  #hlp001       md(001)
     C                   movea(p)  version       md(005)
     C
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#KA0600'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *blank        REPADD           10
     C                   clear                   md

     c     *DTAARA       DEFINE                  #sku             10 0
     c     *lock         IN        #sku
     c
     c
     C                   open      kalk_file

     C                   ENDSR
