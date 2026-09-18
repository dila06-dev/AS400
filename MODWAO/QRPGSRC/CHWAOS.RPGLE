     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei WAOS
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
     F*  WAOS durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FWAOS01    UF A E           K DISK    USROPN
     F                                     RENAME(WAOS1:WAOS01A)
     FWAOS02    UF A E           K DISK    USROPN
     F                                     RENAME(WAOS1:WAOS02A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAOS          E DS
     D KYWAOS        E DS
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
     C                   PARM                    WAOS
     C                   PARM                    KYWAOS
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
     C     K#WAOSLOCK    ANDEQ     'L'                                          FÜR FREIGABE
     C                   MOVE      *BLANK        K#WAOSLOCK                     FALLS GELOCKT
     C                   MOVE      K#WAOSFIRM    KYWAOSFIRM
     C                   MOVE      K#WAOSLISO    KYWAOSLISO
     C                   MOVE      K#WAOSPLZB    KYWAOSPLZB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKCHNR        CASEQ     '01'          FILE01
     C     WKCHNR        CASEQ     '02'          FILE02
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
     C                   MOVEL(P)  WKJNAM        WAOSJNAM                       JOBNAME
     C                   Z-ADD     WKJDAT        WAOSJDAT                       JOBDATUM
     C                   Z-ADD     WKJZEI        WAOSJZEI                       JOBZEIT
     C                   MOVEL(P)  WKUSER        WAOSUSER                       USER
     C                   MOVEL(P)  WKPROG        WAOSPROG                       PROGRAMM
     C                   MOVEL(P)  WKBIBL        WAOSBIBL                       BIBLIOTHEK
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
     C                   MOVEL(P)  WAOSJNAM      WKJNAM                         JOBNAME
     C                   Z-ADD     WAOSJDAT      WKJDAT                         JOBDATUM
     C                   Z-ADD     WAOSJZEI      WKJZEI                         JOBZEIT
     C                   MOVEL(P)  WAOSUSER      WKUSER                         USER
     C                   MOVEL(P)  WAOSPROG      WKPROG                         PROGRAMM
     C                   MOVEL(P)  WAOSBIBL      WKBIBL                         BIBLIOTHEK
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
     C                   MOVEL(P)  'L'           K#WAOSLOCK
     C                   MOVE      KYWAOSFIRM    K#WAOSFIRM
     C                   MOVE      KYWAOSLISO    K#WAOSLISO
     C                   MOVE      KYWAOSPLZB    K#WAOSPLZB
     C*
     C                   MOVEL(P)  'L'           WAOSLOCK                       BEI 'LOCK'
     C                   MOVEL(P)  DAJNAM        WAOSJNAM                       ZUGRIFFELDER
     C                   MOVEL(P)  WKCHPN        WAOSPROG                       MIT USERDATEN
     C                   MOVEL(P)  WKCHPL        WAOSBIBL                       FÜLLEN
     C                   MOVEL(P)  DAUSER        WAOSUSER
     C*--------------------------------------------------------
     C                   TIME                    CHN120
     C                   MOVE      CHN120        CHN060
     C     *JOBRUN       MOVE      CHN060        CHTDAT
     C                   MOVEL     CHN120        WAOSJZEI
     C                   MOVE      CHTDAT        WAOSJDAT
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
     C                   MOVEL(P)  WAOSJNAM      DSJNAM                         ANZEIGE 'SATZ
     C                   MOVEL(P)  WAOSPROG      DSPROG                         WIRD BENUTZT
     C                   MOVEL(P)  WAOSBIBL      DSBIBL                         DURCH ...'
     C                   MOVEL(P)  WAOSUSER      DSUSER                         FÜLLEN
     C                   Z-ADD     WAOSJZEI      DSJZEI
     C                   Z-ADD     WAOSJDAT      DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOS01                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOS01      KLIST                                                  KEY WAOS01
     C                   KFLD                    KYWAOSFIRM
     C                   KFLD                    KYWAOSLISO
     C                   KFLD                    KYWAOSPLZB
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOS01                               98      DATEI
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOS01      CHAIN     WAOS01                             9798
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
     C                   MOVE      *BLANK        WAOSLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOS01A                              98
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
     C                   DELETE    WAOS01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOS01      READE     WAOS01                               9899
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
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDNE     DAJNAM
     C                   MOVE      *BLANK        WAOSLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOS01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOS01
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOS01      SETGT     WAOS01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOS01      SETLL     WAOS01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOS01      READE     WAOS01                               9899
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
     C     KYWAOS01      SETLL     WAOS01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOS01                               9899
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
     C                   READ      WAOS01                               9899
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
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOSLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOS01A                              98
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
     C                   MOVE      *BLANK        WAOSLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOS01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOS01      SETGT     WAOS01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOS01                               9899
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
     C     KYWAOS01      SETLL     WAOS01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOS01                               9899
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
     C                   CLEAR                   WAOS
     C                   MOVE      KYWAOSFIRM    WAOSFIRM
     C                   MOVE      KYWAOSLISO    WAOSLISO
     C                   MOVE      KYWAOSPLZB    WAOSPLZB
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOS01
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOS01A                              98
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
     C                   UNLOCK    WAOS01
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOS02                                             ***
     C**************************************************************************
     C     FILE02        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO02                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOS02      KLIST                                                  KEY WAOS02
     C                   KFLD                    KYWAOSFIRM
     C                   KFLD                    KYWAOSLISO
     C                   KFLD                    KYWAOSPLZV
     C*-------------------------------------------------------------------------
     C     WKIO02        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOS02                               98      DATEI
     C                   MOVE      *ON           WKIO02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOS02      CHAIN     WAOS02                             9798
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
     C                   MOVE      *BLANK        WAOSLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOS02A                              98
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
     C                   DELETE    WAOS02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOS02      READE     WAOS02                               9899
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
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDEQ     DAJNAM
     C                   MOVE      *BLANK        WAOSLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOS02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOS02
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOS02      SETGT     WAOS02                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOS02      SETLL     WAOS02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOS02      READE     WAOS02                               9899
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
     C     KYWAOS02      SETLL     WAOS02                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOS02                               9899
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
     C                   READ      WAOS02                               9899
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
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOSLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOS02A                              98
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
     C                   MOVE      *BLANK        WAOSLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOS02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOS02      SETGT     WAOS02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOS02                               9899
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
     C     KYWAOS02      SETLL     WAOS02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOS02                               9899
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
     C                   CLEAR                   WAOS
     C                   MOVE      KYWAOSFIRM    WAOSFIRM
     C                   MOVE      KYWAOSLISO    WAOSLISO
     C                   MOVE      KYWAOSPLZV    WAOSPLZV
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOSLOCK      IFEQ      'L'
     C     WAOSJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOS02
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOS02A                              98
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
     C                   UNLOCK    WAOS02
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
