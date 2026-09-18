     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE Anzeige offene Posten
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: GD 24.04.2009
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 19.12.2010 Mandant aus Parameter FIRM/BUHA/MAND
     H*  Änderung: SZ 04.01.2013 Projekt 9111, Kundennummer 5-stellig bei Firma
     H*            '55' (Dometic CH)
     H*  Änderung: SZ 31.01.2013 Projekt 9110, Kundennummer 7-stellig bei Firma
     H*            '08' (Dometic Belgien) und '52' (Dometic NL)
     H*  Änderung: SZ 14.02.2013 Projekt 9110, Kundennummer 7-stellig bei Firma
     H*            '08' (Dometic Belgien) und '52' (Dometic NL), aber führende
     H*            '0'
     H*  Änderung: SZ 04.09.2015 Projekt 11614 Dometic AT. Debitor 6-stellig.
     F**************************************************************************
     F*
     F*  Mit diesem Programm werden die offene Posten aus der Schilling-Buchaltung
     F*  angezeigt. Dieses Programm ist notwendig, da die bisherige Darstellung
     F*  unter XCALIBER nicht möglich war.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FHAW042FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(HAW042R1:RCDNBR)
     F                                     SFILE(DLH042R1:WKRCNO)
     F*
     FFPSKTO00  IF   E           K DISK
     FFOPPK91   IF   E           K DISK
     FFBUTXT00  IF   E           K DISK
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFLH042         S                   LIKE(KYH042) DIM(999) DESCEND
     D SFLAUSW         S                   LIKE(SFAUSW) DIM(999)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,MCCURSOR
     D*
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D UXH042        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D KYTRPC        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     DFOPPK01        E DS
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXNUUM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
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
     D/COPY QCPYSRC,EXUX05
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
     D                 DS                  INZ
     D  KYH042                       19
     D   KYH042OPFA                   5  0 OVERLAY(KYH042:1)
     D   KYH042OPOPAR                 1    OVERLAY(KYH042:6)
     D   KYH042OPKTO                  9    OVERLAY(KYH042:7)
     D   KYH042OPOPNR                10  0 OVERLAY(KYH042:8)
     D   KYH042OPOPUN                 2  0 OVERLAY(KYH042:18)
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
     C                   PARM                    EXTR02
     C                   PARM                    EXTR03
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      KEYH042
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      'M1'          WKIFMT
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      HAW042FM
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'DL'          BILDDL
     C     WKIFMT        CASEQ     'M1'          BILDM1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     #CRTCD        OREQ      '9'
     C**                 CLEAR                   AFVSVW01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     HAW042FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ER\FFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN
     C                   Z-ADD     *ZERO         #CDATV
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'HAW042'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         EXTEXTMSGA
     C                   MOVEL(P)  'KEIN'        EXTEXTMSGN
     C                   MOVE      'PRUEFE'      EXTEXTPGST
     C
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C                   MOVEL(P)  RTTEXTTEXT    TXKEIN
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVE      '01'          WKMCKZ
     C                   Z-ADD     *ZERO         WKPAGE
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*--------------------------------------------------------
     C                   BITOFF    '01234567'    WKAT01
     C                   BITON     '26'          WKAT01
     C                   BITOFF    '01234567'    WKAT02
     C                   BITON     '25'          WKAT02
     C                   BITOFF    '01234567'    WKAT03
     C                   BITON     '24'          WKAT03
     C                   BITOFF    '01234567'    WKROTF                         ROT
     C                   BITON     '24'          WKROTF                         ROT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *OFF          WKIOKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAW042FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     *DATE         EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   MOVEL     RTDATEDATE    WKDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     #CPGST        IFNE      WKPGST
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CMCFG        MCF
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     WKPGST        ANDEQ     *BLANK                                       auf reinen Anzeige-
     C                   MOVE      '5     '      WKPGST                         modus umschalten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSH042KDNR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0602'        #CUEBE
     C     #CUEBE        WHENEQ    *BLANK
     C                   MOVE      '0012'        #CUEBE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BNR'         EXTEXTMSGA
     C                   MOVEL(P)  #CUEBE        EXTEXTMSGN
     C                   MOVE      'ERMBSK'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C*
     C                   MOVEL(P)  RTTEXTTEXT    DSBT01
     C                   MOVEA(P)  RTTEXTBSKZ    BSK
     C*-------------------------------------------------------------------------
     C     *YEAR         SUB       1             WKYEARLOW         4 0
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKBT24
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C                   MOVE      *OFF          WKIWND
     C*-------------------------------------------------------------------------
     C     WKPGST        IFNE      *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBEST]CKUNG H042                                                ***
     C**************************************************************************
     C     KEYH042       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        UFH042KDNR
     C                   MOVE      *HIVAL        OFH042KDNR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM      = '08'
     C                   EVAL      UFH042KDNR  = WKTRPAKTAD + '0' +
     C                                           %SUBST(DSH042KDNR:1:7)
     C                   WHEN      DAFIRM      = '52'
     C                   EVAL      UFH042KDNR  = WKTRPAKTAD + '0' +
     C                                           %SUBST(DSH042KDNR:1:7)
     C                   WHEN      DAFIRM      = '55'
     C                   EVAL      UFH042KDNR  = WKTRPAKTAD + %SUBST(DSH042KDNR:
     C                                           1:5) + '0000'
     C                   OTHER
     C                   EVAL      UFH042KDNR  = WKTRPAKTAD + %SUBST(DSH042KDNR:
     C                                           1:6) + '000'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      '02'          WKMCKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD01                                              ***
     C**************************************************************************
     C     BILD01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   WRITE     HAW04201
     C                   WRITE     HAW042K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   WRITE     HAW042B2
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      HAW042K1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#UPDT        WHENEQ    *ON
     C     FUKT05        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   EXSR      TRH042
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      B01SI
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#MUST        WHENEQ    *ON
     C     FUKT20        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   EXSR      TRH042
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#WEIT        WHENEQ    *ON
     C     FUKT24        ANDEQ     *ON
     C*
     C     WKBT24        IFEQ      *OFF
     C                   MOVE      *ON           WKBT24
     C                   ELSE
     C                   MOVE      *OFF          WKBT24
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#PGUP        WHENEQ    *ON
     C     FUKT26        ANDEQ     *ON
     C                   EXSR      BLAET
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      B01RA
     C                   EXSR      B01SF
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C     WKFENR        IFNE      *ZERO
     C     #CRTCD        OREQ      'N'
     C                   ITER
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  F]LLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C     WKUXMCOPEN    IFEQ      *ON
     C                   MOVEL     EXUXMCPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXMCOPEN
     C                   ENDIF
     C*
     C     WKUXMCOPEN    IFNE      *ON
     C                   EXSR      UXMCOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     HAW042K1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C                   Z-ADD     *ZERO         RCDNBR
     C                   Z-ADD     *ZERO         PAGNBR
     C*-------------------------------------------------------------------------
     C                   EXSR      CCURSOR
     C                   EXSR      OCURSOR
     C*-------------------------------------------------------------------------
     C     W$RCNO        DOWGT     RCDNBR
     C     W$RCNO        OREQ      *ZERO
     C*
     C                   SELECT
     C     WKMCKZ        WHENEQ    '02'
     C                   EXSR      H04202
     C                   ENDSL
     C*
     C                   MOVE      *ON           C#PGUP
     C*--------------------------------------------------------
     C     C#MORE        IFEQ      *ON
     C     W$RCNO        OREQ      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#PGUP
     C*
     C     W$RCNO        IFGT      *ZERO
     C     W$RCNO        ANDLE     RCDNBR
     C                   Z-ADD     W$RCNO        PAGNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      MCUEB
     C*
     C                   MOVEL(P)  KDNAM1        DSH042NAM1
     C                   MOVE      KDNAM2        DSH042NAM1
     C                   MOVEL(P)  KDSTRA        DSH042STRA
     C                   MOVEL(P)  KDPOLD        DSH042POLD
     C                   MOVEL(P)  KDPOLZ        DSH042POLZ
     C                   MOVEL(P)  KDWORT        DSH042WORT
     C     KYFPSK        KLIST
     C                   KFLD                    P0FA
     C                   KFLD                    P0KTO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  UFH042KDNR    P0KTO
     C     KYFPSK        CHAIN     FPSKTO00                           21
     C     P0L1          DIV(H)    1000          DSH042KRED
     C*-------------------------------------------------------------------------
     C                   EXSR      ERMOPS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM F]LLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     B01SI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXMCRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      RCDNBR = EXUXRCNR
     C     RCDNBR        CHAIN     HAW042R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK
     C                   MOVE      *ON           C#NEXT
     C                   ELSE
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    HAW042R1
     C                   MOVE      *OFF          C#NEXT
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RETTEN DER AUSWAHL                                                ***
     C**************************************************************************
     C     B01RA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I2
     C                   MOVEL(P)  KYH042        WKH042
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KYH042
     C                   MOVEL(P)  WKOPFA        KYH042OPFA
     C                   READC     HAW042R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TRH042                                       FORMAT SCHLIESSEN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    HAW042R1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KYH042        SFLH042(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKH042        KYH042
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPR]FUNG F]R SUBFILE                                         ***
     C**************************************************************************
     C     B01SF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      *OFF          WKIDEL
     C                   Z-ADD     *ZERO         WKRCNO
     C                   Z-ADD     *ZERO         W$RCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*-------------------------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     HAW042R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'ENDE  '      PCPGST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     RCDNBR        W$RCNO
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    HAW042R1
     C                   MOVE      *OFF          C#NEXT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      %TRIM(SFAUSW)='1' AND BSK(1)='J'
     C                   MOVE      '1     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='2' AND BSK(2)='J'
     C                   MOVE      '2     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='3' AND BSK(3)='J'
     C                   MOVE      '3     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='4' AND BSK(4)='J'
     C                   MOVE      '4     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='5' AND BSK(5)='J'
     C                   MOVE      '5     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='7' AND BSK(7)='J'
     C                   MOVE      '7     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)<>' ' AND BSK(10)='J'
     C                   MOVE      'TRTRDZ'      PCPGST
     C                   WHEN      %TRIM(SFAUSW)=' '
     C                   MOVE      '      '      PCPGST
     C                   OTHER
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   MOVEL(P)  KYH042        WKH042
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WKH042        KYH042
     C                   Z-ADD     W$RCNO        RCDNBR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKIDEL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   MOVE      'J'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *ON           *IN99
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      TRH042
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'TRTRDZ'
     C                   EXSR      TRTRDZ
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '7     '
     C*--------------------------------------------------------
     C     PCPGST        WHENNE    *BLANK
     C                   EXSR      TRH042
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   MOVE      'ENDE  '      PCPGST
     C                   EXSR      TRH042
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     HAW042R1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    HAW042R1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      '2     '      PCPGST
     C                   EXSR      TRH042
     C*--------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     RCDNBR        ANDGT     *ZERO
     C     RCDNBR        CHAIN     HAW042R1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    HAW042R1
     C                   MOVE      *OFF          C_AUSW
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPR]FUNG BILD01                                              ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C**   WKFENR        IFNE      *ZERO
     C**                 MOVE      *ON           C#LCK1
     C**                 LEAVESR
     C**                 ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE L\SCHANZEIGE                                        ***
     C**************************************************************************
     C     BILDDL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BDLDS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'DL'
     C                   WRITE     HAW04201
     C                   WRITE     DLH042K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     HAW042DL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DLH042K1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      BDLSI
     C                   MOVE      *ZERO         WKFENR
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      RFMTS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  F]LLEN L\SCHANZEIGE                                               ***
     C**************************************************************************
     C     BDLDS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     WKUXDLOPEN    IFEQ      *ON
     C                   MOVEL     EXUXDLPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXDLOPEN
     C                   ENDIF
     C*
     C     WKUXDLOPEN    IFNE      *ON
     C                   EXSR      UXDLOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     DLH042K1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     *ZERO         WKRCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      '4 '
     C     SFAUSW        OREQ      ' 4'
     C                   ADD       1             WKRCNO
     C                   WRITE     DLH042R1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     HAW042R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    HAW042R1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             WKPGNO
     C                   MOVE      '0005'        WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM F]LLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     BDLSI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXDLRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      WKRCNO      = EXUXRCNR
     C     WKRCNO        CHAIN     DLH042R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK
     C                   MOVE      *ON           C#NEXT
     C                   ELSE
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    DLH042R1
     C                   MOVE      *OFF          C#NEXT
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDM1                                              ***
     C**************************************************************************
     C     BILDM1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'M1'
     C                   EXSR      EFLPO
     C                   WRITE     HAW042W1
     C                   WRITE     HAW042M1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W1H042B2
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      HAW042M1                             9899
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYH042
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLH042
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         W$RCNO
     C                   MOVE      '01'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  F]LLEN BILDSCHIRMFORMAT M1                                        ***
     C**************************************************************************
     C     BM1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSH042KDNR'  EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPR]FUNG F]R BILDM1                                          ***
     C**************************************************************************
     C     BM1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRH042KDNR
     C*----------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILDM1                                           ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSH042KDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSH042KDNR'
     C                   EXSR      HAW042KDNR
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     HAW042KDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSH042KDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSH042KDNR    KOM(01)
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   MOVEL     *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF                                         FEHLER
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL(P)  *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSH042KDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRH042KDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSH042KDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSH042KDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'SFAUSW'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDNR'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BLAETTERROUTINE                                                   ***
     C**************************************************************************
     C     BLAET         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    '02'
     C                   EXSR      H04202
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     HAW042LO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE ]BERSCHRIFT ERMITTELN                                   ***
     C**************************************************************************
     C     MCUEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCUB'      WKSBFLPGST
     C                   Z-ADD     WKISIC        WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBE
     C                   EXSR      UMUEBE
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBEJV
     C                   EXSR      UMUEBEJV
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR                                                      ***
     C**************************************************************************
     C     CCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKOPEN02      WHENEQ    *ON
     C                   EXSR      CCH04202
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  OPEN CURSOR                                                       ***
     C**************************************************************************
     C     OCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    '02'
     C     WKOPEN02      ANDNE     *ON
     C                   EXSR      OCH04202
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR H04202                                             ***
     C**************************************************************************
     C     OCH04202      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPEN02
     C*-------------------------------------------------------------------------
     C                   IF        WKTRPAMAND <> *BLANK
     C                   MOVEL(P)  WKTRPAMAND    EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    P0FA
     C                   Z-ADD     EXNUUMNUMM    OPFA
     C                   Z-ADD     EXNUUMNUMM    WKFA
     C                   ELSE
     C                   Z-ADD     1             P0FA
     C                   Z-ADD     1             OPFA
     C                   Z-ADD     1             WKFA              5 0
     C                   ENDIF
     C*
     C                   MOVEL(P)  OPFA          KYH042OPFA
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE H042C2 CURSOR FOR SELECT * FROM FOPPK01
     C+ WHERE OPFA     = :WKFA               AND
     C+       OPKTO    = :UFH042KDNR         AND
     C+       OPOPST   <> '7'
     C+ ORDER BY OPFA, OPKTO, OPBGJT, OPOPNR
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN H042C2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI H042                                               ***
     C**************************************************************************
     C     H04202        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     10            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C                   Z-ADD     WKRENO        RCDNBR                         ZUR]CKSCHR.
     C                   ENDIF                                                  RCDNBR
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE)
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM H042C2 INTO :FOPPK01
     C/END-EXEC
     C*--------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C**   OPOPST        IFEQ      '7'
     C**                 ITER
     C**                 ENDIF
     C*--------------------------------------------------------
     C     OPFA          IFLT      WKFA
     C     OPKTO         ORLT      UFH042KDNR
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     OPFA          IFGT      WKFA
     C     OPKTO         ORGT      OFH042KDNR
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C                   Z-ADD     OPFA          KYH042OPFA
     C                   MOVEL(P)  OPOPAR        KYH042OPOPAR
     C                   MOVEL(P)  OPKTO         KYH042OPKTO
     C                   MOVEL(P)  OPOPNR        KYH042OPOPNR
     C                   MOVEL(P)  OPOPUN        KYH042OPOPUN
     C*
     C                   ADD       1             RCDNBR
     C*
     C                   EXSR      ADUMM
     C*
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW
     C                   EXSR      FKONS
     C*
     C                   WRITE     HAW042R1
     C                   EXSR      UXMCWRTE
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             I0
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      ERPAGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI H04202                                         ***
     C**************************************************************************
     C     CCH04202      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPEN02
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE H042C2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN F]R ANZEIGEN                                          ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KYFBUTX       KLIST
     C                   KFLD                    OPFA
     C                   KFLD                    OPBUNR
     C                   KFLD                    OPBUPS
     C                   KFLD                    BTBUTA
     C*
     C                   MOVE      'B'           BTBUTA
     C     KYFBUTX       CHAIN     BTSATZ                             21
     C     *IN21         IFEQ      *OFF
     C                   MOVEL     BTBGT1        WKBGT1
     C                   MOVEL     BTBGT2        WKBGT2
     C                   ELSE
     C                   MOVE      *BLANK        WKBGT1
     C                   MOVE      *BLANK        WKBGT2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     OPOPNR        WKOPNR
     C                   MOVEL     OPBGJT        WKBGJT
     C                   MOVEL     OPFLJT        WKFLJT
     C                   MOVEL(P)  OPSH          WKSHKZ
     C                   MOVEL(P)  OPWG          WKWAEH
     C                   MOVEL(P)  OPPJ          WKPROJ
     C                   Z-ADD     OPMNNR        WKMSTU
     C*
     C     OPURDM        ADD       OPDM          WKSALDO
     C     OPURWG        ADD       OPWGDM        WKSALDOFW
     C*
     C                   SELECT
     C     OPSH          WHENEQ    'S'
     C                   Z-ADD     OPURDM        WKSOLL
     C                   OTHER
     C                   Z-ADD     OPURDM        WKHABEN
     C                   ENDSL
     C*
     C     OPFLJT        IFLE      WKDATE                                       FÄLLIG ROT
     C                   MOVE      WKROTF        WKATFL            1
     C                   ELSE
     C                   MOVE      WKAT01        WKATFL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SICHTEN                                                           ***
     C**************************************************************************
     C     ERSIC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SIC
     C*
     C     SIC           DOWLE     10
     C     FSI(SIC)      ANDNE     *ZERO
     C                   MOVEL     'ERMCUZ'      WKSBFLPGST
     C                   Z-ADD     FSI(SIC)      WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C
     C                   SELECT
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1JV
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2JV
     C     SIC           WHENEQ    3
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS3
     C     SIC           WHENEQ    4
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS4
     C     SIC           WHENEQ    5
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS5
     C     SIC           WHENEQ    6
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS6
     C     SIC           WHENEQ    7
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS7
     C     SIC           WHENEQ    8
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS8
     C     SIC           WHENEQ    9
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS9
     C     SIC           WHENEQ    10
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS10
     C                   ENDSL
     C*
     C                   ADD       1             SIC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  F]LLEN VON KONS MIT DER JEWEILIGEN SICHT                          ***
     C**************************************************************************
     C     FKONS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     SI            WHENEQ    1
     C                   MOVEL     EXUXS1        SFKONS
     C                   MOVEL     EXUXS1JV      SFKONSJV
     C     SI            WHENEQ    2
     C                   MOVEL     EXUXS2        SFKONS
     C                   MOVEL     EXUXS2JV      SFKONSJV
     C     SI            WHENEQ    3
     C                   MOVEL     EXUXS3        SFKONS
     C     SI            WHENEQ    4
     C                   MOVEL     EXUXS4        SFKONS
     C     SI            WHENEQ    5
     C                   MOVEL     EXUXS5        SFKONS
     C     SI            WHENEQ    6
     C                   MOVEL     EXUXS6        SFKONS
     C     SI            WHENEQ    7
     C                   MOVEL     EXUXS7        SFKONS
     C     SI            WHENEQ    8
     C                   MOVEL     EXUXS8        SFKONS
     C     SI            WHENEQ    9
     C                   MOVEL     EXUXS9        SFKONS
     C     SI            WHENEQ    10
     C                   MOVEL     EXUXS10       SFKONS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  F]LLEN VON AUSW BEIM NEUAUFBAU DER SUBFILE                        ***
     C**************************************************************************
     C     FAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYH042        LOOKUP    SFLH042(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#NEXT
     C                   MOVEL(P)  SFLAUSW(I1)   SFAUSW
     C                   ELSE
     C                   MOVE      *OFF          C#NEXT
     C                   MOVE      *BLANK        SFAUSW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  L\SCHEN VON AUSW NACH ERFOLGREICHER BEARBEITUNG                   ***
     C**************************************************************************
     C     LAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYH042        LOOKUP    SFLH042(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFLH042(I1)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SEITE                                                   ***
     C**************************************************************************
     C     ERPAGE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     RCDNBR        WHENEQ    *ZERO
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     1             PAGNBR
     C                   MOVE      *ON           C#NDSP
     C                   MOVE      *ON           WKILER
     C                   MOVEL(P)  TXKEIN        EXUXS1
     C                   MOVEL(P)  TXKEIN        EXUXS2
     C                   MOVEL(P)  TXKEIN        EXUXS3
     C                   MOVEL(P)  TXKEIN        EXUXS4
     C                   MOVEL(P)  TXKEIN        EXUXS5
     C                   MOVEL(P)  TXKEIN        EXUXS6
     C                   MOVEL(P)  TXKEIN        EXUXS7
     C                   MOVEL(P)  TXKEIN        EXUXS8
     C                   MOVEL(P)  TXKEIN        EXUXS9
     C                   MOVEL(P)  TXKEIN        EXUXS10
     C                   MOVEL(P)  TXKEIN        SFKONS
     C                   MOVEL(P)  TXKEIN        SFKONSJV
     C                   WRITE     HAW042R1
     C                   EXSR      UXMCWRTE
     C*--------------------------------------------------------
     C     RCDNBR        WHENNE    *ZERO
     C     RCDNBR        SUB       1             PAGNBR
     C                   DIV       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   MULT      W$PAGE        PAGNBR
     C                   SUB       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   Z-ADD     PAGNBR        WKPAGE
     C                   Z-ADD     RCDNBR        WKRENO
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI H042                                                 ***
     C**************************************************************************
     C     TRH042        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF SUBFILE-ZEILEN-ERMITTLUNG                                  ***
     C**************************************************************************
     C     TRAUFRSBFL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSBFL
     C                   MOVEL(P)  'HAW042'      EXSBFLPROG
     C                   MOVEL(P)  'HAW042FM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C*
     C                   MOVEL(P)  '##BGT1'      EXSBFLAF01
     C                   MOVEL(P)  WKBGT1        EXSBFLAL01
     C                   MOVEL     WKATFL        EXSBFLAA01
     C*
     C                   MOVEL(P)  '##BGT2'      EXSBFLAF02
     C                   MOVEL(P)  WKBGT2        EXSBFLAL02
     C                   MOVEL     WKATFL        EXSBFLAA02
     C*
     C                   MOVEL(P)  '##SHKZ'      EXSBFLAF03
     C                   MOVEL(P)  WKSHKZ        EXSBFLAL03
     C                   MOVEL     WKATFL        EXSBFLAA03
     C*
     C                   MOVEL(P)  '##WAEH'      EXSBFLAF04
     C                   MOVEL(P)  WKWAEH        EXSBFLAL04
     C                   MOVEL     WKATFL        EXSBFLAA04
     C*
     C                   MOVEL(P)  '##PROJ'      EXSBFLAF05
     C                   MOVEL(P)  WKPROJ        EXSBFLAL05
     C                   MOVEL     WKATFL        EXSBFLAA05
     C*
     C                   MOVEL(P)  '##BGJT'      EXSBFLNF01
     C                   Z-ADD     WKBGJT        EXSBFLNU01
     C                   MOVEL(P)  WKATFL        EXSBFLAN01
     C*
     C                   MOVEL(P)  '##FLJT'      EXSBFLNF02
     C                   Z-ADD     WKFLJT        EXSBFLNU02
     C                   MOVEL(P)  WKATFL        EXSBFLAN02
     C*
     C                   MOVEL(P)  '##SALDO'     EXSBFLNF03
     C                   Z-ADD     WKSALDO       EXSBFLNU03
     C                   MOVEL(P)  WKATFL        EXSBFLAN03
     C*
     C                   MOVEL(P)  '##SOLL'      EXSBFLNF04
     C                   Z-ADD     WKSOLL        EXSBFLNU04
     C                   MOVEL(P)  WKATFL        EXSBFLAN04
     C*
     C                   MOVEL(P)  '##HABEN'     EXSBFLNF05
     C                   Z-ADD     WKHABEN       EXSBFLNU05
     C                   MOVEL(P)  WKATFL        EXSBFLAN05
     C*
     C                   MOVEL(P)  '##OPNR'      EXSBFLNF06
     C                   Z-ADD     WKOPNR        EXSBFLNU06
     C                   MOVEL(P)  WKATFL        EXSBFLAN06
     C*
     C                   MOVEL(P)  '##SALDOFW'   EXSBFLNF07
     C                   Z-ADD     WKSALDOFW     EXSBFLNU07
     C                   MOVEL(P)  WKATFL        EXSBFLAN07
     C*
     C                   MOVEL(P)  '##MSTU'      EXSBFLNF08
     C                   Z-ADD     WKMSTU        EXSBFLNU08
     C                   MOVEL     WKATFL        EXSBFLAN08
     C*
     C                   EXSR      TRSBFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCSI'      WKSBFLPGST
     C                   Z-ADD     *ZERO         WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEA(P)  RTSBFLMCSI    WSI
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SI
     C                   Z-ADD     *ZERO         FSI
     C*--------------------------------------------------------
     C                   DO        10            I1
     C                   TESTN                   WSI(I1)              97
     C*
     C     *IN97         IFEQ      *ON
     C                   ADD       1             SI
     C                   MOVE      WSI(I1)       FSI(SI)
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SI
     C                   Z-ADD     FSI(SI)       WKISIC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART DEBITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTDE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAKTAD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         MANDANT FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'MAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMAND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSWAHL 10 UND ZUGRIFF AUF TRTRDZ                                 ***
     C**************************************************************************
     C     TRTRDZ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *OFF          WKTRDZZYKL
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRDN
     C                   MOVEL(P)  SFAUSW        EXTRDNAWCD
     C                   MOVEL(P)  'HAW042'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'HAW042B2'    EXTRDNPGNA
     C                   MOVE      C#FUKT        EXTRDNFUKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C     SFAUSW        IFEQ      '10'
     C                   WRITE     HAW04201
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRTK'
     C                   EXSR      MCAUFRTRTK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*
     C     SFAUSW        IFNE      *BLANK
     C     SFAUSW        ANDNE     '10'
     C                   LEAVE
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#BACK        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXMCOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXMCPARM
     C                   EVAL      EXUXMCINAM = 'MCSBFH042'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile HAW042'
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXMCOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXMCWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = RCDNBR
     C                   EVAL      UXH042OPFA  = KYH042OPFA
     C                   EVAL      UXH042OPKT  = KYH042OPKTO
     C                   EVAL      UXH042OPNR  = KYH042OPOPNR
     C                   EVAL      UXH042OPNU  = KYH042OPOPUN
     C                   EVAL      UXH042OPAR  = KYH042OPOPAR
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UXH042
     C                   EVAL      EXUXMCIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXMCREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYH042
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UXH042)
     C                   EVAL      UXH042      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYH042OPFA  = UXH042OPFA
     C                   EVAL      KYH042OPKTO = UXH042OPKT
     C                   EVAL      KYH042OPOPNR= UXH042OPNR
     C                   EVAL      KYH042OPOPUN= UXH042OPNU
     C                   EVAL      KYH042OPOPAR= UXH042OPAR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN   USERINDEX                                               ***
     C**************************************************************************
     C     UXMCRMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUXRCNR     = RCDNBR
     C                   EVAL      UXH042OPFA  = KYH042OPFA
     C                   EVAL      UXH042OPKT  = KYH042OPKTO
     C                   EVAL      UXH042OPNR  = KYH042OPOPNR
     C                   EVAL      UXH042OPNU  = KYH042OPOPUN
     C                   EVAL      UXH042OPAR  = KYH042OPOPAR
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXH042
     C                   EVAL      EXUXMCIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCRMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXDLOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXDLPARM
     C                   EVAL      EXUXDLINAM  = 'DLSBFH042'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DLH042'
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXDLOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXDLWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = WKRCNO
     C                   EVAL      UXH042OPFA  = KYH042OPFA
     C                   EVAL      UXH042OPKT  = KYH042OPKTO
     C                   EVAL      UXH042OPNR  = KYH042OPOPNR
     C                   EVAL      UXH042OPNU  = KYH042OPOPUN
     C                   EVAL      UXH042OPAR  = KYH042OPOPAR
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UXH042
     C                   EVAL      EXUXDLIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXDLREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYH042
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UXH042)
     C                   EVAL      UXH042      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYH042OPFA  = UXH042OPFA
     C                   EVAL      KYH042OPKTO = UXH042OPKT
     C                   EVAL      KYH042OPOPNR= UXH042OPNR
     C                   EVAL      KYH042OPOPUN= UXH042OPNU
     C                   EVAL      KYH042OPOPAR= UXH042OPAR
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
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKC020          +19
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILER
     C     *LIKE         DEFINE    WKC001        WKAT01
     C     *LIKE         DEFINE    WKC001        WKAT02
     C     *LIKE         DEFINE    WKC001        WKAT03
     C     *LIKE         DEFINE    WKC001        WKROTF
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIWND
     C     *LIKE         DEFINE    WKC001        WKMCKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKBT24
     C     *LIKE         DEFINE    WKC001        WKTRPAKTAD
     C     *LIKE         DEFINE    WKC001        WKTRPAMAND      + 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPEN01
     C     *LIKE         DEFINE    WKC001        WKOPEN02
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKDATE          + 7
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIDEL
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        TXKEIN          +75
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        SI              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKISIC          + 1
     C     *LIKE         DEFINE    WKN010        WKBGJT          + 7
     C     *LIKE         DEFINE    WKN010        WKFLJT          + 7
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    PAGNBR        WKPAGE
     C     *LIKE         DEFINE    PAGNBR        W$PAGE
     C     *LIKE         DEFINE    RCDNBR        WKRENO
     C     *LIKE         DEFINE    RCDNBR        W$RCNO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C     *LIKE         DEFINE    KYH042        WKH042
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    OPKTO         UFH042KDNR
     C     *LIKE         DEFINE    OPKTO         OFH042KDNR
     C*
     C     *LIKE         DEFINE    OPFA          WKOPFA
     C     *LIKE         DEFINE    OPOPNR        WKOPNR
     C     *LIKE         DEFINE    OPSH          WKSHKZ
     C     *LIKE         DEFINE    OPPJ          WKPROJ
     C     *LIKE         DEFINE    OPWG          WKWAEH
     C     *LIKE         DEFINE    OPMNNR        WKMSTU
     C     *LIKE         DEFINE    OPUREU        WKSALDO
     C     *LIKE         DEFINE    OPUREU        WKSALDOFW
     C     *LIKE         DEFINE    OPUREU        WKSOLL
     C     *LIKE         DEFINE    OPUREU        WKHABEN
     C     *LIKE         DEFINE    BTBGT1        WKBGT1
     C     *LIKE         DEFINE    BTBGT2        WKBGT2
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTEXTTEXT    TXTEXTFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'
     C                   PARM                    WKFENR
     C                   PARM                    KEYVAR
     C                   PARM                    DSJNAM
     C                   PARM                    DSUSER
     C                   PARM                    W$PA03
     C                   PARM                    W$PA04
     C                   PARM                    W$PA05
     C                   PARM                    W$PA06
     C                   PARM                    W$PA07
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAW042'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTH042W1
     C                   OTHER
     C                   WRITE     HAW042CT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTH042W1
     C                   OTHER
     C                   WRITE     HAW042CT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *BLANK        W$PA08
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTLEN OP-SUMME                                                 ***
     C**************************************************************************
     C     ERMOPS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZEROS        DSH042OPFL
     C                   Z-ADD     *ZEROS        DSH042OPGE
     C                   Z-ADD     *ZEROS        WKH042OPFL       11 2
     C                   Z-ADD     *ZEROS        WKH042OPGE       11 2
     C*-------------------------------------------------------------------------
     C     KYFOPPK       KLIST
     C                   KFLD                    P0FA
     C                   KFLD                    P0KTO
     C*-------------------------------------------------------------------------
     C     KYFOPPK       SETLL     FOPPK91
     C*-------------------------------------------------------------------------
     C                   DO        *HIVAL
     C                   MOVE      *OFF          *IN94
     C                   READ      OPSATZ                                 94
     C*-------------------------------------------------------------------------
     C     *IN94         IFEQ      *ON
     C     OPFA          ORNE      P0FA
     C     OPKTO         ORNE      P0KTO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     OPOPST        IFEQ      '7'                                          ERLEDIGT RAUS
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     OPOPAR        IFNE      *BLANK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     OPURDM        ADD       OPDM          WKSALDO
     C     OPFLJT        IFLE      WKDATE
     C                   ADD       WKSALDO       WKH042OPFL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ADD       WKSALDO       WKH042OPGE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKH042OPFL    DIV(H)    1000          DSH042OPFL
     C     WKH042OPGE    DIV(H)    1000          DSH042OPGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMSETZEN IN NUMERISCHEN WERT                                      ***
     C**************************************************************************
     C     NUMUMS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CALL      'TRNUUM'
     C                   PARM                    EXNUUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHMSGF
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRSBFL
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
