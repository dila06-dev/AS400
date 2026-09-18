     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 17.11.2010 für Kunde WAECO Besuch in Emstetten
     H*  --------------------------------------------------------------
     H*  Änderung: MG 23.09.2020 DOMETIC Projekt 13482, IC-Abwicklung
     H*            Aktualisieren Versandadresse IC-Bestellung/Auftrag (UAFAD)
     F**************************************************************************
     F*/
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*/
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D BBEL          E DS                  INZ
     D KYBBEL        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXAFAD        E DS                  INZ
     D RTAFAD        E DS                  INZ
     D*
     D EXAFPO        E DS                  INZ
     D RTAFPO        E DS                  INZ
     D*
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***     R E C H E N B E S T I M M U N G E N                            ***
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
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ADVS  '
     C                   EXSR      VADVS
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UAFAD '
     C                   EXSR      UAFAD
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
     C                   MOVEL(P)  DAFIRM        KYADFI                         AFAD
     C                   MOVEL(P)  DAFIRM        KYELFI                         BBEL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        EXAFADAFJJ
     C                   MOVEA     KOM(05)       EXAFADAFNR
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C                   MOVEA     KOM(01)       EXAFADKDNR
     C                   MOVEA     KOM(11)       EXAFADVSNR
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
     C***  SR-VADVS   Löschen                                                ***
     C**************************************************************************
     C     VADVS         BEGSR
     C*
     C                   MOVE      *OFF          WKTRTP
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     EXAFADKDNR    KOM(1)
     C                   MOVEL(P)  *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCKUND
     C*-------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C*-------------------------------------------------------------------
     C     KDKDST        IFGE      '90'                                         DER KUNDEN
     C                   MOVEL     'KDST'        KYTPTA                         STATUS LÄSST
     C                   MOVEL     KDKDST        KYTPTC                         EINE
     C                   EXSR      CHTRTP                                       BEARBEITUNG
     C                   MOVEA     TPTTXT        W99                            NICHT ZU
     C*
     C                   MOVEA     W99(1)        RTTRNDPA03
     C                   MOVEA     W99(11)       RTTRNDPA04
     C                   MOVE      '0014'        RTTRNDFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   CLEAR                   RTAFAD
     C*
     C                   MOVEL(P)  '2     '      EXAFADPGST
     C                   MOVEL(P)  'ADVS'        EXAFADAART
     C                   MOVEL(P)  *BLANK        EXAFADVSNR
     C                   MOVEL(P)  KDNAM1        EXAFADNAM1
     C                   MOVEL(P)  KDNAM2        EXAFADNAM2
     C                   MOVEL(P)  KDNAM3        EXAFADNAM3
     C                   MOVEL(P)  KDSTRA        EXAFADSTRA
     C                   MOVEL(P)  KDHSNR        EXAFADHSNR
     C                   MOVEL(P)  KDWORT        EXAFADWORT
     C                   MOVEL(P)  KDPOLD        EXAFADPOLD
     C                   MOVEL(P)  KDPOLZ        EXAFADPOLZ
     C                   MOVEL(P)  KDHINW        EXAFADHINW
     C                   MOVEL(P)  *ON           EXAFADIFK1
     C                   CALL      'TRAFAD'
     C                   PARM                    EXAFAD
     C                   PARM                    RTAFAD
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Aktualisieren Versandadresse IC-Bestellung/Auftrag                ***
     C**************************************************************************
     C     UAFAD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln IC-Bestell/Auftragsnr
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFPO
     C                   MOVEL     'PBBEU '      EXAFPOPGST
     C                   Z-ADD     EXAFADAFJJ    EXAFPOAFJJ
     C                   MOVEL     EXAFADAFNR    EXAFPOAFNR
     C                   CALL      'T2AFPO'
     C                   PARM                    EXAFPO
     C                   PARM                    RTAFPO
     C*
     C     RTAFPOBZAN    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Ermitteln Versandadresse (KD-Auftrag)
     C*--------------------------------------------------------
     C                   Z-ADD     EXAFADAFJJ    KYADJH
     C                   MOVEL     EXAFADAFNR    KYADAF
     C                   MOVEL     'ADVS'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL     'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*--------------------------------------------------------
     C* Aktualisieren Lieferadresse IC-Bestellung
     C*--------------------------------------------------------
     C     RTAFPOBENR    IFNE      *BLANK
     C                   EXSR      UBBEL
     C                   ENDIF
     C*--------------------------------------------------------
     C* Aktualisieren Versandadresse IC-Auftrag
     C*--------------------------------------------------------
     C                   EXSR      UAFADADVS
     C                   MOVEL     DAFIRM        KYADFI
     C*--------------------------------------------------------
     C* Aktualisieren Kommissionierung
     C*--------------------------------------------------------
     C                   EXSR      UAFKM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BBEL                                                 ***
     C**************************************************************************
     C     UBBEL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTAFPOBEJJ    KYELJH
     C                   MOVEL     RTAFPOBENR    KYELBE
     C                   MOVEL     'BBEL'        KYELAA
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBEL
     C*-------------------------------------------------------------------------
     C                   MOVE      ADNAM1        ELNAM1
     C                   MOVE      ADNAM2        ELNAM2
     C                   MOVE      ADNAM3        ELNAM3
     C                   MOVE      ADSTRA        ELSTRA
     C                   EVAL      ELSTRA      = %TRIM(ELSTRA)+' '+%TRIM(ADHSNR)
     C                   MOVE      ADPOLD        ELPOLD
     C                   MOVE      ADPOLZ        ELPOLZ
     C                   MOVE      ADPOLN        ELPOLN
     C                   MOVE      ADWORT        ELWORT
     C                   MOVE      ADPOFA        ELPOFA
     C                   MOVE      ADLAND        ELLAND
     C*--------------------------------------------------------
     C                   MOVE      DAJNAM        ELJNAM
     C                   MOVE      WKCHPN        ELPROG
     C                   MOVE      WKCHPL        ELBIBL
     C                   MOVE      DAUSER        ELUSER
     C                   TIME                    ELJZEI
     C*--------------------------------------------------------
     C                   MOVEL     *DATE         #CDATV
     C                   MOVEL     '*EUR'        #CFMTV
     C                   MOVEL     '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVEL     #CDATN        ELJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHBBEL
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBBEL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI AFAD                                                 ***
     C**************************************************************************
     C     UAFADADVS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTAFPOBZAF    KYADFI
     C                   Z-ADD     RTAFPOBZAJ    KYADJH
     C                   MOVEL     RTAFPOBZAN    KYADAF
     C                   Z-ADD     *ZERO         KYADPO
     C                   MOVEL     'ADVS'        KYADAA
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFAD
     C*-------------------------------------------------------------------------
     C                   MOVE      ELNAM1        ADNAM1
     C                   MOVE      ELNAM2        ADNAM2
     C                   MOVE      ELNAM3        ADNAM3
     C                   MOVE      ELSTRA        ADSTRA
     C                   MOVE      *BLANK        ADHSNR
     C                   MOVE      ELPOLD        ADPOLD
     C                   MOVE      ELPOLZ        ADPOLZ
     C                   MOVE      ELPOLN        ADPOLN
     C                   MOVE      ELWORT        ADWORT
     C                   MOVE      ELPOFA        ADPOFA
     C                   MOVE      ELLAND        ADLAND
     C                   MOVE      *BLANK        ADHINW
     C*
     C                   MOVEL     DAJNAM        ADJNAM
     C                   MOVEL     WKCHPN        ADPROG
     C                   MOVEL     WKCHPL        ADBIBL
     C                   MOVEL     DAUSER        ADUSER
     C                   TIME                    ADJZEI
     C*--------------------------------------------------------
     C                   MOVEL     UDATE         #CDATV
     C                   MOVE      DADJHT        #CDATV
     C                   MOVEL     DADFMT        #CFMTV
     C                   MOVEL     'JHJJMMTT'    #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVE      #CDATN        ADJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHAFAD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFAD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-UAFKM  UPDATEN KOMMISSIONIERKOPF                               ***
     C**************************************************************************
     C     UAFKM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTAFPOBZAF    KYAMJH
     C                   MOVEL     '20'          KYAMST
     C                   Z-ADD     RTAFPOBZAJ    KYAMJH
     C                   MOVEL     RTAFPOBZAN    KYAMAF
     C                   Z-ADD     *ZERO         KYAMJH
     C                   MOVEL     *BLANK        KYAMKM
     C                   MOVEA     '04+U    '    CHI
     C                   EXSR      CHAFKM
     C*
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     AMFIRM        IFNE      KYAMFI
     C     AMAFST        ORNE      KYAMST
     C     AMAFJJ        ORNE      KYAMJJ
     C     AMAFNR        ORNE      KYAMAF
     C                   MOVEA     '04F     '    CHI
     C                   EXSR      CHAFKM
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVE      ADNAM1        AMNAM1
     C                   MOVE      ADNAM2        AMNAM2
     C                   MOVE      ADNAM3        AMNAM3
     C                   MOVE      ADSTRA        AMSTRA
     C                   MOVE      ADHSNR        AMHSNR
     C                   MOVE      ADPOLD        AMPOLD
     C                   MOVE      ADPOLZ        AMPOLZ
     C                   MOVE      ADPOLN        AMPOLN
     C                   MOVE      ADWORT        AMWORT
     C                   MOVE      ADPOFA        AMPOFA
     C                   MOVE      ADLAND        AMLAND
     C*----------------------------------------------------------
     C                   MOVEA     '04U     '    CHI
     C                   EXSR      CHAFKM
     C*-------------------------------------------------------------------------
     C                   MOVEA     '04RU    '    CHI
     C                   EXSR      CHAFKM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
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
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHBBEL
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,TRDAUM
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
