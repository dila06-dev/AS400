     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Druck Etikett Schenker
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 12.01.2011 WAECO, Projekt 7485
     H*  -----------------------------------------------------------------------
     H*  Änderung:
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm erstellt das Etikett für Spedition Schenker
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAOG      IT   F  128        DISK
     FWAO031DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     F                                     USROPN
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D DR1             S            128    DIM(99) FROMFILE(WAOG)               DRUCKKONSTANTE
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXW021        E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXW021
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      DRUCK01
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCK ETIKETT                                                     ***
     C**************************************************************************
     C     DRUCK01       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   OPEN      WAO031DR
     C*-------------------------------------------------------------------------
     C                   DO        56            I1
     C                   EVAL      WKTEXT = %TRIMR(DR1(I1))
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      I1          = 09
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +                    DATUM
     C                             %TRIMR(EXW021F012) + '"'
     C                   WHEN      I1          = 10
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(%SUBST(EXW021F032:1:5))  + '"'         EMPFANGS-GST.
     C                   WHEN      I1          = 23
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ABS1)  + '"'                     ABSENDER
     C                   WHEN      I1          = 99
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ABS2)  + '"'
     C                   WHEN      I1          = 24
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ASTR)  + '"'
     C                   WHEN      I1          = 25
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021APLZ)  + '"'
     C                   WHEN      I1          = 26
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021AORT)  + '"'
     C                   WHEN      I1          = 27
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIMR(EXW021F043) + '"'                     HUB
     C                   WHEN      I1          = 31
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ADR1)  + '"'                     EMPFÄNGER
     C                   WHEN      I1          = 99
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ADR2)  + '"'
     C                   WHEN      I1          = 32
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021STRA)  + '"'
     C                   WHEN      I1          = 99
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021POLD)  + '"'
     C                   WHEN      I1          = 33
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021POLZ)  + '"'
     C                   WHEN      I1          = 34
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(%SUBST(EXW021WORT:1:18))  + '"'
     C                   WHEN      I1          = 35
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021ABFA)  + '"'                     ABSTELLFACH
     C                   WHEN      I1          = 39
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021SSCC)  + '"'                     NVE/SSCC
     C                   WHEN      I1          = 40
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021F011)  + '"'                     REFERENZ
     C                   WHEN      I1          = 42
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021F044)  + '"'                     GEWICHT
     C                   WHEN      I1          = 43
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021F008)  + '/' +                   LFD.ANZAHL
     C                             %TRIM(EXW021F045)  + '"'                     ANZ. VON
     C                   WHEN      I1          = 52
     C                   EVAL      WKTEXT = %TRIMR(WKTEXT) +
     C                             %TRIM(EXW021BARC)  + '"'                     NVE BARCODE
     C                   ENDSL
     C*--------------------------------------------------------
     C                   WRITE     EXDR00
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLOSE     WAO031DR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI          +  7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI001
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR         +  3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTEXT         +127
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1             +  2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2             +  2            INDEX 2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
