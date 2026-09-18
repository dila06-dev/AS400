
      //************************************************************************
      //
      //      Programmname       URSPRUNGR
      //      Erstellt  am       14.03.2023
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Ursprungsland Korrektur
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
      //
      //
      //
      //
      //
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
     hALWNULL(*USRCTL)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     fURSPRUNGl1uf   e           k DISK    usropn
     f                                     RENAME(URSPRUNG:PHY01R)

      //bwae07    if   e           k DISK

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
     d URSPRUNGl1_i  e ds                  ExtName(URSPRUNGl1:*input)
     d                                     Qualified

     d URSPRUNGl1_o  E DS                  ExtName(URSPRUNGl1:*output)
     d                                     Qualified

     d URSPRUNGl1_k  E DS                  ExtName(URSPRUNGl1:*key)
     d                                     Qualified

      //Bwae07_k      E DS                  ExtName(Bwae07:*key)
      //                                    Qualified
      //Bwae07_I      E DS                  ExtName(bwae07:*input)
      //                                    Qualified


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
     D p_inFIL         s             22a

      /eject
     IPHY01R
     I              status                      §status

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start FTP Transfer for URSPRUNGR    ';
       exsr      SR_log;
       //Bereinigung

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/URSPRUNG)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/URSPRUNG)      ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/URSPRUNG)     ';
       endmon;

       //Zuordnungen Stammlieferent
       exec sql
        insert into TVRELWAECO/ursprung
        SELECT char('1', 1) f1,
               TEFIRM,TETENR,TETEST,TEERTE,TESAAV,TEDIAV,TESTLF,
        TELFNR,TEZOTN,TEURLD,TEZPUR,lfLFNR,lfland,LFLFST,LFEGKZ,
        LPLFNR,LPSTAT,       LPIDEN,LPHKLD,       char(' ', 4) #TEEWITTY,
        char('  ', 2) status,  current timestamp  tstamp
        from tvpf/teil01 inner join tvpf/lief01
                         on tefirm=LFFIRM and
                            TESTLF=LFLFNR
                         inner join tvpf/lpif01
                         on tefirm=LpFIRM and
                            TESTLF=LpLFNR and
                            TEtenr=Lptenr
        where tefirm='01';

       //Zuordnungen, wo nicht der Stammlieferant eine Verbindung hat
       //zum Artikel (alternative Lieferanten)
       exec sql
        insert into TVRELWAECO/ursprung
        SELECT char('2', 1) f1,
               TEFIRM,TETENR,TETEST,TEERTE,TESAAV,TEDIAV,TESTLF,
        TELFNR,TEZOTN,TEURLD,TEZPUR,lfLFNR,lfland,LFLFST,LFEGKZ,
        LPLFNR,LPSTAT,       LPIDEN,LPHKLD,       char(' ', 4) #TEEWITTY,
        char('  ', 2) status,  current timestamp  tstamp
        from tvpf/lpif01 inner join tvpf/teil01
                         on tefirm=LpFIRM and
                            tetenr=Lptenr and
                            TESTLF<>LpLFNR
                         inner join tvpf/lief01
                         on lpfirm=LFFIRM and
                            lplfnr=LFLFNR
        where lpfirm='01';

       //Zuordnungen fehlender Stammlieferent oder Artikelzuordnung
       exec sql
        insert into TVRELWAECO/ursprung
        SELECT char('3', 1) f1,
               TEFIRM,TETENR,TETEST,TEERTE,TESAAV,TEDIAV,TESTLF,
        TELFNR,TEZOTN,TEURLD,TEZPUR,lfLFNR,lfland,LFLFST,LFEGKZ,
        LPLFNR,LPSTAT,       LPIDEN,LPHKLD,       char(' ', 4) #TEEWITTY,
        char('  ', 2) status,  current timestamp  tstamp
        from tvpf/teil01 left  join tvpf/lief01
                         on tefirm=LFFIRM and
                            TESTLF=LFLFNR
                         left  join tvpf/lpif01
                         on tefirm=LpFIRM and
                            TESTLF=LpLFNR and
                            TEtenr=Lptenr
        where tefirm='01' and
              (LFLFNR is null or LPLFNR is null);

       exec sql
        update ursprung set   LFLFNR = ' ' WHERE LFLFNR is null;
       exec sql
        update ursprung set   LFLAND = ' ' WHERE LFLAND is null;
       exec sql
        update ursprung set   LFLFST = ' ' WHERE LFLFST is null;
       exec sql
        update ursprung set   LFEGKZ = ' ' WHERE LFEGKZ is null;

       exec sql
        update ursprung set   LPLFNR = ' ' WHERE LPLFNR is null;
       exec sql
        update ursprung set   LPIDEN = ' ' WHERE LPIDEN is null;
       exec sql
        update ursprung set   LPHKLD = ' ' WHERE LPHKLD is null;
       exec sql
        update ursprung set   LPSTAT = ' ' WHERE LPSTAT is null;

       exec sql
        update        ursprung set #TEEWITTY =
        (select TEEWITTY from teew01 where
               TEEWFIRM ='01' and tetenr=TEEWtenr)
        where exists
        (select TEEWITTY from teew01 where
               TEEWFIRM ='01' and tetenr=TEEWtenr);

       //F1
       //Artikel inaktiv Lpif aber aktiv theoretisch
       //mit gleichen zugeordneten Hauptlieferanten TESTLF = LPLFNR
       exec sql
        update ursprung set status='F1'
        where
        tetest='90' and LPSTAT <> '90' and TESTLF = LPLFNR;

       //F2
       //Lieferant inaktiv Lpif aber aktiv theoretisch
       //mit gleichen zugeordneten Hauptlieferanten LFLFST = LPLFNR
       exec sql
        update ursprung set status='F2'
        where
        LFLFST='90' and LPSTAT <> '90' and LFLFST = LPLFNR;

       //F9
       //Ursprungsland unterschiedlich bei aktiven Sätzen und
       //mit gleichen zugeordneten Hauptlieferanten TEURLD <> LPHKLD
       exec sql
        update ursprung set status='F9'
        where
        tetest <> '90' and LFLFST <>'90' and LPSTAT <> '90' and F1 ='1'
        and TEURLD <> LPHKLD;

       exsr SR_output;

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

       eval status ='Ende  FTP Transfer for URSPRUNGR    ';
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
       //create index tvrelwaeco/ursprungl1 on tvrelwaeco/ursprung
       //(tefirm, tetenr)
       //-----------------------------------------------------------------------

       begsr wupupdate;

       //...
          open  URSPRUNGl1;
             URSPRUNGl1_k.tefirm  =  '01';
             setll %kds(URSPRUNGl1_k:1) URSPRUNGl1;
             reade %kds(URSPRUNGl1_k:1) URSPRUNGl1  URSPRUNGl1_i;
             dow not %eof(URSPRUNGl1);
       //   ....
       //       exsr  bwaeread;
                URSPRUNGl1_o = URSPRUNGl1_i;
                update phy01r   URSPRUNGl1_o;
                reade %kds(URSPRUNGl1_k:1) URSPRUNGl1  URSPRUNGl1_i;
             enddo;
          close URSPRUNGl1;

       endsr;

       //-----------------------------------------------------------------------
       //lesen bwae07
       //-----------------------------------------------------------------------


       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;


       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(tvrelwaeco/URSPRUNGo)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(tvrelwaeco/URSPRUNGo)    ';
       on-error;
          status='Error by clrpfm object (tvrelwaeco/URSPRUNGo)   ';
       endmon;


       exec sql
         insert into tvrelwaeco/URSPRUNGo
         select * from  URSPRUNG
         where tstamp > current timestamp -1 hour;

       //exec sql
       //  insert into tvrelwaeco/URSPRUNGO
       //  SELECT FKT, ITEM, ITEMNAME, BACKCURV, BACKCURP, ROOTCAUSE,
       //  LIEFERANT, SUPNAME, FORECAST, ONSTOCK, ARRIVALW1, ARRIVALW2,
       //  ARRIVALW3, ARRIVALW4, ARRIVALW5, ARRIVALW6, DISPONENT, INFO,
       //  TSTAMP, RRN# FROM backorders
       //  WHERE tstamp > current timestamp -02 hour;
       //                                          and FKT =' ';

         eval p_infil   =  'URSPRUNGO'         +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'URSPRUNGO';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/SCM/URSPRUNGO*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed URSPRUNGO*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object URSPRUNGO*                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'URSPRUNGO';

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
          status='Error by CVTDBF object URSPRUNGO                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'URSPRUNGO';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/SCM/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/URSPRUNGO)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/URSPRUNGO)    ';
       endmon;

       //...
       //'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT10) '  +
           'FORMTYPE(''URSPRUNGO'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'URSPRUNGO';

       //-----------------------------------------------------------------------
       //'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
       //''' '' '' '' '' '')';
       //-----------------------------------------------------------------------
       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT10'' ' +
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


