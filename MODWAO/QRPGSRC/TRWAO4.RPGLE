     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2010')
     H DFTACTGRP(*NO)
     H**************************************************************************
     H/TITLE Das IFS-Verzeichnis für den Import der Rückmeldungen aus dem QS-System
     H/TITLE PDAP7 lesen
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 15.02.2010 Projekt 5309 für Kunde WAECO
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 23.08.2010 Folgende Korrektur aus MODRIH/IFLV01 nachgezogen:
     H*            Änderung: SZ 30.07.2010 Abbruch DIR-Befehl wegen *NULL-terminierter
     H*                      Variable bei unterschiedlich langen File Namen korrigiert.
     F**************************************************************************
     F*  Das Programm liest das IFS-verzeichnis, in welches das QS-System die
     F*  Rückmeldedsaten als  .csv-Dateien stellt. Dabei ermittelt das Programm
     F*  die Namen der einzelnen .csv-Dateien, die an das  CL-Programm übergeben
     F*  werden, welches dann die Daten aus den .csv-Dateien in eine Datenbankdatei
     F*  übernimmt.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     F*
     F*
     D**************************************************************************
     D***  I F S - A P I S                                                   ***
     D***  aus: http://www.scottklement.com/rpg/ifs_ebook/                   ***
     D**************************************************************************
     D opendir         PR              *   EXTPROC('opendir')
     D  dirname                        *   VALUE options(*string)
     D*
     D dir             S               *
     D*
     D readdir         PR              *   EXTPROC('readdir')
     D  dirp                           *   VALUE
     D*
     D closedir        PR            10I 0 EXTPROC('closedir')
     D  dirhandle                      *   VALUE
     D*
     D p_dirent        s               *
     D dirent          ds                  based(p_dirent)
     D   d_reserved1                 16A
     D   d_fileno_gen_id...
     D                               10U 0
     D   d_fileno                    10U 0
     D   d_reclen                    10U 0
     D   d_reserved3                 10I 0
     D   d_reserved4                  8A
     D   d_nlsinfo                   12A
     D     nls_ccsid                 10I 0 OVERLAY(d_nlsinfo:1)
     D     nls_cntry                  2A   OVERLAY(d_nlsinfo:5)
     D     nls_lang                   3A   OVERLAY(d_nlsinfo:7)
     D     nls_reserv                 3A   OVERLAY(d_nlsinfo:10)
     D   d_namelen                   10U 0
     D   d_name                     640A
     D*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D KYTRPC        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   EXSR      VDIR
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*-------------------------------------------------------------------------
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXTR02'      EXDATAFILE
     C                   MOVEL(P)  EXTR02        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       WKFDIR
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
     C***  VERARBEITEN IMPORTVERZEICHNIS                                     ***
     C**************************************************************************
     C     VDIR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      dir = opendir(%TRIM(WKFDIR))
     C*
     C                   IF        dir = *NULL
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      p_dirent = readdir(dir)
     C*
     C                   DOW       p_dirent <> *NULL
     C*
     C                   EVAL      DUC001 = %TRIM(d_name)
     C     DUC001        IFNE      '.'
     C**PH X'00':' '     XLATE     d_name        d_name
     C                   EVAL      WKNAME      = %STR(%ADDR(d_name):640)
     C**PH               EVAL      WKFMBR = %TRIM(WKFDIR) + %TRIM(d_name)
     C                   EVAL      WKFMBR = %TRIM(WKFDIR) + %TRIM(WKNAME)
     C                   CALL      'TRWAO5CL'
     C                   PARM                    WKFMBR
     C                   ENDIF
     C*
     C                   EVAL      p_dirent = readdir(dir)
     C                   ENDDO
     C*
     C                   CALLP     closedir(dir)
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C     *LIKE         DEFINE    WKC001        WKFDIR          +49
     C     *LIKE         DEFINE    WKC001        WKFMBR         +689
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
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
     C     *LIKE         DEFINE    d_name        WKNAME
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
