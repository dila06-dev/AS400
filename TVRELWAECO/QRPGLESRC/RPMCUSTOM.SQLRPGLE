
      //************************************************************************
      //
      //      Programmname       RPMCUSTOM
      //      Erstellt  am       25.08.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an RPM customer report
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      // create index tvrelwaeco/absatzb4l1 on tvrelwaeco/absatzb4
      // (APKDNR, JAHR)
      // create index tvrelwaeco/absatzb4#l on tvrelwaeco/absatzb4#
      // (AKFIRM, APKDNR, JAHR)
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

     fkund01    if   e           k DISK

     fkueg01    if   e           k DISK

     fkdew01    if   e           k DISK

     fRPMCUSTOM o  a e             disk

     fabsatzb4l1if   e           k DISK    USROPN

     fabsatzb4#lif   e           k DISK    USROPN
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


     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
     d                                     Qualified

     d kueg_k        E DS                  ExtName(kueg01:*key)
     d                                     Qualified

     d kueg_i        E DS                  ExtName(kueg01:*input)
     d                                     Qualified

     d kdew_k        E DS                  ExtName(kdew01:*key)
     d                                     Qualified

     d kdew_i        E DS                  ExtName(kdew01:*input)
     d                                     Qualified

     d rpmcustom_o   E DS                  ExtName(RPMCUSTOM:*output)
     d                                     Qualified

     d absatzb4l1_k  E DS                  ExtName(absatzb4l1:*key)
     d                                     Qualified

     d absatzb4l1_i  E DS                  ExtName(absatzb4l1:*input)
     d                                     Qualified

     d absatzb4#l_k  E DS                  ExtName(absatzb4#l:*key)
     d                                     Qualified

     d absatzb4#l_i  E DS                  ExtName(absatzb4#l:*input)
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

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     D years           s              4s 0 inz


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for RPM Customers';
       exsr      SR_log;

       exec sql
         delete from RPMCUSTOM;
       //sql handling
         exec sql
                  whenever not found CONTINUE;;
         exec sql
                  WHENEVER SQLWARNING CONTINUE;
         exec sql
                  WHENEVER SQLERROR  CONTINUE;

       exsr  srinit;

       open absatzb4l1;

       open absatzb4#l;

       kund_k.kdfirm = *zero;
       kund_k.kdkdnr = *zero;

       setll %kds(kund_K:2) kund01;
       //reade %kds(kund_K:1) kund01 kund_i;
        read kund01 kund_i;
       dow not %eof(kund01);

       if %subst(kund_i.kdfirm:1:2) = '01' or
          %subst(kund_i.kdfirm:1:2) = '08' or
          %subst(kund_i.kdfirm:1:2) = '52' or
          %subst(kund_i.kdfirm:1:2) = '55';
          clear rpmcustom_o;
       //für upload
          eval rpmcustom_o.h4 = 'upload';
          select;
             when kund_i.kdfirm = '01';
                  rpmcustom_o.ENTITY     = 'DE411';
             when kund_i.kdfirm = '08';
                  rpmcustom_o.ENTITY     = 'BE111';
             when kund_i.kdfirm = '52';
                  rpmcustom_o.ENTITY     = 'NL411';
             when kund_i.kdfirm = '55';
                  rpmcustom_o.ENTITY     = 'CH412';
             other;
                  rpmcustom_o.ENTITY     = 'ERROR';
                  eval rpmcustom_o.h4    = 'no upload';
          endsl;
          rpmcustom_o.CUSTOMER#  = kund_i.kdkdnr;
          rpmcustom_o.CUSTOMER   = kund_i.kdnam1;
          if  rpmcustom_o.CUSTOMER = *blank;
             rpmcustom_o.CUSTOMER   =  kund_i.KDKNAM;
          endif;
          if  rpmcustom_o.CUSTOMER = *blank;
             rpmcustom_o.CUSTOMER   =  kund_i.KDNAM2;
          endif;
          if  rpmcustom_o.CUSTOMER = *blank;
             rpmcustom_o.CUSTOMER   =  kund_i.KDNAM3;
          endif;
          rpmcustom_o.STATUSCUS  = kund_i.KDKDST;

       // ______________________________________________________________________
         // lesen kueg: Referencen aus kueg

          kueg_k.kefirm  =  kund_i.kdfirm;
          kueg_k.kekdnr  =  kund_i.kdkdnr;

          chain %kds(kueg_k:2) kueg01 kueg_I;
          if %found(kueg01);
             eval   rpmcustom_o.VAT# = kueg_I.KEUSTI;
          else;
             clear  rpmcustom_o.vat#;
          endif;
       // ______________________________________________________________________
         // lesen kdew: Referencen aus kdew

          kdew_k.kdewfirm =  kund_i.kdfirm;
          kdew_k.Kdewkdnr =  kund_i.kdkdnr;

          chain %kds(kdew_k:2) kdew01 kdew_I;
          if %found(kdew01);
             eval   rpmcustom_o.RPMGROUP   = %subst(kdew_I.kDEWRPMG:2:2);
             eval   rpmcustom_o.RPMGROUP   = %subst(kdew_I.KDEWFL03:1:20);
             eval   rpmcustom_o.PLANKUNDE  = kdew_I.KDEWKDPL;
             if     rpmcustom_o.RPMGROUP   = *blank;
                    rpmcustom_o.h4   = 'no upload';
             endif;
             select;
                when kdew_I.KDEWKSST = '1001    ';
                    rpmcustom_o.division   = 'RVOEM   ';
                when kdew_I.KDEWKSST = '1002    ';
                    rpmcustom_o.division   = 'RVAM    ';
                when kdew_I.KDEWKSST = '1003    ';
                    rpmcustom_o.division   = 'RETL    ';
                when kdew_I.KDEWKSST = '1004    ';
                    rpmcustom_o.division   = 'LODG    ';
                when kdew_I.KDEWKSST = '1005    ';
                    rpmcustom_o.division   = 'CPVOEM  ';
                when kdew_I.KDEWKSST = '1006    ';
                    rpmcustom_o.division   = 'CPVAM   ';
                when kdew_I.KDEWKSST = '1007    ';
                    rpmcustom_o.division   = 'MAOEM   ';
                when kdew_I.KDEWKSST = '1008    ';
                    rpmcustom_o.division   = 'MAAM    ';
                when kdew_I.KDEWKSST = '1009    ';
                    if rpmcustom_o.ENTITY     = 'DE411'
                    or rpmcustom_o.ENTITY     = 'CH412';
                       rpmcustom_o.division   = 'MEDI    ';
                       rpmcustom_o.h4   = 'no upload';
                    endif;
                    if rpmcustom_o.ENTITY     = 'NL411';
                       rpmcustom_o.division   = 'RETL    ';
                    endif;
                    if rpmcustom_o.ENTITY     = 'BE111';
                       rpmcustom_o.division   = 'LODG    ';
                    endif;
                when kdew_I.KDEWKSST = '1015    ';
                    rpmcustom_o.division   = 'GROUP   ';
                    rpmcustom_o.h4   = 'no upload';
                when kdew_I.KDEWKSST = '1020    ';
                    rpmcustom_o.division   = 'OTHER   ';
                    rpmcustom_o.h4   = 'no upload';
                when kdew_I.KDEWKSST = '6050    ';
                    rpmcustom_o.division   = 'OTHER   ';
                    rpmcustom_o.h4   = 'no upload';
                other;
                    rpmcustom_o.division   = 'ERROR   ';
                    rpmcustom_o.h4         = 'no upload';
             endsl;
          else;
                    rpmcustom_o.division   = 'noRecord';
                    rpmcustom_o.h4         = 'no upload';
          endif;
       // ______________________________________________________________________
         // lesen absatz/umsatz               APKDNR, JAHR

       if  %subst(kund_i.kdfirm:1:2) = '01';
          years = %subdt( %date(): *years );
          absatzb4l1_k.apkdnr  =  kund_i.kdkdnr;
          setll %kds(absatzb4l1_k:1) absatzb4l1;
          reade %kds(absatzb4l1_k:1) absatzb4l1  absatzb4l1_i;
          dow not %eof(absatzb4l1);
             select;
                when absatzb4l1_i.Jahr =      %char(years);
                     rpmcustom_o.ABSATZAJ   = rpmcustom_o.ABSATZAJ  +
                                              absatzb4l1_i.to;
                when absatzb4l1_i.Jahr =      %char(years -1);
                     rpmcustom_o.ABSATZVJ   = rpmcustom_o.ABSATZVJ  +
                                              absatzb4l1_i.to;
                when absatzb4l1_i.Jahr =      %char(years -2);
                     rpmcustom_o.ABSATZVVJ  = rpmcustom_o.ABSATZVVJ +
                                              absatzb4l1_i.to;
                other;
                     rpmcustom_o.ABSATZ_    = rpmcustom_o.ABSATZ_   +
                                              absatzb4l1_i.to;
             endsl;
             reade %kds(absatzb4l1_k:1) absatzb4l1  absatzb4l1_i;
          enddo;
       endif;


       if  %subst(kund_i.kdfirm:1:2) <> '01';
          years = %subdt( %date(): *years );
          absatzb4#l_k.akfirm  =  kund_i.kdfirm;
          absatzb4#l_k.apkdnr  =  kund_i.kdkdnr;
          setll %kds(absatzb4#l_k:2) absatzb4#l;
          reade %kds(absatzb4#l_k:2) absatzb4#l  absatzb4#l_i;
          dow not %eof(absatzb4#l);
                if  kund_i.kdkdnr  ='05089';
                   clear     breakpoint;
                endif;
             select;
                when absatzb4#l_i.Jahr =      %char(years);
                     rpmcustom_o.ABSATZAJ   = rpmcustom_o.ABSATZAJ  +
                                              absatzb4#l_i.to;
                when absatzb4#l_i.Jahr =      %char(years -1);
                     rpmcustom_o.ABSATZVJ   = rpmcustom_o.ABSATZVJ  +
                                              absatzb4#l_i.to;
                when absatzb4#l_i.Jahr =      %char(years -2);
                     rpmcustom_o.ABSATZVVJ  = rpmcustom_o.ABSATZVVJ +
                                              absatzb4#l_i.to;
                other;
                     rpmcustom_o.ABSATZ_    = rpmcustom_o.ABSATZ_   +
                                              absatzb4#l_i.to;
             endsl;
             reade %kds(absatzb4#l_k:2) absatzb4#l  absatzb4#l_i;
          enddo;
       endif;
       // ______________________________________________________________________

         if rpmcustom_o.ABSATZAJ = 0 and
            rpmcustom_o.ABSATZVJ = 0;
            rpmcustom_o.h4         = 'no upload';
         endif;

         eval rpmcustom_o.I1 =  %trimr(rpmcustom_o.ENTITY   ) + ';' +
                                %trimr(rpmcustom_o.CUSTOMER#) + ';' +
                                %trimr(rpmcustom_o.CUSTOMER ) + ';' +
                                %trimr(rpmcustom_o.DIVISION ) + ';' +
                                %trimr(rpmcustom_o.VAT#     ) + ';' +
                                %trimr(rpmcustom_o.RPMGROUP );
         eval rpmcustom_o.h1 = 'upload';
         eval rpmcustom_o.h2 = %date();
         eval rpmcustom_o.h3 = %timestamp();
         eval rpmcustom_o.h5 = %date();
         eval rpmcustom_o.h6 = %timestamp();
         write rpmcustomr rpmcustom_o;
         clear            rpmcustom_o;
        endif;

       //reade %kds(kund_K:1) kund01 kund_i;
        read kund01 kund_i;
       enddo;

       eval  suffix   = 'DE411 ';
       exsr  file_out;

       eval  suffix   = 'BE111 ';
       exsr  file_out;

       eval  suffix   = 'NL411 ';
       exsr  file_out;

       eval  suffix   = 'CH412 ';
       exsr  file_out;

       close  absatzb4l1;

       close  absatzb4#l;

       exec sql
          drop index   tvrelwaeco/absatzb4l1;

       exec sql
          drop index   tvrelwaeco/absatzb4#l;

       eval status ='Ende  FTP Transfer for RPM Customers';
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

         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'DLTF FILE(TVRELWAECO/RPMCDE411) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command DLTF TVRELWAECO/RPMCDE411)       ';
               exsr      SR_log;
         endmon;

         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'DLTF FILE(TVRELWAECO/RPMCBE111) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command DLTF TVRELWAECO/RPMCNE111)       ';
               exsr      SR_log;
         endmon;

         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'DLTF FILE(TVRELWAECO/RPMCNL411) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command DLTF TVRELWAECO/RPMCNL411)       ';
               exsr      SR_log;
         endmon;

         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'DLTF FILE(TVRELWAECO/RPMCCH412) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command DLTF TVRELWAECO/RPMCCH412)       ';
               exsr      SR_log;
         endmon;

       exec sql
            create index tvrelwaeco/absatzb4l1 on
                         tvrelwaeco/absatzb4  (APKDNR, JAHR);

       exec sql
            create index tvrelwaeco/absatzb4#l on
                         tvrelwaeco/absatzb4#  (AKFIRM, APKDNR, JAHR);

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;

       //Ausgabe der einzelnen Files über variable
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6700';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'RPMC'         +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:    p_print:
                        p_outfil: p_lib:    p_repadd);

          eval  transfer =  'Customers-'                          +
                            %trimr(suffix) +'-'                   +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            '.csv';

         clear     Wrk.var1;
         clear     status;

       //OVRDBF FILE INPUT
         MONITOR;
            Wrk.var1 =
                'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                'MBR(RPMCUSTOMC)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
               exsr      SR_log;
         endmon;

         clear     Wrk.var1;
         clear     status;

       //OVRDBF FILE OUTPUT
         MONITOR;
            Wrk.var1 =
                'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                'MBR(RPMCUSTOML)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO/FTP)';
               exsr      SR_log;
         endmon;

       //Info in Outfile timestamp
         clear p_md;
         eval p_msg     =  '#DC0010';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'OUTPUT    ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);


         eval p_outfil  =  'RPMC'         +
                            suffix;
         clear  string_file;
         eval   string_file = 'APPEND ' +
                              'RPMC'    +
                              %trimr(suffix) + ' ' +
                              transfer;

       exec sql
         update input set SRCDTA = :string_file
           where  substr(srcdta, 1, 07) = 'APPEND ';

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       //FTP-Befehl
         MONITOR;
            Wrk.var1 =
                'FTP RMTSYS(''ftp.seit.dometic.com'')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               err_msg = '1';
         endmon;

         if err_msg = '1';
               status='error ftp.seit.dometic.com '    +
                                                  'RPMC'         +
                                                  %trimr(suffix) + ' ' +
                                                  transfer;
               exsr      SR_log;
         else;
               status='transfer successful '    +
                                                  'RPMC'         +
                                                  %trimr(suffix) + ' ' +
                                                  transfer;
               exsr      SR_log;
         endif;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'RPMCUSTOM ';
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


