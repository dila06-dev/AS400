
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

     f#RAB000IN if   e           k DISK    RENAME(#RAB000INR:log02R)
     f
     fkond01    o  a e             DISK    RENAME(kond1:phy01R)
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

     d #RAB000IN_i   E DS                  ExtName(#RAB000IN:*input)
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
          read #RAB000IN #RAB000IN_i;
          dow not %eof(#RAB000IN);
             if #RAB000IN_i.KOBEGR = 'RP1';
                clear #RAB000IN_i.KOKDLG;
             endif;
             if #RAB000IN_i.KOBEGR = 'RP3';
                clear #RAB000IN_i.KOKDLG;
             endif;
             if #RAB000IN_i.KOBEGR = 'RP5';
                clear #RAB000IN_i.KOKDLI;
                clear #RAB000IN_i.KOKOND;
             endif;
                   #ERRORS  = *blank;
                   GoodDateV='1';
                   GoodDateB='1';
                   monitor;
                   Date_in_V=%date(%char(#RAB000IN_i.KOGADA):*iso0);
                   On-error *all;
                   GoodDateV='0';
                   eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                   %char(#RAB000IN_i.KOGADA) ;
                   endmon;
       //          monitor;
       //          Date_in_B=%date(%char(#RAB000IN_i.KOGBDA):*iso0);
       //          On-error *all;
       //          if    #RAB000IN_i.KOGBDA<> 0;
       //             GoodDateV='0';
       //             eval #ERRORS ='Von Datum kein reguläres Datum ' +
       //                          %char(#RAB000IN_i.KOGBDA) ;
       //          endif;
       //          endmon;
                   if Date_in_V < %date() + %days(1) and GoodDateV='1';
                      eval #ERRORS ='Von Datum zu klein ' +
                                     %char(#RAB000IN_i.KOGADA) ;
                   endif;

       //          if Date_in_B <  Date_in_V + %days(1) and
       //              #RAB000IN_i.KOGBDA<> 0    and GoodDateB='1';
       //             eval #ERRORS ='Bis Datum zu klein '    +
       //                             %char(#RAB000IN_i.KOGBDA) ;
       //          endif;
       //    Datumsbereiche akzeptieren !!!!!!!!!!!!!!!
             #errors = *blank;
             if #errors = *blank;
                clear    kond01_O;
                kond01_o.KOLOCK     = *blank;
                kond01_o.KOJNAM     = §§§job;
                kond01_o.KOJDAT     = %dec(%char(%date():*iso0):8:0);
                kond01_o.KOJZEI     = %dec(%char(%time():*iso0):6:0);
                kond01_o.KOUSER     = §§§usr;
                kond01_o.KOPROG     = §§§pgm;
                kond01_o.KOBIBL     = §§§LIB;
                kond01_o.KOFIRM     = #RAB000IN_i.KOFIRM;
                kond01_o.KOBEGR     = #RAB000IN_i.KOBEGR;
                kond01_o.KOABTL     = *blank;
                kond01_o.KOLAND     = *blank;
                kond01_o.KOBLGA     = *blank;
                if #RAB000IN_i.KOBEGR = 'RP1';
                   kond01_o.KOKDLI     = #RAB000IN_i.KOKDLI;
                   if  %subst(kond01_o.KOKDLI:1:1) <> *Blank;
                      if %subst(kond01_o.KOKDLI:5:1) = *Blank;
                        §d   = kond01_o.KOKDLI;
                        clear  kond01_o.KOKDLI;
                        %subst(kond01_o.KOKDLI:1:6) ='00' +
                                 %subst(§d:1:4);
                      endif;
                      if %subst(kond01_o.KOKDLI:6:1) = *Blank;
                        §d   = kond01_o.KOKDLI;
                        clear  kond01_o.KOKDLI;
                        %subst(kond01_o.KOKDLI:1:6) ='0' +
                                 %subst(§d:1:5);
                      endif;
                   endif;
                endif;

                if #RAB000IN_i.KOBEGR = 'RP3';
                   kond01_o.KOKDLI     = #RAB000IN_i.KOKOND;
                   if  %subst(kond01_o.KOKDLI:1:1) <> *Blank;
                      if %subst(kond01_o.KOKDLI:5:1) = *Blank;
                        §d   = kond01_o.KOKDLI;
                        clear  kond01_o.KOKDLI;
                        %subst(kond01_o.KOKDLI:1:6) ='00' +
                                 %subst(§d:1:4);
                      endif;
                      if %subst(kond01_o.KOKDLI:6:1) = *Blank;
                        §d   = kond01_o.KOKDLI;
                        clear  kond01_o.KOKDLI;
                        %subst(kond01_o.KOKDLI:1:6) ='0' +
                                 %subst(§d:1:5);
                      endif;
                   endif;
                endif;
                kond01_o.KOVSNR     = *blank;

                if #RAB000IN_i.KOBEGR = 'RP5';
                    kond01_o.KOKDLG     = #RAB000IN_i.KOKDLG;
                    if  %subst(kond01_o.KOKDLG:1:1) <> *Blank;
                       if %subst(kond01_o.KOKDLG:2:1) = *Blank;
                         §c   = kond01_o.KOKDLG;
                         clear  kond01_o.KOKDLG;
                         %subst(kond01_o.KOKDLG:1:3) ='00' +
                                  %subst(§c:1:1);
                       endif;
                       if %subst(kond01_o.KOKDLG:3:1) = *Blank;
                         §c   = kond01_o.KOKDLG;
                         clear  kond01_o.KOKDLG;
                         %subst(kond01_o.KOKDLG:1:3) ='0' +
                                  %subst(§c:1:2);
                       endif;
                    endif;
                endif;
                kond01_o.KOPRGR     = #RAB000IN_i.KOPRGR;
                kond01_o.KOMAGR     = *blank;
                kond01_o.KOVKGB     = *blank;
                kond01_o.KOPOLZ     = *blank;
                kond01_o.KOSTCD     = *blank;
                kond01_o.KOTENR     = *blank;
                kond01_o.KOWACD     = 'EUR';
                kond01_o.KOGADA     = #RAB000IN_i.KOGADA;
                kond01_o.KOGBDA     = *zero;
                kond01_o.KORABA     = #RAB000IN_i.KORABA;
                kond01_o.KOPDVK     = *blank;
                kond01_o.KORBKZ     = *blank;
                kond01_o.KOSTKZ     = *blank;

                kond01_o.KOMG01     = #RAB000IN_i.KOMG01;
                kond01_o.KOMG02     = #RAB000IN_i.KOMG02;
                kond01_o.KOMG03     = #RAB000IN_i.KOMG03;
                kond01_o.KOMG04     = *zero;
                kond01_o.KOMG05     = *zero;
                kond01_o.KOMG06     = *zero;
                kond01_o.KOMG07     = *zero;
                kond01_o.KOMG08     = *zero;
                kond01_o.KOMG09     = *zero;
                kond01_o.KOMG10     = *zero;
                kond01_o.KORB01     = *zero;
                kond01_o.KORB02     = *zero;
                kond01_o.KORB03     = *zero;
                kond01_o.KORB04     = *zero;


                kond01_o.KORB05     = *zero;
                kond01_o.KORB06     = *zero;
                kond01_o.KORB07     = *zero;
                kond01_o.KORB08     = *zero;
                kond01_o.KORB09     = *zero;
                kond01_o.KORB10     = *zero;
                kond01_o.KOPD01     = *blank;
                kond01_o.KOPD02     = *blank;
                kond01_o.KOPD03     = *blank;
                kond01_o.KOPD04     = *blank;
                kond01_o.KOPD05     = *blank;
                kond01_o.KOPD06     = *blank;
                kond01_o.KOPD07     = *blank;
                kond01_o.KOPD08     = *blank;

                kond01_o.KOPD09     = *blank;
                kond01_o.KOPD10     = *blank;
                kond01_o.KOGEBI     = *blank;
                kond01_o.KOPSLI     = *blank;
                kond01_o.KOLNKZ     = *blank;
                kond01_o.KOTSTP     = %timestamp();
                kond01_o.KOPJNR     = *blank;
                kond01_o.KOFRIN     = *blank;
                kond01_o.KOFREX     = *blank;

             else;
             endif;
             write phy01R     kond01_O;
             clear            kond01_O;
       //    update phy01R    kond01_O;
             read #RAB000IN #RAB000IN_i;
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


