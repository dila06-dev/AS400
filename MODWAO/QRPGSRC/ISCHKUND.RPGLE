     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H*  HINWEIS:  GS 19.06.2007 Beim Umwandeln "ADDLIBLE SFBF"
     H**************************************************************************
     H/TITLE  Ermitteln Daten aus Schilling-Fibu Datei FPSKTO
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstr. 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 24.01.2002
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 10.04.2002 Anpassung Schilling Releaese 2.05, Datei FPSKTO
     H*            statt FKUNDE
     H*  Änderung: SZ 24.11.2003 Mandant Fibu aus Parameter FIRM/BUHA/MAND
     H*  Änderung: SZ 19.04.2011 Projekt 7179, WAECO, zusätzlich Kreditlimit und
     H*            Kreditversicherung aus Schilling ermitteln
     H*  Änderung: SZ 15.02.2013 Projekt 9110 Dometic, Programm in MODWAO über-
     H*            nommen. Struktur der Debitornummer ist je Mandant bei Dometic
     H*            unterschiedlich.
     H*  Änderung: SZ 04.09.2015 Projekt 11614 Dometic AT
     H*  Änderung: SZ 27.03.2018 Projekt Dometic Ezetil
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus der Prüfung des Kreditlimits PRKLOP aufgerufen
     F*  Das Programm ermittelt aus der Schilling Datei FPSKTO das Bonitätskenn-
     F*  zeichen für die übergebene Kundennummer.
     F*
     F*  Input-Felder:
     F*  WKKDNR = Kundennummer
     F*  WKBOKZ = Bonitätskennzeichen
     F*  WKFENR = Fehlernummer
     F*  WKKLSU = Kreditlimit
     F*  WKHVSU = Kreditversicherung
     F*
     F*  Der unterschiedliche Aufbau der Debitornummer bei den verschiedenen
     F*  Mandanten stammt aus der Vergangenheit. Die Salescompanies waren teil-
     F*  weise Töchter von WAECO und teilweise von Elektrolux.
     F*  Die Personenkontonummer in Schilling ist 9-stellig und beginnt für
     F*  Debitoren immer mit einer '1'. Dann folgen:
     F*  Mandant 01 WAECO       6-stellig, angehängt '00'
     F*  Mandant 08 Belgien     7-stellig, führende '0'
     F*  Mandant 52 Niederlande 7-stellig, führende '0'
     F*  Mandant 55 Schweiz     5-stellig, angehängt '000'
     F*  Mandant 61 Österreich  6-stellig, angehängt '00'
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FFPSKTO00  IF A E           K DISK
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
     C                   PARM                    WKBOKZ
     C                   PARM                    WKFENR
     C                   PARM                    WKKLSU
     C                   PARM                    WKHVSU
     C*-------------------------------------------------------------------------
     C                   IF        %PARMS      > 3
     C                   EVAL      WKKLSU      = *ZERO
     C                   EVAL      WKHVSU      = *ZERO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      EFPSKTO
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
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
     C                   MOVEL(P)  'FIRM'        KYTATA                         MANDANT FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'MAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMAND
     C*
     C     WKTRPAMAND    IFEQ      *BLANK
     C                   MOVEL(P)  '000'         WKTRPAMAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUFROUTINE                                                    ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTRPAMAND    EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    KYPKTOFIRM
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM      = '01'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:6) + '00'
     C                   WHEN      DAFIRM      = '08'
     C                   EVAL      WKDBNR      = '0' + %SUBST(WKKDNR:1:7)
     C                   WHEN      DAFIRM      = '52'
     C                   EVAL      WKDBNR      = '0' + %SUBST(WKKDNR:1:7)
     C                   WHEN      DAFIRM      = '55'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:5) + '000'
     C                   WHEN      DAFIRM      = '20'
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:8)
     C                   OTHER
     C                   EVAL      WKDBNR      = %SUBST(WKKDNR:1:6) + '00'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKIDBN      = *ON
     C                   MOVEL(P)  WKKTDE        WKC011
     C                   MOVE      WKDBNR        WKC011
     C                   MOVEL(P)  WKC011        KYPKTOKDNR
     C                   ELSE
     C                   MOVEL(P)  WKDBNR        KYPKTOKDNR
     C                   ENDIF
     C*
     C     ' ':'0'       XLATE     KYPKTOKDNR    KYPKTOKDNR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKBOKZ
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKTDE                         KONTOART DEBITOR
     C     *LIKE         DEFINE    WKC001        WKKDNR          + 9            KUNDENNUMMER
     C     *LIKE         DEFINE    WKC001        WKDBNR          + 9            DEBITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKIDBN                         IND.DEBITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKBOKZ                         BONITÄTSKENNZEICHEN
     C     *LIKE         DEFINE    WKC001        WKC011          +10            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKTRPAMAND      + 2            MANDANT FIBU
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        WKKLSU          + 8            KREDITLIMIT
     C     *LIKE         DEFINE    WKN010        WKHVSU          + 8            KREDITVERSICHERUNG
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    P0FA          KYPKTOFIRM
     C     *LIKE         DEFINE    P0KTO         KYPKTOKDNR
     C*-------------------------------------------------------------------------
     C     KYPKTO        KLIST
     C                   KFLD                    KYPKTOFIRM
     C                   KFLD                    KYPKTOKDNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FPSKTO                                        ***
     C**************************************************************************
     C     EFPSKTO       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KYPKTO        CHAIN     FPSKTO00                           9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVEL(P)  P0BONI        WKBOKZ
     C                   ENDIF
     C*
     C                   IF        *IN97       = *OFF          AND
     C                             *IN98       = *OFF          AND
     C                             %PARMS      > 3
     C                   EVAL      WKKLSU      = P0L1
     C                   EVAL      WKHVSU      = P0L2
     C                   ENDIF
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
     C/COPY QCPYSRC,CHTRPA
     C*
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
