     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2019')
      //*************************************************************************
      /TITLE  XML-Ausgabe Modifikationen
      //*************************************************************************
      //  Copyright 2019 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 31.07.2019 DOMETIC Projekt 15085-01.
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //
      //*************************************************************************
      //  Dieses Programm erstellt die XML-Blöcke der Modifikationen zur
      //  Bestellung. Es erhält die XML- sowie Schlüsseldaten aus dem
      //  aufrufenden Programm XLBBEK01. XML-Blöcke werden direkt im
      //  Hauptspeicher hinzugefügt
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL

     D WRK             S              3    DIM(20) INZ

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BBEK          E DS
     D BBEP          E DS

     D LIEF          E DS

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXADRE        E DS                  INZ
     D RTADRE        E DS                  INZ

     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ

     D EXTREND       E DS
     D E1TREND       E DS

     D E1XLST        E DS

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
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D LIEFSPCD        S              1
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKFENR          S              4
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKIOKZ          S              1
     D WKI000          S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D I1              S              3S 0
     D I2              S              3S 0
     D I3              S              3S 0
     D I4              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPROG          S                   LIKE(DAPROG)
     D WKBIBL          S                   LIKE(DABIBL)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFTPFI          S                   LIKE(KYTPFI)
     D OFTPSP          S                   LIKE(KYTPSP)
     D OFTPTA          S                   LIKE(KYTPTA)
     D OFTPTC          S                   LIKE(KYTPTC)
     D ##TRNDBEJJ      S                   LIKE(EPBEJJ)
     D ##TRNDBENR      S                   LIKE(EPBENR)
     D WKDRFLPGNA      S                   LIKE(EXDRFLPGNA)
     D WKDRFLKOPI      S                   LIKE(EXDRFLKOPI)
     D WKDRFLLDNR      S                   LIKE(EXDRFLLDNR)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    E1TREND
     C                   PARM                    BBEK
     C                   PARM                    BBEP
     C                   PARM                    LIEF
     C                   PARM                    EXXMLDRFL

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       SELECT;
       WHEN EXDRFLBLOC = 'MODWAOBBEPWERK    ';
         EXSR XLBBEPWERK;
       WHEN EXDRFLBLOC = 'MODWAOWERKADRE';
         EXSR XLWERKADRE;
       ENDSL;

       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         MONITOR;
           ##TRNDBEJJ = %INT(%SUBST(EXTRNDKEYB:01:04));
         ON-ERROR *PROGRAM;
           ##TRNDBEJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         ##TRNDBENR = %SUBST(EXTRNDKEYB:05);

         LIEFSPCD = %SUBST(EXTRNDDATE:80);
         WKDRFLPGNA = EXDRFLPGNA;
         WKDRFLKOPI = EXDRFLKOPI;
         WKDRFLLDNR = EXDRFLLDNR;

       ENDSR;

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

         KYTAFI = DAFIRM;     // TRPA
         KYWRFI = DAFIRM;     // WERK

         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;

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
       //**  Ausgabe WERK auf Positionsebene                                   ***
       //*************************************************************************
       BEGSR XLBBEPWERK;

         KYWRNR = E1TRNDAL01;
         CHIDS = '01C';
         EXSR CHWERK;
         IF CHI(5) = 'N';
           LEAVESR;
         ENDIF;

         CLEAR EXADRE;
         EXADNAM1 = WRNAM1;
         EXADNAM2 = WRNAM2;
         EXADNAM3 = WRNAM3;
         EXADSTRA = WRSTRA;
         EXADHSNR = WRHSNR;
         EXADPOLD = WRPOLD;
         EXADPOLZ = WRPOLZ;
         EXADWORT = WRWORT;
         EXADPOFA = WRPOFA;
         EXADPOLN = WRPOLN;
         EXADLAND = WRLAND;
         EXADSPCD = LIEFSPCD;
         EXADAART = 'ADVS';
         EXSR TRADRE;

         WKDRFLPGST = 'ADDBLOC';
         WKDRFLBLOC = 'MODWAOBBEPWERK    ';
         EXSR ERAUFRDRFL;

         I1 = %LOOKUP(WRWKNR:WRK);
         IF I1 = *ZERO;
           I1 = %LOOKUP(*BLANK:WRK);
           IF I1 > *ZERO;
             WRK(I1) = WRWKNR;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe Adressdaten der zugeordneten Werke (Bestell-Lieferanschriften)
       //*************************************************************************
       BEGSR XLWERKADRE;

         FOR I1 = 1 TO 20;

           IF WRK(I1) = *BLANK;
             LEAVE;
           ENDIF;

           KYWRNR = WRK(I1);
           CHIDS = '01C';
           EXSR CHWERK;
           IF CHI(5) = 'N';
             LEAVE;
           ENDIF;

           CLEAR EXADRE;
           EXADNAM1 = WRNAM1;
           EXADNAM2 = WRNAM2;
           EXADNAM3 = WRNAM3;
           EXADSTRA = WRSTRA;
           EXADHSNR = WRHSNR;
           EXADPOLD = WRPOLD;
           EXADPOLZ = WRPOLZ;
           EXADWORT = WRWORT;
           EXADPOFA = WRPOFA;
           EXADPOLN = WRPOLN;
           EXADLAND = WRLAND;
           EXADSPCD = LIEFSPCD;
           EXADAART = 'ADVS';
           EXSR TRADRE;

           WKDRFLPGST = 'ADDBLOC';
           WKDRFLBLOC = 'MODWAOWERKADRE';
           EXSR ERAUFRDRFL;
         ENDFOR;

       ENDSR;

       //*************************************************************************
       //**  XML Erzeugen                                                      ***
       //*************************************************************************
       BEGSR ERAUFRDRFL;

         EXSR INIDRFL;

         EXDRFLPGNA = WKDRFLPGNA;
         EXDRFLPGST = WKDRFLPGST;
         EXDRFLBLOC = WKDRFLBLOC;
         EXDRFLSPCD = LIEFSPCD;
         EXDRFLKOPI = WKDRFLKOPI;

         EXDRFLDANA = 'BBEK';
         EXDRFLJAHR = ##TRNDBEJJ;
         EXDRFLNMKR = ##TRNDBENR;
         EXDRFLFIRM = DAFIRM;
         EXDRFLWKNR = EKWKNR;
         EXDRFLKDLI = EKLFNR;
         EXDRFLBLGA = EKBEAT;
         EXDRFLSABE = EKSABE;
         EXDRFLLDNR = WKDRFLLDNR;

         SELECT;

         WHEN EXDRFLBLOC = 'MODWAOBBEPWERK    ';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'WERK    ';
           EXDRFLDATA = WERK;
           %OCCUR(EXXMLFILE) += 1;
           EXDRFLFILE = 'WERKADRE';
           EXDRFLDATA = RTADRE;

         WHEN EXDRFLBLOC = 'MODWAOWERKADRE';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'WERK    ';
           EXDRFLDATA = WERK;
           %OCCUR(EXXMLFILE) += 1;
           EXDRFLFILE = 'WERKADRE';
           EXDRFLDATA = RTADRE;
         ENDSL;

         EXSR ERDRFL;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWERK
      /COPY QCPYSRC,ERDRFL
      /COPY QCPYSRC,TRADRE
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
