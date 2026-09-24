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
     F*  Kalkulationsaufbau PB 3                                 *
     F*                                                          *
     F************************************************************
     fpb3xx     ip   e           k disk    RENAME(pb3xx:pb3xxf0) prefix('X')
     fSchemalf  if   e           k disk    prefix('Y')
     fSBGART17  if   e           k disk
     fZollta2lf if   e           k disk
     fTRENDEKPLFif   e           k disk
     fSLAZSlf   if   e           k disk
     fTEIL00    if   e           k disk

     fKALK_PB3  if a e           k disk

     dfirma            s                   like(slazfirm)
     dtenr             s                   like(PRTENR)

     c*  Schlüsselliste für SCHEMAlf
     c     keyschema     klist
     c                   kfld                    Xschema
     c*  Schlüsselliste für SBGART17
     c     keyart17      klist
     c                   kfld                    Xart030
     c*  Schlüsselliste für ZOLLTA2lf
     c     keyzoll1      klist
     c                   kfld                    art220
     c*  Schlüsselliste für ZOLLTA2lf
     c     keyzoll2      klist
     c                   kfld                    tezotn
     c*  Schlüsselliste für TRENDEKPlf
     c     keyekp        klist
     c                   kfld                    Xart030
     c*  Schlüsselliste für SLAZSlf
     c     keyslazs      klist
     c                   kfld                    firma
     c                   kfld                    Xart030
     c*  Schlüsselliste für teil00
     c     teilkey       klist
     c                   kfld                    slazfirm
     c                   kfld                    SLAZKOTE


     c     keyschema     chain     SCHEMA
     c     keyart17      chain     SBGART17
     c     keyekp        chain     TRENDEKP
     c     keyslazs      chain     slaz1

     c                   if        %found(SCHEMALF) and
     c                             %found(SBGART17) and
     c                             %found(TRENDEKPLF) and
     c                             %found(SLAZSLF)

     c     keyzoll1      chain     Zollta2


     c                   if        %found(zollta2lf)

     c                   eval      JAHR       = 2009
     c* PB3XX Felder
     c                   eval      LNLISO     = xLNLISO
     c                   eval      ID         = '2009' + xart030
     c                   eval      ARTNR      = xART030
     c                   eval      ARTGRP     = xART040
     c                   eval      STATNR     = xART050
     c                   eval      ARTBEZ     = xART060
     c                   eval      ABC        = xART180
     c                   eval      WACDVK     = xART340
     c                   eval      KSCHEMA    = xSCHEMA
     c                   eval      EVP        = xART950
     c                   eval      FRACHTSATZ = xSATZ

     c* SCHEMA
     c                   eval      SCHBEZ     = yBEZ
     c                   eval      PB         = yPB
     c                   eval      KWAKURS    = yKURS
     c                   eval      RISIKOSATZ = yRISIKO
     c                   eval      ICSS       = yICS
     c                   eval      ICNS       = yICN
     c                   eval      EXSS       = yEXS
     c                   eval      EXNS       = yEXN
     c                   eval      OEMS       = yOEM
     c                   eval      GHNETS     = yGHNETTO
     c                   eval      GHRABS     = yGHRAB
     c                   eval      GHRABATT   = yGHRAB/100

     c* SBGART17
     c                   eval      LIEFNR = ART510
     c                   eval      ZOLLNR = ART220
     c                   eval      ARTZ1  = ART390
     c                   eval      ARTZ2  = ART400
     c                   eval      ARTZ3  = ART550

     c* ZOLLTA2
     c                   eval      ZOLLSATZ = satz1

     c* TRENDEKP
     c                   eval      MIBT     = PRMIBT
     c                   eval      WACDEK   = prwacd

     c* Fixfelder
     c                   eval      BEISTELL   = 0
     c                   eval      BEIAUSPRO  = 0
     c                   eval      ENTWICKLUN = 0
     c                   eval      PREIS_PM   = 0
     c                   eval      VKALTINCL  = 1
     c                   eval      VKNEUINCL  = 1
     c                   eval      WAKURS     = 1

     c* Stückliste lesen
     C     keyslazs      setll     slaz1
     C                   DOU       %eof(SLAZSLF)
     C     keyslazs      READE     slaz1

     C                   if        %found(SLAZSLF) and not %eof(SLAZSLF)
     c* SLAZS Felder
     c                   eval      VARP   = SLAZVARP
     c                   eval      KOTE   = SLAZKOTE
     c                   eval      KBZ1   = SLAZKBZ1


     c* Einkaufswert bestimmen
     c     teilkey       chain     TEIL1
     c                   if        %found(TEIL00)

     c* Einkaufswerte aus TRENDEKP sind primär zu ziehen
     c     SLAZKOTE      chain     TRENDEKP
     c                   if        %found(TRENDEKPLF)

     c                   z-add     PREZPR        WEKPR
     c                   movel     PRWACD        WACDEK

     c                   else

     c                   z-add     TESTPR        WEKPR
     c                   movel     'EUR'         WACDEK

     c                   ENDIF

     c     keyzoll2      chain     Zollta2
     c                   if        %found(zollta2lf)
     c                   eval      ZOLLSATZ = satz1
     c                   else
     c                   eval      ZOLLSATZ = 0
     c                   ENDIF

     c                   ENDIF


     c                   if        WACDEK = 'EUR'
     c                   eval      EKPR   = WEKPR
     c                   else
     c                   eval      EKPR   = WEKPR / KWAKURS
     c                   ENDIF

     c* Berechnungsfelder
     c                   eval      FRACHT     = EKPR * FRACHTSATZ / 100
     c                   eval      ZOLL       = EKPR * zollsatz
     c                   eval      VERSICHERU = (EKPR + FRACHT + ZOLL) * 0,0004
     c                   eval      COSTPRS    = EKPR+FRACHT+ZOLL+VERSICHERU
     c                   eval      RISIKOZ    = RISIKOSATZ * COSTPRS / 100
     c                   eval      KALKBASIS  = RISIKOZ + COSTPRS
     c                   eval      GHNET      = (KALKBASIS * GHNETS /
     c                                          (100 - GHNETS)) + KALKBASIS
     c                   eval      GHRAB      = (GHNET * GHRABS / (100-GHRABS))
     c                                          + GHNET
     c                   eval      EV01       = GHRAB * 1,19
     c                   eval      EV02       = EV01
     c                   eval      ZU         = (100 * EV01 / xART950) - 100
     c                   eval      PALT       = ((EVP / 1,19 *
     c                                          (1- GHRABATT)-kalkbasis))/
     c                                          (EVP / 1,19 *
     c                                          (1- GHRABATT)) * 100
     c                   if        ev02<>0
     c                   eval      PNEU       = ((ev02 / 1,19 * (1-GHRABATT)-
     c                                          kalkbasis)) / (ev02 / 1,19
     c                                          * (1-GHRABATT)) * 100
     c                   else
     c                   eval      PNEU       = 0
     c                   endif
     c                   eval      ICS        = (COSTPRS * (ICSS/100))
     c                                          + COSTPRS
     c                   eval      ICN        = (COSTPRS * (ICNS/100))
     c                                          + COSTPRS
     c                   eval      EXS        = (COSTPRS * (EXSS/100))
     c                                          + COSTPRS
     c                   eval      EXN        = (COSTPRS * (EXNS/100))
     c                                          + COSTPRS
     c                   eval      OEM        = (COSTPRS * (OEMS/100))
     c                                          + COSTPRS

     c                   write     KALK_PB3F1
     C                   ENDif

     C                   ENDDO


     c                   ENDIF

     c                   endif

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   move      '01'          firma
     c                   movel     'XYZ3454354'  tenr
     C                   ENDSR
