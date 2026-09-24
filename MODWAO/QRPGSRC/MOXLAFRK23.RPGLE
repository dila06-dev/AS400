     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2021')
      //*************************************************************************
      /TITLE  XML-Ausgabe Modifikationen
      //*************************************************************************
      //  Copyright 2021 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 29.04.2021 DOMETIC Projekt 16515-01
      //  -----------------------------------------------------------------------
      //  Änderung: PH 21.06.2023 DOMETIC Projekt 230321-01. Ermittlung und Ausgabe eines OCR-Codes
      //            für nordische Länder (##OCR_NORD im Block print_header/header/modwaoaflk bei
      //            Aufruf aus XLAFRK01 bzw. im Block  print_header/header/modwaokopf bei Aufruf
      //            aus XLAFRK02).
      //*************************************************************************
      //  Dieses Programm erstellt die XML-Blöcke der Modifikationen zur
      //  Rechnung. Es erhält die XML- sowie Schlüsseldaten aus dem
      //  aufrufenden Programm XLAFRK0x. XML-Blöcke werden direkt im
      //  Hauptspeicher hinzugefügt
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D PINTRDS         DS
     D PINTR                          1    DIM(27)                              INTERNE NUMMER

     D PINT1DS         DS
     D PINT1                          1    DIM(9)                               INTERNE NUMMER 2

     D W10DS           DS
     D W10                            1    DIM(10)

     D/COPY QCPYSRC,EXXMLDRFL

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFLK          E DS
     D AFLP          E DS
     D AFRK          E DS

     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D ZABD          E DS                  INZ
     D KYZABD        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXAFRK90      E DS                  INZ

     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ

     D EXTREND       E DS
     D E1TREND       E DS

     D E1XLST        E DS                  INZ

      //*************************************************************************
      //**     Konstantendefinition                                           ***
      //*************************************************************************
     D PF0             C                   CONST('0946827135')
     D PF1             C                   CONST('9468271350')
     D PF2             C                   CONST('4682713509')
     D PF3             C                   CONST('6827135094')
     D PF4             C                   CONST('8271350946')
     D PF5             C                   CONST('2713509468')
     D PF6             C                   CONST('7135094682')
     D PF7             C                   CONST('1350946827')
     D PF8             C                   CONST('3509468271')
     D PF9             C                   CONST('5094682713')

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
     D KUNDSPCD        S              1
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
     D WKTRPABRTT      S              1
     D DIGITS          S             30
     D ##OCRB2         S             53
     D PTOCR_NORD      S             21
     D I1              S              3S 0
     D I2              S              3S 0
     D I3              S              3S 0
     D DO_X            S              3S 0
     D DIGIT           S              3U 0
     D DIGITS_LEN      S              3U 0
     D PARITY          S              3U 0
     D SUM             S              5U 0
     DLUHN_CHECKDIGIT  S              1P 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPROG          S                   LIKE(DAPROG)
     D WKBIBL          S                   LIKE(DABIBL)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D OFTPFI          S                   LIKE(KYTPFI)
     D OFTPSP          S                   LIKE(KYTPSP)
     D OFTPTA          S                   LIKE(KYTPTA)
     D OFTPTC          S                   LIKE(KYTPTC)
     D ##TRNDRGJJ      S                   LIKE(ALRGJJ)
     D ##TRNDRGNR      S                   LIKE(ALRGNR)
     D WKREDA          S                   LIKE(RKREDA)
     D WKRELD          S                   LIKE(EXDRFLLDNR)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    E1TREND
     C                   PARM                    AFRK
     C                   PARM                    AFLK
     C                   PARM                    AFLP
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
       WHEN PCPGST = 'EOCRB2';
         EXSR EOCRB2;
       WHEN EXDRFLBLOC = 'MODWAOHEADER';
         EXSR XLKOPF;
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
           ##TRNDRGJJ = %INT(%SUBST(EXTRNDKEYB:01:04));
         ON-ERROR *PROGRAM;
           ##TRNDRGJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         ##TRNDRGNR = %SUBST(EXTRNDKEYB:05);

         MONITOR;
           WKREDA = %INT(%SUBST(EXTRNDKEYB:11:08));
         ON-ERROR *PROGRAM;
           WKREDA = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         KUNDSPCD = %SUBST(EXTRNDDATE:80);

         WKRELD = EXDRFLLDNR;

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

         KYKDEWFIRM = DAFIRM; // KDEW
         KYTAFI = DAFIRM;     // TRPA

         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;

         KYZBFI = DAFIRM;     // ZABD

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
       //**  Ausgabe KOPF                                                      ***
       //*************************************************************************
       BEGSR XLKOPF;

         EXSR EROCR_NORD;

         SELECT;
         WHEN EXDRFLPGNA = 'XLAFRK01';
           WKDRFLPGST = 'ADDFIEL';
           WKDRFLBLOC = 'MODWAOAFLK';
         WHEN EXDRFLPGNA = 'XLAFRK02';
           WKDRFLPGST = 'ADDFIEL';
           WKDRFLBLOC = 'MODWAOKOPF';
         OTHER;
           WKDRFLPGST = 'ADDBLOC';
           WKDRFLBLOC = 'MODWAOHEADER';
         ENDSL;
         EXSR ERAUFRDRFL;

       ENDSR;

       //*************************************************************************
       //** Ermitteln OCR-Code KDNR+RGJJ+RGNR+Prüfziffer nach dem Luhn Algorithmus
       //*************************************************************************
       BEGSR EROCR_NORD;

        PTOCR_NORD = *BLANK;

         // Vorbereiten PTOCR_NORD
         MONITOR;
           DUN100 = %INT(%TRIM(RKKDNR));
         ON-ERROR *PROGRAM;
           PTOCR_NORD = *BLANK;
           EXSR RMVMONMSG;
           LEAVESR;
         ENDMON;

         MONITOR;
           DUN100 = %INT(%TRIM(##TRNDRGNR));
         ON-ERROR *PROGRAM;
           PTOCR_NORD = *BLANK;
           EXSR RMVMONMSG;
           LEAVESR;
         ENDMON;

         PTOCR_NORD = %TRIM(RKKDNR)
         + %EDITC(##TRNDRGJJ :'X') + %TRIM(##TRNDRGNR);

         DIGITS = PTOCR_NORD;
         EXSR ERDIGITSLUHN;
         PTOCR_NORD = DIGITS;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln OCR-Code auf Basis KDEW.KDEWFL01 (Aufruf aus XLAFRK90)  ***
       //*************************************************************************
       BEGSR EOCRB2;

         IF EXDRFLWKNR <> '005';
           CLEAR E1TRNDAL01;
           LEAVESR;
         ENDIF;

         KYKDEWKDNR = EXDRFLKDLI;
         CHIDS = '01C';
         EXSR CHKDEW;
         if CHI(5) = 'N' or KDEWFL01 = *BLANK;
           CLEAR E1TRNDAL01;
           leavesr;
         endif;

         EXRK90RGNN = E1TRNDNU01;
         EXRK90BRSU = E1TRNDNU02;
         EXRK90ZABD = E1TRNDAL01;
         CLEAR E1TREND;

         %SUBST(PINTRDS:15) = %EDITC(EXRK90RGNN: 'X');

         %SUBST(PINTRDS:21) = KDEWFL01;

         FOR I1 = 1 TO 27;
           MONITOR;
             WKN010 = %INT(PINTR(I1));
           ON-ERROR;
             WKN010 = *ZERO;
             PINTR(I1) = '0';
             EXSR RMVMONMSG;
           ENDMON;
         ENDFOR;

         DUC027 = PINTRDS;
         EXSR EPRZF;
         PINTR(27) = DUC001;

         FOR I1 = 1 TO 9;
           MONITOR;
             WKN010 = %INT(PINT1(I1));
           ON-ERROR;
             WKN010 = *ZERO;
             PINT1(I1) = %EDITC(WKN010:'X');
             EXSR RMVMONMSG;
           ENDMON;
         ENDFOR;

         DUN112 = EXRK90BRSU;
         DUN102 = EXRK90BRSU;

         KYZBZA = EXRK90ZABD;
         CHIDS  = '01C';
         EXSR CHZABD;

         W99 = *BLANK;
         IF ZBPRZ1 <> *ZERO
           AND WKTRPABRTT = *OFF;
           %SUBST(W99DS:11) = '042';
         ELSE;
           %SUBST(W99DS:1) = '01';
           %SUBST(W99DS:3) = DUC010;

           DUC027 = *ZERO;
           DUC012 = W99DS;
           DUN120 = DUN120 * 10;
           DUN270 = DUN120;
           EXSR EPRZF;
           %SUBST(W99DS:13) = DUC001;
         ENDIF;

         %SUBST(W99DS:14) = '>';
         %SUBST(W99DS:15) = PINTRDS;
         %SUBST(W99DS:42) = '+ ';
         %SUBST(W99DS:44) = PINT1DS;
         %SUBST(W99DS:53) = '>';
         ##OCRB2 = W99DS;

         E1TRNDAL01 = ##OCRB2;

       ENDSR;

       //*************************************************************************
       //**  SR-EPRZF      ERMITTELN PR]FZIFFER                                ***
       //*************************************************************************
       BEGSR EPRZF;

         DUC026 = DUC027;

         I1 = 1;
         I2 = *ZERO;
         I3 = *ZERO;

         DOW I1 <= 26;

           DUC001 = %SUBST(DUC026:I1:1);

           EVAL(H) I2 = DUN010 + 1;

           SELECT;
           WHEN I3 = 0;
             W10DS = PF0;
           WHEN I3 = 1;
             W10DS = PF1;
           WHEN I3 = 2;
             W10DS = PF2;
           WHEN I3 = 3;
             W10DS = PF3;
           WHEN I3 = 4;
             W10DS = PF4;
           WHEN I3 = 5;
             W10DS = PF5;
           WHEN I3 = 6;
             W10DS = PF6;
           WHEN I3 = 7;
             W10DS = PF7;
           WHEN I3 = 8;
             W10DS = PF8;
           WHEN I3 = 9;
             W10DS = PF9;
           ENDSL;

           DUC001 = W10(I2);
           EVAL(H) I3 = DUN010;

           I1 += 1;
         ENDDO;

         MONITOR;
           EVAL(H) DUN010 = 10 - I3;
         ON-ERROR *PROGRAM;
           DUN010 = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         %SUBST(DUC027:27) =  DUC001;

       ENDSR;

       //*************************************************************************
       //** SR-ERDIGITSLUHN. Ermitteln die kompette Ziffernfolge einschließlich **
       //** der nach dem Luhn Algorithmus berechneten Prüfziffer                **
       //*************************************************************************
       BEGSR ERDIGITSLUHN;

         // Zuerst ermitteln Prüfziffer nach dem Luhn Algorithmus

         DIGITS_LEN = %LEN(%TRIM(DIGITS));

         PARITY = %REM(DIGITS_LEN: 2);

         SUM = *ZERO;

         FOR I1 = DIGITS_LEN DOWNTO 1;

           DIGIT = %INT(%SUBST(DIGITS: I1: 1));

           IF %REM(I1: 2) = PARITY;
             DIGIT *= 2;
             IF DIGIT > 9;
               DIGIT -= 9;
             ENDIF;
           ENDIF;

           SUM += DIGIT;
         ENDFOR;

         // Die nach dem Luhn Algorithmus ermittelte Prüfziffer
         LUHN_CHECKDIGIT = %REM(SUM * 9: 10);

         // Die kompette Ziffernfolge einschließlich der nach dem
         // Luhn Algorithmus berechneten Prüfziffer
         DIGITS = %TRIM(DIGITS) + %EDITC(LUHN_CHECKDIGIT:'X');

       ENDSR;

       //*************************************************************************
       //**  XML Erzeugen                                                      ***
       //*************************************************************************
       BEGSR ERAUFRDRFL;

         EXSR INIDRFL;

         EXDRFLPGST = WKDRFLPGST;
         EXDRFLBLOC = WKDRFLBLOC;
         EXDRFLSPCD = KUNDSPCD;

         EXDRFLDANA = 'AFRK';
         EXDRFLJAHR = ##TRNDRGJJ;
         EXDRFLNMKR = ##TRNDRGNR;
         EXDRFLFIRM = DAFIRM;
         EXDRFLWKNR = ALWKNR;
         EXDRFLKDLI = KLKDNR;
         EXDRFLBLGA = KLAFAT;
         EXDRFLSABE = ALSABE;
         EXDRFLLDNR = WKRELD;

         SELECT;

         WHEN EXDRFLBLOC = 'MODWAOHEADER'
           OR EXDRFLBLOC = 'MODWAOAFLK  '
           OR EXDRFLBLOC = 'MODWAOKOPF  ';
           %OCCUR(EXXMLALPH) = 1;
           EXDRFLALPF = '##OCR_NORD';
           EXDRFLALPH = PTOCR_NORD;

         ENDSL;

         EXSR ERDRFL;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'XLAFRK90';
         KYTATC = 'INTR';
         KYTAPA = 'INTR';
         CHIDS  = '01C';
         EXSR CHTRPA;
         PINTRDS = TAPTXT;

         KYTATA = 'XLAFRK90';
         KYTATC = 'INT1';
         KYTAPA = 'INT1';
         CHIDS  = '01C';
         EXSR CHTRPA;
         PINT1DS = TAPTXT;

         KYTATA = 'XLAFRK90';
         KYTATC = 'DRUCK';
         KYTAPA = 'BRUTTO';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPABRTT = TAPCDE;
         IF WKTRPABRTT <> *ON;
           WKTRPABRTT = *OFF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHKDEW
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHZABD
      /COPY QCPYSRC,ERDRFL
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
