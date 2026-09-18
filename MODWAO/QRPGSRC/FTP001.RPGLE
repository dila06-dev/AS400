     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Ändern Sourcedatei FTP für Senden Daten an fernes System
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 03.06.2011 Projekt 7357, WAECO
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 09.01.2013 Projekt 9128, Schnittstelle BRT, zusätzliche
     H*            File mit Endung .CHK
     H*  Änderung: SZ 14.03.2013 Projekt 8997, Schnittstelle TNT
     H*
     H**************************************************************************
     F*
     F*  Dieses Programm ändert den zusammengesetzten Namen mit der fortlaufen-
     F*  den Nummer in der Sourcedatei FTP für das Senden der Daten an das
     F*  ferne System.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FINPUT     UF   E             DISK    USROPN
     F*
     D**************************************************************************
     D***  TABELLEN UND FELDGRUPPEN                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D FTPI          E DS                  INZ
     D KYFTPI        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXFTPI        E DS                  INZ
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
     C***  RECHENBESTIMMUNGEN                                                ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RTFTPI
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C                   OPEN      INPUT                                98
     C*-------------------------------------------------------------------------
     C                   EVAL      RTFTPIZLSE = RTFTPIZLSE + 1
     C                   EXSR      UFTPI
     C                   EXSR      VINPUT
     C*-------------------------------------------------------------------------
     C                   CLOSE     INPUT                                98
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ANFANGROUTINE                                                     ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   EVAL      KYFTPIFIRM  = DAFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÄNDERN DER SOURCE                                                 ***
     C**************************************************************************
     C     VINPUT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKFNAM      = %TRIM(RTFTPIAFSE) +
     C                                           %SUBST(%EDITC(FTPIJDAT:'X')
     C                                           :3:6) + %EDITC(FTPIJZEI:'X') +
     C                                           '.WAD'
     C*-------------------------------------------------------------------------
     C     *INLR         DOWNE     *ON
     C                   READ      INPUT                                9899
     C*--------------------------------------------------------
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      SRCSEQ      = 1                              BENUTZER/KENNWORT
     C                   EVAL      SRCDTA      = %TRIM(RTFTPIUEUS) + ' ' +
     C                                           %TRIM(RTFTPIUEKW)
     C                   WHEN      SRCSEQ      = 4 AND RTFTPISEVZ <> ' '        VERZEICHNIS
     C                   EVAL      SRCDTA      = 'cd ' + %TRIM(RTFTPISEVZ)
     C                   WHEN      SRCSEQ      = 4
     C                   EVAL      SRCDTA      = ' '
     C                   WHEN      SRCSEQ      = 5                              DATEI
     C                   EVAL      SRCDTA      = 'put QTEMP/' +
     C                                           %TRIM(RTFTPINASE) + ' ' +
     C                                           %TRIM(RTFTPINASE) + '.tmp'
     C                   WHEN      SRCSEQ      = 6             AND              SENDE-DATEINAME
     C                             RTFTPIZUBG  = 'TNT'
     C                   EVAL      SRCDTA      = 'ren ' +
     C                                           %TRIM(RTFTPINASE) + '.tmp ' +
     C                                           %TRIM(WKFNAM)
     C                   WHEN      SRCSEQ      = 6                              SENDE-DATEINAME
     C                   Z-ADD     RTFTPIZLSE    DUN060
     C                   EVAL      SRCDTA      = 'ren ' +
     C                                           %TRIM(RTFTPINASE) + '.tmp ' +
     C                                           %TRIM(RTFTPIAFSE) +
     C                                           DUC006 + '.DAT'
     C                   WHEN      SRCSEQ      = 7             AND
     C                             %SUBST(SRCDTA : 1 : 3) = 'put'
     C                   EVAL      SRCDTA      = 'put MODWAO/' +
     C                                           %TRIM(RTFTPINASE) + ' ' +
     C                                           %TRIM(RTFTPIAFSE) +
     C                                           DUC006 + '.CHK'
     C                   OTHER
     C                   ITER
     C                   ENDSL
     C*--------------------------------------------------------
     C                   UPDATE    QFTPSRC
     C                   ENDDO
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
     C                   EVAL      FTPIZLSE    = RTFTPIZLSE
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
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFNAM          +63
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHFTPI
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
