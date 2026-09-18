     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei WAO1
     H**************************************************************************
     H*  Copyright 1994/2001 by trend SWM
     H*                         Verwaltung GmbH
     H*                         Ziegelhofstraße 210a
     H*                         DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  automatisch generiert
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm führt sämtliche Zugriffe und Änderungen in der Datei
     F*  WAO1 durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FWAO101    UF A E           K DISK    USROPN
     F                                     RENAME(WAO11:WAO101A)
     FWAO102    UF A E           K DISK    USROPN
     F                                     RENAME(WAO11:WAO102A)
     FWAO103    UF A E           K DISK    USROPN
     F                                     RENAME(WAO11:WAO103A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAO1          E DS
     D KYWAO1        E DS
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS
     D EXTR02        E DS                  INZ
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
     C                   PARM                    WAO1
     C                   PARM                    KYWAO1
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
     C     K#WAO1LOCK    ANDEQ     'L'                                          FÜR FREIGABE
     C                   MOVE      *BLANK        K#WAO1LOCK                     FALLS GELOCKT
     C                   MOVE      K#WAO1FIRM    KYWAO1FIRM
     C                   MOVE      K#WAO1LIJJ    KYWAO1LIJJ
     C                   MOVE      K#WAO1LINR    KYWAO1LINR
     C                   MOVE      K#WAO1RALP    KYWAO1RALP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKCHNR        CASEQ     '01'          FILE01
     C     WKCHNR        CASEQ     '02'          FILE02
     C     WKCHNR        CASEQ     '03'          FILE03
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
     C                   MOVEL(P)  WKJNAM        WAO1JNAM                       JOBNAME
     C                   Z-ADD     WKJDAT        WAO1JDAT                       JOBDATUM
     C                   Z-ADD     WKJZEI        WAO1JZEI                       JOBZEIT
     C                   MOVEL(P)  WKUSER        WAO1USER                       USER
     C                   MOVEL(P)  WKPROG        WAO1PROG                       PROGRAMM
     C                   MOVEL(P)  WKBIBL        WAO1BIBL                       BIBLIOTHEK
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
     C                   MOVEL(P)  WAO1JNAM      WKJNAM                         JOBNAME
     C                   Z-ADD     WAO1JDAT      WKJDAT                         JOBDATUM
     C                   Z-ADD     WAO1JZEI      WKJZEI                         JOBZEIT
     C                   MOVEL(P)  WAO1USER      WKUSER                         USER
     C                   MOVEL(P)  WAO1PROG      WKPROG                         PROGRAMM
     C                   MOVEL(P)  WAO1BIBL      WKBIBL                         BIBLIOTHEK
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
     C                   MOVEL(P)  'L'           K#WAO1LOCK
     C                   MOVE      KYWAO1FIRM    K#WAO1FIRM
     C                   MOVE      KYWAO1LIJJ    K#WAO1LIJJ
     C                   MOVE      KYWAO1LINR    K#WAO1LINR
     C                   MOVE      KYWAO1RALP    K#WAO1RALP
     C*
     C                   MOVEL(P)  'L'           WAO1LOCK                       BEI 'LOCK'
     C                   MOVEL(P)  DAJNAM        WAO1JNAM                       ZUGRIFFELDER
     C                   MOVEL(P)  WKCHPN        WAO1PROG                       MIT USERDATEN
     C                   MOVEL(P)  WKCHPL        WAO1BIBL                       FÜLLEN
     C                   MOVEL(P)  DAUSER        WAO1USER
     C                   TIME                    WAO1JZEI
     C*--------------------------------------------------------
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   MOVE      *BLANK        #CRTCD
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        WAO1JDAT
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
     C                   MOVEL(P)  WAO1JNAM      DSJNAM                         ANZEIGE 'SATZ
     C                   MOVEL(P)  WAO1PROG      DSPROG                         WIRD BENUTZT
     C                   MOVEL(P)  WAO1BIBL      DSBIBL                         DURCH ...'
     C                   MOVEL(P)  WAO1USER      DSUSER                         FÜLLEN
     C                   Z-ADD     WAO1JZEI      DSJZEI
     C*--------------------------------------------------------
     C                   Z-ADD     WAO1JDAT      #CDATV
     C                   MOVEL(P)  '*ISO'        #CFMTV
     C                   MOVEL(P)  '*EUR'        #CFMTN
     C                   MOVE      *BLANK        #CRTCD
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAO101                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAO101      KLIST                                                  KEY WAO101
     C                   KFLD                    KYWAO1FIRM
     C                   KFLD                    KYWAO1LIJJ
     C                   KFLD                    KYWAO1LINR
     C                   KFLD                    KYWAO1RALP
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAO101                               98      DATEI
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAO101      CHAIN     WAO101                             9798
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO101A                              98
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
     C                   DELETE    WAO101A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAO101      READE     WAO101                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO101A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAO101
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAO101      SETGT     WAO101                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAO101      SETLL     WAO101                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAO101      READE     WAO101                               9899
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
     C     KYWAO101      SETLL     WAO101                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAO101                               9899
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
     C                   READ      WAO101                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAO101A                              98
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   WRITE     WAO101A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAO101      SETGT     WAO101                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAO101                               9899
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
     C     KYWAO101      SETLL     WAO101                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAO101                               9899
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
     C                   CLEAR                   WAO1
     C                   MOVE      KYWAO1FIRM    WAO1FIRM
     C                   MOVE      KYWAO1LIJJ    WAO1LIJJ
     C                   MOVE      KYWAO1LINR    WAO1LINR
     C                   MOVE      KYWAO1RALP    WAO1RALP
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAO101
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAO101A                              98
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
     C                   UNLOCK    WAO101
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAO102                                             ***
     C**************************************************************************
     C     FILE02        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO02                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAO102      KLIST                                                  KEY WAO102
     C                   KFLD                    KYWAO1FIRM
     C                   KFLD                    KYWAO1UEST
     C                   KFLD                    KYWAO1LIJJ
     C                   KFLD                    KYWAO1LINR
     C                   KFLD                    KYWAO1RALP
     C*-------------------------------------------------------------------------
     C     WKIO02        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAO102                               98      DATEI
     C                   MOVE      *ON           WKIO02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAO102      CHAIN     WAO102                             9798
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO102A                              98
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
     C                   DELETE    WAO102A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAO102      READE     WAO102                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDEQ     DAJNAM
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO102A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAO102
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAO102      SETGT     WAO102                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAO102      SETLL     WAO102                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAO102      READE     WAO102                               9899
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
     C     KYWAO102      SETLL     WAO102                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAO102                               9899
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
     C                   READ      WAO102                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAO102A                              98
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   WRITE     WAO102A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAO102      SETGT     WAO102                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAO102                               9899
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
     C     KYWAO102      SETLL     WAO102                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAO102                               9899
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
     C                   CLEAR                   WAO1
     C                   MOVE      KYWAO1FIRM    WAO1FIRM
     C                   MOVE      KYWAO1UEST    WAO1UEST
     C                   MOVE      KYWAO1LIJJ    WAO1LIJJ
     C                   MOVE      KYWAO1LINR    WAO1LINR
     C                   MOVE      KYWAO1RALP    WAO1RALP
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAO102
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAO102A                              98
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
     C                   UNLOCK    WAO102
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WAO103                                             ***
     C**************************************************************************
     C     FILE03        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO03                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWAO103      KLIST                                                  KEY WAO103
     C                   KFLD                    KYWAO1FIRM
     C                   KFLD                    KYWAO1DANA
     C                   KFLD                    KYWAO1JAHR
     C                   KFLD                    KYWAO1NMKR
     C                   KFLD                    KYWAO1POSI
     C                   KFLD                    KYWAO1LIJJ
     C                   KFLD                    KYWAO1LINR
     C                   KFLD                    KYWAO1RALP
     C*-------------------------------------------------------------------------
     C     WKIO03        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WAO103                               98      DATEI
     C                   MOVE      *ON           WKIO03
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWAO103      CHAIN     WAO103                             9798
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO103A                              98
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
     C                   DELETE    WAO103A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWAO103      READE     WAO103                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDEQ     DAJNAM
     C                   MOVE      *BLANK        WAO1LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WAO103A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WAO103
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWAO103      SETGT     WAO103                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWAO103      SETLL     WAO103                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWAO103      READE     WAO103                               9899
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
     C     KYWAO103      SETLL     WAO103                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WAO103                               9899
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
     C                   READ      WAO103                               9899
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
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   UPDATE    WAO103A                              98
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
     C                   MOVE      *BLANK        WAO1LOCK
     C                   ENDIF
     C*
     C                   WRITE     WAO103A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWAO103      SETGT     WAO103                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WAO103                               9899
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
     C     KYWAO103      SETLL     WAO103                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WAO103                               9899
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
     C                   CLEAR                   WAO1
     C                   MOVE      KYWAO1FIRM    WAO1FIRM
     C                   MOVE      KYWAO1DANA    WAO1DANA
     C                   MOVE      KYWAO1JAHR    WAO1JAHR
     C                   MOVE      KYWAO1NMKR    WAO1NMKR
     C                   MOVE      KYWAO1POSI    WAO1POSI
     C                   MOVE      KYWAO1LIJJ    WAO1LIJJ
     C                   MOVE      KYWAO1LINR    WAO1LINR
     C                   MOVE      KYWAO1RALP    WAO1RALP
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WAO1LOCK      IFEQ      'L'
     C     WAO1JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WAO103
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WAO103A                              98
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
     C                   UNLOCK    WAO103
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,TRDAUM
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
