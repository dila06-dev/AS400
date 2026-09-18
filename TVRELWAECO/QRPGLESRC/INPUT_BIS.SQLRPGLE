
      //************************************************************************
      //
      //      Programmname
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Items  Österreich updates
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      // CPYFRMIMPF FROMFILE(TVRELWAECO/RABATTE_I) TOFILE(TVRELWAECO/#RAB000IN)
      // MBROPT(*ADD) FLDDLM(';') DECPNT(*COMMA) FROMRCD(1) RPLNULLVAL(*FLDDFT)
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

     fkond01    uf   e           k DISK    RENAME(kond1:phy01R)
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
       //           Rabatte

     d kond01_i      E DS                  ExtName(kond01:*input)
     d                                     Qualified

     d kond01_O      E DS                  ExtName(kond01:*output)
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

     D p_customer      s             10a   inz

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
     D err_msg         s              1a   inz
     D #call           s              1a   inz
     D §ICS_2          s             12s 4 inz
     D §tetenr         s             15a   inz
     D §c              s              4a   inz
     D §d              s              8a   inz

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
     DDate_in_V2       S               D   DATFMT(*iso)
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)


      // Überschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start KDRABATTE                           ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //Beziehungen: RP1 KOPRGR ________
       //                 KOKDLI ________
       //________________________________
       //Beziehungen: RP3 KOPRGR ________
       //                 KOKOND ________
       //________________________________
       //Beziehungen: RP5 KOKDLG Kundengruppe
       //                 KOPRGR Produktgruppe
       //________________________________
       //Firma __ teil
          read kond01 kond01_i;
          dow not %eof(kond01);
                   #ERRORS  = *blank;
                   GoodDateV='1';
                   GoodDateB='1';
                   monitor;
                   Date_in_V=%date(%char(kond01_i.KOGADA):*iso0);
                   On-error *all;
                   GoodDateV='0';
                   eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                   %char(kond01_i.KOGADA) ;
                   endmon;
       //          monitor;
       //          Date_in_B=%date(%char(kond01_i.KOGBDA):*iso0);
       //          On-error *all;
       //          if    kond01_i.KOGBDA<> 0;
       //             GoodDateV='0';
       //             eval #ERRORS ='Von Datum kein reguläres Datum ' +
       //                          %char(kond01_i.KOGBDA) ;
       //          endif;
       //          endmon;
                   if Date_in_V < %date() + %days(1) and GoodDateV='1';
                      eval #ERRORS ='Von Datum zu klein ' +
                                     %char(kond01_i.KOGADA) ;
                   endif;

       //          if Date_in_B <  Date_in_V + %days(1) and
       //              #RAB000IN_i.KOGBDA<> 0    and GoodDateB='1';
       //             eval #ERRORS ='Bis Datum zu klein '    +
       //                             %char(kond01_i.KOGBDA) ;
       //          endif;
       //    Datumsbereiche akzeptieren !!!!!!!!!!!!!!!
             #errors = *blank;
             if kond01_i.KOBEGR     = 'RP1'
             or kond01_i.KOBEGR     = 'RP3'
             or kond01_i.KOBEGR     = 'RP4';
       //       kond01_i.KOPRGR     = '305'
       //       kond01_i.KOKDLG     = '042';
             if kond01_i.KOGBDA     = *zero            and
                kond01_i.KOFIRM     = kond01_o.KOFIRM  and
                kond01_i.KOBEGR     = kond01_o.KOBEGR  and
                kond01_i.KOPSLI     = kond01_o.KOPSLI  and
                kond01_i.KOABTL     = kond01_o.KOABTL  and
                kond01_i.KOLAND     = kond01_o.KOLAND  and
                kond01_i.KOBLGA     = kond01_o.KOBLGA  and
                kond01_i.KOKDLI     = kond01_o.KOKDLI  and
                kond01_i.KOVSNR     = kond01_o.KOVSNR  and
                kond01_i.KOPJNR     = kond01_o.KOPJNR  and
                kond01_i.KOKDLG     = kond01_o.KOKDLG  and
                kond01_i.KOPRGR     = kond01_o.KOPRGR  and
                kond01_i.KOMAGR     = kond01_o.KOMAGR  and
                kond01_i.KOVKGB     = kond01_o.KOVKGB  and
                kond01_i.KOPOLZ     = kond01_o.KOPOLZ  and
                kond01_i.KOSTCD     = kond01_o.KOSTCD  and
                kond01_i.KOTENR     = kond01_o.KOTENR  and
                kond01_i.KOGEBI     = kond01_o.KOGEBI  and
                kond01_i.KOWACD     = kond01_o.KOWACD;

             kond01_o            = kond01_i;

                Date_in_V  = Date_in_V2 - %days(1);
                kond01_o.KOGBDA  = %dec(%char((Date_in_V):*iso0):8:0);

                kond01_o.KOLOCK     = *blank;
                kond01_o.KOJNAM     = §§§job;
                kond01_o.KOJDAT     = %dec(%char(%date():*iso0):8:0);
                kond01_o.KOJZEI     = %dec(%char(%time():*iso0):6:0);
                kond01_o.KOUSER     = §§§usr;
                kond01_o.KOPROG     = §§§pgm;
                kond01_o.KOBIBL     = §§§LIB;
                kond01_o.KOTSTP     = %timestamp();
                update phy01R    kond01_O;
             endif;
             endif;

             kond01_o.KOFIRM     = kond01_i.KOFIRM;
             kond01_o.KOBEGR     = kond01_i.KOBEGR;
             kond01_o.KOPSLI     = kond01_i.KOPSLI;
             kond01_o.KOABTL     = kond01_i.KOABTL;
             kond01_o.KOLAND     = kond01_i.KOLAND;
             kond01_o.KOBLGA     = kond01_i.KOBLGA;
             kond01_o.KOKDLI     = kond01_i.KOKDLI;
             kond01_o.KOVSNR     = kond01_i.KOVSNR;
             kond01_o.KOPJNR     = kond01_i.KOPJNR;
             kond01_o.KOKDLG     = kond01_i.KOKDLG;
             kond01_o.KOPRGR     = kond01_i.KOPRGR;
             kond01_o.KOMAGR     = kond01_i.KOMAGR;
             kond01_o.KOVKGB     = kond01_i.KOVKGB;
             kond01_o.KOPOLZ     = kond01_i.KOPOLZ;
             kond01_o.KOSTCD     = kond01_i.KOSTCD;
             kond01_o.KOTENR     = kond01_i.KOTENR;
             kond01_o.KOGEBI     = kond01_i.KOGEBI;
             kond01_o.KOWACD     = kond01_i.KOWACD;
             Date_in_V2 = Date_in_V;

             read kond01 kond01_i;
          enddo;

       endif;

       // ______________________________________________________________________

       eval status ='#RAB000IN                               ';
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

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



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


