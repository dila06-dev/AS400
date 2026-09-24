     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei KVAE
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: HR 08.02.2004 für Kunde Busch Projekt 2612
     H*  -----------------------------------------------------------------------
     H*  Änderung: MB Datum      Referenz
     H*  Änderung: X2 23.07.2004 Anpassung trend-Java-Client
     H*  Änderung: HR 11.08.2004 Standard Projekt 2612 Rückgabe FehlerNr./Fehlerfeld
     H*            im LDA für Aufruf extern
     H*  Änderung: PH 22.05.2006 Folgende TRPA-Parameter wurden geändert:
     H*            FIRM/TRKA01/KAAT --> T1KVKK/DEFAULT/KAAT
     H*            FIRM/TRKA01/RSBE --> T1KVKK/DEFAULT/RSBE
     H*            FIRM/TRKA01/PBEK --> T1KVKK/DEFAULT/PBEK
     H*            FIRM/TRKA01/PBEF --> T1KVKK/DEFAULT/PBEF
     H*  Änderung: WM 08.12.2006 Projekt 3301  Ersetzen MCSLSS durch MCPAPA
     H*  Änderung: PH 14.12.2006 Neue Felder im LDA-Bereich für die Üvbergabe
     H*            an TRKA02 integriert
     H*  Änderung: HR 20.01.2011 SERVICE 20120120-001 Initalisierung Gültig ab-Datum
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei KVAE.
     F*
      **************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRKVAEFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KVAE          E DS                  INZ
     D KYKVAE        E DS                  INZ
     D*
     D KVKK          E DS                  INZ
     D KYKVKK        E DS                  INZ
     D*
     D KVKS          E DS                  INZ
     D KYKVKS        E DS                  INZ
     D*
     D PAPA          E DS                  INZ
     D KYPAPA        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D SLAZ          E DS                  INZ
     D*
     D SLKO          E DS                  INZ
     D KYSLKO        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXKVAE        E DS
     D RTKVAE        E DS
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D  DARI01               210    220  2
     D  DARI02               221    231  2
     D  DARI03               232    242  2
     D  DARI04               243    253  2
     D  DARI05               254    264  2
     D  DARI06               265    275  2
     D  DARI07               276    286  2
     D  DARI08               287    297  2
     D  DARI09               298    308  2
     D  DARI10               309    319  2
     D*
     D  DAKLCD               320    323
     D  DAMV01               324    333
     D  DAMV02               334    343
     D  DAMV03               344    353
     D  DAMV04               354    363
     D  DAMV05               364    373
     D  DAMV06               374    383
     D  DAMV07               384    393
     D  DAMV08               394    403
     D  DAMV09               404    413
     D  DAMV10               414    423
     D*
     D  DAMB01               434    443
     D  DAMB02               444    453
     D  DAMB03               454    463
     D  DAMB04               464    473
     D  DAMB05               474    483
     D  DAMB06               484    493
     D  DAMB07               494    503
     D  DAMB08               504    513
     D  DAMB09               514    523
     D  DAMB10               524    533
     D*
     D  DAGEBI               534    548
     D  DAGBMG               549    559  2
     D  DASTUZ               560    565  0
     D  DAKDNR               566    575
     D*
     D  DADA01               576    586  3
     D  DADA02               587    597  3
     D  DADA03               598    608  3
     D  DADA04               609    619  3
     D  DADA05               620    630  3
     D  DADA06               631    641  3
     D  DADA07               642    652  3
     D  DADA08               653    663  3
     D  DADA09               664    674  3
     D*
     D  DATXT1               675    734
     D  DATXT2               735    794
     D*
     D  DADRBR               795    798  0
     D  DALFBR               799    802  0
     D*
     D  DAHPGR               803    822
     D  DAVETE               823    838
     D*
     D  DAWZFEWEZG           839    853
     D  DAWZFEFORM           854    868
     D  DAWZFEHPOS           869    873  0
     D  DAWZFEUPOS           874    878  0
     D*
     D  DAFENR               879    882
     D  DAFFLD               883    892
     D*
     D  DASTDA               893    900  0
     D*
     D  DAVSNR               901    903
     D  DAPRDA               904    911  0
     D*
     D  DAGBME               912    912
     D  DALIBD               913    915
     D  DAZABD               916    918
     D  DAAFJJ               919    922  0
     D  DAAFNR               923    928
     D  DAGADA               929    936  0
     D  DADBKZ               937    937
     D  DADBWT               938    948  2
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
     C     *ENTRY        PLIST
     C                   PARM                    EXKVAE
     C                   PARM                    RTKVAE
     C*
     C                   EXSR      UEBKVAE
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
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '
     C*
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRKVAEFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PKVAE '
     C                   EXSR      PKVAE
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PKVAE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LKVAE
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GNKVAE'
     C                   EXSR      GNKVAE
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     DATEST        WHENEQ    '5'
     C                   MOVE      '5     '      PCPGST
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRKVAEFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C     PCPGST        OREQ      'MUSTER'
     C                   CLOSE     TRKVAEFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTKVAERTCD
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
     C                   Z-ADD     *ZERO         WKN219           21 9
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKVAEFIRM                     KVAE
     C                   MOVEL(P)  DAFIRM        KYVKFI                         KVKK
     C                   MOVEL     DAFIRM        KYVSFI                         KVKS
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYSKFI                         SLKO
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYPAFI                         PAPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'TRKVAE'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C*                  MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKVAEFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRKVAEFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXKVAE                         ***
     C**************************************************************************
     C     UEBKVAE       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXKVAEPGST    PCPGST
     C*
     C                   MOVEL     EXKVAETSTP    KYKVAETSTP
     C                   MOVEL(P)  EXKVAEVEUR    KYKVAEVEUR
     C*
     C                   MOVEL(P)  EXKVAEVEUR    DSKVAEVEUR
     C*
     C                   MOVEL     EXKVAENTST    DSKVAENTST
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTKVAE
     C                   MOVEL     *ZERO         RTKVAEFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
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
     C                   EXSR      EFLPO
     C                   WRITE     TRKVAEW3
     C                   WRITE     TRKVAE01
     C                   WRITE     W3KVAEB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C**                 MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRKVAE01                             9899
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
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#ACCS        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
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
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UKVAE
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C                   MOVE      *LOVAL        KYKVAETSTP
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKVAE
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHKVAE
     C                   ENDSL
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
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C                   CLEAR                   KVAE
     C                   CALL      'EXTSTP'
     C                   PARM                    KYKVAETSTP
     C                   MOVEL     KYKVAETSTP    KVAETSTP
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVAE
     C                   MOVEL(P)  KVAEUSER      WKUSER
     C                   Z-ADD     KVAEJDAT      WKJDAT
     C                   Z-ADD     KVAEJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHKVAE
     C                   EXSR      EKVAE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KVAETSTP      DSKVAETSTP
     C                   MOVEL(P)  KVAEVEUR      DSKVAEVEUR
     C                   MOVEL(P)  KVAETENR      DSKVAETENR
     C                   MOVEL(P)  KVAESLAT      DSKVAESLAT
     C                   MOVEL(P)  KVAEAPAT      DSKVAEAPAT
     C                   MOVEL(P)  KVAEVARK      DSKVAEVARK
     C                   Z-ADD     KVAEKAJJ      DSKVAEKAJJ
     C                   MOVEL(P)  KVAEKANR      DSKVAEKANR
     C                   MOVEL(P)  KVAEPDAV      DSKVAEPDAV
     C                   Z-ADD     KVAESTPR      DSKVAESTPR
     C                   Z-ADD     KVAEVKSK      DSKVAEVKSK
     C                   MOVEL(P)  KVAESTAT      DSKVAESTAT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     KVAEKADA      EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSKVAEKADA
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXKVAEVEUR                     INITIALISIEREN
     C*-------------------------------------------------------------------------
     C     DSKVAEVEUR    CASNE     *BLANK        PRKVAEVEUR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKVAETENR    CASNE     *BLANK        PRKVAETENR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKVAESLAT    CASNE     *BLANK        PRKVAESLAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKVAEAPAT    CASNE     *BLANK        PRKVAEAPAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKVAEPDAV    CASNE     *BLANK        PRKVAEPDAV                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKVAESTAT    CASNE     *BLANK        PRKVAESTAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKVAE01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C     PCRTCD        IFEQ      'W'
     C                   MOVE      '0070'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSKVAEKANR'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSKVAEVEUR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSKVAEKANR'  EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     PCPGST        ANDNE     *BLANK
     C     PCPGST        ANDNE     'MUSTER'
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKJDAT        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   EVAL      W$PA03 = %TRIM(%EDITW(RTDATEDATE :
     C                              '0 .  .    '))
     C                   MOVEL(P)  WKUSER        W$PA04
     C                   EVAL      W$PA05 = %TRIM(%EDITW(WKJZEI : '0 :  :  '))
     C                   MOVE      '0076'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAEVEUR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAETENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFEQ      *BLANK
     C*--------------------------------------------------------
     C                   MOVEL     DSKVAETSTP    KYKVAETSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVAE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSKVAETSTP'  EXFLPOFLDN
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAESLAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAEAPAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAEKADA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAEPDAV
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKVAESTAT
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
     C***  STEUERROUTINE BILDK1                                              ***
     C**************************************************************************
     C     BILDK1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BK1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'K1'
     C                   EXSR      EFLPO
     C                   WRITE     TRKVAEW2
     C                   WRITE     TRKVAEK1
     C                   WRITE     W2KVAEB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRKVAEK1                             9899
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
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
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
     C                   EXSR      BK1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KKVAE
     C                   EXSR      UKVAE
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL     KYKVAETSTP    RTKVAETSTP
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTKVAERTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT K1                                        ***
     C**************************************************************************
     C     BK1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYKVAETSTP    DSKVAETSTP
     C*
     C                   MOVE      *LOVAL        DSKVAENTST
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAENYYY'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDK1                                          ***
     C**************************************************************************
     C     BK1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C**                 EXSR      PRKVAENTST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKVAENTST    KYKVAETSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVAE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSKVAENYYY'  EXFLPOFLDN
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSKVAEVEUR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSKVAEVEUR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAEVEUR'
     C                   EXSR      MCKVAEVEUR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAETENR'
     C                   EXSR      MCKVAETENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAESLAT'
     C                   EXSR      MCKVAESLAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAEAPAT'
     C                   EXSR      MCKVAEAPAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAEKANR'
     C**                 EXSR      MCKVAEKANR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAEKADA'
     C                   EXSR      MCKVAEKADA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAEPDAV'
     C                   EXSR      MCKVAEPDAV
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKVAESTAT'
     C                   EXSR      MCKVAESTAT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRMU                                                 ***
     C**************************************************************************
     C     UTRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KVAE'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         KVAEFREI
     C*
     C                   MOVEL(P)  KVAE          TRMUDATA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TRMUJNAM
     C                   MOVEL(P)  WKCHPN        TRMUPROG
     C                   MOVEL(P)  WKCHPL        TRMUBIBL
     C                   MOVEL(P)  WKUSER        TRMUUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TRMUJZEI
     C                   MOVE      WKTDAT        TRMUJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'W'           #CRTCD
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'U'           #CRTCD
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOPIEREN SÄTZE AUS DATEI KVAE                                     ***
     C**************************************************************************
     C     KKVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKVAETSTP    KYKVAETSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVAE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  KVAEVEUR      DSKVAEVEUR
     C                   Z-ADD     KVAEKAJJ      DSKVAEKAJJ
     C                   MOVEL(P)  KVAEKANR      DSKVAEKANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB KVAE-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PKVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYKVAETSTP    OFKVAETSTP
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKVAE
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     KVAEFIRM      ANDEQ     KYKVAEFIRM
     C     KVAETSTP      ANDLE     OFKVAETSTP
     C*--------------------------------------------------------
     C     KVAELOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'KVAELOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHKVAE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTKVAE
     C                   MOVEL(P)  WKPROG        RTKVAEPROG
     C                   MOVEL(P)  WKDANA        RTKVAEDANA
     C                   MOVEL(P)  WKFFLD        RTKVAEFFLD
     C                   MOVEL(P)  WKFENR        RTKVAEFENR
     C                   MOVEL(P)  W$PA03        RTKVAEPA03
     C                   MOVEL(P)  W$PA04        RTKVAEPA04
     C                   MOVEL(P)  W$PA05        RTKVAEPA05
     C                   MOVEL(P)  W$PA06        RTKVAEPA06
     C                   MOVEL(P)  W$PA07        RTKVAEPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI KVAE                                          ***
     C**************************************************************************
     C     LKVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYKVAETSTP    OFKVAETSTP
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKVAE
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     KVAEFIRM      ANDEQ     KYKVAEFIRM
     C     KVAETSTP      ANDLE     OFKVAETSTP
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL     KVAETSTP      KYKVAETSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVAE
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHKVAE
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHKVAE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTKVAE
     C                   MOVEL(P)  WKPROG        RTKVAEPROG
     C                   MOVEL(P)  WKDANA        RTKVAEDANA
     C                   MOVEL(P)  WKFFLD        RTKVAEFFLD
     C                   MOVEL(P)  WKFENR        RTKVAEFENR
     C                   MOVEL(P)  W$PA03        RTKVAEPA03
     C                   MOVEL(P)  W$PA04        RTKVAEPA04
     C                   MOVEL(P)  W$PA05        RTKVAEPA05
     C                   MOVEL(P)  W$PA06        RTKVAEPA06
     C                   MOVEL(P)  W$PA07        RTKVAEPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN DER ABHÄNGIG. SÄTZE                                       ***
     C**************************************************************************
     C     LPOSI         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KVAE                                                 ***
     C**************************************************************************
     C     UKVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKVAETSTP    KYKVAETSTP
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE      DSKVAENTST    KYKVAETSTP
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVAE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSKVAEVEUR    KVAEVEUR
     C                   MOVEL(P)  DSKVAETENR    KVAETENR
     C                   MOVEL(P)  DSKVAESLAT    KVAESLAT
     C                   MOVEL(P)  DSKVAEAPAT    KVAEAPAT
     C                   MOVEL(P)  DSKVAEVARK    KVAEVARK
     C                   Z-ADD     DSKVAEKAJJ    KVAEKAJJ
     C                   MOVEL(P)  DSKVAEKANR    KVAEKANR
     C                   MOVEL(P)  DSKVAEPDAV    KVAEPDAV
     C                   Z-ADD     DSKVAESTPR    KVAESTPR
     C                   Z-ADD     DSKVAEVKSK    KVAEVKSK
     C                   MOVEL(P)  DSKVAESTAT    KVAESTAT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSKVAEKADA    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    KVAEKADA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KVAEJNAM
     C                   MOVEL(P)  WKCHPN        KVAEPROG
     C                   MOVEL(P)  WKCHPL        KVAEBIBL
     C                   MOVEL(P)  DAUSER        KVAEUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KVAEJZEI
     C                   MOVE      WKTDAT        KVAEJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKVAE
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHKVAE
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVAE
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     MCKVAEVEUR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAEVEUR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVEA(P)  DSKVAEVEUR    KOM(01)
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTEIL
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSKVAEVEUR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     PRKVAEVEUR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAEVEUR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSKVAEVEUR    IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   ELSE
     C*
     C                   MOVEL(P)  DSKVAEVEUR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSKVAEVEUR
     C                   MOVEL(P)  TETBZ1        TXKVAEVEUR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     MCKVAETENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAETENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVEA(P)  DSKVAETENR    KOM(01)
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTEIL
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSKVAETENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRKVAETENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAETENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSKVAETENR    IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   ELSE
     C*
     C                   MOVEL(P)  DSKVAETENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSKVAETENR
     C                   MOVEL(P)  TETBZ1        TXKVAETENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE SLAT                                                   ***
     C**************************************************************************
     C     MCKVAESLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAESLAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  DSKVAESLAT    KOM(01)
     C                   MOVE      'DETAIL'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCPAPA
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  PAAPAT        DSKVAESLAT
     C                   MOVEL     PAABEZ        TXKVAESLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SLAT                                                   ***
     C**************************************************************************
     C     PRKVAESLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAESLAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSKVAESLAT    IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   ELSE
     C*
     C                   MOVEL(P)  DSKVAESLAT    KYPAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAPA                                       VORHANDEN
     C                   MOVEL(P)  PAABEZ        TXKVAESLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE APAT                                                   ***
     C**************************************************************************
     C     MCKVAEAPAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAEAPAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      'DETAIL'      #CPGST
     C                   MOVEA(P)  DSKVAEAPAT    KOM(01)
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCPAPA
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  PAAPAT        DSKVAEAPAT
     C                   MOVEL     PAABEZ        TXKVAEAPAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE APAT                                                   ***
     C**************************************************************************
     C     PRKVAEAPAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAEAPAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSKVAEAPAT    IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   ELSE
     C*
     C                   MOVEL(P)  DSKVAEAPAT    KYPAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAPA                                       VORHANDEN
     C                   MOVEL(P)  PAABEZ        TXKVAEAPAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KADA                                                   ***
     C**************************************************************************
     C     MCKVAEKADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAEKADA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSKVAEKADA    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSKVAEKADA    IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSKVAEKADA
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     PRKVAEKADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAEKADA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSKVAEKADA    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSKVAEKADA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PDAV                                                   ***
     C**************************************************************************
     C     MCKVAEPDAV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAEPDAV'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSKVAEPDAV    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKVAEPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSKVAEPDAV    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKVAEPDAV
     C                   MOVEL(P)  TPTTXT        TXKVAEPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PDAV                                                   ***
     C**************************************************************************
     C     PRKVAEPDAV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAEPDAV'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSKVAEPDAV    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKVAEPDAV
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE STAT                                                   ***
     C**************************************************************************
     C     MCKVAESTAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKVAESTAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSKVAESTAT    EXTRPCCODE
     C                   MOVEL(P)  'STATKVAE'    EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKVAESTAT
     C                   MOVEL(P)  EXTRPCTEXT    TXKVAESTAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN DSKVAESTAT                                                 ***
     C**************************************************************************
     C     PRKVAESTAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSKVAESTAT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXKVAESTAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSKVAESTAT    EXTRPCCODE                     JNKZ
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATKVAE'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKVAESTAT
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
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDAV'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KVAE'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      KVAE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN KVAE UND AUSFÜHREN DER VORKALKULATION                  ***
     C**************************************************************************
     C     GNKVAE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXKVAEVEUR    KYTENR                         TEIL
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXKVAESLAT    KYSKAT
     C                   MOVEL     EXKVAEVARK    KYSKVA                         ZUGRIFF
     C                   MOVEL     EXKVAEVEUR    KYSKTE                         STÜCKLISTEN-
     C                   MOVEA     '01C     '    CHI                            KOPF
     C                   EXSR      CHSLKO
     C*
     C     WKFENR        IFNE      *ZERO
     C     SKSLST        ORGE      '80'
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'EXTSTP'
     C                   PARM                    DSKVAETSTP
     C                   MOVEL(P)  EXKVAEVEUR    DSKVAEVEUR
     C                   MOVEL(P)  EXKVAETENR    DSKVAETENR
     C                   MOVEL(P)  EXKVAESLAT    DSKVAESLAT
     C                   MOVEL(P)  EXKVAEAPAT    DSKVAEAPAT
     C                   MOVEL(P)  EXKVAEVARK    DSKVAEVARK
     C                   Z-ADD     EXKVAEKADA    EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSKVAEKADA
     C                   Z-ADD     TESTPR        DSKVAESTPR
     C                   Z-ADD     *ZERO         DSKVAEVKSK
     C                   MOVEL(P)  TEPDAV        DSKVAEPDAV
     C                   MOVEL(P)  '01'          DSKVAESTAT
     C                   EXSR      UKVAE
     C*-------------------------------------------------------------------------
     C                   EXSR      TRKA02
     C                   EXSR      ERKVKK
     C                   EXSR      U1KVAE
     C*-------------------------------------------------------------------------
     C                   EXSR      EXSLAZ                                       ERM.VERWENDUNG
     C                   EXSR      OSLAZ                                        ÖFFNEN DISX
     C                   EXSR      VSLAZ                                        VERARBEITEN
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORKALKULATION                                                    ***
     C**************************************************************************
     C     TRKA02        BEGSR
     C*
     C                   Z-ADD     *ZERO         WKKAJJ                         KALK.JAHR
     C                   MOVE      *BLANK        WKKANR                         KALK.NUMMER
     C                   MOVE      *ZERO         WKKVAEFENR
     C                   MOVE      *BLANK        WKKVAEFFLD
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C*--------------------------------------------------------
     C                   MOVE      WKKAJJ        DUN040                         KALK-JAHR
     C                   MOVEA     DUC004        KOM(1)
     C                   MOVEA     WKKANR        KOM(5)                         KALK-NUMMER
     C                   MOVEA     WKTRPAKAAT    KOM(11)                        KALK-ART
     C*--------------------------------------------------------
     C                   MOVE      EXKVAEKADA    DUN080
     C                   MOVEA     DUC008        KOM(14)
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        KOM(22)
     C                   Z-ADD     SKBAMG        DUN112                         KALK.MENGE
     C                   MOVEA     DUC011        KOM(37)
     C                   MOVEA     EXKVAESLAT    KOM(48)
     C                   MOVEA     *BLANK        KOM(51)
     C                   MOVEA     EXKVAEAPAT    KOM(54)
     C                   MOVEA     *BLANK        KOM(57)
     C                   MOVEA     WKTRPAPBEK    KOM(60)
     C                   MOVEA     WKTRPAPBEF    KOM(63)
     C                   MOVEA     SKTENR        KOM(105)
     C*--------------------------------------------------------
     C                   SELECT
     C     MODBUS        WHENEQ    *ON
     C     TEWKNR        ANDEQ     '001'
     C                   MOVEA     '100'         KOM(195)
     C     MODBUS        WHENEQ    *ON
     C     TEWKNR        ANDEQ     '002'
     C                   MOVEA     '200'         KOM(195)
     C                   OTHER
     C                   MOVEA     WKTRPARSBE    KOM(195)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        KOM(208)
     C*--------------------------------------------------------
     C                   MOVEA     KOM           WKKOMM
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DARI01                         LDA- INITIALISIEREN
     C                   Z-ADD     *ZERO         DARI02
     C                   Z-ADD     *ZERO         DARI03
     C                   Z-ADD     *ZERO         DARI04
     C                   Z-ADD     *ZERO         DARI05
     C                   Z-ADD     *ZERO         DARI06
     C                   Z-ADD     *ZERO         DARI07
     C                   Z-ADD     *ZERO         DARI08
     C                   Z-ADD     *ZERO         DARI09
     C                   Z-ADD     *ZERO         DARI10
     C*
     C                   MOVEL     *BLANK        DAKLCD
     C                   MOVEL     *BLANK        DAGEBI
     C                   Z-ADD     *ZERO         DAGBMG
     C*
     C                   Z-ADD     *ZERO         DADA01
     C                   Z-ADD     *ZERO         DADA02
     C                   Z-ADD     *ZERO         DADA03
     C                   Z-ADD     *ZERO         DADA04
     C                   Z-ADD     *ZERO         DADA05
     C                   Z-ADD     *ZERO         DADA06
     C                   Z-ADD     *ZERO         DADA07
     C                   Z-ADD     *ZERO         DADA08
     C                   Z-ADD     *ZERO         DADA09
     C**                 MOVE      KPKVKDNR      DAKDNR                         KUNDE
     C                   MOVEL     *BLANK        DATXT1
     C                   MOVEL     *BLANK        DATXT2
     C                   Z-ADD     *ZERO         DADRBR
     C                   Z-ADD     *ZERO         DALFBR
     C                   MOVEL     *BLANK        DAHPGR
     C                   MOVEL     *BLANK        DAVETE
     C*
     C                   MOVEL     *BLANK        DAWZFEWEZG
     C                   MOVEL     *BLANK        DAWZFEFORM
     C                   Z-ADD     *ZERO         DAWZFEHPOS
     C                   Z-ADD     *ZERO         DAWZFEUPOS
     C*
     C                   MOVEL     *BLANK        DAFENR
     C                   MOVEL     *BLANK        DAFFLD
     C*
     C                   Z-ADD     *ZERO         DASTDA
     C                   Z-ADD     *ZERO         DAGADA
     C*
     C                   MOVEL     *BLANK        DAVSNR
     C                   Z-ADD     *ZERO         DAPRDA
     C*
     C                   MOVEL     *BLANK        DAGBME
     C                   MOVEL     *BLANK        DALIBD
     C                   MOVEL     *BLANK        DAZABD
     C                   Z-ADD     *ZERO         DAAFJJ
     C                   MOVEL     *BLANK        DAAFNR
     C*--------------------------------------------------------
     C                   OUT       EXTRLD
     C*-------------------------------------------------------------------------
     C                   CALL      'TRKA02'                             99      VORKALKULATION
     C                   PARM                    WKKOMM          220
     C*-------------------------------------------------------------------------
     C                   IN        EXTRLD
     C*--------------------------------------------------------
     C     DAFENR        IFNE      *ZERO
     C     DAFENR        ANDNE     *BLANK
     C                   MOVE      DAFENR        WKKVAEFENR
     C                   MOVEL(P)  DAFFLD        WKKVAEFFLD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     WKKOMM        KOM
     C*--------------------------------------------------------
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        WKKAJJ                         KALK.JAHR
     C                   MOVEA     KOM(5)        WKKANR                         KALK.NUMMER
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN STÜCKLISTENVERWENDUNG                                   ***
     C**************************************************************************
     C     EXSLAZ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXKVAESLAT    EXSLAZSLAT
     C                   MOVEL(P)  EXKVAETENR    EXSLAZTENR
     C                   MOVEL(P)  'SV'          EXSLAZAZAR
     C                   MOVEL(P)  EXKVAEVARK    EXSLAZVARK
     C                   MOVE      DAJNUM        EXSLAZJNUM
     C                   Z-ADD     SKBAMG        EXSLAZMENG
     C                   MOVEL(P)  EXKVAEKADA    EXSLAZBETE
     C                   MOVEL(P)  *ZERO         EXSLAZGADA
     C                   MOVEL(P)  *BLANK        EXSLAZPEAR
     C                   MOVEL     *BLANK        DAFEHL
     C                   OUT       EXTRLD
     C                   CALL      'EXSLAZC1'
     C                   IN        EXTRLD
     C*
     C                   CALL      'EXSLAZ'
     C                   PARM                    EXSLAZSLAT
     C                   PARM                    EXSLAZTENR
     C                   PARM                    EXSLAZAZAR
     C                   PARM                    EXSLAZJNUM
     C                   PARM                    EXSLAZVARK
     C                   PARM                    EXSLAZMENG
     C                   PARM                    EXSLAZBETE
     C                   PARM                    EXSLAZGADA
     C                   PARM                    EXSLAZPEAR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERÖFFNEN CUSOR                                                    ***
     C**************************************************************************
     C     OSLAZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  DECLARE SLAZC1 CURSOR FOR
     C+    SELECT * FROM SLAZ
     C+    ORDER BY SLAZFIRM, SLAZTENR
     C+    FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  OPEN SLAZC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN STÜCKLISTENVERWENDUNG                                 ***
     C**************************************************************************
     C     VSLAZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         FETCH SLAZC1 INTO :SLAZ
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*--------------------------------------------------------
     C                   MOVEL     SLAZSLAT      KYSKAT
     C                   MOVEL     SLAZVARK      KYSKVA                         ZUGRIFF
     C                   MOVEL     SLAZTENR      KYSKTE                         STÜCKLISTEN-
     C                   MOVEA     '01C     '    CHI                            KOPF
     C                   EXSR      CHSLKO
     C     WKFENR        IFNE      *ZERO
     C     SKSLST        ORGE      '80'
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL     SLAZTENR      KYTENR                         TEIL
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C
     C                   CALL      'EXTSTP'
     C                   PARM                    DSKVAETSTP
     C                   MOVEL(P)  SLAZTENR      DSKVAEVEUR
     C                   MOVEL(P)  EXKVAEVEUR    DSKVAETENR
     C                   MOVEL(P)  SLAZSLAT      DSKVAESLAT
     C                   MOVEL(P)  EXKVAEAPAT    DSKVAEAPAT
     C                   MOVEL(P)  SLAZVARK      DSKVAEVARK
     C                   Z-ADD     EXKVAEKADA    EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSKVAEKADA
     C                   Z-ADD     TESTPR        DSKVAESTPR
     C                   Z-ADD     *ZERO         DSKVAEVKSK
     C                   MOVEL(P)  TEPDAV        DSKVAEPDAV
     C                   MOVEL(P)  '01'          DSKVAESTAT
     C                   EXSR      UKVAE
     C                   EXSR      TRKA02
     C                   EXSR      ERKVKK
     C                   EXSR      U1KVAE
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         CLOSE SLAZC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE KVAE                                                       ***
     C**************************************************************************
     C     U1KVAE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKVAETSTP    KYKVAETSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVAE
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C*--------------------------------------------------------
     C                   Z-ADD     WKKAJJ        KVAEKAJJ
     C                   MOVEL(P)  WKKANR        KVAEKANR
     C                   MOVEL(P)  WKKVAEFENR    KVAEFENR
     C                   MOVEL(P)  WKKVAEFFLD    KVAEFFLD
     C                   Z-ADD     DSKVAEVKSK    KVAEVKSK
     C                   MOVEL(P)  '90'          KVAESTAT
     C*--------------------------------------------------------
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKVAE
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KALK-SELBSTKOSTEN                                       ***
     C**************************************************************************
     C     ERKVKK        BEGSR
     C*
     C                   Z-ADD     *ZERO         DSKVAEVKSK
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     WKKANR        IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKKAJJ        KYVKJJ
     C                   MOVEL     WKKANR        KYVKNR
     C                   MOVEL     DSKVAEVEUR    KYVKVU
     C                   MOVEL     DSKVAEVEUR    KYVKTE
     C                   MOVEL     *ZERO         KYVKSX
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVKK
     C*-------------------------------------------------------------------------
     C     WKTRPABWBA    IFNE      '90    '                                     BEWERT-HK
     C                   MOVE      VKKAJJ        KYVSJJ                         AUFBAUEN
     C                   MOVE      VKKANR        KYVSNR                         SCHLÜSSEL
     C                   MOVE      VKVEUR        KYVSVU
     C                   MOVE      WKTRPABWBA    KYVSUF
     C                   MOVE      *LOVAL        KYVSRF
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKVKS
     C*
     C     CHI(5)        IFEQ      'J'
     C     VSFIRM        ANDEQ     KYVSFI
     C     VSKAJJ        ANDEQ     KYVSJJ
     C     VSKANR        ANDEQ     KYVSNR
     C     VSVEUR        ANDEQ     KYVSVU
     C     VSUFLD        ANDEQ     KYVSUF
     C                   Z-ADD     VSRAWT        DSKVAEVKSK
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSKVAEVKSK    IFEQ      *ZERO                                        BEW-HK-PREIS
     C     VKSBWP        ADD       VKSKMA        DSKVAEVKSK
     C                   ADD       VKLOKO        DSKVAEVKSK
     C                   ADD       VKSKFE        DSKVAEVKSK
     C                   ADD       VKFRKO        DSKVAEVKSK
     C                   ADD       VKBZST        DSKVAEVKSK
     C                   ADD       VKLZST        DSKVAEVKSK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'PDIM'        KYTPTA                         BERECHNEN
     C                   MOVEL     DSKVAEPDAV    KYTPTC                         PREISDIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   END
     C*-------------------------------------------------------------------------
     C     VKBAMG        IFGT      *ZERO
     C     DSKVAEVKSK    DIV       VKBAMG        WKN219
     C     WKN219        MULT      TPTNUM        DSKVAEVKSK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EKVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**   KVAEJNKZ      IFEQ      *BLANK
     C**                 MOVEL     DAJNKZ        KVAEJNKZ
     C**                 ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TRKVAE'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T1KVKK'      KYTATA                         VORBELEGUNG
     C                   MOVEL(P)  'DEFAULT'     KYTATC                         KALK-ART
     C                   MOVEL(P)  'KAAT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPAKAAT
     C*--------------------------------------------------------
     C                   MOVEL(P)  'T1KVKK'      KYTATA                         VORBELEGUNG
     C                   MOVEL(P)  'DEFAULT'     KYTATC                         RECHENSCHEMA
     C                   MOVEL(P)  'RSBE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPARSBE
     C*--------------------------------------------------------
     C                   MOVEL(P)  'T1KVKK'      KYTATA                         VORBELEGUNG
     C                   MOVEL(P)  'DEFAULT'     KYTATC                         PREIBASIS
     C                   MOVEL(P)  'PBEK'        KYTAPA                         EINKAUFSTEILE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPAPBEK
     C*--------------------------------------------------------
     C                   MOVEL(P)  'T1KVKK'      KYTATA                         VORBELEGUNG
     C                   MOVEL(P)  'DEFAULT'     KYTATC                         PREIBASIS
     C                   MOVEL(P)  'PBEF'        KYTAPA                         EIGENFERTIGUNG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPAPBEF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA
     C                   MOVEL     'MODBUS'      KYTATC
     C                   MOVEL     'MODBUS'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODBUS
     C*
     C     MODBUS        IFNE      *ON
     C                   MOVE      *OFF          MODBUS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'MCKVKK'      KYTATC                         PREISBASIS
     C                   MOVEL     'BWBA'        KYTAPA                         FÜR ANZEIGE
     C                   MOVEA     '01C     '    CHI                            BEWERT-HK
     C*
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPABWBA
     C*
     C     WKTRPABWBA    IFEQ      *BLANK
     C                   MOVE      '90    '      WKTRPABWBA
     C                   END
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFE                                                          ***
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
     C                   MOVEL(P)  WKPGST        EXTRDNPGST
     C                   MOVEL(P)  'TRKVAE'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C                   MOVEL(P)  'TRKVAEB1'    EXTRDNPGNA
     C*
     C                   MOVE      C#FUKT        EXTRDNFUKT                     F-TASTEN
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
     C                   WRITE     TRKVAEW3
     C                   WRITE     TRKVAE01
     C                   WRITE     W3KVAEB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
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
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     EXTRDNPGST    IFEQ      'DIREKT'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     EXTRDNPGST    IFEQ      'WEITER'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#ACCS        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        #CRTCD
     C                   ENDDO
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
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTRPAKAAT      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPARSBE      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAPBEF      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAPBEK      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPABWBA      + 5
     C     *LIKE         DEFINE    WKC001        MODBUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        TXKVAESLAT      +25
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
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYKVAETSTP    OFKVAETSTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTKVAEPROG    WKPROG
     C     *LIKE         DEFINE    RTKVAEDANA    WKDANA
     C     *LIKE         DEFINE    RTKVAEFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    SKSLAT        EXSLAZSLAT
     C     *LIKE         DEFINE    SKTENR        EXSLAZTENR
     C     *LIKE         DEFINE    WKC001        EXSLAZAZAR      + 1
     C     *LIKE         DEFINE    WKC001        EXSLAZJNUM      + 5
     C     *LIKE         DEFINE    SKVARK        EXSLAZVARK
     C     *LIKE         DEFINE    SKBAMG        EXSLAZMENG
     C     *LIKE         DEFINE    DUN080        EXSLAZBETE
     C     *LIKE         DEFINE    DUN080        EXSLAZGADA
     C     *LIKE         DEFINE    DUC002        EXSLAZPEAR
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    KVAEKAJJ      WKKAJJ
     C     *LIKE         DEFINE    KVAEKANR      WKKANR
     C     *LIKE         DEFINE    KVAEFENR      WKKVAEFENR
     C     *LIKE         DEFINE    KVAEFFLD      WKKVAEFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KVAESLAT      DSKVAESLAT
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
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3
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
     C                   MOVEL(P)  'TRKVAE'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTKVAEW3
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTKVAEW2
     C                   OTHER
     C                   WRITE     TRKVAECT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTKVAEW3
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTKVAEW2
     C                   OTHER
     C                   WRITE     TRKVAECT
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
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHKVAE
     C/COPY QCPYSRC,CHKVKK
     C/COPY QCPYSRC,CHKVKS
     C/COPY QCPYSRC,CHPAPA
     C/COPY QCPYSRC,CHSLKO
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCPAPA
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
