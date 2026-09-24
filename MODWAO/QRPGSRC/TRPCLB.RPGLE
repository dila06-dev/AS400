     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE Datenübertragung Lagerleitrechner
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Datenübertragung der Lagerbuchungs-
     F*  sätze in die Schnittstellendatei für den Lagerleitrechner.
     F*
     F*  Die Steuerung der Verarbeitungsart erfolgt über DSUPKZ:
     F*
     F*      - 'U' =  Update PCLB   - Erzeugen Schnittstellensatz
     F*
     F*  Als Übergabe-Parameter werden nachfolgende Elemente mitgegeben:
     F*
     F*     KOM(001) =   DSUPKZ  Update Kennzeichen
     F*     KOM(002) =   DSTENR  Identnummer
     F*     KOM(017) =   DSLANR  Lager
     F*     KOM(020) =   DSLORT  Lagerplatz
     F*     KOM(028) =   DSBHNR  Behälter
     F*     KOM(038) =   DSBUMG  Entnahmemenge
     F*     KOM(049) =   DSDANA  Auftrags-Datei
     F*     KOM(059) =   DSAFJJ  Auftrags-Jahr
     F*     KOM(063) =   DSAFNR  Auftrags-Nummer
     F*     KOM(069) =   DSAFPO  Auftrags-Position
     F*     KOM(073) =   DSAFUP  Auftrags-Unterpostion
     F*     KOM(077) =   DSDANA  Dateiname
     F*     KOM(087) =   DSJAHR  Jahr
     F*     KOM(091) =   DSNMKR  Nummernkreis
     F*     KOM(097) =   DSPOSI  Position
     F*     KOM(102) =   DSKMTE  Kom.Termin
     F*     KOM(110) =   DSBUKZ  Buchungsschlüssel
     F*     KOM(113) =   DSTMST  Timesstamp
     F*     KOM(139) =   DSCHAR  Chargennummer
     F*     KOM(159) =   DSULNR  Umbuchungslager
     F*     KOM(162) =   DSALST  Auslagerstrecke
     F*     KOM(164) =   DSUORT  Umbuchungslagerplatz
     F*     KOM(172) =   DSALPR  Auslagerpriorität
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D W99             S              1    DIM(99)                              WORK-FELDGRP.
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ
     D*
     D LBBS          E DS                  INZ
     D KYLBBS        E DS                  INZ
     D*
     D PCLB          E DS                  INZ
     D KYPCLB        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEMA          E DS                  INZ
     D KYTEMA        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D/COPY TAMP/QCPYSRC,EXTRDA
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C*
     C     DSUPKZ        IFEQ      'U'
     C*-------------------------------------------------------------------------
     C                   MOVE      LSSBEZ        KZBUCH            1            UPDATE
     C                   MOVEL(P)  *OFF          WKBGFS            1
     C*-------------------------------------------------------------------------
     C                   MOVEL     '$$BGFS'      KYTPTA
     C                   MOVEL     LBLBLSTC      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVEL(P)  *ON           WKBGFS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     #CPGST        IFNE      '6     '
     C     KZBUCH        ANDEQ     '*'
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             WKBESTAND        11 3
     C                   MOVEL(P)  'LB02'        KYLBBSBSTY
     C                   MOVEL(P)  DSTENR        KYLBBSTENR
     C                   MOVEL(P)  DSLANR        KYLBBSLANR
     C                   MOVEL(P)  DSLORT        KYLBBSLORT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBBS
     C     WKFENR        IFEQ      *ZEROS
     C     LBBSSPKZ      IFEQ      'J'
     C                   SUB       LBBSLAGB      DSBUMG
     C                   MOVEL(P)  '!'           KZBUCH
     C                   EXSR      SPERRBGFS
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LB01'        KYLBBSBSTY
     C                   MOVEL(P)  DSTENR        KYLBBSTENR
     C                   MOVEL(P)  DSLANR        KYLBBSLANR
     C                   MOVEL(P)  DSLORT        KYLBBSLORT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBBS
     C     WKFENR        IFEQ      *ZEROS
     C     LBBSSPKZ      IFEQ      'J'
     C                   SUB       LBBSLAGB      DSBUMG
     C                   MOVEL(P)  '!'           KZBUCH
     C                   EXSR      SPERRBGFS
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KZBUCH        IFEQ      '*'                                          UPDATE
     C**   WKBGFS        OREQ      *ON
     C                   EXSR      UPCLB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      NACHLAUF                                     PRÜFEN PCLB
     C*-------------------------------------------------------------------------
     C     ENDE          TAG
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         #CDATN                         DATUMFELDER
     C                   MOVE      *ZERO         #CDATV                         AUF NULL SETZEN
     C                   MOVE      *ZERO         #CFMTN
     C                   MOVE      *ZERO         #CFMTV
     C                   MOVE      *ZERO         #CDAKW
     C                   MOVE      *ZERO         #CDAJJ
     C                   MOVE      *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C                   MOVE      *ZERO         WKN090            9 0
     C                   MOVE      *ZERO         WKN154           15 4
     C                   MOVE      *ZERO         WKN219           21 9
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  DAUSER        WKUSER
     C                   MOVEL(P)  DAPROG        WKCHPN
     C                   MOVEL(P)  DABIBL        WKCHPL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLBLBFIRM                     LBLB
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM                     LBBS
     C                   MOVEL(P)  DAFIRM        KYPCLBFIRM                     PCLB
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTMFI                         TEMA
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYLSFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYAEFI                         BWAE
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM                     LBBS
     C                   MOVEL(P)  DAFIRM        KYLDFI                         LBBS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DABIBL        KYTPFI
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      DSTMST        KYLBLBTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBLB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBLSTC      KYLSTC
     C                   MOVE      *BLANKS       KYLSLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSS
     C*-------------------------------------------------------------------------
     C                   MOVE      '!'           LSSBEZ
     C*    #CPGST        IFEQ      '6     '
     C                   MOVEL(P)  DSLANR        KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     WKFENR        IFEQ      *ZEROS
     C     LDHLKZ        IFEQ      'J'
     C                   MOVE      '*'           LSSBEZ
     C     DSBUMG        IFLT      0
     C                   MULT      -1            DSBUMG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*                  ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÜBERNAHME KOM-BEREICH                                             ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM(01)       DSUPKZ                         ÜBERGABEBEREICH
     C                   MOVEA     KOM(02)       DSTENR
     C                   MOVEA     KOM(17)       DSLANR
     C                   MOVEA     KOM(20)       DSLORT
     C                   MOVEA     KOM(28)       DSBHNR
     C*--------------------------------------------------------
     C                   MOVEA     KOM(38)       DUC011
     C                   TESTN                   DUC011                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN112
     C                   ENDIF
     C*
     C                   Z-ADD     DUN112        DSBUMG
     C*--------------------------------------------------------
     C                   MOVEA     KOM(49)       DSDANA
     C*--------------------------------------------------------
     C                   MOVEA     KOM(59)       DUC004
     C                   TESTN                   DUC004                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN040
     C                   ENDIF
     C*
     C                   Z-ADD     DUN040        DSAFJJ
     C*--------------------------------------------------------
     C                   MOVEA     KOM(63)       DSAFNR
     C*--------------------------------------------------------
     C                   MOVEA     KOM(69)       DUC004
     C                   TESTN                   DUC004                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN040
     C                   ENDIF
     C*
     C                   Z-ADD     DUN040        DSAFPO
     C*--------------------------------------------------------
     C                   MOVEA     KOM(73)       DUC004
     C                   TESTN                   DUC004                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN040
     C                   ENDIF
     C*
     C                   Z-ADD     DUN040        DSAFUP
     C*--------------------------------------------------------
     C                   MOVEA     KOM(77)       DSDANA
     C*--------------------------------------------------------
     C                   MOVEA     KOM(87)       DUC004
     C                   TESTN                   DUC004                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN040
     C                   ENDIF
     C*
     C                   Z-ADD     DUN040        DSJAHR
     C*--------------------------------------------------------
     C                   MOVEA     KOM(91)       DSNMKR
     C*--------------------------------------------------------
     C                   MOVEA     KOM(97)       DUC005
     C                   TESTN                   DUC005                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN050
     C                   ENDIF
     C*
     C                   Z-ADD     DUN050        DSPOSI
     C*--------------------------------------------------------
     C                   MOVEA     KOM(102)      DUC008
     C                   TESTN                   DUC008                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     *ZERO         DUN080
     C                   ENDIF
     C*
     C                   Z-ADD     DUN080        DSKMTE
     C*--------------------------------------------------------
     C                   MOVEA     KOM(110)      DSBUKZ
     C*--------------------------------------------------------
     C                   MOVEA     KOM(113)      DUC026
     C                   TESTN                   DUC026                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     1             DUN260
     C                   ENDIF
     C*
     C                   Z-ADD     DUN260        DSTMST
     C*--------------------------------------------------------
     C                   MOVEA     KOM(139)      DSCHAR
     C                   MOVEA     KOM(159)      DSULNR
     C                   MOVEA     KOM(162)      DSALST
     C                   MOVEA     KOM(164)      DSUORT
     C*--------------------------------------------------------
     C                   MOVEA     KOM(172)      DUC001
     C                   TESTN                   DUC001                   99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     1             DUN010
     C                   ENDIF
     C*
     C                   Z-ADD     DUN010        DSALPR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**********************************************************************
     C***  LESEN WARENEINGANGSSATZ
     C**********************************************************************
     C     LBWAE         BEGSR
     C*
     C                   MOVEL     LBLBDAKY      A10
     C*
     C                   MOVEL     A10           KYAEWJ
     C                   MOVE      A10           KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*
     C     WKFENR        IFEQ      *OFF
     C                   MOVEL(P)  AEBLIN        PCLBKDNR
     C                   ENDIF
     C*
     C                   ENDSR
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
     C***  PRÜFEN SCHNITTSTELLENSATZ                                         ***
     C**************************************************************************
     C     PPCLB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERSTELLEN SCHNITTSTELLENSATZ                                      ***
     C**************************************************************************
     C     UPCLB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***************    MOVEL(P)  LBLBLSTC      DSBUKZ
     C*-------------------------------------------------------------------------
     C     DSALST        IFEQ      *BLANK
     C                   MOVEL(P)  '01'          DSALST
     C                   ENDIF
     C*----------------------------------- -------------------------------------
     C     LBLBSTKZ      IFEQ      'S'
     C                   MULT      -1            DSBUMG
     C     DSBUKZ        IFEQ      'ABG'
     C                   MOVEL(P)  'ZUG'         DSBUKZ
     C                   ELSE
     C                   MOVEL(P)  'ABG'         DSBUKZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSKDNR
     C                   MOVEL(P)  LBLBDANA      DSDANA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBDAKY      A10              10
     C                   MOVEL     A10           DSAFJJ
     C                   MOVE      A10           DSAFNR
     C                   EVALR     DSAFNR = %TRIMR(DSAFNR)
     C     ' ':'0'       XLATE     DSAFNR        DSAFNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTENR                         DATEN AUS
     C                   MOVE      *BLANK        KYTEEZ                         TEILESTAMM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   MOVEL(P)  TEMEIN        DSMEIN
     C                   MOVEL(P)  TETBZ1        DSTBZ1
     C                   MOVEL(P)  TETBZ2        DSTBZ2
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSVEDA                         VERFALLDATUM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTMTE                         ERMITTELN
     C                   MOVEA     '01C     '    CHI                            STÜCK/LADEMITTEL
     C                   EXSR      CHTEMA
     C                   Z-ADD     TML4ST        DSMGVP
     C*-------------------------------------------------------------------------
     C                   MOVE      *DATE         #CDATV                         ERMITTELN
     C                   MOVEL(P)  '*EUR'        #CFMTV                         SCHLÜSSEL
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        KYPCLBSEDA
     C                   TIME                    KYPCLBSEZT
     C                   MOVE      *HIVAL        KYPCLBLFIX
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHPCLB
     C                   MOVE      *ZERO         WKFENR
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     PCLBFIRM      ORNE      KYPCLBFIRM                                   WENN SATZ FEHLT
     C     PCLBSEDA      ORNE      KYPCLBSEDA
     C     PCLBSEZT      ORNE      KYPCLBSEZT
     C                   Z-ADD     1             KYPCLBLFIX
     C                   ELSE
     C     PCLBLFIX      ADD       1             KYPCLBLFIX
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI                            SATZ HINZUFÜGEN
     C                   EXSR      CHPCLB
     C*-------------------------------------------------------------------------
     C                   MOVE      '00'          PCLBSTAT
     C                   MOVE      DSBUKZ        PCLBBUKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBSTKZ      PCLBFRIN
     C                   MOVEL(P)  LBLBLSTC      PCLBFREX
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSTENR        PCLBTENR
     C                   MOVEL(P)  DSLANR        PCLBLANR
     C                   MOVEL(P)  DSLORT        PCLBLORT
     C                   MOVEL(P)  DSBHNR        PCLBBHNR
     C                   Z-ADD     DSBUMG        PCLBBUMG
     C                   Z-ADD     DSKMTE        PCLBKMTE
     C                   MOVEL(P)  DSMEIN        PCLBMEIN
     C                   MOVEL(P)  DSTBZ1        PCLBBEZ1
     C                   MOVEL(P)  DSTBZ2        PCLBBEZ2
     C                   Z-ADD     DSMGVP        PCLBMGVP
     C                   MOVEL(P)  DSULNR        PCLBULNR
     C                   MOVEL(P)  DSALST        PCLBALST
     C                   MOVEL(P)  DSUORT        PCLBUORT
     C                   Z-ADD     DSALPR        PCLBALPR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSAFDN        PCLBAFDN                         AUFTRAG
     C                   MOVEL(P)  'BGFS'        PCLBAFDN                         AUFTRAG
     C                   Z-ADD     DSAFJJ        PCLBAFJJ
     C                   MOVEL(P)  DSAFNR        PCLBAFNR
     C                   Z-ADD     DSAFPO        PCLBAFPO
     C                   Z-ADD     DSAFUP        PCLBAFUP
     C                   MOVEL(P)  DSKDNR        PCLBKDNR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSCHAR        PCLBCHAR
     C                   Z-ADD     DSVEDA        PCLBVEDA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSDANA        PCLBDANA                        ZUORDNUNG
     C                   Z-ADD     DSJAHR        PCLBJAHR
     C                   MOVEL(P)  DSNMKR        PCLBNMKR
     C                   Z-ADD     DSPOSI        PCLBPOSI
     C                   MOVE      DSTMST        PCLBTMST
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PCLBJNAM
     C                   MOVEL(P)  WKCHPN        PCLBPROG
     C                   MOVEL(P)  WKCHPL        PCLBBIBL
     C                   MOVEL(P)  DAUSER        PCLBUSER
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PCLBJDAT
     C                   TIME                    DUN060
     C                   Z-ADD     DUN060        PCLBJZEI
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHPCLB                                       FÜGEN
     C*-------------------------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHPCLB
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SPERRBESTAND IN BGFS WEGBUCHEN                                    ***
     C**************************************************************************
     C     SPERRBGFS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSALST        IFEQ      *BLANK
     C                   MOVEL(P)  '01'          DSALST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ABG'         DSBUKZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSKDNR
     C                   MOVEL(P)  LBLBDANA      DSDANA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBDAKY      A10              10
     C                   MOVEL     A10           DSAFJJ
     C                   MOVE      A10           DSAFNR
     C                   EVALR     DSAFNR = %TRIMR(DSAFNR)
     C     ' ':'0'       XLATE     DSAFNR        DSAFNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTENR                         DATEN AUS
     C                   MOVE      *BLANK        KYTEEZ                         TEILESTAMM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   MOVEL(P)  TEMEIN        DSMEIN
     C                   MOVEL(P)  TETBZ1        DSTBZ1
     C                   MOVEL(P)  TETBZ2        DSTBZ2
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSVEDA                         VERFALLDATUM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTMTE                         ERMITTELN
     C                   MOVEA     '01C     '    CHI                            STÜCK/LADEMITTEL
     C                   EXSR      CHTEMA
     C                   Z-ADD     TML4ST        DSMGVP
     C*-------------------------------------------------------------------------
     C                   MOVE      *DATE         #CDATV                         ERMITTELN
     C                   MOVEL(P)  '*EUR'        #CFMTV                         SCHLÜSSEL
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        KYPCLBSEDA
     C                   TIME                    KYPCLBSEZT
     C                   MOVE      *HIVAL        KYPCLBLFIX
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHPCLB
     C                   MOVE      *ZERO         WKFENR
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     PCLBFIRM      ORNE      KYPCLBFIRM                                   WENN SATZ FEHLT
     C     PCLBSEDA      ORNE      KYPCLBSEDA
     C     PCLBSEZT      ORNE      KYPCLBSEZT
     C                   Z-ADD     1             KYPCLBLFIX
     C                   ELSE
     C     PCLBLFIX      ADD       1             KYPCLBLFIX
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI                            SATZ HINZUFÜGEN
     C                   EXSR      CHPCLB
     C*-------------------------------------------------------------------------
     C                   MOVE      '00'          PCLBSTAT
     C                   MOVE      DSBUKZ        PCLBBUKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBSTKZ      PCLBFRIN
     C                   MOVEL(P)  LBLBLSTC      PCLBFREX
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSTENR        PCLBTENR
     C                   MOVEL(P)  DSLANR        PCLBLANR
     C                   MOVEL(P)  DSLORT        PCLBLORT
     C                   MOVEL(P)  DSBHNR        PCLBBHNR
     C                   Z-ADD     DSBUMG        PCLBBUMG
     C     DSBUMG        IFLT      0
     C                   MULT      -1            DSBUMG
     C                   ENDIF
     C                   Z-ADD     DSBUMG        PCLBBUMG
     C                   Z-ADD     DSKMTE        PCLBKMTE
     C                   MOVEL(P)  DSMEIN        PCLBMEIN
     C                   MOVEL(P)  DSTBZ1        PCLBBEZ1
     C                   MOVEL(P)  DSTBZ2        PCLBBEZ2
     C                   Z-ADD     DSMGVP        PCLBMGVP
     C                   MOVEL(P)  DSULNR        PCLBULNR
     C                   MOVEL(P)  DSALST        PCLBALST
     C                   MOVEL(P)  DSUORT        PCLBUORT
     C                   Z-ADD     DSALPR        PCLBALPR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSAFDN        PCLBAFDN                         AUFTRAG
     C                   MOVEL(P)  'BGFS'        PCLBAFDN                         AUFTRAG
     C                   Z-ADD     DSAFJJ        PCLBAFJJ
     C                   MOVEL(P)  DSAFNR        PCLBAFNR
     C                   Z-ADD     DSAFPO        PCLBAFPO
     C                   Z-ADD     DSAFUP        PCLBAFUP
     C                   MOVEL(P)  DSKDNR        PCLBKDNR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSCHAR        PCLBCHAR
     C                   Z-ADD     DSVEDA        PCLBVEDA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSDANA        PCLBDANA                        ZUORDNUNG
     C                   Z-ADD     DSJAHR        PCLBJAHR
     C                   MOVEL(P)  DSNMKR        PCLBNMKR
     C                   Z-ADD     DSPOSI        PCLBPOSI
     C                   MOVE      DSTMST        PCLBTMST
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PCLBJNAM
     C                   MOVEL(P)  WKCHPN        PCLBPROG
     C                   MOVEL(P)  WKCHPL        PCLBBIBL
     C                   MOVEL(P)  DAUSER        PCLBUSER
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PCLBJDAT
     C                   TIME                    DUN060
     C                   Z-ADD     DUN060        PCLBJZEI
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHPCLB                                       FÜGEN
     C*-------------------------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHPCLB
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RÜCKGABE PARAMETER                                                ***
     C**************************************************************************
     C     NACHLAUF      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   MOVEA     WKFENR        KOM(1)
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5            INT.PROGR.STAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPA                         IND.TRPA
     C     *LIKE         DEFINE    WKC001        DSUPKZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 3            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         USER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    PCLBTENR      DSTENR
     C     *LIKE         DEFINE    PCLBLANR      DSLANR
     C     *LIKE         DEFINE    PCLBLORT      DSLORT
     C     *LIKE         DEFINE    PCLBBHNR      DSBHNR
     C     *LIKE         DEFINE    PCLBBUMG      DSBUMG
     C     *LIKE         DEFINE    PCLBKMTE      DSKMTE
     C     *LIKE         DEFINE    PCLBAFDN      DSAFDN
     C     *LIKE         DEFINE    PCLBAFJJ      DSAFJJ
     C     *LIKE         DEFINE    PCLBAFNR      DSAFNR
     C     *LIKE         DEFINE    PCLBAFPO      DSAFPO
     C     *LIKE         DEFINE    PCLBAFUP      DSAFUP
     C     *LIKE         DEFINE    PCLBDANA      DSDANA
     C     *LIKE         DEFINE    PCLBJAHR      DSJAHR
     C     *LIKE         DEFINE    PCLBNMKR      DSNMKR
     C     *LIKE         DEFINE    PCLBPOSI      DSPOSI
     C     *LIKE         DEFINE    PCLBKDNR      DSKDNR
     C     *LIKE         DEFINE    PCLBTMST      DSTMST
     C     *LIKE         DEFINE    PCLBBUKZ      DSBUKZ
     C     *LIKE         DEFINE    PCLBMEIN      DSMEIN
     C     *LIKE         DEFINE    PCLBBEZ1      DSTBZ1
     C     *LIKE         DEFINE    PCLBBEZ2      DSTBZ2
     C     *LIKE         DEFINE    PCLBVEDA      DSVEDA
     C     *LIKE         DEFINE    PCLBCHAR      DSCHAR
     C     *LIKE         DEFINE    PCLBMGVP      DSMGVP
     C     *LIKE         DEFINE    PCLBULNR      DSULNR
     C     *LIKE         DEFINE    PCLBALST      DSALST
     C     *LIKE         DEFINE    PCLBUORT      DSUORT
     C     *LIKE         DEFINE    PCLBALPR      DSALPR
     C*
     C     *LIKE         DEFINE    PCLBLANR      WKTRPALANR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHLBBS
     C/COPY QCPYSRC,CHPCLB
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEMA
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHLBSS
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,TRDAUM
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
