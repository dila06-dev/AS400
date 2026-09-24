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
     fTEIL01    if   e           k disk    RENAME(teil1:PHY01R)
     fTEIL00    if   e           k disk
     fLAND01    if   e           k disk
     fPREI02    if   e           k disk

     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
     fARTNR_KALKif   e           k disk    prefix('Z')
     fZollta2lf if   e           k disk
     fTRENDEKPLFif   e           k disk
     fSLAZSlf   if   e           k disk
     ftrtp00    if   e           k disk
     fbbep09    if   e           k disk
     fTeuf00    if   e           k disk

     fKALK_FILESuf a e           k disk

     DARRAY            S              3a   DIM(99)
     dfirma            s                   like(slazfirm)
     dbegr             s                   like(prbegr)
     dtenr             s                   like(PRTENR)

     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0

     Dp_jahr           S              4  0
     dp_artnr          s                   like(TETENR)
     dp_EKPR           s                   like(wEKPR)

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
     c                   kfld                    liefnr
     c                   kfld                    TETENR

     c*  Schlüsselliste für kalkschzu
     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    StatNr
     c                   kfld                    §lieferant

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    liefnr
     c                   kfld                    TETENR

     c*  Schlüsselliste für teil00
     c     teil1key      klist
     c                   kfld                    firma
     c                   kfld                    TETENR

     c*  Schlüsselliste für teil00
     c     teil2key      klist
     c                   kfld                    firma
     c                   kfld                    SLAZKOTE

     c*  Schlüsselliste für prei02
     c     preikey       klist
     c                   kfld                    FIRMA
     c                   kfld                    BEGR
     c                   kfld                    TETENR

     c*  Schlüsselliste für prei02
     c     prstkey       klist
     c                   kfld                    FIRMA
     c                   kfld                    BEGR
     c                   kfld                    SLAZKOTE

     c*  Schlüsselliste für KSchemata
     c     keyschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    kschema

     c*  Schlüsselliste für SLAZSlf
     c     keyslazs      klist
     c                   kfld                    firma
     c                   kfld                    TETENR

     C     *ENTRY        PLIST
     C                   PARM                    p_JAHR
     C                   PARM                    p_LIEFNR          3
     C                   PARM                    p_ARTNR
     C                   PARM                    p_EKPR
     c                   parm                    CCSTCK            4 0
     c                   parm                    CWSTCK            2 0
     c                   parm                    artz1             6

     c                   z-add     0             p_EKPR
     c                   clear                   i                 3 0

     c* Artikelstamm lesen
     c     teil1key      chain     TEIL1
     c                   IF        %found(TEIL01)

     c                   z-add     nxt_jahr      Jahr
     c                   movel     '999'         LiefNr
     c                   movel     TETENR        ArtNr
     c                   movel     *blanks       KOTE
     c                   movel     TEMAGR        ArtGrp
     c                   movel     TEPRGR        StatNr
     c                   movel     teabc1        ABC
     c                   movel     TETBZ1        ARTBEZ
     c                   clear                   WACDVK
     c                   movel     '999'         LIEFNR
     c                   movel     *blanks       ZOLLNR
     c                   movel     *blanks       VARP
     c                   movel     *blanks       KOTE
     c                   movel     *blanks       KBZ1

     c                   eval      WAKURS     = 1
     c                   eval      KWAKURS    = 1


     c* Kalkulationsschema bestimmen
     c                   eval      KSCHEMA    = 0
     c****               eval      KSCHEMASTD = 0
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

     c* Kalkulationsschema bestimmen
     c     keySCHEMA     chain     KSCHEMA_F1
     c                   IF        %found(KSchemata)

     c* SCHEMA
     c                   eval      KWAKURS    = yKURS

     c                   ENDIF                                                  %found(KSchemata)



     c* Stückliste lesen
     C     keyslazs      setll     slaz1
     C                   DOU       %eof(SLAZSLF)
     C     keyslazs      READE     slaz1

     C                   IF        %found(SLAZSLF) and not %eof(SLAZSLF)
     c* SLAZS Felder
     c                   eval      VARP   = SLAZVARP
     c                   eval      POS    = SLAZHPOS
     c                   eval      KOTE   = SLAZKOTE
     c                   eval      KBZ1   = SLAZKBZ1
     c                   z-add     SLAZEIMG      menge


     c* TEIL-Satz lesen
     c     teil2key      chain     TEIL1
     c                   IF        %found(TEIL00)

     c                   movel     TESTLF        lieferant1
     c                   movel     *blanks       lieferant2
     c                   movel     *blanks       uland
     c* Ursprungsland bestimmen
     c     teurld        chain     land1
     c                   IF        %found(land01)
     c                   movel     LNLISO        uland
     c                   ENDIF                                                  %found(land01)

     c* EKP bestimmen
     c                   clear                   buchung          20
     c                   clear                   faktor#          05 0
     c                   movel     'EUR'         WACDEK
     c                   exsr      sr5500
     c                   exsr      sr5600
     c                   exsr      sr5800
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

     c     wacdek        LOOKUP    array                                  25
     c  n25              eval      i=i+1
     c  n25              move      WACDEK        array(i)
     c  n25              z-add     i             CWSTCK
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   eval      wekpr=wekpr/TUUFAK
     c                   ENDIF
     c                   if        WACDEK = 'EUR'
     c                   eval      EKPR   = WEKPR
     c                   else
     c                   eval      EKPR   = WEKPR / KWAKURS
     c                   ENDIF

     c* Berechnungsfelder
     C* Ek-Preis * Menge
     c                   eval      wert = wekpr*SLAZEIMG

     c                   eval      CCSTCK = CCSTCK + 1
     c                   add       wert          p_EKPR
     c                   write     KALK_FS1

     C                   ENDIF                                                  %found(SLAZSLF)

     C                   ENDDO                                                  %eof(SLAZSLF)




     c                   ENDIF                                                  %found(sbgart00)
     c     next          tag

     c                   move      *on           *inlr

     C**************************************************************************
     C* SR2201: KSCHEMASTD Standardschema ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     SR2201        BEGSR
     C*
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c****               eval      KSCHEMASTD = KALKSCHEMA
     c                   else
     C*
     c                   eval      §lieferant = *blank
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c****               eval      KSCHEMASTD = KALKSCHEMA
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
     C* SR5500: lesen trtp00, um zu ermitteln, ob ein Lieferant mit 90733
     C*         gelesen werden muss
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
     c                   clear                   sabe              3
     c                   movel     testlf        #testlf          10
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
     c                   movel     kote          tuTENR
     c                   movel     temeek        tumein

     c     KEY5900       chain     teuf00
     c                   IF        %found(teuf00)
     c                   ENDIF

     C*
     C     ##5900        ENDSR

     C* --------------------------------------------------
     C     *inzsr        BEGSR

     c                   move      '01'          firma
     c                   movel     'XYZ3454354'  tenr
     c                   movel     'LP1'         begr

     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   eval      nxt_jahr = pjahr

     C                   ENDSR
