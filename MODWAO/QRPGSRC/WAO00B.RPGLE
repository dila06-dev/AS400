     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG
     H**************************************************************************
     H/TITLE  Drucken Identstamm-Etikett
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO00BDR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     F                                     USROPN
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRDR
     D/COPY TAMP/QCPYSRC,EXTRDA
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D EXFIRM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXADRE        E DS                  INZ
     D RTADRE        E DS                  INZ
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D/COPY TAMP/QCPYSRC,EXUX01
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     D*
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,TRSPOL
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   EXSR      ERMKO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*                                                                     ----
     C*                                                                     ----
     C*-------------------------------------------------------------------------
     C     1             DO        DSANZE
     C                   EXSR      VTENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYLDFI                         TEUF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXWAOA                                                 ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  KOM(01)       KYTENR
     C*
     C                   MOVEA(P)  KOM(16)       DUC002
     C                   TESTN                   DUC002               97
     C     *IN97         IFEQ      *ON
     C                   Z-ADD     DUN020        DSANZE            2 0
     C                   ELSE
     C                   Z-ADD     *ZERO         DSANZE
     C                   ENDIF
     C                   MOVEA(P)  KOM(18)       DSLANR            3
     C                   MOVEA(P)  KOM(21)       DSLORT            8
     C                   MOVEA(P)  KOM(29)       DSOBUN            1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DRUCKKONSTANTE                                          ***
     C**************************************************************************
     C     ERMKO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO00B'      KYTPTA
     C                   MOVEL(P)  'WAO00B'      KYTPTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  KYTPFI        OFTPFI
     C                   MOVEL(P)  KYTPSP        OFTPSP
     C                   MOVEL(P)  KYTPTA        OFTPTA
     C                   MOVEL(P)  KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C                   DO        100           I1
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     TPFIRM        IFGT      OFTPFI
     C     TPSPCD        ORGT      OFTPSP
     C     TPTART        ORGT      OFTPTA
     C     TPTCDE        ORGT      OFTPTC
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  TPTTXT        KON(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KON(01)       KON001           40
     C                   MOVEL(P)  KON(02)       KON002           40
     C                   MOVEL(P)  KON(03)       KON003           40
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSITIONSZEILEN                                           ***
     C**************************************************************************
     C     ZEILEN        BEGSR
     C*
     C                   MOVEL(P)  KON001        TXTENR
     C                   MOVEL(P)  KON002        TXTBZ1
     C                   MOVEL(P)  KON003        TXLANR
     C*-------------------------------------------------------------------
     C* Teile-Nr. zulesen
     C*-------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   EVAL      PTTENR = TETENR
     C                   EVAL      PTTBZ1 = TETBZ1
     C     TEEANR        IFNE      *BLANKS
     C                   EVAL      PTEANR = TEEANR
     C**                 EVAL      PTEANT = TEEANR
     C                   ELSE
     C                   EVAL      PTEANR = TETENR
     C**                 EVAL      PTEANT = TETENR
     C                   ENDIF
     C*-------------------------------------------------------------------
     C* Lager-Nr. zulesen
     C*-------------------------------------------------------------------
     C                   MOVEL     DSLANR        KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C*-------------------------------------------------------------------------
     C                   EVAL      PTLBZ1 = LDLBZ1
     C                   EVAL      PTLAGN = DSLANR + ' / ' + DSLORT
     C                   EVAL      PTLAGE = DSLANR + DSLORT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  Verarbeiten Identnummer                                           ***
     C**************************************************************************
     C     VTENR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      ZEILEN
     C                   EXSR      DRUCK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKROUTINE                                                      ***
     C**************************************************************************
     C     DRUCK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   OPEN      WAO00BDR
     C*-------------------------------------------------------------------------
     C     KYTENR        IFNE      *BLANKS
     C     DSOBUN        IFEQ      'O'
     C                   WRITE     EXDR03
     C                   ELSE
     C                   WRITE     EXDR01
     C                   ENDIF
     C                   ELSE
     C                   WRITE     EXDR02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLOSE     WAO00BDR
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
     C     *LIKE         DEFINE    WKC001        ##CHI          +  7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT         +  1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR         +  3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIKOP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        PTTXT1         + 64
     C     *LIKE         DEFINE    WKC001        PTTXT2         + 64
     C     *LIKE         DEFINE    WKC001        WKSORT         + 54
     C     *LIKE         DEFINE    WKC001        PTSDDA         +  9
     C     *LIKE         DEFINE    WKC001        PTGWBR         +  9
     C     *LIKE         DEFINE    WKC001        PTFIRM         + 39
     C     *LIKE         DEFINE    WKC001        PTPACK         +  9
     C     *LIKE         DEFINE    WKC001        TXPAKN         + 29
     C     *LIKE         DEFINE    WKC001        WKTEXT         +189
     C     *LIKE         DEFINE    WKC001        BARC01          +29
     C     *LIKE         DEFINE    WKC001        BARC02          +29
     C     *LIKE         DEFINE    WKC001        BARC03          +29
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRTPKRTN     +  9
     C     *LIKE         DEFINE    WKC001        WKTRTPPLTT     +  9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0             +  2
     C     *LIKE         DEFINE    WKN010        I1             +  2
     C     *LIKE         DEFINE    WKN010        I2             +  2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRADRE
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
