     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2000')
     H**************************************************************************
     H/TITLE PTC Bestandsauskunft
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 17.11.2003
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm zeigt die Bestände (max. 4 Plätze) im PTC-Bild an.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRLBBSS9FMCF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,TRCURSOR
     D  C_IDENT               41     41N
     D  C_LAGER               42     42N
     D  C_BEST1               51     51N
     D  C_BEST2               52     52N
     D  C_BEST3               53     53N
     D  C_BEST4               54     54N
     D  C_BEST5               55     55N
     D  C_BEST6               56     56N
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBBS          E DS                  INZ
     D KYLBBS        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    AKTION            6
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRLBBSS9FM                           98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRLBBSS9FM                           98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C**                 RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN                         DATUMFELDER
     C                   Z-ADD     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C                   MOVEL(P)  DAFIRM        WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYLLFI                         LBPL
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM                     LBBS
     C                   MOVEL(P)  DAFIRM        KYLBRSFIRM                     TEIL
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   EVAL      TXFIRM = 'Bestandsauskunft              '
     C                   EVAL      TXFIRMK = 'Bestand    '
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKTION        WKPGST            6
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
     C                   MOVE      'F'           WKFEAT                         MSG-FELDER
     C                   MOVE      *BLANK        MCF                            MC-PROGRAMME
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
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C                   EXSR      B01DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C*
     C     WKPGST        IFEQ      'SCANH1'
     C                   WRITE     TRLBS901
     C                   WRITE     TRLBS9B1
     C                   ELSE
     C                   WRITE     TRLBS911
     C                   WRITE     TRLBS9B2
     C                   ENDIF
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C     WKPGST        IFEQ      'SCANH1'
     C                   READ      TRLBS901                             9899    LESEN DES BILDS
     C                   ELSE
     C                   READ      TRLBS911                             9899    LESEN DES BILDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#EXIT        WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C*-------------------------------------------------------------------------
     C     DSTENR        IFNE      *BLANKS
     C                   MOVE      '02'          WKIFMT                         NÄCHSTES BILD
     C                   ELSE
     C                   MOVE      '03'          WKIFMT                         NÄCHSTES BILD
     C                   ENDIF
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
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C_IDENT
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
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLAGER
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD02                                              ***
     C**************************************************************************
     C     BILD02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C                   EXSR      B02DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '02'
     C*
     C     WKPGST        IFEQ      'SCANH1'
     C                   WRITE     TRLBS902
     C                   WRITE     TRLBS9B1
     C                   ELSE
     C                   WRITE     TRLBS912
     C                   WRITE     TRLBS9B2
     C                   ENDIF
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C     WKPGST        IFEQ      'SCANH1'
     C                   READ      TRLBS902                             9899    LESEN DES BILDS
     C                   ELSE
     C                   READ      TRLBS912                             9899    LESEN DES BILDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#EXIT        WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
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
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT                         NÄCHSTES BILD
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 02                                        ***
     C**************************************************************************
     C     B02DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C_IDENT
     C                   MOVE      *OFF          C_LAGER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANKS       DSLAG1
     C                   MOVE      *BLANKS       DSPLA1
     C                   MOVE      *BLANKS       DSART1
     C                   MOVE      *BLANKS       DSART1X
     C                   MOVE      *ZEROS        DSBES1
     C                   MOVE      *BLANKS       DSLAG2
     C                   MOVE      *BLANKS       DSPLA2
     C                   MOVE      *BLANKS       DSART2
     C                   MOVE      *BLANKS       DSART2X
     C                   MOVE      *ZEROS        DSBES2
     C                   MOVE      *BLANKS       DSLAG3
     C                   MOVE      *BLANKS       DSPLA3
     C                   MOVE      *BLANKS       DSART3
     C                   MOVE      *BLANKS       DSART3X
     C                   MOVE      *ZEROS        DSBES3
     C                   MOVE      *BLANKS       DSLAG4
     C                   MOVE      *BLANKS       DSPLA4
     C                   MOVE      *BLANKS       DSART4
     C                   MOVE      *BLANKS       DSART4X
     C                   MOVE      *ZEROS        DSBES4
     C                   MOVE      *BLANKS       DSLAG5
     C                   MOVE      *BLANKS       DSPLA5
     C                   MOVE      *BLANKS       DSART5
     C                   MOVE      *BLANKS       DSART5X
     C                   MOVE      *ZEROS        DSBES5
     C                   MOVE      *BLANKS       DSLAG6
     C                   MOVE      *BLANKS       DSPLA6
     C                   MOVE      *BLANKS       DSART6
     C                   MOVE      *BLANKS       DSART6X
     C                   MOVE      *ZEROS        DSBES6
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLANR        DSLAGNR
     C                   MOVEL(P)  DSLORT        DSPLATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             ZAEHL             1 0
     C                   MOVE      *OFF          C_BEST1
     C                   MOVE      *OFF          C_BEST2
     C                   MOVE      *OFF          C_BEST3
     C                   MOVE      *OFF          C_BEST4
     C                   MOVE      *OFF          C_BEST5
     C                   MOVE      *OFF          C_BEST6
     C*
     C                   CLEAR                   KYLBBS
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM
     C                   MOVEL(P)  'LB02'        KYLBBSBSTY
     C                   MOVEL(P)  DSTENR        KYLBBSTENR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C                   DO        *HIVAL
     C*-------------------------------------------------------------------------
     C                   ADD       1             ZAEHL
     C*
     C     WKFENR        IFNE      *ZERO
     C     LBBSTENR      ORNE      KYLBBSTENR
     C     ZAEHL         ORGT      6
     C                   LEAVE
     C                   ENDIF
     C*
     C                   SELECT
     C     ZAEHL         WHENEQ    1
     C                   MOVEL(P)  LBBSLANR      DSLAG1
     C                   MOVEL(P)  LBBSLORT      DSPLA1
     C                   Z-ADD     LBBSLAGB      DSBES1
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST1
     C                   ENDIF
     C     ZAEHL         WHENEQ    2
     C                   MOVEL(P)  LBBSLANR      DSLAG2
     C                   MOVEL(P)  LBBSLORT      DSPLA2
     C                   Z-ADD     LBBSLAGB      DSBES2
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST2
     C                   ENDIF
     C     ZAEHL         WHENEQ    3
     C                   MOVEL(P)  LBBSLANR      DSLAG3
     C                   MOVEL(P)  LBBSLORT      DSPLA3
     C                   Z-ADD     LBBSLAGB      DSBES3
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST3
     C                   ENDIF
     C     ZAEHL         WHENEQ    4
     C                   MOVEL(P)  LBBSLANR      DSLAG4
     C                   MOVEL(P)  LBBSLORT      DSPLA4
     C                   Z-ADD     LBBSLAGB      DSBES4
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST4
     C                   ENDIF
     C     ZAEHL         WHENEQ    5
     C                   MOVEL(P)  LBBSLANR      DSLAG5
     C                   MOVEL(P)  LBBSLORT      DSPLA5
     C                   Z-ADD     LBBSLAGB      DSBES5
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST5
     C                   ENDIF
     C     ZAEHL         WHENEQ    6
     C                   MOVEL(P)  LBBSLANR      DSLAG6
     C                   MOVEL(P)  LBBSLORT      DSPLA6
     C                   Z-ADD     LBBSLAGB      DSBES6
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST6
     C                   ENDIF
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD02                                          ***
     C**************************************************************************
     C     B02PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD03                                              ***
     C**************************************************************************
     C     BILD03        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C                   EXSR      B03DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '03'
     C*
     C     WKPGST        IFEQ      'SCANH1'
     C                   WRITE     TRLBS903
     C                   WRITE     TRLBS9B1
     C                   ELSE
     C                   WRITE     TRLBS913
     C                   WRITE     TRLBS9B2
     C                   ENDIF
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C     WKPGST        IFEQ      'SCANH1'
     C                   READ      TRLBS903                             9899    LESEN DES BILDS
     C                   ELSE
     C                   READ      TRLBS913                             9899    LESEN DES BILDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#EXIT        WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
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
     C                   EXSR      B03PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT                         NÄCHSTES BILD
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 03                                        ***
     C**************************************************************************
     C     B03DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C_IDENT
     C                   MOVE      *OFF          C_LAGER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANKS       DSLAG1
     C                   MOVE      *BLANKS       DSART1
     C                   MOVE      *BLANKS       DSART1X
     C                   MOVE      *ZEROS        DSBES1
     C                   MOVE      *BLANKS       DSLAG2
     C                   MOVE      *BLANKS       DSART2
     C                   MOVE      *BLANKS       DSART2X
     C                   MOVE      *ZEROS        DSBES2
     C                   MOVE      *BLANKS       DSLAG3
     C                   MOVE      *BLANKS       DSART3
     C                   MOVE      *BLANKS       DSART3X
     C                   MOVE      *ZEROS        DSBES3
     C                   MOVE      *BLANKS       DSLAG4
     C                   MOVE      *BLANKS       DSART4
     C                   MOVE      *BLANKS       DSART4X
     C                   MOVE      *ZEROS        DSBES4
     C                   MOVE      *BLANKS       DSLAG5
     C                   MOVE      *BLANKS       DSART5
     C                   MOVE      *BLANKS       DSART5X
     C                   MOVE      *ZEROS        DSBES5
     C                   MOVE      *BLANKS       DSLAG6
     C                   MOVE      *BLANKS       DSART6
     C                   MOVE      *BLANKS       DSART6X
     C                   MOVE      *ZEROS        DSBES6
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLANR        DSLAGNR
     C                   MOVEL(P)  DSLORT        DSPLATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             ZAEHL             1 0
     C                   MOVE      *OFF          C_BEST1
     C                   MOVE      *OFF          C_BEST2
     C                   MOVE      *OFF          C_BEST3
     C                   MOVE      *OFF          C_BEST4
     C                   MOVE      *OFF          C_BEST5
     C                   MOVE      *OFF          C_BEST6
     C*
     C                   CLEAR                   KYLBBS
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM
     C                   MOVEL(P)  'LB02'        KYLBBSBSTY
     C                   MOVEL(P)  DSLAGNR       KYLBBSLANR
     C                   MOVEL(P)  DSPLATZ       KYLBBSLORT
     C                   MOVEA     '12+     '    CHI
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C                   DO        *HIVAL
     C*-------------------------------------------------------------------------
     C                   ADD       1             ZAEHL
     C*
     C     WKFENR        IFNE      *ZERO
     C     LBBSLANR      ORNE      KYLBBSLANR
     C     LBBSLORT      ORNE      KYLBBSLORT
     C     ZAEHL         ORGT      6
     C                   LEAVE
     C                   ENDIF
     C*
     C*                  CLEAR                   KYLBBS
     C* LBRS             MOVEL(P)  DAFIRM        KYLBBSFIRM
     C* zulesen          MOVEL(P)  'LB02'        KYLBBSBSTY
     C*                  MOVEL(P)  DSLAGNR       KYLBBSLANR
     C*                  MOVEL(P)  DSPLATZ       KYLBBSLORT
     C*                  MOVEA     '99+     '    CHI
     C*                  EXSR      CHLBRS
     C*
     C                   SELECT
     C     ZAEHL         WHENEQ    1
     C                   MOVEL(P)  LBBSTENR      DSART1
     C                   MOVEL(P)  LBBSTENR      DSART1X
     C                   Z-ADD     LBBSLAGB      DSBES1
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST1
     C                   ENDIF
     C     ZAEHL         WHENEQ    2
     C                   MOVEL(P)  LBBSTENR      DSART2
     C                   MOVEL(P)  LBBSTENR      DSART2X
     C                   Z-ADD     LBBSLAGB      DSBES2
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST2
     C                   ENDIF
     C     ZAEHL         WHENEQ    3
     C                   MOVEL(P)  LBBSTENR      DSART3
     C                   MOVEL(P)  LBBSTENR      DSART3X
     C                   Z-ADD     LBBSLAGB      DSBES3
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST3
     C                   ENDIF
     C     ZAEHL         WHENEQ    4
     C                   MOVEL(P)  LBBSTENR      DSART4
     C                   MOVEL(P)  LBBSTENR      DSART4X
     C                   Z-ADD     LBBSLAGB      DSBES4
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST4
     C                   ENDIF
     C     ZAEHL         WHENEQ    5
     C                   MOVEL(P)  LBBSTENR      DSART5
     C                   MOVEL(P)  LBBSTENR      DSART5X
     C                   Z-ADD     LBBSLAGB      DSBES5
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST5
     C                   ENDIF
     C     ZAEHL         WHENEQ    6
     C                   MOVEL(P)  LBBSTENR      DSART6
     C                   MOVEL(P)  LBBSTENR      DSART6X
     C                   Z-ADD     LBBSLAGB      DSBES6
     C     LBBSSPKZ      IFEQ      'J'
     C                   MOVE      *ON           C_BEST6
     C                   ENDIF
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEA     '12R     '    CHI
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD03                                          ***
     C**************************************************************************
     C     B03PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRTENR        BEGSR
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_IDENT
     C*-------------------------------------------------------------------------
     C     DSTENR        IFNE      *BLANK
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSTENR        KYTEEA                         PRÜFEN
     C                   MOVEL     *BLANK        KYTEEZ                         EAN-NR
     C                   MOVEA     '91C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSTENR
     C                   MOVEL(P)  TETBZ1        TXTENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTENR        IFNE      *BLANK
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     TETENR        DSTENR
     C                   MOVEL(P)  TETBZ1        TXTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTENR        IFEQ      *BLANKS
     C     DSLANR        ANDEQ     *BLANKS
     C                   MOVEL     '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LAGER                                                  ***
     C**************************************************************************
     C     PRLAGER       BEGSR
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_LAGER
     C*-------------------------------------------------------------------------
     C     DSLORT        IFNE      *BLANKS
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLANR        KYLLLA
     C                   MOVE      DSLORT        KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C*-------------------------------------------------------------------------
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKIOKZ                         OPEN KZ. FORMAT
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKCFMT                         IND.CLOSE FORMAT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN31                         RETTEN INDICAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    #CRTCD        PCRTCD                         RETURNCODE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIUSR                         IND.USER
     C     *LIKE         DEFINE    WKC001        WKMENU                         IND.USER
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT                         MSG-ART (F,I)
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9            ÜBERGABEPARAMET
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
     C                   MOVEL(P)  'TRLBBSS9'    PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           C#INIT                         SUBFILE
     C*
     C     WKPGST        IFEQ      'SCANH1'
     C                   WRITE     TRLBS901CT
     C                   ELSE
     C                   WRITE     TRLBS902CT
     C                   ENDIF
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C     WKPGST        IFEQ      'SCANH1'
     C                   WRITE     TRLBS901CT
     C                   ELSE
     C                   WRITE     TRLBS902CT
     C                   ENDIF
     C*
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
     C/COPY TAMP/QCPYSRC,CHTRTP
     C/COPY TAMP/QCPYSRC,CHLBBS
     C/COPY TAMP/QCPYSRC,CHLBRS
     C/COPY TAMP/QCPYSRC,CHTEIL
     C/COPY TAMP/QCPYSRC,CHLBPL
     C/COPY TAMP/QCPYSRC,TRIFMT
     C/COPY TAMP/QCPYSRC,VINFO
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
