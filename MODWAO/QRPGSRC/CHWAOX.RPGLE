     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei WAOX
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
     F*  WAOX durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FWAOX01    UF A E           K DISK    USROPN
     F                                     RENAME(WAOX1:WAOX01A)
     FWAOX00    UF A E           K DISK    USROPN
     F                                     RENAME(WAOX1:WAOX00A)
     FWAOX02    UF A E           K DISK    USROPN
     F                                     RENAME(WAOX1:WAOX02A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAOX          E DS
     D KYWAOX        E DS
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
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    ##CHI
     C                   PARM                    WAOX
     C                   PARM                    KYWAOX
     C                   PARM                    EXTR01
     C*
     C                   MOVEA     ##CHI         CHI
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
     C     K#WAOXLOCK    ANDEQ     'L'                                          FÜR FREIGABE
     C                   MOVE      *BLANK        K#WAOXLOCK                     FALLS GELOCKT
     C                   MOVE      K#WAOXFIRM    KYWAOXFIRM
     C                   MOVE      K#WAOXTENR    KYWAOXTENR
     C                   MOVE      K#WAOXLAND    KYWAOXLAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKCHNR        CASEQ     '01'          FILE01
     C     WKCHNR        CASEQ     '00'          FILE00
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
     C                   MOVEL(P)  WKJNAM        WAOXJNAM                       JOBNAME
     C                   Z-ADD     WKJDAT        WAOXJDAT                       JOBDATUM
     C                   Z-ADD     WKJZEI        WAOXJZEI                       JOBZEIT
     C                   MOVEL(P)  WKUSER        WAOXUSER                       USER
     C                   MOVEL(P)  WKPROG        WAOXPROG                       PROGRAMM
     C                   MOVEL(P)  WKBIBL        WAOXBIBL                       BIBLIOTHEK
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
     C                   MOVEL(P)  WAOXJNAM      WKJNAM                         JOBNAME
     C                   Z-ADD     WAOXJDAT      WKJDAT                         JOBDATUM
     C                   Z-ADD     WAOXJZEI      WKJZEI                         JOBZEIT
     C                   MOVEL(P)  WAOXUSER      WKUSER                         USER
     C                   MOVEL(P)  WAOXPROG      WKPROG                         PROGRAMM
     C                   MOVEL(P)  WAOXBIBL      WKBIBL                         BIBLIOTHEK
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
     C                   MOVEL(P)  'L'           K#WAOXLOCK
     C                   MOVE      KYWAOXFIRM    K#WAOXFIRM
     C                   MOVE      KYWAOXTENR    K#WAOXTENR
     C                   MOVE      KYWAOXLAND    K#WAOXLAND
     C*
     C                   MOVEL(P)  'L'           WAOXLOCK                       BEI 'LOCK'
     C                   MOVEL(P)  EXPSDSJNAM    WAOXJNAM                       ZUGRIFFELDER
     C                   MOVEL(P)  WKCHPN        WAOXPROG                       MIT USERDATEN
     C                   MOVEL(P)  WKCHPL        WAOXBIBL                       FÜLLEN
     C                   MOVEL(P)  EXPSDSUSER    WAOXUSER
     C*--------------------------------------------------------
     C                   TIME                    CHN120
     C                   MOVE      CHN120        CHN060
     C     *JOBRUN       MOVE      CHN060        CHTDAT
     C                   MOVEL     CHN120        WAOXJZEI
     C                   MOVE      CHTDAT        WAOXJDAT
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
     C                   MOVEL(P)  WAOXJNAM      DSJNAM                         ANZEIGE 'SATZ
     C                   MOVEL(P)  WAOXPROG      DSPROG                         WIRD BENUTZT
     C                   MOVEL(P)  WAOXBIBL      DSBIBL                         DURCH ...'
     C                   MOVEL(P)  WAOXUSER      DSUSER                         FÜLLEN
     C                   Z-ADD     WAOXJZEI      DSJZEI
     C                   Z-ADD     WAOXJDAT      DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOX01                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOX01      KLIST                                                  KEY WAOX01
     C                   KFLD                    KYWAOXFIRM
     C                   KFLD                    KYWAOXTENR
     C                   KFLD                    KYWAOXLAND
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOX01                               98      DATEI
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOX01      CHAIN     WAOX01                             9798
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX01A                              98
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
     C                   DELETE    WAOX01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOX01      READE     WAOX01                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOX01
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOX01      SETGT     WAOX01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOX01      SETLL     WAOX01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOX01      READE     WAOX01                               9899
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
     C     KYWAOX01      SETLL     WAOX01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOX01                               9899
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
     C                   READ      WAOX01                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOX01A                              98
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOX01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOX01      SETGT     WAOX01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOX01                               9899
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
     C     KYWAOX01      SETLL     WAOX01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOX01                               9899
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
     C                   CLEAR                   WAOX
     C                   MOVE      KYWAOXFIRM    WAOXFIRM
     C                   MOVE      KYWAOXTENR    WAOXTENR
     C                   MOVE      KYWAOXLAND    WAOXLAND
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOX01
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOX01A                              98
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
     C                   UNLOCK    WAOX01
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOX00                                             ***
     C**************************************************************************
     C     FILE00        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO00                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOX00      KLIST                                                  KEY WAOX00
     C                   KFLD                    KYWAOXFIRM
     C                   KFLD                    KYWAOXTENR
     C                   KFLD                    KYWAOXLAND
     C*-------------------------------------------------------------------------
     C     WKIO00        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOX00                               98      DATEI
     C                   MOVE      *ON           WKIO00
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOX00      CHAIN     WAOX00                             9798
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX00A                              98
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
     C                   DELETE    WAOX00A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOX00      READE     WAOX00                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDEQ     EXPSDSJNAM
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX00A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOX00
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOX00      SETGT     WAOX00                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOX00      SETLL     WAOX00                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOX00      READE     WAOX00                               9899
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
     C     KYWAOX00      SETLL     WAOX00                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOX00                               9899
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
     C                   READ      WAOX00                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOX00A                              98
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOX00A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOX00      SETGT     WAOX00                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOX00                               9899
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
     C     KYWAOX00      SETLL     WAOX00                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOX00                               9899
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
     C                   CLEAR                   WAOX
     C                   MOVE      KYWAOXFIRM    WAOXFIRM
     C                   MOVE      KYWAOXTENR    WAOXTENR
     C                   MOVE      KYWAOXLAND    WAOXLAND
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOX00
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOX00A                              98
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
     C                   UNLOCK    WAOX00
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAOX02                                             ***
     C**************************************************************************
     C     FILE02        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO02                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAOX02      KLIST                                                  KEY WAOX02
     C                   KFLD                    KYWAOXFIRM
     C                   KFLD                    KYWAOXLAND
     C                   KFLD                    KYWAOXTENR
     C*-------------------------------------------------------------------------
     C     WKIO02        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAOX02                               98      DATEI
     C                   MOVE      *ON           WKIO02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAOX02      CHAIN     WAOX02                             9798
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX02A                              98
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
     C                   DELETE    WAOX02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAOX02      READE     WAOX02                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDEQ     EXPSDSJNAM
     C                   MOVE      *BLANK        WAOXLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAOX02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAOX02
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAOX02      SETGT     WAOX02                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAOX02      SETLL     WAOX02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAOX02      READE     WAOX02                               9899
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
     C     KYWAOX02      SETLL     WAOX02                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAOX02                               9899
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
     C                   READ      WAOX02                               9899
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
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAOX02A                              98
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
     C                   MOVE      *BLANK        WAOXLOCK
     C                   ENDIF
     C*
     C                   WRITE     WAOX02A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAOX02      SETGT     WAOX02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAOX02                               9899
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
     C     KYWAOX02      SETLL     WAOX02                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAOX02                               9899
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
     C                   CLEAR                   WAOX
     C                   MOVE      KYWAOXFIRM    WAOXFIRM
     C                   MOVE      KYWAOXLAND    WAOXLAND
     C                   MOVE      KYWAOXTENR    WAOXTENR
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAOXLOCK      IFEQ      'L'
     C     WAOXJNAM      ANDNE     EXPSDSJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAOX02
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAOX02A                              98
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
     C                   UNLOCK    WAOX02
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
