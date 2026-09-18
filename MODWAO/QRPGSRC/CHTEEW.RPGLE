     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Zugriff auf Datei TEEW
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
     F*  TEEW durch. Der Aufruf des Programms erfolgt über CALL aus anderen
     F*  Programmen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG STAMMDATEIEN                                    ***
     F**************************************************************************
     FTEEW01    UF A E           K DISK    USROPN
     F                                     RENAME(TEEW1:TEEW01A)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEEW          E DS
     D KYTEEW        E DS
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
     C                   PARM                    TEEW
     C                   PARM                    KYTEEW
     C                   PARM                    EXTR01
     C*
     C                   MOVEA     ##CHI         CHI
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   MOVE      *ON           WKI000
     C                   ENDIF
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   MOVEA     CHI(1)        WKCHNR
     C                   MOVEA     CHI(3)        WKCHOP
     C                   MOVEA     CHI(4)        WKCHCU
     C*
     C                   MOVE      'N'           WKCHRT
     C                   MOVEA     *OFF          *IN(97)
     C*-------------------------------------------------------------------------
     C     WKCHCU        IFEQ      'F'
     C     K#TEEWLOCK    ANDEQ     'L'
     C                   MOVE      *BLANK        K#TEEWLOCK
     C                   MOVE      K#TEEWFIRM    KYTEEWFIRM
     C                   MOVE      K#TEEWTENR    KYTEEWTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKCHNR        CASEQ     '01'          FILE01
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEA     WKCHRT        CHI(5)
     C                   MOVEA     *IN(97)       CHI(6)
     C                   MOVEA     CHI           ##CHI
     C*-------------------------------------------------------------------------
     C     WKCHNR        IFEQ      'LR'
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
     C                   Z-ADD     *ZERO         DSJDAT
     C                   Z-ADD     *ZERO         DSJZEI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN FELDER USERZUGRIFF                                        ***
     C**************************************************************************
     C     LZUGR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKJNAM
     C                   Z-ADD     *ZERO         WKJDAT
     C                   Z-ADD     *ZERO         WKJZEI
     C                   MOVE      *BLANK        WKUSER
     C                   MOVE      *BLANK        WKPROG
     C                   MOVE      *BLANK        WKBIBL
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
     C                   MOVEL(P)  WKJNAM        TEEWJNAM
     C                   Z-ADD     WKJDAT        TEEWJDAT
     C                   Z-ADD     WKJZEI        TEEWJZEI
     C                   MOVEL(P)  WKUSER        TEEWUSER
     C                   MOVEL(P)  WKPROG        TEEWPROG
     C                   MOVEL(P)  WKBIBL        TEEWBIBL
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
     C                   MOVEL(P)  TEEWJNAM      WKJNAM
     C                   Z-ADD     TEEWJDAT      WKJDAT
     C                   Z-ADD     TEEWJZEI      WKJZEI
     C                   MOVEL(P)  TEEWUSER      WKUSER
     C                   MOVEL(P)  TEEWPROG      WKPROG
     C                   MOVEL(P)  TEEWBIBL      WKBIBL
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##PGST
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILCK
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DSJNAM        WKJNAM
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSPROG        WKPROG
     C     *LIKE         DEFINE    DSBIBL        WKBIBL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE FUER LOCK                                                  ***
     C**************************************************************************
     C     ULOCK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'L'           K#TEEWLOCK
     C                   MOVE      KYTEEWFIRM    K#TEEWFIRM
     C                   MOVE      KYTEEWTENR    K#TEEWTENR
     C*
     C                   MOVEL(P)  'L'           TEEWLOCK
     C                   MOVEL(P)  DAJNAM        TEEWJNAM
     C                   MOVEL(P)  WKCHPN        TEEWPROG
     C                   MOVEL(P)  WKCHPL        TEEWBIBL
     C                   MOVEL(P)  DAUSER        TEEWUSER
     C*--------------------------------------------------------
     C                   TIME                    CHN120
     C                   MOVE      CHN120        CHN060
     C     *JOBRUN       MOVE      CHN060        CHTDAT
     C                   MOVEL     CHN120        TEEWJZEI
     C                   MOVE      CHTDAT        TEEWJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DS-FELDER MIT DATEIFELDERN                                 ***
     C**************************************************************************
     C     UDADS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'L'           WKCHRT
     C                   MOVEL(P)  TEEWJNAM      DSJNAM
     C                   MOVEL(P)  TEEWPROG      DSPROG
     C                   MOVEL(P)  TEEWBIBL      DSBIBL
     C                   MOVEL(P)  TEEWUSER      DSUSER
     C                   Z-ADD     TEEWJZEI      DSJZEI
     C                   Z-ADD     TEEWJDAT      DSJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFROUTINE TEEW01                                             ***
     C**************************************************************************
     C     FILE01        BEGSR
     C*
     C     *LIKE         DEFINE    WKC001        WKIO01
     C*-------------------------------------------------------------------------
     C     KYTEEW01      KLIST
     C                   KFLD                    KYTEEWFIRM
     C                   KFLD                    KYTEEWTENR
     C*-------------------------------------------------------------------------
     C     WKIO01        IFNE      *ON
     C                   OPEN      TEEW01                               98
     C                   MOVE      *ON           WKIO01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKILCK
     C*--------------------------------------------------------
     C                   SELECT
     C     WKCHOP        WHENEQ    'C'
     C     KYTEEW01      CHAIN     TEEW01                             9798
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
     C     WKCHCU        ANDEQ     'F'
     C                   MOVE      *BLANK        TEEWLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   OTHER
     C                   MOVE      *ON           WKILCK
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'D'
     C                   DELETE    TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'E'
     C     KYTEEW01      READE     TEEW01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'F'
     C*
     C     TEEWLOCK      IFEQ      'L'
     C     TEEWJNAM      ANDNE     DAJNAM
     C                   MOVE      *BLANK        TEEWLOCK
     C                   EXSR      RZUGR
     C                   UPDATE    TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ELSE
     C                   UNLOCK    TEEW01
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'G'
     C     KYTEEW01      SETGT     TEEW01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'K'
     C     KYTEEW01      SETLL     TEEW01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C     KYTEEW01      READE     TEEW01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'L'
     C     KYTEEW01      SETLL     TEEW01                             9798
     C*
     C     *IN97         IFEQ      *OFF
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'P'
     C                   READP     TEEW01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'R'
     C                   READ      TEEW01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'U'
     C*
     C     WKCHCU        IFEQ      'L'
     C*
     C     TEEWLOCK      IFEQ      'L'
     C     TEEWJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   ELSE
     C                   EXSR      ULOCK
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVE      *BLANK        TEEWLOCK
     C                   ENDIF
     C*
     C                   UPDATE    TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    'W'
     C*
     C     WKCHCU        IFEQ      'L'
     C                   EXSR      ULOCK
     C                   ELSE
     C                   MOVE      *BLANK        TEEWLOCK
     C                   ENDIF
     C*
     C                   WRITE     TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   EXSR      LZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '-'
     C     KYTEEW01      SETGT     TEEW01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READP     TEEW01                               9899
     C*
     C     *IN98         IFEQ      *OFF
     C     *IN99         ANDEQ     *OFF
     C                   EXSR      SZUGR
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKILCK
     C*--------------------------------------------------------
     C     WKCHOP        WHENEQ    '+'
     C     KYTEEW01      SETLL     TEEW01                             9798
     C                   MOVEA     *OFF          *IN(97)
     C                   READ      TEEW01                               9899
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
     C     WKILCK        IFEQ      *ON
     C*
     C                   SELECT
     C     WKCHRT        WHENNE    'J'
     C                   CLEAR                   TEEW
     C                   MOVE      KYTEEWFIRM    TEEWFIRM
     C                   MOVE      KYTEEWTENR    TEEWTENR
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'L'
     C*
     C     TEEWLOCK      IFEQ      'L'
     C     TEEWJNAM      ANDNE     DAJNAM
     C                   EXSR      UDADS
     C                   UNLOCK    TEEW01
     C                   ELSE
     C                   EXSR      ULOCK
     C                   UPDATE    TEEW01A                              98
     C*
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'J'           WKCHRT
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKCHCU        WHENEQ    'U'
     C*
     C*--------------------------------------------------------
     C                   OTHER
     C                   UNLOCK    TEEW01
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ENDE DES PROGRAMMS                                                ***
     C**************************************************************************
