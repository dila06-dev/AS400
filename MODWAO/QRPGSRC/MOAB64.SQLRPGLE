     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2017')
      //*************************************************************************
      /TITLE  Programm für die kundenspezifischen Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2017 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: ZG 16.01.2017 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: ZG 06.04.2018 PROGRAMM VON HERRN GANG DEAKTIVIERT !!!!!
      //  Änderung: ZG 24.04.2018 Update AKKLKZ in der AFKO wurde deaktiveirt
      //            Herr Gang setzt das KZ pro Auftrag_Nr auf Ja in seinem Programm
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AB64          E DS                  INZ
     D WA64          E DS                  INZ

     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ

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
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKSTMT          S           1000
     D WKLANR          S                   LIKE(SQLANR)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WA64TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA64TSTP                          LIKE(WA64TSTP)

      //--------------------------------------------------
      // Program name: C_TRKOMLFSR
      //--------------------------------------------------
     D C_TRKOMLFSR...
     D                 PR                  EXTPGM('TRKOMLFSR')

     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       SELECT;
       WHEN PCPGST = 'TRAF07';
       WHEN PCPGST = 'DRAB69';
       WHEN PCPGST = 'RSAB69';
       WHEN PCPGST = 'DRLBAK';
       OTHER;
         C_TRKOMLFSR();
         EXSR PRAB64;
       ENDSL;

       WKFIRM = DAFIRM;

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

         KYAKFI = DAFIRM;                                                         // AFKO
         KYTAFI = DAFIRM;  // TRPA
         KYTPFI = DAFIRM;  // TRTP
         KYTPSP = DASPCD;  // TRTP

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         CLEAR RTTREND;
         RTTRNDFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

         WA64LOCK = *BLANK;
         WA64JNAM = DAJNAM;
         WA64JDAT = %DEC(%DATE():*ISO);
         WA64JZEI = %DEC(%TIME());
         WA64USER = DAUSER;
         WA64PROG = DAPROG;
         WA64BIBL = WKCHPL;
         C_EXTSTP(WA64TSTP);
         WA64ERUS = DAUSER;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob alle Positionen                                        ***
       //*************************************************************************
       BEGSR PRAB64;

         WKSTMT = 'SELECT * FROM AB64';
         WKSTMT = %TRIM(WKSTMT) +
         ' ORDER BY SQFIRM, SQAFJJ, SQAFNR, SQAFPO, SQUPOS';
         WKSTMT = %TRIM(WKSTMT) +  ' FOR FETCH ONLY ';

         EXEC SQL
           PREPARE SQAB64 FROM :WKSTMT;

         EXEC SQL
          DECLARE AB64KY SCROLL CURSOR FOR SQAB64;

         EXEC SQL
          OPEN AB64KY;

         SQLCOD = *ZERO;
         WKLANR = *LOVAL;
         KYAKJH = *ZERO;
         KYAKAF = *BLANK;

         DOW SQLCOD = *ZERO;

           EXEC SQL
            FETCH NEXT FROM AB64KY INTO :AB64;

           IF SQLCOD <> *ZERO;
             LEAVE;
           ENDIF;

           IF SQAFJJ <> KYAKJH
             OR SQAFNR <> KYAKAF;
             KYAKJH = SQAFJJ;
             KYAKAF = SQAFNR;
             CHIDS = '01C';
             EXSR CHAFKO;
             WKLANR = SQLANR;
           ENDIF;

           IF AKKLKZ <> DAJNKZ
             AND SQLANR <> WKLANR;
           //EXSR UAFKO;
           ENDIF;

           EXSR WWA64;
         ENDDO;


         CLEAR RTTREND;
         RTTRNDFENR = WKFENR;

       ENDSR;

       //*************************************************************************
       //**  SR-UAFKO     UPDATEN STATUS IN AUFTRAGSKOPF                       ***
       //*************************************************************************
       BEGSR UAFKO;

       KYAKJH = AKAFJJ;
       KYAKAN = AKAFNN;
       CHIDS = '03CU';
       EXSR CHAFKO;

       AKKLKZ = DAJNKZ;

       AKJNAM = DAJNAM;
       AKPROG = WKCHPN;
       AKBIBL = WKCHPL;
       AKUSER = DAUSER;
       AKJZEI = %DEC(%TIME());
       AKJDAT = %DEC(%DATE:*ISO);

       CHIDS = '03U';
       EXSR CHAFKO;

       ENDSR;

       //*************************************************************************
       //**  SR-WWAOK     UPDATEN WAOK                                         ***
       //*************************************************************************
       BEGSR WWA64;


         EXEC SQL
         INSERT INTO WA64
         (WA64FIRM,WA64AFAT,WA64AFJJ,WA64AFNR,WA64AFPO,
          WA64UPOS,WA64KDNR,WA64VSBD,WA64LIBD,
          WA64VPEI,WA64LANR,WA64LORT,WA64KMJK,WA64KMTE,
          WA64TENR,WA64MEIN,WA64TART,WA64OFMG,
          WA64LAMG,WA64UMMG,WA64FWMG,WA64KMLA,WA64LMLO,
          WA64LIAR,WA64SABE,WA64GWNT,WA64VOLU,
          WA64WKNR,WA64A115,WA64A215,WA64A315,WA64A415,
          WA64A515,WA64KMJJ,WA64KMNR,WA64STAT,
          WA64LFTE,WA64FREI,
          WA64LOCK,WA64JNAM,WA64JDAT,WA64JZEI,WA64USER,
          WA64PROG,WA64BIBL,WA64TSTP,WA64ERUS)
         VALUES
         (:SQFIRM,:SQAFAT,:SQAFJJ,:SQAFNR,:SQAFPO,
         :SQUPOS,:SQKDNR,:SQVSBD,:SQLIBD,
         :SQVPEI,:SQLANR,:SQLORT,:SQKMJK,:SQKMTE,
         :SQTENR,:SQMEIN,:SQTART,:SQOFMG,
         :SQLAMG,:SQUMMG,:SQFWMG,:SQKMLA,:SQLMLO,
         :SQLIAR,:SQSABE,:SQGWNT,:SQVOLU,
         :SQWKNR,:SQA115,:SQA215,:SQA315,:SQA415,
         :SQA515,:SQKMJJ,:SQKMNR,:SQSTAT,
         :SQLFTE,:SQFREX,
         :WA64LOCK,:WA64JNAM,:WA64JDAT,:WA64JZEI,:WA64USER,
         :WA64PROG,:WA64BIBL,:WA64TSTP,:WA64ERUS);

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHAFKO
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,PRFIRMFIRM
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
