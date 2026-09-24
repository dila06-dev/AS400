     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*                                                          *
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  Kalkulation ausführen                                   *
     F*  lpif01  unser Artikel - Artikel des Lieferanten        *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     fsbgart00  ip   e           k disk
     fTEIL00    if   e           k disk
     fLAND01    if   e           k disk
     fPREI02    if   e           k disk
     fTEOS01    if   e           k disk

     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
     fARTNR_KALKif   e           k disk    prefix('Z')
     fFRACHTKS  if   e           k disk
     fZollta2lf if   e           k disk
     fSLAZSlf   if   e           k disk
     fWAECOLCP  if   e           k disk
     f#KA0290L1 if   e           k disk    prefix('S')
     fsbgarb00  if   e           k disk
     fsbgarb97  if   e           k disk
     fsbgprs00  if   e           k disk
     fartier    if   e           k disk
     fE_STK_LCP if   e           k disk
     fE_preis_pmif   e           k disk
     fE_preis2pmif   e           k disk
     fE_preis3pmif   e           k disk
     fE_ics_aj  if   e           k disk
     fE_ics2aj  if   e           k disk
     fsbgfan99  if   e           k disk
     f#pr0011l1 if   e           k disk
     fsystempf  if   e           k disk
     ftrtp00    if   e           k disk
     fbbep09    if   e           k disk
     f#kp0105l1 if   e           k disk
     fTeuf00    if   e           k disk
     fwaehrungk if   e           k disk

     fKALK_FILE uf a e           k disk
     F                                     USROPN

     dfirma            s                   like(slazfirm)
     dpekpr            s                   like(ekpr)
     dbegr             s                   like(prbegr)
     dtenr             s                   like(PRTENR)
     dlager            s                   like(arb020)
     dics_nr           s                   like(prs020)
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

     c*  Schlüsselliste für kalk_file
     c     kalkkey       klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art020
     c                   kfld                    art030
     c                   kfld                    version

     c*  Schlüsselliste für #ka0290
     c     kcjkey        klist
     c                   kfld                    key_jahr
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für teil00
     c     teilkey       klist
     c                   kfld                    firma
     c                   kfld                    art030

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
     c                   kfld                    art050
     c                   kfld                    §lieferant

     c*  Schlüsselliste für SLAZSlf
     c     keyslazs      klist
     c                   kfld                    firma
     c                   kfld                    art030

     c*  Schlüsselliste für WAECOLCP
     c     LCPkey        klist
     c                   kfld                    art010
     c                   kfld                    art020
     c                   kfld                    art030
     c                   kfld                    key_jahr

     c*  Schlüsselliste für SBGARB00
     c     arbkey        klist
     c                   kfld                    art010
     c                   kfld                    lager
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für SBGPRS00
     c     PRSkey        klist
     c                   kfld                    art010
     c                   kfld                    ICS_NR
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für E_stk_lcp (Kalk_basis STK-LCP)
     c     key002        klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art020
     c                   kfld                    art030

     c*  sbgfan99 für ean-code
     c     key003        klist
     c                   kfld                    art010
     c                   kfld                    art020
     c                   kfld                    art030

     C     *ENTRY        PLIST
     C                   PARM                    version

     c     kalkkey       chain     KALK_F1
     c                   IF        %found(KALK_FILE)
     c                   IF        status='F'
     c                   goto      next
     c                   ENDIF                                                  status='F'
     c                   ENDIF                                                  %found(KALK_FILE)
     c*********              clear                   KALK_F1
     c                   movel     art050        StatNr
     c****               IF        ( %subst(statnr: 1: 3) = '197' or
     c****                           %subst(statnr: 1: 3) = '198' or
     c****                           %subst(statnr: 1: 3) = '199'    ) and
     c*************      IF        art180<>'X' and
     c*************                art180<>'Z' and
     c*************                art180<>'K' and
     c                   IF        art180<>'<' and
     c                             art180<>'<' and
     c                             art180<>'<'
     c****** raus ****             art050='418' and
     c*************                art040<>'GAR' and art040<>'WER' and
     c*************                art040<>'FWK' and art040<>'PRO' and
     c*************                art040<>'DRU'
     c                   IF        %subst(statnr: 1: 3) = '197'
     c                   clear                   ff                1 0
     c                   endif


     c                   z-add     nxt_jahr      Jahr
     c                   movel     art020        LiefNr
     c                   movel     art030        ArtNr
     c                   movel     art040        ArtGrp
     c                   movel     art050        StatNr
     c                   movel     art170        ERSETZ
     c                   movel     art200        PREISKDU
     c                   movel     art180        ABC
     c                   movel     art060        ARTBEZ
     c                   movel     art340        WACDVK
     c                   z-add     art950        EVP_A_BR
     c                   eval      EVP_NEU1 = ( EVP_A_BR * 1,03 )
     c                   eval      EVP_NEU2 = ( EVP_A_BR * 1,05 )
     c                   eval      EVP_AJ = ART950 / 1,19
     c*                  movel     ART510        LIEFNR
     c                   movel     ART220        ZOLLNR
     c                   movel     ART390        ARTZ1
     c                   movel     ART400        ARTZ2
     c                   movel     ART550        ARTZ3
     c                   z-add     ART240        ARTGEW
     c                   movel     ART280        jj                2 0
     c                   movel     ART280        jjmm              4 0
     c                   move      ART280        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      anldat=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        anldat > 20500000
     c                   movel     '19'          anldat
     c                   endif

      * alter Preis und gültig ab Datum
     c                   z-add     art270        ##art270
     c                   z-add     art280        ##art280
     c                   movel     ART280        jj                2 0
     c                   movel     ART280        jjmm              4 0
     c                   move      ART280        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      ##ART280B=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        ##ART280B> 20500000
     c                   movel     '19'          ##ART280B
     c                   endif
      * derzeit gültiger Preis und ab Datum
     c                   z-add     art290        ##art290
     c                   z-add     art300        ##art300
     c                   movel     ART300        jj                2 0
     c                   movel     ART300        jjmm              4 0
     c                   move      ART300        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      ##ART300B=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        ##ART300B> 20500000
     c                   movel     '19'          ##ART300B
     c                   endif
      * neuer gültiger Preis und gültig ab Datum
     c                   z-add     art310        ##art310
     c                   z-add     art320        ##art320
     c                   movel     ART320        jj                2 0
     c                   movel     ART320        jjmm              4 0
     c                   move      ART320        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      ##ART320B=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        ##ART320B> 20500000
     c                   movel     '19'          ##ART320B
     c                   endif

     c                   if        ARTZ1='EIPROD' or ARTZ1='EIPRO'
     c                   eval      GKSatz = 0.1
     c                   else
     c                   eval      GKSatz = 0
     c                   endif                                                  ARTZ1='EIPROD'

     c* Fixfelder
     c                   eval      WERKZEUG   = 0
     c                   eval      ENTWICKLUN = 0
     c                   eval      PRODUKTION = 0
     c                   eval      BEISTELL   = 0
     c                   eval      KONFEKTION = 0
     c                   eval      CWSTCK2W   = 0

     c                   eval      PREIS_PM   = 0
     c                   if        statnr <> '342'
     c* Preis_pm einlesen aus Excel-files, wenn Daten vorhanden
     c     key002        chain     E_preis_pm
     c                   IF        %found(E_preis_pm)
     c                   z-add     #PREIS_PM     preis_pm
     c                   endif
      *
     c* Preis2pm einlesen aus Excel-files, wenn Daten vorhanden
     c     key002        chain     E_preis2pm
     c                   IF        %found(E_preis2pm)
     c                   z-add     #PREIS_PM     preis_pm
     c                   endif
     c                   endif
      *
     c* Preis3pm einlesen aus Excel-files, wenn Daten vorhanden
     c     key002        chain     E_preis3pm
     c                   IF        %found(E_preis3pm)
     c                   z-add     #PREIS_PM     preis_pm
     c                   endif
      *
     c* wenn preis_pm = *zero für statnr = '342' dann Wert aus evp_a_br
     c* Besprechung 6.1.2010 Erdmann, Luetjen, Poschmann
     c                   IF        StatNr ='342' and preis_pm = *zero
     c                   z-add     evp_a_br      preis_pm
     c                   endif
      *
     c* wenn statnr = '6xx' dann erhält Preis_pm Wert aus evp_a_br
     c* Besprechung 6.1.2010 Erdmann, Luetjen, Poschmann
     c                   IF        %subst(statnr: 1: 1) = '6'
     c                   z-add     evp_a_br      preis_pm
     c                   endif
      *
     c* wenn statnr = '6xx' dann erhält ics Wert aus ICS_aj
     c* Besprechung 6.1.2010 Erdmann, Luetjen, Poschmann
     c                   IF        %subst(statnr: 1: 1) = '6'
     c                   z-add     ICS_aj        ics
     c                   endif
      *
     c                   eval      WAKURS     = 1
     c* Ersatzartikel ermitteln
     c     art030        chain     artier
     c                   IF        %found(artier)
     c                   Else
     c                   clear                   e1
     c                   clear                   e2
     c                   clear                   e3
     c                   clear                   e4
     c                   clear                   e5
     c                   clear                   e6
     c                   clear                   e7
     c                   clear                   e8
     c                   clear                   e9
     c                   clear                   e10
     c                   endif

     c* LCP's ermitteln
     c                   z-add     0             COSTPRS_VJ
     c                   movel     vj_jahr       key_jahr
     c     LCPKey        chain     LCP00R1
     c                   IF        %found(WAECOLCP)
     c                   z-add     LCP160        COSTPRS_VJ
     c                   ENDIF                                                  %found(WAECOLCP)
     c                   z-add     0             COSTPRS_AJ
     c                   movel     pjahr         key_jahr
     c     LCPKey        chain     LCP00R1
     c                   IF        %found(WAECOLCP)
     c                   z-add     LCP160        COSTPRS_AJ
     c                   ENDIF                                                  %found(WAECOLCP)

     c* KCJ ermitteln
     c                   z-add     0             KCJMNG_VJ
     c                   z-add     0             KCJUMS_VJ
     c                   z-add     0             KCJROH_VJ
     c                   movel     vj_jahr       key_jahr
     c     kcjKey        chain     #ka0290l1
     c                   IF        %found(#ka0290l1)
     c                   z-add     SMENGEN       KCJMNG_VJ
     c                   z-add     SUMSATZ       KCJUMS_VJ
     c                   z-add     SROHERL       KCJROH_VJ
     c                   ENDIF                                                  %found(WAECOLCP)

     c                   z-add     0             KCJMNG_AJ
     c                   z-add     0             KCJUMS_AJ
     c                   z-add     0             KCJROH_AJ
     c                   z-add     0             MIBT
     c                   z-add     0             ROHS_AJ
     c                   movel     pjahr         key_jahr
     c     kcjKey        chain     #ka0290l1
     c                   IF        %found(#ka0290l1)
     c                   z-add     SMENGEN       KCJMNG_AJ
     c                   z-add     SUMSATZ       KCJUMS_AJ
     c                   z-add     SROHERL       KCJROH_AJ
     c                   if        KCJMNG_AJ <> 0
     c                   eval      mibt = KCJUMS_AJ / KCJMNG_AJ
     c                   ENDIF                                                  KCJMNG_AJ <> 0
     c                   if        KCJUMS_AJ <> 0
     c                   eval      ROHS_AJ = KCJROH_AJ/KCJUMS_AJ
     c                   ENDIF                                                  KCJMNG_AJ <> 0
     c                   ENDIF                                                  %found(WAECOLCP)

     c* SBGARB00 lesen
     c                   z-add     0             COSTPRS_AR
     c                   z-add     0             VKMENGE_VJ
     c                   z-add     0             VKMENGE_AJ
     c                   z-add     0             STK_LCP
     c                   z-add     0             STK_LCP_a
     c     arbKey        chain     ARB00R1
     c                   IF        %found(SBGARB00)
     c                   z-add     ARB220        COSTPRS_AR
     c                   eval      VKMENGE_AJ = ARB740 + ARB730 + ARB720 +
     c                             ARB710 + ARB700 + ARB690 +
     c                             ARB680 + ARB670 + ARB660 +
     c                             ARB650 + ARB640 + ARB630
     c                   eval      VKMENGE_VJ = ARB620 + ARB610 + ARB600 +
     c                             ARB590 + ARB580 + ARB570 +
     c                             ARB560 + ARB550 + ARB540 +
     c                             ARB530 + ARB520 + ARB510
     c                   z-add     ARB870        VKMENGE_VJ
     c                   z-add     ARB220        STK_LCP
     C                   clear                   b001
     C                   clear                   b002
     C                   clear                   b003
     C                   clear                   b004
     C                   clear                   b005
     C                   clear                   c001
     C*                  Inventur  Menge
     c                   z-add     arb150        b001                           Inventur  Menge
     C*                  Einkauf  Menge
     c                   z-add     arb200        b002
     C*                  Verkauf  Menge
     c                   z-add     arb280        b003
     C*                  Mengen  Kundenrückstellungen
     c                   z-add     arb300        b004
     C*                  Mengen         Bestellungen offen + Abrufaufträge
     c                   eval      b005=arb320             + arb310
     c                   eval      c001=(arb150+arb200-arb280-arb300+b005)
     c                   else                                                   %found(WAECOLCP)
     c                   exsr      sr7000                                       %found(WAECOLCP)
     c                   ENDIF                                                  %found(WAECOLCP)

     c                   exsr      sr2550

     c* veränderter STK_LCP einlesen aus Excel-Umgebungen etc.
     c* wenn anlagedatum > 20090000
     c                   clear                   STK_LCP_a
     c                   if        anldat > 20090000
     c     key002        chain     E_STK_LCP
     c                   IF        %found(E_STK_LCP)
     c                   if        lcp  <>  arb220
     c                   z-add     lcp           STK_LCP
     c                   z-add     ARB220        STK_LCP_a
     c                   endif
     c                   endif
     c                   endif

     c* TEIL-Satz lesen
     c     teilkey       chain     TEIL1
     c                   IF        %found(TEIL00)

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
     c     art220        chain     Zollta2
     c                   IF        %found(zollta2lf)
     c                   eval      ZOLLSATZ = satz1
     c                   else
     c                   eval      ZOLLSATZ = 0
     c                   ENDIF                                                  %found(zollta2lf)
     c                   ENDIF                                                  LNLDGR = '0001'
     c                   if        statnr = '342'
     c                   eval      ZOLLSATZ = 0
     c                   ENDIF                                                  LNLDGR = '0001'

     c                   ENDIF                                                  %found(land01)

     c* EKP bestimmen
     c                   IF        artnr= '388 0165-80/2' or
     c                             artnr= '388 0165-80/2'
     c                   move      '1'           tets              1
     c                   endif
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

     c                   if        %subst(artz1: 1: 3) = 'KON'
     c                   eval      %subst(BUCHUNG: 10: 1) = ' '
     c                   endif

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

     c* SBGPRS00-Satz bestimmen
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      ics_aj = prs050
     c                   else
     c                   eval      ics_aj = 0
     c                   ENDIF                                                  %found(sbgprs00)

     c* veränderter ics_aj einlesen aus Excel-Umgebungen etc.
     c                   clear                   ICS_AJ_A                       %found(WAECOLCP)
     c     key002        chain     E_ics_aj
     c                   IF        %found(E_ics_aj)
     c                   if        ics_aj <>  #ICS_AJ
     c                   z-add     ics_aj        ics_aj_a
     c                   z-add     #ICS_AJ       ics_aj
     c                   endif
     c                   endif                                                  %found(WAECOLCP)
     c* veränderter ics_aj einlesen aus Excel-Umgebungen etc.
     c     key002        chain     E_ics2aj
     c                   IF        %found(E_ics2aj)
     c                   if        ics_aj <>  #ICS_AJ
     c                   z-add     ics_aj        ics_aj_a
     c                   z-add     #ICS_AJ       ics_aj
     c                   endif
     c                   endif                                                  %found(WAECOLCP)

     c                   if        kwakurs = 0
     c                   eval      kwakurs = 1
     c                   endif

      *                  wenn kein Preis vorhanden, stk_lcp über Artikeldate
     c                   if        stk_lcp = *zero
     c                   z-add     ARt330        STK_LCP
     c                   if        art340 = 09
     c                   eval      STK_LCP = stk_lcp/KWAKURS
     c                   endif
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
     c                   if        LiefNr = '103' or LiefNr = '733' or
     c                             LiefNr = '363' or LiefNr = '819' or
     c                             LiefNr = '110' or LiefNr = '526' or
     c                             LiefNr = '540'
     c                   else
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

     c******             if        art950<>0
     c******             eval      PAENDERUNG = (100 * EVP_N_BR / ART950) - 100
     c******             endif                                                  art950<>0

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
     c                   if        p<> 0
     c***** Hause        eval      MARGE_NEU1=
     c***** Hause                  (EVP_NEU1/1,19*
     c***** Hause                  (1-(GHRABS/100))-KALKBASIS) /
     c***** Hause                  p
     c                   endif
     c
     c                   eval      p=
     c                             ((EVP_NEU2/1,19) *
     c                             (1-(GHRABS/100))/100)
     c*
     c                   if        p<> 0
     c***** Hause        eval      MARGE_NEU2=
     c***** Hause                  ((EVP_NEU2/1,19)*
     c***** Hause                  (1-(GHRABS/100))-KALKBASIS) /
     c***** Hause                  p
     c                   endif
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
     c                   exsr      sr6005

     c                   seton                                        30
      *                 ## = Neuanlagen                                       
     c                   if        %subst(version: 1: 2) = '##' and
     c                             (anldat > DATUM_AB    )
     c***************              or anldat = DATUM_AB  )
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
     c                   if        art180 = 'X' and
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
     c                   if        art180 <> 'X'
     c                   seton                                        30
     c                   endif
     c                   endif
     c                   if
     c                             art040= 'GAR' and art040= 'WER' and
     c                             art040= 'FWK' and art040= 'PRO' and
     c                             art040= 'DRU'
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

     c                   ENDIF                                                  art180<>'X' 'Z'

     C     next          tag

     Clr                 seton                                        40
     Clr                 if        *in40 = '1'
     clr                 setoff                                       40
     Clr                 endif
     Clr                 if        %subst(version: 1: 2) = '##'
     clr                 z-add     ##anldat      datum_ab
     Clr                 out       datum_ab
     Clr                 endif
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
     C                   clear                   ARTEAN
     C     KEY003        SETLL     sbgfan99
     C                   DO        *HIVAL
     C     KEY003        READE     sbgfan99                               91
     C   91              LEAVE
     C                   if        fan010 = art010  and
     c                             fan040 = art020  and
     c                             fan050 = art030
     C                   if        fan020 = '999'
     C                   movel     fan030        ARTEAN
     c                   leave
     C                   endif                                                  PROTECTED
     c                   else
     c                   leave
     C                   endif                                                  PROTECTED
     C                   ENDDO
     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C* SR2500: sku#     lesen aus sbgfan99
     C*-------------------------------------------------------------------------
     C*
     C     SR2501        BEGSR
     C*
     C                   clear                   ARTSKU
     C     KEY003        SETLL     sbgfan99
     C                   DO        *HIVAL
     C     KEY003        READE     sbgfan99                               91
     C   91              LEAVE
     C                   if        fan010 = art010  and
     c                             fan040 = art020  and
     c                             fan050 = art030
     C                   if        fan020 = '998'
     C                   movel     fan030        ARTSKU
     c                   leave
     C                   endif                                                  PROTECTED
     c                   else
     c                   leave
     C                   endif                                                  PROTECTED
     C                   ENDDO
     C*
     C     ##2501        ENDSR
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
     C                   KFLD                    art030
     C*
     C     KEY3000       SETLL     #pr0011l1                          95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #pr0011l1                              95
     C     *IN95         IFEQ      '1'
     c     art030        orne      UPTENR
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
     C                   if        wekpr <> art330
     c                   if        (wekpr - art330) > 0,02  or
     c                             (wekpr - art330) < -0,02
     c                   eval      %subst(BUCHUNG: 10: 1) = '2'
     C                   endif
     C                   endif

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
     C                   if        wekpr <> art330
     c                   if        (wekpr - art330) > 0,02  or
     c                             (wekpr - art330) < -0,02
     c                   eval      %subst(BUCHUNG: 10: 1) = 'p'
     C                   endif
     C                   endif
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
     C                   if        wekpr <> art330
     c                   if        (wekpr - art330) > 0,02  or
     c                             (wekpr - art330) < -0,02
     c                   eval      %subst(BUCHUNG: 10: 1) = '2'
     C                   endif
     C                   endif

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
     c                   z-add     ARt330        STK_LCP
     c                   if        art340 = 09
     c                   eval      STK_LCP = stk_lcp/KWAKURS
     c                   endif
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
     C* SR6005: preise aus sbgprs00
     C*-------------------------------------------------------------------------
     C*
     C     SR6005        BEGSR
     C*
     C*
     c* SBGPRS00-Satz bestimmen
      *                 EXN-Preise lesen 70xxx                                
     c                   movel     '70XXX'       ics_nr
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      exn_   = prs050
     c                   else
     c                   eval      exn_   = 0
     c                   ENDIF                                                  %found(sbgprs00)
      *                 ICN-Preise lesen 72xxx                                
     c                   movel     '72XXX'       ics_nr
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      icn_   = prs050
     c                   else
     c                   eval      icn_   = 0
     c                   ENDIF                                                  %found(sbgprs00)
      *                 ICS-Preise lesen 73xxx                                
     c                   movel     '73XXX'       ics_nr
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      ics_   = prs050
     c                   else
     c                   eval      ics_   = 0
     c                   ENDIF                                                  %found(sbgprs00)
      *                 EXS-Preise lesen 74xxx                                
     c                   movel     '74XXX'       ics_nr
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      exs_   = prs050
     c                   else
     c                   eval      exs_   = 0
     c                   ENDIF                                                  %found(sbgprs00)
      *                 OEM-Preise lesen 75xxx                                
     c                   movel     '75XXX'       ics_nr
     c     prskey        chain     PRS00R1
     c                   IF        %found(sbgprs00)
     c                   eval      oem_   = prs050
     c                   else
     c                   eval      oem_   = 0
     c                   ENDIF                                                  %found(sbgprs00)
     C*
     C     ##6005        ENDSR
     C*
     C**************************************************************************
     C* SR7000: preise aus SBGARB97 wegen anderes Lager bis arb220 <> *zero
     C*-------------------------------------------------------------------------
     C*
     C     SR7000        BEGSR
     C*
     c     ke7000        klist
     c                   kfld                    art020
     c                   kfld                    art030
     c                   kfld                    art010
     c                   eval      %subst(BUCHUNG: 16: 3) = '###'
     C     KE7000        SETLL     SBGARB97
     C                   DO        *HIVAL
     C     KE7000        READE     SBGARB97                               91
     C   91              LEAVE
     C                   if        art020 = arb030  and
     c                             art030 = arb040  and
     c                             art010 = arb010
     C                   if        ARB220 <> 0
     C*#######
     c                   z-add     ARB220        COSTPRS_AR
     c                   eval      VKMENGE_AJ = ARB740 + ARB730 + ARB720 +
     c                             ARB710 + ARB700 + ARB690 +
     c                             ARB680 + ARB670 + ARB660 +
     c                             ARB650 + ARB640 + ARB630
     c                   eval      VKMENGE_VJ = ARB620 + ARB610 + ARB600 +
     c                             ARB590 + ARB580 + ARB570 +
     c                             ARB560 + ARB550 + ARB540 +
     c                             ARB530 + ARB520 + ARB510
     c                   z-add     ARB870        VKMENGE_VJ
     c                   z-add     ARB220        STK_LCP
     C                   clear                   b001
     C                   clear                   b002
     C                   clear                   b003
     C                   clear                   b004
     C                   clear                   b005
     C                   clear                   c001
     C*                  Inventur  Menge
     c                   z-add     arb150        b001                           Inventur  Menge
     C*                  Einkauf  Menge
     c                   z-add     arb200        b002
     C*                  Verkauf  Menge
     c                   z-add     arb280        b003
     C*                  Mengen  Kundenrückstellungen
     c                   z-add     arb300        b004
     C*                  Mengen         Bestellungen offen + Abrufaufträge
     c                   eval      b005=arb320             + arb310
     c                   eval      c001=(arb150+arb200-arb280-arb300+b005)
     c                   eval      %subst(BUCHUNG: 16: 3) = arb020
     C*#######
     c                   leave
     C                   endif                                                  PROTECTED
     c                   else
     c                   leave
     C                   endif                                                  PROTECTED
     C                   ENDDO
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
     c                   movel     '001'         lager
     c                   movel     '73XXX'       ics_nr

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

     C                   open      kalk_file

     C                   ENDSR
