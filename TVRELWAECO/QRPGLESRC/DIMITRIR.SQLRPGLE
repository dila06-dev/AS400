
      //************************************************************************
      //
      //      Programmname       AKTIVBANKR
      //      Erstellt  am       08.10.2020
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an galaxus Bestände
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //  maikey='2019611640'  Wert=null!!!!!!
      //
      //
      //************************************************************************
      // Übersetzungshinweise:
      // Restartmöglichkeiten:
      // _____________________
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      // SELECT * FROM Bar_edi/aktivbank
      //
      // SELECT maikey, a14#1 , a14#2, a14#4,hrclvl, XEORF FROM stddat WHERE
      // maikey='2020206875' and hrclvl= '100000000'
      //
      // update  edifact/stddat set xeorf='X'
      // WHERE (PRTNUM like '%DE_MARKANT%'
      // or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP ='INVOIC' and UPDDAT
      // ='20220722' and HRCLVL = '100000000'
      //
      // SELECT * FROM edifact/stddat a WHERE (PRTNUM like '%DE_MARKANT%' or
      // PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP ='INVOIC' and UPDDAT
      // ='20220722' and HRCLVL='100000000' and a.maikey in (select b.maikey
      // from HRCLVL1300 b )
      //
      // update               edifact/stddat a set   SCDDAT = '        ',
      //  USERNM = 'HRCLVLZUAB'                WHERE (PRTNUM like
      // '%DE_MARKANT%' or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP
      // ='INVOIC' and UPDDAT ='20220721' and HRCLVL='100000000' and
      // a.maikey in (select b.maikey from HRCLVL1300 b )
      // 7 Zeilen in STDDAT in EDIFACT aktualisiert.
      //
       //Umstellung 21.07.2022
      // update               edifact/stddat a set   SCDDAT = '        ',
      //  USERNM = 'HRCLVLZUAB'                WHERE (PRTNUM like
      // '%DE_MARKANT%' or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP
      // ='INVOIC' and UPDDAT >'20220721' and HRCLVL='100000000' and
      // a.maikey in (select b.maikey from HRCLVL1300 b )
      // 77 Zeilen in STDDAT in EDIFACT aktualisiert.
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  insert into  tvrelwaeco/afrkstddat
      //  select RKRGJJ, RKRGNR, sum(RKERG1*0), sum(RKERG2*0),
      //                         sum(RKERG3*0), sum(RKERG4*0)
      //           from afrk01
      //           where rkfirm='01' and RKERG1 > 0 and rkrgnr='162858'and
      //                 (RkRGJJ concat RKRGNR) in
      //                 ( select maikey from       stddat
      //                   where a3#01 ='A' )
      //           group by RKRGJJ, RKRGNR
      //
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  SELECT * FROM HRCLVL1300 ORDER BY ERRORTYP, maikey
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  SELECT HRCLVL1300.SNDREC, HRCLVL1300.PRTNUM, HRCLVL1300.MSGTYP,
      //  HRCLVL1300.MAIKEY, HRCLVL1300.HRCLVL, HRCLVL1300.LINNUM,
      //  HRCLVL1300.ANZAHL, HRCLVL1300.STATUS, HRCLVL1300.ERRORTYP,
      //  HRCLVL1300.TSTAMP, STDDAT.UPDDAT, STDDAT.WRTTIM, STDDAT.WRTDAT,
      //  STDDAT.USERNM, STDDAT.XEORF, STDDAT.SCDDAT FROM HRCLVL1300,
      //  edifact/stddat WHERE HRCLVL1300.MAIKEY = STDDAT.MAIKEY and
      //  STDDAT.HRCLVL ='100000000' ORDER BY ERRORTYP , rrn(HRCLVL1300)
      //
      //  update  afrk01 set RKST02= '10' where RKFIRM ='01' and
      //  RKRGJJ =2021 and RKRGNR ='163392'
      //
      //  SELECT * FROM stddat WHERE ( HRCLVL ='130000000' and MSGTYP =
      //  'INVOIC' ) and HRCLVL  ='130000000' and np3#1 <> 0
      //  and prtnum=        'EZ_MARKANT_RECHNUNG'
      ///Fehler gemeldet! 08.08.2022 #
      //  update EDIFACT/stddat set np3#1 =  0
      //  WHERE (HRCLVL ='130000000' and MSGTYP = 'INVOIC' and np3#1 <> 0)
      //  update tvrelwaeco/HRCLVL1300 set status= '  '
      //  WHERE MAIKEY = '2019617116'
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

     fHRCLVL130luf   e           k DISK    usropn
     f                                     RENAME(HRCLVL1300:PHY01R)

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


       // define files
       // ______________________________________________________________________
     d HRCLVL130l_i  e ds                  ExtName(HRCLVL130l:*input)
     d                                     Qualified

     d HRCLVL130l_o  E DS                  ExtName(HRCLVL130l:*output)
     d                                     Qualified

     d HRCLVL130l_k  E DS                  ExtName(HRCLVL130l:*key)
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
     D week            s              1s 0 inz
     d NumSysTime      s              6s 0
     d myDate          s               d

     D suffix          s             06A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     D years           s              4s 0 inz
     D §ENTRY#         s             11A   inz
     D §rkreda         s              8s 0 inz
     D §rplipo         s              4a   inz
     D §rkkon          s             10a   inz
     D §rpnesu         s             13s 2 inz
     D §§rpnesu        s             13s 2 inz
     D §upload         s            256a   inz
     D §monat          s              2s 0 inz
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §records        s              9s 0 inz
     D §text           s             48a   inz
     D §SNDREC         s              3a   inz
     D §PRTNUM         s             35a   inz
     D §MSGTYP         s              6a   inz
     D §MAIKEY         s             35a   inz
     D §HRCLVL         s              9a   inz
     D §LINNUM         s              6s 0 inz

     IPHY01R
     I              status                      §status
      /eject

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start FTP Transfer for AKTIVBANKR   ';
       exsr      SR_log;
      // exsr HRCLVL1300;

       //balance INVOICES for erp ERP Trend-System
       exec sql
         insert into bar_edi/aktivbank
         SELECT RKFIRM,RKRGJJ,RKRGNR,RKLIJJ,RKLINR,RKKDNR,rkreda
                             ,dec(0, 10) #cc,
         char('  ', 2) status,current date #date,current timestamp #tstamp,
         dec(0, 10) #count,current timestamp updtstamp,
         char(' ', 10) pgm,char(' ', 10) job,char(' ', 10) user,
         char(' ', 128) protokoll
         FROM afrk01 b WHERE RKRGJJ > 2021 and rkreda > 20210000  and
                             rkkdnr<>'xxxxxx'  and  rkrgnr<>' ' and rkrgnr
         not in (select rkrgnr from bar_edi/aktivbank a
                 where b.rkfirm=a.rkfirm and b.RKRGJJ=a.RKRGJJ and
                       b.RKLIJJ=a.RKLIJJ and b.RKLINR=a.RKLINR and
                       b.RKKDNR=a.RKKDNR)        and b.RKKDNR in
                 (select kdkdnr from kund01
                  where kdfirm=b.rkfirm and KDKDGR='025' and KDKDST='01');

       exec sql
         update        Bar_edi/aktivbank set protokoll =
         (select kdnam3 from kund01
          where kdfirm=rkfirm and  kdkdnr=rkkdnr  and
          STATUS='  ' )
         where exists
          (select kdnam3 from kund01
          where kdfirm=rkfirm and  kdkdnr=rkkdnr  and
          STATUS='  ' );

       exec sql
         update Bar_edi/aktivbank set #tstamp = current timestamp
         where  aktivbank.status='  ' and
                char(RKRGJJ concat RKRGNR) in
                ( select MAIKEY from stddat where
                (a14#1=' ' or a14#2=' ' or a14#4=' ') and
       //       hrclvl= 100000000 and STDDAT.XEORF ='X');
                hrclvl= '100000000' and STDDAT.XEORF <>'#'
                and substr( MAIKEY, 1, 4)='2022');

       exec sql
         update Bar_edi/aktivbank set status = '10'
         where  aktivbank.status=' ' and
                char(RKRGJJ concat RKRGNR) in
                ( select MAIKEY from stddat where
                (a14#1=' ' or a14#2=' ' or a14#4=' ') and
       //       hrclvl= 100000000 and STDDAT.XEORF ='X');
                hrclvl= '100000000' and STDDAT.XEORF <>'#'
                and substr( MAIKEY, 1, 4)='2022');


       //a14#2 ZR
       exec sql
          update  stddat set a14#2 =
          (SELECT substr(PROTOKOLL, 4, 5) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022')
          where exists
          (SELECT substr(PROTOKOLL, 4, 5) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022');

       //a14#1 VL
       exec sql
          update  stddat set a14#1 =
          (SELECT substr(PROTOKOLL, 12, 6) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022')
          where exists
          (SELECT substr(PROTOKOLL, 12, 6) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022');


       //a14#4 AH
       exec sql
          update  stddat set a14#4 =
          (SELECT substr(PROTOKOLL, 22, 6) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022')
          where exists
          (SELECT substr(PROTOKOLL, 22, 6) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)='2022');


       //update Aktivbank restart bbbb
       exec sql
          update  stddat set XEORF  = 'X'
          where   maikey in
                  (select char(RKRGJJ concat RKRGNR)
                   FROM bar_edi/aktivbank
                   where  aktivbank.status='10' and
                     hrclvl= '100000000' and STDDAT.XEORF <>'#'
                     and substr( MAIKEY, 1, 4)='2022');

       //..
       exec sql
           update  Bar_edi/aktivbank
           set status='20' where status='10';


       eval status ='Start HRCLVL1300                    ';
       exsr      SR_log;
       exsr HRCLVL1300;
       eval status ='Ende  HRCLVL1300                    ';
       exsr      SR_log;

       MONITOR;
       Wrk.var1 =
           'DSPJOBLOG OUTPUT(*PRINT) ';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DSPJOBLOG OUTPUT(*PRINT)';
          exsr      SR_log;
       endmon;

       eval status ='Ende  FTP Transfer for AKTIVBANKR   ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //-----------------------------------------------------------------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';




       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //-----------------------------------------------------------------------

       begsr HRCLVL1300;

       //Funktion HRCLVLZUAB
       //Sätze ohne Werte im HRCLVL 1300000 dürfen nicht übertragen werden!
       //Die Funktion HRCLVLZUAB muß vor der Funktion HRCLVL1300 laufen   !
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
                                            and substr( MAIKEY, 1, 4)='2022'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVLZUAB nur prtnum='EZ_MARKANT_RECHNUNG' !!!!!!!!
       //Bereigung da altlast   alt Ezitel                    !!!!!!!!
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (prtnum='EZ_MARKANT_RECHNUNG')
                                            and substr( MAIKEY, 1, 4)='2019'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;


       //Funktion HRCLVLZUAB nur prtnum='MARKANT_RECHNUNG' alt aus 2020 und 2021
       //die über den restart hineingegangen sind wrtdat(20220805) ladedatum
       //===> update  afrk01 set RKST02= '10'
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
             and (substr( MAIKEY, 1, 4)='2020' or substr( MAIKEY, 1, 4)='2021')
             and wrtdat > '20220804'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;


       exec sql
          insert into tvrelwaeco/savestddat
          select * from EDIFACT/stddat a where a.maikey in
          (select b.maikey from TVRELWAECO/HRCLVL1300 b
           where a.HRCLVL = b.HRCLVL  and
                 a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                     and status='  ' );
       exec sql
          delete   from EDIFACT/stddat a where a.maikey in
          (select b.maikey from TVRELWAECO/HRCLVL1300 b
           where a.HRCLVL = b.HRCLVL  and
                 a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                     and status='  ' );
       exec sql
          update TVRELWAECO/HRCLVL1300 a set status = '10' where
          a.maikey in
          (select b.maikey from EDIFACT/stddat b
           where a.HRCLVL = b.HRCLVL  and
                 a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                     and status='  ' );

       exec sql
          update TVRELWAECO/HRCLVL1300  set status = '20'
          where errortyp='HRCLVLZUAB' and status='  ';

       //Funktion HRCLVL1300
       //Sätze müssen in der Reihenfolge von HRCLVL erfolgen und nur bei
       //Rechnungen, die auch Wert haben!!
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
                                            and substr( MAIKEY, 1, 4)='2022'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVL1300  nur prtnum='EZ_MARKANT_RECHNUNG' !!!!!!!!
       //Bereigung da altlast   alt Ezitel                    !!!!!!!!
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (prtnum='EZ_MARKANT_RECHNUNG')
                                            and substr( MAIKEY, 1, 4)='2019'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVL1300 nur prtnum='MARKANT_RECHNUNG' alt aus 2020 und 2021
       //die über den restart hineingegangen sind wrtdat(20220805) ladedatum
       //===> update  afrk01 set RKST02= '10'
       //Bereigung da altlast   2020/2021                     !!!!!!!!
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
             and (substr( MAIKEY, 1, 4)='2020' or substr( MAIKEY, 1, 4)='2021')
             and wrtdat > '20220804'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;



       exec sql
         create index tvrelwaeco/HRCLVL130l on tvrelwaeco/HRCLVL1300
         (status);

       MONITOR;
       Wrk.var1 =
           'DLTOBJ OBJ(QTEMP/STDDAT) OBJTYPE(*FILE)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DLTOBJ OBJ(QTEMP/STDDAT)';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CRTDUPOBJ OBJ(STDDAT) FROMLIB(EDIFACT) ' +
           'OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(STDDAT)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in CRTDUPOBJ OBJ(STDDAT)   ';
          exsr      SR_log;
       endmon;

          open HRCLVL130l;
          HRCLVL130l_k.status  =  *blank;
          setll %kds(HRCLVL130l_k:1) HRCLVL130l;
          reade %kds(HRCLVL130l_k:1) HRCLVL130l  HRCLVL130l_i;
          dow not %eof(HRCLVL130l);
       //CRTDUPOBJ OBJ(STDDAT) FROMLIB(EDIFACT) OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(STDDAT)
       //// ,,,
             if HRCLVL130l_i.status = *blank and
                HRCLVL130l_i.ANZAHL = 1      and
                HRCLVL130l_i.ERRORTYP = 'HRCLVL1300';
                HRCLVL130l_i.status = '10';
                HRCLVL130l_o = HRCLVL130l_i;
                update phy01r   HRCLVL130l_o;
                §SNDREC = HRCLVL130l_i.SNDREC;
                §PRTNUM = HRCLVL130l_i.PRTNUM;
                §MSGTYP = HRCLVL130l_i.MSGTYP;
                §MAIKEY = HRCLVL130l_i.MAIKEY;
                §HRCLVL = HRCLVL130l_i.HRCLVL;
                §LINNUM = HRCLVL130l_i.LINNUM;

                eval status ='####  HRCLVL1300   ' + §MAIKEY;
       //no log exsr      SR_log;

                exec sql
                   insert into   qtemp/stddat
                   select * from  EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY
                            ORDER BY SNDREC, PRTNUM,  MSGTYP,
                                     MAIKEY, HRCLVL, LINNUM;

                exec sql
                   insert into   tvrelwaeco/savestddat
                   select * from  EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY;

                exec sql
                   delete from   EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY;

       //Korrektur: laufende Nummer mit Sequenz (wegen order by)
                exec sql
                   update qtemp/stddat
                          set LINNUM = rrn(stddat) - 1,
                              USERNM = 'HRCLVL1300';

       //Korrektur: HRCLVL: 130000000      hier einer aus 2021:MAIKEY ='2021146902'
       //-> A = Allowance= Abschläge  / C = Charge=Zuschläge
       //where a3#01 ='A' dieses ist ein Fehler bei RKERG1 > 0, RKERG2 > 0 usw.
       //zwischendatei für Erkennung ableiten
                exec sql
                   insert into   tvrelwaeco/afrkstddat
                   select RKRGJJ, RKRGNR, sum(RKERG1) a from afrk01
                   where rkfirm='01' and RKERG1 > 0 and
                         (RkRGJJ concat RKRGNR) in
                         ( select maikey from qtemp/stddat
                           where a3#01 ='A' and HRCLVL = '130000000')
                   group by RKRGJJ, RKRGNR;
                exec sql
                   insert into   tvrelwaeco/afrkstddat
                   select RKRGJJ, RKRGNR, sum(RKERG2) a from afrk01
                   where rkfirm='01' and RKERG2 > 0 and
                         (RkRGJJ concat RKRGNR) in
                         ( select maikey from qtemp/stddat
                           where a3#01 ='A' and HRCLVL = '130000000')
                   group by RKRGJJ, RKRGNR;
                exec sql
                   insert into   tvrelwaeco/afrkstddat
                   select RKRGJJ, RKRGNR, sum(RKERG3) a from afrk01
                   where rkfirm='01' and RKERG3 > 0 and
                         (RkRGJJ concat RKRGNR) in
                         ( select maikey from qtemp/stddat
                           where a3#01 ='A' and HRCLVL = '130000000')
                   group by RKRGJJ, RKRGNR;
                exec sql
                   insert into   tvrelwaeco/afrkstddat
                   select RKRGJJ, RKRGNR, sum(RKERG4) a from afrk01
                   where rkfirm='01' and RKERG4 > 0 and
                         (RkRGJJ concat RKRGNR) in
                         ( select maikey from qtemp/stddat
                           where a3#01 ='A' and HRCLVL = '130000000')
                   group by RKRGJJ, RKRGNR;


       //Korrektur:                    für HRCLVL = '130000000'
       //hier alle Fehler:  K O P F
       //SELECT DISTINCT RKRGJJ, RKRGNR, sum(RKERG1),sum(RKERG2),
       //sum(RKERG3),sum(RKERG4) FROM afrk01 WHERE RkRGJJ =2022 and RKERG1 >
       //0 and (RkRGJJ concat RKRGNR) in ( select maikey from stddat where
       //a3#01 ='A' and hrclvl='130000000' and MSGTYP ='INVOIC')
       //GROUP BY RKRGJJ, RKRGNR
       //                   U N D   P O S T I O N
       //SELECT DISTINCT RpRGJJ, RpRGNR, sum(RpERG1),sum(RpERG2),
       //sum(RpERG3),sum(RpERG4) FROM afrp01 WHERE RpRGJJ =2022 and RpERG1 >
       //0 and (RpRGJJ concat RpRGNR) in ( select maikey from stddat where
       //a3#01 ='A' and hrclvl='155000000' and MSGTYP ='INVOIC')
       //GROUP BY RpRGJJ, RpRGNR
       //
       //Korrektur: -> A = Allowance= Abschläge  / C = Charge=Zuschläge
       //Korrektur: auf ===> c
                exec sql
                   update qtemp/stddat
                          set a3#01 ='C'
                   where HRCLVL = '130000000' and
                         np2#2 in (select a from tvrelwaeco/afrkstddat);
       //Korrektur: -> np3#1 = '0'  -> hier müsste der MWStsatz für die Zu/Abschläge stehen  ( 0 dürfte nur dann
       //Korrektur: -> sein, wenn ohne Mwst) wird aus Kopfsatz gezogen
                exec sql
                   update qtemp/stddat a
                          set a.np3#1 =
                   (select b.np3#1 from qtemp/stddat b where
                         b.HRCLVL = '100000000'  and
                         a.HRCLVL = '130000000')
                   where exists
                   (select b.np3#1 from qtemp/stddat b where
                         b.HRCLVL = '100000000'  and
                         a.HRCLVL = '130000000');

       //Korrektur: -> Qualifier bei  Zu/Abschlagsangaben
                exec sql
                   update qtemp/stddat  set A3#02 = CASE
                      when a35#02 = 'Versandkosten     ' then 'FC '
                      when a35#02 = 'Frachtkosten      ' then 'FC '
                      when a35#02 = 'Frachtzuschlag    ' then 'FC '
                      when a35#02 = 'Versandnebenkosten' then 'FC '
                      when a35#02 = 'Zentrallagerrabatt' then 'DI '
                      when a35#02 = 'Auftragsrabatt    ' then 'DI '
                      when a35#02 = 'Rabatt            ' then 'DI '
                      when a35#02 = 'Auftrags-Bonus    ' then 'TD '
                      when a35#02 = 'Verpackungs-Kosten' then 'PC '
                      when a35#02 = '                  ' then 'FC '
                      when A3#02  = 'Ver'                then 'FC '
                      else                                    'FC '
                      end
                   where HRCLVL = '130000000';

       //Korrektur: der gesamtbonuswert ist negativ !!!!!!
       //update        stddat set np3#4 =
       //(select  RKERG1+RKERG2+RKERG3+RKERG4
       // from afrk01
       // where RKERG1+RKERG2+RKERG3+RKERG4 < 0 and
       //       maikey=(RkRGJJ concat RKRGNR) and
       //       MSGTYP = 'INVOIC' and HRCLVL = '100000000'
       //       and MAIKEY = '2019617116')
       //where exists
       //(select  RKERG1+RKERG2+RKERG3+RKERG4
       // from afrk01
       // where RKERG1+RKERG2+RKERG3+RKERG4 < 0 and
       //       maikey=(RkRGJJ concat RKRGNR) and
       //       MSGTYP = 'INVOIC' and HRCLVL = '100000000'
       //       and MAIKEY = '2019617116')
       //
       //
       //
       //    > update                            stddat set XEORF='X'
       //                                               WHERE MAIKEY = '2019617116'
       //         and HRCLVL  ='100000000'
       //      1 Zeilen in STDDAT in EDIFACT aktualisiert.
       //    > update                            stddat set SCDDAT ='NEU'
       //                                               WHERE MAIKEY = '2019617116'
       //         and HRCLVL  ='100000000'


       //Korrektur: alt für EDDY
       ////     exec sql
       ////        update qtemp/stddat set XEORF  = 'X'
       ////               where HRCLVL = '100000000';

       //Korrektur: SCDDAT = 'NEU     '  übergabe System neu
                exec sql
                   update qtemp/stddat set SCDDAT = 'NEU     '
                          where HRCLVL = '100000000';

                exec sql
                   insert into  EDIFACT/stddat
                   select * from qtemp/stddat;
                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(qtemp/stddat)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(qtemp/stddat)           ';
                      exsr      SR_log;
                endmon;
             endif;
                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(tvrelwaeco/afrkstddat)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(qtemp/afrkstddat)       ';
                      exsr      SR_log;
                endmon;
             reade %kds(HRCLVL130l_k:1) HRCLVL130l  HRCLVL130l_i;
          enddo;

          close HRCLVL130l;


       //Korrektur: SCDDAT = 'NEU     '  übergabe System neu
       //Freigabe aller Rechnungen ab Stapel
                exec sql
                   update EDIFACT/stddat set SCDDAT = 'NEU     '
                   where MSGTYP ='INVOIC' and
                         HRCLVL ='100000000' and
                         SCDDAT = '        ' and
                   (PRTNUM like '%DE_MARKANT%'
                    or PRTNUM like 'MARKANT_RECHNUNG%'
                    or PRTNUM =    'EZ_MARKANT_RECHNUNG')
                   and WRTDAT >'20220720';
       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'GALAXUSR  ';
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


