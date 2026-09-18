
      //************************************************************************
      //
      //      Programmname       ....
      //      Erstellt  am       ....
      //      Erstellt von       Dometic Waeco
      //
      */      Beschreibung
      //
      //
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

     fkalk_file if   e             DISK    RENAME(KALK_F1:PHY05R)
      //fkalk_file if   e           k DISK

      // ...
     fprj015p   uf   e           k disk    RENAME(PRJ015F:PHY01R)
      //                                   prefix('$')
      // ...
     f#prj015p  uf a e           k disk    RENAME(PRJ015F:PHY02R)
      //                                   prefix('$')

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

       // ______________________________________________________________________
       //           Abgleich
       //d KUND_k        E DS                  ExtName(kund01:*key)
       //d                                     Qualified

     d kalk_i        E DS                  ExtName(kalk_file:*input)
     d                                     Qualified

     d fadr01_k      E DS                  ExtName(fadr01:*key)
     d                                     Qualified
     d fadr01_i      E DS                  ExtName(fadr01:*input)
     d                                     Qualified
     d fadr01_o      E DS                  ExtName(fadr01:*output)
     d                                     Qualified
     d #prjr01_i     E DS                  ExtName(#fadr01:*input)
     d                                     Qualified
     d #fadr01_o     E DS                  ExtName(#fadr01:*output)
     d                                     Qualified

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
     D output          s              1a   inz
     D change          s              1a   inz

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

       eval status ='Start Aufbau für READSEQR eingeleitet    ';
       exsr      SR_log;

       //************************************************************
       //Protokolldaten

          read kalk_file kalk_i;
          dow not %eof(kalk_file);
             if kalk_i.version = '§§EL_PS_DB' and
                kalk_i.sys01   = 'P';
                select;
                when %subst(kalk_i.artnr: 11: 3) = '-CH';
                     exsr sr_update;
                other;
       //            crmoutput_o.ENTITY     = 'ERROR';
                endsl;
             endif;
             read kalk_file kalk_i;
          enddo;

       eval status ='Ende  Aufbau für READSEQR                ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //break and restart reaction cases
       //-----------------------------------------------------------------------

       begsr sr_update;

          prj015p_k.artnum       = %dec(kalk_i.artnr);

          chain %kds(prj015p_k:1) prj015p prj015p_I;
          if %found(prj015p);

       //      Protokollierung Altsatz
                clear  prj015p_o;
                prj015p_o = prj015p_i;
                #fadr01_o.tstamp = %timestamp();
                write  phy02R prj015p_o;

                fadr01_o   = fadr01_i;
       //       if  §§§USR = '    ';
                   update phy01R   fadr01_o;
                   eval status =*blank;
                   exsr      SR_log;
       //       endif;
             endif;
             unlock      fadr01;
          else;
       //    crmoutput_o.CCLINE   =  *zero;
             unlock      fadr01;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr #protokoll;


       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'WATCHADR_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WATCHJOBS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Rhenania/WATCHADR_*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/WATCHADR_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/WATCHADR_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WATCHLFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WATCHLFS)      ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WATCHLFS)     ';
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
