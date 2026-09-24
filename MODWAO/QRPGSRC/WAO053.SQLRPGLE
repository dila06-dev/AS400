     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2014')
      //*************************************************************************
      /TITLE  BWAE-Sätze mit Lieferantenpreise
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 15.10.2014 für Kunde Dometic Projekt 10797
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Programm für die Ermittlung BWAE-Sätze mit Lieferantenpreisen
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D WAOV          E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
      //
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
      //
     D BBEK          E DS                  INZ
     D KYBBEK        E DS                  INZ
      //
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
      //
     D BWAE          E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
      //
     D EXPRKO01      E DS                  INZ
     D RTPRKO01      E DS                  INZ
      //
     D EXTREND       E DS
     D RTTREND       E DS
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
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
     D WKSTMT          S           1000    VARYING
     D WKTRPAAUAT      S                   LIKE(EKBEAT)
     D WKWACD          S                   LIKE(AEWACD)
     D WKLFNR          S                   LIKE(LFLFNR)
     D WKWEJJ          S                   LIKE(AEWEJJ)
     D WKWENR          S                   LIKE(AEWENR)
     D WKWEDA          S                   LIKE(AEWEDA)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)

      //--------------------------------------------------
      // Program name: C_ERPRKO
      // Purpose:
      // Returns:
      // Parameter:      #EXPRKO01
      // Parameter:      #RTPRKO01
      //--------------------------------------------------
     D C_ERPRKO...
     D                 PR                  EXTPGM('ERPRKO')
     D  #EXPRKO01                          LIKEDS(EXPRKO01)
     D  #RTPRKO01                          LIKEDS(RTPRKO01)

     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND

      /FREE
       EXSR UEBTREND;

       //
       IN EXTRLD;

       SELECT;
       WHEN WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDSL;

       EXSR EXJOBA;

       SELECT;
       WHEN WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDSL;

       EXSR VORLAUF;
       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************

       EXSR DWAOV;

       EXSR VBWAE;

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

       KYTAFI = DAFIRM;                                                         // TRPA
       KYTPFI = DAFIRM;                                                         // TRTP
       KYTEFI = DAFIRM;                                                         // TEIL
       KYLFFI = DAFIRM;                                                         // LIEF
       KYEPFI = DAFIRM;                                                         // BBEP
       KYEKFI = DAFIRM;                                                         // BBEK

       KYTPSP = DASPCD;                                                         //TRTP

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;


       PCPGST = EXTRNDPGST;

       KOMDS = EXTRNDKEYB;

       MONITOR;
         WKWEJJ = %INT(%SUBST(KOMDS:1:4));
       ON-ERROR;
         WKWEJJ = *ZERO;
       ENDMON;

       WKWENR = %SUBST(KOMDS:5:6);

       MONITOR;
         WKWEDA = %INT(%SUBST(KOMDS:11:8));
       ON-ERROR;
         WKWEDA = *ZERO;
       ENDMON;

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
       //**  LÖSCHEN WAOV                                                      ***
       //*************************************************************************
       BEGSR DWAOV;


       WKFENR = '0000';

       WKSTMT = 'DELETE FROM WAOV WHERE WAOVFIRM = ' +
                '''' + DAFIRM + '''';

       IF WKWEDA <> *ZERO;
         WKSTMT += ' AND WAOVWEDA >= ' +
                   %CHAR(WKWEDA);
       ENDIF;

       IF WKWEJJ <> *ZERO AND
          WKWENR <> *BLANKS;
         WKSTMT += ' AND WAOVWEJJ = ' +
                   %CHAR(WKWEJJ) +
                   ' AND WAOVWENR = ' +
                   '''' + WKWENR + '''';
       ENDIF;

       EXEC SQL
         PREPARE SQWAOV FROM :WKSTMT;

       EXEC SQL
         EXECUTE SQWAOV;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG BWAE                                                 ***
       //*************************************************************************
       BEGSR VBWAE;


       WKSTMT = 'SELECT * FROM BWAE WHERE AEFIRM = ' +
                '''' + DAFIRM + '''';

       IF WKWEDA <> *ZERO;
         WKSTMT += ' AND AEWEDA >= ' +
                   %CHAR(WKWEDA);
       ENDIF;

       IF WKWEJJ <> *ZERO AND
          WKWENR <> *BLANKS;
         WKSTMT += ' AND AEWEJJ = ' +
                   %CHAR(WKWEJJ) +
                   ' AND AEWENR = ' +
                   '''' + WKWENR + '''';
       ENDIF;

       //WKSTMT += ' AND AETENR = ' +
       //          ''''+ '9102200032' + '''' +
       //          ' AND AELFNR = ' +
       //          '''' + '90174' + '''' +
       //          ' AND AEWENR = ' +
       //          '''' + '116610' + '''';
       EXEC SQL
         PREPARE SQBWAE FROM :WKSTMT;

       EXEC SQL
         DECLARE BWAECU CURSOR FOR SQBWAE;

       EXEC SQL
         OPEN BWAECU;

       DOW SQLCOD = *ZERO;

         EXEC SQL
           FETCH BWAECU INTO :BWAE;
         IF SQLCOD <> *ZERO;
           LEAVE;
         ENDIF;

         CLEAR WAOV;

         WKWACD = AEWACD;

         SELECT;
           WHEN AEWACD = 'EUR';
             WKWACD = 'USD';
           WHEN AEWACD = 'USD';
             WKWACD = 'EUR';
         ENDSL;

         KYEKJH = AEBEJJ;
         KYEKBE = AEBENR;
         CHIDS = '01C';
         EXSR CHBBEK;
         IF WKFENR <> *ZERO;
           ITER;
         ENDIF;

         KYEPJH = AEBEJJ;
         KYEPBE = AEBENR;
         KYEPPO = AEBEPO;
         CHIDS = '01C';
         EXSR CHBBEP;
         IF WKFENR <> *ZERO;
           ITER;
         ENDIF;

         KYTENR = AETENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         IF WKFENR <> *ZERO;
           ITER;
         ENDIF;

         KYLFNR = AELFNR;
         CHIDS = '01C';
         EXSR CHLIEF;
         IF WKFENR <> *ZERO;
           ITER;
         ENDIF;

         WKLFNR = LFLFNR;

         EXSR TRPREI;

         WAOVFIRM = DAFIRM;
         WAOVWEJJ = AEWEJJ;
         WAOVWENR = AEWENR;
         WAOVBEJJ = AEBEJJ;
         WAOVBENR = AEBENR;
         WAOVBEPO = AEBEPO;
         WAOVWEDA = AEWEDA;
         WAOVTENR = AETENR;
         WAOVBETE = EPBETE;
         WAOVWACD = AEWACD;
         WAOVLFNR = LFLFNR;
         WAO1EZPR = RTPRKOPREI;
         WAO1PDIM = RTPRKOPDIM;
         WAO1WACD = WKWACD;

         IF LFKOLF <> *BLANKS;
           IF LFKOLF <> LFLFNR;
             WKLFNR = LFKOLF;
             EXSR TRPREI;
               WAOVKOLF = WKLFNR;
               WAO2EZPR = RTPRKOPREI;
               WAO2PDIM = RTPRKOPDIM;
               WAO2WACD = WKWACD;
           ENDIF;
         ENDIF;

         IF TESTLF <> *BLANKS;
           WKLFNR = TESTLF;
           EXSR TRPREI;
           WAOVSTLF = WKLFNR;
           WAO3EZPR = RTPRKOPREI;
           WAO3PDIM = RTPRKOPDIM;
           WAO3WACD = WKWACD;
         ENDIF;

         EXEC SQL
           INSERT INTO WAOV VALUES(:WAOV);

       ENDDO;

       EXEC SQL
         CLOSE BWAECU;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

       WKTRPA = *ON;

       KYTATA = 'FIRM';                                             // ERMITTELN
       KYTATC = 'BBPA';                                             // BESTELLART
       KYTAPA = 'AUAT';                                             // AUSWÄRTIGE
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPAAUAT = TAPCDE;



       ENDSR;
       //*************************************************************************
       //**  TRPREI  PREIS/KONDITIONEN-FINDUNGSPROGRAMM                        ***
       //*************************************************************************
       BEGSR TRPREI;


       // Ermitteln Preis/Konditionen aus Preis-Zuordnung

       CLEAR EXPRKO01;
       CLEAR RTPRKO01;

       // Ermitteln Preis/Konditionen aus Preis-Zuordnung

       CLEAR EXPRKO01;
       CLEAR RTPRKO01;

       EXPRKOVPKZ = 'B';
       EXPRKOPRAR = EPPRAR;
       EXPRKOLAND = LFLAND;
       EXPRKOPRGR = TEPRGR;
       EXPRKOMAGR = TEMAGR;
       %SUBST(EXPRKOVKGB:1:2) = TELPGR;                                         // LF-PREIS-GRP./VK-
       //EXPRKOGBAT = DSGBAT;

       EXPRKOPOLZ = LFPOLZ;

       EXPRKOKDNR = WKLFNR;

       EXPRKOTENR = TETENR;
       EXPRKOBLGA = EKBEAT;
       EXPRKOWACD = WKWACD;

       EXPRKODATE = EPBETE;

       DUN112 = AELSMG * TEGWNT;                                                // GEWICHT NETTO

       KYTPTA = 'GDIM';                                                         // ERMITTELN GEWICHT
       KYTPTC = TEGWDI;                                                         // DIMENSION
       CHIDS = '01C';
       EXSR CHTRTP;
       IF TPTNUM = *ZERO;
         TPTNUM = 1;
       ENDIF;
       EVAL(H) DUN112 /= TPTNUM;

       EXPRKOGWNT = DUN112;
       EXPRKOMENG = AELSMG;
       EXPRKOMEIN = TEMPEK;

       IF EKBEAT = WKTRPAAUAT                                                   // BESTELLART =
         AND WKTRPAAUAT <> *BLANK;                                              // AUSW.BEARBEITUNG
         EXPRKOAWKZ = DAJNKZ;
       ELSE;
         EXPRKOAWKZ = DANEKZ;
       ENDIF;

       EXPRKOWKNR = AEWKNR;
       //EXPRKOGEBI = DSGEBI;
       EXPRKOLANR = AEBWLA;
      /END-FREE
     C*                  Z-ADD     DSGBGR        EXPRKOLFBR                     LIEFERBREITE

      /FREE
       CALLP(E) C_ERPRKO(EXPRKO01:RTPRKO01);
       *IN99 = %ERROR;
       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBBEK
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRDATE

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
