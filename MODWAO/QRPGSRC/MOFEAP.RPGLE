     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2010')
      //*************************************************************************
      /TITLE Verwalten Datei FEAP
      //*************************************************************************
      //  Copyright 2010 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: RE 21.03.2014 Dometic Projekt 10347
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei FEAP.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FMOFEAPFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR
      //
      //*************************************************************************
      //**  INDICATORS                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
      //
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
      //
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
      //
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
      //
     D FEAP          E DS                  INZ
     D KYFEAP        E DS                  INZ
      //
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D TRPC          E DS                  INZ
      //
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
      //
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
      //
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
      //
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
      //
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
      //
     D EXFEAP        E DS
     D RTFEAP        E DS
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
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
     D WKIOKZ          S              1
     D WKI000          S              1
     D WKCFMT          S              1
     D WKTRDZZYKL      S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D WKC010          S             10
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D FL              S              4S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D W1PGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFFEAPDANA      S                   LIKE(KYFEAPDANA)
     D OFFEAPJAHR      S                   LIKE(KYFEAPJAHR)
     D OFFEAPNMKR      S                   LIKE(KYFEAPNMKR)
     D OFFEAPPOSI      S                   LIKE(KYFEAPPOSI)
     D DSFEAPDANA      S                   LIKE(FEAPDANA)
     D DSFEAPNDAN      S                   LIKE(FEAPDANA)
     D DSFEAPNJAH      S                   LIKE(FEAPJAHR)
     D DSFEAPNNMK      S                   LIKE(FEAPNMKR)
     D DSFEAPNPOS      S                   LIKE(FEAPPOSI)
     D WKPROG          S                   LIKE(RTFEAPPROG)
     D WKDANA          S                   LIKE(RTFEAPDANA)
     D WKFFLD          S                   LIKE(RTFEAPFFLD)
     D WKFEAT          S              1
     D WKFENR          S              4
     D WKINFO          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10

      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #FEAPTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #FEAPTSTP                          LIKE(FEAPTSTP)

      //--------------------------------------------------
      // Program name: C_INZDATASTR
      // Purpose:
      // Returns:
      // Parameter:      #EXDATA
      // Parameter:      #RTDATA
      //--------------------------------------------------
     D C_INZDATASTR...
     D                 PR                  EXTPGM('INZDATASTR')
     D  #EXDATA                            LIKEDS(EXDATA)
     D  #RTDATA                            LIKEDS(RTDATA)

      //--------------------------------------------------
      // Program name: C_TRFEHLCL
      // Purpose:
      // Returns:
      // Parameter:      #WKFENR
      // Parameter:      #KEYVAR
      // Parameter:      #DSJNAM
      // Parameter:      #DSUSER
      // Parameter:      #W$PA03
      // Parameter:      #W$PA04
      // Parameter:      #W$PA05
      // Parameter:      #W$PA06
      // Parameter:      #W$PA07
      //--------------------------------------------------
     D C_TRFEHLCL...
     D                 PR                  EXTPGM('TRFEHLCL')
     D  #WKFENR                            LIKE(WKFENR)
     D  #KEYVAR                            LIKE(KEYVAR)
     D  #DSJNAM                            LIKE(DSJNAM)
     D  #DSUSER                            LIKE(DSUSER)
     D  #W$PA03                            LIKE(W$PA03)
     D  #W$PA04                            LIKE(W$PA04)
     D  #W$PA05                            LIKE(W$PA05)
     D  #W$PA06                            LIKE(W$PA06)
     D  #W$PA07                            LIKE(W$PA07)

      //--------------------------------------------------
      // Program name: C_TRINFO
      // Purpose:
      // Returns:
      // Parameter:      #EXINFO
      // Parameter:      #DSINFO
      //--------------------------------------------------
     D C_TRINFO...
     D                 PR                  EXTPGM('TRINFO')
     D  #EXINFO                            LIKE(EXINFO)
     D  #DSINFO                            LIKE(DSINFO)

      //--------------------------------------------------
      // Program name: C_TRTRDZ
      // Purpose:
      // Returns:
      // Parameter:      #EXTRDN
      //--------------------------------------------------
     D C_TRTRDZ...
     D                 PR                  EXTPGM('TRTRDZ')
     D  #EXTRDN                            LIKEDS(EXTRDN)
     C     *ENTRY        PLIST
     C                   PARM                    EXFEAP
     C                   PARM                    RTFEAP

      /FREE
       EXFEAPPGST = '2';
       EXSR UEBFEAP;

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
       EXSR OFFUKT;

       *IN = *OFF;
       *IN28 = C#IN28;

       IF WKIOKZ = *ON;
         C#WNDW = *ON;
       ENDIF;

       SELECT;

       WHEN PCPGST = 'ENDE  ';                                                  // BILDSCHIRMFORMAT
         IF WKIOKZ = *ON;
           CLOSE MOFEAPFM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         EXSR PRFEAPNMKR;
         EXSR PRFEAPPOSI;
         EXSR KFEAP;

         DSFEAPDANA = DSFEAPNDAN;
         DSFEAPJAHR = DSFEAPNJAH;
         DSFEAPNMKR = DSFEAPNNMK;
         DSFEAPPOSI = DSFEAPNPOS;
         EXSR PRFEAPNMKR;
       //EXSR PRFEAPPOSI;
         EXSR UFEAP;

         WKIFMT = '00';

       WHEN PCPGST = 'PFEAP ';
         EXSR PRFEAPNMKR;
         EXSR PRFEAPPOSI;

         EXSR PFEAP;
         WKIFMT = '00';

       WHEN PCPGST = '4     ';
         EXSR PRFEAPNMKR;
         EXSR PRFEAPPOSI;

         EXSR PFEAP;

         IF WKFENR = *ZERO;
           EXSR LFEAP;
         ENDIF;

         WKIFMT = '00';

       WHEN DATEST = '5';
         PCPGST = '5     ';

       ENDSL;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           EXSR AUFFOR;
           OPEN(E) MOFEAPFM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) MOFEAPFM;
         *IN98 = %ERROR;
         WKIOKZ = *OFF;
       ENDIF;

       RTFEAPRTCD = #CRTCD;

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
       KYAAFI = DAFIRM;                                                         // AFPA
       KYAPFI = DAFIRM;                                                         // AFPO
       KYFEAPFIRM = DAFIRM;                                                     // FEAP
       KYTEFI = DAFIRM;                                                         // TEIL
       KYTAFI = DAFIRM;                                                         // TRPA
       KYTPFI = DAFIRM;                                                         // TRTP

       KYTPSP = DASPCD;                                                         // TRTP

       EXFLPOFMTN = 'MOFEAPFM';

       CLEAR EXTRPB;
       EXTRPBBPRG = 'MOFEAPFM';

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXFEAP                         ***
       //*************************************************************************
       BEGSR UEBFEAP;

       CLEAR EXDATA;
       EXDATAFILE = 'EXFEAP';
       EXDATADATA = EXFEAP;
       C_INZDATASTR(EXDATA:RTDATA);
       EXFEAP = RTDATADATA;

       PCPGST = EXFEAPPGST;

       KYFEAPDANA = EXFEAPDANA;
       KYFEAPJAHR = EXFEAPJAHR;
       KYFEAPNMKR = EXFEAPNMKR;
       KYFEAPPOSI = EXFEAPPOSI;

       DSFEAPDANA = EXFEAPDANA;
       DSFEAPJAHR = EXFEAPJAHR;
       DSFEAPNMKR = EXFEAPNMKR;
       DSFEAPPOSI = EXFEAPPOSI;

       DSFEAPNDAN = EXFEAPNDAN;
       DSFEAPNJAH = EXFEAPNJAH;
       DSFEAPNNMK = EXFEAPNNMK;
       DSFEAPNPOS = EXFEAPNPOS;

       CLEAR RTFEAP;
       RTFEAPFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

       C#LCK0 = *OFF;
       C#LCK1 = *OFF;
       WKIN30 = C#LCK0;
       WKIN31 = C#LCK1;

       DAFEHL = *BLANK;
       ##RTCD = *BLANK;
       #CRTCD = *BLANK;
       WKFEAT = 'F';
       MCF = *BLANK;

       WKIFMT = '01';
       FMTDS = *BLANK;

       FM = 1;
       FMT(FM) = '00';

       ENDSR;
       //*************************************************************************
       //**  AUFBEREITUNG FÜR FORMATANZEIGE                                    ***
       //*************************************************************************
       BEGSR AUFFOR;

       EXFIRMFIRM = DAFIRM;
       EXSR PRFIRMFIRM;
       %SUBST(W99DS:01) = EXFIRMKNAM;
       %SUBST(W99DS:31) = *BLANK;

       EXTRDNDANA = 'MOFEAP';
       EXSR RDTRDNTRDN;
       %SUBST(W99DS:32) = EXTRDNTEXT;

       DSKOPF = W99DS;

       ENDSR;
       //*************************************************************************
       //**  STEUERROUTINE BILD01                                              ***
       //*************************************************************************
       BEGSR BILD01;

       IF WKIFMT <> FMT(FM);
         EXSR IFMTS;
       ENDIF;

       EXSR B01DS;

       DOW WKIFMT = '01';
         %SUBST(WKFLPORECN:1:8) = 'MOFEAP01';
         EXSR EFLPO;
         WRITE MOFEAP01;
         WRITE MOFEAPB1;
         EXSR OFFUKT;
         FUKT04 = *ON;
         FUKT10 = *ON;
         FUKT12 = *ON;
         FUKT13 = *ON;
         FUKT15 = *ON;

         SELECT;
         WHEN WKFENR <> *ZERO;
           EXSR AUMSG;
         ENDSL;

         C#WNDW = *OFF;

         READ(E) MOFEAP01;
         *IN98 = %ERROR;
         *IN99 = %EOF;

         IF *IN98 = *ON
           OR *IN99 = *ON;
           #CRTCD = 'N';
           DAFEHL = *ON;
           #CPGST = *BLANK;
           WKIFMT = '00';
           LEAVE;
         ENDIF;

         SELECT;

         WHEN C#SELC = *ON
           AND FUKT04 = *ON;
           WKIFMT ='01';
           EXSR MCAUFR;
           WKIFMT ='01';

           IF WKTRTP = *ON
             OR WKFENR <> *ZERO;
             ITER;
           ENDIF;

         WHEN C#ACCS = *ON
           AND FUKT10 = *ON;
           WKPGST = 'AUFRUF';
           EXSR TRTRDZ;
           C#WNDW = *ON;
           ITER;

         WHEN C#CANC = *ON
           AND FUKT12 = *ON;
           #CRTCD = 'N';
           #CPGST = *BLANK;
           EXSR RFMTS;
           LEAVE;

         WHEN C#INFO = *ON
           AND FUKT13 = *ON;
           EXSR VINFO;
           C#WNDW = *ON;
           ITER;

         WHEN C#TEXT = *ON                                                      // STAMMTEXTE
           AND FUKT15 = *ON;

         WHEN C#FUKT <> *ZERO
           AND FUKT10 = *ON;
           WKPGST = 'AUFRUF';
           EXSR TRTRDZ;

           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           LEAVE;

         WHEN C#FUKT <> *ZERO;
           WKFENR = '0075';
           ITER;

         ENDSL;

         IF PCPGST <> '5     '
           AND PCPGST <> 'F     ';

           IF PCPGST <> 'MUSTER';
             EXSR BILDPR;
             WKIFMT ='01';

          //   IF WKFENR <> *ZERO;
             IF WKFENR <> *ZERO or (Fukt04 = *on and c#Selc = *on);
               ITER;
             ENDIF;

           ENDIF;

           EXSR UFEAP;

           WKPGST = 'DIREKT';
           EXSR TRTRDZ;

           SELECT;
           ENDSL;

         ENDIF;

         #CRTCD = *BLANK;
         #CPGST = *BLANK;
         WKIFMT = '00';

       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
       //*************************************************************************
       BEGSR B01DS;

       C#LCK0 = WKIN30;
       C#LCK1 = WKIN31;
       PCRTCD = #CRTCD;

       IF PCPGST <> '5     ';
         CHIDS = '01C';
         EXSR CHFEAP;

         EXINFOFILE = 'FEAP';
         EXINFODATA = %ADDR(FEAP);

         C_TRINFO(EXINFO:DSINFO);
         IF CHI(05) = 'N';
           PCPGST = *BLANK;
         ELSE;
           PCPGST = '2     ';
         ENDIF;

       ENDIF;

       SELECT;

       WHEN PCPGST = *BLANK
         OR PCPGST = 'MUSTER';
         CLEAR FEAP;
         FEAPDANA = KYFEAPDANA;
         FEAPJAHR = KYFEAPJAHR;
         FEAPNMKR = KYFEAPNMKR;
         FEAPPOSI = KYFEAPPOSI;

       OTHER;
         CHIDS = '01C';
         EXSR CHFEAP;
         WKUSER = FEAPUSER;
         WKJDAT = FEAPJDAT;
         WKJZEI = FEAPJZEI;

       ENDSL;

       DSAFPOTENR = *BLANK;                                                     // INITIALISIEREN
       DSAFPOTBZ1 = *BLANK;                                                     // TEXTFELDER
       DSAFPOTBZ2 = *BLANK;
       DSAFPOAFAT = *BLANK;
       TXAFPOAFAT = *BLANK;
       DSAFPOBSMG = *ZERO;
       DSAFPOMEIN = *BLANK;
       TXAFPOMEIN = *BLANK;
       DSAFPOLFTE = *ZERO;

       DSGRP1 = *BLANK;
       DSGRP2 = *BLANK;
       DSGRP3 = *BLANK;
       DSGRP4 = *BLANK;
       DSGRP5 = *BLANK;
       DSCOD1 = *BLANK;
       DSCOD2 = *BLANK;
       DSCOD3 = *BLANK;
       DSCOD4 = *BLANK;
       DSCOD5 = *BLANK;
       TXCOD1 = *BLANK;
       TXCOD2 = *BLANK;
       TXCOD3 = *BLANK;
       TXCOD4 = *BLANK;
       TXCOD5 = *BLANK;
       DSANZ1 = *ZERO;
       DSANZ2 = *ZERO;
       DSANZ3 = *ZERO;
       DSANZ4 = *ZERO;
       DSANZ5 = *ZERO;
       DSEBKM = *ZERO;
       DSABKM = *ZERO;
       DSABDA = *ZERO;
       DSSENR = *BLANK;
       DSPNCN = *BLANK;
       DSERSA = *BLANK;
       DSKZER = *BLANK;
       DSCLTI = *BLANK;
       DSCLTY = *BLANK;
       DSCLTYK= *BLANK;
       TxCLTY = *BLANK;
       DSCLRE = *BLANK;
       DSCLREK= *BLANK;
       TxCLRE = *BLANK;
       DSPrex = *BLANK;
       DSPrexK= *BLANK;
       TxPrex = *BLANK;

       IF DSFEAPJAHR <> *ZERO
         AND DSFEAPNMKR <> *BLANK
         AND DSFEAPPOSI <> *ZERO;
         EXSR PRFEAPNMKR;
         EXSR PRFEAPPOSI;
       ENDIF;

       W1PGST = 'ERFEAP';
       EXSR MOFEAP;

       IF DSCOD1 <> *BLANK;
         EXSR PRFEAPCOD1;
       ENDIF;

       IF DSCOD2 <> *BLANK;
         EXSR PRFEAPCOD2;
       ENDIF;

       IF DSCOD3 <> *BLANK;
         EXSR PRFEAPCOD3;
       ENDIF;

       IF DSCOD4 <> *BLANK;
         EXSR PRFEAPCOD4;
       ENDIF;

       IF DSCOD5 <> *BLANK;
         EXSR PRFEAPCOD5;
       ENDIF;

       IF DSCLTY <> *BLANK;
         EXSR PRFEAPCLTY;
       ENDIF;

       IF DSCLRE <> *BLANK;
         EXSR PRFEAPCLRE;
       ENDIF;

       IF DSPREX <> *BLANK;
         EXSR PRFEAPPREX;
       ENDIF;

       EXTRPBBFMT = 'MOFEAP01';
       EXSR CSTRPB;

       WKFENR = '0000';
       EXFLPOFLDN = *BLANK;

       IF PCRTCD = 'W';
         WKFENR = '0070';
       ENDIF;

       SELECT;

       WHEN PCPGST = '5     ';
         C#LCK0 = *ON;
         C#LCK1 = *ON;

       WHEN PCPGST = '2     ';
         C#LCK1 = *ON;
         EXFLPOFLDN = 'DSPNCN    ';

         IF RTTRPBCUSR <> *BLANK;
           EXFLPOFLDN = RTTRPBCUSR;
         ENDIF;

       WHEN PCPGST = 'MUSTER';
         C#LCK1 = *ON;
         EXFLPOFLDN = 'DSPNCN    ';

       WHEN PCPGST = 'F     ';
         WKFENR = '0001';
         C#LCK0 = *ON;
         C#LCK1 = *ON;

       OTHER;
         EXFLPOFLDN = 'DSPNCN    ';
         C#LCK1 = *ON;
       ENDSL;

       #CRTCD = *BLANK;


       ENDSR;
       //*************************************************************************
       //**  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
       //*************************************************************************
       BEGSR MCAUFR;

       WKTRTP = *OFF;
       WKFENR = '0000';
       EXFLPOFLDN = FLDNAM;
       EXSR EFLPO;

       SELECT;

       WHEN EXFLPOKZIO = *OFF;
         WKFENR = '0052';

       WHEN C#LCK1 = *ON
         AND FLDNAM = 'DSFEAPNMKR';
         WKFENR = '0052';

       WHEN C#LCK1 = *ON
         AND FLDNAM = 'DSFEAPPOSI';
         WKFENR = '0052';

       WHEN C#LCK0 = *ON
         AND FLDNAM = 'DSABDA';
         WKFENR = '0052';

       WHEN FLDNAM = 'DSABDA';
         EXSR MCFEAPABDA;


       OTHER;
         WKFENR = '0050';
       ENDSL;

       // Claim Type
        If FLDNAM = 'DSCLTYK';
      /end-free
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$CLTY'      KOM(02)
     C                   MOVEA     DSCLTYK       KOM(12)
      /free
          #CPGST  = *Blank;
          #CueBe  = '0010';
          exsr McTrTp;
          if *in99 = *off;
            DsCltyK = TpTcde;
            TxClty = TpTTxt;
          endif;
        endif;

       // Claim Reason
        If FLDNAM = 'DSCLREK';
      /end-free
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$CLRE'      KOM(02)
     C                   MOVEA     DSCLREK       KOM(12)
      /free
          #CPGST  = *Blank;
          #CueBe  = '0010';
          exsr McTrTp;
          if *in99 = *off;
            DsClreK = TpTcde;
            TxClRe = TpTTxt;
          endif;
        endif;

       // Product Exchange
        If FLDNAM = 'DSPREX';
      /end-free
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$PREX'      KOM(02)
     C                   MOVEA     DSPREXK       KOM(12)
      /free
          #CPGST  = *Blank;
          #CueBe  = '0010';
          exsr McTrTp;
          if *in99 = *off;
            DsPrexK = TpTcde;
            TxPrex  = TpTTxt;
          endif;
        endif;



       ENDSR;
       //*************************************************************************
       //**  PLAUSIPRÜFUNG FÜR FORMATE                                         ***
       //*************************************************************************
       BEGSR BILDPR;

       WKFENR = '0000';
       FLDDS = EXFLPOFLDA;

       IF PCPGST <> '3     ';
         WKIFMT ='01';
       ENDIF;

       FOR FL = 1 TO 100;

         IF FLD(FL) = *BLANK;
           LEAVE;
         ENDIF;

         FLDNAM = FLD(FL);
         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;
         WHEN EXFLPOKZIO = *OFF;

         WHEN FLDNAM = 'DSFEAPNMKR'
           AND C#LCK1 = *OFF;
           EXSR PRFEAPNMKR;
         WHEN FLDNAM = 'DSFEAPPOSI'
           AND C#LCK1 = *OFF;
           EXSR PRFEAPPOSI;
         WHEN FLDNAM = 'DSPNCN    '
           AND C#LCK0 = *OFF;
           EXSR PRAUFRPNCN;
         WHEN FLDNAM = 'DSSENR    '
           AND C#LCK0 = *OFF;
           EXSR PRAUFRSENR;
         WHEN FLDNAM = 'DSERSA    '
           AND C#LCK0 = *OFF;
           EXSR PRAUFRERSA;
         WHEN FLDNAM = 'DSKZER    '
           AND C#LCK0 = *OFF;
           EXSR PRAUFRKZER;
         WHEN FLDNAM = 'DSEBKM    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPEBKM;
         WHEN FLDNAM = 'DSABKM    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPABKM;
         WHEN FLDNAM = 'DSABDA    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPABDA;
         WHEN FLDNAM = 'DSGRP1    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPGRP1;
         WHEN FLDNAM = 'DSCOD1    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCOD1;
         WHEN FLDNAM = 'DSANZ1    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPANZ1;
         WHEN FLDNAM = 'DSGRP2    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPGRP2;
         WHEN FLDNAM = 'DSCOD2    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCOD2;
         WHEN FLDNAM = 'DSANZ2    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPANZ2;
         WHEN FLDNAM = 'DSGRP3    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPGRP3;
         WHEN FLDNAM = 'DSCOD3    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCOD3;
         WHEN FLDNAM = 'DSANZ3    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPANZ3;
         WHEN FLDNAM = 'DSGRP4    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPGRP4;
         WHEN FLDNAM = 'DSCOD4    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCOD4;
         WHEN FLDNAM = 'DSANZ4    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPANZ4;
         WHEN FLDNAM = 'DSGRP5    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPGRP5;
         WHEN FLDNAM = 'DSCOD5    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCOD5;
         WHEN FLDNAM = 'DSANZ5    '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPANZ5;
         WHEN FLDNAM = 'DSCLTYK   '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCLTY;
         WHEN FLDNAM = 'DSCLREK   '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPCLRE;
         WHEN FLDNAM = 'DSPREXK   '
           AND C#LCK0 = *OFF;
           EXSR PRFEAPPREX;
         ENDSL;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

       ENDFOR;

       SELECT;
       WHEN PCPGST = '3     ';

       WHEN PCPGST = '2     '
         OR PCPGST = *BLANK;
         KYFEAPDANA = DSFEAPDANA;
         KYFEAPJAHR = DSFEAPJAHR;
         KYFEAPNMKR = DSFEAPNMKR;
         KYFEAPPOSI = DSFEAPPOSI;
         CHIDS = '01C';
         EXSR CHFEAP;

         SELECT;
         WHEN WKFENR = *ZERO
           AND PCPGST = *BLANK;
           WKFENR = '0092';
           EXFLPOFLDN = 'DSFEAPPOSI';
           LEAVESR;
         WHEN WKFENR <> *ZERO
           AND PCPGST = '2     ';
           WKFENR = '0901';
           EXFLPOFLDN = 'DSFEAPPOSI';
           LEAVESR;
         ENDSL;

       ENDSL;

       WKFENR = '0000';
       IF PCPGST <> '3     ';
         WKIFMT ='01';
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  KOPIEREN SÄTZE AUS DATEI FEAP                                     ***
       //*************************************************************************
       BEGSR KFEAP;

       KYFEAPDANA = DSFEAPDANA;
       KYFEAPJAHR = DSFEAPJAHR;
       KYFEAPNMKR = DSFEAPNMKR;
       KYFEAPPOSI = DSFEAPPOSI;
       CHIDS = '01C';
       EXSR CHFEAP;

       IF WKFENR = *ZERO;
         W1PGST = 'ERFEAP';
         EXSR MOFEAP;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN, OB FEAP-SATZ GELÖSCHT WERDEN DARF                         ***
       //*************************************************************************
       BEGSR PFEAP;

       WKFENR = '0000';

       CLEAR RTFEAP;
       RTFEAPPROG = WKPROG;
       RTFEAPDANA = WKDANA;
       RTFEAPFFLD = WKFFLD;
       RTFEAPFENR = WKFENR;
       RTFEAPPA03 = W$PA03;
       RTFEAPPA04 = W$PA04;
       RTFEAPPA05 = W$PA05;
       RTFEAPPA06 = W$PA06;
       RTFEAPPA07 = W$PA07;

       ENDSR;
       //*************************************************************************
       //**  LÖSCHEN SÄTZE DATEI FEAP                                          ***
       //*************************************************************************
       BEGSR LFEAP;

       W1PGST = '4     ';
       EXSR MOFEAP;

       CLEAR RTFEAP;
       RTFEAPPROG = WKPROG;
       RTFEAPDANA = WKDANA;
       RTFEAPFFLD = WKFFLD;
       RTFEAPFENR = WKFENR;
       RTFEAPPA03 = W$PA03;
       RTFEAPPA04 = W$PA04;
       RTFEAPPA05 = W$PA05;
       RTFEAPPA06 = W$PA06;
       RTFEAPPA07 = W$PA07;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI FEAP                                                 ***
       //*************************************************************************
       BEGSR UFEAP;

       KYFEAPDANA = DSFEAPDANA;
       KYFEAPJAHR = DSFEAPJAHR;
       KYFEAPNMKR = DSFEAPNMKR;
       KYFEAPPOSI = DSFEAPPOSI;

       IF PCPGST = '3     ';
        KYFEAPDANA = DSFEAPNDAN;
        KYFEAPJAHR = DSFEAPNJAH;
        KYFEAPNMKR = DSFEAPNNMK;
        KYFEAPPOSI = DSFEAPNPOS;
       ENDIF;

       W1PGST = '      ';
       EXSR MOFEAP;

       ENDSR;
       //*************************************************************************
       //**  MC-ROUTINE NMKR                                                   ***
       //*************************************************************************
       BEGSR MCFEAPNMKR;

       C#WNDW = *ON;

       SELECT;

       WHEN DSFEAPDANA = 'AFPO';
         KOM = *BLANK;
         DUN040 = DSFEAPJAHR;
         %SUBST(KOMDS:13:4) = DUC004;
         %SUBST(KOMDS:17:6) = DSFEAPNMKR;
         #CPGST = '5     ';
         #CUEBE = '0535';
         EXSR MCAFKO;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSFEAPJAHR = AKAFJJ;
           DSFEAPNMKR = AKAFNR;
         ENDIF;

       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE NMKR                                                   ***
       //*************************************************************************
       BEGSR PRFEAPNMKR;

       EXFLPOFLDN = 'DSFEAPNMKR';

       SELECT;

       WHEN DSFEAPDANA = 'AFPO';
         KYAKJH = DSFEAPJAHR;
         KYAKAF = DSFEAPNMKR;
         CHIDS = '01C';
         EXSR CHAFKO;

       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ANZEIGEN POSI                                                     ***
       //*************************************************************************
       BEGSR MCFEAPPOSI;

       C#WNDW = *ON;

       IF DSFEAPPOSI = *ZERO;
         DSAFPOTENR = *BLANK;
         DSAFPOTBZ1 = *BLANK;
         DSAFPOTBZ2 = *BLANK;
         DSAFPOAFAT = *BLANK;
         TXAFPOAFAT = *BLANK;
         DSAFPOBSMG = *ZERO;
         DSAFPOMEIN = *BLANK;
         TXAFPOMEIN = *BLANK;
         DSAFPOLFTE = *ZERO;
       ENDIF;

       SELECT;

       WHEN DSFEAPDANA = 'AFPO';
         DUN040 = DSFEAPJAHR;
         %SUBST(KOMDS:01) = DUC004;
         %SUBST(KOMDS:05:6) = DSFEAPNMKR;
         DUN040 = *ZERO;
         %SUBST(KOMDS:11:4) = DUC004;
         #CPGST = 'AFPO01';
         #CUEBE = '0526';
         EXSR MCAFPO;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSFEAPJAHR = APAFJJ;
           DSFEAPNMKR = APAFNR;
           DSFEAPPOSI = APAFPO;

           EXSR PRFEAPPOSI;
         ENDIF;

       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN POSI                                                       ***
       //*************************************************************************
       BEGSR PRFEAPPOSI;

       EXFLPOFLDN = 'DSFEAPPOSI';
       DSAFPOTENR = *BLANK;
       DSAFPOTBZ1 = *BLANK;
       DSAFPOTBZ2 = *BLANK;
       DSAFPOAFAT = *BLANK;
       TXAFPOAFAT = *BLANK;
       DSAFPOBSMG = *ZERO;
       DSAFPOMEIN = *BLANK;
       TXAFPOMEIN = *BLANK;
       DSAFPOLFTE = *ZERO;

       SELECT;

       WHEN DSFEAPDANA = 'AFPO';
         KYAPJH = DSFEAPJAHR;
         KYAPAF = DSFEAPNMKR;
      /END-FREE
     C                   Z-ADD     DSFEAPPOSI    KYAPPO
      /FREE
         CHIDS = '01C';
         EXSR CHAFPO;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         DSAFPOTENR = APTENR;
         DSAFPOTBZ1 = APTBZ1;
         DSAFPOTBZ2 = APTBZ2;
         DSAFPOAFAT = APAFAT;
         DSAFPOBSMG = APBSMG;
         DSAFPOMEIN = APMEIN;

         CLEAR EXDATE;
         EXDATEDATV = APLFTE;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSAFPOLFTE = RTDATEDATE;

         KYAAAT = DSAFPOAFAT;
         CHIDS = '01C';
         EXSR CHAFPA;
         TXAFPOAFAT = AAABEZ;

         KYTPTA = 'MEIN';
         KYTPTC = DSAFPOMEIN;
         CHIDS = '01C';
         EXSR CHTRTP;
      /END-FREE
     C                   MOVEL(P)  TPTTXT        TXAFPOMEIN
      /FREE
         WKFENR = '0000';

       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE PNCN                                                   ***
       //*************************************************************************
       BEGSR PRAUFRPNCN;

       EXFLPOFLDN = 'DSPNCN    ';

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE SENR                                                   ***
       //*************************************************************************
       BEGSR PRAUFRSENR;

       EXFLPOFLDN = 'DSSENR    ';

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ERSA                                                   ***
       //*************************************************************************
       BEGSR PRAUFRERSA;

       EXFLPOFLDN = 'DSERSA    ';

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE KZER                                                   ***
       //*************************************************************************
       BEGSR PRAUFRKZER;

       EXFLPOFLDN = 'DSKZER    ';

       ENDSR;
       //*************************************************************************
       //**  MC-ROUTINE ABDA                                                   ***
       //*************************************************************************
       BEGSR MCFEAPABDA;

       C#WNDW = *ON;

       CLEAR EXDATE;
       EXDATEDATV = DSABDA;
       EXDATEFMTV = '*EUR';
       EXDATEFMTN = '*EUR';

       IF DSABDA = *ZERO;
         EXDATEPGCD = 'POSAKT';
       ENDIF;

       EXSR TRDATE;

       IF WKFENR = *ZERO
         AND WKTRTP = *OFF;
         DSABDA = RTDATEDATE;
         WKTRTP = *ON;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ABDA                                                   ***
       //*************************************************************************
       BEGSR PRFEAPABDA;

       EXFLPOFLDN = 'DSABDA';

       IF DSABDA <> *ZERO;
         CLEAR EXDATE;
         EXDATEDATV = DSABDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAPR';
         EXSR TRDATE;

         IF WKFENR = *ZERO;
           DSABDA = RTDATEDATE;
         ENDIF;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE EBKM                                                   ***
       //*************************************************************************
       BEGSR PRFEAPEBKM;

       EXFLPOFLDN = 'DSEBKM';

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ABKM                                                   ***
       //*************************************************************************
       BEGSR PRFEAPABKM;

       EXFLPOFLDN = 'DSABKM';

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE GRP1                                                   ***
       //*************************************************************************
       BEGSR PRFEAPGRP1;

       EXFLPOFLDN = 'DSGRP1';

       IF DSGRP1 = *BLANK
         AND DSCOD1 <> *BLANK
         OR  DSGRP1 = *BLANK
         AND DSANZ1 <> *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE COD1                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCOD1;

       EXFLPOFLDN = 'DSCOD1';
       TXCOD1 = *BLANK;

       IF DSGRP1 <> *BLANK
         OR DSCOD1 <> *BLANK
         OR DSANZ1 <> *ZERO;
         p_sgrp = DSGRP1;
         p_ERRC = DSCOD1;
         EXSR DOMPRQMERR;

         IF WKFENR <>*ZERO;
           LEAVESR;
         ENDIF;

         TXCOD1 = P_ERRBESC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ANZ1                                                   ***
       //*************************************************************************
       BEGSR PRFEAPANZ1;

       EXFLPOFLDN = 'DSANZ1';

       IF DSCOD1 <> *BLANK
         AND DSANZ1 = *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE GRP2                                                   ***
       //*************************************************************************
       BEGSR PRFEAPGRP2;

       EXFLPOFLDN = 'DSGRP2';

       IF DSGRP2 = *BLANK
         AND DSCOD2 <> *BLANK
         OR  DSGRP2 = *BLANK
         AND DSANZ2 <> *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE COD2                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCOD2;

       EXFLPOFLDN = 'DSCOD2';
       TXCOD2 = *BLANK;

       IF DSGRP2 <> *BLANK
         OR DSCOD2 <> *BLANK
         OR DSANZ2 <> *ZERO;
         p_sgrp = DSGRP2;
         p_ERRC = DSCOD2;
         EXSR DOMPRQMERR;

         IF WKFENR <>*ZERO;
           LEAVESR;
         ENDIF;

         TXCOD2 = P_ERRBESC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ANZ2                                                   ***
       //*************************************************************************
       BEGSR PRFEAPANZ2;

       EXFLPOFLDN = 'DSANZ2';

       IF DSCOD2 <> *BLANK
         AND DSANZ2 = *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE GRP3                                                   ***
       //*************************************************************************
       BEGSR PRFEAPGRP3;

       EXFLPOFLDN = 'DSGRP3';

       IF DSGRP3 = *BLANK
         AND DSCOD3 <> *BLANK
         OR  DSGRP3 = *BLANK
         AND DSANZ3 <> *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE COD3                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCOD3;

       EXFLPOFLDN = 'DSCOD3';
       TXCOD3 = *BLANK;

       IF DSGRP3 <> *BLANK
         OR DSCOD3 <> *BLANK
         OR DSANZ3 <> *ZERO;
         p_sgrp = DSGRP3;
         p_ERRC = DSCOD3;
         EXSR DOMPRQMERR;

         IF WKFENR <>*ZERO;
           LEAVESR;
         ENDIF;

         TXCOD3 = P_ERRBESC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ANZ3                                                   ***
       //*************************************************************************
       BEGSR PRFEAPANZ3;

       EXFLPOFLDN = 'DSANZ3';

       IF DSCOD3 <> *BLANK
         AND DSANZ3 = *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE GRP4                                                   ***
       //*************************************************************************
       BEGSR PRFEAPGRP4;

       EXFLPOFLDN = 'DSGRP4';

       IF DSGRP4 = *BLANK
         AND DSCOD4 <> *BLANK
         OR  DSGRP4 = *BLANK
         AND DSANZ4 <> *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE COD4                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCOD4;

       EXFLPOFLDN = 'DSCOD4';
       TXCOD4 = *BLANK;

       IF DSGRP4 <> *BLANK
         OR DSCOD4 <> *BLANK
         OR DSANZ4 <> *ZERO;
         p_sgrp = DSGRP4;
         p_ERRC = DSCOD4;
         EXSR DOMPRQMERR;

         IF WKFENR <>*ZERO;
           LEAVESR;
         ENDIF;

         TXCOD4 = P_ERRBESC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ANZ4                                                   ***
       //*************************************************************************
       BEGSR PRFEAPANZ4;

       EXFLPOFLDN = 'DSANZ4';

       IF DSCOD4 <> *BLANK
         AND DSANZ4 = *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE GRP5                                                   ***
       //*************************************************************************
       BEGSR PRFEAPGRP5;

       EXFLPOFLDN = 'DSGRP5';

       IF DSGRP5 = *BLANK
         AND DSCOD5 <> *BLANK
         OR  DSGRP5 = *BLANK
         AND DSANZ5 <> *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE COD5                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCOD5;

       EXFLPOFLDN = 'DSCOD5';
       TXCOD5 = *BLANK;

       IF DSGRP5 <> *BLANK
         OR DSCOD5 <> *BLANK
         OR DSANZ5 <> *ZERO;
         p_sgrp = DSGRP5;
         p_ERRC = DSCOD5;
         EXSR DOMPRQMERR;

         IF WKFENR <>*ZERO;
           LEAVESR;
         ENDIF;

         TXCOD5 = P_ERRBESC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE ANZ5                                                   ***
       //*************************************************************************
       BEGSR PRFEAPANZ5;

       EXFLPOFLDN = 'DSANZ5';

       IF DSCOD5 <> *BLANK
         AND DSANZ5 = *ZERO;
         WKFENR ='0031';
         LEAVESR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  DOMETIC VERWALTEN ZUSÄLICHEN FELDER                               ***
       //*************************************************************************
       BEGSR MOFEAP;

       SELECT;
       WHEN W1PGST = *BLANK;
         P_VAKZ = '2';
         EXSR DOMQMERR;
       WHEN W1PGST = '2     ';
         P_VAKZ = '2';
         EXSR DOMQMERR;
       WHEN W1PGST = '4     ';
         P_VAKZ = '4';
         EXSR DOMQMERR;
       WHEN W1PGST = 'ERFEAP'
         OR W1PGST = '5     ';
         P_VAKZ = '5';
         EXSR DOMQMERR;
       ENDSL;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE CLTY                                                   ***
       //*************************************************************************
       BEGSR PRFEAPCLTY;

       EXFLPOFLDN = 'DSCLTYK';

       TxClty = *blank;
       DSClty = *blank;
       KYTPTA = '$$CLTY';
       KYTPTC = DSCLTYK;
       CHIDS = '01C';
       if DsCltyK <> ' ';
        EXSR CHTRTP;

        if chi(5) = 'N' and dsCltyK <> ' ';
          WKFENR ='0031';
        else;
          DsCltyK = TpTcde;
          TxClty = TpTTxt;
        endif;

       // jetzt noch die LangNr. holen
       KYTPTA = '$$CLTY';
       KYTPTC = DSCLTYK;
       KYTPTF = 1;
        EXSR CHTRTP;

        if chi(5) = 'N' and dsCltyK <> ' ';
          WKFENR ='0031';
        else;
          DsClty = TpTTxt;
        endif;

       endif;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE CLRE                                                   ***
       //*************************************************************************

       BEGSR PRFEAPCLRE;

       EXFLPOFLDN = 'DSCLREK';

       TxClRe = *blank;
       DSClRe = *blank;
       KYTPTA = '$$CLRE';
       KYTPTC = DSCLREK;
       CHIDS = '01C';
       if DsClREK <> ' ';
        EXSR CHTRTP;

        if chi(5) = 'N' and dsClReK <> ' ';
          WKFENR ='0031';
        else;
          DsClReK = TpTcde;
          TxClRe = TpTTxt;
        endif;

       // jetzt noch die LangNr. holen
       KYTPTA = '$$CLRE';
       KYTPTC = DSCLREK;
       KYTPTF = 1;
        EXSR CHTRTP;

        if chi(5) = 'N' and dsClReK <> ' ';
          WKFENR ='0031';
        else;
          DsClRe = TpTTxt;
        endif;

       endif;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE PREX                                                   ***
       //*************************************************************************

       BEGSR PRFEAPPREX;

       EXFLPOFLDN = 'DSPREXK';

       TxPrex = *blank;
       DSPrex = *blank;
       KYTPTA = '$$PREX';
       KYTPTC = DSPREXK;
       CHIDS = '01C';
       if DsPREXK <> ' ';
        EXSR CHTRTP;

        if chi(5) = 'N' and dsPrexK <> ' ';
          WKFENR ='0031';
        else;
          DsPrexK = TpTcde;
          TxPrex  = TpTTxt;
        endif;

       // jetzt noch die LangNr. holen
       KYTPTA = '$$PREX';
       KYTPTC = DSPREXK;
       KYTPTF = 1;
        EXSR CHTRTP;

        if chi(5) = 'N' and dsPrexK <> ' ';
          WKFENR ='0031';
        else;
          DsPrex = TpTTxt;
        endif;

       endif;

       ENDSR;
      /END-FREE
     C**************************************************************************
     C***  DOMQMERR                                                          ***
     C**************************************************************************
     C     DOMQMERR      BEGSR
     C*
      /FREE
         CLEAR EXDATE;
         EXDATEDATV = DSABDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSABDA = RTDATEDATE;

         P_ERRO1 = *BLANK;
         IF DSCOD1 <> *BLANK;
           P_ERRO1 = DSGRP1 + '000' + DSCOD1;
         ENDIF;

         P_ERRO2 = *BLANK;
         IF DSCOD2 <> *BLANK;
           P_ERRO2 = DSGRP2 + '000' + DSCOD2;
         ENDIF;

         P_ERRO3 = *BLANK;
         IF DSCOD3 <> *BLANK;
           P_ERRO3 = DSGRP3 + '000' + DSCOD3;
         ENDIF;

         P_ERRO4 = *BLANK;
         IF DSCOD4 <> *BLANK;
           P_ERRO4 = DSGRP4 + '000' + DSCOD4;
         ENDIF;

         P_ERRO5 = *BLANK;
         IF DSCOD5 <> *BLANK;
           P_ERRO5 = DSGRP5 + '000' + DSCOD5;
         ENDIF;
      /END-FREE
     C                   EVAL      P_ERRANZ1  = DSANZ1
     C                   EVAL      P_ERRANZ2  = DSANZ2
     C                   EVAL      P_ERRANZ3  = DSANZ3
     C                   EVAL      P_ERRANZ4  = DSANZ4
     C                   EVAL      P_ERRANZ5  = DSANZ5
     C*
     C                   call      'DOMQMERR'
     C                   parm      DAFIRM        p_firm            2
     C                   parm      DSFEAPJAHR    p_Jahr            4 0
     C                   parm      AKAFAT        p_AFAT            3
     C                   parm      DSFEAPNMKR    p_AfNr            6
     C                   parm      DSFEAPPOSI    p_AfPo            4 0
     C                   parm      APTENR        p_Tenr           15
     C                   parm      DSPNCN        p_PCN            15
     C                   parm      AKMAAF        p_rpnr           15
     C                   parm      FEAPFGSN      p_FgSn           20
     C                   parm      DSSENR        p_Senr           25
     C                   parm      DSERSA        p_Ersa           15
     C                   parm      DSKZER        p_Kzer            1
     C                   parm      APKDNR        p_KDNR           10
     C                   parm                    p_KOST            4
     C                   parm      APNESU        p_NESU            9 2
     C                   parm      APWACD        p_WACD            3
     C                   parm                    p_Erro1          20
     C                   parm                    p_ErrAnz1         4 0
     C                   parm                    p_Erro2          20
     C                   parm                    p_ErrAnz2         4 0
     C                   parm                    p_Erro3          20
     C                   parm                    p_ErrAnz3         4 0
     C                   parm                    p_Erro4          20
     C                   parm                    p_ErrAnz4         4 0
     C                   parm                    p_Erro5          20
     C                   parm                    p_ErrAnz5         4 0
     C                   parm      DSABKM        p_ABKM            8 0
     C                   parm      DSEBKM        p_EBKM            8 0
     C                   parm      DSABDA        p_ABDT            8 0
     C                   parm      FEAPEBDA      p_EBDT            8 0
     C                   PARM                    p_VaKz            1
     C                   PARM                    p_ErsaKz          1
     C                   PARM      APTBZ1        p_tbz1           30
     C                   PARM      APTBZ2        p_tbz2           30
     C                   PARM      dsclti        p_clti           50
     C                   PARM      dsbuse        p_buse           10
     C                   PARM      dsclty        p_clty           10
     C                   PARM      dscltyk       p_cltyk          10
     C                   PARM      dsclre        p_clre           10
     C                   PARM      dsclrek       p_clrek          10
     C                   PARM      dsprex        p_prex           10
     C                   PARM      dsprexk       p_prexk          10
     C*
     C                   EVAL      DSGRP1     =  %SUBST(P_ERRO1:1:2)
     C                   EVAL      DSGRP2     =  %SUBST(P_ERRO2:1:2)
     C                   EVAL      DSGRP3     =  %SUBST(P_ERRO3:1:2)
     C                   EVAL      DSGRP4     =  %SUBST(P_ERRO4:1:2)
     C                   EVAL      DSGRP5     =  %SUBST(P_ERRO5:1:2)
     C*
     C                   EVAL      DSCOD1     =  %SUBST(P_ERRO1:6:3)
     C                   EVAL      DSCOD2     =  %SUBST(P_ERRO2:6:3)
     C                   EVAL      DSCOD3     =  %SUBST(P_ERRO3:6:3)
     C                   EVAL      DSCOD4     =  %SUBST(P_ERRO4:6:3)
     C                   EVAL      DSCOD5     =  %SUBST(P_ERRO5:6:3)
     C*
     C                   EVAL      DSANZ1     =        P_ERRANZ1
     C                   EVAL      DSANZ2     =        P_ERRANZ2
     C                   EVAL      DSANZ3     =        P_ERRANZ3
     C                   EVAL      DSANZ4     =        P_ERRANZ4
     C                   EVAL      DSANZ5     =        P_ERRANZ5
     C*
     C                   EVAL      DSEBKM     =        P_EBKM
     C                   EVAL      DSABKM     =        P_ABKM
     C                   EVAL      DSABDA     =        P_ABDT
      /FREE
         CLEAR EXDATE;
         EXDATEDATV = DSABDA;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSABDA = RTDATEDATE;
      /END-FREE
     C                   EVAL      DSPNCN     =        P_PCN
     C                   EVAL      DSSENR     =        P_SENR
     C                   EVAL      DSERSA     =        P_ERSA
     C                   EVAL      DSKZER     =        P_KZER
     C                   EVAL      DSClti     =        P_Clti
     C                   EVAL      DSBuse     =        P_Buse
     C                   EVAL      DSCltyK    =        P_CltyK
     C                   EVAL      DSClreK    =        P_ClreK
     C                   EVAL      DSPrexK    =        P_PrexK
     C                   EVAL      DSClty     =        P_Clty
     C                   EVAL      DSClre     =        P_Clre
     C                   EVAL      DSPrex     =        P_Prex
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DOMPRQMERR                                                        ***
     C**************************************************************************
     C     DOMPRQMERR    BEGSR
     C*
     C                   EVAL      p_ERRBESC = *BLANK
     C                   EVAL      p_RETURN = *BLANK
     C*-------------------------------------------------------------------------
     C                   call      'DOMPRQMERR'
     C                   parm                    p_sgrp            2
     C                   parm                    p_ERRC            3
     C                   parm                    p_ERRBESC       150
     C                   parm                    p_Return         10
     C*
     C                   SELECT
     C                   WHEN      P_RETURN = 'OK'
     C                   EVAL      WKFENR = *ZERO
     C                   OTHER
     C                   EVAL      WKFENR = '0031'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
      /FREE
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

       WKTRPA = *ON;

       KYTATA = 'NEUANLAGE';
       KYTATC = 'AKTUALISIE';
       KYTAPA = 'MOFEAP';
       CHIDS = '01C';
       EXSR CHTRPA;
       WKCFMT = TAPCDE;

       IF WKCFMT <> *ON;
         WKCFMT = *OFF;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ZUGRIFFE                                                          ***
       //*************************************************************************
       BEGSR TRTRDZ;


       WKTRTP = *OFF;
       WKFENR = '0000';
       WKTRDZZYKL = *OFF;

       DOW WKFENR = *ZERO;

         CLEAR EXTRDN;
         EXTRDNPGST = WKPGST;
         EXTRDNPGNA = 'MOFEAP';

         IF C#ACCS = *OFF                                                       // F10=OPTIONEN
           AND WKPGST <> 'DIREKT';
           EXTRDNFUKT = C#FUKT;                                                 // F-TASTEN
         ENDIF;

         IF WKTRDZZYKL = *OFF;
           EXTRDNMCKZ = *ON;
           WKTRDZZYKL = *ON;
         ENDIF;

         C_TRTRDZ(EXTRDN);
         IF EXTRDNRTCD = 'N'
           OR EXTRDNFENR <> *ZERO;
           WKFENR = EXTRDNFENR;
           LEAVE;
         ENDIF;

         SELECT;

         ENDSL;

         IF EXTRDNPGST = 'DIREKT';
           WKPGST = 'WEITER';
           WKFENR = '0000';
         ENDIF;

         IF EXTRDNPGST = 'WEITER';
           WKPGST = 'WEITER';
           WKFENR = '0000';
         ENDIF;

         IF C#FUKT <> *ZERO
           AND C#ACCS <> *ON;
           LEAVE;
         ENDIF;

         #CRTCD = *BLANK;
       ENDDO;


       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  AUFBEREITEN DER NACHRICHTEN                                       ***
       //*************************************************************************
       BEGSR AUMSG;

       C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
       W$PA06:W$PA07);
       PGMNAM = 'MOFEAP';
       C#INIT = *ON;

       SELECT;
       OTHER;
         WRITE MOFEAPCT;
       ENDSL;

       C#INIT = *OFF;

       SELECT;
       OTHER;
         WRITE MOFEAPCT;
       ENDSL;

       W$PA03 = *BLANK;
       W$PA04 = *BLANK;
       W$PA05 = *BLANK;
       W$PA06 = *BLANK;
       W$PA07 = *BLANK;
       W$PA08 = *BLANK;
       WKFENR = '0000';

       ENDSR;


       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHFEAP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCAFKO
     C/COPY QCPYSRC,MCAFPO
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
