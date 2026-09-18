
      //************************************************************************
      //
      //      Programmname       .....................
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
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
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------


      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur



      // System-Datenstruktur
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

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------
      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         480A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            520A   varying

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

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D P_INFIL         s             21A   inz
     D §RECORDS        s              7  0 inz
     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz
     D error4          s              1a   inz
     D error5          s              1a   inz
     D Quser           s             10a   inz
     D Qjob            s             10a   inz
     D Qnumber         s              6a   inz
     D link            s             26a   inz
     D Qspool          s             10a   inz
     D qlfdnr          s              4a   inz
     D qoutq           s             10a   inz
     D qinputdat       s             08a   inz
     D qinputdat#      s               d   DATFMT(*ymd)
     D qinputtime      s             08a   inz

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       eval status ='Start TR_LFS_R  Analyse Lagerinput eingeleitet';
       exsr      SR_log;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/TR_LFS1)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/TR_LFS1)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/TR_LFS2)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/TR_LFS2)           ';
             exsr      SR_log;
       endmon;


       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/TR_LFS)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/TR_LFS)           ';
             exsr      SR_log;
       endmon;


       exec sql
          insert into  tvrelwaeco/TR_LFS1
          SELECT char(zoned(date(IFBLTSTP))) IN_DATUM,
                 char('Köpfe', 20),
                 dec(count(*), 6, 0) Anzahl
          FROM ifbl, lbak
          WHERE IFBLfirm='01' and
          IFBLdana ='AFKM' and date(IFBLTSTP) > current date -30 day
          and IFBLfirm=LBAKfirm
          and IFBLdana=LBAKdana
          and IFBLjahr=LBAKjahr
          and IFBLnmkr=LBAKnmkr
          group by  char(zoned(date(IFBLTSTP)));

       exec sql
          insert into  tvrelwaeco/TR_LFS2
          SELECT char(zoned(date(IFBLTSTP))) IN_DATUM,
                 char('Positionen', 20),
                 dec(count(*), 6, 0) Anzahl
          FROM ifbl, lbak, lbap
          WHERE IFBLfirm='01' and
          IFBLdana ='AFKM' and date(IFBLTSTP) > current date -30 day
          and IFBLfirm=LBAKfirm and IFBLfirm=LBApfirm
          and IFBLdana=LBAKdana and IFBLdana=LBApdana
          and IFBLjahr=LBAKjahr and IFBLjahr=LBApjahr
          and IFBLnmkr=LBAKnmkr and IFBLnmkr=LBApnmkr
          group by  char(zoned(date(IFBLTSTP)));

       exec sql
          insert into  tvrelwaeco/TR_LFS
          select TR_LFS1.IN_DATUM, TR_LFS1.SEL0002,
          TR_LFS1.ANZAHL, TR_LFS2.IN_DATUM,
          TR_LFS2.SEL0002, TR_LFS2.ANZAHL, current
          timestamp tstamp
          FROM tr_lfs1, tr_lfs2
          WHERE TR_LFS1.IN_DATUM = TR_LFS2.IN_DATUM
          order by TR_LFS1.IN_DATUM desc;

          exsr SR_output;

       eval status ='Ende TR_LFS_R Analyse Lagerinput ingeleitet';
       exsr      SR_log;

       *inlr = *on;


       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'TR_LFS'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'TR_LFS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/TR_LFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/TR_LFS2017*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/TR_LFS2017*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'TR_LFS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object TR_LFS                    ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'TR_LFV   ';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/TR_LFS)       ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/TR_LFS)      ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/IT/TR_LFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /IT/TR_LFS2017*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /IT/TR_LFS2017*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'TR_LFS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/IT/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object TR_LFS                    ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'TR_LFV   ';


       MONITOR;
       Wrk.var1 =
           'STRPCO PCTA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='STRPCO successful                                  ';
       on-error;
          status='Error by STRPCO                                  ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'STRPCCMD PCCMD(''//172.16.100.1/Lager/cpy.cmd'')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='STRPCCMD successful FILE(TVRELWAECO/...CKOUT3)       ';
       on-error;
          status='Error by STRPCCMD object (TVRELWAECO/....KOUT3)    ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'AT_item   ';
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
