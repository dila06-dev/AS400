     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei WAOP
     H**************************************************************************
     H*  Copyright 1994/2001 by trend SWM
     H*                         Verwaltung GmbH
     H*                         Gundelfinger Straße 11
     H*                         DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  automatisch generiert
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm führt sämtliche Zugriffe und Änderungen in der Datei
     F*  WAOP durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FWAOP01    UF A E           K DISK    USROPN
     F                                     RENAME(WAOP1:WAOP01A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAOP          E DS
     D KYWAOP        E DS
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS
     D EXTR02        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENFELDER                                               ***
     D**************************************************************************
     D  CHTDAT         S               D   DATFMT(*ISO) INZ
     D  CHN060         S              6S 0
     D  CHN120         S             12S 0
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
     C                   PARM                    ##CHI
     C                   PARM                    WAOP
     C                   PARM                    KYWAOP
     C                   PARM                    EXTR01
     C*
     C                   MOVEA     ##CHI         CHI
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON                                          ANFANGROUTINE
     C                   EXSR      ANFANG
     C                   MOVE      *ON           WKI000
     C                   ENDIF
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   MOVEA     CHI(1)        WKCHNR                         SAVE ÜBERGABE-
     C                   MOVEA     CHI(3)        WKCHOP                         PARAMETER
     C                   MOVEA     CHI(4)        WKCHCU
     C*
     C                   MOVE      'N'           WKCHRT
     C                   MOVEA     *OFF          *IN(97)
     C*-------------------------------------------------------------------------
     C     WKCHCU        IFEQ      'F'                                          FÜLLEN KEY
     C     K#WAOPLOCK    ANDEQ     'L'                                          FÜR FREIGABE
     C                   MOVE      *BLANK        K#WAOPLOCK                     FALLS GELOCKT
     C                   MOVE      K#WAOPFIRM    KYWAOPFIRM
     C                   MOVE      K#WAOPPLAT    KYWAOPPLAT
     C                   MOVE      K#WAOPWKNR    KYWAOPWKNR
     C                   MOVE      K#WAOPKSTC    KYWAOPKSTC
     C                   MOVE      K#WAOPKDGR    KYWAOPKDGR
     C                   MOVE      K#WAOPKDPL    KYWAOPKDPL
     C                   MOVE      K#WAOPKDNR    KYWAOPKDNR
     C                   MOVE      K#WAOPLDNR    KYWAOPLDNR
     C                   MOVE      K#WAOPTENR    KYWAOPTENR
     C                   MOVE      K#WAOPJAHR    KYWAOPJAHR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKCHNR        CASEQ     '01'          FILE01
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEA     WKCHRT        CHI(5)                         STEUERUNGSINFO
     C                   MOVEA     *IN(97)       CHI(6)                         ÜBERGEBEN
     C                   MOVEA     CHI           ##CHI
     C*-------------------------------------------------------------------------
     C     WKCHNR        IFEQ      'LR'                                         BEENDEN
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   RETURN
     C**************************************************************************
     C***  ANFANGROUTINE                                                     ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSJDAT                         NUM.-FELDER AUS
     C                   Z-ADD     *ZERO         DSJZEI                         EXTR01
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN FELDER USERZUGRIFF                                        ***
     C**************************************************************************
     C     LZUGR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKJNAM                         JOBNAME
     C                   Z-ADD     *ZERO         WKJDAT                         JOBDATUM
     C                   Z-ADD     *ZERO         WKJZEI                         JOBZEIT
     C                   MOVE      *BLANK        WKUSER                         USER
     C                   MOVE      *BLANK        WKPROG                         PROGRAMM
     C                   MOVE      *BLANK        WKBIBL                         BIBLIOTHEK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RESTORE FELDER USERZUGRIFF                                        ***
     C**************************************************************************
     C     RZUGR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKUSER        IFNE      *BLANK
     C                   MOVEL(P)  WKJNAM        WAOPJNAM                       JOBNAME
     C                   Z-ADD     WKJDAT        WAOPJDAT                       JOBDATUM
     C                   Z-ADD     WKJZEI        WAOPJZEI                       JOBZEIT
     C                   MOVEL(P)  WKUSER        WAOPUSER                       USER
     C                   MOVEL(P)  WKPROG        WAOPPROG                       PROGRAMM
     C                   MOVEL(P)  WKBIBL        WAOPBIBL                       BIBLIOTHEK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SICHERN FELDER USERZUGRIFF                                        ***
     C**************************************************************************
     C     SZUGR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKCHCU        IFEQ      'L'
     C                   MOVEL(P)  WAOPJNAM      WKJNAM                         JOBNAME
     C                   Z-ADD     WAOPJDAT      WKJDAT                         JOBDATUM
     C                   Z-ADD     WAOPJZEI      WKJZEI                         JOBZEIT
     C                   MOVEL(P)  WAOPUSER      WKUSER                         USER
     C                   MOVEL(P)  WAOPPROG      WKPROG                         PROGRAMM
     C                   MOVEL(P)  WAOPBIBL      WKBIBL                         BIBLIOTHEK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINIEREN VARIABLE                                               ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKILCK                         IND.LOCK
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IND.TABELLE
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DSJNAM        WKJNAM                         JOBNAME
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C     *LIKE         DEFINE    DSUSER        WKUSER                         USER
     C     *LIKE         DEFINE    DSPROG        WKPROG                         PROGRAMM
     C     *LIKE         DEFINE    DSBIBL        WKBIBL                         BIBLIOTHEK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE FUER LOCK                                                  ***
     C**************************************************************************
     C     ULOCK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'L'           K#WAOPLOCK
     C                   MOVE      KYWAOPFIRM    K#WAOPFIRM
     C                   MOVE      KYWAOPPLAT    K#WAOPPLAT
     C                   MOVE      KYWAOPWKNR    K#WAOPWKNR
     C                   MOVE      KYWAOPKSTC    K#WAOPKSTC
     C                   MOVE      KYWAOPKDGR    K#WAOPKDGR
     C                   MOVE      KYWAOPKDPL    K#WAOPKDPL
     C                   MOVE      KYWAOPKDNR    K#WAOPKDNR
     C                   MOVE      KYWAOPLDNR    K#WAOPLDNR
     C                   MOVE      KYWAOPTENR    K#WAOPTENR
     C                   MOVE      KYWAOPJAHR    K#WAOPJAHR
     C*
     C                   MOVEL(P)  'L'           WAOPLOCK                       BEI 'LOCK'
     C                   MOVEL(P)  DAJNAM        WAOPJNAM                       ZUGRIFFELDER
     C                   MOVEL(P)  WKCHPN        WAOPPROG                       MIT USERDATEN
     C                   MOVEL(P)  WKCHPL        WAOPBIBL                       FÜLLEN
     C                   MOVEL(P)  DAUSER        WAOPUSER
     C*--------------------------------------------------------
     C                   TIME                    CHN120
     C                   MOVE      CHN120        CHN060
     C     *JOBRUN       MOVE      CHN060        CHTDAT
     C                   MOVEL     CHN120        WAOPJZEI
     C                   MOVE      CHTDAT        WAOPJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DS-FELDER MIT DATEIFELDERN                                 ***
     C**************************************************************************
     C     UDADS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'L'           WKCHRT                         FELDER FÜR
     C                   MOVEL(P)  WAOPJNAM      DSJNAM                         ANZEIGE 'SATZ
     C                   MOVEL(P)  WAOPPROG      DSPROG                         WIRD BENUTZT
     C                   MOVEL(P)  WAOPBIBL      DSBIBL                         DURCH ...'
     C                   MOVEL(P)  WAOPUSER      DSUSER                         FÜLLEN
     C                   Z-ADD     WAOPJZEI      DSJZEI
     C                   Z-ADD     WAOPJDAT      DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOP01                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOP01      KLIST                                                  KEY WAOP01
     C                   KFLD                    KYWAOPFIRM
     C                   KFLD                    KYWAOPPLAT
     C                   KFLD                    KYWAOPWKNR
     C                   KFLD                    KYWAOPKSTC
     C                   KFLD                    KYWAOPKDGR
     C                   KFLD                    KYWAOPKDPL
     C                   KFLD                    KYWAOPKDNR
     C                   KFLD                    KYWAOPLDNR
     C                   KFLD                    KYWAOPTENR
     C                   KFLD                    KYWAOPJAHR
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOP01                               98      DATEI
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOP01      CHAIN     WAOP01                             9798
     C*
     C                   SELECT
     C     *IN97         WHENEQ    *OFF
     C     *IN98         ANDEQ     *OFF
     C     WKCHCU        ANDNE     'F'
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   MOVE      *ON           WKILCK
     C     *IN97         WHENEQ    *OFF
     C     *IN98         ANDEQ     *OFF
     C     WKCHCU        ANDEQ     'F'                                          FREIGEBEN
     C                   MOVE      *BLANK        WAOPLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   OTHER
     C                   MOVE      *ON           WKILCK
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'D'                                          DELETE
     C                   DELETE    WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOP01      READE     WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'F'                                          FREIGEBEN
     C*
     C     WAOPLOCK      IFEQ      'L'
     C     WAOPJNAM      ANDNE     DAJNAM
     C                   MOVE      *BLANK        WAOPLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOP01
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOP01      SETGT     WAOP01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOP01      SETLL     WAOP01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOP01      READE     WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'L'                                          SETLL
     C     KYWAOP01      SETLL     WAOP01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'R'                                          READ
     C                   READ      WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'U'                                          UPDATE
     C*
     C     WKCHCU        IFEQ      'L'
     C*
     C     WAOPLOCK      IFEQ      'L'
     C     WAOPJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOPLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'W'                                          WRITE
     C*
     C     WKCHCU        IFEQ      'L'
     C                   EXSR      ULOCK
     C                   ELSE
     C                   MOVE      *BLANK        WAOPLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOP01      SETGT     WAOP01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '+'                                          SETLL/READ
     C     KYWAOP01      SETLL     WAOP01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOP01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKILCK        IFEQ      *ON                                          PRUEFEN LOCK
     C*
     C                   SELECT
     C     WKCHRT        WHENNE    'J'                                          ZUGRIFFSFEHLER
     C                   CLEAR                   WAOP
     C                   MOVE      KYWAOPFIRM    WAOPFIRM
     C                   MOVE      KYWAOPPLAT    WAOPPLAT
     C                   MOVE      KYWAOPWKNR    WAOPWKNR
     C                   MOVE      KYWAOPKSTC    WAOPKSTC
     C                   MOVE      KYWAOPKDGR    WAOPKDGR
     C                   MOVE      KYWAOPKDPL    WAOPKDPL
     C                   MOVE      KYWAOPKDNR    WAOPKDNR
     C                   MOVE      KYWAOPLDNR    WAOPLDNR
     C                   MOVE      KYWAOPTENR    WAOPTENR
     C                   MOVE      KYWAOPJAHR    WAOPJAHR
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOPLOCK      IFEQ      'L'
     C     WAOPJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOP01
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOP01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'U'                                          UPDATE, LOCK
     C*                                                                         DURCH SYSTEM
     C*--------------------------------------------------------
     C                   OTHER
     C                   UNLOCK    WAOP01
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
