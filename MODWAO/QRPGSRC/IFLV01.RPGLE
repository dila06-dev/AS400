     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H DFTACTGRP(*NO)
     H**************************************************************************
     H/TITLE Verzeichnis für den Import der Files von Spedition lesen
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: VU 05.08.2011 Projekt 7195
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 11.08.2011 variables Verzeichnis/Dateiname
     H*
     F**************************************************************************
     F*
     F*  Das Programm liest den Inhalt des übergebenen Verzeichnisses und
     F*  schreibt die Namen der einzelnen Dateien in Datei IFLV.
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
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
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
     D***  I F S - A P I aus: http://www.scottklement.com/rpg/ifs_ebook/     ***
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
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VDIR
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
     C                   MOVEL(P)  DAFIRM        KYIFLVFIRM                     IFLV
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
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
     C                   EVAL      dir         = opendir(%TRIM(RTFTPITDIR))
     C*--------------------------------------------------------
     C                   IF        dir         = *NULL
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      p_dirent    = readdir(dir)
     C*-------------------------------------------------------------------------
     C                   DOW       p_dirent   <> *NULL
     C                   EVAL      WKIUPD      = *OFF
     C                   EXSR      PIFLV
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UIFLV
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      p_dirent    = readdir(dir)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CALLP     closedir(dir)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AUF RELEVANZ                                               ***
     C**************************************************************************
     C     PIFLV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(d_name:1:1) = '.'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(d_name:1:1) <> %SUBST(RTFTPIAFEM:1:1)
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKNAME      = %STR(%ADDR(d_name):128)
     C*--------------------------------------------------------
     C                   IF        WKNAME     <> *BLANK
     C                   EVAL      WKIUPD      = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI IFLV                                                 ***
     C**************************************************************************
     C     UIFLV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '00'          KYIFLVSTAT
     C                   MOVEL(P)  WKNAME        KYIFLVNAME
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHIFLV
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        IFLVDATN
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
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHIFLV                                       FÜGEN
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHIFLV
     C*
     C                   MOVE      'U'           #CRTCD
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIUPD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
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
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    IFLVNAME      WKNAME
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHIFLV
     C/COPY QCPYSRC,CHTRPA
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
