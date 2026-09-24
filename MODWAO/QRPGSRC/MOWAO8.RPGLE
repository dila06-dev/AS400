     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei WAO8
     H**************************************************************************
     H*  Copyright 2007 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 21.12.2010 für Kunde WAECO Projekt 6864
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 05.01.2011 ERWAO8 für XLAFLK01
     H*  Änderung: SZ 01.02.2011 ERWAO8 angepaßt, Position 0 wird nicht mehr
     H*            geschrieben.
     H*  Änderung: VU 17.06.2011 Projekt 7087, Berechnung von Nachnahmbetrag
     H*  Änderung: VU 03.08.2011 Projekt 7087, Doppelte Berechnung von Versand-
     H*            kosten, Versicherung, Verpackung unterbinden
     H*  Änderung: SZ 25.08.2011 Projekt 7087, Rundung Nachberechnung MWSt und
     H*            Nettobetrag
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient zum Update der Datei WAO8
     F*  Aufruf Programm mit 'ERANBT+'  -> Emittlung Nachnahmebetrag und Update
     F*                      'ERANBT-'  -> nur Ermittlung Nachnahmebetrag
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D FGCODP          S                   DIM(999) LIKE(WAO8CODP)
     D FGCODU          S                   DIM(999) LIKE(WAO8CODU)
     D FGAFPO          S                   DIM(999) LIKE(WAO8AFPO)
     D FGIFPO          S                   DIM(999) LIKE(WAO8IFPO)
     D FGBSMG          S                   DIM(999) LIKE(IFAPBSMG)
     D FGGLMG          S                   DIM(999) LIKE(ALGLMG)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
     D*
     D IFAP          E DS                  INZ
     D KYIFAP        E DS                  INZ
     D*
     D WAO8          E DS                  INZ
     D KYWAO8        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERWAO8'
     C                   EXSR      ERWAO8
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENABT+'                                     Erm. Nachnahme BT
     C     PCPGST        OREQ      'ENABT-'
     C                   EXSR      ENABT
     C*--------------------------------------------------------
     C                   OTHER                                                  EXTERNES
     C                   EXSR      IFWAO8                                       UPDATE
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        WKFIRM
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C                   Z-ADD     *ZERO         WKN145           14 5
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYWAO8FIRM                     WAO8
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYALFI                         AFLP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C                   MOVEA     EXTRNDKEYB    KOM
     C*
     C                   MOVEA     KOM(1)        KYWAO8IFFI
     C                   MOVEA     KOM(6)        KYWAO8IFNR
     C                   MOVEA     KOM(38)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        KYWAO8IFPO
     C*
     C                   MOVEL     KYWAO8IFFI    DSWAO8IFFI
     C                   MOVEL     KYWAO8IFNR    DSWAO8IFNR
     C                   Z-ADD     KYWAO8IFPO    DSWAO8IFPO
     C*
     C                   MOVEA     KOM(42)       KYWAO8FIRM
     C                   MOVEA     KOM(44)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        KYWAO8AFJJ
     C                   MOVEA     KOM(48)       KYWAO8AFNR
     C                   MOVEA     KOM(54)       DUC004
     C                   Z-ADD     DUN040        KYWAO8AFPO
     C                   MOVEA     KOM(58)       DUC004
     C                   TESTN                   DUC004               97
     C*
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUC004
     C                   ENDIF
     C*
     C                   Z-ADD     DUN040        KYAMJH
     C                   MOVEA     KOM(62)       KYAMKM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAO8FIRM    DSWAO8FIRM
     C                   Z-ADD     KYWAO8AFJJ    DSWAO8AFJJ
     C                   MOVEL(P)  KYWAO8AFNR    DSWAO8AFNR
     C                   Z-ADD     KYWAO8AFPO    DSWAO8AFPO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAO8        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSWAO8IFFI    KYWAO8IFFI
     C                   MOVEL     DSWAO8IFNR    KYWAO8IFNR
     C                   Z-ADD     DSWAO8IFPO    KYWAO8IFPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO8
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      UWAO8
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAO8                                                 ***
     C**************************************************************************
     C     UWAO8         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO8IFFI    KYWAO8IFFI
     C                   MOVEL(P)  DSWAO8IFNR    KYWAO8IFNR
     C                   Z-ADD     DSWAO8IFPO    KYWAO8IFPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO8
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO8FIRM    WAO8FIRM
     C                   Z-ADD     DSWAO8AFJJ    WAO8AFJJ
     C                   MOVEL(P)  DSWAO8AFNR    WAO8AFNR
     C                   Z-ADD     DSWAO8AFPO    WAO8AFPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAO8JNAM
     C                   MOVEL(P)  WKCHPN        WAO8PROG
     C                   MOVEL(P)  WKCHPL        WAO8BIBL
     C                   MOVEL(P)  DAUSER        WAO8USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO8JZEI
     C                   MOVE      WKTDAT        WAO8JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL(P)  DAUSER        WAO8ERUS
     C*                  MOVEA     '01W     '    CHI
     C*                  EXSR      CHWAO8
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO8
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS WAO8                                          ***
     C**************************************************************************
     C     ERWAO8        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO         OR
     C                             WAO8FIRM   <> KYWAO8FIRM    OR
     C                             WAO8AFJJ   <> KYWAO8AFJJ    OR
     C                             WAO8AFNR   <> KYWAO8AFNR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = WAO8
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN NACHNAHMEBETRAG                                         ***
     C**************************************************************************
     C     ENABT         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*-------------------------------------------------------------------------
     C* ÜBER WAO8 PRÜFEN, OB DIE GELIEFERTE MENGE DER BESTELLTEN MENGE ENTSPRICHT
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C                   MOVEA     *ZERO         FGCODP
     C                   MOVEA     *ZERO         FGCODU
     C                   MOVEA     *ZERO         FGAFPO
     C                   MOVEA     *ZERO         FGIFPO
     C                   MOVEA     *ZERO         FGBSMG
     C                   MOVEA     *ZERO         FGGLMG
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHWAO8
     C*
     C                   IF        WKFENR     <> *ZERO         OR
     C                             WAO8FIRM   <> KYWAO8FIRM    OR
     C                             WAO8AFJJ   <> KYWAO8AFJJ    OR
     C                             WAO8AFNR   <> KYWAO8AFNR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      WKVSCD      = WAO8SPWG
     C                   EVAL      WKCODW      = WAO8CODW                       COD Währung
     C                   EVAL      WKCODS      = WAO8CODS                       Skonto
     C                   EVAL      WKCODM      = WAO8CODM                       MWST
     C                   EVAL      WKCODB      = WAO8CODB                       Betrag gesamt
     C                   EVAL      WKNABT      = WKCODB                         GESAMTBETRAG
     C*--------------------------------------------------------
     C                   IF        WKCODB      = *ZERO         OR               KEINE NACHNAHME
     C                             WAO8CODN   <> 'J'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO8KMJJ  = AMKMJJ
     C                   EVAL      KYWAO8KMNR  = AMKMNR
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   IF        WAO8FIRM    = KYWAO8FIRM    AND
     C                             WAO8KMJJ    = KYWAO8KMJJ    AND
     C                             WAO8KMNR    = KYWAO8KMNR    AND
     C                             WKFENR      = *ZERO
     C                   EVAL      WKCODV      = WAO8CODV                       Versandkosten
     C                   EVAL      WKCODK      = WAO8CODK                       Verpackungskosten
     C                   EVAL      WKCODI      = WAO8CODI                       Versicherungskosten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO8IFFI  = WAO8IFFI
     C                   EVAL      KYWAO8IFNR  = WAO8IFNR
     C                   EVAL      KYWAO8IFPO  = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             WAO8IFFI    = KYWAO8IFFI    AND
     C                             WAO8IFNR    = KYWAO8IFNR
     C                   EVAL      I1          = I1 + 1
     C                   EVAL      FGCODP(I1)  = WAO8CODP                       Nettopreis p.Stück
     C                   EVAL      FGCODU(I1)  = WAO8CODU                       Betrag p.Stück
     C                   EVAL      FGAFPO(I1)  = WAO8AFPO                       Position
     C                   EVAL      FGIFPO(I1)  = WAO8IFPO
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO8
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGIFPO(I1)  = 0
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYIFAPIFFI  = KYWAO8IFFI
     C                   EVAL      KYIFAPIFNR  = KYWAO8IFNR
     C                   EVAL      KYIFAPIFPO  = FGIFPO(I1)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHIFAP
     C                   EVAL      FGBSMG(I1)  = IFAPBSMG
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = 0
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYALJH      = AMAFJJ
     C                   EVAL      KYALAF      = AMAFNR
     C                   EVAL      KYALPO      = FGAFPO(I1)
     C                   EVAL      KYALKJ      = AMKMJJ
     C                   EVAL      KYALKN      = AMKMNR
     C                   EVAL      KYALKP      = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFLP
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             ALFIRM      = KYALFI        AND
     C                             ALAFJJ      = KYALJH        AND
     C                             ALAFNR      = KYALAF        AND
     C                             ALAFPO      = KYALPO        AND
     C                             ALKMJJ      = KYALKJ        AND
     C                             ALKMNR      = KYALKN
     C                   EVAL      FGGLMG(I1)  = ALGLMG
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      WKIBER      = *OFF
     C                   EVAL      I1          = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1) <> *ZERO         OR
     C                             FGBSMG(I1) <> FGGLMG(I1)
     C                   EVAL      WKIBER      = *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1)  = *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKIBER      = *OFF                           LIEFERUNG ENTSPRICHT
     C**SZ               LEAVESR                                                DER BESTELLUNG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* BERECHNEN NACHNAHMEBETRAG
     C*-------------------------------------------------------------------------
     C                   IF        WKIBER      = *ON
     C                   EVAL      I1          = 0
     C                   EVAL      WKBETR      = 0
     C                   EVAL      WKWAWT      = 0
     C                   EVAL      WKNTBT      = 0
     C                   EVAL      DUN134      = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C                   EVAL      DUN134      = FGCODP(I1) * FGGLMG(I1)
     C                   EVAL      WKBETR      = WKBETR + DUN134
     C                   EVAL      DUN134      = FGCODU(I1) * FGGLMG(I1)
     C                   EVAL      WKBETR      = WKBETR + DUN134
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1)  = *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   EVAL      WKWAWT      = WKBETR                         Warenwert
     C                   EVAL      WKBETR      = WKBETR + WKCODV                Versandkosten
     C                   EVAL      WKBETR      = WKBETR + WKCODK                Verpackungskosten
     C                   EVAL      WKBETR      = WKBETR + WKCODI                Versicherungskosten
     C                   EVAL      WKNTBT      = WKBETR                         Nettobetrag
     C*--------------------------------------------------------
     C                   IF        WKCODM     <> *ZERO
     C                   EVAL(H)   WKMWST      = WKBETR * (WKCODM/100)
     C                   EVAL(H)   WKBETR      = WKBETR + WKMWST                MWST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     WKBETR        WKNABT
     C*--------------------------------------------------------
     C                   ELSE
     C                   Z-ADD     WKCODB        WKNABT                         Nachnahmebetrag
     C*
     C                   IF        WKCODM     <> *ZERO
     C                   EVAL      WKRECH      = WKNABT / (WKCODM+100)
     C                   EVAL(H)   WKMWST      = WKRECH * (WKCODM)              Mehrwertsteuer
     C                   EVAL(H)   WKNTBT      = WKRECH * 100                   Nettobetrag
     C                   ELSE
     C                   Z-ADD     WKCODB        WKNTBT
     C                   ENDIF
     C*
     C                   EVAL      WKWAWT      = WKNTBT - WKCODV                Versandkosten
     C                   EVAL      WKWAWT      = WKWAWT - WKCODK                Verpackungskosten
     C                   EVAL      WKWAWT      = WKWAWT - WKCODI                Versicherungskosten
     C                   ENDIF
     C*-------------------------------------------------------------------------WERTE RÜCKGABE
     C                   Z-ADD     WKCODV        DUN092
     C                   EVAL      RTTRNDDATE = DUC009                           Versandkosten
     C                   Z-ADD     WKCODK        DUN092
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC009       Verpackungskosten
     C                   Z-ADD     WKCODI        DUN092
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC009       Versicherungskosten
     C                   Z-ADD     WKNTBT        DUN112
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC011       Nettobetrag
     C                   Z-ADD     WKMWST        DUN092
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC009       Mehrwertsteuer
     C                   Z-ADD     WKNABT        DUN112
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC011       Rechnungsbetrag
     C                   Z-ADD     WKWAWT        DUN112
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC011       Warenwert
     C                   Z-ADD     WKCODM        DUN092
     C                   EVAL      RTTRNDDATE = %TRIM(RTTRNDDATE) + DUC009       Mehrwertsteuer %
     C*-------------------------------------------------------------------------
     C                   IF        PCPGST      = 'ENABT-'                       Ohne Update
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO8IFFI  = KYIFAPIFFI                     UPDATE STATUS
     C                   EVAL      KYWAO8IFNR  = KYIFAPIFNR                     ALLE SÄTZE
     C                   EVAL      KYWAO8IFPO  = *ZERO
     C                   MOVEA     '01+U    '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             WAO8IFFI    = KYWAO8IFFI    AND
     C                             WAO8IFNR    = KYWAO8IFNR
     C                   EVAL      WAO8IFST    = '90'
     C*
     C                   IF        WAO8ERUS    = *BLANK
     C                   EVAL      WAO8ERUS    = WAO8USER
     C                   ENDIF
     C*
     C                   IF        WAO8ERDA    = *ZERO
     C                   EVAL      WAO8ERDA    = WAO8JDAT
     C                   ENDIF
     C*
     C                   IF        WAO8ERZT    = *ZERO
     C                   EVAL      WAO8ERZT    = WAO8JZEI
     C                   ENDIF
     C*
     C                   MOVEL(P)  DAJNAM        WAO8JNAM
     C                   MOVEL(P)  EXPSDSPROC    WAO8PROG
     C                   MOVEL(P)  EXPSDSBIBL    WAO8BIBL
     C                   MOVEL(P)  EXPSDSUSER    WAO8USER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO8JZEI
     C                   MOVE      WKTDAT        WAO8JDAT
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO8
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHWAO8
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIBER                         IND.BERECHNEN NACHN.
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN145        WKRECH
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO8IFFI      DSWAO8IFFI
     C     *LIKE         DEFINE    WAO8IFNR      DSWAO8IFNR
     C     *LIKE         DEFINE    WAO8IFPO      DSWAO8IFPO
     C*
     C     *LIKE         DEFINE    WAO8FIRM      DSWAO8FIRM
     C     *LIKE         DEFINE    WAO8AFJJ      DSWAO8AFJJ
     C     *LIKE         DEFINE    WAO8AFNR      DSWAO8AFNR
     C     *LIKE         DEFINE    WAO8AFPO      DSWAO8AFPO
     C*
     C     *LIKE         DEFINE    WAO8SPWG      WKVSCD
     C     *LIKE         DEFINE    WAO8CODW      WKCODW
     C     *LIKE         DEFINE    WAO8CODS      WKCODS
     C     *LIKE         DEFINE    WAO8CODM      WKCODM
     C     *LIKE         DEFINE    WAO8CODB      WKCODB
     C     *LIKE         DEFINE    WAO8CODB      WKNABT
     C     *LIKE         DEFINE    WAO8CODV      WKCODV
     C     *LIKE         DEFINE    WAO8CODK      WKCODK
     C     *LIKE         DEFINE    WAO8CODI      WKCODI
     C     *LIKE         DEFINE    WAO8CODP      WKCODP
     C     *LIKE         DEFINE    WAO8CODU      WKCODU
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN112        WKBETR
     C     *LIKE         DEFINE    DUN112        WKNTBT
     C     *LIKE         DEFINE    DUN112        WKWAWT
     C     *LIKE         DEFINE    DUN092        WKMWST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C     *LIKE         DEFINE    RTTRNDFENR    WKFENR
     C     *LIKE         DEFINE    RTTRNDPA03    W$PA03
     C     *LIKE         DEFINE    RTTRNDPA04    W$PA04
     C     *LIKE         DEFINE    RTTRNDPA05    W$PA05
     C     *LIKE         DEFINE    RTTRNDPA06    W$PA06
     C     *LIKE         DEFINE    RTTRNDPA07    W$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHIFAP
     C/COPY QCPYSRC,CHWAO8
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
