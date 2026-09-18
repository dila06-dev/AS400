     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Verarbeiten Dateien aus DIR-Befehl
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: VU 05.08.2011 Projekt 7195
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 11.08.2011 Verarbeitung auch für Parts Express
     H*  Änderung: SZ 22.11.2011 Projekt 7197, Verarbeitung auch für Hamacher
     H*
     F**************************************************************************
     F*
     F*  Das Programm liest die Datei IFLV nach Status. Sobald ein Satz mit
     F*  Status 00 gefunden wird, wird der Dateiname über Parameter RTFTPI an
     F*  das nachfolgende Programm zur Verarbeitung übergeben.
     F*  Die Datei IFLV wird zuvor über IFLV01 gefüllt. Sie enthält das Ergeb-
     F*  nis eines DIR-Befehls auf das Verzeichnis /SPEDITION für alle Files
     F*  mit den Anfangsbuchstaben laut übergebenem Dateicode.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D IFLV          E DS                  INZ
     D KYIFLV        E DS                  INZ
     D*
     D FTPI          E DS                  INZ
     D KYFTPI        E DS                  INZ
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
     D RTFTPI        E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RTFTPI
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VIFLV
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYIFLVFIRM                     IFLV
     C                   MOVEL(P)  DAFIRM        KYFTPIFIRM                     FTPI
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN SÄTZE AUS IFLV                                        ***
     C**************************************************************************
     C     VIFLV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '00'          KYIFLVSTAT
     C                   MOVE      *LOVAL        KYIFLVNAME
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHIFLV
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR      <> *ON
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHIFLV
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO         OR
     C                             IFLVFIRM   <> KYIFLVFIRM    OR
     C                             IFLVSTAT   <> KYIFLVSTAT
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHIFLV
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        IFLVNAME   <> *BLANK
     C                   EVAL      WKIDTN      = *OFF
     C                   EXSR      PIFLV
     C*
     C                   IF        WKIDTN      = *OFF
     C                   ITER
     C                   ENDIF
     C*
     C                   EVAL      RTFTPIZLEM  = RTFTPIZLEM + 1
     C                   EVAL      RTFTPIDTEI  = IFLVNAME
     C                   Z-ADD     RTFTPIZLEM    DUN080
     C                   EVAL      RTFTPIDATN  = %SUBST(RTFTPIAFEM : 1 : 3)
     C                                         + DUC008
     C                   EXSR      UIFLV
     C                   EXSR      UFTPI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN DATEINAME GEGEN JOBNAME                                    ***
     C**************************************************************************
     C     PIFLV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKDCDE      = %SUBST(IFLVNAME : 1 : 3)
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      RTFTPIZUBG  = 'DPD'         AND
     C                             WKDCDE      = RTFTPIAFEM
     C                   EVAL      WKIDTN      = *ON
     C                   WHEN      RTFTPIZUBG  = 'PARTSEXPRESS' AND
     C                             WKDCDE      = RTFTPIAFEM
     C                   EVAL      WKIDTN      = *ON
     C                   WHEN      RTFTPIZUBG  = 'PARTSEXPRESS_NACHT' AND
     C                             WKDCDE      = %SUBST(RTFTPIAFEM:1:3)
     C                   EVAL      WKIDTN      = *ON
     C                   WHEN      RTFTPIZUBG  = 'HAMACHER'     AND
     C                             WKDCDE      = RTFTPIAFEM
     C                   EVAL      WKIDTN      = *ON
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI IFLV                                                 ***
     C**************************************************************************
     C     UIFLV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '90'          IFLVSTAT
     C                   MOVEL(P)  RTFTPIDATN    IFLVDATN
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        IFLVJNAM
     C                   MOVEL(P)  WKCHPN        IFLVPROG
     C                   MOVEL(P)  WKCHPL        IFLVBIBL
     C                   MOVEL(P)  DAUSER        IFLVUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        IFLVJZEI
     C                   MOVE      WKTDAT        IFLVJDAT
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHIFLV
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE NEUE DATEINUMMER IN FTPI                                   ***
     C**************************************************************************
     C     UFTPI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYFTPITSTP  = RTFTPITSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHFTPI
     C*-------------------------------------------------------------------------
     C                   EVAL      FTPIZLEM    = RTFTPIZLEM
     C*-------------------------------------------------------------------------
     C                   EVAL      FTPIJNAM    = DAJNAM
     C                   EVAL      FTPIPROG    = EXPSDSPROC
     C                   EVAL      FTPIBIBL    = EXPSDSBIBL
     C                   EVAL      FTPIUSER    = EXPSDSUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        FTPIJZEI
     C                   MOVE      WKTDAT        FTPIJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHFTPI
     C*--------------------------------------------------------
     C                   ENDSL
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIDTN                         IND.DATEI
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKDCDE          + 9            DATEICODE
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    IFLVDATN      WKIFLVDATN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHIFLV
     C/COPY QCPYSRC,CHFTPI
     C/COPY QCPYSRC,CHTRPA
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
