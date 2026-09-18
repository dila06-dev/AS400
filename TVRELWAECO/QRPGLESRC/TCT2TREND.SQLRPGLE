
      //************************************************************************
      //
      //      Programmname: TCT2TREND
      //      Erstellt  am: 29.04.2025
      //      Erstellt von  M.Gang
      //
      //      Beschreibung: TCT2TREND  interface
      //                    Übernahme Kalkulationen ==> kazk auf KAZKBEGR = 'BG2'
      //                    Übernahme Codenummern (alt: Zolltarifnummer)
      //                    in ZOTN und Artikeldatei
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
      // SELECT * FROM kazk01 WHERE KAZKKASL ='27101943900' and KAZKZART
      // ='ZKO' and KAZKBEGR ='BG2'
      //
      // call trzotnst
      // prototyp
      // SELECT * FROM kazk01 WHERE KAZKKASL ='84185090100'
      //
      // CPYFRMSTMF FROMSTMF('/IVEAS/TCT/TCT2Trend/Zolltarifnummer.csv')
      //     TOMBR('/QSYS.LIB/TVRELWAECO.LIB/ZOLLTin.FILE/ZOLLTin.MBR')
      //            MBROPT(*REPLACE)
      // Datenstromdatei in Objekt kopiert.
      // CPYFRMIMPF FROMFILE(TVRELWAECO/ZolltIN)
      //        TOFILE(TVRELWAECO/ZolltIMP) MBROPT(*REPLACE)
      //               FLDDLM(';') DECPNT(*COMMA)
      //                    FROMRCD(1) RPLNULLVAL(*FLDDFT)
      //
      // Prozess: Status 90 bei Artikel kein update
      //          KAZKGADA muß gesetzt sein und keine Prüfung
      //          durch Programm
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

     fzolltimp  uf   e             DISK    RENAME(zolltimp :PHY01R)
     f                                     usropn

     fzolltimpp uf a e             disk    RENAME(zolltimpp:PHY02R)
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
     D tct2trend       s             10p 0 dtaara


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d zolltimp_i    E DS                  ExtName(zolltimp :*input)
     d                                     Qualified

     d zolltimp_o    E DS                  ExtName(zolltimp:*output)
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


     d zolltimppo    E DS                  ExtName(zolltimpp:*output)
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

      // Überschreibungen
      //************************************************************************
     IPHY01R
     I              ZOTNABEZ                    #ZOTNABEZ
     IPHY02R
     I              ZOTNABEZ                    #ZOTNABEZ
      //************************************************************************
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for tct2trend    ';
       exsr      SR_log;

       exsr  srinit;

       //tvrelwaeco/ZOLLTin
       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/ZOLLTin)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/ZOLLTin)  ';
             exsr      SR_log;
       endmon;

       //CRTSRCPF FILE(TVRELWAECO/ZOLLTin) RCDLEN(240)
       //TEXT('importing Zolltarifnummern')

       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/IVEAS/TCT/TCT2Trend/' +
           'Zolltarifnummer.csv'') ' +
           'TOMBR(''/QSYS.LIB/TVRELWAECO.LIB/ZOLLTin.FILE/ZOLLTin.MBR'') ' +
           ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
          exsr      SR_log;
       endmon;

       //tvrelwaeco/ZolltIMP
       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/ZolltIMP)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/ZolltIMP)  ';
             exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/ZolltIN) ' +
           'TOFILE(TVRELWAECO/ZolltIMP) MBROPT(*REPLACE) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          if week > 0;
             in  *lock *dtaara;
             tct2trend  = tct2trend   + 1;
             out *dtaara;
             open ZolltIMP;
             open ZolltIMPP;

             read zolltimp  zolltimp_i;
                dow not %eof(zolltimp) or  week = 0;
                TEIL_INB_ = *blank;
                zotn_INB_ = *blank;
                kazk_INB_ = *blank;
       //      für upload    20230501
                   if zolltimp_i.STATUS_I = '  ';
                      *in20 = '0';
                      zolltimp_o  = zolltimp_i;
       // *eur yyyy-mm-dd
       // *iso dd.mm.yyyy
       // Test(DE) *eur zollTIMP_i.KAZKGADA;
       // If %Error;
       //    *in20 = '1';
       // Endif;
                      Test(DE) *iso zollTIMP_i.KAZKGADA;
                      If %Error;
                         *in20 = '1';
                      Endif;
       //      Fehler vorab erkennen
                      if zollTIMP_i.KAZKGADA <> 0 and
                      *in20 = '0';
       //n20              eval      #h060  = %char (%date (#h060:*eur) :*eur)
       //n20              eval      #h060  = %char (%date (#h060:*eur) :*iso)
                         exsr  sr_1000;
                      else;
                         TEIL_INB_ = '     ';
                         zotn_INB_ = '     ';
                         kazk_INB_ = 'error dataimport';
                      endif;
       //      für message an IVEAS
                      zolltimp_o.STATUS_I  = '10';
                      zolltimp_o.TSTAMP_I  = %timestamp();

       //      update
                      update PHY01R    zolltimp_o;
       //      Protokolldatei Zolltimppo
                      zolltimppo  = zolltimp_o;
                      zolltimppo.TEIL_INB = TEIL_INB_;
                      zolltimppo.zotn_INB = zotn_INB_;
                      zolltimppo.kazk_INB = kazk_INB_;
                      clear            zolltimp_o;
                      zolltimppo.DATE_INB   = %date();
                      zolltimppo.TSTAMP_INB = %timestamp();
                      write  PHY02R    zolltimppo;
                      clear            zolltimppo;
                   endif;
                   read zolltimp  zolltimp_i;
             enddo;
             close ZolltIMP;
             close ZolltIMPP;
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

         eval p_savef   =  'Zolltarifnummer'   +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0)) +
                        '.csv';

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       MONITOR;
       Wrk.var1 =
           'RNM OBJ(''Zolltarifnummer.csv'') '+
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

       eval status ='Ende  FTP Transfer for tct2trend    ';
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
          teil_k.tefirm    = zolltimp_i.TEFIRM;
          teil_k.tetenr    = zolltimp_i.TETENR;
          chain %kds(teil_k:2) teil01 teil_I;
          if %found(teil01);
             exsr sr_zotn;
             exsr sr_kazk;
             if teil_i.TEZOTN         =  ZOLLTIMP_i.ZOTNZOTN_n  or
                ZOLLTIMP_i.ZOTNZOTN_n =  *BLANK                 or
                teil_i.TETEST         =  '90';
                   TEIL_INB_ = 'ERROR ';
                if teil_i.TETEST =  '90';
                   TEIL_INB_ = 'ERROR Staus 90';
                else;
                endif;
             else;
                teil_o = teil_i;
                teil_o.TEZOTN = ZOLLTIMP_i.ZOTNZOTN_n;
                teil_o.teuser = §§§usr;
                teil_o.tePROG = §§§pgm;
                teil_o.teJNAM = §§§job;
                teil_o.tebibl = §§§LIB;
                teil_o.teJDAT = %dec(%char(%date():*iso0):8:0);
                teil_o.teJZEI = %dec(%char(%time():*iso0):6:0);
                update teil1     teil_o;
                TEIL_INB_ = 'UPDATE';
             endif;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_lief
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
       //lesen sr_lpif
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

       //alte TarifNummer lesen aktuell keine Aktion
          zotn_k.ZOTNZOTN = ZOLLTIMP_i.ZOTNZOTN_A;
          chain %kds(ZOTN_k:1) ZOTN01  ZOTN_I;
          if %found(ZOTN01);
          else;
             clear               ZOTN_I;
          endif;

       //neue TarifNummer lesen aktuell
          zotn_k.ZOTNZOTN = ZOLLTIMP_i.ZOTNZOTN_n;
          chain %kds(ZOTN_k:1) ZOTN01  ZOTN_I;
          if %found(ZOTN01);
             if ZOTN_i.ZOTNABEZ <> %subst(#ZOTNABEZ:1:30);
                ZOTN_o = ZOTN_i;
                ZOTN_o.ZOTNABEZ = %subst(#ZOTNABEZ:1:30);
                ZOTN_o.ZOTNuser = §§§usr;
                ZOTN_o.ZOTNPROG = §§§pgm;
                ZOTN_o.ZOTNJNAM = §§§job;
                ZOTN_o.ZOTNbibl = §§§LIB;
                ZOTN_o.ZOTNJDAT = %dec(%char(%date():*iso0):8:0);
                ZOTN_o.ZOTNJZEI = %dec(%char(%time():*iso0):6:0);
                update zotn1     zotn_o;
                zotn_INB_ = 'UPDATE';
             else;
             endif;
          else;
             clear               ZOTN_o;
             zotn_o.ZOTNZOTN = ZOLLTIMP_i.ZOTNZOTN_n;
             ZOTN_o.ZOTNABEZ = %subst(#ZOTNABEZ:1:30);
             ZOTN_o.ZOTNuser = §§§usr;
             ZOTN_o.ZOTNPROG = §§§pgm;
             ZOTN_o.ZOTNJNAM = §§§job;
             ZOTN_o.ZOTNbibl = §§§LIB;
             ZOTN_o.ZOTNJDAT = %dec(%char(%date():*iso0):8:0);
             ZOTN_o.ZOTNJZEI = %dec(%char(%time():*iso0):6:0);
             write  zotn1     zotn_o;
             zotn_INB_ = 'WRITE ';
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_kazk
       //KAZKFIRM           kazk01             Firma.........:
       //KAZKKASL           kazk01             Zolltarif-Nr..:
       //KAZKGADA           kazk01             ab Datum .....:
       //
       //SELECT * FROM kazk01 WHERE KAZKKASL ='27101943900' and KAZKZARTL
       //='ZKO' and KAZKBEGR ='BG2' and KAZKKASL ='001'
       //-----------------------------------------------------------------------

       begsr sr_kazk;

       //lesen der alten Zolltarifnummer
          kazk_k.KAZKFIRM = zolltimp_i.TEFIRM;
          kazk_k.KAZKZART = 'ZKO';
          kazk_k.KAZKBERE = '001';
          kazk_k.KAZKBEGR = 'BG2';
          kazk_k.KAZKKASL = ZOLLTIMP_i.ZOTNZOTN_N;
          kazk_k.KAZKTENR = *blank;
          kazk_k.KAZKGADA = ZOLLTIMP_i.KAZKGADA;
          chain %kds(kazk_k:7) kazk01  kazk_I;
          if %found(kazk01);
             if KAZK_i.KAZKBAWT <> ZOLLTIMP_i.KAZKBAWT_N
             or KAZK_i.KAZKWTFL <> 'J';
                KAZK_o = KAZK_i;
                KAZK_o.KAZKBAWT =  ZOLLTIMP_i.KAZKBAWT_N;
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
             if ZOLLTIMP_i.KAZKGADA <> 0;
                clear               kazk_I;
                clear               kazk_o;
                kazk_o.KAZKFIRM = zolltimp_i.TEFIRM;
                kazk_o.KAZKZART = 'ZKO';
                kazk_o.KAZKBERE = '001';
                kazk_o.KAZKBEGR = 'BG2';
                kazk_o.KAZKKASL = ZOLLTIMP_i.ZOTNZOTN_N;
                kazk_o.KAZKTENR = *blank;
                kazk_o.KAZKGADA = ZOLLTIMP_i.KAZKGADA;
                KAZK_o.KAZKBAWT = ZOLLTIMP_i.KAZKBAWT_N;
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
                   kazk_k.KAZKFIRM = zolltimp_i.TEFIRM;
                   kazk_k.KAZKZART = 'ZKO';
                   kazk_k.KAZKBERE = '001';
                   kazk_k.KAZKBEGR = 'BG2';
                   kazk_k.KAZKKASL = ZOLLTIMP_i.ZOTNZOTN_N;
                   kazk_k.KAZKTENR = *blank;
                   kazk_k.KAZKGADA = ZOLLTIMP_i.KAZKGADA;
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
       //lesen sr_prei
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


