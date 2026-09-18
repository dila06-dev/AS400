     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 19.11.2010 WAECO Projekt 6943
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 15.12.2015 Einstellung Standardwert Kreditlimit abhängig
     H*            vom Mandanten
     H*            DSKDEWxxxx Felder entfernt, weil nicht definiert. MOKUND war
     H*            bisher nie in Verwendung.
     H*  Änderung: PH 22./24.11.2024 Zusätzliche Anforderungen zum Projekt "Preise nach Segment"
     H*            (ursprünglich Case #03895676). Prüfung Kunden-Nr auf "Segment"-Zuordnung
     H*             über WA16/WA17 (s. Routine PRSEGM).
     H*  Änderung: PH 10.12.2024 Case #03813644. Update-Routine "UPKDST" für den Status KUND.KDKDST
     H*  Änderung: PH 06.06.2025 Projekt Dometic Germany - B2B (Case #03777387). Aktualisieren das
     H*            Änderung-Job-Datum/die letzte Änderungs-Job-Zeit in der Update-Routine "UPKDST"
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D WKKDEW        E DS                  INZ EXTNAME(KDEW) PREFIX(WK)
     D KYKDEW        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  EXKDEWKEYB                  256
     D   EXKDEWKDNR                  10    OVERLAY(EXKDEWKEYB:1)
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
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERSBFL'
     C                   EXSR      ERSBFL
     C     PCPGST        WHENEQ    'ERKLSU'
     C                   EXSR      ERKLSU
     C     PCPGST        WHENEQ    'PRSEGM'
     C                   EXSR      PRSEGM
     C     PCPGST        WHENEQ    'UPKDST'
     C                   EXSR      UPKDST
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDKEYB    KYKDNR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KUNDEN-ANSPRECHPARTNER                                  ***
     C**************************************************************************
     C     ERSBFL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEWGSKZ      WKKDEWGSKZ
     C                   MOVEL(P)  KDEWKDKR      WKKDEWKDKR
     C                   MOVEL(P)  KDEWBLKZ      WKKDEWBLKZ
     C                   MOVEL(P)  KDEWBVKG      WKKDEWBVKG
     C                   MOVEL(P)  KDEWKSST      WKKDEWKSST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN START KREDITLIMIT ABHÄNGIG VOM MANDANTEN                ***
     C**************************************************************************
     C     ERKLSU        BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM = '01'
     C                   EVAL      KDKLSU = 3000
     C                   EVAL      KDBNKZ = '1'
     C                   WHEN      DAFIRM = '61'
     C                   EVAL      KDKLSU = 1000
     C                   EVAL      KDBNKZ = '1'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE = KDBNKZ + %EDITC(KDKLSU:'X')
     C*-------------------------------------------------------------------------
     C                   ENDSR
      /FREE
       //*************************************************************************
       //**  SR-PRXEGM  Prüfen der an das Programm übergebenen Kunden-Nr auf   ***
       //**  deren Zuordnung über WA16/WA17 zu einer Produktgruppe aus der     ***
       //**  TEEW, die in der TRTP-Tabelle "$$TEEWPRGR" hinterlegt ist und     ***
       //**  dort in der Textzeile 1 einen nicht leeren Inhalt, d. h. ein sog. ***
       //**  "Segment" hat.                                                    ***
       //*************************************************************************
       BEGSR PRSEGM;

         SQLCOD = *ZERO;

         EXEC SQL SELECT 1 INTO :I1 FROM WA16
         WHERE WA16.WA16FIRM = :DAFIRM
           AND WA16.WA16KDNR = :KYKDNR
           AND EXISTS(SELECT 1 FROM WA17
           WHERE WA17.WA17FIRM = WA16.WA16FIRM
             AND WA17.WA17KDGR = WA16.WA16KDGR
             AND EXISTS(SELECT 1 FROM TRTP
             WHERE TRTP.TPFIRM = WA17.WA17FIRM
               AND TRTP.TPSPCD = :DASPCD
               AND TRTP.TPTART = '$$TEEWPRGR'
               AND TRTP.TPTCDE = WA17.WA17PRGR
               AND TRTP.TPTFLG = 1
               AND TRTP.TPTTXT <> ''))
         FETCH FIRST ROW ONLY;

         IF SQLCOD < *ZERO OR SQLCOD >= 100;
           RTTRNDRTCD = 'N';
         ELSE;
           RTTRNDRTCD = 'J';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  SR-UPKDST  Updaten KD-Status KUND.KDKDST                          ***
       //*************************************************************************
       begsr UPKDST;

         CHIDS = '01CU';
         exsr CHKUND;
         if CHI(5) = 'J';
           KDKDST = %subst(EXTRNDDATE:01);
           KDJNAM = DAJNAM;
           KDPROG = DAPROG;
           KDBIBL = WKCHPL;
           KDUSER = DAUSER;
           KDJZEI = %dec(%time());
           KDJDAT = %dec(%date():*ISO);
           CHIDS = '01U';
           exsr CHKUND;
         endif;

       endsr;
      /END-FREE
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*
     C     *LIKE         DEFINE    WKC001        WKTRPAAPKM      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAAPTE      + 9
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
