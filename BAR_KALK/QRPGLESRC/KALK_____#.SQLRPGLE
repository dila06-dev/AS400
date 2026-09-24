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
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     fsbgart00  ip   e           k disk
     fTEIL00    if   e           k disk
     fLAND01    if   e           k disk
     fPREI02    if   e           k disk

     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
     fARTNR_KALKif   e           k disk    prefix('Z')
     fFRACHTKS  if   e           k disk
     fZollta2lf if   e           k disk
     fSLAZSlf   if   e           k disk
     fWAECOLCP  if   e           k disk
     fKCJ___31LFif   e           k disk    prefix('S')
     fsbgarb00  if   e           k disk
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

     c*  Schlüsselliste für KCJ____31
     c     kcjkey        klist
     c                   kfld                    art020
     c                   kfld                    art030
     c                   kfld                    key_jahr

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
     c                   IF        art180<>'X' and
     c                             art180<>'Z' and
     c                             art180<>'K' and
     c*                            art050='418' and
     c                             art040<>'GAR' and art040<>'WER' and
     c                             art040<>'FWK' and art040<>'PRO' and
     c                             art040<>'DRU'
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
     c     kcjKey        chain     KCJ____31
     c                   IF        %found(KCJ___31LF)
     c                   z-add     SMENGE01      KCJMNG_VJ
     c                   z-add     SUMSATZ01     KCJUMS_VJ
     c                   z-add     SROHERLOE01   KCJROH_VJ
     c                   ENDIF                                                  %found(WAECOLCP)

     c                   z-add     0             KCJMNG_AJ
     c                   z-add     0             KCJUMS_AJ
     c                   z-add     0             KCJROH_AJ
     c                   z-add     0             MIBT
     c                   z-add     0             ROHS_AJ
     c                   movel     pjahr         key_jahr
     c     kcjKey        chain     KCJ____31
     c                   IF        %found(KCJ___31LF)
     c                   z-add     SMENGE01      KCJMNG_AJ
     c                   z-add     SUMSATZ01     KCJUMS_AJ
     c                   z-add     SROHERLOE01   KCJROH_AJ
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
     c                   ENDIF                                                  %found(WAECOLCP)

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

     c                   movel     TESTLF        lieferant1
     c                   eval      §lieferant  = lieferant1
     c                   movel     *blanks       lieferant2
     c                   movel     *blanks       uland
     c                   z-add     0             FRACHTSATZ
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
     c                   IF        artnr= '9101900025'   or
     c                             artnr= '9101900025'
     c                   move      '1'           tets              1
     c                   endif
     c                   eval      WACDEK = 'EUR'
     c                   eval      wekpr  = 0
     c                   move      art510        l                 5
     c                   movel     '90'          l                 5
     c                   movel     l             l2               10
     c                   eval      %subst(BUCHUNG: 10: 1) = '1'
     c     preikey       setll     prei1
     c                   DOU       %eof(prei02)
     c     preikey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = l2
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

     c                   z-add     PRGADA        datumv
     c                   z-add     PRGBDA        datumb
     c                   z-add     PREZPR        WEKPR
     c                   eval      wekpr = wekpr/faktor
     C                   if        wekpr <> art330
     c                   eval      %subst(BUCHUNG: 10: 1) = '2'
     C                   endif

     C                   if        prkdli='90733'
     c                   movel     prkdli        lieferant2
     c                   leave
     c                   ENDIF                                                  prkdli='90733'

     c                   ENDIF                                                  not %eof(prei02)
     C                   ENDDO                                                  %eof(prei02)

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
     c                   eval      KWAKURS    = 1
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
     c                   eval      KWAKURS    = yKURS
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

     c                   clear                   CCSTCK
     c                   clear                   CWSTCK
     c     keyslazs      chain     slaz1
     c                   IF        %found(SLAZSLF)

     c                   call      'KALK_STCKL'
     c                   parm                    JAHR
     c                   parm                    LIEFNR
     c                   parm                    ARTNR
     c                   parm                    PEKPR
     c                   parm      0             CCSTCK
     c                   parm      0             CWSTCK

     c                   if        Wekpr <> *zero
     c                   z-add     pekpr         beistell
     c                   eval      wekpr = wekpr + pekpr
     c                   Else                                                   %found(SLAZSLF)
     c                   eval      WACDEK = 'EUR'
     c                   eval      WEKPR  = PEKPR
     c                   eval      KWAKURS= 1
     c                   ENDIF                                                  %found(SLAZSLF)

     c                   ENDIF                                                  %found(SLAZSLF)

     c                   if        art030= '9102000022'
     c                   z-add     63,46         wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102000023'
     c                   z-add     141           wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102000043'
     c                   z-add     63,46         wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102200058'
     c                   z-add     3,78          wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102200059'
     c                   z-add     0,61          wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102200060'
     c                   z-add     1,81          wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)
     c                   if        art030= '9102200061'
     c                   z-add     10,85         wekpr                          %found(SLAZSLF)
     c                   ENDIF                                                  %found(SLAZSLF)

     c                   if        WACDEK = 'EUR'
     c                   eval      EKPR   = WEKPR
     c                   else
     c                   eval      EKPR   = WEKPR / KWAKURS
     c                   ENDIF

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
     c                   eval      MARGE_NEU1=
     c                             (EVP_NEU1/1,19*
     c                             (1-(GHRABS/100))-KALKBASIS) /
     c                             p
     c                   endif
     c
     c                   eval      p=
     c                             ((EVP_NEU2/1,19) *
     c                             (1-(GHRABS/100))/100)
     c*
     c                   if        p<> 0
     c                   eval      MARGE_NEU2=
     c                             ((EVP_NEU2/1,19)*
     c                             (1-(GHRABS/100))-KALKBASIS) /
     c                             p
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
     c                   exsr      sr6000

     c                   IF        %found(KALK_FILE)
     c                   update    KALK_F1
     c                   ELSE
     c                   write     KALK_F1
     c                   ENDIF                                                  %found(KALK_FILE)

     c                   ENDIF                                                  art180<>'X' 'Z'

     c     next          tag
     C   LR              close     kalk_file

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
     C                   clear                   CWSTCK2W
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
     C                             %subst(statnr: 1: 1) <> '6' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '8' and              PROTECTED
     C                             %subst(statnr: 1: 1) <> '9'                  PROTECTED
     C                   movel     '1'           DRUCK001
     C                   ENDif
     C                   ENDif
     C*
     C     ##6000        ENDSR
     C*
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
