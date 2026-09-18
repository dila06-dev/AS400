
      //************************************************************************
      //
      //      Programmname       SANKTION2R
      //      Erstellt  am       20.03.2025
      //      Erstellt von       M.Gang
      //
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      // Restartmöglichkeiten:
      // _____________________
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      //
      // call trtrtpst  mit Parameter TPTART ='LANDNEGATI'
      // Tabellenwertt  muß auf  stehen       1,00000
      //
      // select                   * from  TVPF/BOYH
      // where substr(BOYHLDNR, 1, 3) in
      // (select substr(TPTCDE, 1, 3) from tamf/trtp01 WHERE TPFIRM ='01'
      //  and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
      // BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
      // BOYHTSTP > current timestamp -99999 minutes) and
      // (BOYHSTAT='20')
      //
      // select                   * from  TVPFtest/BOYH
      // where substr(BOYHLDNR, 1, 3) in
      // (select substr(TPTCDE, 1, 3) from tamftest/trtp01 WHERE TPFIRM ='01'
      //  and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
      // BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
      // BOYHTSTP > current timestamp -99999 minutes) and
      // (BOYHSTAT='20' or BOYHSTAT='00')
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
     D p_inFIL         s             44a   inz


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
     d NumSysTime      s              6s 0
     d myDate          s               d

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
     D §DELIVER_N      s             17a   inz
     D key1            s             10a   inz
     D key2            s             50a   inz
     D key3            s             50a   inz
     D WKLIBL          s             10A
     D WKFIRM          s              2A
     D WKENVI          s             10A
     D fkt             s             10A
     D §curlib         s             10A
     D §usrlib         s           2750A


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start: create SANKTION2R                           ';
       exsr      SR_log;

         NumSysTime = %Dec(%Time(): *ISO);
         dow  NumSysTime < 234500;
            exsr  srinit;
            NumSysTime = %Dec(%Time(): *ISO);
            MONITOR;
               Wrk.var1 =
                   'DLYJOB DLY(0100)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status = 'error DLYJOB                                    ';
                  exsr      SR_log;
            endmon;
         enddo;

       eval status ='Ende create SANKTION2R                            ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //-----------------------------------------------------------------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       //update boyh über Zeitparameter und tvpf LANDNEGATI key
       //Auftrag läuft rein '00'
       //Sanktionsmonitor   '90' +
       //Sanktionsmonitor   '20' - ok keine Saktion
       //Sanktionsmonitor   '95' Trend sperrt !!!!
       //==> Produktion     BOYHPROG
         exec sql
            update tvpf/boyh01 set BOYHPROG='SANKTION2R'
            where substr(BOYHLDNR, 1, 3) in
            ( select substr(TPTCDE, 1, 3) from tamf/trtp01 WHERE TPFIRM ='01'
            and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
            BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
            BOYHTSTP > current timestamp -030   minutes) and
            (BOYHSTAT='20');
       //BOYHSTAT='20' = geprüft ohne Auffälligkeit
         exec sql
            update tvpf/boyh01 set BOYHSTAT='90',
            BOYHPRDA = zoned(('20') concat
            substr(char(current date +0 day), 7, 2)  concat
            substr(char(current date +0 day), 4, 2)  concat
            substr(char(current date +0 day), 1, 2), 8, 0)
            where substr(BOYHLDNR, 1, 3) in
            ( select substr(TPTCDE, 1, 3) from tamf/trtp01 WHERE TPFIRM ='01'
            and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
            BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
            BOYHTSTP > current timestamp -030   minutes) and
            (BOYHSTAT='20');
       //BOYHSTAT='20' = geprüft ohne Auffälligkeit


       //==> Test  Abweichung im Test auch BOYHSTAT Status ='00'
         exec sql
            update tvpftest/boyh01 set BOYHPROG='SANKTION2R'
            where substr(BOYHLDNR, 1, 3) in
            ( select substr(TPTCDE, 1, 3) from tamftest/trtp01 WHERE TPFIRM
            = '01' and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
            BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
            BOYHTSTP > current timestamp -030   minutes) and
            (BOYHSTAT='20' or BOYHSTAT='00');
       //BOYHSTAT='20' = geprüft ohne Auffälligkeit

       //==> Test  Abweichung im Test auch BOYHSTAT Status ='00'
         exec sql
            update tvpftest/boyh01 set BOYHSTAT='90',
            BOYHPRDA = zoned(('20') concat
            substr(char(current date +0 day), 7, 2)  concat
            substr(char(current date +0 day), 4, 2)  concat
            substr(char(current date +0 day), 1, 2), 8, 0)
            where substr(BOYHLDNR, 1, 3) in
            ( select substr(TPTCDE, 1, 3) from tamftest/trtp01 WHERE TPFIRM
            = '01' and TPTART ='LANDNEGATI' and TPSPCD ='D' and TPTNUM =1 and
            BOYHTSTP > timestamp(TPJDAT concat TPJZEI) and
            BOYHTSTP > current timestamp -030   minutes) and
            (BOYHSTAT='20' or BOYHSTAT='00');
       //BOYHSTAT='20' = geprüft ohne Auffälligkeit

       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'SCHLANSER ';
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


