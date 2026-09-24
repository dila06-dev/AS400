
      //************************************************************************
      //
      //      Programmname
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung
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
       eval status ='JIS-Invoices  Start                       ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';
       endif;

       //________________________________
       //.............

       // ______________________________________________________________________

       eval status ='JIS-Invoices  Ende                      ';
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

       //           JIS_order
       exec sql
         delete from tvrelwaeco/JIS_order;

       //           JIS_posit
       exec sql
         delete from tvrelwaeco/JIS_posit;

       //           JIS_unique
       exec sql
         delete from tvrelwaeco/JIS_unique;

       //           JIS_input
       exec sql
         delete from tvrelwaeco/JIS_input;

       //           JIS_order
       exec sql
         insert into JIS_order
         SELECT akfirm,AKKDNR,akafst, akref1, count(*) FROM afko01 WHERE
         AKFIRM='01' and ( AKKDNR = '082157' or AKKDNR = '001075') and
         (substr(akmaaf, 1, 7)= substr(akref1, 1, 7) ) and akafst < '90'
         GROUP BY akfirm,AKKDNR,akafst, akref1 HAVING count(*) > 1 ORDER BY
         akkdnr,akref1;

       //           JIS_posit
       exec sql
         insert into JIS_posit
         SELECT apfirm, APKDNR , APSARG , substr(aPMAAF, 1, 8) apmaaf,
         APAFST, count(*) FROM afpo01 WHERE APFIRM ='01' and ( ApKDNR =
         '001075' or ApKDNR = '082157') and substr(apmaaf, 1, 8) in ( select
         substr(akref1, 1, 8) from JIS_order  where akfirm=apfirm and
         akkdnr=apkdnr) GROUP BY apfirm, APKDNR , APSARG,substr(aPMAAF, 1,
         8) ,APAFST ORDER BY apfirm, APKDNR,substr(aPMAAF, 1, 8);

       //           JIS_unique
       exec sql
         insert into JIS_unique
         SELECT APFIRM, APKDNR, APSARG, APMAAF, count(*) FROM JIS_posit
         GROUP BY APFIRM, APKDNR, APSARG, APMAAF HAVING count(*) = 1;


       //           JIS_unique
       exec sql
         delete   FROM JIS_unique a          WHERE
         a.APFIRM in (select b.APFIRM from jis_posit b where
                                       a.APKDNR= b.APKDNR and
         a.APSARG= b.APSARG and a.APMAAF=
         b.APMAAF and APAFST <> '90');

       //           JIS_input
       exec sql
         insert into JIS_input
         SELECT a.AKFIRM, a.akAFJJ, a.AKAFNR, a.AKKDNR, a.AKref1, a.akafst
         FROM afko01 a WHERE a.akref1 in (select APMAAF from jis_unique) and
         AKAFST = '  ';

       //           JIS_aflk Sicherung
       exec sql
         insert into JIS_aflk
         select * from    aflk01
                              WHERE KLFIRM in (select akfirm from jis_input
         where KLAFJJ =AKAFJJ and KLAFNR=akAFNR and KLkdnr =AKkdnr ) and
         KLSTAT='30';

       //           JIS_aflp Sicherung
       exec sql
         insert into JIS_aflp
         SELECT *        FROM aflp01 WHERE alFIRM in (select akfirm from
         jis_input where alAFJJ =AKAFJJ and alAFNR=akAFNR and alkdnr =AKkdnr
         ) and alafst='30';

       //           JIS_aflk update
       exec sql
         update aflk01 set klstat='35'
                              WHERE KLFIRM in (select akfirm from jis_input
         where KLAFJJ =AKAFJJ and KLAFNR=akAFNR and KLkdnr =AKkdnr ) and
         KLSTAT='30';

       //           JIS_aflp update
       exec sql
         update aflp01 set alafst='35'
                                     WHERE alFIRM in (select akfirm from
         jis_input where alAFJJ =AKAFJJ and alAFNR=akAFNR and alkdnr =AKkdnr
         ) and alafst='30';

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


