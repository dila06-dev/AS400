
      //************************************************************************
      //
      //      Programmname       ORDERFTEST
      //      Erstellt  am       25.02.2022
      //      Erstellt von       M.Gang
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
      // sonstiges check
      // ===============
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

       // ______________________________________________________________________

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
       eval status ='Start: ORDERFTEST                                  ';
       exsr      SR_log;

          NumSysTime = %Dec(%Time(): *ISO);

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          exsr  srinit;

       eval status ='Ende ORDERFTEST                                   ';

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

       //ifak  99
         exec sql
         insert into TVPFtest/ifak01
         SELECT * FROM TVPF/ifak01 a
         WHERE a.IFAKIFFI ='00099' and a.IFAKIFNR not in
         (select b.IFAKIFNR from TVPFtest/ifak01 b
          where b.IFAKIFFI ='00099');

       //ifap
         exec sql
         insert into TVPFtest/ifap01
         SELECT * FROM TVPF/ifap01 a
         WHERE a.IFApIFFI ='00099' and a.IFApIFNR not in
         (select b.IFApIFNR from TVPFtest/ifap01 b
          where b.IFApIFFI ='00099');

       //ifad
         exec sql
         insert into TVPFtest/ifad01
         SELECT * FROM TVPF/ifad01 a
         WHERE a.IFAdIFFI ='00099' and a.IFAdIFNR not in
         (select b.IFAdIFNR from TVPFtest/ifad01 b
          where b.IFAdIFFI ='00099');

       //ifat
         exec sql
         insert into TVPFtest/ifat01
         SELECT * FROM TVPF/ifat01 a
         WHERE a.IFAtIFFI ='00099' and a.IFAtIFNR not in
         (select b.IFAtIFNR from TVPFtest/ifat01 b
          where b.IFAtIFFI ='00099');

       //ifan
         exec sql
         insert into TVPFtest/ifan01
         SELECT * FROM TVPF/ifan01 a
         WHERE a.IFAnIFFI ='00099' and a.IFAnIFNR not in
         (select b.IFAnIFNR from TVPFtest/ifan01 b
          where b.IFAnIFFI ='00099');

       //ifed
         exec sql
         insert into TVPFtest/ifed01
         SELECT * FROM TVPF/ifed01 a
         WHERE a.IFedIFFI ='00099' and a.IFedIFNR not in
         (select b.IFedIFNR from TVPFtest/ifed01 b
          where b.IFedIFFI ='00099');

       //ifep
         exec sql
         insert into TVPFtest/ifep01
         SELECT * FROM TVPF/ifep01 a
         WHERE a.IFepIFFI ='00099' and a.IFepIFNR not in
         (select b.IFepIFNR from TVPFtest/ifep01 b
          where b.IFepIFFI ='00099');

       //modwao
         exec sql
         insert into modwaotest/wao8
         SELECT * FROM modwao/wao8 a
         WHERE a.wao8IFFI ='00099' and a.wao8IFNR not in
         (select b.wao8IFNR from modwaotest/wao8 b
          where b.wao8IFFI ='00099');


       //ifak  00009
         exec sql
         insert into TVPFtest/ifak01
         SELECT * FROM TVPF/ifak01 a
         WHERE a.IFAKIFFI ='00009' and a.IFAKIFNR not in
         (select b.IFAKIFNR from TVPFtest/ifak01 b
          where b.IFAKIFFI ='00009');

       //ifap
         exec sql
         insert into TVPFtest/ifap01
         SELECT * FROM TVPF/ifap01 a
         WHERE a.IFApIFFI ='00009' and a.IFApIFNR not in
         (select b.IFApIFNR from TVPFtest/ifap01 b
          where b.IFApIFFI ='00009');

       //ifad
         exec sql
         insert into TVPFtest/ifad01
         SELECT * FROM TVPF/ifad01 a
         WHERE a.IFAdIFFI ='00009' and a.IFAdIFNR not in
         (select b.IFAdIFNR from TVPFtest/ifad01 b
          where b.IFAdIFFI ='00009');

       //ifat
         exec sql
         insert into TVPFtest/ifat01
         SELECT * FROM TVPF/ifat01 a
         WHERE a.IFAtIFFI ='00009' and a.IFAtIFNR not in
         (select b.IFAtIFNR from TVPFtest/ifat01 b
          where b.IFAtIFFI ='00009');

       //ifan
         exec sql
         insert into TVPFtest/ifan01
         SELECT * FROM TVPF/ifan01 a
         WHERE a.IFAnIFFI ='00009' and a.IFAnIFNR not in
         (select b.IFAnIFNR from TVPFtest/ifan01 b
          where b.IFAnIFFI ='00009');

       //ifed
         exec sql
         insert into TVPFtest/ifed01
         SELECT * FROM TVPF/ifed01 a
         WHERE a.IFedIFFI ='00009' and a.IFedIFNR not in
         (select b.IFedIFNR from TVPFtest/ifed01 b
          where b.IFedIFFI ='00009');

       //ifep
         exec sql
         insert into TVPFtest/ifep01
         SELECT * FROM TVPF/ifep01 a
         WHERE a.IFepIFFI ='00009' and a.IFepIFNR not in
         (select b.IFepIFNR from TVPFtest/ifep01 b
          where b.IFepIFFI ='00009');

       //modwao
         exec sql
         insert into modwaotest/wao8
         SELECT * FROM modwao/wao8 a
         WHERE a.wao8IFFI ='00009' and a.wao8IFNR not in
         (select b.wao8IFNR from modwaotest/wao8 b
          where b.wao8IFFI ='00009');

       //ifak  'ORDERFTEST' in ref2
         exec sql
         insert into TVPFtest/ifak01
         SELECT * FROM TVPF/ifak01 a
         where substr(a.ifakref2, 1, 10) = 'ORDERFTEST' and
         a.IFAKIFNR not in (select b.IFAKIFNR from
         TVPFtest/ifak01 b where b.IFAKIFFI in
         ('40631', '88505','78678','40670') );

       //ifap
         exec sql
         insert into TVPFtest/ifap01
         SELECT * FROM TVPF/ifap01 a
         where a.IFApIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifapiffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFApIFNR not in
             (select c.IFApIFNR from TVPFtest/ifap01 c
              where c.IFApIFFI = a.IFApIFFI);

       //ifad
         exec sql
         insert into TVPFtest/ifad01
         SELECT * FROM TVPF/ifad01 a
         where a.IFAdIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifadiffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFAdIFNR not in
             (select c.IFAdIFNR from TVPFtest/ifad01 c
              where c.IFAdIFFI = a.IfAdIFFI);

       //ifat
         exec sql
         insert into TVPFtest/ifat01
         SELECT * FROM TVPF/ifat01 a
         where a.IFAtIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifatiffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFAtIFNR not in
             (select c.IFAtIFNR from TVPFtest/ifat01 c
              where c.IFAtIFFI = a.IfAtIFFI);

       //ifan
         exec sql
         insert into TVPFtest/ifan01
         SELECT * FROM TVPF/ifan01 a
         where a.IFAnIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifaniffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFAnIFNR not in
             (select c.IFAnIFNR from TVPFtest/ifan01 c
              where c.IFAnIFFI = a.IfAnIFFI);

       //ifed
         exec sql
         insert into TVPFtest/ifed01
         SELECT * FROM TVPF/ifed01 a
         where a.IFedIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifediffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFedIFNR not in
             (select c.IFedIFNR from TVPFtest/ifed01 c
              where c.IFedIFFI = a.IfedIFFI);

       //ifep
         exec sql
         insert into TVPFtest/ifep01
         SELECT * FROM TVPF/ifep01 a
         where a.IFepIFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.ifepiffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.IFepIFNR not in
             (select c.IFepIFNR from TVPFtest/ifep01 c
              where c.IFepIFFI = a.IfepIFFI);

       //modwao
         exec sql
         insert into modwaotest/wao8
         SELECT * FROM modwao/wao8 a
         where a.wao8IFNR in (select b.ifakifnr from
         TVPFtest/ifak01 b where b.IFAKIFFI = a.wao8iffi
         and substr(b.ifakref2, 1, 10) = 'ORDERFTEST')
         and a.wao8IFNR not in
             (select c.wao8IFNR from modwaotest/wao8 c
              where c.wao8IFFI = a.wao8IFFI);


       //sql handling
            exec sql
                     whenever not found CONTINUE;
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


