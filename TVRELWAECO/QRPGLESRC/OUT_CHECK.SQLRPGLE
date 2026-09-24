
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
      //  Achtung akdte ändert sich nicht, wenn doch dann
      //  update out_check set edatum =
      //  date(date (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2)))) where
      //  date(date (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2)))) <> edatum
      //
      //  update out_check set ewoche =
      //  integer(week (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2)))) where ewoche <>
      //  integer(week (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2))))
      //
      //
      //  update out_check set ejahr  =
      //  integer(year (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2)))) where EJahr <>
      //  integer(year (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2))))
      //
      //
      //  update out_check set Ewochent =
      //  integer(dayofweek (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2)))) where Ewochent <>
      //  integer(dayofweek (date(substr(AKDTE, 1, 4)
      //  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //  substr(AKDTE, 7, 2))))
      //
      //  update out_check   set delivdays =
      //  zoned((days (date(substr(AKDTE , 1, 4)
      //  concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
      //  substr(AKDTE , 7, 2)))
      //  -    (days( date(substr(APDTB , 1, 4) concat
      //  '-' concat substr(APDTB , 5, 2) concat '-' concat substr(APDTB , 7,
      //  2))))), 8, 0) where delivdays <>
      //  zoned((days (date(substr(AKDTE , 1, 4)
      //  concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
      //  substr(AKDTE , 7, 2)))
      //  -    (days( date(substr(APDTB , 1, 4) concat
      //  '-' concat substr(APDTB , 5, 2) concat '-' concat substr(APDTB , 7,
      //  2))))), 8, 0)
      //
      //   ... Achtung Datumsbezug nicht aus PSAVEak2 ==> domcomv7
      //  sELECT AKDTDF, AKTIDF, AKDTE , AKTIE ,APANR1, APANRP, APIDEN,
      //         APAPN,          APAPPO
      //  FROM DOMCOMV7/psaveap2, DOMCOMV7/psaveak2
      //  WHERE substr(apanr1, 1, 2) ='K0' and APIDEN <>'ENDE'  and
      //        date(date (date(substr(AKDTE , 1, 4)
      //        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //        substr(AKDTE, 7, 2)))) > current date - 95 day
      //  and AKKONZ = 'EMS' and AKFIRM = 'DWI' and
      //  AKKONZ=ApKONZ  and AKFIRM=ApFIRM  and AKAPN=ApAPN
      //  and (APANR1='K012016284526'
      //  or   APANR1='K012016294197')
      //
      //
      //   ... Achtung Datumsbezug nicht aus PSAVEak ==> domdatv7
      //  sELECT AKDTDF, AKTIDF, AKDTE , AKTIE ,APANR1, APANRP, APIDEN,
      //         APAPN,          APAPPO
      //  FROM DOMdatV7/psaveap , DOMdatV7/psaveak
      //  WHERE substr(apanr1, 1, 2) ='K0' and APIDEN <>'ENDE'  and
      //        date(date (date(substr(AKDTE , 1, 4)
      //        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
      //        substr(AKDTE, 7, 2)))) > current date - 95 day
      //  and AKKONZ = 'EMS' and AKFIRM = 'DWI' and
      //  AKKONZ=ApKONZ  and AKFIRM=ApFIRM  and AKAPN=ApAPN
      //  and (APANR1='K012016284526'
      //  or   APANR1='K012016294197')
      //
      //
      //   .....
      //  select c.AKDTDF,c.AKTIDF,c.AKDTE,c.AKTIE,
      //         d.AKDTDF,d.AKTIDF,d.AKDTE,d.AKTIE
      //  from   DOMdatV7/psaveak  c,  out_check d
      //  where c.AkAPN = d.ApAPN
      //  and (c.AkANR1='K012016284526'
      //  or   c.AkANR1='K012016294197')
      //  grunenberg erweiterung !!!!!!!!!!!!!!!!!!! verladescannung
      //  select c.AKDTDF,c.AKTIDF,c.AKDTE,c.AKTIE, c.AKDTL, c.AKTIL ,
      //
      //  d.AKDTDF,d.AKTIDF,d.AKDTE,d.AKTIE, d.AKDTL, d.AKTIL
      //
      //  from DOMdatV7/psaveak c, DOMcomV7/psaveak2 d
      //
      //  where c.AkAPN = d.AkAPN
      //
      //  and (c.AkANR1='K012016284526'
      //
      //  or c.AkANR1='K012016294197' or c.AKANR1='K012016339409')
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

     fout_check uf   e             DISK    RENAME(out_check:PHY01R)
     f                                     USROPN

     fLbaP01    if   e           k disk

     fafkm01    if   e           k disk

     fafpo01    if   e           k disk

     fPSAVEAK2  if   e           K DISK    RENAME(PANFKOPF:LOG02R)
     f
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

     d out_check_i   E DS                  ExtName(out_check:*input)
     d                                     Qualified

     d out_check_o   E DS                  ExtName(out_check:*output)
     d                                     Qualified

     d LbAp01_k      E DS                  ExtName(LbAp01:*key)
     d                                     Qualified
     d LbAp01_I      E DS                  ExtName(LbAp01:*input)
     d                                     Qualified

     d afkm01_k      E DS                  ExtName(afkm01:*key)
     d                                     Qualified
     d afkm01_I      E DS                  ExtName(afkm01:*input)
     d                                     Qualified

     d afpo01_k      E DS                  ExtName(afpo01:*key)
     d                                     Qualified
     d afpo01_I      E DS                  ExtName(afpo01:*input)
     d                                     Qualified

     d psaveak2_k    E DS                  ExtName(psaveak2:*key)
     d                                     Qualified
     d psaveak2_I    E DS                  ExtName(psaveak2:*input)
     d                                     Qualified

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
       eval status ='Start Out_check                          ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

       //if §records <> *zero;
            exsr      SR_report;
       //endif;

       endif;

       // ______________________________________________________________________

       eval status ='Ende  OUT_CHECK                         ';
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
              'CLRPFM FILE(tvrelwaeco/OUt_check) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/out_Check)             ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/out_check_1)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/out_check_1)           ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/out_join)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/out_join)             ';
             exsr      SR_log;
       endmon;


       //1) abweichende Mengen zu den Auftragspositionen
       //1) apdtb, aptib  datum und Zeit für Lieferung!!!!
       //1) APANR1 ='K012016294197'
       //                      ____,   ____
       exec sql
        insert into tvrelwaeco/out_check
        SELECT AKDTDF, AKTIDF, AKDTE , AKTIE,
        zoned(
        (days (date(substr(AKDTE , 1, 4)
        concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
        substr(AKDTE , 7, 2)))
        -
        (days( date(substr(AKDTDF, 1, 4) concat
        '-' concat substr(AKDTDF, 5, 2) concat '-' concat substr(AKDTDF, 7,
        2))))), 8, 0) workdays,
        date(date (date(substr(AKDTE, 1, 4)
        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
        substr(AKDTE, 7, 2)))) Edatum,
        integer(week (date(substr(AKDTE, 1, 4)
        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
        substr(AKDTE, 7, 2)))) Ewoche,
        integer(year (date(substr(AKDTE, 1, 4)
        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
        substr(AKDTE, 7, 2)))) EJahr,
        integer(dayofweek (date(substr(AKDTE, 1, 4)
        concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
        substr(AKDTE, 7, 2)))) Ewochent, apdtb, aptib,
        zoned((days (date(substr(AKDTE , 1, 4)
        concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
        substr(AKDTE , 7, 2)))
        -    (days( date(substr(APDTB , 1, 4) concat
        '-' concat substr(APDTB , 5, 2) concat '-' concat substr(APDTB , 7,
        2))))), 8, 0) delivdays,
        APAPN1, APAPP1, APAPN2, APGKZ, APTOUR, APVART, APSSC,
        APLFDN, APBSTM, APAPN, APANFM, APAPPO, APRESM, APALM, APPM1,
        APKDNR, APLSNR, APLSNP, APANR1, APANRP, APIDEN, APDTDI, APTIDI,
        dec(0, 5) joining,
        char(' ', 2) LBAPFIRM, zoned(0, 4) LBAPKMJJ, char(' ', 06)
        LBAPKMNR, zoned(0, 4) LBAPKMPO, zoned(0, 4) LBAPAFJJ, char(' ', 06)
        LBAPAFNR, zoned(0, 4) LBAPAFPO, char(' ', 15) LBAPTENR,
        dec(0, 13, 4) LBAPBWMG,dec(0, 13, 4) LBAPRMMG,zoned(0, 26) LBAPTMST,
        zoned(0, 8, 0) AMKMDA, char(' ', 10) amkdnr,char(' ', 03) amafat,
        char(' ', 03) amvsbd,zoned(0, 8, 0) AMLFTE ,char(' ', 03) amlibd,
        char(' ', 01) amliar,
        char(' ', 1) statuslfs,
        char(' ', 1) statustr,
        char(' ', 30) AMNAM1, char(' ', 30) AMNAM2, char(' ', 30) AMNAM3,
        char(' ', 30) AMSTRA, char(' ',  3) AMPOLD, char(' ', 10) AMPOLZ,
        char(' ', 30) AMWORT, char(' ', 10) AMPOFA, char(' ', 03) AMLAND,
        char(' ', 03) AMPOLN,
        current timestamp tstamp
        FROM DOMCOMV7/psaveap2, DOMCOMV7/psaveak2
        WHERE substr(apanr1, 1, 2) ='K0' and APIDEN <>'ENDE'  and
              date(date (date(substr(AKDTE , 1, 4)
              concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
              substr(AKDTE, 7, 2)))) > current date - 722 day
       //     AKDTE > 20160000
        and AKKONZ = 'EMS' and (AKFIRM = 'DWI' or AKFIRM = 'SCH') and
        AKKONZ=ApKONZ  and AKFIRM=ApFIRM  and AKAPN=ApAPN;
       //     and apbstm <> apalm;

       //1a) Trend geht nur bis zum verpacken
       exec sql
        update out_check a set a.akdtdf =
        ( select b.akdtdf from DOMdatV7/psaveak b
          where a.apapn=b.akapn and a.akdtdf<>b.akdtdf and
                AKKONZ = 'EMS' and (AKFIRM = 'DWI' or AKFIRM = 'SCH'))
        where exists
        ( select b.akdtdf from DOMdatV7/psaveak b
          where a.apapn=b.akapn and a.akdtdf<>b.akdtdf and
                AKKONZ = 'EMS' and (AKFIRM = 'DWI' or AKFIRM = 'SCH'));

       //1a) Trend geht nur bis zum verpacken
       exec sql
        update out_check a set a.AKTIDF =
        ( select b.AKTIDF from DOMdatV7/psaveak b
          where a.apapn=b.akapn and a.AKTIDF<>b.AKTIDF and
                AKKONZ = 'EMS' and (AKFIRM = 'DWI' or AKFIRM = 'SCH'))
        where exists
        ( select b.AKTIDF from DOMdatV7/psaveak b
          where a.apapn=b.akapn and a.AKTIDF<>b.AKTIDF and
                AKKONZ = 'EMS' and (AKFIRM = 'DWI' or AKFIRM = 'SCH'));

       //1a) Trend geht nur bis zum verpacken
       exec sql
        update  out_check set WORKDAYS =
        (days (date(substr(AKDTE , 1, 4)
        concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
        substr(AKDTE , 7, 2)))
        -
        (days( date(substr(AKDTDF, 1, 4) concat
        '-' concat substr(AKDTDF, 5, 2) concat '-' concat substr(AKDTDF, 7,
         2)))))  where
        (days (date(substr(AKDTE , 1, 4)
        concat '-' concat substr(AKDTE , 5, 2) concat '-' concat
        substr(AKDTE , 7, 2)))
        -
        (days( date(substr(AKDTDF, 1, 4) concat
        '-' concat substr(AKDTDF, 5, 2) concat '-' concat substr(AKDTDF, 7,
         2)))))  <> workdays;


       //2) Zusammenführungen feststellen
       exec sql
        insert into tvrelwaeco/out_join
        SELECT apapn2, APANR1 , count(*)
        FROM out_check WHERE APAPN2 <> 0
        GROUP BY apapn2, APANR1;


       //3) Zusammenführungen feststellen
       exec sql
        update tvrelwaeco/out_check a set a.joining=
        (select count(*) from tvrelwaeco/out_join b
         where a.apapn2 = b.apapn2)
        where exists
        (select count(*) from tvrelwaeco/out_join b
         where a.apapn2 = b.apapn2);

       //....
          open OUT_CHECK;

          read OUT_CHECK OUT_CHECK_i;
          dow not %eof(OUT_CHECK);
             OUT_CHECK_o  = OUT_CHECK_i;
             if  out_check_i.APANR1 =      'K012016318654';
                 out_check_i.APANR1 =      'K012016318654';
             endif;
       //psaveak2
       //    psaveak2_k.AKKONZ = 'EMS';
       //    psaveak2_k.AKFIRM = 'DWI';
       //    psaveak2_k.AKAPN  =  out_check_i.APapn;
       //    chain %kds(psaveak2_k:3) psaveak2   psaveak2_I;
       //    if %found(psaveak2);
       //       out_check_o.AKDTDF = psaveak2_i.AKDTDF;
       //       out_check_o.AKTIDF = psaveak2_i.AKTIDF;
       //       out_check_o.AKDTE  = psaveak2_i.AKDTE ;
       //       out_check_o.AKTIE  = psaveak2_i.AKTIE ;
       //    endif;
       //Afkm01
             AfKm01_k.AMFIRM = %subst(out_check_i.APANR1:02:02);
             AfKm01_k.AMKMJJ = %dec(%subst(out_check_i.APANR1:04:04):4:0);
             AfKm01_k.AMKMNR = %subst(out_check_i.APANR1:08:06);
             chain %kds(AfKm01_k:3) AfKm01 AfKm01_I;
             if %found(AfKm01);
                out_check_o.AMKMDA   = afkm01_i.AMKMDA;
                out_check_o.amkdnr   = afkm01_i.amkdnr;
                out_check_o.amafat   = afkm01_i.amafat;
                out_check_o.amvsbd   = afkm01_i.amvsbd;
                out_check_o.AMLFTE   = afkm01_i.AMLFTE;
                out_check_o.amlibd   = afkm01_i.amlibd;
                out_check_o.amliar   = afkm01_i.amliar;
                out_check_o.AMNAM1   = afkm01_i.AMNAM1;
                out_check_o.AMNAM2   = afkm01_i.AMNAM2;
                out_check_o.AMNAM3   = afkm01_i.AMNAM3;
                out_check_o.AMSTRA   = afkm01_i.AMSTRA;
                out_check_o.AMPOLD   = afkm01_i.AMPOLD;
                out_check_o.AMPOLZ   = afkm01_i.AMPOLZ;
                out_check_o.AMWORT   = afkm01_i.AMWORT;
                out_check_o.AMPOFA   = afkm01_i.AMPOFA;
                out_check_o.AMLAND   = afkm01_i.AMLAND;
                out_check_o.AMPOLN   = afkm01_i.AMPOLN;
             endif;
       //LbAp01
             LbAp01_k.LbApFirm = %subst(out_check_i.APANR1:02:02);
             LbAp01_k.LbApDana = 'AFKM ';
             LbAp01_k.LbApJahr = %dec(%subst(out_check_i.APANR1:04:04):4:0);
             LbAp01_k.LbApNmkr = %subst(out_check_i.APANR1:08:06);
             LbAp01_k.LbApPosi = out_check_i.APANRP;
             chain %kds(LbAp01_k:5) LbAp01    LbAp01_I;
             if %found(LbAp01);
                out_check_o.LBAPFIRM = lbap01_i.LBAPFIRM;
                out_check_o.LBAPKMJJ = lbap01_i.LBAPKMJJ;
                out_check_o.LBAPKMNR = lbap01_i.LBAPKMNR;
                out_check_o.LBAPKMPO = lbap01_i.LBAPKMPO;
                out_check_o.LBAPAFJJ = lbap01_i.LBAPAFJJ;
                out_check_o.LBAPAFNR = lbap01_i.LBAPAFNR;
                out_check_o.LBAPAFPO = lbap01_i.LBAPAFPO;
                out_check_o.LBAPTENR = lbap01_i.LBAPTENR;
                out_check_o.LBAPTMST = lbap01_i.LBAPTMST;
                out_check_o.LBAPBWMG = lbap01_i.LBAPBWMG;
                out_check_o.LBAPRMMG = lbap01_i.LBAPRMMG;
                out_check_o.LBAPTMST = lbap01_i.LBAPTMST;
                //Afpo01                                       ffff
                Afpo01_k.apFIRM = %subst(out_check_i.APANR1:02:02);
                Afpo01_k.APAFJJ = lbap01_i.LBAPAFJJ;
                Afpo01_k.APAFNR = lbap01_i.LBAPAFNR;
                Afpo01_k.APAFPO = lbap01_i.LBAPAFPO;
                chain %kds(Afpo01_k:4) Afpo01 Afpo01_I;
                if %found(Afpo01);
                   out_check_o.AMLFTE   = afpo01_i.APLFTE;
                endif;
                if out_check_i.apbstm <> out_check_i.APRESM;
                   out_check_o.statuslfs = '1';
                endif;
                if out_check_i.APBSTM <> out_check_i.APALM;
                   out_check_o.statuslfs = '2';
                endif;
                if out_check_i.APBSTM =  out_check_i.APALM;
                   out_check_o.statuslfs = ' ';
                endif;
                out_check_o.statustr = '1';
             //update
                update PHY01R    out_check_o;
                clear            out_check_o;
             else;
                if out_check_i.APBSTM <> out_check_i.APALM;
                   out_check_o.statuslfs = '2';
                endif;
                if out_check_i.apbstm <> out_check_i.APRESM;
                   out_check_o.statuslfs = '1';
                endif;
                if out_check_i.apbstm <> out_check_i.APALM  and
                   out_check_i.apbstm <> out_check_i.APRESM;
                   out_check_o.statuslfs = '3';
                endif;
                if out_check_i.APBSTM =  out_check_i.APALM;
                   out_check_o.statuslfs = ' ';
                endif;
                out_check_o.statustr = '0';
                update PHY01R    out_check_o;
                clear            out_check_o;
             endif;
             read OUT_CHECK OUT_CHECK_i;
          enddo;

          close out_check;

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

         eval p_infil   =  'OUT_CHECK' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'OUT_CHECK';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/OUT_CHECK*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed OUT_CHECK*              ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object OUT_CHECK*                 ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'OUT_CHECK';

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
          status='Error by CVTDBF object OUT_CHECK                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'OUT_CHECK';

       /////////////////////////////////////////////exsr  SR_we2;

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/OUT_CHECK)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/OUT_CHECK)    ';
       endmon;



       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''OUT_CHECK'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'OUT_CHECK';

       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
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

         eval p_infil   =  'OUT_CHECK_1' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'OUT_CHECK_1';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/OUT_CHECK_1*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed OUT_CHECK_1*            ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object OUT_CHECK_1*               ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'OUT_CHECK_1';

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
          status='Error by CVTDBF object OUT_CHECK_1                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'OUT_CHECK_1';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/AVAILABLE)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/AVAILABLE)    ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'OUT_CHECK  ';
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


