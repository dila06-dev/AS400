     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
      //*************************************************************************
      /TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: JK 14.05.2024 Dometic - Unterwegslieferungen Pj 240060
      //  -----------------------------------------------------------------------
      //  Änderung: GS 03.07.2024 Korrektur Update auf BBEP
      //  Änderung: JK 27.08.2024 Korrektur Update auf BBEP - status 43 obwohl WE lager <> ziellager
      //            aus datei BBPL (case #03841280)
      //  Änderung: GS/JK 19.05.2025 Case 04307212 Status 60 und 90 entfällt. Es gibt nur noch
      //            maximal Status 43
      //*************************************************************************
      //
      //  Programm zum Update des Bestellpositionsstatus
      //  vergebene status:
      //  40 = WE auf das unterwegslager erfolgt ("vollieferung")
      //  41 = WE auf das unterwegslager erfolgt ("vollieferung") und rechnung erfasst
      //       aber noch nicht an die FiBu übergeben
      //  42 = WE auf das unterwegslager erfolgt ("vollieferung") und rechnung erfasst
      //       und an die FiBu übergeben
      //  43 = WE auf das eigentliche Ziellager erfolgt (entweder direkt oder per umlagerung)
      //  60 und 90 entfallen. (JK/GS 19.05.2025 siehe o.g. Case)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************

     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D XXBBEP        E DS                  EXTNAME(BBEP) PREFIX(XX)

     D BBPL          E DS                  INZ
     D KYBBPL        E DS                  INZ

     D BKOK          E DS                  INZ
     D KYBKOK        E DS                  INZ

     D BLPO          E DS                  INZ
     D KYBLPO        E DS                  INZ

     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS

     D EXTREND       E DS
     D RTTREND       E DS

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKIFMT          S              2
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D WKIN30          S              1
     D WKIN31          S              1
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D EXTRNDLFNR      S             10
     D EXTRNDVSBD      S              3
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKBBEPBEST      S                   LIKE(EPBEST)

     D WKBBEPKY        DS                  INZ
     D WKBBEPBEJJ                          LIKE(EPBEJJ)
     D WKBBEPBENR                          LIKE(EPBENR)
     D WKBBEPBEPO                          LIKE(EPBEPO)

      /FREE

       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       EXSR ANFANG;
       EXSR DCL;
       EXSR OPN;
       EXSR FTC;
       RETURN;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         DAFIRM = '01';

         KYEPFI = DAFIRM;  // BBEP
         KYBBPLFIRM = DAFIRM;  // BBPL
         KYBLPOFIRM = DAFIRM;  // BLPO
         KYOKFI = DAFIRM;  // BKOK
         KYAEFI = DAFIRM;  // BWAE

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMETER EXTREND                        ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         EXTRNDKEYB ='202412463 0171';

         // WKBBEPKY = EXTRNDKEYB;

         CLEAR RTTREND;
         RTTRNDFENR = '0000';

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  KUNDENSPEZIFISCHE PRÜFUNG  - Update Bestellstatus                 ***
       //*************************************************************************
       BEGSR UPBBEP;

         WKFENR = '0000';
         KYEPFI = DAFIRM;
         KYEPJH = XXEPBEJJ;
         KYEPBE = XXEPBENR;
         KYEPPO = XXEPBEPO;

         CHIDS = '01C ';
         EXSR CHBBEP;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         Exsr EBBPL;

         // BBPL satz muss existieren und Splitt muss an sein
         IF WKFENR <> *ZERO Or BBPLSPLT <> *ON;
           LEAVESR;
         ENDIF;

         Exsr EBWAE;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR EBLPO;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR EBKOK;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         // update BBEP mit dem ermittelten Status
         WKFENR = '0000';
         KYEPJH = XXEPBEJJ;
         KYEPBE = XXEPBENR;
         KYEPPO = XXEPBEPO;

         CHIDS = '01CU';
         EXSR CHBBEP;

         IF EPBEST <> WKBBEPBEST;
           EPPROG ='RGBBEPSTAT';
           EPJZEI = %DEC(%TIME());
           EPJDAT = %DEC(%DATE():*ISO);
         ENDIF;

         EPBEST = WKBBEPBEST;
         CHIDS = '01U';
         EXSR CHBBEP;

       ENDSR;
       //*************************************************************************
       //**  BBPL ermitteln                                                    ***
       //*************************************************************************
       BEGSR EBBPL;

         KYBBPLBEAT = XXEPBEAT;
         CHIDS = '01C';
         EXSR CHBBPL;

       ENDSR;
       //*************************************************************************
       //**  BWAE ermitteln                                                    ***
       //*************************************************************************
       BEGSR EBWAE;

         KYAEJH = XXEPBEJJ;
         KYAEBE = XXEPBENR;
         KYAEPO = XXEPBEPO;
         CHIDS = '01+C';
         EXSR CHBWAE;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         IF AEFIRM <> KYAEFI or
            AEBEJJ <> KYAEJH or
            AEBENR <> KYAEBE or
            AEBEPO <> KYAEPO;
           WKFENR = '0031';
           LEAVESR;
         ENDIF;

         // WE erfasst für Lager = unterwegslager
         IF AEBWLA = BBPLWELA OR AEBWLA = BBPLWELQ;
           WKBBEPBEST = '40';
           LEAVESR;
         ENDIF;

         // WE erfasst für Lager = ziellager
         // IF AEBWLA = BBPLUMLA OR AEBWLA = BBPLUMLQ;
         WKBBEPBEST = '43';
         //  LEAVESR;
         // ENDIF;

         // WE erfasst für Lager <> ziellager
         // IF AEBWLA <> BBPLUMLA and AEBWLA <> BBPLUMLQ;
         //   WKBBEPBEST = '43';
         //   LEAVESR;
         // ENDIF;


       ENDSR;
       //*************************************************************************
       //**  BLPO ermitteln                                                    ***
       //*************************************************************************
       BEGSR EBLPO;

         // Beleg erfasst ?
         If AEBLJJ <> 0 and AEBLGN <> *BLANK;
           KYBLPOBLJJ = AEBLJJ;
           KYBLPOBLNR = AEBLGN;
           KYBLPOWEJJ = AEWEJJ;
           KYBLPOWENR = AEWENR;
           CHIDS = '01+';
           EXSR CHBLPO;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
           If KYBLPOFIRM <> AEFIRM or
              KYBLPOBLJJ <> AEBLJJ or
              KYBLPOBLNR <> AEBLGN or
              KYBLPOWEJJ <> AEWEJJ or
              KYBLPOWENR <> AEWENR;
              WKFENR = '0031';
              LEAVESR;
           ENDIF;
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  BKOK ermitteln                                                    ***
       //*************************************************************************
       BEGSR EBKOK;

         // Beleg erfasst ?
         If AEBLJJ <> 0 and AEBLGN <> *BLANK;
           KYOKBA = 'RE';
           KYOKJJ = AEBLJJ;
           KYOKBE = AEBLGN;
           CHIDS = '01C';
           EXSR CHBKOK;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

           // BKOK status 30 oder kleiner --> noch nicht in schilling
           If OKOKST <= '30';
             If WKBBEPBEST = '40';
               WKBBEPBEST = '41';
             ENDIF;
             If WKBBEPBEST = '43';
          //   WKBBEPBEST = '60';
             ENDIF;
           ELSE;
             If WKBBEPBEST = '40';
               WKBBEPBEST = '41';
             ENDIF;
             If WKBBEPBEST = '43';
          //   WKBBEPBEST = '60';
             ENDIF;
           // beleg in FiBu = status = 99
             If WKBBEPBEST = '41';
               WKBBEPBEST = '42';
             ENDIF;
             If WKBBEPBEST = '42'and AEBWLA = BBPLUMLA OR AEBWLA = BBPLUMLQ;
               WKBBEPBEST = '43';
             ENDIF;
         //  If WKBBEPBEST = '60';
         //    WKBBEPBEST = '90';
         //  ENDIF;
           ENDIF;
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  cursor für auswahl der BBEP Daten                                 ***
       //*************************************************************************
       BEGSR DCL;
         EXEC SQL Declare C Cursor for
         select * from bbep where
           epfirm = '01'
           and epbest = '40' and (epbeat = '100'
           or epbeat = '105'
           or epbeat = '106'
           or epbeat = '910'
           or epbeat = '930')
           and epjdat > 20240900;

       ENDSR;
       //*************************************************************************
       //**  Open des cursors                                                  ***
       //*************************************************************************
       BEGSR OPN;
         EXEC SQL
           Open C;
       ENDSR;
       //*************************************************************************
       //**  lesen des cursors                                                 ***
       //*************************************************************************
       BEGSR FTC;
         DOW SQLCOD = 0;
           EXEC SQL
             Fetch C Into :XXBBEP;

           // Update des Bestellpositionsstatus per Aufruf MOBBEPSTAT
           IF  SQLCOD = 0;
             // Update BBEP
             EXSR UPBBEP;

           ENDIF;
         ENDDO;
       ENDSR;

       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBBPL
     C/COPY QCPYSRC,CHBKOK
     C/COPY QCPYSRC,CHBLPO
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
