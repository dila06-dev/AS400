
      //************************************************************************
      //
      //      Programmname       AVAILABLER
      //      Erstellt  am       30.06.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       ...
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //   SELECT APANR1,APANRP,APIDEN FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
      //    WHERE AKFIRM ='DWI' and AKAPN = APAPN and AKTIDF > 0 and APRESM <>
      //    0 and date(date (date(substr(AKDTDF, 1, 4) concat '-' concat
      //    substr(AKDTDF, 5, 2) concat '-' concat substr(AKDTDF, 7, 2)))) =
      //    current date - 000 day and substr(apanr1, 1, 2) ='K0' and APIDEN
      //    <>'ENDE'                       !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      // Eingansdatum und Zeit
      // Verarbeitungsdatum und Zeit (damit wure auch eine Rechnung erstellt
      //
      //
      // Status 3= alle in LFS verarbeiteten Positionen, die nicht mit dem KomDatum ( jeweils aktuelles Datum um
      // 23:00:00)
      // übereinstimmen, also Altlasten
      //
      // Status 2= sind Sätze, die verarbeitet worden sind und üblicherweise mit dem selben KomTermin (Prüfung gegen
      // aktuelle Datei
      // wir sind am 16. angefangen und haben nur Sätze übernommen, die nicht grösser Status 50 sind!!!!!!!!!!!!!)
      //
      // Status= *blank, Sätze mit Übergabe Status der Position nicht größer als 50
      //
      // und wo stehen Sätze, wo der Kom-Termin im nachherein geändert worden ist und nicht erfasst worden ist?
      // ==> in Status 3 werden solche Sätze abgelegt, da hier eine Prüfung losgelöst vom KomTermin stattfindet mit
      // den LFS Daten
      // geprüft wird, welche Sätze sind verarbeitet worden ohne Bezug zur aktuellen Datei auf Basis des
      // Verarbeitungsdatums! Z.B. freigegebene Kom_Sperren
      //
      // SELECT LBAPAFJJ, LBAPAFNR, LBAPAFPO , LBAPBWMG FROM ifbl, lbap
      // WHERE (IFBLDANA ='AFKM' and date(IFBLTSTP)= current date -1 day and
      // LBAPDANA ='AFKM' and IFBLjahr=LBAPjahr and IFBLNMKR=LBAPNMKR and
      // IFBLFIRM=LBAPFIRM and LBAPFIRM ='01' and IFBL.IFBLSTAT ='90') and
      // LBAPAFJJ not in (select apafjj from available where LBAPAFNR=apafnr
      // and lbapafpo=apafpo and date(tstamp)= current date - 1 day)
      // Datei MAI201702 in TVRELWAECO wurde erstellt.
      //
      // SELECT APAFJJ, APAFNR, APAFPO,AKKOSP,APTENR,APKMTE,
      // aplfte,APRSDA, APBSMG, AKEIDA, AKEIUZ, AKAFAT,
      // decimal(0, 08, 0) available,  decimal(0, 08, 0) lfsInput,
      // decimal(0, 03, 0) lfr,  decimal(0, 11, 2) UFR,decimal(0, 03, 0) OFR,
      // decimal(0, 03, 0) lfrpr,
      // decimal(0, 03, 0) UFRpr,decimal(0, 03, 0) OFRpr,
      // decimal(week(current date), 2) week#, decimal(0, 03, 0) lfrprweek,
      // decimal(0, 03, 0) UFRprweek, decimal(0, 03, 0) OFRprweek,
      // decimal(month(current date), 2) month#, decimal(0, 03, 0)
      // lfrprmonth,
      // decimal(0, 03, 0) UFRprmonth,decimal(0, 03, 0) OFRprmonth,
      // APKURS, APNESU , zoned((apnesu*apkurs), 13, 2) apnesueur,
      // zoned(0, 8, 0) dateinp, zoned(0, 6, 0) timeinp,
      // zoned(0, 8, 0) dateout, zoned(0, 6, 0) timeout,char(' ', 2) status,
      // current timestamp tstamp   FROM afpo, afko
      // where APFIRM ='01'                 and apfirm= akfirm
      // and apafjj=akafjj  and apafnr=akafnr and
      // apafjj in ( select LBAPAFJJ from mai201702 where
      //   LBAPAFNR=apafnr and  lbapafpo=apafpo)
      // Datei MAI201702# in TVRELWAECO wurde erstellt.
      //
      //log auslesen
      // SELECT * FROM job_run WHERE JOBDESC like '%BARTRR3%'
      //
      //                           rp1
      // Referenzsatz
      //
      //Daten auslagern 11.10.2019
      //
      // 11.10.2019 sicherung in #AVAILABLE
      // SELECT * FROM AVAILABLE WHERE APKMTE < 20180000
      // ORDER BY apkmte
      // Datei #AVAILABLE in TVRELWAECO wurde erstellt.
      //
      // und löschen aus original
      // delete   FROM AVAILABLE WHERE APKMTE < 20180000
      // 302151 Zeilen aus AVAILABLE in TVRELWAECO gelöscht.
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

     favailablelif a e           k DISK    RENAME(AVAILABLE:PHY01R)
     f                                     USROPN

     fout_check if   e             DISK    RENAME(out_check:PHY02R)
     f                                     USROPN

     fafpo01    if   e           k disk

     fafko01    if   e           k disk

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
       // define files
       // ______________________________________________________________________
     d availablel_k  E DS                  ExtName(availablel:*key)
     d                                     Qualified
     d availablel_i  E DS                  ExtName(availablel:*input)
     d                                     Qualified
     d availablel_o  E DS                  ExtName(availablel:*output)
     d                                     Qualified

     d out_check_i   E DS                  ExtName(out_check:*input)
     d                                     Qualified

     d afpo01_k      E DS                  ExtName(afpo01:*key)
     d                                     Qualified
     d afpo01_I      E DS                  ExtName(afpo01:*input)
     d                                     Qualified
     d afko01_k      E DS                  ExtName(afko01:*key)
     d                                     Qualified
     d afko01_I      E DS                  ExtName(afko01:*input)
     d                                     Qualified
       //           ... Grunddaten
       // ______________________________________________________________________
       // Sicherung PBESTLO_R
       // ______________________________________________________________________
       // AVAILABLER      PR                  ExtPgm('AVAILABLER')
       // ______________________________________________________________________
       // define data areas
       // ______________________________________________________________________
     D #swapc          s             08a   dtaara
     D JOB_R_run       s             01a   dtaara

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
     D §records2       s              9s 0 inz
     D §quantity1      s             13s 3 inz
     D §quantity2      s             13s 3 inz
     D §summen         s             13s 2 inz
     D §summen2        s             13s 2 inz
     D §calc           s              6s 3 inz
     D ##week          s              2s 0 inz
     D ##month         s              2s 0 inz

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
     D #error          s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz
     D #run            s              1a   inz
     D #dirmail        s              1a   inz
     D checkd          s              8s 0 inz
     D checkx          s              8s 0 inz
     D p               s             15p 0

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d NumSysTime      s              6s 0
     d myDate          s               d
     d tomorrow        s               d
     d twechsel        s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d tommonths       s              2s 0
     d eofyear         s              8s 0
     d nowdate         s              8s 0
     Dweek             s              1s 0
     DGoodDateV        S              1a
     DGoodDateB        S              1a
     Derror1           s              1a   inz
     Derror2           s              1a   inz
     Derror3           s              1a   inz
     Derror4           s              1a   inz
     Derror5           s              1a   inz
     Dpstamp           s               z   inz
     D#ERRORS          s             60a
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     D p_inFIL         s             24a
     D z§§week         s              2s 0

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §pstamp         s               z   inz

      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________
     IPHY01R
     I              status                      §status

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE

       §records=*zero;
       §summen =*zero;

       eval status ='Start AVAILABLER              ' ;
       exsr      SR_log;

       §pstamp = %timestamp;
       //    exsr  srmonth;
       //    exsr  srmonth;
       //    exsr  srweek;
       //    exsr  srweek;
       //    exsr  srweek;
       //    exsr  srweek;
       //
       //     pstamp= %timestamp('2017-04-13-23.01.10.905000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-14-23.01.59.088000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-15-23.00.51.044000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-17-23.00.49.042000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-18-23.01.26.154000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-19-23.01.09.859000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-20-23.01.13.135000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-21-23.02.39.620000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-24-23.01.08.199000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-25-23.01.06.736000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-26-23.01.13.690000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-27-23.04.24.189000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-04-28-23.05.46.138000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-05-01-23.03.34.055000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-05-02-23.06.39.414000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-05-03-23.06.42.917000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-05-04-23.05.37.966000');
       //                      exsr  srday;
       //     pstamp= %timestamp('2017-05-05-23.01.49.527000');
       //                      exsr  srday;
       exsr  sr_availab;
       exsr  SR_output;
       err_msg   = '0';

       if §records <> *zero;
       endif;

       // ______________________________________________________________________


       eval status ='Ende  AVAILABLER              ';

       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //
       //    %dec(Datum:*iso) => JJJJMMTT
       //    %dec(Datum:*eur) => TTMMJJJJ
       //    %dec(Datum:*jul) => JJJJTTT
       //-----------------------------------------------------------------------

       begsr srinit;

       //liblist

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(xxxxxxxxxx/available)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
          exsr      SR_log;
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed2)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;


       //*************************************************************************************************************
       err_msg     = '1';
       NumSysTime = %Dec(%Time(): *ISO);
       //  If MyNumTime = NumSysTime;
       //  //2. Convert numeric Time (HHMMSS) into a real time
       //  RealTime = %Time(MyNumTime: *ISO);
       //  If RealTime = %Time();

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       tomorrow  = %date() +  %days(01);
       twechsel  = %date() +  %days(01);
       tommonths = %subdt( %date() + %days(01): *months );

       §records=*zero;

       exec sql
         select  dec(DAYOFWEEK_iso(current date ), 1, 0)
                 into            :week
                 from   qsys2/qsqptabl;

       exec sql
         select  dec(WEEK_iso(current date ), 2, 0)
                 into            :z§§week
                 from   qsys2/qsqptabl;

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       // C**************************************************************************
       // C*vorher Stücklistenkalkulation
       // C*-------------------------------------------------------------------------

       begsr sr_availab;

       status=*blank;

       // callP STR_STUECK();

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/out_check2)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/out_check2)    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/out_check2)   ';
       endmon;

        exec sql
           insert into  TVRELWAECO/out_check2
           SELECT distinct
                  AKDTDF, AKTIDF, AKDTE, AKTIE, WORKDAYS, EDATUM, EWOCHE,
           EJAHR, EWOCHENT, APDTB, APTIB, DELIVDAYS, APAPN1, APAPP1, APAPN2,
           APGKZ, APTOUR, APVART, APSSC, APLFDN, APBSTM, APAPN, APANFM,
           APAPPO, APRESM, APALM, APPM1, APKDNR, APLSNR, APLSNP, APANR1,
           APANRP, APIDEN, APDTDI, APTIDI, JOINING, LBAPFIRM, LBAPKMJJ,
           LBAPKMNR, LBAPKMPO, LBAPAFJJ, LBAPAFNR, LBAPAFPO, LBAPTENR,
           LBAPBWMG, LBAPRMMG, LBAPTMST, AMKMDA, AMKDNR, AMAFAT, AMVSBD,
           AMLFTE, AMLIBD, AMLIAR, STATUSLFS, STATUSTR, AMNAM1, AMNAM2,
           AMNAM3, AMSTRA, AMPOLD, AMPOLZ, AMWORT, AMPOFA, AMLAND, AMPOLN,
           TSTAMP APANR1, LBAPAFJJ, LBAPAFNR, LBAPAFPO, LBAPFIRM, LBAPKMJJ,
           LBAPKMNR, LBAPKMPO, dec((eldtj concat eldtm concat eldtt), 8, 0)
           out_date, dec(eltim, 6, 0) out_time, LSNR, LRENR, DSK01, DSK02,
           DSK05, FAUNR, FRF ,VSRHF ,PKAVS, trknr, PKASN,fvsgw,SNNGW,SNVLM,
           VSBLG,VSBBR,VSBHO,VSBVO,KFVSA,GATE,VSBKZ, char(' ', 1) x
                                           FROM out_check, VLF95DWE/frdtn
           WHERE apanr1=substr(VSRHF, 1, 13) and eldtj <> ' ' and eldtm <>' ';



        exec sql
           insert into  TVRELWAECO/out_check2
           SELECT distinct
                  AKDTDF, AKTIDF, AKDTE, AKTIE, WORKDAYS, EDATUM, EWOCHE,
           EJAHR, EWOCHENT, APDTB, APTIB, DELIVDAYS, APAPN1, APAPP1, APAPN2,
           APGKZ, APTOUR, APVART, APSSC, APLFDN, APBSTM, APAPN, APANFM,
           APAPPO, APRESM, APALM, APPM1, APKDNR, APLSNR, APLSNP, APANR1,
           APANRP, APIDEN, APDTDI, APTIDI, JOINING, LBAPFIRM, LBAPKMJJ,
           LBAPKMNR, LBAPKMPO, LBAPAFJJ, LBAPAFNR, LBAPAFPO, LBAPTENR,
           LBAPBWMG, LBAPRMMG, LBAPTMST, AMKMDA, AMKDNR, AMAFAT, AMVSBD,
           AMLFTE, AMLIBD, AMLIAR, STATUSLFS, STATUSTR, AMNAM1, AMNAM2,
           AMNAM3, AMSTRA, AMPOLD, AMPOLZ, AMWORT, AMPOFA, AMLAND, AMPOLN,
           TSTAMP APANR1, LBAPAFJJ, LBAPAFNR, LBAPAFPO, LBAPFIRM, LBAPKMJJ,
           LBAPKMNR, LBAPKMPO, dec((eldtj concat eldtm concat eldtt), 8, 0)
           out_date, dec(eltim, 6, 0) out_time,a.LSNR,a.LRENR,a.DSK01, a.DSK02,
           a.DSK05, a.FAUNR, FRF ,VSRHF ,PKAVS, trknr, PKASN,fvsgw,SNNGW,SNVLM,
           VSBLG,VSBBR,VSBHO,VSBVO,KFVSA,GATE,VSBKZ, char('b', 1) x

           FROM out_check, VLF95DWE/frdtn a, VLF95DWE/frdtp b
           WHERE apanr1=substr(bcd, 1, 13)   and eldtj <> ' ' and eldtm <>' '
           and eldtt<>' ' and eltim<>' ' and
           a.dsk01 <> '    ' and a.dsk05 <> '    '   and
           a.FIR = b.FIR and a.BTNR = b.btnr and a.elj = b.elj
           and a.VSNR = b.VSNR and a.VSPN = b.VSPN and pkpn<>'000001';

       if %char(pstamp) < '2018-01-01-00.00.00.000001';
       //Aufbau, bis zur Kommissionierung, aber ohne Lieferschein
        exec sql
           insert into tvrelwaeco/AVAILABLE
           SELECT APAFJJ, APAFNR, APAFPO,AKKOSP,APTENR,' ',APKMTE,
           aplfte,APRSDA, APBSMG, AKEIDA, AKEIUZ, AKAFAT,
           decimal(0, 08, 0) available,  decimal(0, 08, 0) lfsInput,
           decimal(0, 03, 0) lfr,  decimal(0, 11, 2) UFR,decimal(0, 03, 0) OFR,
           decimal(0, 03, 0) lfrpr,
           decimal(0, 03, 0) UFRpr,decimal(0, 03, 0) OFRpr,
           decimal(0, 03, 0) lfrpr_,
           decimal(0, 03, 0) UFRpr_,decimal(0, 03, 0) OFRpr_,
           decimal(week(current date), 2) week#, decimal(0, 03, 0) lfrprweek,
           decimal(0, 03, 0) UFRprweek, decimal(0, 03, 0) OFRprweek,
           decimal(0, 03, 0) lfrprweek_,
           decimal(0, 03, 0) UFRprweek_, decimal(0, 03, 0) OFRprweek_,
           decimal(month(current date), 2) month#, decimal(0, 03, 0) lfrprmonth,
           decimal(0, 03, 0) UFRprmonth,decimal(0, 03, 0) OFRprmonth,
           decimal(0, 03, 0) lfrprmont_,
           decimal(0, 03, 0) UFRprmont_,decimal(0, 03, 0) OFRprmont_,
           APKURS, APNESU , zoned((apnesu*apkurs), 13, 2) apnesueur, 0,0  ,
           akkdnr, ' ', ' ', ' ', ' ', ' ', ' ',
           zoned(0, 8, 0) dateinp, zoned(0, 6, 0) timeinp,
           zoned(0, 8, 0) dateout, zoned(0, 6, 0) timeout,char(' ', 2) status,
           ' ',   :§pstamp tstamp,char(' ', 4) #TEPRGR, decimal(0, 08, 0)
           out_date, decimal(0, 06, 0) out_time,zoned(0, 7, 0)
           FROM afpo, afko
       //  where APFIRM ='01' and APAFST < 50 and apfirm= akfirm
           where APAFJJ > 2021 and
                 APFIRM ='01' and APAFST < 91 and apfirm= akfirm
           and apafjj=akafjj  and apafnr=akafnr and
           date(date (date(substr(APKMTE, 1, 4)
           concat '-' concat substr(APKMTE, 5, 2) concat '-' concat
           substr(APKMTE, 7, 2)))) = current date - 00 day ;

       //  and apafjj=akafjj  and apafnr=akafnr and  (
       //  date(date (date(substr(APKMTE, 1, 4)
       //  concat '-' concat substr(APKMTE, 5, 2) concat '-' concat
       //  substr(APKMTE, 7, 2)))) > current date - 34 day   and
       //  date(date (date(substr(APKMTE, 1, 4)
       //  concat '-' concat substr(APKMTE, 5, 2) concat '-' concat
       //  substr(APKMTE, 7, 2)))) < current date - 00 day);


       //and apafjj=akafjj  and apafnr=akafnr and  (
       //date(date (date(substr(APKMTE, 1, 4)
       //concat '-' concat substr(APKMTE, 5, 2) concat '-' concat
       //substr(APKMTE, 7, 2)))) > current date - 27 day   and
       //date(date (date(substr(APKMTE, 1, 4)
       //concat '-' concat substr(APKMTE, 5, 2) concat '-' concat
       //substr(APKMTE, 7, 2)))) < current date - 01 day);

       //Erweiterung
       //Übernahme aller Sätze, die an dem definierten Tag nach LFS
       //übergeben wurden. Diese Sätze erhalten einen Status '2'.
       //Sind Sätze schon übergeben worden, erhalten sie den Status '3'.

       //  where APFIRM ='01' and APAFST < 50 and apfirm= akfirm
       //  ==>>>>>>>>>>>>>>>>>>> exsr SRlfsinput;

       //update aktueller Bestand
        exec sql
           update TVRELWAECO/AVAILABLE set available =
           (select bestand from abestand where tetenr=aptenr and lager='001'
            and tstamp > current timestamp -1 hour)
           where exists
           (select bestand from abestand where tetenr=aptenr and lager='001'
            and tstamp > current timestamp -1 hour);

       //update aktuelle Übergabe aus LFS
        exec sql
           update TVRELWAECO/AVAILABLE set lfsinput  =
           (select sum(LBAPBWMG) from lbap where LBAPDANA ='AFKM' and
            LBAPAFJJ= apAFJJ and  LBAPAFNR= apAFNR and LBAPAFPO= apAFPO
            and LBAPFIRM ='01' and (tstamp > current timestamp -1 hour
            or tstamp =:pstamp ) group by LBAPAFJJ,LBAPAFNR, lbapAFNR)
            where exists
           (select sum(LBAPBWMG) from lbap where LBAPDANA ='AFKM' and
            LBAPAFJJ= apAFJJ and  LBAPAFNR= apAFNR and LBAPAFPO= apAFPO
            and LBAPFIRM ='01' and (tstamp > current timestamp -1 hour
            or tstamp =:pstamp ) group by LBAPAFJJ,LBAPAFNR, lbapAFNR);

       //update OFR_VALUE
        exec sql
           update TVRELWAECO/AVAILABLE set OFR_VALUE =
           (APNESUEUR/APBSMG*LFSINPUT) where APBSMG <> 0 and
           (tstamp > current timestamp -1 hour or tstamp =:pstamp );

       //AKKOSP bereinigen bei einigen Auträgen, wo durch den
       //Kundenstammeintrag eine AKKOSP ausgehebelt wird
        exec sql
           update TVRELWAECO/AVAILABLE set AKKOSP    = ' ' where apafjj
           in ( select LBAPAFJJ from lbap where LBAPDANA ='AFKM' and
            LBAPAFJJ= apAFJJ and  LBAPAFNR= apAFNR and LBAPAFPO= apAFPO
            and LBAPFIRM ='01') and (tstamp > current timestamp -1 hour
            or tstamp =:pstamp) and akkosp ='J ';

       //update Bestellmenge = LFS Menge
       //Achtung Fixierung auf date und time !!!!!!!!!!!!!!!!!
        exec sql
           update available set lfr = 1 where LFSINPUT= APBSMG;

       endif;

       //update Gleichheit Lieferantenbezeichnung
       exec sql
          update  tvrelwaeco/available  set AKKDNRDES =
          (select KDNAM1 from kund01 where
                        kdfirm='01' and  akkdnr=kdkdnr)
          where exists
          (select KDNAM1 from kund01 where
                        kdfirm='01' and  akkdnr=kdkdnr);

       //update Gleichheit Artikelbezeichnung
       exec sql
          update  tvrelwaeco/available  a set a.APTBZ1  =
          (select b.teTBZ1 from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr)
          where exists
          (select b.teTBZ1 from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr);

       exec sql
          Update available set APTBZ1= Replace(APTBZ1, ';', ' ')
          where APTBZ1 like '%;%';

       exec sql
          Update available set APTBZ1= Replace(APTBZ1, ',', ' ')
          where APTBZ1 like '%,%';

       exec sql
          Update available set APTBZ1= Replace(APTBZ1, '"', ' ')
          where APTBZ1 like '%"%';

       exec sql
          Update available set APTBZ1= Replace(APTBZ1, '`', ' ')
          where APTBZ1 like '%`%';

       exec sql
          Update available set APTBZ1= Replace( LIEFERDES, ';', ' ')
          where LIEFERDES like '%;%';

       exec sql
          Update available set APTBZ1= Replace( LIEFERDES, ',', ' ')
          where LIEFERDES like '%,%';

       exec sql
          Update available set APTBZ1= Replace( LIEFERDES, '"', ' ')
          where LIEFERDES like '%"%';

       exec sql
          Update available set APTBZ1= Replace( LIEFERDES, '`', ' ')
          where LIEFERDES like '%`%';


       //update Gleichheit Disponent
       exec sql
          update TVRELWAECO/available  set DISPO     =
          (select TEDIEK  from teil01 where tefirm='01' and tetenr=aptenr)
          where exists
          (select TEDIEK  from teil01 where tefirm='01' and tetenr=aptenr);

       //update Gleichheit Einkäufer
       exec sql
          update TVRELWAECO/available  set EINK      =
          (select TESAEK  from teil01 where tefirm='01' and tetenr=aptenr)
          where exists
          (select TESAEK  from teil01 where tefirm='01' and tetenr=aptenr);

       //update Gleichheit Division
       exec sql
          update TVRELWAECO/available  set division  =
          (select KDEWKSST from kdew01 where kdewfirm='01' and kdewkdnr=AKKDNR)
          where exists
          (select KDEWKSST from kdew01 where kdewfirm='01' and kdewkdnr=AKKDNR);

       //update Gleichheit Division
       exec sql
          update TVRELWAECO/available  set division  = case
          When division = '1001      ' then 'RVOEM     '
          When division = '1002      ' then 'RVAM      '
          When division = '1003      ' then 'RETL      '
          When division = '1004      ' then 'LODG      '
          When division = '1005      ' then 'CPVOEM    '
          When division = '1006      ' then 'CPVAM     '
          When division = '1007      ' then 'MAOEM     '
          When division = '1008      ' then 'MAAM      '
          When division = '1009      ' then 'MEDI      '
          When division = '1015      ' then 'GROUP     '
          When division = '1020      ' then 'OTHER 1020'
          When division = '6050      ' then 'OTHER 6050'
          else 'undefined'
          end;

       //update Gleichheit Lieferant
       exec sql
          update  tvrelwaeco/available  a set a.LIEFER    =
          (select b.TESTLF from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr)
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr);

       //update Gleichheit Lieferant
       exec sql
          update TVRELWAECO/available  a set a.LIEFERDES =
          (select lfnam1 from lief01 where LFFIRM='01' and LFLFNR=LIEFER)
           where exists
          (select lfnam1 from lief01 where LFFIRM='01' and LFLFNR=LIEFER);


       //gültige haben Kennung byton='1'
       exec sql
          update available set byteon = '1'
          where (tstamp > current timestamp -1 hour or tstamp =:pstamp )
                and AKKOSP<>'J'  and
                (status='  ' or status = '2 ' or status ='4 ') and
                AKAFAT not in ( '03 ', '10 ', '14 ', '15 ', '17 ', '18 ',
                                '20 ', '70 ', '71 ', '84 ', '85 ') and
                LIEFER not in ( '90052', '90830');

       //gültige haben Kennung byton='1' Gruppenausschluß
       exec sql
          update available set byteon = ' '
          where (tstamp > current timestamp -1 hour or tstamp =:pstamp )
                and byteon= '1'
                and APTENR in (select tetenr from TEIL01 where tefirm='01'
                           and TEPRGR > '900');

       //day  calculation    ----------------------------------------
       exsr srday;
       //week calculation    ----------------------------------------
       exsr srweek;
       //month calculation  -----------------------------------------
       exsr srmonth;


       //====> Datum reale Übergabe in LFS
       exec sql
          update tvrelwaeco/available set dateinp =
          (select max(AKDTdF) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(AKDTdF) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);


       //====> Time reale Übergabe in LFS
       exec sql
          update tvrelwaeco/available set TIMEINP =
          (select max(AKTIDF) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(AKTIDF) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);


       //====> Datum reale Fertigstellung in lfs
       exec sql
          update tvrelwaeco/available set dateout =
          (select max(AKDTE) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(AKDTE) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);


       //====> Zeit  reale Fertigstellung in lfs
       exec sql
          update tvrelwaeco/available set TIMEout =
          (select max(AKTIE) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(AKTIE) From out_check where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);

       //====> Date  reale Fertigstellung aus Rhenania
       exec sql
          update tvrelwaeco/available a set a.OUT_DATE=
          (select max(b.OUT_DATE) From out_check2 b where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(b.OUT_DATE) From out_check2 b where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);

       //====> Time  reale Fertigstellung aus Rhenania
       exec sql
          update tvrelwaeco/available a set a.OUT_time=
          (select max(b.OUT_time) From out_check2 b where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO)
          where exists
          (select max(b.OUT_time) From out_check2 b where LBAPAFJJ=APAFJJ and
                  LBAPAFNR=APAFNR and LBAPAFPO=APAFPO
           group by LBAPAFJJ,LBAPAFNR, LBAPAFPO);

       //update TEPRGR Dometic Gruppe
       exec sql
          update  tvrelwaeco/available  a set a.#TEPRGR    =
          (select b.TEPRGR from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr)
          where exists
          (select b.TEPRGR from teil01 b where
                  tefirm='01' and a.aptenr=b.tetenr);

       exec sql
        whenever not found continue;
       exec sql
        WHENEVER SQLWARNING CONTINUE;
       exec sql
        WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //day   calculation
       //-----------------------------------------------------------------------

       begsr SRday;

       //alle Auftragsköpfe ohne Belieferung
       exec sql
          CREATE TABLE qtemp/intermed
          (APAFNR    CHAR(16) CCSID 273,
          lfr       decimal(03, 2),
          #sum       decimal(13, 2));
       exec sql
          delete from qtemp/intermed;
       exec sql
          insert into intermed
          SELECT APAFNR, LFR, sum(APNESUEUR)
          FROM AVAILABLE where (tstamp > current timestamp -1 hour
                               or tstamp =:pstamp )
          and (byteon='1') and lfr=0  GROUP BY APAFNR, LFR;
       exec sql
          update available a set ofr = 1 where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp =:pstamp )
          and a.apafnr not in (select b.apafnr from intermed b);

       exec sql
          CREATE TABLE qtemp/intermed2
          (APAFNR    CHAR(16) CCSID 273,
           #sum       decimal(13, 2));
       exec sql
          delete from qtemp/intermed2;
       //update alle Auftragsköpfe einlesen
       exec sql
        insert into qtemp/intermed2
           SELECT APAFNR, sum(APNESUEUR) FROM available where (byteon='1')
           and     (tstamp > current timestamp -1 hour
                    or tstamp=:pstamp)              GROUP BY APAFNR;
       //und ermitteln als Zahl für §records
       §records=*zero;
       exec sql
          select count(*) into :§records
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM  qtemp/intermed;
       §calc =((§records-§records2)*100/§records) +0,5;
       exec sql
          update available a set ofrpr = :§calc where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);

       §QUANTITY1 = 0;
       §QUANTITY2 = 0;
       //und ermitteln als Zahl für §records   week  *UMSATZ
       §records=*zero;
       exec sql
          select sum(#sum) into :§QUANTITY1
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste *UMSATZ
       §QUANTITY2 = 0;
       exec sql
          SELECT sum(APNESUEUR) into :§QUANTITY2  FROM available a
          WHERE a.apafnr in (select b.apafnr from qtemp/intermed b)
                                  and (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §calc =((§QUANTITY1-§QUANTITY2)*100/§QUANTITY1)+0,5;
       exec sql
          update available a set ofrpr_    = :§calc where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);





       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs
       //teillieferungen/Überlieferungen
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG )
          and (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §records=*zero;
       exec sql
          select count(*) into :§records
          FROM available where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §calc =(§records2*100/§records)+0,5;
       exec sql
        update available a set lfrpr = :§calc where (byteon='1')
        and (tstamp > current timestamp -1 hour or tstamp=:pstamp);

       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs Umsatz
       §quantity2=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG) and
          byteon='1'
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §quantity1=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §calc =(§records2*100/§records)+0,5;
       exec sql
        update available a set lfrpr_    = :§calc where (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);


       //Berechnung der UFR auf Basis der "belieferten Mengen"
       exec sql
          select sum(lfsinput) into :§quantity1
          FROM available WHERE (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       exec sql
          select sum(APBSMG)   into :§quantity2
          FROM available WHERE (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
        update available a set ufrpr = :§calc where (byteon='1')
        and (tstamp > current timestamp -1 hour or tstamp=:pstamp);

       //Berechnung der UFR auf Basis der "belieferten Umsatz"
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available WHERE (byteon='1') and lfr='1'
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available WHERE (byteon='1')
          and (tstamp > current timestamp -1 hour or tstamp=:pstamp);
       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
        update available a set ufrpr_ = :§calc where (byteon='1')
        and (tstamp > current timestamp -1 hour or tstamp=:pstamp);

       endsr;

       //-----------------------------------------------------------------------
       //week  calculation
       //-----------------------------------------------------------------------

       begsr SRweek;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed2)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;

       if %char(pstamp) < '2017-01-01-00.00.00.000001';
          exec sql
             select  week(current timestamp - 1 hour)
                  into :##week
                  from TVRELWAECO/available ;
       else;
          exec sql
             select  week(:pstamp)
                  into :##week
                  from TVRELWAECO/available ;
       endif;

       //alle Auftragsköpfe ohne Belieferung  WEEK
       exec sql
          CREATE TABLE qtemp/intermed
          (APAFNR    CHAR(16) CCSID 273,
          lfr       decimal(03, 2),
          #sum       decimal(13, 2));
       exec sql
          delete from qtemp/intermed;
       exec sql
       //negativliste da lfr=0 !!!!!!
          insert into intermed
          SELECT APAFNR, LFR, sum(APNESUEUR)
          FROM AVAILABLE where (week#=:##week) and (byteon='1')
          and lfr=0  GROUP BY APAFNR, LFR;

       exec sql
        CREATE TABLE qtemp/intermed2
        (APAFNR    CHAR(16) CCSID 273,
           #sum       decimal(13, 2));
       //update
       exec sql
          delete from qtemp/intermed2;
       //update alle Auftragsköpfe einlesen    week
       exec sql
        insert into qtemp/intermed2
           SELECT APAFNR, sum(APNESUEUR)
           FROM available where (week#=:##week) and (byteon='1')
           GROUP BY APAFNR;
       //und ermitteln als Zahl für §records   week
       §records=*zero;
       exec sql
          select count(*) into :§records
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM  qtemp/intermed;
       §calc =((§records-§records2)*100/§records) +0,5;
       exec sql
          update available a set ofrprweek = :§calc where (byteon='1') and
          (week#=:##week);

       §QUANTITY1 = 0;
       §QUANTITY2 = 0;
       //und ermitteln als Zahl für §records   week  *UMSATZ
       §records=*zero;
       exec sql
          select sum(#sum) into :§QUANTITY1
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste *UMSATZ
       §QUANTITY2 = 0;
       exec sql
          SELECT sum(APNESUEUR) into :§QUANTITY2  FROM available a
          WHERE a.apafnr in (select b.apafnr from qtemp/intermed b)
                and week#=:##week and (byteon='1');
       §calc =((§QUANTITY1-§QUANTITY2)*100/§QUANTITY1)+0,5;
       exec sql
          update available a set ofrprweek_= :§calc where (byteon='1') and
          (week#=:##week);


       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG) and
          (byteon='1') and  (week#=:##week);
       §records=*zero;
       exec sql
          select count(*) into :§records
          FROM available where (byteon='1') and (week#=:##week);
       §calc =(§records2*100/§records) +0,5;
       exec sql
        update available a set lfrprweek = :§calc where (byteon='1') and
        (week#=:##week);

       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs Umsatz
       §quantity2=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG) and
          (week#=:##week)   and (byteon='1');
       §quantity1=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available where (byteon='1') and (week#=:##week);
       §calc =(§records2*100/§records)+0,5;
       exec sql
        update available a set lfrprweek_= :§calc where (byteon='1') and
        (week#=:##week);

       //Berechnung der UFR auf Basis der "belieferten Mengen"
       exec sql
          select sum(lfsinput) into :§quantity1
          FROM available WHERE (byteon='1') and (week#=:##week);
       exec sql
          select sum(APBSMG)   into :§quantity2
          FROM available WHERE (byteon='1') and (week#=:##week);

       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
          update available a set ufrprweek = :§calc where (byteon='1') and
          (week#=:##week);

       //Berechnung der UFR auf Basis der "belieferten Umsätze"
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available WHERE (byteon='1') and (week#=:##week) and lfr='1';
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available WHERE (byteon='1') and (week#=:##week);
       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
        update available a set ufrprweek_= :§calc where (byteon='1')
        and (week#=:##week);
       endsr;

       //-----------------------------------------------------------------------
       //month calculation
       //-----------------------------------------------------------------------

       begsr SRmonth;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(qtemp/intermed2)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/available)     ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/available)    ';
       endmon;

       if %char(pstamp) < '2017-01-01-00.00.00.000001';
          exec sql
             select month(current timestamp - 1 hour)
                  into :##month
                  from TVRELWAECO/available ;
       else;
          exec sql
             select month(:pstamp)
                  into :##month
                  from TVRELWAECO/available ;
       endif;

       //alle Auftragsköpfe ohne Belieferung
       exec sql
          CREATE TABLE qtemp/intermed
          (APAFNR    CHAR(16) CCSID 273,
          lfr       decimal(03, 2) ,
          #sum       decimal(13, 2));
       //alle Auftragsköpfe ohne Belieferung month
       exec sql
          delete from qtemp/intermed;
       exec sql
       //negativliste da lfr=0 !!!!!!
          insert into intermed
          SELECT APAFNR, LFR, sum(APNESUEUR)
          FROM AVAILABLE where (month#=:##month) and (byteon='1')
          and lfr=0  GROUP BY APAFNR, LFR;

       exec sql
        CREATE TABLE qtemp/intermed2
        (APAFNR    CHAR(16) CCSID 273,
           #sum       decimal(13, 2));
       //update
       exec sql
          delete from qtemp/intermed2;
       //update alle Auftragsköpfe einlesen    month
       exec sql
        insert into qtemp/intermed2
           SELECT APAFNR, sum(APNESUEUR)
           FROM available where (month#=:##month)  and
           (byteon='1')  GROUP BY APAFNR;

       //und ermitteln als Zahl für §records   month
       §records=*zero;
       exec sql
          select count(*) into :§records
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM  qtemp/intermed;
       §calc =((§records-§records2)*100/§records)+0,5;
       exec sql
          update available a set ofrprmonth= :§calc where (byteon='1') and
          (month#=:##month);

       §QUANTITY1 = 0;
       §QUANTITY2 = 0;
       //und ermitteln als Zahl für §records   month *UMSATZ
       §records=*zero;
       exec sql
          select sum(#sum) into :§QUANTITY1
                FROM  qtemp/intermed2;

       //aus intermed als Zahl für §records2 für Köpfe Fehlliste *UMSATZ
       §QUANTITY2 = 0;
       exec sql
          SELECT sum(APNESUEUR) into :§QUANTITY2  FROM available a
          WHERE a.apafnr in (select b.apafnr from qtemp/intermed b)
                and  month#=:##month and (byteon='1');
       §calc =((§QUANTITY1-§QUANTITY2)*100/§QUANTITY1)+0,5;
       exec sql
          update available a set ofrprmont_= :§calc where (byteon='1') and
          (month#=:##month);


       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs
       §records2=*zero;
       exec sql
          select count(*) into :§records2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG) and
          (month#=:##month) and (byteon='1');
       §records=*zero;
       exec sql
          select count(*) into :§records
          FROM available where (byteon='1') and (month#=:##month);
       §calc =(§records2*100/§records)+0,5;
       exec sql
        update available a set lfrprmonth= :§calc where (byteon='1') and
        (month#=:##month);
       //gesamte Anzahl Basis Positionssätze die erfüllt sind lfs Umsatz
       §quantity2=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available where (LFSINPUT=APBSMG or LFSINPUT>APBSMG) and
          (month#=:##month) and (byteon='1');
       §quantity1=*zero;
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available where (byteon='1') and (month#=:##month);
       §calc =(§records2*100/§records)+0,5;
       exec sql
        update available a set lfrprmont_= :§calc where (byteon='1') and
        (month#=:##month);

       //Berechnung der UFR auf Basis der "belieferten Mengen"
       exec sql
          select sum(lfsinput) into :§quantity1
          FROM available WHERE (byteon='1')  and (month#=:##month);
       exec sql
          select sum(APBSMG)   into :§quantity2
          FROM available WHERE (byteon='1') and (month#=:##month);
       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
        update available a set ufrprmonth= :§calc where (byteon='1')
        and (month#=:##month);

       //Berechnung der UFR auf Basis der "belieferten Umsätze"
       exec sql
          select sum(APNESUEUR) into :§quantity1
          FROM available WHERE (byteon='1') and (month#=:##month) and lfr='1';
       exec sql
          select sum(APNESUEUR) into :§quantity2
          FROM available WHERE (byteon='1') and (month#=:##month);
       §calc =(§quantity1*100/§quantity2) +0,5;
       exec sql
        update available a set ufrprmont_= :§calc where (byteon='1')
        and (month#=:##month);

       endsr;

       //-----------------------------------------------------------------------
       //LFS Eingänge
       //-----------------------------------------------------------------------

       begsr SRlfsinput;

       exec sql
            create index tvrelwaeco/availablel on
                         tvrelwaeco/available
                         (APAFJJ, APAFNR, APAFPO, APKMTE, DATEINP);

       open OUT_CHECK;
       open availablel;

       read OUT_CHECK OUT_CHECK_i;
       dow not %eof(OUT_CHECK);
       // if OUT_CHECK_i.AKDTDF   = %dec(%char(%date():*iso0):8:0);
       // z§§week=13;
       // if OUT_CHECK_i.AKDTDF   = 20170329
          if OUT_CHECK_i.AKDTDF   = %dec(%char(%date()-%days(0):*iso0):8:0)
             and out_check_i.LBAPAFJJ <> 0;
             clear          availablel_o;
             availablel_o.APAFJJ   = out_check_i.LBAPAFJJ;
             availablel_o.APAFNR   = out_check_i.LBAPAFNR;
             availablel_o.APAFPO   = out_check_i.LBAPAFPO;
             availablel_o.APTENR   = out_check_i.LBAPTENR;
       //.
             //Afpo01                                       ffff
             Afpo01_k.apFIRM = '01';
             Afpo01_k.APAFJJ = out_check_i.LBAPAFJJ;
             Afpo01_k.APAFNR = out_check_i.LBAPAFNR;
             Afpo01_k.APAFPO = out_check_i.LBAPAFPO;
             chain %kds(Afpo01_k:4) Afpo01 Afpo01_I;
             if %found(Afpo01);
       //       availablel_o.AKKOSP   = afpo01_i.AKKOSP;
                availablel_o.APTENR   = afpo01_i.APTENR;
                availablel_o.APKMTE   = afpo01_i.APKMTE;
                availablel_o.APLFTE   = afpo01_i.APLFTE;
                availablel_o.APRSDA   = afpo01_i.APRSDA;
                availablel_o.APBSMG   = afpo01_i.APBSMG;
       //       availablel_o.AKEIDA   = afpo01_i.AKEIDA;
       //       availablel_o.AKEIUZ   = afpo01_i.AKEIUZ;
       //       availablel_o.AKAFAT   = afpo01_i.AKAFAT;
                availablel_o.APKURS   = afpo01_i.APKURS;
                availablel_o.APNESU   = afpo01_i.APNESU;
                availablel_o.APNESUEUR= afpo01_i.APNESU *
                                        afpo01_i.APKURS;
             endif;
             //Afko01                                       ffff
             Afko01_k.akFIRM = '01';
             Afko01_k.AkAFJJ = out_check_i.LBAPAFJJ;
             Afko01_k.AkAFNR = out_check_i.LBAPAFNR;
             chain %kds(Afko01_k:3) Afko01 Afko01_I;
             if %found(Afko01);
                availablel_o.AKKOSP   = afko01_i.AKKOSP;
                availablel_o.AKEIDA   = afko01_i.AKEIDA;
                availablel_o.AKEIUZ   = afko01_i.AKEIUZ;
                availablel_o.AKAFAT   = afko01_i.AKAFAT;
             endif;
             //Kom_Sperre auf Nein grundsätzlich hier
             availablel_o.AKKOSP   = *blank;
       //.
             availablel_o.week#    = z§§week;
             availablel_o.month#   = %subdt( %date(): *months );
             //Eingangsdatum!!!!  und Zeit
             availablel_o.DATEINP  = out_check_i.AKDTDF ;
             availablel_o.TIMEINP  = out_check_i.AKTIDF ;
             //ERL./RÜCKCH. DATUM und Zeit
             availablel_o.DATEOUT  = out_check_i.AKDTE  ;
             availablel_o.TIMEOUT  = out_check_i.AKTIE  ;
             availablel_o.APTENR   = out_check_i.LBAPTENR;
             availablel_o.STATUS   = '2 ';
             availablel_o.TSTAMP   = §pstamp;
             //Availablel Gegenprüfung
             availablel_k.APAFJJ = availablel_o.APAFJJ;
             availablel_k.APAFNR = availablel_o.APAFNR;
             availablel_k.APAFPO = availablel_o.APAFPO;
             availablel_k.APKMTE = availablel_o.APKMTE;
             availablel_k.DATEINP= availablel_o.DATEINP;
             chain %kds(availablel_k:5) availablel availablel_i;
             //es wird gegen das Eingangsdatum in lfs geprüft
             //die out_check beinhaltet nur Sätze, die erledigt sind!!!
             if %found(availablel);
                availablel_o.STATUS   = '3 ';
                write PHY01R    availablel_o;
             else;
             //erledigt, waren aber nicht in Originaldatei vorhanden
             //Frage: Ist das Kom_Datum identisch mit dem Dateeinp
             //       Achtung nicht Erledigung!!!
                if availablel_o.DATEINP = availablel_o.APKMTE;
                   availablel_o.STATUS   = '2 ';
                   if availablel_o.DATEOUT = availablel_o.APKMTE;
                      availablel_o.STATUS   = '4 ';
                   endif;
                else;
                   availablel_o.STATUS   = '3 ';
                endif;
                write PHY01R    availablel_o;
             endif;
          endif;
          read OUT_CHECK OUT_CHECK_i;
       enddo;

       close out_check;
       close availablel;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'AVAILABLER'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'AVAILABLE';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/SCM/AVAILABLE*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed AVAILABLE*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object AVAILABLE*                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'AVAILABLE';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/SCM/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object AVAILABLE                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'AVAILABLE';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/SCM/'+ p_infil +''  +
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


       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
           'FORMTYPE(''AVAILABLE'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'AVAILABLE';

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


