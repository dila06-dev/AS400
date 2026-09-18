     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE  Update Datei WAOP
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 11.10.2012 Telefonat Herr Klaffke
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*/
     F*/ Update Datei WAOP
     F*/
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAOP          E DS                  INZ
     D KYWAOP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXWAOP        E DS                  INZ
     D RTWAOP        E DS                  INZ
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
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OWAOP
     C                   EXSR      VWAOP
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYWAOPFIRM                     WAOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOPC1                                             ***
     C**************************************************************************
     C     OWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOPC1 CURSOR FOR SELECT * FROM WAOP
     C+   WHERE WAOPFIRM = :DAFIRM
     C+   AND   WAOPPLAT = '001'
     C+   AND   WAOPJAHR = 2013
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN WAOP                                                  ***
     C**************************************************************************
     C     VWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  FETCH WAOPC1 INTO :WAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*--------------------------------------------------------
     C                   EXSR      TRWAOP
     C*--------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOP                                                 ***
     C**************************************************************************
     C     TRWAOP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOP
     C                   MOVEL     *OFF          EXWAOPIFKZ
     C                   MOVEL     *BLANK        EXWAOPPGST
     C                   MOVEL     WAOPPLAT      EXWAOPPLAT
     C                   MOVEL     WAOPWKNR      EXWAOPWKNR
     C                   MOVEL     WAOPKSTC      EXWAOPKSTC
     C                   MOVEL     WAOPKDGR      EXWAOPKDGR
     C                   MOVEL     WAOPKDPL      EXWAOPKDPL
     C                   MOVEL     WAOPKDNR      EXWAOPKDNR
     C                   MOVEL     WAOPLDNR      EXWAOPLDNR
     C                   MOVEL     WAOPTENR      EXWAOPTENR
     C                   Z-ADD     WAOPJAHR      EXWAOPJAHR
     C*
     C                   Z-ADD     WAOPPLMG      EXWAOPPLMG
     C                   Z-ADD     WAOPPLUM      EXWAOPPLUM
     C                   Z-ADD     WAOPSTPR      EXWAOPSTPR
     C                   MOVEL     WAOPPDAV      EXWAOPPDAV
     C                   Z-ADD     WAOPERTR      EXWAOPERTR
     C                   Z-ADD     WAOPMG01      EXWAOPMG01
     C                   Z-ADD     WAOPMG02      EXWAOPMG02
     C                   Z-ADD     WAOPMG03      EXWAOPMG03
     C                   Z-ADD     WAOPMG04      EXWAOPMG04
     C                   Z-ADD     WAOPMG05      EXWAOPMG05
     C                   Z-ADD     WAOPMG06      EXWAOPMG06
     C                   Z-ADD     WAOPMG07      EXWAOPMG07
     C                   Z-ADD     WAOPMG08      EXWAOPMG08
     C                   Z-ADD     WAOPMG09      EXWAOPMG09
     C                   Z-ADD     WAOPMG10      EXWAOPMG10
     C                   Z-ADD     WAOPMG11      EXWAOPMG11
     C                   Z-ADD     WAOPMG12      EXWAOPMG12
     C                   Z-ADD     WAOPUM01      EXWAOPUM01
     C                   Z-ADD     WAOPUM02      EXWAOPUM02
     C                   Z-ADD     WAOPUM03      EXWAOPUM03
     C                   Z-ADD     WAOPUM04      EXWAOPUM04
     C                   Z-ADD     WAOPUM05      EXWAOPUM05
     C                   Z-ADD     WAOPUM06      EXWAOPUM06
     C                   Z-ADD     WAOPUM07      EXWAOPUM07
     C                   Z-ADD     WAOPUM08      EXWAOPUM08
     C                   Z-ADD     WAOPUM09      EXWAOPUM09
     C                   Z-ADD     WAOPUM10      EXWAOPUM10
     C                   Z-ADD     WAOPUM11      EXWAOPUM11
     C                   Z-ADD     WAOPUM12      EXWAOPUM12
     C                   Z-ADD     WAOPER01      EXWAOPER01
     C                   Z-ADD     WAOPER02      EXWAOPER02
     C                   Z-ADD     WAOPER03      EXWAOPER03
     C                   Z-ADD     WAOPER04      EXWAOPER04
     C                   Z-ADD     WAOPER05      EXWAOPER05
     C                   Z-ADD     WAOPER06      EXWAOPER06
     C                   Z-ADD     WAOPER07      EXWAOPER07
     C                   Z-ADD     WAOPER08      EXWAOPER08
     C                   Z-ADD     WAOPER09      EXWAOPER09
     C                   Z-ADD     WAOPER10      EXWAOPER10
     C                   Z-ADD     WAOPER11      EXWAOPER11
     C                   Z-ADD     WAOPER12      EXWAOPER12
     C                   MOVEL     WAOPWACD      EXWAOPWACD
     C                   MOVEL     WAOPSTKD      EXWAOPSTKD
     C*
     C                   CALL      'TRWAOP'
     C                   PARM                    EXWAOP
     C                   PARM                    RTWAOP
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHWAOP
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
