     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE  prüfen WE mit Lager 500/510 Bestand vorhanden ?
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 13.09.2016 Dometic
     H*  -----------------------------------------------------------------------
     F**************************************************************************
     F*/
     F*/
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
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
     C*
     C                   MOVEL     'U5BWAE'      DAPROG
     C                   OUT       EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OBWAE                                        ÖFFNEN BWAEC1
     C                   EXSR      VBWAE                                        VERARBEIT.BWAEC1
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
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR BWAEC1                                             ***
     C**************************************************************************
     C     OBWAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE BWAEC1 CURSOR FOR SELECT * FROM BWAE
     C+ WHERE BWAE.AEFIRM=:DAFIRM
     C+ AND   BWAE.AEBWLA='510'
     C+ ORDER BY AEFIRM, AEWEJJ, AEWENR
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN BWAEC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN BWAE                                                  ***
     C**************************************************************************
     C     VBWAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYBWAE
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH BWAEC1 INTO :BWAE
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *OFF          KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *OFF          KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     AETENR        KOM(10)
     C                   MOVEA     AEBWLA        KOM(25)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C*
     C     DUN134        IFLE      *ZERO
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     AEWEJJ        DUN040
     C                   MOVEA     DUC004        KOM(01)
     C                   MOVEA     AEWENR        KOM(05)
     C                   MOVEA     KOM(01)       EXTRNDKEYB
     C*
     C                   EVAL       EXTRNDDATE = BWAE
     C                   MOVEL(P)  'L     '      EXTRNDPGST
     C*
     C                   CALL      'MOBWAE'                             99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UBWAE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE BWAEC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BWAE                                                 ***
     C**************************************************************************
     C     UBWAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AEFIRM        KYAEFI
     C                   Z-ADD     AEWEJJ        KYAEWJ
     C                   MOVEL(P)  AEWENR        KYAEWE
     C                   MOVEA     '07CU    '    CHI
     C                   EXSR      CHBWAE
     C*-------------------------------------------------------------------------
     C                   MOVEL     '110'         AEBWLA
     C*-------------------------------------------------------------------------
     C                   MOVEA     '07U     '    CHI
     C                   EXSR      CHBWAE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VLIKE  DEFINITION DER WORKFELDER...                               ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AEBIBL        WKCHPL
     C     *LIKE         DEFINE    AEPROG        WKCHPN
     C     *LIKE         DEFINE    AEUSER        WKUSER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY - MODULE                                                     ***
     C**************************************************************************
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  E N D E  D E S   P R O G R A M M S                                ***
     O**************************************************************************
