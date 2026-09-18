
      //************************************************************************
      //
      //      Programmname       LFS_SEGM
      //      Erstellt  am       13.10.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung
      //    
      //    
      //    
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
      //
      // wenn Sätzte fehlen oft dann:
      //
      // Referenzsatz
      //
      //
      // (
      //
      //
      //
      //
      //************************************************************************

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
       //           ... Grunddaten

      //------------------------------------------------------------------------
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

     D §records        s              9s 0 inz

      // qmhsndpm
      // ______________________________________________________________________
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D err_msg         s              1a   inz
     D #error          s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0
     d nowdate         s              8s 0
     DGoodDateV        S              1a
     DGoodDateB        S              1a
     D#ERRORS          s             60a
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     D p_inFIL         s             24a
     D §x              s              3s 0 inz
     D §item           s             28a   inz

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz

      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start WE_check                            ';
       exsr      SR_log;

       //innerhalb von lfs part one______
       exsr  srinit;
       //innerhalb von trend part second_
       exsr  srinit2;
       exsr  srinit3;



       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

       //if §records <> *zero;
          exsr      SR_report;
       //endif;

       endif;

       // ______________________________________________________________________

       eval status ='Ende  LFS_SEGM                          ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei KPIF
       //-----------------------------------------------------------------------

       begsr srinit;

       err_msg   = '1';

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_check) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_Check)             ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_check_1)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_check_1)           ';
             exsr      SR_log;
       endmon;


       //1) Hauptdatei WE's  SSDTDI, SSTIDI  first write
       //                      ____,   ____  first write
       exec sql
        insert into tvrelwaeco/we_check
        SELECT SSKONZ, SSFIRM, SSSST, SSLFDN, SSIDEN, SSBST1, SSBSTP,
        SSLIEF, SSWENR, SSWEPO, SSLSNR, SSLSNP, SSBSTM , SSQKZ, SSQSTA,
        SSQCHR, SSDTEE, SSDTZU, SSLM, SSBART, SSDTBU, SSTIBU, SSDTDI,
        SSTIDI, SSDTDU, SSTIDU ,
        SSDTDI, SSTIDI, char(' ', 1) status,
        zoned(0, 8, 0) TPDTPP, zoned(0, 6, 0) TPTIPP,
        zoned(0, 8, 0) TPDTEE, zoned(0, 8, 0) TPDTZU,
        zoned(0, 8, 0) tpdte, zoned(0, 8, 0) tptie,
        zoned(0, 8, 0) TPDTDI, zoned(0, 12, 0) TPTIDI,
        zoned(0, 8, 0) workdays,
        current timestamp tstamp FROM
        domdatv7/PBESTSS WHERE SSSST =110 or SSSST =115 or SSSST =220;


       //_offene WE's ermittel aus domdatv7/PBESTTP aus Transportaufträgen_
       exec sql
        update tvrelwaeco/we_check a set status = '1'
        where ssbst1 in (select tpbst1 from domdatv7/PBESTTP
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220')));

       //_TPDTPP___________________________________________________________
       exec sql
        update we_check a set a.TPDTPP =
        (select max(b.TPDTPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);

       //_TPTIPP___________________________________________________________
       exec sql
        update we_check a set a.TPTIPP =
        (select max(b.TPTIPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTEE___________________________________________________________
       exec sql
        update we_check a set a.TPDTEE =
        (select max(b.TPDTEE) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTEE) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTDI___________________________________________________________
       exec sql
        update we_check a set a.TPDTDI =
        (select max(b.TPDTDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPTIDI___________________________________________________________
       exec sql
        update we_check a set a.TPTIDI =
        (select max(b.TPTIDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //3.) integration  Lagerbewegungen__________________________________

       exec sql
        update we_check a set status = '2'
        where ssbst1 in (select bmbst1 from domdatv7/pbestlo
              where  SSBST1=bmBST1 and SSBSTP=bmBSTP and
                     SSWENR=bmwenr and sswepo=bmwepo and
                     SSKONZ=bmKONZ and SSFIRM=bmFIRM and status=' ');

       //__________Historie________________________________________________
       //__________________________________________________________________
       //offene WE's ermittel aus domdatv7/phisttp aus Transportaufträgen__
       exec sql
        update tvrelwaeco/we_check a set status = '3'
        where ssbst1 in (select tpbst1 from domdatv7/phisttp
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220')));

       //_TPDTPP___________________________________________________________
       exec sql
        update we_check a set a.TPDTPP =
        (select max(b.TPDTPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);

       //_TPTIPP___________________________________________________________
       exec sql
        update we_check a set a.TPTIPP =
        (select max(b.TPTIPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTEE___________________________________________________________
       exec sql
        update we_check a set a.TPDTEE =
        (select max(b.TPDTEE) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTEE) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_tpdte _________Prüffeld_nur in Historie__________________________
       exec sql
        update we_check a set a.tpdte  =
        (select max(b.tpdte)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.tpdte)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_tptie _________Prüffeld_nur in Historie__________________________
       exec sql
        update we_check a set a.tptie  =
        (select max(b.tptie)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.tptie)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTDI___________________________________________________________
       exec sql
        update we_check a set a.TPDTDI =
        (select max(b.TPDTDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPTIDI___________________________________________________________
       exec sql
        update we_check a set a.TPTIDI =
        (select max(b.TPTIDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST in ('110', '115', '220'))
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_Berechnung Zeit__________________________________________________
       exec sql
        update we_check set workdays =
        (days (date(substr(tpdte , 1, 4)
        concat '-' concat substr(tpdte , 5, 2) concat '-' concat
        substr(tpdte , 7, 2)))
        -
        (days( date(substr(SSDTDI, 1, 4) concat
        '-' concat substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7,
        2))))) WHERE TPDTE <> 0;

       //_Gruppierung______________________________________________________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT
        SSSST,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2)))
        inpd, workdays, status, decimal((count(*)), 5, 0) rate,
        decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
        decimal(0, 5, 0) freeday
        FROM we_check GROUP BY SSSST ,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))),
        workdays, status
        ORDER BY  SSSST ,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))),
        workdays, status;

       //_Gruppierung______________________________________________________
       exec sql
        update we_check_1 a set daytotal =
        (select count(*)      from tvrelwaeco/we_check b where
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))
        = inpd) and a.SSSST = b.SSSST)
        where exists
        (select count(*)      from tvrelwaeco/we_check b where
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))
        = inpd) and a.SSSST = b.SSSST);


       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder aus Trend Analyse 825 auf Lager 500 und 501
       //-----------------------------------------------------------------------

       begsr srinit2;

       err_msg   = '1';

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECKTR)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECKTR)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/we_check5) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/we_check5)             ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK5B)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK5B)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK5C)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK5C)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK5D)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK5D)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK5E)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK5e)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK5F)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK5f)           ';
             exsr      SR_log;
       endmon;


       //1) Grundfilter zeitliches Limit

       //_Filter___________________________________________________________
       //_alle Optionen wegen der Laufzeit zuordnen           ==>we_check5_
       exec sql
        insert into tvrelwaeco/we_check5
        SELECT * FROM datenkw/#lblb WHERE
        date(date (date(substr(#LBLBBDAT , 1, 4)
        concat '-' concat substr(#LBLBBDAT, 5, 2) concat '-' concat
        substr(#LBLBBDAT, 7, 2)))) > current date - 95 day;

       //_Filter_nur 500 und 510 für 1.Koordinate_nur WE's 825'er__________
/*     //* ...                                                                  */
       //_nur 825 auswählen mit Lager 500/510                 ==>we_check5b
       exec sql
        insert into tvrelwaeco/we_check5b
        SELECT * FROM we_check5
        WHERE #LBLBLSTC ='825' and #LBLBLANR in ('500', '510');

       //_Filter_nur 500 und 510 für 1.Koordinate__________________________
       exec sql
        insert into tvrelwaeco/we_check5c
        SELECT * from we_check5 a where a.#AEWENR  <> ' '  and
         a.#AEFIRM in  (select b.#AEFIRM from we_check5b b where
                        a.#AEBEJJ = b.#AEBEJJ and
                        a.#AEBENR = b.#AEBENR and
                        a.#AEBEPO = b.#AEBEPO and
                        a.#AELFNR = b.#AELFNR and
                        a.#AEWEJJ = b.#AEWEJJ and
                        a.#AEWENR = b.#AEWENR )
        order by #AEWEJJ,
                 #AEWENR;

       //_Koordinatensystem ableiten für 500 und 510 als Basisdatenbank____
       //_1. Ableitung bereits integriert
       exec sql
        insert into tvrelwaeco/WE_CHECKTR
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(min(#LBLBBDAT), 8, 0) #LBLBBDAT,
        #LBLBLANR ,#LBLBBWMG,
        ( date(substr(min(#LBLBBDAT), 1, 4) concat '-' concat
        substr(min(#LBLBBDAT), 5, 2) concat '-' concat
        substr(min(#LBLBBDAT), 7, 2))) LBLBBDAT,
        zoned(0, 8, 0) dat500510, dec(0,0, 14, 4)bwmg500510,
        current date date500510, decimal(0, 8, 0) WORKL1,
                                 decimal(0, 8, 0) WORKL11,
        zoned(0, 8, 0) dat100110, dec(0,0, 14, 4)bwmg100110,
        current date date100110, decimal(0, 8, 0) WORKL2,
        zoned(0, 8, 0) dat001, dec(0,0, 14, 4)bwmg001,
        current date date001,  decimal(0, 8, 0) WORKL3,
        zoned(0, 8, 0) lfterm,current date datelfterm,decimal(0, 8, 0) WORKL4,
        zoned(0, 8, 0) beterm,current date datebeterm,decimal(0, 8, 0) WORKL5,
        zoned(0, 8, 0) vsterm,current date datevsterm,decimal(0, 8, 0) WORKL6,
        current timestamp tstamp FROM WE_CHECK5C
        WHERE (#LBLBLANR ='500' or #LBLBLANR ='510') and #LBLBBWMG > 0
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR,#LBLBLANR, #LBLBBWMG ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR,#LBLBLANR;

       //__________________________________________________________________
       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Liefertermin ____________________________________________________
       exec sql
        update WE_CHECKTR a set a.LFTERM    =
        (select b.EPBETE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPBETE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  );

       exec sql
         update we_checktr a set dateLFterm =
          ( date(substr(LFterm, 1, 4) concat '-' concat
          substr(LFterm, 5, 2) concat '-' concat
          substr(LFterm, 7, 2)) ) where LFterm > 0;

       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Bestelltermin____________________________________________________
       exec sql
        update WE_CHECKTR a set a.BETERM    =
        (select b.EPBEDA    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPBEDA    from BBep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  );

       exec sql
         update we_checktr a set dateBEterm =
          ( date(substr(BEterm, 1, 4) concat '-' concat
          substr(BEterm, 5, 2) concat '-' concat
          substr(BEterm, 7, 2)) ) where BEterm > 0;

       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Versandtermin____________________________________________________
       exec sql
        update WE_CHECKTR a set a.vsTERM    =
        (select b.EPVSTE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPVSTE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  );

       exec sql
         update we_checktr a set dateVSterm =
          ( date(substr(VSterm, 1, 4) concat '-' concat
          substr(VSterm, 5, 2) concat '-' concat
          substr(VSterm, 7, 2)) ) where VSterm > 0;

       //__________________________________________________________________

       //_Zwischenträger __________________________________________________
       exec sql
        insert into tvrelwaeco/we_check5d
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(max(#LBLBBDAT), 8, 0) #LBLBBDAT,
        #LBLBLANR ,sum(#LBLBBWMG) #LBLBBWMG,
        ( date(substr(max(#LBLBBDAT), 1, 4) concat '-' concat
        substr(max(#LBLBBDAT), 5, 2) concat '-' concat
        substr(max(#LBLBBDAT), 7, 2)) ) #date
        FROM WE_CHECK5C
        WHERE (#LBLBLANR ='500' or #LBLBLANR ='510') and #LBLBBWMG  > 0
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR,#LBLBLANR            ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR,#LBLBLANR;


       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       exec sql
        update WE_CHECKTR a set a.dat500510 =
        (select b.#LBLBBDAT from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBDAT from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );

       exec sql
        update WE_CHECKTR a set a.bwmg500510=
        (select b.#LBLBBWMG from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBWMG from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );

       exec sql
        update WE_CHECKTR a set a.date500510=
        (select b.#date     from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#date     from WE_CHECK5D b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );

       //_Zwischenträger __________________________________________________
       //_Achtung Lagerbuchungsfehler !!!!!!!! ____________________________
       //es wurde sowohl auf 500 und 510 gebucht also von 500 auf 110 z.b._
       //daher eigenen Zwischenträger bilden
       exec sql
        insert into tvrelwaeco/we_check5e
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(max(#LBLBBDAT), 8, 0) #LBLBBDAT
          ,sum(#LBLBBWMG) #LBLBBWMG,
        ( date(substr(max(#LBLBBDAT), 1, 4) concat '-' concat
        substr(max(#LBLBBDAT), 5, 2) concat '-' concat
        substr(max(#LBLBBDAT), 7, 2)) ) #date
        FROM WE_CHECK5C
        WHERE (#LBLBLANR ='100' or #LBLBLANR ='110')
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR              ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR;

       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       exec sql
        update WE_CHECKTR a set a.dat100110 =
        (select b.#LBLBBDAT from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBDAT from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );


       exec sql
        update WE_CHECKTR a set a.bwmg100110=
        (select b.#LBLBBWMG from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBWMG from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );


       exec sql
        update WE_CHECKTR a set a.date100110=
        (select b.#date     from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#date     from WE_CHECK5e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR );


       //_Zwischenträger __________________________________________________
       //wegen der Überprüfbarkeit eigene Datei bilden
       //alle Restbuchungen
       exec sql
        insert into tvrelwaeco/we_check5f
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(max(#LBLBBDAT), 8, 0) #LBLBBDAT
          ,sum(#LBLBBWMG) #LBLBBWMG,
        ( date(substr(max(#LBLBBDAT), 1, 4) concat '-' concat
        substr(max(#LBLBBDAT), 5, 2) concat '-' concat
        substr(max(#LBLBBDAT), 7, 2)) ) #date
        FROM WE_CHECK5C
        WHERE  #LBLBLANR not in('100', '110', '500', '510')
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR              ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR;


       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       exec sql
        update WE_CHECKTR a set a.dat001 =
        (select distinct max(b.#lblbbdat)    from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#lblbbdat,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select  distinct max(b.#lblbbdat)    from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#lblbbdat,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR);

       exec sql
        update WE_CHECKTR a set a.bwmg001=
        (select          sum(b.#LBLBBWMG)    from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by             b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select          sum(b.#LBLBBWMG)    from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by             b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR);

       exec sql
        update WE_CHECKTR a set a.date001=
        (select distinct max(b.#date)        from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#date    ,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select distinct max(b.#date)        from WE_CHECK5f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#date    ,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR);

       exec sql
        update we_checktr set workl1=
        decimal(days(dATE500510)-days(LBLBBDAT))
        WHERE DAT500510 <> 0;

       exec sql
        update we_checktr set workl11=
        decimal(days(DATE001)-days(DATE500510))
        WHERE DAT500510 <> 0 and dat001 <> 0;


       exec sql
        update we_checktr set workl2=
        decimal(days(date100110)-days(DATE500510))
        WHERE DAT100110 <> 0;

       exec sql
        update we_checktr set workl3=
        decimal(days(date001)-days(DATE100110))
        WHERE DAT001 <> 0;


       //_Vergleich mit Wareneingang jetzt ________________________________
       exec sql
        update we_checktr set workl6=
        decimal(days(DATE100110)-days(DATELFTERM))
       // decimal(days(DATE500510)-days(DATELFTERM))
        WHERE LFTERM <> 0 and DAT100110  <> 0;


       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE500510,
               zoned((workl1), 8, 0)     workdays, char('I', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT500510 <> 0
        group by #LBLBLANR, DATE500510,WORKL1
        ORDER BY #LBLBLANR, DATE500510,WORKL1;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and DAT500510 <> 0)
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and DAT500510 <> 0)
       and  a.status= 'I' and a.SSSST in ('500', '510');



       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die auch einen Eingang haben          _______________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE100110,
               zoned((workl2), 8, 0)     workdays, char('W', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT100110 <> 0
        group by #LBLBLANR, DATE100110,WORKL2
        ORDER BY #LBLBLANR, DATE100110,WORKL2;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and DAT100110 <> 0)
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and DAT100110 <> 0)
       and  a.status= 'W' and a.SSSST in ('500', '510');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die keinen Eingang haben  OFFEN       _______________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), LBLBBDAT,
               zoned((workl2), 8, 0)     workdays, char('O', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT100110 =  0
        group by #LBLBLANR, LBLBBDAT  ,WORKL2
        ORDER BY #LBLBLANR, LBLBBDAT  ,WORKL2;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die keinen Eingang haben  OFFEN       _______________
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.LBLBBDAT   = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500','510') and b.DAT100110 = 0)
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.LBLBBDAT   = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500','510') and b.DAT100110 = 0)
       and  a.status= 'O' and a.SSSST in ('500', '510');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_LFS Einbuchung__________
       //achtung jetzt A N F A N G S D A T U M   statt date001 => DATE100110
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE100110,
               zoned((workl3), 8, 0)     workdays, char('L', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where DAT001 <> 0
        group by #LBLBLANR, DATE100110,WORKL3
        ORDER BY #LBLBLANR, DATE100110,WORKL3;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //achtung jetzt A N F A N G S D A T U M   statt date001 => DATE100110
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and  zoned((#LBLBLANR), 3, 0) in ('500','510') and b.DAT001 <> 0 )
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500','510')  and b.DAT001 <> 0 )
       and  a.status= 'L' and a.SSSST in ('500', '510');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl11__
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE500510,
               zoned((workl11), 8, 0)     workdays, char('X', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT500510 <> 0 and dat001 <> 0
        group by #LBLBLANR, DATE500510,WORKL11
        ORDER BY #LBLBLANR, DATE500510,WORKL11;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl11__
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE500510 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and
                      (DAT500510 <> 0 and dat001 <> 0))
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and
                      (DAT500510 <> 0 and dat001 <> 0))
       and  a.status= 'X' and a.SSSST in ('500', '510');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl6___
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATELFTERM,
               zoned((workl6), 8, 0)     workdays, char('E', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    LFTERM    <> 0 and DAT100110  <> 0
        group by #LBLBLANR, DATELFTERM,WORKL6
        ORDER BY #LBLBLANR, DATELFTERM,WORKL6;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATElfterm   und erste WE                  ____workl6___
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATElfterm = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and
                      (LFTERM    <> 0 and DAT100110  <> 0))
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATElfterm = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('500', '510') and
                      (LFTERM    <> 0 and DAT100110  <> 0))
       and  a.status= 'E' and a.SSSST in ('500', '510');

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder aus Trend Analyse 825 auf Lager 100 und 101
       //    also ohne vorher auf 500 oder 510 gebucht worden zu sein
       //-----------------------------------------------------------------------

       begsr srinit3;

       err_msg   = '1';

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6B)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6B)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/we_check6) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/we_check6)             ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6B)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6B)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6C)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6C)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6D)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6D)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6E)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6e)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/WE_CHECK6F)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/WE_CHECK6f)           ';
             exsr      SR_log;
       endmon;


       //1) Grundfilter zeitliches Limit

       //_Filter___________________________________________________________
       //_alle Optionen wegen der Laufzeit zuordnen           ==>we_check6_
       //_wurde bereits oben gemacht
       //_Filter_nur 500 und 510 für 1.Koordinate_nur WE's 825'er__________
/*     //* ...                                                                  */
       //_nur 825 auswählen mit Lager 500/510                 ==>we_check6b
       exec sql
        insert into tvrelwaeco/we_check6b
        SELECT * FROM we_check5
        WHERE #LBLBLSTC ='825' and #LBLBLANR in ('100', '110');

       //_Filter_nur 100 und 110 für 1.Koordinate__________________________
       exec sql
        insert into tvrelwaeco/we_check6c
        SELECT * from we_check6b a where a.#AEWENR  <> ' '  and
         a.#AEFIRM not in (select b.#AEFIRM from we_check5b b where
                        a.#AEBEJJ = b.#AEBEJJ and
                        a.#AEBENR = b.#AEBENR and
                        a.#AEBEPO = b.#AEBEPO and
                        a.#AELFNR = b.#AELFNR and
                        a.#AEWEJJ = b.#AEWEJJ and
                        a.#AEWENR = b.#AEWENR )
        order by #AEWEJJ,
                 #AEWENR;

       //_Koordinatensystem ableiten für 100 und 110 als Basisdatenbank____
       //_1. Ableitung bereits integriert
       exec sql
        insert into tvrelwaeco/WE_CHECKTR
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(min(#LBLBBDAT), 8, 0) #LBLBBDAT,
        #LBLBLANR ,#LBLBBWMG,
        ( date(substr(min(#LBLBBDAT), 1, 4) concat '-' concat
        substr(min(#LBLBBDAT), 5, 2) concat '-' concat
        substr(min(#LBLBBDAT), 7, 2))) LBLBBDAT,
        zoned(0, 8, 0) dat500510, dec(0,0, 14, 4)bwmg500510,
        current date date500510, decimal(0, 8, 0) WORKL1,
                                 decimal(0, 8, 0) WORKL11,
        zoned(0, 8, 0) dat100110, dec(0,0, 14, 4)bwmg100110,
        current date date100110, decimal(0, 8, 0) WORKL2,
        zoned(0, 8, 0) dat001, dec(0,0, 14, 4)bwmg001,
        current date date001,  decimal(0, 8, 0) WORKL3,
        zoned(0, 8, 0) lfterm,current date datelfterm,decimal(0, 8, 0) WORKL4,
        zoned(0, 8, 0) beterm,current date datebeterm,decimal(0, 8, 0) WORKL5,
        zoned(0, 8, 0) vsterm,current date datevsterm,decimal(0, 8, 0) WORKL6,
        current timestamp tstamp FROM WE_CHECK6C
        WHERE (#LBLBLANR ='100' or #LBLBLANR ='110') and #LBLBBWMG > 0
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR,#LBLBLANR, #LBLBBWMG ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR,#LBLBLANR;

       //__________________________________________________________________
       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Liefertermin ____________________________________________________
       exec sql
        update WE_CHECKTR a set a.LFTERM    =
        (select b.EPBETE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPBETE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  ) and a.#LBLBLANR in ('100', '110');

       exec sql
         update we_checktr a set dateLFterm =
          ( date(substr(LFterm, 1, 4) concat '-' concat
          substr(LFterm, 5, 2) concat '-' concat
          substr(LFterm, 7, 2)) ) where LFterm > 0
          and #LBLBLANR in ('100', '110');

       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Bestelltermin____________________________________________________
       exec sql
        update WE_CHECKTR a set a.BETERM    =
        (select b.EPBEDA    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPBEDA    from BBep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  ) and a.#LBLBLANR in ('100', '110');

       exec sql
         update we_checktr a set dateBEterm =
          ( date(substr(BEterm, 1, 4) concat '-' concat
          substr(BEterm, 5, 2) concat '-' concat
          substr(BEterm, 7, 2)) ) where BEterm > 0
          and #LBLBLANR in ('100', '110');

       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       //_Versandtermin____________________________________________________
       exec sql
        update WE_CHECKTR a set a.vsTERM    =
        (select b.EPVSTE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  )
        where exists
        (select b.EPVSTE    from bbep01     b where
         a.#AEFIRM = b.epFIRM  and a.#AEBEJJ = b.epBEJJ and
         a.#AEBENR = b.epBENR  and a.#AEBEPO = b.epBEPO and
         a.#AELFNR = b.epLFNR  ) and a.#LBLBLANR in ('100', '110');

       exec sql
         update we_checktr a set dateVSterm =
          ( date(substr(VSterm, 1, 4) concat '-' concat
          substr(VSterm, 5, 2) concat '-' concat
          substr(VSterm, 7, 2)) ) where VSterm > 0
          and #LBLBLANR in ('100', '110');

       //__________________________________________________________________

       //_Zwischenträger _____WE_CHECK6c__wird nicht gebraucht_____________


       //_Zwischenträger __________________________________________________
       //_Achtung Lagerbuchungsfehler !!!!!!!! ____________________________
       //es wurde sowohl auf 100 und 110 gebucht also von 500 auf 110 z.b._
       //daher eigenen Zwischenträger bilden
       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________

       exec sql
        insert into tvrelwaeco/we_check6e
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(max(#LBLBBDAT), 8, 0) #LBLBBDAT
          ,sum(#LBLBBWMG) #LBLBBWMG,
        ( date(substr(max(#LBLBBDAT), 1, 4) concat '-' concat
        substr(max(#LBLBBDAT), 5, 2) concat '-' concat
        substr(max(#LBLBBDAT), 7, 2)) ) #date
        FROM WE_CHECK6C
        WHERE (#LBLBLANR ='100' or #LBLBLANR ='110')
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR              ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR;

       exec sql
        update WE_CHECKTR a set a.dat100110 =
        (select b.#LBLBBDAT from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBDAT from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR ) and #LBLBLANR in ('100', '110');


       exec sql
        update WE_CHECKTR a set a.bwmg100110=
        (select b.#LBLBBWMG from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#LBLBBWMG from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR ) and #LBLBLANR in ('100', '110');


       exec sql
        update WE_CHECKTR a set a.date100110=
        (select b.#date     from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR )
        where exists
        (select b.#date     from WE_CHECK6e b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR ) and #LBLBLANR in ('100', '110');


       //_Zwischenträger __________________________________________________
       //wegen der Überprüfbarkeit eigene Datei bilden
       //alle Restbuchungen
       exec sql
        insert into tvrelwaeco/we_check6f
        SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR, zoned(max(#LBLBBDAT), 8, 0) #LBLBBDAT
          ,sum(#LBLBBWMG) #LBLBBWMG,
        ( date(substr(max(#LBLBBDAT), 1, 4) concat '-' concat
        substr(max(#LBLBBDAT), 5, 2) concat '-' concat
        substr(max(#LBLBBDAT), 7, 2)) ) #date
        FROM WE_CHECK6C
        WHERE  #LBLBLANR not in('100', '110', '500', '510')
        GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
        #AEWENR, #LBLBTENR              ORDER BY #AEFIRM, #AEBEJJ,
        #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBTENR;


       //_Versorgung der Hauptdatenbank WE_CHECKTR_________________________
       exec sql
        update WE_CHECKTR a set a.dat001 =
        (select distinct max(b.#lblbbdat)    from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#lblbbdat,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select  distinct max(b.#lblbbdat)    from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#lblbbdat,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
         and a.#LBLBLANR in ('100', '110');

       exec sql
        update WE_CHECKTR a set a.bwmg001=
        (select          sum(b.#LBLBBWMG)    from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by             b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select          sum(b.#LBLBBWMG)    from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by             b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
         and a.#LBLBLANR in ('100', '110');

       exec sql
        update WE_CHECKTR a set a.date001=
        (select distinct max(b.#date)        from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#date    ,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
        where exists
        (select distinct max(b.#date)        from WE_CHECK6f b where
         a.#AEFIRM = b.#AEFIRM and a.#AEBEJJ = b.#AEBEJJ and
         a.#AEBENR = b.#AEBENR and a.#AEBEPO = b.#AEBEPO and
         a.#AELFNR = b.#AELFNR and a.#AEWEJJ = b.#AEWEJJ and
         a.#AEWENR = b.#AEWENR  and a.#LBLBTENR = b.#LBLBTENR
                                group by b.#date    ,b.#AEFIRM,
         b.#AEBEJJ, b.#AEBENR, b.#AEBEPO,  b.#AELFNR, b.#AEWEJJ, b.#AEWENR)
         and a.#LBLBLANR in ('100', '110');

       exec sql
        update we_checktr set workl1=
        decimal(days(dATE500510)-days(LBLBBDAT))
        WHERE DAT500510 <> 0 and #LBLBLANR in ('100', '110');

       exec sql
        update we_checktr set workl11=
        decimal(days(DATE001)-days(DATE500510))
        WHERE DAT500510 <> 0 and dat001 <> 0 and #LBLBLANR in ('100', '110');


       exec sql
        update we_checktr set workl2=
        decimal(days(date100110)-days(DATE500510))
        WHERE DAT100110 <> 0 and #LBLBLANR in ('100', '110');

       exec sql
        update we_checktr set workl3=
        decimal(days(date001)-days(DATE100110))
        WHERE DAT001 <> 0 and #LBLBLANR in ('100', '110');


       //_Vergleich mit Wareneingang jetzt ________________________________
       exec sql
        update we_checktr set workl6=
         decimal(days(DATE100110)-days(DATELFTERM))
        // decimal(days(DATE500510)-days(DATELFTERM))
        WHERE LFTERM <> 0 and DAT100110  <> 0
                          and #LBLBLANR in ('100', '110');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die auch einen Eingang haben          _______________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE100110,
               zoned((workl2), 8, 0)     workdays, char('W', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT100110 <> 0 and #LBLBLANR in ('100', '110')
        group by #LBLBLANR, DATE100110,WORKL2
        ORDER BY #LBLBLANR, DATE100110,WORKL2;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and DAT100110 <> 0)
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and DAT100110 <> 0)
       and  a.status= 'W' and a.SSSST in ('100', '110');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die keinen Eingang haben  OFFEN       _______________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), LBLBBDAT,
               zoned((workl2), 8, 0)     workdays, char('O', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT100110 =  0 and #LBLBLANR in ('100', '110')
        group by #LBLBLANR, LBLBBDAT  ,WORKL2
        ORDER BY #LBLBLANR, LBLBBDAT  ,WORKL2;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //_nur welche, die keinen Eingang haben  OFFEN       _______________
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.LBLBBDAT   = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100','110') and b.DAT100110 = 0)
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.LBLBBDAT   = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100','110') and b.DAT100110 = 0)
       and  a.status= 'O' and a.SSSST in ('100', '110');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_LFS Einbuchung__________
       //achtung jetzt A N F A N G S D A T U M   statt date001 => DATE100110
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE100110,
               zoned((workl3), 8, 0)     workdays, char('L', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where DAT001 <> 0 and #LBLBLANR in ('100', '110')
        group by #LBLBLANR, DATE100110,WORKL3
        ORDER BY #LBLBLANR, DATE100110,WORKL3;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_erster WE_______________
       //achtung jetzt A N F A N G S D A T U M   statt date001 => DATE100110
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and  zoned((#LBLBLANR), 3, 0) in ('100','110') and b.DAT001 <> 0 )
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100','110')  and b.DAT001 <> 0 )
       and  a.status= 'L' and a.SSSST in ('100', '110');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl11__
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATE500510,
               zoned((workl11), 8, 0)     workdays, char('X', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where    DAT500510 <> 0 and dat001 <> 0 and #LBLBLANR in ('100', '110')
        group by #LBLBLANR, DATE500510,WORKL11
        ORDER BY #LBLBLANR, DATE500510,WORKL11;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl11__
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE500510 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and
                      (DAT500510 <> 0 and dat001 <> 0))
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATE100110 = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and
                      (DAT500510 <> 0 and dat001 <> 0))
       and  a.status= 'X' and a.SSSST in ('100', '110');


       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATE500510 und Beendifung in lfs  DATE001  ____workl6___
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT zoned((#LBLBLANR), 3, 0), DATELFTERM,
               zoned((workl6), 8, 0)     workdays, char('E', 1) status,
               decimal(count(*), 5) rate,
               decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
               decimal(0, 5, 0) freeday FROM we_checktr
        where LFTERM <> 0 and DAT100110  <> 0 and #LBLBLANR in ('100', '110')
        group by #LBLBLANR, DATELFTERM,WORKL6
        ORDER BY #LBLBLANR, DATELFTERM,WORKL6;

       //_Versorgung der Hauptdatenbank WE_CHECK_1_invoicing_______________
       //_zwischen DATElfterm   und erste WE                  ____workl6___
       exec sql
       update we_check_1 a set daytotal =
        (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATElfterm = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and
                      (LFTERM    <> 0 and DAT100110  <> 0))
       where exists
       (select count(*)  from tvrelwaeco/we_checktr b where
       b.DATElfterm = a.INPD    and a.SSSST=zoned((#LBLBLANR), 3, 0)
       and zoned((#LBLBLANR), 3, 0) in ('100', '110') and
                      (LFTERM    <> 0 and DAT100110  <> 0))
       and  a.status= 'E' and a.SSSST in ('100', '110');



       exec sql
          update TVRELWAECO/we_checktr set  datevsterm
          = current date + 10 year  WHERE datevsterm >
            current date + 10 year;


       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //report customer
       //-----------------------------------------------------------------------

       begsr SR_report;

         eval p_infil   =  'WE_CHECK' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WE_CHECK';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/WE_CHECK*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed WE_CHECK*              ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object WE_CHECK*                 ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'WE_CHECK';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WE_CHECK                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECK';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WE_CHECK)      ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WE_CHECK)     ';
       endmon;


       exsr  SR_we2;
       exsr  SR_we3;

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''WE_CHECK'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object ' +
                         p_outfil +'csv';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECK';

       //-----------------------------------------------------------------------
       //'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
       //''' '' '' '' '' '')';
       //-----------------------------------------------------------------------
       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT10'' ' +
           ''' '' '' '' '' '')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by DUMMY512                        ';
          exsr      SR_log;
       endmon;

       endsr;


       //-----------------------------------------------------------------------
       //report clients
       //-----------------------------------------------------------------------

       begsr SR_we2;

         eval p_infil   =  'WE_CHECK_1' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WE_CHECK_1';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/WE_CHECK_1*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed WE_CHECK_1*            ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object WE_CHECK_1*               ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'WE_CHECK_1';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WE_CHECK_1                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECK_1';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(KOLTHOFF MEIER POHLAND FUNKE) DTAAUT(*RWX) ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/USERI5) gang  ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/USERI5) gang ';
       endmon;


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WE_CHECK1)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WE_CHECK1)    ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //report clients
       //-----------------------------------------------------------------------

       begsr SR_we3;

         eval p_infil   =  'WE_CHECKTR' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WE_CHECKTR';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/WE_CHECKTR*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed WE_CHECKTR*            ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object WE_CHECKTR*               ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'WE_CHECKTR';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WE_CHECKTR                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECKTR';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(KOLTHOFF MEIER POHLAND FUNKE) DTAAUT(*RWX) ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/USERI5) gang  ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/USERI5) gang ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WE_CHECKTR)    ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WE_CHECKTR)   ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'WE_CHECK  ';
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


