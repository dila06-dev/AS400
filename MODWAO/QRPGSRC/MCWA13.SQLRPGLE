     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2003')
     H**************************************************************************
     H/TITLE MC-Routine für Datei WA13
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 19.01.2005
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei WA13.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KYWA13AFAT Kunden-Auftrags-Art
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMCWA13FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWA13R1:RCDNBR)
     F                                     SFILE(DLWA13R1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFLWA13         S                   LIKE(KYWA13) DIM(999) DESCEND
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
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ-
     D                                     [\]')
     D LO              C                   CONST('abcdefghijklmnopqrstuvwxyzäöü-
     D                                     {¦}')
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WA13          E DS
     D KYWA13        E DS                  INZ
     D UXWA13        E DS                  INZ
     D*
     D AFPA          E DS
     D KYAFPA        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
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
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
     D*
     D EXWA13        E DS                  INZ
     D RTWA13        E DS                  INZ
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
     C                   PARM                    WA13
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
     C                   EXSR      KEYWA13
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
     C                   OPEN      MCWA13FM
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
     C                   CLEAR                   WA13
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     MCWA13FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
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
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYWA13FIRM                     WA13
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'MCWA13'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         EXTEXTMSGA
     C                   MOVEL(P)  'KEIN'        EXTEXTMSGN
     C                   MOVE      'PRUEFE'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C*--------------------------------------------------------
     C                   MOVEL(P)  RTTEXTTEXT    TXKEIN
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVE      '01'          WKMCKZ
     C                   Z-ADD     *ZERO         WKPAGE
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWA13
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *OFF          WKIOKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MCWA13FM'    EXFLPOFMTN
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
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CMCFG        MCF
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'                                          auf reinen Anzeige-
     C                   MOVE      '5     '      WKPGST                         modus umschalten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSWA13AFAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0531'        #CUEBE
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
     C                   MOVE      *OFF          WKBT24
     C*-------------------------------------------------------------------------
     C                   MOVE      'M1'          WKIFMT
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
     C***  KEYBESTÜCKUNG WA13                                                ***
     C**************************************************************************
     C     KEYWA13       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWA13AFAT    KYWA13AFAT
     C                   MOVE      *LOVAL        UFWA13AFAT
     C                   MOVE      *HIVAL        OFWA13AFAT
     C                   EVAL      UFWA13AFAT = %TRIMR(KYWA13AFAT) + UFWA13AFAT
     C                   EVAL      OFWA13AFAT = %TRIMR(KYWA13AFAT) + OFWA13AFAT
     C*-------------------------------------------------------------------------
     C                   MOVE      'KY'          WKMCKZ
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
     C                   WRITE     MCWA1301
     C                   WRITE     MCWA13K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   SELECT
     C     WKPGST        WHENEQ    '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   WRITE     MCWA13B2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWA13B1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWA13B3
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      MCWA13K1                             9899
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
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   MOVEL(P)  DSWA13AFAT    KYWA13AFAT
     C                   EXSR      TRWA13
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DSWA13AFAT    KYWA13AFAT
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
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#MUST        WHENEQ    *ON
     C     FUKT20        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   MOVE      *BLANK        KYWA13AFAT
     C                   EXSR      TRWA13
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
     C                   MOVEL(P)  DSWA13AFAT    KYWA13AFAT
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
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
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
     C                   MOVEL     *OFF          WKUXMCOPEN
     C                   ENDIF
     C*
     C     WKUXMCOPEN    IFNE      *ON
     C                   EXSR      UXMCOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     MCWA13K1
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
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      WA13KY
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     B01SI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C*
     C     EXUXMCRTCD    DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      RCDNBR = EXUXRCNR
     C     RCDNBR        CHAIN     MCWA13R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK                                       GEÄNDERTE SÄTZE ALS
     C                   MOVE      *ON           C#NEXT                         GEÄNDERT MARKIERT
     C                   ELSE                                                   LASSEN
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    MCWA13R1
     C                   MOVE      *OFF          C#NEXT
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  KYWA13        WKWA13
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KYWA13
     C                   MOVEL(P)  DAFIRM        KYWA13FIRM
     C                   READC     MCWA13R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TRWA13                                       FORMAT SCHLIESSEN
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
     C                   UPDATE    MCWA13R1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KYWA13        SFLWA13(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWA13        KYWA13
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR SUBFILE                                         ***
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
     C                   READC     MCWA13R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
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
     C                   UPDATE    MCWA13R1
     C                   MOVE      *OFF          C#NEXT
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
     C*--------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   MOVEL(P)  KYWA13        WKWA13
     C                   MOVEL     C#MORE        WKIN91
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WKWA13        KYWA13
     C                   Z-ADD     W$RCNO        RCDNBR
     C                   MOVEL     WKIN91        C#MORE
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
     C                   EXSR      TRWA13
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
     C     PCPGST        WHENNE    *BLANK
     C                   EXSR      TRWA13
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MCWA13R1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    MCWA13R1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      '2     '      PCPGST
     C                   MOVEL     RTWA13AFAT    KYWA13AFAT
     C                   EXSR      TRWA13
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
     C     RCDNBR        CHAIN     MCWA13R1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWA13R1
     C                   MOVE      *OFF          C_AUSW
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG BILD01                                              ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA13
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      *ON           C#LCK1
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE LÖSCHANZEIGE                                        ***
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
     C                   WRITE     MCWA1301
     C                   WRITE     DLWA13K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     MCWA13DL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DLWA13K1                             9899
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
     C***  FÜLLEN LÖSCHANZEIGE                                               ***
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
     C                   MOVEL     *OFF          WKUXDLOPEN
     C                   ENDIF
     C*
     C     WKUXDLOPEN    IFNE      *ON
     C                   EXSR      UXDLOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     DLWA13K1
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
     C                   WRITE     DLWA13R1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MCWA13R1                               99
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
     C                   UPDATE    MCWA13R1
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
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     BDLSI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXDLIKEY = DUC004
     C                   EVAL      EXUX05PARM =  EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM =  EXUX05PARM
     C*
     C     EXUXDLRTCD    DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXSICHT = EXUXDLIDTA
     C                   EVAL      WKRCNO = EXUXRCNR
     C     WKRCNO        CHAIN     DLWA13R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C                   UPDATE    DLWA13R1
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXDLPARM =  EXUX05PARM
     C*-------------------------------------------------------------------------
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
     C                   WRITE     MCWA13W1
     C                   WRITE     MCWA13M1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W1WA13B1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MCWA13M1                             9899
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
     C                   EXSR      KEYWA13
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWA13
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         W$RCNO
     C                   MOVE      '01'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT M1                                        ***
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
     C                   MOVEL(P)  'DSWA13AFAT'  EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDM1                                          ***
     C**************************************************************************
     C     BM1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWA13AFAT
     C*
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
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWA13AFAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWA13AFAT'
     C                   EXSR      MCWA13AFAT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     MCWA13AFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWA13AFAT    KOM(1)
     C                   MOVEL     'AFPA01'      #CPGST
     C                   MOVE      '0526'        #CUEBE
     C                   EXSR      MCAFPA
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  AAAFAT        DSWA13AFAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     PRWA13AFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWA13AFAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWA13AFAT    IFNE      *BLANK
     C                   MOVEL(P)  DSWA13AFAT    KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C                   ENDIF
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
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      WA13KY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     MCWA13LO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE ÜBERSCHRIFT ERMITTELN                                   ***
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
     C     WKOPENKY      WHENEQ    *ON
     C                   EXSR      CCWA13KY
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
     C     WKMCKZ        WHENEQ    'KY'
     C     WKOPENKY      ANDNE     *ON
     C                   EXSR      OCWA13KY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WA13KY                                             ***
     C**************************************************************************
     C     OCWA13KY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WA13KY SCROLL CURSOR FOR SELECT * FROM WA13
     C+ WHERE WA13FIRM = :DAFIRM AND
     C+ WA13AFAT BETWEEN :UFWA13AFAT AND :OFWA13AFAT
     C+ ORDER BY WA13FIRM, WA13AFAT
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WA13KY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI WA13                                               ***
     C**************************************************************************
     C     WA13KY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     14            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C/EXEC SQL
     C+ FETCH CURRENT FROM WA13KY INTO :WA13
     C/END-EXEC
     C                   Z-ADD     WKRENO        RCDNBR                         ZURÜCKSCHR.
     C                   ELSE                                                   RCDNBR
     C/EXEC SQL
     C+ FETCH NEXT FROM WA13KY INTO :WA13
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE)
     C*--------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   MOVE      *ON           C#MORE                         SFLEND-KENNZ.
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C                   MOVEL(P)  WA13AFAT      KYWA13AFAT
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
     C                   WRITE     MCWA13R1
     C                   EXSR      UXMCWRTE
     C*
     C/EXEC SQL
     C+ FETCH NEXT FROM WA13KY INTO :WA13
     C/END-EXEC
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
     C***  CLOSE CURSOR DATEI WA13KY                                         ***
     C**************************************************************************
     C     CCWA13KY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WA13KY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN FÜR ANZEIGEN                                          ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WA13AFAT      KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
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
     C*
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
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON KONS MIT DER JEWEILIGEN SICHT                          ***
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
     C***  FÜLLEN VON AUSW BEIM NEUAUFBAU DER SUBFILE                        ***
     C**************************************************************************
     C     FAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYWA13        LOOKUP    SFLWA13(I1)                            99
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
     C***  LÖSCHEN VON AUSW NACH ERFOLGREICHER BEARBEITUNG                   ***
     C**************************************************************************
     C     LAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYWA13        LOOKUP    SFLWA13(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFLWA13(I1)
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
     C                   WRITE     MCWA13R1
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
     C***  UPDATE DATEI WA13                                                 ***
     C**************************************************************************
     C     TRWA13        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWA13
     C                   CLEAR                   RTWA13
     C                   MOVEL(P)  PCPGST        EXWA13PGST
     C                   MOVEL(P)  KYWA13AFAT    EXWA13AFAT
     C*
     C                   CALL      'TRWA13'
     C                   PARM                    EXWA13
     C                   PARM                    RTWA13
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTWA13PROG    WKPROG
     C                   MOVEL(P)  RTWA13DANA    WKDANA
     C                   MOVEL(P)  RTWA13FFLD    WKFFLD
     C                   MOVEL(P)  RTWA13FENR    WKFENR
     C                   MOVEL(P)  RTWA13PA03    W$PA03
     C                   MOVEL(P)  RTWA13PA04    W$PA04
     C                   MOVEL(P)  RTWA13PA05    W$PA05
     C                   MOVEL(P)  RTWA13PA06    W$PA06
     C                   MOVEL(P)  RTWA13PA07    W$PA07
     C*
     C                   MOVEL(P)  RTWA13RTCD    #CRTCD
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
     C                   CLEAR                   RTSBFL
     C                   MOVEL(P)  'MCWA13'      EXSBFLPROG
     C                   MOVEL(P)  'MCWA13FM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  'WA13'        EXSBFLFIL1
     C                   MOVEL(P)  WA13          EXSBFLDAT1
     C*
     C                   MOVEL(P)  'AFPA'        EXSBFLFIL2
     C                   MOVEL(P)  AFPA          EXSBFLDAT2
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
     C                   Z-ADD     FSI(SI)       WKISIC                         SICHT
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
     C                   MOVEL(P)  'MCWA13'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'MCWA13B1'    EXTRDNPGNA
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'MCWA13B2'    EXTRDNPGNA
     C                   ENDIF
     C*
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
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C*--------------------------------------------------------
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
     C                   EVAL      EXUXMCINAM = 'MCSBFWA13'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile MCWA13'
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
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUXRCNR     = RCDNBR
     C                   EVAL      UXWA13FIRM = KYWA13FIRM
     C                   EVAL      UXWA13AFAT = KYWA13AFAT
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXWA13
     C                   EVAL      EXUXMCIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
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
     C                   CLEAR                   KYWA13
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY = DUC004
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      DUN030=%LEN(UXWA13)
     C                   EVAL      UXWA13   = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYWA13FIRM = UXWA13FIRM
     C                   EVAL      KYWA13AFAT = UXWA13AFAT
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
     C                   EVAL      EXUXDLINAM = 'DLSBFWA13'
     C                   EVAL      EXUXDLILIB = 'QTEMP'
     C                   EVAL      EXUXDLIATR = 'TREND'
     C                   EVAL      EXUXDLDTLG = 4 + 996
     C                   EVAL      EXUXDLKYLG = 4
     C                   EVAL      EXUXDLITXT = 'Subfile DLWA13'
     C*
     C                   EVAL      EXUX05PARM =  EXUXDLPARM
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
     C                   EVAL      EXUXDLIKEY = DUC004
     C                   EVAL      EXUXRCNR   = WKRCNO
     C                   EVAL      UXWA13FIRM = KYWA13FIRM
     C                   EVAL      UXWA13AFAT = KYWA13AFAT
     C                   EVAL      EXUXDLIDTA = EXUXSICHT + UXWA13
     C                   EVAL      EXUXDLIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXDLPARM
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
     C                   CLEAR                   KYWA13
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY = DUC004
     C*
     C                   EVAL      EXUX05PARM =  EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM =  EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT= EXUXDLIDTA
     C                   EVAL      DUN030=%LEN(UXWA13)
     C                   EVAL      UXWA13   = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYWA13FIRM = UXWA13FIRM
     C                   EVAL      KYWA13AFAT = UXWA13AFAT
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILER
     C     *LIKE         DEFINE    WKC001        WKAT01
     C     *LIKE         DEFINE    WKC001        WKAT02
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIWND
     C     *LIKE         DEFINE    WKC001        WKMCKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKBT24
     C*
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPENKY
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
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
     C     *LIKE         DEFINE    WKN010        WKISIC           +1
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
     C     *LIKE         DEFINE    C#MORE        WKIN91
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KYWA13        WKWA13
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KYWA13AFAT    OGWA13AFAT
     C     *LIKE         DEFINE    KYWA13AFAT    UFWA13AFAT
     C     *LIKE         DEFINE    KYWA13AFAT    OFWA13AFAT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWA13PROG    WKPROG
     C     *LIKE         DEFINE    RTWA13DANA    WKDANA
     C     *LIKE         DEFINE    RTWA13FFLD    WKFFLD
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
     C                   MOVEL(P)  'MCWA13'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWA13W1
     C                   OTHER
     C                   WRITE     MCWA13CT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWA13W1
     C                   OTHER
     C                   WRITE     MCWA13CT
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
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHWA13
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,MCAFPA
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,TRSBFL
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
