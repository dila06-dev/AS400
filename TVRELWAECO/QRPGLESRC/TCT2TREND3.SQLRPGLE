
      //************************************************************************
      //
      //      Programmname: TCT2TREND3
      //      Erstellt  am: 08.06.2026
      //      Erstellt von: M.Gang
      //
      //      Beschreibung: TCT2TREND3 tct Daten integrieren in ERP
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
      //
      // Restartmöglichkeiten:
      // _____________________
      //
      //
      //
      //
      //
      //
      //
      //------------------------------------------------------------------------
      //    S T E U E R - B E S T I M M U N G E N
      //------------------------------------------------------------------------
     h datfmt(*EUR)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*NO) actgrp(*CALLER)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     fTCT_TREND uf   e             DISK    RENAME(TCT_TREND :PHY01R)
     f                                     usropn

     fteil01    uf   e           k DISK

     flief01    if   e           k DISK
     f
     flpif01    if   e           k DISK
     f
     fteew01    if   e           k DISK
     f
     fzotn01    uf a e           k DISK
     f
     fkazk01    uf a e           k DISK
     f
     f#preil5   if   e           k DISK
     f
     fIVSC01    uf a e           k DISK
     f

      /eject
      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------

      // System-Datenstruktur

      // dsSystem       sds
      //  aThisProgramm          1     10
      //  aThisWorkStn         244    253
      //  aThisUser            254    263
     d DSPGM          SDS
     d  §§§PGM                 1     10
     d  §§§STS                11     15
     d  §§§SEQ                21     28
     d  §§§SR                 29     36
     d  §§§MSG                40     46
     d  §§§LIB                81     90
     d  §§§MTX                91    170
     d  §§§FIL               201    208
     d  §§§FST               209    243
     d  §§§JOB               244    253
     d  §§§USR               254    263
     d  §§§JNO               264    269  0
     d  §§§SDT               276    281  0
     d  §§§STM               282    287  0


     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

       // ______________________________________________________________________
       // qmhsndpm
       // ______________________________________________________________________
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                    256A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                    1A

       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
       //p_md                         001a   DIM(256)
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a

       // ______________________________________________________________________
       // define data areas
       // ______________________________________________________________________
     D tct2trend3      s             10p 0 dtaara


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d TCT_TREND_i   E DS                  ExtName(TCT_TREND :*input)
     d                                     Qualified

     d TCT_TREND_o   E DS                  ExtName(TCT_TREND:*output)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil_o        E DS                  ExtName(teil01:*output)
     d                                     Qualified

     d lief_k        E DS                  ExtName(lief01:*key)
     d                                     Qualified

     d lief_i        E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d lpif_k        E DS                  ExtName(lpif01:*key)
     d                                     Qualified

     d lpif_i        E DS                  ExtName(lpif01:*input)
     d                                     Qualified


     d zotn_k        E DS                  ExtName(zotn01:*key)
     d                                     Qualified

     d zotn_i        E DS                  ExtName(zotn01:*input)
     d                                     Qualified

     d zotn_o        E DS                  ExtName(zotn01:*output)
     d                                     Qualified

     d kazk_k        E DS                  ExtName(kazk01:*key)
     d                                     Qualified

     d kazk_i        E DS                  ExtName(kazk01:*input)
     d                                     Qualified

     d kazk_o        E DS                  ExtName(kazk01:*output)
     d                                     Qualified

     d prei_k        E DS                  ExtName(#preil5:*key)
     d                                     Qualified

     d prei_i        E DS                  ExtName(#preil5:*input)
     d                                     Qualified

     d IVSC_k        E DS                  ExtName(IVSC01:*key)
     d                                     Qualified

     d IVSC_i        E DS                  ExtName(IVSC01:*input)
     d                                     Qualified

     d IVSC_o        E DS                  ExtName(IVSC01:*output)
     d                                     Qualified



      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

      // dummy512
      //------------------------------------------------------------------------
      // p_md            s            001a   inz
      //                                     dim(256)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz

      // qmhsndpm
      // ______________________________________________________________________
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz




      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D breakpoint      s              1a   inz
     D err_msg         s              1a   inz
     D week            s              1s 0 inz

     D suffix          s             06A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     D years           s              4s 0 inz
     D §ENTRY#         s             11A   inz
     D §rkreda         s              8s 0 inz
     D §rplipo         s              4a   inz
     D §rkkon          s             10a   inz
     D §rpnesu         s             13s 2 inz
     D §§rpnesu        s             13s 2 inz
     D §upload         s            256a   inz
     D §monat          s              2s 0 inz
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §records        s              9s 0 inz
     D §text           s             48a   inz
     D $$TEEWPRGR_     s              1a   inz
     D TEIL_INB_       s              6a   inz
     D zotn_INB_       s              6a   inz
     D kazk_INB_       s              6a   inz
     D p_savef         s             33a
     d yesterday       s               d
     D #yesterday      s              8s 0 inz
     D check           s             10a   inz
     D KAZKBAWT_N      s             11s 3 inz
     D #TPTFLG         s              3s 0 inz
     D #TPTTXT         s             40a   inz

      // Überschreibungen
      //************************************************************************
      //************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    load              1

      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for tct2trend3   ';
       exsr      SR_log;

       exsr  srinit;
       load='0';

       if load='1' or
          load='2';
       //tvrelwaeco/IVEAS_TRAN
       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/IVEAS_TRAN)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/IVEAS_TRAN)';
             exsr      SR_log;
       endmon;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          if week > 0;
             in  *lock *dtaara;
             TCT2TREND3 = TCT2TREND3  + 1;
             out *dtaara;
             open TCT_TREND;

             read TCT_TREND   TCT_TREND_i;
                dow not %eof(TCT_TREND) or  week = 0;
                TEIL_INB_ = *blank;
                zotn_INB_ = *blank;
                kazk_INB_ = *blank;
       //      für upload    20230501
                   if TCT_TREND_i.STATUS_I = '  ';
                      *in20 = '0';
                      TCT_TREND_o  = TCT_TREND_i;
       // *eur yyyy-mm-dd
       // *iso dd.mm.yyyy
       // Test(DE) *eur zollTIMP_i.KAZKGADA;
       // If %Error;
       //    *in20 = '1';
       // Endif;
                      eval      check         =
                                %subst(ZOLLIVEAS_i.DATEADD: 01: 04)    +
                                '-'                          +
                                %subst(ZOLLIVEAS_i.DATEADD: 05: 02)    +
                                '-'                          +
                                %subst(ZOLLIVEAS_i.DATEADD: 07: 02);
                      Test(DE) *iso check;
                      If %Error;
                         *in20 = '1';
                      Endif;
       //      Fehler vorab erkennen
                      if *in20 = '0';
       //n20              eval      #h060  = %char (%date (#h060:*eur) :*eur)
       //n20              eval      #h060  = %char (%date (#h060:*eur) :*iso)
                         exsr  sr_1000;
                      else;
                         TEIL_INB_ = '     ';
                         zotn_INB_ = '     ';
                         kazk_INB_ = 'error dataimport';
                      endif;
       //      für message an IVEAS
                      TCT_TREND_o.STATUS_I  = '10';
                      TCT_TREND_o.TSTAMP_I  = %timestamp();

       //      update
                      update PHY01R    TCT_TREND_o;
       //      Protokolldatei Zolltimppo
                      clear            TCT_TREND_o;
                   endif;
                   read TCT_TREND  TCT_TREND_i;
             enddo;
             close TCT_TREND;
       MONITOR;
       Wrk.var1 =
           'CD DIR(''/IVEAS/TCT/TCT2Trend'') ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CD DIR successful FILE(TVRELWAECO/TCT2TREND )    ';
       on-error;
          status='Error by CD DIR object (TVRELWAECO/TCT2TREND )   ';
       endmon;

         eval p_savef   =  'ARTIKEL_Iveas'   +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0)) +
                        '.csv  ';

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       MONITOR;
       Wrk.var1 =
           'RNM OBJ(''ARTIKEL_Iveas.csv'') '+
           'NEWOBJ('+ p_savef +')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rnm    successful FILE(TVRELWAECO/TCT2TREND )    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/TCT2TREND )   ';
       endmon;

          endif;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       eval status ='Ende  FTP Transfer for tct2trend3   ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei
       //-----------------------------------------------------------------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';
         yesterday = %date() -  %days(01);
       //w_datum  = %dec(%date(): *ISO);
       //#yesterday  = %dec(%date(): *ISO);
         #yesterday  = %dec(%date() - %days(01) : *ISO);

       //sql handling
            exec sql
                     whenever not found CONTINUE;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //Schreiben Iveas Interface
       //-----------------------------------------------------------------------

       begsr sr_1000;

       //teil
          teil_k.tefirm    = '01';
          teil_k.tetenr    =  %subst(ZOLLIVEAS_i.ART#:1:15);
          chain %kds(teil_k:2) teil01 teil_I;
          if %found(teil01);
             exsr sr_zotn;
             exsr sr_IVSC;
       //    exsr sr_kazk;
             if teil_i.TEZOTN         =  ZOLLIVEAS_i.ZOLLTARIF   or
                ZOLLIVEAS_i.ZOLLTARIF =  *BLANK                 or
                teil_i.TETEST         =  '90';
                   TEIL_INB_ = 'ERROR ';
                if teil_i.TETEST =  '90';
                   TEIL_INB_ = 'ERROR Staus 90';
                else;
                endif;
             else;
                teil_o = teil_i;
                teil_o.TEZOTN = ZOLLIVEAS_i.ZOLLTARIF;
                teil_o.teuser = §§§usr;
                teil_o.tePROG = §§§pgm;
                teil_o.teJNAM = §§§job;
                teil_o.tebibl = §§§LIB;
                teil_o.teJDAT = %dec(%char(%date():*iso0):8:0);
                teil_o.teJZEI = %dec(%char(%time():*iso0):6:0);
                *in80 = '0';
                if *in80='1';
                   update teil1     teil_o;
                endif;
                TEIL_INB_ = 'UPDATE';
             endif;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_lief aktuell inaktiv
       //-----------------------------------------------------------------------

       begsr sr_lief;

       //LIEF01 initialisiert mit Mandant
          LIEF_k.LFFIRM = teil_i.TEFIRM;
          LIEF_k.LFLFNR = teil_i.TELFNR;
          chain %kds(LIEF_k:2) LIEF01  LIEF_I;
          if %found(LIEF01);
          else;
             clear               LIEF_I;
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_lpif aktuell inaktiv
       //-----------------------------------------------------------------------

       begsr sr_lpif;

       //lpif01 lesen
          Lpif_k.LPFIRM = teil_i.TEFIRM;
          Lpif_k.LPLFNR = teil_i.TELFNR;
          Lpif_k.LPTENR = teil_i.TETENR;
          Lpif_k.LPGADA = %dec(%char(%date():*iso0):8:0);
       //          chain %kds(Lpif_k:3) Lpif01    Lpif_I;
       //          setll %kds(Lpif_k:3) Lpif01    ;
          setgt %kds(Lpif_k:3) Lpif01    ;
          readp Lpif01 Lpif_i;
          if %found(lpif01);
          else;
             clear               Lpif_I;
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_zotn
       //ZOTNZOTN           ZOTN01             Zolltarif-Nr..:
       //ZOTNABEZ           ZOTN01             Bezeichnung...:
       //-----------------------------------------------------------------------

       begsr sr_zotn;

       //neue TarifNummer lesen aktuell
          zotn_k.ZOTNZOTN = ZOLLIVEAS_i.ZOLLTARIF;
          chain %kds(ZOTN_k:1) ZOTN01  ZOTN_I;
          if %found(ZOTN01);
             if ZOTN_i.ZOTNABEZ <> %subst(ZOLLIVEAS_i.ZOLLBEZ:1:30);
                ZOTN_o = ZOTN_i;
                ZOTN_o.ZOTNABEZ = %subst(ZOLLIVEAS_i.ZOLLBEZ:1:30);
                ZOTN_o.ZOTNuser = §§§usr;
                ZOTN_o.ZOTNPROG = §§§pgm;
                ZOTN_o.ZOTNJNAM = §§§job;
                ZOTN_o.ZOTNbibl = §§§LIB;
                ZOTN_o.ZOTNJDAT = %dec(%char(%date():*iso0):8:0);
                ZOTN_o.ZOTNJZEI = %dec(%char(%time():*iso0):6:0);
                *in80 = '0';
                if *in80='1';
                   update zotn1     zotn_o;
                endif;
                zotn_INB_ = 'UPDATE';
             else;
             endif;
          else;
             clear               ZOTN_o;
             zotn_o.ZOTNZOTN = ZOLLIVEAS_i.ZOLLTARIF;
             ZOTN_o.ZOTNABEZ = %subst(ZOLLIVEAS_i.ZOLLBEZ:1:30);
             ZOTN_o.ZOTNuser = §§§usr;
             ZOTN_o.ZOTNPROG = §§§pgm;
             ZOTN_o.ZOTNJNAM = §§§job;
             ZOTN_o.ZOTNbibl = §§§LIB;
             ZOTN_o.ZOTNJDAT = %dec(%char(%date():*iso0):8:0);
             ZOTN_o.ZOTNJZEI = %dec(%char(%time():*iso0):6:0);
             *in80 = '0';
             if *in80='1';
                write  zotn1     zotn_o;
             endif;
             zotn_INB_ = 'WRITE ';
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_kazk  inaktiv halten
       //KAZKFIRM           kazk01             Firma.........:
       //KAZKKASL           kazk01             Zolltarif-Nr..:
       //KAZKGADA           kazk01             ab Datum .....:
       //
       //SELECT * FROM kazk01 WHERE KAZKKASL ='27101943900' and KAZKZARTL
       //='ZKO' and KAZKBEGR ='BG2' and KAZKKASL ='001'
       //-----------------------------------------------------------------------

       begsr sr_kazk;

          KAZKBAWT_N = 0;

       //lesen der alten Zolltarifnummer
          kazk_k.KAZKFIRM = '01';
          kazk_k.KAZKZART = 'ZKO';
          kazk_k.KAZKBERE = '001';
          kazk_k.KAZKBEGR = 'BG2';
          kazk_k.KAZKKASL = ZOLLIVEAS_i.ZOLLTARIF;
          kazk_k.KAZKTENR = *blank;
          kazk_k.KAZKGADA = %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0);
          chain %kds(kazk_k:7) kazk01  kazk_I;
          if %found(kazk01);
             if KAZK_i.KAZKBAWT <> KAZKBAWT_N
             or KAZK_i.KAZKWTFL <> 'J';
                KAZK_o = KAZK_i;
                KAZK_o.KAZKBAWT =  KAZKBAWT_N;
                KAZK_o.KAZKWTFL =  'J';
                KAZK_o.KAZKSART =  '1';
                KAZK_o.KAZKuser = §§§usr;
                KAZK_o.KAZKPROG = §§§pgm;
                KAZK_o.KAZKJNAM = §§§job;
                KAZK_o.KAZKbibl = §§§LIB;
                KAZK_o.KAZKJDAT = %dec(%char(%date():*iso0):8:0);
                KAZK_o.KAZKJZEI = %dec(%char(%time():*iso0):6:0);
                update KAZK1     KAZK_o;
                kazk_INB_ = 'UPDATE';
             endif;
          else;
             if %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0) <> 0;
                clear               kazk_I;
                clear               kazk_o;
                kazk_o.KAZKFIRM = '01';
                kazk_o.KAZKZART = 'ZKO';
                kazk_o.KAZKBERE = '001';
                kazk_o.KAZKBEGR = 'BG2';
                kazk_o.KAZKKASL = ZOLLIVEAS_i.ZOLLTARIF;
                kazk_o.KAZKTENR = *blank;
                kazk_o.KAZKGADA = %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0);
                KAZK_o.KAZKBAWT = KAZKBAWT_N;
                KAZK_o.KAZKWTFL = 'J';
                KAZK_o.KAZKSART = '1';
                KAZK_o.KAZKuser = §§§usr;
                KAZK_o.KAZKPROG = §§§pgm;
                KAZK_o.KAZKJNAM = §§§job;
                KAZK_o.KAZKbibl = §§§LIB;
                KAZK_o.KAZKJDAT = %dec(%char(%date():*iso0):8:0);
                KAZK_o.KAZKJZEI = %dec(%char(%time():*iso0):6:0);
                write  KAZK1     KAZK_o;
                kazk_INB_ = 'WRITE ';
       //      read prior start
                   kazk_k.KAZKFIRM = '01';
                   kazk_k.KAZKZART = 'ZKO';
                   kazk_k.KAZKBERE = '001';
                   kazk_k.KAZKBEGR = 'BG2';
                   kazk_k.KAZKKASL = ZOLLIVEAS_i.ZOLLTARIF;
                   kazk_k.KAZKTENR = *blank;
                   kazk_k.KAZKGADA =
                   %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0);
                   setgt %kds(kazk_k:7) kazk01;
                   readp Kazk01 kazk_i;
                   if %found(kazk01);
       //            wenn BisDatum = 0 dann Datum eintragen
                      if KAZK_i.KAZKGBDA = 0 ;
                         KAZK_o = KAZK_i;
                         kazk_o.KAZKGBDA = #yesterday;
                         KAZK_o.KAZKuser = §§§usr;
                         KAZK_o.KAZKPROG = §§§pgm;
                         KAZK_o.KAZKJNAM = §§§job;
                         KAZK_o.KAZKbibl = §§§LIB;
                         KAZK_o.KAZKJDAT = %dec(%char(%date():*iso0):8:0);
                         KAZK_o.KAZKJZEI = %dec(%char(%time():*iso0):6:0);
                         update KAZK1     KAZK_o;
                         kazk_INB_ = 'WRITE + ';
                      else;
                         kazk_INB_ = 'WRITE - ';
                      endif;
                   else;
                      kazk_INB_ = 'WRITE 0';
                   endif;
       //      read prior ende
             else;
                kazk_INB_ = 'error dataimport';
             endif;
          endif;
       endsr;


       //-----------------------------------------------------------------------
       //lesen sr_prei aktuell inaktiv
       //-----------------------------------------------------------------------

       begsr sr_prei;

       //#preil5 lesen
          prei_k.PRFIRM = teil_i.TEFIRM;
          prei_k.PRBEGR = 'LP1';
          prei_k.PRKDLI = teil_i.TESTLF;
          prei_k.PRTENR = teil_i.TETENR;
          prei_k.PRWACD = 'EUR';
          prei_k.PRGADA = %dec(%char(%date():*iso0):8:0);

       //          chain %kds(Lpif_k:3) Lpif01    Lpif_I;
       //          setll %kds(Lpif_k:3) Lpif01    ;
          setgt %kds(prei_k:3) #preil5  ;
       // dow not %eof(#preil5);           für schleife
             readp #preil5 prei_i;
             if %found(#preil5);
             else;
                clear               prei_i;
             endif;
       // enddo;                            für Schleife
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_IVSC
       //-----------------------------------------------------------------------

       begsr sr_IVSC;

       //lpif01 lesen      ZOLLIVEAS_i.CODIERUNG;
          IVSC_k.IVSCFIRM = teil_i.TEFIRM;
          IVSC_k.IVSCCODE = ZOLLIVEAS_i.CODIERUNG;
          IVSC_k.IVSCIMEX = 'I';
          IVSC_k.IVSCGADA = %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0);
       // IVSC_k.IVSCGADA = %dec(%char(%date():*iso0):8:0);
          chain %kds(IVSC_k:4) IVSC01    IVSC_I;
       //          setll %kds(Lpif_k:3) Lpif01    ;
       // setgt %kds(IVSC_k:4) IVSC01    ;
       // readp IVSC01 IVSC_i;
          if %found(IVSC01);
             if IVSC_i.IVSCCBZ1 <> ZOLLIVEAS_i.ZOLLBEZ;
                IVSC_o  =        IVSC_i;
                IVSC_o.IVSCJDAT = %dec(%char(%date():*iso0):8:0);
                IVSC_o.IVSCJZEI = %dec(%char(%time():*iso0):6:0);
                IVSC_o.IVSCCBZ1 = ZOLLIVEAS_i.ZOLLBEZ;
                if  %subst(ZOLLIVEAS_i.USRADD: 1: 4) = 'Herr' or
                    %subst(ZOLLIVEAS_i.USRADD: 1: 4) = 'Frau';
                    %subst(ZOLLIVEAS_i.USRADD: 1: 10) =
                    %subst(ZOLLIVEAS_i.USRADD: 6: 10);
                endif;
                IVSC_o.IVSCERUS = ZOLLIVEAS_i.USRADD;
                if %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4)  <> 'NULL';
                   if  %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4) = 'Herr' or
                       %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4) = 'Frau';
                       %subst(ZOLLIVEAS_i.USRCHANGE: 1: 10) =
                       %subst(ZOLLIVEAS_i.USRCHANGE: 6: 10);
                   endif;
                IVSC_o.IVSCERUS = ZOLLIVEAS_i.USRCHANGE;
                endif;
                update IVSC1      IVSC_o;
             else;
             endif;
          else;
             clear             IVSC_o;
             IVSC_o.IVSCuser = §§§usr;
             IVSC_o.IVSCPROG = §§§pgm;
             IVSC_o.IVSCJNAM = §§§job;
             IVSC_o.IVSCbibl = §§§LIB;
             IVSC_o.IVSCJDAT = %dec(%char(%date():*iso0):8:0);
             IVSC_o.IVSCJZEI = %dec(%char(%time():*iso0):6:0);
             IVSC_o.IVSCFIRM = teil_i.TEFIRM;
             IVSC_o.IVSCZOTN = ZOLLIVEAS_i.ZOLLTARIF;
             IVSC_o.IVSCIMEX = 'I';
             IVSC_o.IVSCCODE = ZOLLIVEAS_i.CODIERUNG;
             IVSC_o.IVSCCBZ1 = ZOLLIVEAS_i.ZOLLBEZ;
             IVSC_o.IVSCGADA = %dec(%subst(ZOLLIVEAS_i.DATEADD:1:8)  :8 :0);
             IVSC_o.IVSCGBDA = IVSC_o.IVSCGBDA;
             if  %subst(ZOLLIVEAS_i.USRADD: 1: 4) = 'Herr' or
                 %subst(ZOLLIVEAS_i.USRADD: 1: 4) = 'Frau';
                 %subst(ZOLLIVEAS_i.USRADD: 1: 10) =
                 %subst(ZOLLIVEAS_i.USRADD: 6: 10);
             endif;
             IVSC_o.IVSCERUS = ZOLLIVEAS_i.USRADD;
             if %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4)  <> 'NULL';
                if  %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4) = 'Herr' or
                    %subst(ZOLLIVEAS_i.USRCHANGE: 1: 4) = 'Frau';
                    %subst(ZOLLIVEAS_i.USRCHANGE: 1: 10) =
                    %subst(ZOLLIVEAS_i.USRCHANGE: 6: 10);
                endif;
                IVSC_o.IVSCERUS = ZOLLIVEAS_i.USRCHANGE;
             endif;
             write  IVSC1     IVSC_o;
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'RPMSALESM ';
       //  %Subarr(p_md:11:10)  = §§§JOB;
       //  %Subarr(p_md:22:10)  = §§§USR;
       //  %Subarr(p_md:33:132) = status;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       endsr;


