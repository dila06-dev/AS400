     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Setzen des Firmennamens
     H**************************************************************************
     H*  Copyright 2004 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 30.03.2004
     H*  -----------------------------------------------------------------------
     H*  Geändert: xx xx.xx.xxxx text
     F**************************************************************************
     F*
     F*  Dieses Programm setzt den Firmennamen nach der Erstellung der
     F*  Datenbibliothek TVPFTEST.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNG                                                 ***
     F**************************************************************************
     FFIRM01    UF   E           K DISK    RENAME(FIRM1:FIRM01A)
     F*
     FTRTP01    UF   E           K DISK    RENAME(TRTP1:TRTP01A)
     C**************************************************************************
     C***  S C H L Ü S S E L                                                 ***
     C**************************************************************************
     C     KYFIRM01      KLIST
     C                   KFLD                    FIRMFIRM
     C*
     C     KYTRTP01      KLIST
     C                   KFLD                    TPFIRM
     C                   KFLD                    TPSPCD
     C                   KFLD                    TPTART
     C                   KFLD                    TPTCDE
     C                   KFLD                    TPTFLG
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '01'          FIRMFIRM
     C     KYFIRM01      CHAIN     FIRM01A                            97
     C     *IN97         IFEQ      *OFF
     C                   EVAL       FIRMKNAM = '** TEST ** WAECO'
     C                   EVAL       FIRMNAM1 = 'WAECO'
     C                   EVAL       FIRMMCBG = '** TEST **'
     C                   UPDATE    FIRM01A
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '01'          TPFIRM
     C                   MOVEL(P)  'D'           TPSPCD
     C                   MOVEL(P)  'FIRM'        TPTART
     C                   MOVEL(P)  '01'          TPTCDE
     C                   Z-ADD     0             TPTFLG
     C     KYTRTP01      CHAIN     TRTP01A                            97
     C     *IN97         IFEQ      *OFF
     C                   EVAL       TPTTXT = '** TEST ** WAECO'
     C                   UPDATE    TRTP01A
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
