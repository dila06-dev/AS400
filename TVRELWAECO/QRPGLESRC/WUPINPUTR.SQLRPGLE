
      //************************************************************************
      //
      //      Programmname       WUPINPUTR
      //      Erstellt  am       08.10.2020
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung für WUP
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
      // feld: status
      // 0 restart
      // 1 wird verarbeitet werden durch WUP
      // 2 erflogreich verarbeitet
      // 3 kleine Fehler, aber gespeichert
      // 4 inhaltlicher Fehler nicht gespeichert abgelehtn
      // 5 allgemeiner Fehler nicht gespeichert abgelehtn
      // prüfung gegen SELECT count(*) FROM land WHERE LNLDGR ='0001'
      //               SELECT count(*) FROM land WHERE LNLDGR ='0002' FTA
      //
      // WUPINPUT   Pooldatei      *löschen bei Neuaufbau
      // wupmeldung bereinigt sich nach jedem Lauf
      // wuphistory Historie gebildet aus Wupinput wenn ok für Meldung
      //            aus Wup selber mit Status 2 oder 3, danach werden
      //            aus Wupinput  diese Sätze gelöscht
      //            *löschen bei Neuaufbau bei kompletten Neuaufbau
      // wupoutput  Ausgabedatei für Wup, der status wird nach Wup-prozess
      //            von WUP geändert
      //            erledigte in Wup mit status 2 oder 3 werden in WUPHISTORY
      //            kopiert und aus wupoutput gelöscht
      //            es kann sein, dass der WE in WUPHISTORY ist und der
      //            Verbrauch in wupoutput bis dieses Programm erneut
      //            aufgerufen wird für die Kopieraktion
      //            Ausgabedatei   *löschen bei Neuaufbau
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      // SELECT LBLBBDAT, LBLBTENR, SORT, MENGE, LBLBBWME, LBLBSTKZ, STOCK,
      // ANZAHL, substr(LBLBDAKY, 1, 10), aelfnr,WUPKEY, STATUS WUPWE, TCT
      // FROM wupinput WHERE status <'90' ORDER BY LBLBTENR, LBLBBDAT,SORT
      // desc
      //
      //
      //
      //
      //
      //  SELECT * FROM wupinput WHERE wupwe='2016172636'
      //  SELECT DISTINCT LBLBTENR,LBLBBDAT, LBLBTENR , WUPWE, TCT FROM
      //  wupinput WHERE status <>'99' and status <>'95' and tct in ('1',
      //  '2') ORDER BY LBLBTENR,wupwe , tct desc
      //
      //                                       2021279067
      //
      //
      //  SELECT LBLBTENR,LBLBBDAT, LBLBTENR , WUPWE, TCT, count(*) FROM
      //  wupinput WHERE status <>'99' and status <>'95' and tct in ('1',
      //  '2') and wupwe='2019192711' GROUP BY LBLBTENR,LBLBBDAT, LBLBTENR,
      //  WUPWE, TCT ORDER BY LBLBTENR,wupwe , tct desc
      //
      //  SELECT * FROM wupinput WHERE LBLBTENR ='9104100179' and status
      //  <>'99' and status <>'95' ORDER BY wupwe
      //
      //  SELECT LBLBBDAT, LBLBTENR, SORT, MENGE, LBLBBWME, STOCK,
      //  substr(LBLBDAKY, 1, 10), AELFNR, WUPKEY, STATUS, TSTAMP, WUPWE,
      //  TCT, "CHECK" FROM wupinput WHERE LBLBTENR <>'x887200018' and
      //  substr(status, 1, 1) <> '9' ORDER BY LBLBTENR, LBLBBDAT,SORT desc
      //
      //  SELECT LBLBTENR,LBLBBDAT, WUPWE,AELFNR,     TCT, current timestamp
      //  tstamp , char(' ', 1) VBKZ, Char('  ', 2) status FROM wupinput
      //  WHERE status <>'99' and status <>'95' and status <>'91' and tct in
      //  ('1', '2') and check   = '10'
      //  GROUP BY LBLBTENR,LBLBBDAT,WUPWE,AELFNR, TCT ORDER
      //  BY LBLBTENR,wupwe , tct desc
      ///Fehler gemeldet! 08.08.2022 #
      ///log file sehen
      //  SELECT * FROM job_run WHERE JOBDESC like '%BARTRR3%'
      ///status '99' für Prozess uninteressant
      //
      //
      //
      //
      //
      //
      //  SELECT * FROM wupinput WHERE LBLBDAKY like '%2020148588%' or wupkey
      //  like '%2020148588%' ORDER BY SORT desc , LBLBBDAT
      //
      //
      //
      //
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

     fWUPINPUTl1uf   e           k DISK    usropn
     f                                     RENAME(WUPINPUT:PHY01R)

     fWUPOUTPUTluf   e           k DISK    usropn
     f                                     RENAME(WUPoutPUT:PHY02R)

     fbwae07    if   e           k DISK

     flpif01    if   e           k DISK
     f
     fLAND01    if   e           k disk

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
     d WUPINPUTl1_i  e ds                  ExtName(WUPINPUTl1:*input)
     d                                     Qualified

     d WUPINPUTl1_o  E DS                  ExtName(WUPINPUTl1:*output)
     d                                     Qualified

     d WUPINPUTl1_k  E DS                  ExtName(WUPINPUTl1:*key)
     d                                     Qualified

     d WUPoutputl_i  e ds                  ExtName(WUPoutputl:*input)
     d                                     Qualified

     d WUPoutputl_o  E DS                  ExtName(WUPoutputl:*output)
     d                                     Qualified

     d WUPoutputl_k  E DS                  ExtName(WUPoutputl:*key)
     d                                     Qualified

     d Bwae07_k      E DS                  ExtName(Bwae07:*key)
     d                                     Qualified
     d Bwae07_I      E DS                  ExtName(bwae07:*input)
     d                                     Qualified

       //           Lpif
     d lpif01_k      E DS                  ExtName(lpif01:*key)
     d                                     Qualified

     d lpif01_i      E DS                  ExtName(lpif01:*input)
     d                                     Qualified

       //lpif_o        E DS                  ExtName(lpif01:*output)
       //                                    Qualified

       //           Land
     d land01_k      E DS                  ExtName(land01:*key)
     d                                     Qualified

     d land01_i      E DS                  ExtName(land01:*input)
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
     D §LBLBTENR       s             15a   inz
     D §sort           s              4a   inz
     D §LBLBDAKY       s             40a   inz
     D §stock          s             10s 3 inz
     D §AELFNR         s             10a   inz
     D §runon          s              1s 0 inz
     D §rrn            s             13s 0 inz
     D #LBLBBDAT       s              8s 0 inz
     D #LBLBTENR       s             15a   inz
     D #stock          s             10s 3 inz
     D #wupkey         s             23a   inz
     D #sort           s              4a   inz
     D #LBLBDAKY       s             40a   inz
     D #AELFNR         s             10a   inz
     D #upd            S               Z
     D #TIMESTAMP      S             26a
     D #Tstamp         S               z

      /eject
     IPHY01R
     I              status                      §status

     IPHY02R
     I              status                      $status

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start FTP Transfer for WUPINPUTR    ';
       exsr      SR_log;

       exec sql
           select max(LBLBTMST) into :#TIMESTAMP from wupinput;
       if #TIMESTAMP = *blank;
       exec sql
           select current timestamp - 5 years into :#tstamp from lblb01;
       exec sql
           select char(current timestamp - 5 years)
                         into #TIMESTAMP  from lblb01;
       else;
       exec sql
           SELECT timestamp(:#TIMESTAMP) into :#tstamp from wupinput;
       endif;

       exec sql
        insert into TVRELWAECO/WUPINPUT
        SELECT min(LBLBBDAT) LBLBBDAT,
                        LBLBTENR, char('0' concat LBLBLSTC, 4) sort,
        dec(sum(LBLBBWMG), 10, 3) Menge, LBLBBWME, LBLBSTKZ,
        dec(0,0, 10, 3) stock, dec(max(LBLBLGBS), 10, 3) #LBLBLmax,
        dec(min(LBLBLGBS), 10, 3) #LBLBLmin,dec(count(*), 5, 0) anzahl,
        LBLBDAKY, char(' ', 10) AELFNR,char(' ', 23) Wupkey,char(' ', 2)
        status, current timestamp tstamp, current timestamp upd,
        max(LBLBTMST) lblbtmst, LBLBLANR, char(' ', 10) Wupwe,
        char(' ', 1) TCT, char(' ', 1) TCTST, char('  ', 2) check,
        LBLBDANA, current timestamp tstamptct
        FROM lblb01 WHERE LBLBFIRM ='01' and LBLBLANR ='001'
        and LBLBBDAT > 20190101
        and LBLBTENR not in
              ('#9600000338', '#9620000128', '#AS71430', '#A411041',
              '#A411042', '#9102000135', '#9104100163', '#9104100179',
              '#4445900467', '#9105330588', '#4445900487', '#8887500055',
              '#4440400008', '#8887200018', '#4442700517', '#9620001413',
              '#4445900092', '#4445200117', '#9600026790', '#4443300055')
        and LBLBDAKY not in (select LBLBDAKY from WUPINPUT )
        GROUP BY LBLBTENR,LBLBLSTC,LBLBBWME,LBLBSTKZ,LBLBDAKY,LBLBLANR,
                 LBLBDANA
        having LBLBDAKY > :#TIMESTAMP ORDER BY (LBLBBDAT), sort desc;

       //für den Prozess uninteressante oder bereits verarbeitete
       //Status = '95'
       exec sql
        update wupinput  set status='95' where
        status = '  ' and sort= '0950' and check = '  ' and
        (LBLBDAKY = ' ' or
         substr(lblbdaky, 1, 21)= '0000      00000000000');

       exec sql
        update wupinput  set status='95' where
        status = '  ' and LBLBDANA ='          ' and check = '  ';

       exec sql
        update wupinput  set status='95' where
        status = '  ' and LBLBDANA ='LGKO      ' and check = '  ';

       //exec sql
       //  create index tvrelwaeco/WUPINPUTl1 on tvrelwaeco/WUPINPUT
       //  (status, LBLBTENR, LBLBBDAT, sort desc);
       //exec sql
       //  SELECT LBLBTENR,LBLBBDAT, LBLBTENR , WUPWE, TCT, current timestamp
       //  tstamp FROM wupinput WHERE status <>'99' and status <>'95' and
       //  status <>'91' and tct in ('1', '2') GROUP BY LBLBTENR,LBLBBDAT,
       //  LBLBTENR, WUPWE, TCT ORDER BY LBLBTENR,wupwe , tct desc
       //exec sql
       //  create index tvrelwaeco/WUPoutputl on tvrelwaeco/WUPoutput
       //  (vbkz, WUpWE);


       breakpoint = '1';
       dow breakpoint = '1';
           §LBLBTENR   = *Blank;
           §sort       = *Blank;
           §LBLBDAKY   = *Blank;
           §stock      = *zero;
           §runon      = *zero;
           exec sql
              select current timestamp
              into   :#upd
              from   TVRELWAECO/WUPINPUT;
           exsr wupupdate;
       enddo;
       exsr      SR_log;

       //Datenermitteln aus Wareneingang Protokoll

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/WUPMELDUNG)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/WUPMELDUNG)    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/WUPMELDUNG)   ';
       endmon;

       //preselect alle Verbräuche "Enddatum" max(LBLBBDAT)
       //Verbräuche status 10
       exec sql
        insert into TVRELWAECO/wupmeldung
        SELECT DISTINCT
               max(LBLBBDAT) LBLBBDAT, LBLBTENR, WUPWE, char('10', 2) status
        FROM wupinput WHERE (status ='10') and check = '  '
             and WUPWE <> ' ' and tct=' ' and stock=0 GROUP BY
        LBLBTENR, WUPWE ORDER BY max(LBLBBDAT), LBLBTENR ,WUPWE desc;

       //status auf 1 wo Verbräuche "Enddatum" max(LBLBBDAT) haben
       //Achtung by stock null
       exec sql
        update wupinput a  set tct='1'
        where a.check = '  ' and
              a.LBLBBDAT in
        (select b.lblbbdat from wupmeldung b
         where a.lblbtenr = b.lblbtenr and
               a.LBLBBDAT = b.LBLBBDAT and
               a.tct =' '  and a.status='10' and
               a.wupwe  =    b.wupwe       and
               a.status =    b.STATUS );

       //preselect alle WE's "Anfangsdatum" min(LBLBBDAT)
       exec sql
        insert into wupmeldung
        SELECT distinct min(LBLBBDAT) LBLBBDAT, LBLBTENR,
               substr(LBLBDAKY, 1, 10), char('20', 2) status
         FROM wupinput WHERE (status ='20') and tct=' ' and check = '  '
         group by LBLBTENR, substr(LBLBDAKY, 1, 10);

       //status auf 2 wo WE's "Anfangsdatum" min(LBLBBDAT) haben
       //we's status 20
       exec sql
        update wupinput a  set tct='2'
        where a.check = '  ' and
              substr(a.LBLBDAKY, 1, 10) in
        (select b.WUPWE  from wupmeldung b
         where a.lblbtenr = b.lblbtenr and
               a.LBLBBDAT = b.LBLBBDAT and
               a.tct =' '  and a.status='20' and
               a.status =     b.STATUS );

       //und auch den WUPWE ergänzen
       exec sql
        update  wupinput set wupwe = substr(LBLBDAKY, 1, 10)
        WHERE status  <>'99' and status <>'95' and status <>'91'
                   and tct in ('2', '2')
                   and wupwe=' ' and check = '  ';

       //alle vorangegangenen Sätze können unberücksichtigt bleiben
       //da ggf. Bestand aber nicht zugeordnet zu einem WE
       exec sql
        update  wupinput set status ='91'
        WHERE status  = '  ' and check = '  ';

       //Wup prozess wird einlesen und Status neu vergeben
       //eingelesene werden in Historie abgelegt und aus Original gelöscht
       exec sql
         insert into tvrelwaeco/wuphistory
         SELECT * from tvrelwaeco/wupoutput
         WHERE status = '2 ' or status = '3 ';

       //löschen aus Übergabedatei
       exec sql
         delete   from tvrelwaeco/wupoutput
         WHERE status = '2 ' or status = '3 ';

       //alle vorangegangenen Sätze können unberücksichtigt bleiben
       //aber vorher Protokoll ausgeben für Format/WUP
       //RT=Einkaufsware (0)
       exec sql
         insert into tvrelwaeco/wupoutput
         SELECT LBLBTENR,LBLBBDAT, WUPWE,AELFNR,    TCT, current timestamp
         tstamp , char(' ', 1) VBKZ, 0 status, 0 rt,
         char('   ', 3) LNLDNR, char('    ', 4) LNLDGR  FROM wupinput
         WHERE status <>'99' and status <>'95' and status <>'91' and tct in
         ('1', '2') and check   = '  '
         GROUP BY LBLBTENR,LBLBBDAT,WUPWE,AELFNR, TCT order
         BY LBLBTENR,wupwe , tct desc;

       exec sql
         update  wupinput set check  ='10'
         WHERE check   = '  ';

       //alle vorangegangenen Sätze können unberücksichtigt bleiben
       exsr sr_lpif;

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

       //Testsystemübergabe
       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/wupoutputt)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/wupoutputt)    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/wupoutputt)   ';
       endmon;

       //Testsystemübergabe
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(TVRELWAECO/wupoutput) '       +
           'TOFILE(TVRELWAECO/wupoutputt) MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='erledigt CPYF FROMFILE(TVRELWAECO/wupoutput)      ';
          exsr      SR_log;
       on-error;
          status='error in command appeared: CPY   wupoutput        ';
          exsr      SR_log;
       endmon;


       eval status ='Ende  FTP Transfer for WUPINPUTR    ';
       exsr      SR_log;

       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

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


       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //    SELECT max(rrn(wupinput)) FROM wupinput WHERE LBLBTENR
       //    ='9600000338' and status='10'
       //    select stock from wupinput where rrn(wupinput) = 2292
       //    §runon = 1; stzen + breakpoint = '1' §stock=
       //
       //
       //-----------------------------------------------------------------------

       begsr wupupdate;

       //...
          open  WUPINPUTl1;
          breakpoint = '0';
          #LBLBTENR  = *blank;
          #stock     = *zero;
          #wupkey    = *blank;
          #sort      = *blank;
          #AELFNR    = *blank;
          #LBLBDAKY  = *blank;
          #LBLBBDAT  = *zero;
          §rrn       = *zero;
             WUPINPUTl1_k.status  =  *blank;
             setll %kds(WUPINPUTl1_k:1) WUPINPUTl1;
             reade %kds(WUPINPUTl1_k:1) WUPINPUTl1  WUPINPUTl1_i;

       //   .Startpunkt suchen
             #LBLBTENR = WUPINPUTl1_i.LBLBTENR;
             exec sql
                SELECT max(rrn(wupinput)) into :§rrn
                FROM wupinput WHERE LBLBTENR = :#LBLBTENR
                                       and status='10';
             exec sql
                select
                   stock,   wupkey,   LBLBDAKY,   sort,   LBLBBDAT,   AELFNR
                into
                  :#stock, :#wupkey, :#LBLBDAKY, :#sort, :#LBLBBDAT, :#AELFNR
                from wupinput where rrn(wupinput) = :§rrn;

       //    §LBLBDAKY  =  #LBLBDAKY;
             %subst(§LBLBDAKY:01:10)=%subst(#wupkey:14:10);
             §stock     =  #stock;
             §aelfnr    =  #aelfnr;
       //   ....

             dow not %eof(WUPINPUTl1);
       //   ....
             if  WUPINPUTl1_i.LBLBTENR = '9600026790';
                 WUPINPUTl1_i.LBLBTENR = '9600026790';
             endif;
       //   ....
             if  WUPINPUTl1_i.status   = *blank;
       //       WUPINPUTl1_i.status = '91';
                if    ((§LBLBTENR = WUPINPUTl1_i.LBLBTENR)
                   or ( §LBLBTENR = *blank));
                if §aelfnr = *blank;
                   exsr  bwaeread;
                endif;
                select;
                when %subst(WUPINPUTl1_i.sort:02:03) ='950'
                     and §stock = *zero
                     and §runon = *zero
                     and WUPINPUTl1_i.status = '  ';
                   §runon = 1;
                   WUPINPUTl1_i.stock  =
                   WUPINPUTl1_i.#LBLBLMIN + WUPINPUTl1_i.MENGE;
                   WUPINPUTl1_i.stock  =    WUPINPUTl1_i.MENGE;
                   §LBLBDAKY = WUPINPUTl1_i.LBLBDAKY;
                   §stock    = WUPINPUTl1_i.stock;
                   §aelfnr   = WUPINPUTl1_i.aelfnr;
                   WUPINPUTl1_i.status = '20';
                   WUPINPUTl1_i.upd    = #upd;
                   breakpoint = '1';
                when %subst(WUPINPUTl1_i.sort:02:03) ='130'
                     and WUPINPUTl1_i.status = '  '
                     and (WUPINPUTl1_i.LBLBBDAT = #LBLBBDAT or
                          WUPINPUTl1_i.LBLBBDAT > #LBLBBDAT or
                               #LBLBBDAT=*zero)
                     and  (§stock > (WUPINPUTl1_i.MENGE*-1)
                        or §stock = (WUPINPUTl1_i.MENGE*-1));
                   WUPINPUTl1_i.stock  =
                   §stock              + WUPINPUTl1_i.MENGE;
                   §stock    = WUPINPUTl1_i.stock;
                   WUPINPUTl1_i.wupkey = WUPINPUTl1_i.LBLBLANR +
                                 %subst(WUPINPUTl1_i.LBLBDAKY:01:10) +
                                         %subst(§LBLBDAKY:01:10);
                   WUPINPUTl1_i.wupwe  = %subst(§LBLBDAKY:01:10);
                   WUPINPUTl1_i.aelfnr = §aelfnr;
                   WUPINPUTl1_i.status = '10';
                   WUPINPUTl1_i.upd    = #upd;
                   breakpoint = '1';
                other;
                endsl;
                exsr  bwaeread;
                if %subst(WUPINPUTl1_i.sort:02:03) ='130'
                or %subst(WUPINPUTl1_i.sort:02:03) ='950';
                else;
       //   .  es gibt zwei Gruppen, Eingang oder Ausgang derzeit in code nur 130 und 950
       //   .  130 Verbräuche an Kunden als GRUPPE ==> '0130'
       //   .  950 WE's als GRUPPE ==> '0950'
       //   .  der Rest wird auf Status 99 gesetzt, uninteressant
                   WUPINPUTl1_i.status = '99';
                endif;
                WUPINPUTl1_o = WUPINPUTl1_i;
                §LBLBTENR = WUPINPUTl1_i.LBLBTENR;
                §sort     = WUPINPUTl1_i.sort;
                update phy01r   WUPINPUTl1_o;
                endif;
             endif;
             reade %kds(WUPINPUTl1_k:1) WUPINPUTl1  WUPINPUTl1_i;
             if  §LBLBTENR <> WUPINPUTl1_i.LBLBTENR;
       //   .Startpunkt suchen Wechsel Artikel
           §LBLBTENR   = *Blank;
           §sort       = *Blank;
           §LBLBDAKY   = *Blank;
           §AELFNR     = *Blank;
           §stock      = *zero;
           §runon      = *zero;
                #LBLBTENR  = *blank;
                #stock     = *zero;
                #wupkey    = *blank;
                #sort      = *blank;
                #AELFNR    = *blank;
                #LBLBDAKY  = *blank;
                #LBLBBDAT  = *zero;
                §rrn       = *zero;
                #LBLBTENR = WUPINPUTl1_i.LBLBTENR;
                exec sql
                   SELECT max(rrn(wupinput)) into :§rrn
                   FROM wupinput WHERE LBLBTENR = :#LBLBTENR
                                          and status='10';
                exec sql
                   select
                    stock,   wupkey,   LBLBDAKY,   sort,   LBLBBDAT,   AELFNR
                   into
                   :#stock, :#wupkey, :#LBLBDAKY, :#sort, :#LBLBBDAT, :#AELFNR
                   from wupinput where rrn(wupinput) = :§rrn;

       //       §LBLBDAKY  =  #LBLBDAKY;
                %subst(§LBLBDAKY:01:10)=%subst(#wupkey:14:10);
                §stock     =  #stock;
                §aelfnr    =  #aelfnr;
                endif;
             enddo;
          close WUPINPUTl1;

       endsr;

       //-----------------------------------------------------------------------
       //lesen bwae07
       //-----------------------------------------------------------------------

       begsr bwaeread;
       //waea
       if %subst(WUPINPUTl1_i.sort:02:03) ='950' and
          %subst(WUPINPUTl1_i.LBLBDAKY:1:4) <> '    ';
          Bwae07_k.AeFirm = '01';
          Bwae07_k.AeWeJJ = %dec(%subst(WUPINPUTl1_i.LBLBDAKY:1:4):4:0);
          Bwae07_k.AeWeNr = %subst(WUPINPUTl1_i.LBLBDAKY:5:6);

          setll %kds(Bwae07_K:3) Bwae07;
          reade %kds(Bwae07_K:3) Bwae07 Bwae07_I;

          dow not %eof(Bwae07);
           reade %kds(Bwae07_K:3) Bwae07 Bwae07_I;
           WUPINPUTl1_i.AELFNR = bwae07_i.AELFNR;
          enddo;
        endif;

       endsr;

       //-----------------------------------------------------------------------
       //ready for WUP, nach erfolgreicher Übertragung werden die Sätze
       //beim nächsten Lauf in die wuphistory überführt
       //restart erfolgt über WUPoutputl_k.VBKZ  =  *blank setzen
       //                                      und 0 restart für WUP
       //-----------------------------------------------------------------------

       begsr sr_lpif;
          open  WUPoutputl;
          WUPoutputl_k.VBKZ  =  *blank;
          setll %kds(WUPoutputl_k:1) WUPoutputl;
          reade %kds(WUPoutputl_k:1) WUPoutputl  WUPoutputl_i;
          dow not %eof(WUPoutputl);
       //   teilweise fehlt der AELFNR (Gruppenwechsel oben) hier nachlesen
       //   TCT = '2' = Wareneingang, TCT = '1' = Verbrauch
             if  WUPoutputl_i.AELFNR   = *blank;
                Bwae07_k.AeFirm = '01';
                Bwae07_k.AeWeJJ = %dec(%subst(WUPoutputl_i.WUPWE:1:4):4:0);
                Bwae07_k.AeWeNr = %subst(WUPoutputl_i.WUPWE:5:6);

                setll %kds(Bwae07_K:3) Bwae07;
                reade %kds(Bwae07_K:3) Bwae07 Bwae07_I;

                dow not %eof(Bwae07);
                    reade %kds(Bwae07_K:3) Bwae07 Bwae07_I;
                    WUPoutputl_i.AELFNR = bwae07_i.AELFNR;
                enddo;
             endif;
       //   Lpif
             Lpif01_k.LPFIRM       =  '01';
             Lpif01_k.LPLFNR       =  WUPoutputl_i.AELFNR;
             Lpif01_k.LPTENR       =  WUPoutputl_i.LBLBTENR;
             if  WUPoutputl_i.LBLBBDAT = *zero;
                 Lpif01_k.LPGADA        =  %dec(%char(%date():*iso0):8:0);
             else;
                 Lpif01_k.LPGADA        =  WUPoutputl_i.LBLBBDAT;
             endif;

             land01_i.LNLDNR  = *blank;
             land01_i.LNLDGR  = *blank;
       //   Lpif  Lpif_i.LPHKLD lesen land
       //    setll %kds(Lpif01_k:3) Lpif01;
       //    reade %kds(Lpif01_k:3) Lpif01 Lpif01_I;
             setgt %kds(Lpif01_k:3) Lpif01;
             readp Lpif01 Lpif01_I;
             dow not %eof(Lpif01);
                 if Lpif01_i.LPFIRM  =  '01'                  and
                    Lpif01_i.LPLFNR  =  WUPoutputl_i.AELFNR   and
                    Lpif01_i.LPTENR  =  WUPoutputl_i.LBLBTENR;
                    if Lpif01_i.LPGADA  =  *zero or
                       Lpif01_i.LPGADA  =  WUPoutputl_i.LBLBBDAT;
                       land01_k.LNLDNR  = Lpif01_i.LPHKLD;
       //   Land lesen
                          chain %kds(land01_k:1) land01 land01_I;
                          if %found(land01) and
                             land01_i.LNLDNR  = Lpif01_i.LPHKLD;
                          else;
                             land01_i.LNLDNR  = *blank;
                             land01_i.LNLDGR  = *blank;
                          endif;
                       leave;
                    else;
                       readp Lpif01 Lpif01_I;
                    endif;
                 else;
                    leave;
                 endif;
             enddo;
             WUPoutputl_o = WUPoutputl_i;
             WUPoutputl_o.LNLDNR = land01_i.LNLDNR;
             WUPoutputl_o.LNLDGR = land01_i.LNLDGR;
             if land01_i.LNLDGR = '0001' or
                land01_i.LNLDGR = '0002';
             else;
       //       WUPoutputl_o.status = 9;
       //       WUPoutputl_o.tct    ggf. sichern vorher
       //       WUPoutputl_o.tct    = 'F';
             endif;
             WUPoutputl_o.VBKZ = '1';
             If WUPoutputl_o.WUPWE = '2022259139';
                WUPoutputl_o.VBKZ = ' ';
             endif;
             update phy02r   WUPoutputl_o;
          reade %kds(WUPoutputl_k:1) WUPoutputl  WUPoutputl_i;
          enddo;
          close WUPoutputl;

       endsr;
       // ______________________________________________________________________
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


