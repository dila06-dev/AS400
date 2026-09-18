     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei WA12
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
     F*  WA12 durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FWA1201    UF A E           K DISK    USROPN
     F                                     RENAME(WA121:WA1201A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WA12          E DS
     D KYWA12        E DS
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
     C                   PARM                    WA12
     C                   PARM                    KYWA12
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
     C     K#WA12LOCK    ANDEQ     'L'                                          FÜR FREIGABE
     C                   MOVE      *BLANK        K#WA12LOCK                     FALLS GELOCKT
     C                   MOVE      K#WA12FIRM    KYWA12FIRM
     C                   MOVE      K#WA12AFAT    KYWA12AFAT
     C                   MOVE      K#WA12KDNR    KYWA12KDNR
     C                   MOVE      K#WA12PRGR    KYWA12PRGR
     C                   MOVE      K#WA12TENR    KYWA12TENR
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
     C                   MOVEL(P)  WKJNAM        WA12JNAM                       JOBNAME
     C                   Z-ADD     WKJDAT        WA12JDAT                       JOBDATUM
     C                   Z-ADD     WKJZEI        WA12JZEI                       JOBZEIT
     C                   MOVEL(P)  WKUSER        WA12USER                       USER
     C                   MOVEL(P)  WKPROG        WA12PROG                       PROGRAMM
     C                   MOVEL(P)  WKBIBL        WA12BIBL                       BIBLIOTHEK
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
     C                   MOVEL(P)  WA12JNAM      WKJNAM                         JOBNAME
     C                   Z-ADD     WA12JDAT      WKJDAT                         JOBDATUM
     C                   Z-ADD     WA12JZEI      WKJZEI                         JOBZEIT
     C                   MOVEL(P)  WA12USER      WKUSER                         USER
     C                   MOVEL(P)  WA12PROG      WKPROG                         PROGRAMM
     C                   MOVEL(P)  WA12BIBL      WKBIBL                         BIBLIOTHEK
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
     C                   MOVEL(P)  'L'           K#WA12LOCK
     C                   MOVE      KYWA12FIRM    K#WA12FIRM
     C                   MOVE      KYWA12AFAT    K#WA12AFAT
     C                   MOVE      KYWA12KDNR    K#WA12KDNR
     C                   MOVE      KYWA12PRGR    K#WA12PRGR
     C                   MOVE      KYWA12TENR    K#WA12TENR
     C*
     C                   MOVEL(P)  'L'           WA12LOCK                       BEI 'LOCK'
     C                   MOVEL(P)  DAJNAM        WA12JNAM                       ZUGRIFFELDER
     C                   MOVEL(P)  WKCHPN        WA12PROG                       MIT USERDATEN
     C                   MOVEL(P)  WKCHPL        WA12BIBL                       FÜLLEN
     C                   MOVEL(P)  DAUSER        WA12USER
     C*--------------------------------------------------------
     C                   TIME                    CHN120
     C                   MOVE      CHN120        CHN060
     C     *JOBRUN       MOVE      CHN060        CHTDAT
     C                   MOVEL     CHN120        WA12JZEI
     C                   MOVE      CHTDAT        WA12JDAT
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
     C                   MOVEL(P)  WA12JNAM      DSJNAM                         ANZEIGE 'SATZ
     C                   MOVEL(P)  WA12PROG      DSPROG                         WIRD BENUTZT
     C                   MOVEL(P)  WA12BIBL      DSBIBL                         DURCH ...'
     C                   MOVEL(P)  WA12USER      DSUSER                         FÜLLEN
     C                   Z-ADD     WA12JZEI      DSJZEI
     C                   Z-ADD     WA12JDAT      DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE WA1201                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01                         FILE OPEN KENNZ
     C*-------------------------------------------------------------------------
     C     KYWA1201      KLIST                                                  KEY WA1201
     C                   KFLD                    KYWA12FIRM
     C                   KFLD                    KYWA12AFAT
     C                   KFLD                    KYWA12KDNR
     C                   KFLD                    KYWA12PRGR
     C                   KFLD                    KYWA12TENR
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      WA1201                               98      DATEI
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'                                          CHAIN
     C     KYWA1201      CHAIN     WA1201                             9798
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
     C                   MOVE      *BLANK        WA12LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WA1201A                              98
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
     C                   DELETE    WA1201A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'                                          READE
     C     KYWA1201      READE     WA1201                               9899
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
     C     WA12LOCK      IFEQ      'L'
     C     WA12JNAM      ANDNE     DAJNAM
     C                   MOVE      *BLANK        WA12LOCK
     C                   EXSR      RZUGR
     C                   UPDATE    WA1201A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    WA1201
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'                                          SETGT
     C     KYWA1201      SETGT     WA1201                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'                                          SETLL/READE
     C     KYWA1201      SETLL     WA1201                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYWA1201      READE     WA1201                               9899
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
     C     KYWA1201      SETLL     WA1201                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'                                          READP
     C                   READP     WA1201                               9899
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
     C                   READ      WA1201                               9899
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
     C     WA12LOCK      IFEQ      'L'
     C     WA12JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        WA12LOCK
     C                   ENDIF
     C*
     C                   UPDATE    WA1201A                              98
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
     C                   MOVE      *BLANK        WA12LOCK
     C                   ENDIF
     C*
     C                   WRITE     WA1201A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'                                          SETGT/READP
     C     KYWA1201      SETGT     WA1201                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     WA1201                               9899
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
     C     KYWA1201      SETLL     WA1201                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      WA1201                               9899
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
     C                   CLEAR                   WA12
     C                   MOVE      KYWA12FIRM    WA12FIRM
     C                   MOVE      KYWA12AFAT    WA12AFAT
     C                   MOVE      KYWA12KDNR    WA12KDNR
     C                   MOVE      KYWA12PRGR    WA12PRGR
     C                   MOVE      KYWA12TENR    WA12TENR
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'                                          BLOCKIEREN
     C*
     C     WA12LOCK      IFEQ      'L'
     C     WA12JNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    WA1201
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    WA1201A                              98
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
     C                   UNLOCK    WA1201
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
