     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2017')
     H**************************************************************************
     H/TITLE  Verarbeiten Lieferantenstamm für Schilling
     H**************************************************************************
     H*  Copyright 2017    by trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 02.12.2017 Projekt 13108 Hungen
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm liest die Datei mit den Lieferanten und ruft für jeden
     F*  Datensatz das Programm ISCHLIEF auf, für die Übergabe der Daten an
     F*  Schilling.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D W99             S              1    DIM(99)                              WORKFELDGRUPPE
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
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
     C                   EXSR      VLIEF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLFFI
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINIION DER WORKFELDER                                          ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX 0
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN LIEFERANTEN                                           ***
     C**************************************************************************
     C     VLIEF         BEGSR
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LIEFC1 CURSOR FOR SELECT * FROM LIEF
     C+ WHERE LFFIRM = :DAFIRM
     C+   AND LFJDAT > 20170630
     C+   AND LFPROG = 'TRIMVA01'
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LIEFC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   EVAL      SQLCOD = *ZERO
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD = *ZERO
     C/EXEC SQL
     C+ FETCH NEXT FROM LIEFC1 INTO :LIEF
     C/END-EXEC
     C                   IF        (SQLCOD < 0 OR
     C                              SQLCOD >= 100)
     C                   LEAVE
     C                   ENDIF
     C*
     C                   IF        LFLFST >= '90'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   IF        LFKRLF <> *BLANK AND
     C                             LFKRLF <> LFLFNR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   #CKOMM
     C                   EVAL      %SUBST(#CKOMM:1:3) = LFWKNR
     C                   EVAL      %SUBST(#CKOMM:4:10) = LFLFNR
     C                   MOVEL(P)  'W     '      #CPGST
     C                   CALL      'ISCHLIEF'                           98
     C                   PARM                    EXTR02
     C                   PARM                    LIEF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE LIEFC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLIEF
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
