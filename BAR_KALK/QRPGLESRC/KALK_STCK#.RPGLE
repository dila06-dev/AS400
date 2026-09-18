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
     fsbgart00  if   e           k disk
     fTEIL00    if   e           k disk
     fLAND01    if   e           k disk
     fPREI02    if   e           k disk

     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
     fARTNR_KALKif   e           k disk    prefix('Z')
     fZollta2lf if   e           k disk
     fTRENDEKPLFif   e           k disk
     fSLAZSlf   if   e           k disk

     fKALK_FILESuf a e           k disk

     DARRAY            S              3a   DIM(99)
     dfirma            s                   like(slazfirm)
     dfirma_n          s                   like(art010)
     dbegr             s                   like(prbegr)
     dtenr             s                   like(PRTENR)

     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0

     Dp_jahr           S              4  0
     dp_liefnr         s                   like(art020)
     dp_artnr          s                   like(art030)
     dp_EKPR           s                   like(wEKPR)

     c*  Schlüsselliste für kalk_file
     c     kalkkey       klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für kalkschzu
     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art050

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    art020
     c                   kfld                    art030

     c*  Schlüsselliste für sbgart00
     c     artkey        klist
     c                   kfld                    firma_n
     c                   kfld                    p_liefnr
     c                   kfld                    p_artnr

     c*  Schlüsselliste für teil00
     c     teil1key      klist
     c                   kfld                    firma
     c                   kfld                    art030

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
     c                   kfld                    art030



     C     *ENTRY        PLIST
     C                   PARM                    p_JAHR
     C                   PARM                    p_LIEFNR
     C                   PARM                    p_ARTNR
     C                   PARM                    p_EKPR
     c                   parm                    CCSTCK            4 0
     c                   parm                    CWSTCK            2 0




     c                   z-add     0             p_EKPR
     c                   clear                   i                 3 0

     c* Artikelstamm lesen
     c     artkey        chain     ART00R1
     c                   IF        %found(SBGART00)

     c                   z-add     nxt_jahr      Jahr
     c                   movel     art020        LiefNr
     c                   movel     art030        ArtNr
     c                   movel     *blanks       KOTE
     c                   movel     art040        ArtGrp
     c                   movel     art050        StatNr
     c                   movel     art180        ABC
     c                   movel     art060        ARTBEZ
     c                   movel     art340        WACDVK
     c                   movel     art510        LIEFNR
     c                   movel     *blanks       ZOLLNR
     c                   movel     *blanks       VARP
     c                   movel     *blanks       KOTE
     c                   movel     *blanks       KBZ1

     c                   eval      WAKURS     = 1
     c                   eval      KWAKURS    = 1


     c* Kalkulationsschema bestimmen
     c                   eval      KSCHEMA    = 0
     c     akkey         chain     ARTNRKF0
     c                   IF        %found(ARTNR_KALK)
     c                   eval      KSCHEMA    = ZSCHEMA
     c                   ELSE
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   ENDIF                                                  %found(Kalkschzu)
     c                   ENDIF                                                  %found(ARTNR_KALK)

     c* Kalkulationsschema bestimmen
     c     KEYSCHEMA     chain     KSCHEMA_F1
     c                   IF        %found(KSchemata)

     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   eval      KWAKURS    = YKURS

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
     c                   z-add     TESTPR        WEKPR
     c                   movel     'EUR'         WACDEK
     c                   move      art510        l                 5
     c                   movel     '90'          l                 5
     c                   movel     l             l2               10
     c     prstkey       setll     prei1
     c                   DOU       %eof(prei02)
     c     prstkey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = l2
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

     C                   if        prkdli='90733'
     c                   movel     prkdli        lieferant2
     c                   leave
     c                   ENDIF                                                  prkdli='90733'

     c                   ENDIF                                                  not %eof(prei02)
     c                   ENDDO                                                  %eof(prei02)

     c                   ENDIF                                                  %found(TEIL00)

     c     wacdek        LOOKUP    array                                  25
     c  n25              eval      i=i+1
     c  n25              move      WACDEK        array(i)
     c  n25              z-add     i             CWSTCK
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

     C* --------------------------------------------------
     C     *inzsr        BEGSR

     c                   move      '01'          firma
     c                   z-add     01            firma_n
     c                   movel     'XYZ3454354'  tenr
     c                   movel     'LP1'         begr

     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1

     C                   ENDSR
