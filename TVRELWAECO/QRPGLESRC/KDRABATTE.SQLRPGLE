
      //************************************************************************
      //
      //      Programmname       AT_item
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
      //
      // update ITEMS000_O set INP1=
      // (select KDKDGR from kund01
      //         WHERE ITEMS000_O.ITEM = KDKDNR and KDFIRM ='01')
      // where exists
      // (select KDKDGR from kund01
      //         WHERE ITEMS000_O.ITEM = KDKDNR and KDFIRM ='01')
      //
      //  item =Kundennummer !!!!!!!!!!
      //
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

     fkdrabatte uf   e             DISK    RENAME(kdrabatte:log01R)
     f                                     usropn
     f
     fkdrabatte#if   e           k DISK    RENAME(kdrabatte_:log02R)
     f                                     usropn

     fkund01    if   e           k DISK

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

     d kdrabatte_i   E DS                  ExtName(kdrabatte:*input)
     d                                     Qualified

     d kdrabatte_o   E DS                  ExtName(kdrabatte:*output)
     d                                     Qualified

     d kdrabatt#_k   E DS                  ExtName(kdrabatte#:*key)
     d                                     Qualified

     d kdrabatt#_i   E DS                  ExtName(kdrabatte#:*input)
     d                                     Qualified

     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
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
       //Firma 61 teil
          open kdrabatte;
          open kdrabatte#;
          read kdrabatte kdrabatte_i;
          kdrabatte_o         = kdrabatte_i;
          dow not %eof(kdrabatte);
             kdrabatt#_k.KOFIRM  = kdrabatte_i.KOFIRM;
             if kdrabatte_i.KOBEGR = 'RP1';
                kdrabatt#_k.KOBEGR  ='RP2';
             endif;
             if kdrabatte_i.KOBEGR = 'RP3';
                kdrabatt#_k.KOBEGR  ='RP4';
             endif;
             if kdrabatte_i.KOBEGR = 'RP5';
                kdrabatt#_k.KOBEGR  ='RP6';
             endif;
             kdrabatt#_k.KOKDLI  = kdrabatte_i.KOKDLI;
             kdrabatt#_k.KOKDLG  = kdrabatte_i.KOKDLG;
             kdrabatt#_k.KOPRGR  = kdrabatte_i.KOPRGR;
             kdrabatt#_k.KOMAGR  = kdrabatte_i.KOMAGR;
             kdrabatt#_k.KOWACD  = kdrabatte_i.KOWACD;
             setll %kds(kdrabatt#_k:7) kdrabatte#;
             reade %kds(kdrabatt#_k:7) kdrabatte#   kdrabatt#_i;
             dow not %eof(kdrabatte#);
                   #ERRORS  = *blank;
                   GoodDateV='1';
                   GoodDateB='1';
                   monitor;
                   Date_in_V=%date(%char(kdrabatt#_i.KOGADA):*iso0);
                   On-error *all;
                   GoodDateV='0';
                   eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                   %char(kdrabatt#_i.KOGADA) ;
                   endmon;
                   monitor;
                   Date_in_B=%date(%char(kdrabatt#_i.KOGBDA):*iso0);
                   On-error *all;
                   if    kdrabatt#_i.KOGBDA<> 0;
                      GoodDateV='0';
                      eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                   %char(kdrabatt#_i.KOGBDA) ;
                   endif;
                   endmon;
                   if Date_in_V < %date() + %days(1) and GoodDateV='1';
       //             eval #ERRORS ='Von Datum zu klein ' +
       //                            %char(kdrabatt#_i.KOGADA) ;
                   endif;

                   if Date_in_B <  Date_in_V + %days(1) and
                       kdrabatt#_i.KOGBDA<> 0    and GoodDateB='1';
                      eval #ERRORS ='Bis Datum zu klein '    +
                                      %char(kdrabatt#_i.KOGBDA) ;
                   endif;
             if #errors = *blank;
                kdrabatte_o.KOBEGR01= kdrabatt#_i.KOBEGR;
                kdrabatte_o.KOKDLI01= kdrabatt#_i.KOKDLI;
                kdrabatte_o.KOKDLG01= kdrabatt#_i.KOKDLG;
                kdrabatte_o.KOPRGR01= kdrabatt#_i.KOPRGR;
                kdrabatte_o.KOMAGR01= kdrabatt#_i.KOMAGR;
                kdrabatte_o.KOWACD01= kdrabatt#_i.KOWACD;
                kdrabatte_o.KOGADA01= kdrabatt#_i.KOGADA;
                kdrabatte_o.KOGBDA01= kdrabatt#_i.KOGBDA;
                kdrabatte_o.KORABA01= kdrabatt#_i.KORABA;
                kdrabatte_o.KOMG0101= kdrabatt#_i.KOMG01;
                kdrabatte_o.KORB0101= kdrabatt#_i.KORB01;
                kdrabatte_o.KOMG0201= kdrabatt#_i.KOMG02;
                kdrabatte_o.KORB0201= kdrabatt#_i.KORB02;
                kdrabatte_o.KOMG0301= kdrabatt#_i.KOMG03;
                kdrabatte_o.KORB0301= kdrabatt#_i.KORB03;
                kdrabatte_o.KOMG0401= kdrabatt#_i.KOMG04;
                kdrabatte_o.KORB0401= kdrabatt#_i.KORB04;
                kdrabatte_o.KOMG0501= kdrabatt#_i.KOMG05;
                kdrabatte_o.KORB0501= kdrabatt#_i.KORB05;
                kdrabatte_o.KOMG0601= kdrabatt#_i.KOMG06;
                kdrabatte_o.KORB0601= kdrabatt#_i.KORB06;
                kdrabatte_o.KOMG0701= kdrabatt#_i.KOMG07;
                kdrabatte_o.KORB0701= kdrabatt#_i.KORB07;
                kdrabatte_o.KOMG0801= kdrabatt#_i.KOMG08;
                kdrabatte_o.KORB0801= kdrabatt#_i.KORB08;
                kdrabatte_o.KOMG0901= kdrabatt#_i.KOMG09;
                kdrabatte_o.KORB0901= kdrabatt#_i.KORB09;
                leave;
             else;
                reade %kds(kdrabatt#_k:7) kdrabatte#   kdrabatt#_i;
             endif;
             enddo;
          //kund
          kund_k.kdfirm  =  kdrabatte_i.KOFIRM;
          kund_k.kdkdnr  =  kdrabatte_i.KOKDLI;
          chain %kds(kund_k:2) kund01 kund_I;
          if %found(kund01);
             if %subst(kdrabatte_o.kdname:1:1) ='*';
                kdrabatte_o.kdname  = '* ' + kund_i.kdnam1;
             else;
                kdrabatte_o.kdname  = kund_i.kdnam1;
             endif;
             %subst(kdrabatte_o.kdname:50:10) = kund_i.KDKOKD;
          endif;
          update log01R    kdrabatte_o;
          read kdrabatte  kdrabatte_i;
          kdrabatte_o         = kdrabatte_i;
          enddo;

          close kdrabatte;
          close kdrabatte#;

       endif;

       // ______________________________________________________________________

       eval status ='KDRABATTE                               ';
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

       //           KDRABATTE
       exec sql
         delete from tvrelwaeco/KDRABATTE;

       //           KDRABATTE
       exec sql
         delete from tvrelwaeco/KDRABATTE_;

       //           KDRABATTE neu
       exec sql
         insert into KDRABATTE
         SELECT distinct KOFIRM, KOBEGR, KOKDLI, KOKDLG,
          char(' ', 60) KDNAME,      KOPRGR, KOMAGR, KOWACD,
         KOGADA, KOGBDA, KORABA , KOMG01, KORB01, KOMG02, KORB02, KOMG03,
         KORB03, KOMG04, KORB04, KOMG05, KORB05, KOMG06, KORB06 ,KOMG07,
         KORB07, KOMG08, KORB08 ,KOMG09, KORB09,
         ' ' KOBEGR, ' ' KOKDLI, ' ' KOKDLG, ' ' KOPRGR, ' 'KOMAGR,
         ' ' KOWACD,
         0 KOGADA, 0 KOGBDA, 0 KORABA, 0 KOMG01, 0 KORB01,
         0 KOMG02, 0 KORB02, 0 KOMG03,
         0 KORB03, 0 KOMG04, 0 KORB04, 0 KOMG05, 0 KORB05,
         0 KOMG06, 0 KORB06, 0 KOMG07,
         0 KORB07, 0 KOMG08, 0 KORB08, 0 KOMG09, 0 KORB09
         FROM  kond01, ITEMS000_o
         WHERE KOFIRM ='01' and substr(KOBEGR, 1, 2) <> 'RA' and
             ( KOKDLI in (select item from ITEMS000_o ) or
               KOKDLI in (select INP2 from ITEMS000_o ) or
               KOKDLG in (select INP1 from ITEMS000_o ));

       //           KDRABATTE neu
       exec sql
         insert into KDRABATTE
         SELECT distinct KOFIRM, KOBEGR, substr(item, 1, 10) KOKDLI, KOKDLG,
          char('*', 60) KDNAME,      KOPRGR, KOMAGR, KOWACD,
         KOGADA, KOGBDA, KORABA , KOMG01, KORB01, KOMG02, KORB02, KOMG03,
         KORB03, KOMG04, KORB04, KOMG05, KORB05, KOMG06, KORB06 ,KOMG07,
         KORB07, KOMG08, KORB08 ,KOMG09, KORB09,
         ' ' KOBEGR, ' ' KOKDLI, ' ' KOKDLG, ' ' KOPRGR, ' 'KOMAGR,
         ' ' KOWACD,
         0 KOGADA, 0 KOGBDA, 0 KORABA, 0 KOMG01, 0 KORB01,
         0 KOMG02, 0 KORB02, 0 KOMG03,
         0 KORB03, 0 KOMG04, 0 KORB04, 0 KOMG05, 0 KORB05,
         0 KOMG06, 0 KORB06, 0 KOMG07,
         0 KORB07, 0 KOMG08, 0 KORB08, 0 KOMG09, 0 KORB09
         fROM kdrabatte,ITEMS000_O WHERE KOKDLI =' ' and
         KDRABATTE.KOKDLG = ITEMS000_O.INP1;

       //           KDRABATTE
       exec sql
         delete FROM KDRABATTE WHERE KOGBDA <> 0 and KOGBDA < :nowdate;

       //           Keybereiche
       exec sql
         create index  KDRABATTE#  on   KDRABATTE_
         (KOFIRM, KOBEGR, KOKDLI, KOKDLG, KOPRGR,
          KOMAGR, KOWACD, KOGADA);

       exec sql
         insert into tvrelwaeco/KDRABATTE_
         select * from kdrabatte  where kobegr in ('RP2','RP4','RP6');

       exec sql
         delete from kdrabatte  where kobegr in  ('RP2','RP4','RP6');

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


