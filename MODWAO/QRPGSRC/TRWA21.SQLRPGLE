     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei WA21
      //*************************************************************************
      //  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 05.12.2024 Case #03829427
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA21.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA21FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR

      //*************************************************************************
      //**  indicators                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR

      //*************************************************************************
      //**  Dateien                                                           ***
      //*************************************************************************
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ

     D BLPA          E DS                  INZ
     D KYBLPA        E DS                  INZ

     D BLPO          E DS                  INZ
     D KYBLPO        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRDN          E DS                  INZ
     D KYTRDN        E DS                  INZ

     D TRDZ          E DS                  INZ
     D KYTRDZ        E DS                  INZ
     D UXTRDZ        E DS                  INZ

     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D WA20          E DS                  INZ
     D KYWA20        E DS                  INZ

     D WA21          E DS                  INZ
     D KYWA21        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ

     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ

     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXKUSR        E DS                  INZ

     D EXTREND       E DS
     D RTTREND       E DS

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
     D/COPY QCPYSRC,EXUX05

     D EXWA21          DS                  INZ
     D  EXWA21PRKZ                  256
     D   EXWA21IFKZ                   1    OVERLAY(EXWA21PRKZ:*NEXT)
     D   EXWA21PRRT                   1    OVERLAY(EXWA21PRKZ:*NEXT)

     D  EXWA21KEYB                  256
     D   EXWA21BLJJ                        OVERLAY(EXWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLJJ)
     D   EXWA21BLNR                        OVERLAY(EXWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLNR)
     D   EXWA21BLPO                        OVERLAY(EXWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLPO)

     D  EXWA21NKEY                  256
     D   EXWA21NBLJ                        OVERLAY(EXWA21NKEY:*NEXT)
     D                                     LIKE(WA21BLJJ)
     D   EXWA21NBLN                        OVERLAY(EXWA21NKEY:*NEXT)
     D                                     LIKE(WA21BLNR)
     D   EXWA21NBLP                        OVERLAY(EXWA21NKEY:*NEXT)
     D                                     LIKE(WA21BLPO)

     D  EXWA21DATE                 1024
     D   EXWA21TENR                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21TENR)
     D   EXWA21PREI                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21PREI)
     D   EXWA21PDIM                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21PDIM)
     D   EXWA21STK1                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21STK1)
     D   EXWA21KAJJ                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21KAJJ)
     D   EXWA21KANR                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21KANR)
     D   EXWA21TLKZ                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21TLKZ)
     D   EXWA21AWPZ                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21AWPZ)
     D   EXWA21AWWT                        OVERLAY(EXWA21DATE:*NEXT)
     D                                     LIKE(WA21AWWT)

     D RTWA21          DS                  INZ
     D  RTWA21KEYB                  256
     D   RTWA21BLJJ                        OVERLAY(RTWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLJJ)
     D   RTWA21BLNR                        OVERLAY(RTWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLNR)
     D   RTWA21BLPO                        OVERLAY(RTWA21KEYB:*NEXT)
     D                                     LIKE(WA21BLPO)

     D  RTWA21DATE                 1024
     D   RTWA21TENR                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21TENR)
     D   RTWA21PREI                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21PREI)
     D   RTWA21PDIM                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21PDIM)
     D   RTWA21STK1                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21STK1)
     D   RTWA21KAJJ                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21KAJJ)
     D   RTWA21KANR                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21KANR)
     D   RTWA21TLKZ                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21TLKZ)
     D   RTWA21AWPZ                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21AWPZ)
     D   RTWA21AWWT                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21AWWT)
     D   RTWA21TSTP                        OVERLAY(RTWA21DATE:*NEXT)
     D                                     LIKE(WA21TSTP)

      //*************************************************************************
      //**  Programmstatus Datenstruktur                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  Einzelfelder                                                      ***
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
     D MODXXX          S              1
     D MODYYY          S              1
     D WKTRPAQQQQ      S              1
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
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFWA21BLJJ      S                   LIKE(KYWA21BLJJ)
     D OFWA21BLNR      S                   LIKE(KYWA21BLNR)
     D OFWA21BLPO      S                   LIKE(KYWA21BLPO)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKFEAT          S              1
     D WKFENR          S              4
     D WKINFO          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10
     D W$MSGA          S              3

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WA21TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA21TSTP                          LIKE(WA21TSTP)

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
      // Parameter:      #W$MSGA
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
     D  #W$MSGA                            LIKE(W$MSGA)
     D                                     OPTIONS(*NOPASS)

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

      //*************************************************************************
      //**  Programmstart                                                     ***
      //*************************************************************************
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
       EXSR OFFUKT;
       *IN = *OFF;
       *IN28 = C#IN28;

       IF WKIOKZ = *ON;
         C#WNDW = *ON;
       ENDIF;

       SELECT;
       WHEN PCPGST = 'ENDE  ';
         // Bildschirmformat schliessen
         IF WKIOKZ = *ON;
           CLOSE TRWA21FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';
       WHEN PCPGST = 'PWA21 ';
         EXSR PWA21;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA21;

         IF WKFENR = *ZERO;
           EXSR LWA21;
         ENDIF;

         WKIFMT = '00';

       // Externes Update
       WHEN EXWA21IFKZ <> *BLANK;
         exsr IFWA21;
         WKIFMT = '00';

       WHEN DATEST = '5';
         PCPGST = '5     ';
       ENDSL;

       //*************************************************************************
       //**  Programmsteuerung                                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           EXSR AUFFOR;
           OPEN(E) TRWA21FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA21';
             EXTRDZAUSW = 'TRWA21';
             EXSR ERTRDZ;
             WKTRDZ = *ON;
           ENDIF;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         WHEN WKIFMT = 'K1';
           EXSR BILDK1;
         ENDSL;
       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) TRWA21FM;
         WKIOKZ = *OFF;
       ENDIF;

       RTTRNDRTCD = #CRTCD;
       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;
         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         // Firma in alle Keystrukten setzen
         KYBLKOFIRM = DAFIRM;  // BLKO
         KYBLPAFIRM = DAFIRM;  // BLPA
         KYLFFI = DAFIRM;      // LIEF
         KYSYTPFIRM = DAFIRM;  // SYTP
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA20FIRM = DAFIRM;  // WA20
         KYWA21FIRM = DAFIRM;  // WA21

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA21FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA21FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXTREND                        ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR EXDATA;
         EXDATAFILE = 'EXTREND';
         EXDATADATA = EXTREND;
         C_INZDATASTR(EXDATA:RTDATA);
         EXTREND = RTDATADATA;

         PCPGST  = EXTRNDPGST;
         EXWA21PRKZ = EXTRNDPRKZ;

         EXWA21KEYB = EXTRNDKEYB;
         MONITOR;
           EXWA21BLJJ = %INT(%SUBST(EXWA21KEYB:01:04));
         ON-ERROR *PROGRAM;
           EXWA21BLJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         KYWA21BLJJ = EXWA21BLJJ;
         KYWA21BLNR = EXWA21BLNR;
         MONITOR;
           EXWA21BLPO = %INT(%SUBST(EXWA21KEYB:11:04));
         ON-ERROR *PROGRAM;
           EXWA21BLPO = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         KYWA21BLPO = EXWA21BLPO;

         DSWA21BLJJ = EXWA21BLJJ;
         DSWA21BLNR = EXWA21BLNR;
         DSWA21BLPO = EXWA21BLPO;

         EXWA21NKEY = EXTRNDNKEY;
         MONITOR;
           EXWA21NBLJ = %INT(%SUBST(EXWA21NKEY:01:04));
         ON-ERROR *PROGRAM;
           EXWA21NBLJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         DSWA21NBLJ = EXWA21NBLJ;
         DSWA21NBLN = EXWA21NBLN;
         MONITOR;
           EXWA21NBLP = %INT(%SUBST(EXWA21NKEY:11:04));
         ON-ERROR *PROGRAM;
           EXWA21NBLP = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         EXWA21DATE = EXTRNDDATE;
         MONITOR;
           EXWA21PREI = %DEC(%SUBST(EXWA21DATE:16:11):11:3);
         ON-ERROR *PROGRAM;
           EXWA21PREI = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           EXWA21STK1 = %DEC(%SUBST(EXWA21DATE:28:11):11:3);
         ON-ERROR *PROGRAM;
           EXWA21STK1 = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           EXWA21KAJJ = %INT(%SUBST(EXWA21DATE:39:04));
         ON-ERROR *PROGRAM;
           EXWA21KAJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           EXWA21AWPZ = %DEC(%SUBST(EXWA21DATE:50:5):5:2);
         ON-ERROR *PROGRAM;
           EXWA21AWPZ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           EXWA21AWWT = %DEC(%SUBST(EXWA21DATE:55:11):11:2);
         ON-ERROR *PROGRAM;
           EXWA21AWWT = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         CLEAR RTTREND;

         CLEAR RTWA21BLJJ;
         CLEAR RTWA21BLPO;
         RTTRNDKEYB = RTWA21KEYB;

         CLEAR RTWA21DATE;
         CLEAR RTWA21PREI;
         CLEAR RTWA21STK1;
         CLEAR RTWA21KAJJ;
         CLEAR RTWA21AWPZ;
         CLEAR RTWA21AWWT;
         CLEAR RTWA21TSTP;
         RTTRNDDATE = RTWA21DATE;

         RTTRNDFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Vorlauf                                                           ***
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
       //**  Aufbereitung für Formatanzeige                                    ***
       //*************************************************************************
       BEGSR AUFFOR;

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'TRWA21';
         EXSR RDTRDNTRDN;
         DSKOPF = %SUBST(EXFIRMKNAM:1:30) + ' ' + EXTRDNTEXT;
         WNKOPF = EXTRDNTEXT;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILD01                                              ***
       //*************************************************************************
       BEGSR BILD01;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR B01DS;

         DOW WKIFMT = '01';
           WKFLPORECN = 'TRWA2101';
           WRITE TRWA21CL;
           EXSR EFLPO;

           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;

           WRITE TRWA2101;
           WRITE TRWA21B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           //FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA2101;
           *IN98 = %ERROR;
           *IN99 = %EOF;

           IF *IN98 = *ON OR *IN99 = *ON;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON AND FUKT04 = *ON;

             EXSR MCAUFR;
             IF WKTRTP = *ON OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#ACCS = *ON AND FUKT10 = *ON;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             C#WNDW = *ON;
             ITER;

           WHEN C#FUKT <> *ZERO AND FUKT10 = *ON;
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

           IF PCPGST <> '5     ' AND PCPGST <> 'F     ';

             IF PCPGST <> 'MUSTER';
               EXSR BILDPR;
               IF WKFENR <> *ZERO;
                 ITER;
                 ENDIF;
               ENDIF;

             EXSR UWA21;

             SELECT;
             WHEN PCPGST = 'MUSTER';
               EXSR UTRMU;
             ENDSL;
           ENDIF;

           IF PCPGST <> 'MUSTER';
             WKPGST = 'DIREKT';
             EXSR TRTRDZ;
           ENDIF;

           IF PCPGST <> *BLANK OR WKCFMT = *ON;
             #CRTCD = *BLANK;
             #CPGST = *BLANK;
             WKIFMT = '00';
           ELSE;
             KYWA21BLJJ = *ZERO;
             KYWA21BLNR = *BLANK;
             KYWA21BLPO = *ZERO;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA21;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA21;
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 01                                        ***
       //*************************************************************************
       BEGSR B01DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;
         PCRTCD = #CRTCD;

         SELECT;
         WHEN PCPGST = *BLANK OR PCPGST = 'MUSTER';
           CLEAR WA21;
           EXSR ETRMU;
           EXSR EWA21;
           WA21BLJJ = KYWA21BLJJ;
           WA21BLNR = KYWA21BLNR;
           WA21BLPO = KYWA21BLPO;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA21;

           EXINFOFILE = 'WA21';
           EXINFODATA = %ADDR(WA21);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA21USER;
           WKJDAT = WA21JDAT;
           WKJZEI = WA21JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA21;
             EXSR EWA21;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA21BLJJ = WA21BLJJ;
         DSWA21BLNR = WA21BLNR;
         DSWA21BLPO = WA21BLPO;

         DSWA21TENR = WA21TENR;
         DSWA21PREI = WA21PREI;
         DSWA21PDIM = WA21PDIM;
         DSWA21STK1 = WA21STK1;
         DSWA21KAJJ = WA21KAJJ;
         DSWA21KANR = WA21KANR;
         DSWA21TLKZ = WA21TLKZ;
         DSWA21AWPZ = WA21AWPZ;
         DSWA21AWWT = WA21AWWT;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA21IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         DSWA20LFNR = *BLANK;
         TXWA20LFNR = *BLANK;
         DSLIEFPOLD = *BLANK;
         DSLIEFPOLZ = *BLANK;

         DSWA20BLGA = *BLANK;
         TXWA20BLGA = *BLANK;
         DSWA20FRUS = *BLANK;
         TXWA20FRUS = *BLANK;
         DSWA20FRDA = *ZERO;

         DSTEILTBZ1 = *BLANK;
         DSTEILTBZ2 = *BLANK;

         TXWA21PDIM = *ZERO;
         TXWA21TLKZ = *ZERO;
         TXWA21EKDM = *ZERO;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA21BLNR <> *BLANK;
           EXSR PRWA21BLNR;
         ENDIF;

         IF DSWA21TENR <> *BLANK;
           EXSR PRWA21TENR;
         ENDIF;

         //EK PREIS ZUR ANZEIGE ERMITELN AUS PREI MIT BEGRIFF LP1
         EXSR PRWA21EKPR;

         IF DSWA21PDIM <> *BLANK;
           EXSR PRWA21PDIM;
         ENDIF;

         IF DSWA21EKDM <> *BLANK;
           EXSR PRWA21EKDM;
         ENDIF;

         IF DSWA21TLKZ <> *BLANK;
           EXSR PRWA21TLKZ;
         ENDIF;

         EXTRPBBFMT = 'TRWA2101';
         EXSR CSTRPB;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;
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
           EXFLPOFLDN = 'DSWA21TENR';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA21TENR';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           SELECT;
           WHEN DSWA21BLJJ = *ZERO;
             EXFLPOFLDN = 'DSWA21BLJJ';
           WHEN DSWA21BLNR = *BLANK;
             EXFLPOFLDN = 'DSWA21BLNR';
           WHEN DSWA21BLPO = *ZERO;
             EXFLPOFLDN = 'DSWA21BLPO';
           OTHER;
             EXFLPOFLDN = 'DSWA21TENR';
           ENDSL;

         ENDSL;

         // Meldung "Bearbeitet ... am ... um ..." ausgeben
         IF WKFENR = *ZERO
           AND PCPGST <> *BLANK
           AND PCPGST <> 'MUSTER';

           CLEAR EXDATE;
           EXDATEDATV = WKJDAT;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           W$PA03 = %TRIM(%EDITW(RTDATEDATE: '0 .  .    '));
           W$PA04 = WKUSER;
           W$PA05 = %TRIM(%EDITW(WKJZEI: '0 :  :  '));
           WKFENR = '0076';
         ENDIF;

         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILDK1                                              ***
       //*************************************************************************
       BEGSR BILDK1;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR BK1DS;

         DOW WKIFMT = 'K1';
           WKFLPORECN = 'TRWA21K1';
           EXSR EFLPO;
           WRITE TRWA21W2;
           WRITE TRWA21K1;
           WRITE W2WA21B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA21K1;

           IF %ERROR OR %EOF;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON AND FUKT04 = *ON;
             EXSR MCAUFR;
             IF WKTRTP = *ON OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             C#WNDW = *ON;
             ITER;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           EXSR BILDPR;
           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR KWA21;
           EXSR UWA21;

           WKIFMT = '00';
           %SUBST(RTTRNDKEYB:01:04) = %EDITC(KYWA21BLJJ:'X');
           %SUBST(RTTRNDKEYB:05:06) = KYWA21BLNR;
           %SUBST(RTTRNDKEYB:11:04) = %EDITC(KYWA21BLPO:'X');
         ENDDO;

         RTTRNDRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA21BLJJ = KYWA21BLJJ;
         DSWA21BLNR = KYWA21BLNR;
         DSWA21BLPO = KYWA21BLPO;

         DSWA21NBLJ = KYWA21BLJJ;
         DSWA21NBLN = KYWA21BLNR;
         DSWA21NBLP = *ZERO;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA21NBLP';

       ENDSR;

       //*************************************************************************
       //**  Funktionstaste 4 für alle Bilder                                  ***
       //*************************************************************************
       BEGSR MCAUFR;

         //  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
         //  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
         //  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
         //  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
         WKTRTP = *OFF;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;

         WHEN EXFLPOKZIO = *OFF;
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA21BLNR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA21TENR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA21PDIM';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA21KANR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA21TLKZ';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA21BLNR';

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für Formate                                         ***
       //*************************************************************************
       BEGSR BILDPR;

         //  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
         //  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
         //  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
         //  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).

         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         FLDDS = EXFLPOFLDA;

         FOR FL = 1 TO 100;
           IF FLD(FL) = *BLANK;
             LEAVE;
           ENDIF;

           FLDNAM = FLD(FL);
           EXFLPOFLDN = FLDNAM;
           EXSR EFLPO;

           SELECT;

           WHEN EXFLPOKZIO = *OFF;

           WHEN FLDNAM = 'DSWA21BLNR' AND C#LCK1 = *OFF;
             EXSR PRWA21BLNR;

           WHEN FLDNAM = 'DSWA21BLPO' AND C#LCK1 = *OFF;
             EXSR PRWA21BLPO;

           WHEN FLDNAM = 'DSWA21TENR' AND C#LCK0 = *OFF;
             EXSR PRWA21TENR;

           WHEN FLDNAM = 'DSWA21PREI' AND C#LCK0 = *OFF;
             EXSR PRWA21PREI;

           WHEN FLDNAM = 'DSWA21EKPR' AND C#LCK0 = *OFF;
             EXSR PRWA21EKPR;

           WHEN FLDNAM = 'DSWA21PDIM' AND C#LCK0 = *OFF;
             EXSR PRWA21PDIM;

           WHEN FLDNAM = 'DSWA21EKDM' AND C#LCK0 = *OFF;
             EXSR PRWA21EKDM;

           WHEN FLDNAM = 'DSWA21STK1' AND C#LCK0 = *OFF;
             EXSR PRWA21STK1;

           WHEN FLDNAM = 'DSWA21KANR' AND C#LCK0 = *OFF;
             EXSR PRWA21KANR;

           WHEN FLDNAM = 'DSWA21TLKZ' AND C#LCK0 = *OFF;
             EXSR PRWA21TLKZ;

           WHEN FLDNAM = 'DSWA21AWPZ' AND C#LCK0 = *OFF;
             EXSR PRWA21AWPZ;

           WHEN FLDNAM = 'DSWA21AWWT' AND C#LCK0 = *OFF;
             EXSR PRWA21AWWT;

           WHEN FLDNAM = 'DSWA21NBLN';
             EXSR PRWA21NBLN;

           WHEN FLDNAM = 'DSWA21NBLP';
             EXSR PRWA21NBLP;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA21BLJJ = DSWA21NBLJ;
           KYWA21BLNR = DSWA21NBLN;
           KYWA21BLPO = DSWA21NBLP;
           CHIDS = '01C';
           EXSR CHWA21;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA21NBLP';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA21BLJJ = DSWA21BLJJ;
           KYWA21BLNR = DSWA21BLNR;
           KYWA21BLPO = DSWA21BLPO;
           CHIDS = '01C';
           EXSR CHWA21;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA21BLPO';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA21BLPO';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA21';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA21;
         TRMUJNAM = DAJNAM;
         TRMUPROG = WKCHPN;
         TRMUBIBL = WKCHPL;
         TRMUUSER = DAUSER;
         TRMUJZEI = %DEC(%TIME());
         TRMUJDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN CHI(6) = *ON;
           CHIDS = '01W';
           EXSR CHTRMU;
           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHTRMU;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WA21                                     ***
       //*************************************************************************
       BEGSR KWA21;

         KYWA21BLJJ = DSWA21BLJJ;
         KYWA21BLNR = DSWA21BLNR;
         KYWA21BLPO = DSWA21BLPO;
         CHIDS = '01C';
         EXSR CHWA21;
         IF WKFENR = *ZERO;
           DSWA21TENR = WA21TENR;
           DSWA21PREI = WA21PREI;
           DSWA21PDIM = WA21PDIM;
           DSWA21STK1 = WA21STK1;
           DSWA21KAJJ = WA21KAJJ;
           DSWA21KANR = WA21KANR;
           DSWA21TLKZ = WA21TLKZ;
           DSWA21AWPZ = WA21AWPZ;
           DSWA21AWWT = WA21AWWT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA21-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA21;

         OFWA21BLJJ = KYWA21BLJJ;
         OFWA21BLNR = KYWA21BLNR;
         OFWA21BLPO = KYWA21BLPO;
         IF KYWA21BLPO = *ZERO;
           OFWA21BLPO = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA21;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA21FIRM = KYWA21FIRM
           AND WA21BLJJ <= OFWA21BLJJ
           AND WA21BLNR <= OFWA21BLNR
           AND WA21BLPO <= OFWA21BLPO;

           IF WA21LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA21LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA21;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;

         CLEAR RTWA21BLJJ;
         CLEAR RTWA21BLPO;
         RTTRNDKEYB = RTWA21KEYB;

         CLEAR RTWA21DATE;
         CLEAR RTWA21PREI;
         CLEAR RTWA21STK1;
         CLEAR RTWA21KAJJ;
         CLEAR RTWA21AWPZ;
         CLEAR RTWA21AWWT;
         CLEAR RTWA21TSTP;
         RTTRNDDATE = RTWA21DATE;

         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WA21                                          ***
       //*************************************************************************
       BEGSR LWA21;

         OFWA21BLJJ = KYWA21BLJJ;
         OFWA21BLNR = KYWA21BLNR;
         OFWA21BLPO = KYWA21BLPO;
         IF KYWA21BLPO = *ZERO;
           OFWA21BLPO = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA21;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA21FIRM = KYWA21FIRM
           AND WA21BLJJ <= OFWA21BLJJ
           AND WA21BLNR <= OFWA21BLNR
           AND WA21BLPO <= OFWA21BLPO;

           EXSR LPOSI;

           KYWA21BLJJ = WA21BLJJ;
           KYWA21BLNR = WA21BLNR;
           KYWA21BLPO = WA21BLPO;
           CHIDS = '01CU';
           EXSR CHWA21;

           CHIDS = '01D';
           EXSR CHWA21;

           CHIDS = '01R';
           EXSR CHWA21;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;

         CLEAR RTWA21BLJJ;
         CLEAR RTWA21BLPO;
         RTTRNDKEYB = RTWA21KEYB;

         CLEAR RTWA21DATE;
         CLEAR RTWA21PREI;
         CLEAR RTWA21STK1;
         CLEAR RTWA21KAJJ;
         CLEAR RTWA21AWPZ;
         CLEAR RTWA21AWWT;
         CLEAR RTWA21TSTP;
         RTTRNDDATE = RTWA21DATE;

         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen der abhängigen Sätze                                      ***
       //*************************************************************************
       BEGSR LPOSI;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;

         PCPGST = '4     ';

       ENDSR;

       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWA21;

         IF EXWA21IFKZ = '0';
           // Satz auf Existenz prüfen
           KYWA21BLJJ = EXWA21BLJJ;
           KYWA21BLNR = EXWA21BLNR;
           KYWA21BLPO = EXWA21BLPO;
           CHIDS = '01C';
           EXSR CHWA21;
           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;
         ENDIF;

         EXSR B01DS;

         IF EXWA21TENR <> *BLANK;
           DSWA21TENR = EXWA21TENR;
         ENDIF;

         IF EXWA21PREI <> *ZERO;
           DSWA21PREI = EXWA21PREI;
         ENDIF;

         IF EXWA21PDIM <> *BLANK;
           DSWA21PDIM = EXWA21PDIM;
         ENDIF;

         IF EXWA21STK1 <> *ZERO;
           DSWA21STK1 = EXWA21STK1;
         ENDIF;

         IF EXWA21KAJJ <> *ZERO;
           DSWA21KAJJ = EXWA21KAJJ;
         ENDIF;

         IF EXWA21KANR <> *BLANK;
           DSWA21KANR = EXWA21KANR;
         ENDIF;

         IF EXWA21TLKZ <> *BLANK;
           DSWA21TLKZ = EXWA21TLKZ;
         ENDIF;

         IF EXWA21AWPZ <> *ZERO;
           DSWA21AWPZ = EXWA21AWPZ;
         ENDIF;

         IF EXWA21AWWT <> *ZERO;
           DSWA21AWWT = EXWA21AWWT;
         ENDIF;

         // Prüfung der Felder nur dann wenn dies expliziet von extern mitgegeben wird
         WKFENR = *ZERO;
         IF EXWA21PRRT = *ON OR EXWA21PRRT = *BLANK;
           WKFLPORECN = 'TRWA2101';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDIF;

         IF WKFENR = *ZERO;
           EXSR UWA21;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTTREND;

         CLEAR RTWA21BLJJ;
         CLEAR RTWA21BLPO;
         RTTRNDKEYB = RTWA21KEYB;

         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

         CLEAR RTWA21DATE;
         CLEAR RTWA21PREI;
         CLEAR RTWA21STK1;
         CLEAR RTWA21KAJJ;
         CLEAR RTWA21AWPZ;
         CLEAR RTWA21AWWT;
         IF #CRTCD = 'W';  // TSTP für neu angelegten Satz zurückgeben
           RTWA21TSTP = WA21TSTP;
         ELSE;
           CLEAR RTWA21TSTP;
         ENDIF;
         RTTRNDDATE = RTWA21DATE;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WA21LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA21;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA21                                                 ***
       //*************************************************************************
       BEGSR UWA21;

         KYWA21BLJJ = DSWA21BLJJ;
         KYWA21BLNR = DSWA21BLNR;
         KYWA21BLPO = DSWA21BLPO;

         IF PCPGST = '3     ';
           KYWA21BLJJ = DSWA21NBLJ;
           KYWA21BLNR = DSWA21NBLN;
           KYWA21BLPO = DSWA21NBLP;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA21;

         WA21TENR = DSWA21TENR;
         WA21PREI = DSWA21PREI;
         WA21PDIM = DSWA21PDIM;
         WA21STK1 = DSWA21STK1;
         WA21KAJJ = DSWA21KAJJ;
         WA21KANR = DSWA21KANR;
         WA21TLKZ = DSWA21TLKZ;
         WA21AWPZ = DSWA21AWPZ;
         WA21AWWT = DSWA21AWWT;

         WA21JNAM = DAJNAM;
         WA21PROG = DAPROG;
         WA21BIBL = WKCHPL;
         WA21USER = DAUSER;
         WA21JZEI = %DEC(%TIME());
         WA21JDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA21;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA21TSTP);
           WA21ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA21;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA21;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune BLNR                                                   ***
       //*************************************************************************
       BEGSR PRWA21BLNR;

         EXFLPOFLDN = 'DSWA21BLNR';
         DSWA20LFNR = *BLANK;
         TXWA20LFNR = *BLANK;
         DSLIEFPOLD = *BLANK;
         DSLIEFPOLZ = *BLANK;

         DSWA20BLGA = *BLANK;
         TXWA20BLGA = *BLANK;

         DSWA20FRUS = *BLANK;
         TXWA20FRUS = *BLANK;

         DSWA20FRDA = *ZERO;

         KYWA20BLJJ = DSWA21BLJJ;
         KYWA20BLNR = DSWA21BLNR;
         CHIDS  = '01C';
         EXSR CHWA20;
         DSWA20LFNR = WA20LFNR;
         DSWA20FRUS = WA20FRUS;
         DSWA20BLGA = WA20BLGA;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         KYLFNR = DSWA20LFNR;
         CHIDS  = '01C';
         EXSR CHLIEF;
         TXWA20LFNR = LFKNAM;
         DSLIEFPOLD = LFPOLD;
         DSLIEFPOLZ = LFPOLZ;

         IF DSWA20BLGA <> *BLANK;
           KYBLPABLGA = DSWA20BLGA;
           CHIDS  = '01C';
           EXSR CHBLPA;
           TXWA20BLGA = BLPAABEZ;
         ENDIF;

         IF DSWA20FRUS <> *BLANK;
           EXKUSRUUSR = DSWA20FRUS;
           EXSR PRKUSR;
           TXWA20FRUS = EXKUSRUNAM;
         ENDIF;

         IF WA20FRDA <> *ZERO;
           CLEAR EXDATE;
           EXDATEDATV = WA20FRDA;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           DSWA20FRDA = RTDATEDATE;
         ENDIF;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune BLPO                                                   ***
       //*************************************************************************
       BEGSR PRWA21BLPO;

         EXFLPOFLDN = 'DSWA21BLPO';

         IF DSWA21BLPO = *ZERO;
           WKFENR = '0031';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune TENR                                                   ***
       //*************************************************************************
       BEGSR PRWA21TENR;

         EXFLPOFLDN = 'DSWA21TENR';

         KYTENR = DSWA21TENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWA21TENR = TETENR;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune PREI                                                   ***
       //*************************************************************************
       BEGSR PRWA21PREI;

         EXFLPOFLDN = 'DSWA21PREI';

       ENDSR;

       //*************************************************************************
       //**  PR-Routune EKPR                                                   ***
       //*************************************************************************
       BEGSR PRWA21EKPR;

         DSWA21EKPR = 0;
         DSWA21EKDM = *BLANK;
         EXFLPOFLDN = 'DSWA21EKPR';
         Exec SQL select PREZPR, PRPDVK  into :DSWA21EKPR, :DSWA21EKDM
           from PREI where
           PRFIRM = :DAFIRM and
           PRKDLI = :TESTLF and
           PRTENR = :TETENR and
           PRBEGR = 'LP1';

         IF SQLCOD <> 0;
           DSWA21EKPR = 0;
           DSWA21EKDM = *BLANK;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune PDIM                                                   ***
       //*************************************************************************
       BEGSR PRWA21PDIM;

         EXFLPOFLDN = 'DSWA21PDIM';
         TXWA21PDIM = *BLANK;

         IF DSWA21PREI <> *ZERO OR DSWA21PDIM <> *BLANK;
           KYTPTA = 'PDIM';
           KYTPTC = DSWA21PDIM;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXWA21PDIM = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune EKDM                                                   ***
       //*************************************************************************
       BEGSR PRWA21EKDM;

         EXFLPOFLDN = 'DSWA21EKDM';
         TXWA21EKDM = *BLANK;

         IF DSWA21EKPR <> *ZERO OR DSWA21EKDM <> *BLANK;
           KYTPTA = 'PDIM';
           KYTPTC = DSWA21EKDM;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXWA21EKDM = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune STK1                                                   ***
       //*************************************************************************
       BEGSR PRWA21STK1;

         EXFLPOFLDN = 'DSWA21STK1';

       ENDSR;

       //*************************************************************************
       //**  PR-Routune KANR                                                   ***
       //*************************************************************************
       BEGSR PRWA21KANR;

         EXFLPOFLDN = 'DSWA21KANR';

       ENDSR;

       //*************************************************************************
       //**  PR-Routune TLKZ                                                   ***
       //*************************************************************************
       BEGSR PRWA21TLKZ;

         EXFLPOFLDN = 'DSWA21TLKZ';

         EXTRPCPGGR = 'BOOL';
         EXTRPCCODE = DSWA21TLKZ;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         TXWA21TLKZ = EXTRPCTEXT;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine AWPZ                                                   ***
       //*************************************************************************
       BEGSR PRWA21AWPZ;

         EXFLPOFLDN = 'DSWA21AWPZ';

       ENDSR;

       //*************************************************************************
       //**  PR-Routine AWWT                                                   ***
       //*************************************************************************
       BEGSR PRWA21AWWT;

         EXFLPOFLDN = 'DSWA21AWWT';

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NBLN                                                   ***
       //*************************************************************************
       BEGSR PRWA21NBLN;

         EXFLPOFLDN = 'DSWA21NBLN';

         KYWA20BLJJ = DSWA21NBLJ;
         KYWA20BLNR = DSWA21NBLN;
         CHIDS  = '01C';
         EXSR CHWA20;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NBLP                                                   ***
       //*************************************************************************
       BEGSR PRWA21NBLP;

         EXFLPOFLDN = 'DSWA21NBLP';

         IF DSWA21NBLP = *ZERO;
           WKFENR = '0031';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA21';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA21;

           CLEAR EXDATA;
           EXDATAFILE = 'WA21';
           EXDATADATA = WA21;
           C_INZDATASTR(EXDATA: RTDATA);

           WA21 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA21;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA21';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKCFMT = TAPCDE;
         IF WKCFMT <> *ON;
           WKCFMT = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'MODXXX';
         KYTAPA = 'MODXXX';
         CHIDS = '01C';
         EXSR CHTRPA;
         MODXXX = TAPCDE;
         IF MODXXX <> *ON;
           MODXXX = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'QQQQ';
         KYTAPA = 'QQQQ';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAQQQQ = TAPCDE;
         IF WKTRPAQQQQ <> *ON;
           WKTRPAQQQQ = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'MODYYY';
         KYTAPA = 'MODYYY';
         CHIDS = '01C';
         EXSR CHTRPA;
         IF TAPCDE = '01';
           MODYYY = *ON;
         ELSE;
           MODYYY = *OFF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Zugriffe                                                          ***
       //*************************************************************************
       BEGSR TRTRDZ;

         WKTRTP = *OFF;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;
           CLEAR EXTRDN;
           EXTRDNPGST = WKPGST;
           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;

           EXTRDNPGNA = 'TRWA21';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA21B1'    EXTRDNPGNA
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
             WKFENR = *ZERO;
             W$MSGA = *BLANK;
           ENDIF;

           IF EXTRDNPGST = 'WEITER';
             WKPGST = 'WEITER';
             WKFENR = *ZERO;
             W$MSGA = *BLANK;
           ENDIF;

           IF C#FUKT <> *ZERO
             AND C#ACCS <> *ON;
             LEAVE;
           ENDIF;

           #CRTCD = *BLANK;
         ENDDO;

       ENDSR;

      /END-FREE
     C/COPY QCPYSRC,SFTRDZ
      /FREE

       //*************************************************************************
       //**  Aufbereiten der Nachrichten                                       ***
       //*************************************************************************
       BEGSR AUMSG;

         C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
         W$PA06:W$PA07:W$MSGA);

         PGMNAM = 'TRWA21';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA21W2;
         OTHER;
           WRITE TRWA21CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA21W2;
         OTHER;
           WRITE TRWA21CT;
         ENDSL;

         W$PA03 = *BLANK;
         W$PA04 = *BLANK;
         W$PA05 = *BLANK;
         W$PA06 = *BLANK;
         W$PA07 = *BLANK;
         W$PA08 = *BLANK;
         W$MSGA = *BLANK;
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHBLKO
      /COPY QCPYSRC,CHBLPA
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA20
      /COPY QCPYSRC,CHWA21
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRKUSR
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
