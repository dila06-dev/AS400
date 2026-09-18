     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2000')
     H**************************************************************************
     H/TITLE  Ermitteln OP-Summe aus Schilling-Fibu Datei FPKDAT
     H**************************************************************************
     H*  Copyright 2000 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 20.03.2000
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 10.04.2002 Anpassung Schilling Release 2.05, Datei FPKDAT
     H*  Änderung: SZ 15.02.2013 Projekt 9110 Dometic, Programm in MODWAO über-
     H*            nommen. Struktur der Debitornummer ist je Mandant bei Dometic
     H*            unterschiedlich.
     H*  Änderung: SZ 04.09.2015 Projekt 11614 Dometic AT. Debitor 6-stellig.
     H*  Änderung: SZ 12.06.2018 Projekt 1xxxx Ezetil Fa. 20, 8 Stellen
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus der Prüfung des Kreditlimits PRKLOP aufgerufen
     F*  Das Programm ermittelt aus der Schilling Datei FPKDAT die OP-Summe für
     F*  die übergebene Kundennummer.
     F*  Zwischengeschaltet ist ein CL mit einem Overwrite der Datei KDAT auf
     F*  FPKDAT.
     F*  Das Programm wird jetzt auch aus TRRG62 aufgerufen.
     F*
     F*  Input-Felder:
     F*  WKKDNR = Kundennummer
     F*  WKOPSU = OP-Summe
     F*  WKFENR = Fehlernummer
     F*
     F*  Der unterschiedliche Aufbau der Debitornummer bei den verschiedenen
     F*  Mandanten stammt aus der Vergangenheit. Die Salescompanies waren teil-
     F*  weise Töchter von WAECO und teilweise von Elektrolux.
     F*  Die Personenkontonummer in Schilling ist 9-stellig und beginnt für
     F*  Debitoren immer mit einer '1'. Dann folgen:
     F*  Mandant 01 WAECO       6-stellig, angehängt '00'
     F*  Mandant 08 Belgien     7-stellig, führende '0'
     F*  Mandant 20 EZetil      8-stellig
     F*  Mandant 52 Niederlande 7-stellig, führende '0'
     F*  Mandant 55 Schweiz     5-stellig, angehängt '000'
     F*  Mandant 61 Österreich  6-stellig, angehängt '00'
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D W99             S              1    DIM(99)                              WORK-FELDGRP.
     D W09             S              1    DIM(9)                               WORK-FELDGRP.
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDAT          E DS                  INZ
     D KYKDAT        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXNUUM        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKKDNR
     C                   PARM                    WKOPSU
     C                   PARM                    WKFENR
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   IF        WKI000     <> *ON
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKTRPA     <> *ON
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VKDAT
     C*-------------------------------------------------------------------------
     C                   RETURN
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  DAPROG        WKCHPN
     C                   MOVEL(P)  DABIBL        WKCHPL
     C                   MOVEL(P)  DAUSER        WKUSER                         BENUTZER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    KYPDFI                         KDKT
     C                   MOVE      *BLANK        KYPDBR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   EVAL      WKI000      = *ON
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETEREINSTELLUNGEN                                  ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART DEBITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTDE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKKTDE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'DBNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKIDBN
     C*
     C     WKIDBN        IFNE      *ON
     C                   MOVE      *OFF          WKIDBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTWC
     C*--------------------------------------------------------
     C     WKSTWC        IFEQ      *BLANK
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG
     C                   MOVEL(P)  'WACD'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTWC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         MANDANT FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'MAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   IF        TAPCDE     <> *BLANK
     C                   MOVEL(P)  TAPCDE        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    KYPDFI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKTRPA      = *ON
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUFROUTINE                                                    ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM      = '01'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:6) + '00'
     C                   WHEN      DAFIRM      = '08'
     C                   EVAL      WKDBNR      = '0' + %SUBST(WKKDNR:1:7)
     C                   WHEN      DAFIRM      = '20'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:8)
     C                   WHEN      DAFIRM      = '52'
     C                   EVAL      WKDBNR      = '0' + %SUBST(WKKDNR:1:7)
     C                   WHEN      DAFIRM      = '55'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:5) + '000'
     C                   OTHER
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:6) + '00'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKIDBN      = *ON
     C                   MOVEL(P)  WKKTDE        WKC011
     C                   MOVE      WKDBNR        WKC011
     C                   MOVEL(P)  WKC011        KYPDKO
     C                   ELSE
     C                   MOVEL(P)  WKDBNR        KYPDKO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  KYPDKO        W09
     C*--------------------------------------------------------
     C                   DO        9             I1
     C*
     C     W09(I1)       IFEQ      ' '
     C                   MOVE      '0'           W09(I1)
     C                   ENDIF
     C*
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA(P)  W09(01)       KYPDKO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKTRPA                         IND.TRPA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKTDE                         KONTOART DEBITOR
     C     *LIKE         DEFINE    WKC001        WKKDNR          + 9            KUNDENNUMMER
     C     *LIKE         DEFINE    WKC001        WKDBNR          + 9            DEBITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKIDBN                         IND.DEBITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKC011          +10            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKSTWC          + 2            STAMMWÄHRUNG
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKOPSU          + 8            OP-SUMME
     C     *LIKE         DEFINE    WKC001        MODCLO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN KDAT                                                  ***
     C**************************************************************************
     C     VKDAT         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     WKSTWC        ANDEQ     'EUR'
     C     PDSE00        SUB(H)    PDHE00        WKOPSU
     C     WKFENR        WHENEQ    *ZERO
     C     PDAKSO        SUB(H)    PDAKHA        WKOPSU
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMSETZEN IN NUMERISCHEN WERT                                      ***
     C**************************************************************************
     C     NUMUMS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CALL      'TRNUUM'
     C                   PARM                    EXNUUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  C O P Y - M O D U L E                                             ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDAT
     C/COPY QCPYSRC,CHTRPA
     C*
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
