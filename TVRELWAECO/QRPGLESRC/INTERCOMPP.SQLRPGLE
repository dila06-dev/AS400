
      //************************************************************************
      //
      //      Programmname       INTERCOMPp
      //      Erstellt  am       11.05.2021
      //      Erstellt von       M.Gang
      //
      //      Beschreibung Ablauf
      //
      //      step 1a: input mit status: '000'
      //      step 1b: ggf. weitere Aufbereitungen (Incoterms, Impex etc.)
      //      step 1c: input mit status: '000' ==> ändern auf status: '010'
      //                nur status '010' wird von boomi erkannt!
      //
      //      step:2a: input by boomi
      //                wenn msgcode ='855' und UPDATEMODE ='010'
      //                (Sätze kommen so original von boomi als confirmation)
      //                ==> ändern auf status: '020'
      //                ==> Aufbereitung für srconfirm-Routine
      //      step:2b: in srconfirm-Routine
      //                records in files ifbk/ifbp erstellen
      //                nicht veränderbare Bedingungen setzen aus Bestellung
      //                status ändern auf 20 Kopf/Position
      //                von updatemode = '020' ändern auf updatemode = '030'
      //
      //      step 3a: Rückmeldungen verarbeiten (von boomi geänderte Sätze,
      //                also update ursprünglich eingestellter Sätze)
      //      step 3b: UPDATEMODE ='010' = mit Fehler
      //                mit Fehler: RESPCODE <> 'OK' and RESPCODE <> '*  '
      //                verändern neu ==> updatemode='E10'
      //                verändern neu ==> status EKBEST ='92', EPBEST ='92'
      //                (erkennbar aus Fehlerhandlingsdatei DATABOOMI/CHKDATA01)
      //                Fehlermitteilung bei der jeweiligen Position
      //      step 3c: UPDATEMODE ='010' = ohne Fehler
      //                ohne Fehler: RESPCODE =  'OK' and RESPCODE =  '*  '
      //      step 4a: call auf MOIFBP
      //      Mi 12.01.2022 10:48 mail Projekte <projekte@trendswm.de>
      //      ich hbe in der MODWAO1 ein CL Programm abgestellt: MOIFBPSJ
      //      es wird wie folgt gerufen
      //
      //      call moifbpsj ('MODWAO' '01' 'TEST')
      //         'PARM(''MODWAO'' ''01'' ''ECHT'')) ' +
      //
      //      29.05.2022 Änderung bbep für dieses Projekt
      //      test                    produktiv
      //      select from
      //      TVPFTEST/bbek01         TVPF/bbek01
      //      databoomi/intercomp     databoomi/intercompP
      //      TAMFTEST/trtp01         TAMF/trtp01
      //      TVPFTEST/lief01         TVPF/lief01
      //      DATABOOMI/CHKDATA01     DATABOOMI/CHKDATA01P
      //      TVPFTEST/ifbk           TVPF/ifbk
      //
      //      insert/write           update                 delete
      //      databoomi/intercomp    DATABOOMI/intercomp    ./.
      //      DATABOOMI/CHKDATA01
      //      TVPFTEST/ifbk          TVPFTEST/ifbk01
      //      TVPFTEST/ifbp
      //                             TVPFTEST/bbek01
      //                             TVPF1/bbep01
      //
      // join TVPFTEST/bbel01        TVPF/bbel01
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
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
      //
      // SELECT * FROM TVPFTEST/ifbk WHERE IFBkPROG ='INTERCOMP'
      // SELECT * FROM TVPFTEST/ifbp WHERE IFBPPROG ='INTERCOMP'
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
     D p_inFIL         s             44a   inz

       // ______________________________________________________________________
      ///MOIFBP          PR                  ExtPgm('MOIFBP')
     d MOIFBPSJ        PR                  ExtPgm('MOIFBPSJ')
     D p_libr_                       10a
     D p_firma_                      02a
     D p_envir_                      04a
       // ______________________________________________________________________

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

      // MOIFBPSJ
      //------------------------------------------------------------------------
     D p_libr_         s             10a
     D p_firma_        s             02a
     D p_envir_        s             04a

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
     D §DELIVER_N      s             17a   inz
     D key1            s             10a   inz
     D key2            s             50a   inz
     D key3            s             50a   inz
     D WKLIBL          s             10A
     D WKFIRM          s              2A
     D WKENVI          s             10A
     D fkt             s             10A
     D §curlib         s             10A
     D §usrlib         s           2750A


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start: INTERCOMPP databoomi/intercompP             ';
       exsr      SR_log;

       NumSysTime = %Dec(%Time(): *ISO);
         dow NumSysTime < 233000;

          MONITOR;
          Wrk.var1 =
            'DLYJOB DLY(300)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error in command appeared: DLYJOB                 ';
             exsr      SR_log;
          endmon;

          MONITOR;
          Wrk.var1 =
            'CHGJOB CCSID(1144)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error in command appeared: CHGJOB CCSID           ';
             exsr      SR_log;
          endmon;

          NumSysTime = %Dec(%Time(): *ISO);

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';
          MONITOR;
             Wrk.var1 =
                 'CLRPFM FILE(DATABOOMI/CHKDATA01P)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error CLRPFM FILE(DATABOOMI/CHKDATA01P)          ';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
          endmon;


          exsr  srinit;
          exsr  srconfirm;

          eval status ='call moifbpsj start                               ';
                exsr      SR_log;
       //for update files
          p_libr_  = 'MODWAO';
          p_firma_ = '01';
          p_envir_ = 'ECHT';

       //sbmjob    CALL PGM(MODWAO/MOIFBPSJ) PARM('MODWAO' '0
          MONITOR;
             Wrk.var1 =
                 'SBMJOB CMD(CALL PGM(MODWAO/MOIFBPSJ) ' +
                 'PARM(''MODWAO'' ''01'' ''ECHT'')) ' +
                 'JOB(JOB_R) JOBD(GANG/GANG) ' +
                 'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                 'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                 'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                 'GANG )';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error SBMJOB CMD(CALL PGM(MODWAO/MOIFBPSJ))';
                exsr      SR_log;
          endmon;

       // callP MOIFBPSJ(p_libr_: p_firma_: p_envir_);

          eval status ='call moifbpsj ende                                ';
                exsr      SR_log;

       // MONITOR;
       //    Wrk.var1 =
       //        'DSPJOBLOG OUTPUT(*PRINT)';
       //    cmd = %TrimR(Wrk.Var1);
       //    L      = %Len(Cmd);
       //    QCMDEXC(cmd: %len(cmd));
       //    on-error;
       //       status='error  DSPJOBLOG OUTPUT(*PRINT)                 ';
       //       exsr      SR_log;
       // endmon;
         enddo;

       eval status ='Ende INTERCOMPP databoomi/intercompP              ';

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

       //TVPF
       //TVPFTEST
       //Kopf
       //           *blank
       //04         Ausgeben Bestell-Abruf
       //05         Gedruckt
       //08         Übernahme EDIFACT
         exec sql
         insert into databoomi/intercompP
         SELECT   a.ekfirm,a.ekbejj,a.ekbenr,a.ekwknr,a.eklfnr,a.eklfnr
                    #eklfnr,                                   a.EKBEAR,
                  b.eptenr,b.epvste,b.epmeng,b.epmein,b.epmepr,b.epnesu,
                  b.epprei,b.EPBEPO,b.epvsbd,b.eplibd,b.epbete,b.EPWACD,
                  case when b.EPBEAT  = '105' then 'DS '
                  else b.EPBEAT end,
                  ELNAM1, ELNAM2, ELNAM3, ELSTRA, ELPOLD, ELPOLZ,
                  ELWORT, ELHSNR,
                  a.ekbejj  AEWEJJ, a.ekbenr AEWENR,
                  zoned (0000,00, 11, 2) AEMENG,
                  char('*', 15)  AEBLIN,  char('*', 30) AEBUT1,
                  char('*', 3) msgcode,
                  char('*', 3) respcode, char('*', 120) response,
                  current timestamp tstamp,
                  current timestamp modtstamp,
                  current timestamp trdtstamp,
                  char('000', 3) updatemode,
                  char(ekuser, 60) owner
       //Achtung wechsel auf TVPF1!
       // FROM  TVPF/bbek01     a full OUTER JOIN TVPFTEST/bbep01 b
          FROM  TVPF/bbek01     a full OUTER JOIN     TVPF/bbep01 b
                    on a.ekfirm=b.epfirm and
                       a.ekBEJJ=b.epBEJJ and
                       a.ekBENR=b.epBENR and
                       a.ekWKNR=b.epWKNR
       //Achtung bbel01 beachten !!!
                    right outer join TVPF/bbel01
                    on elfirm=b.epfirm and
                        elBEJJ=b.epBEJJ and
                        elBENR=b.epBENR
          where
          (timestamp(substr(char(a.ekJDAT), 1, 8) concat
          char(LPAD(RTrim(a.EkJZEI), 06, '0')) )) > current timestamp -999
          hour  and
          (timestamp(substr(char(b.epJDAT), 1, 8) concat
          char(LPAD(RTrim(b.EpJZEI), 06, '0')) )) > current timestamp -999
          hour
          and a.EKBEAR='A'
          and a.ekfirm='01'
          and a.EKWKNR='001'
          and a.EKBEST in ('  ', '04', '05', '08')
          and b.EPBEST in ('05', '05')
          and ELAART ='BBEL'
          and a.EKFIRM not in
               (select c.EKFIRM from databoomi/intercompP c where
                       c.EKBEJJ = a.EKBEJJ and
                       c.EKBENR = a.EKBENR and
                       c.EKWKNR = a.EKWKNR);
       //Incoterms
       //              c.EPBEPO = b.EPBEPO );

       //Incoterms
         exec sql
         update databoomi/intercompP  set eplibd =
         (select substr(TPTTXT, 1, 3) from TAMF/trtp01
         where TPTART ='LIBD' and TPFIRM='01'
               and TPSPCD = 'D' and TPTNUM =0 and
                   eplibd = TPTCDE  and updatemode='000')
         where exists
         (select substr(TPTTXT, 1, 3) from TAMF/trtp01
         where TPTART ='LIBD' and TPFIRM='01'
               and TPSPCD = 'D' and TPTNUM =0 and
                   eplibd = TPTCDE  and updatemode='000');

       //Konditionslieferant Dometic Impex Co.
         exec sql
         update databoomi/intercompP set eklfnr =
         (select LFKOLF from TVPF/lief01
         where lffirm='01' and LFKOLF ='90733'
               and LFLFNR = eklfnr and updatemode='000')
         where exists
         (select LFKOLF from TVPF/lief01
         where lffirm='01' and LFKOLF ='90733'
               and LFLFNR = eklfnr and updatemode='000');

       //confirmation UPDATEMODE ='020' setzten
       //Nur Rückmeldungen erfolgen so, dass ein Satz geschrieben wird
       //ausgelöst vom Fremsystem Boomi, dieses haben msgcode='855'
         exec sql
         update databoomi/intercompP set
         UPDATEMODE ='020'
         where UPDATEMODE ='010' and
               msgcode ='855';

       //nur wenn alle Positionen fehlerlos über DATABOOMI/CHKDATA01P
         exec sql
         insert into  DATABOOMI/CHKDATA01P
         SELECT EKFIRM,EKBEJJ, EKBENR
         FROM   databoomi/intercompP
         where UPDATEMODE ='010' and
               (RESPCODE <> 'OK' and RESPCODE <> '*  ')
         GROUP BY EKFIRM, EKBEJJ, EKBENR;

       //Status Kopf und Positionen auf 92 setzen im Fehlerfall !!!!!!!!!!!!
       //bbek01 auf status '92'
         exec sql
         update TVPF/bbek01     a set EKBEST ='92'
         where  a.ekFIRM in
         (select b.Ekfirm from DATABOOMI/CHKDATA01P b
          where  a.EKBEJJ =b.EKBEJJ and
                 a.EKBENR =b.EKBENR);

       //bbep01 auf status '92'   !!!!!
         exec sql
       //Achtung wechsel auf TVPF1!
       //update TVPFTEST/bbep01 a set EpBEST ='92'
         update     TVPF/bbep01 a set EpBEST ='92'
         where  a.epFIRM in
         (select b.EkFIRM from DATABOOMI/CHKDATA01P b
          where  a.EpBEJJ =b.ekBEJJ and
                 a.EpBENR =b.ekBENR);

       //bbep01 auf status '92'   !!!!!
         exec sql
       //Achtung wechsel auf TVPF1!
       //update TVPFTEST/bbep01 a set EPTBZ1 =
         update     TVPF/bbep01 a set EPTBZ1 =
         (select substr(RESPONSE, 1, 30) from databoomi/intercompP b
          where  a.EpFIRM =b.ekFIRM and
                 a.EpBEJJ =b.ekBEJJ and
                 a.EpBENR =b.ekBENR and
                 a.EpBEPO =b.epBEPO and
                 MSGCODE ='850' and RESPCODE<>'OK'  and
                 UPDATEMODE ='010')
         where exists
         (select substr(RESPONSE, 1, 30) from databoomi/intercompP b
          where  a.EpFIRM =b.ekFIRM and
                 a.EpBEJJ =b.ekBEJJ and
                 a.EpBENR =b.ekBENR and
                 a.EpBEPO =b.epBEPO and
                 MSGCODE ='850' and RESPCODE<>'OK'  and
                 UPDATEMODE ='010');

       //nur wenn alle Positionen, wenn Fehler E10 Status
         exec sql
         update databoomi/intercompP a set updatemode='E10'
         where a.EKFIRM in
         (select b.ekfirm from DATABOOMI/CHKDATA01P b
          where  a.EKBEJJ =b.EKBEJJ and
                 a.EKBENR =b.EKBENR and
                 UPDATEMODE ='010');

       /// **********************************
       //wenn alle neuen Positionen eingelesen und upgedated status '010'
       //nur diese werden von Boomi gelesen
         exec sql
         update databoomi/intercompP set updatemode = '010'
         where updatemode='000';

         eval status ='INTERCOMPP                                   ';
         exsr      SR_log;

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

       begsr srconfirm;


          MONITOR;
          Wrk.var1 =
            'CHGJOB CCSID(65535)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error in command appeared: CHGJOB CCSID           ';
             exsr      SR_log;
          endmon;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       //confirmedh level
       //Achtung tstamp= key
         exec sql
       //insert into databoomi/confirmedk
         insert into TVPF/ifbk
         select  char(' ', 1) IFBKLOCK,  char('GANG#', 10) IFBKJNAM,
         zoned(('20')
         concat  substr(char(current date +0 day), 7, 2)  concat
         substr(char(current date +0 day), 4, 2)  concat
         substr(char(current date +0 day), 1, 2), 8, 0)   IFBKJDAT,
         zoned(substr(char(current time), 1, 2)  concat
         substr(char(current time), 4, 2)  concat
         substr(char(current time), 7, 2), 6, 0)  IFBKJZEI,
         'INTERCOMPP'                     IFBKUSER,
         char('INTERCOMPP', 10)           IFBKPROG,
         char('TVRELWAECO', 10)           IFBKBIBL,
         ekfirm                           IFBKFIRM,
         TSTAMP                           IFBKTSTP,
         ekBEJJ                           IFBKBEJJ,
         EKBENR                           IFBKBENR,
         '00'                             IFBKSTAT,
         substr(RESPONSE, 1, 15)          IFBKABNR,
         zoned(('20')
         concat  substr(char(current date +0 day), 7, 2)  concat
         substr(char(current date +0 day), 4, 2)  concat
         substr(char(current date +0 day), 1, 2), 8, 0)   IFBKABDA,
         #EKLFNR                          IFBKLFNR,
         'HAA'                            IFBKSABE,
         ' '                              IFBKPJNR,
         ' '                              IFBKLIBD,
         EPVSBD                           IFBKVSBD,
         ' '                              IFBKVPEI,
         ' '                              IFBKZABD,
         ' '                              IFBKEDKY,
         ' '                              IFBKFEHL,
         ' '                              IFBKFREI
         from databoomi/intercompP
         where updatemode = '020' and
               msgcode ='855';

       //confirmedl level
       //Achtung tstamp= key
         exec sql
       //insert into databoomi/confirmedl
         insert into TVPF/ifbp
         select  char(' ', 1) IFBPLOCK,  char('GANG#', 10) IFBPJNAM,
         zoned(('20')
         concat  substr(char(current date +0 day), 7, 2)  concat
         substr(char(current date +0 day), 4, 2)  concat
         substr(char(current date +0 day), 1, 2), 8, 0)   IFBPJDAT,
         zoned(substr(char(current time), 1, 2)  concat
         substr(char(current time), 4, 2)  concat
         substr(char(current time), 7, 2), 6, 0)  IFBPJZEI,
         'INTERCOMPP'                     IFBPUSER,
         char('INTERCOMPP', 10)           IFBPPROG,
         char('TVRELWAECO', 10)           IFBPBIBL,
         ekfirm                           IFBPFIRM,
         TSTAMP                           IFBPTSTK,
         TSTAMP                           IFBPTSTP,
         ekBEJJ                           IFBPBEJJ,
         ekBENR                           IFBPBENR,
         epBEPO                           IFBPBEPO,
         '00'                             IFBPSTAT,
         zoned(('20')
         concat  substr(char(current date +0 day), 7, 2)  concat
         substr(char(current date +0 day), 4, 2)  concat
         substr(char(current date +0 day), 1, 2), 8, 0)   IFBPABDA,
         substr(RESPONSE, 1, 15)          IFBPABNR,
         #EKLFNR                          IFBPLFNR,
         EPTENR                           IFBPTENR,
         EPMENG                           IFBPMENG,
         EPBETE                           IFBPBETE,
         EPVSTE                           IFBPVSTE,
         'LP1 '                           IFBPPRAR,
         EPPREI                           IFBPPREI,
         EPNESU                           IFBPNESU,
         '1'                              IFBPPDIM,
         ' '                              IFBPKON1,
         0                                IFBPKOW1,
         ' '                              IFBPPRZ1,
         ' '                              IFBPPDI1,
         ' '                              IFBPBAS1,
         ' '                              IFBPKON2,
         0                                IFBPKOW2,
         ' '                              IFBPPRZ2,
         ' '                              IFBPPDI2,
         ' '                              IFBPBAS2,
         ' '                              IFBPKON3,
         0                                IFBPKOW3,
         ' '                              IFBPPRZ3,
         ' '                              IFBPPDI3,
         ' '                              IFBPBAS3,
         ' '                              IFBPKON4,
         0                                IFBPKOW4,
         ' '                              IFBPPRZ4,
         ' '                              IFBPPDI4,
         ' '                              IFBPBAS4,
         ' '                              IFBPKON5,
         0                                IFBPKOW5,
         ' '                              IFBPPRZ5,
         ' '                              IFBPPDI5,
         ' '                              IFBPBAS5,
         0                                IFBPCOPY,
         ' '                              IFBPFEHL,
         0                                IFBPNRMG,
         EPMEIN                           IFBPMEIN,
         EPMEPR                           IFBPMEPR,
         ' '                              IFBPBEZ1,
         ' '                              IFBPBEZ2,
         'UPDATE BOOMI'                   IFBPARG1,
         substr(RESPONSE, 1, 15)          IFBPARG2,
         ' '                              IFBPARG3,
         0                                IFBPPOSI,
         ' '                              IFBPFREI
         from databoomi/intercompP
         where updatemode = '020' and
               msgcode ='855';


       //original Bedingungen bleiben erhalten auf Kopf!!
         exec sql
         update TVPF/ifbk01 a set
                (a.IFBKSABE, a.IFBKPJNR, a.IFBKLIBD,
                 a.IFBKVSBD, a.IFBKVPEI, a.IFBKZABD) =
         (select b.EKSABE, b.EKPJNR, b.EKLIBD, b.EKVSBD,
                 b.EKVPEI, b.EKZABD from TVPF/bbek01     b
         where    b.EKFIRM = a.ifbkFIRM and
                  b.EKBEJJ = a.ifbkBEJJ and
                  b.EKBENR = a.ifbkBENR and
         a.ifbkFIRM in
          (select c.EKFIRM from databoomi/intercompP c where
                  c.EKBEJJ = a.ifbkBEJJ and
                  c.EKBENR = a.ifbkBENR and
                  c.updatemode='020'    and
                  c.msgcode ='855'  ))
         where exists
         (select b.EKSABE, b.EKPJNR, b.EKLIBD, b.EKVSBD,
                 b.EKVPEI, b.EKZABD from TVPF/bbek01     b
         where    b.EKFIRM = a.ifbkFIRM and
                  b.EKBEJJ = a.ifbkBEJJ and
                  b.EKBENR = a.ifbkBENR and
         a.ifbkFIRM in
          (select c.EKFIRM from databoomi/intercompP c where
                  c.EKBEJJ = a.ifbkBEJJ and
                  c.EKBENR = a.ifbkBENR and
                  c.updatemode='020'    and
                  c.msgcode ='855'  ));

       //bbek01 auf status '05'
         exec sql
         update TVPF/bbek01     a set EKBEST ='05'
         where  a.ekFIRM in
         (select c.EKFIRM from databoomi/intercompP c where
                 c.EKBEJJ = a.ekBEJJ and
                 c.EKBENR = a.ekBENR and
                 c.updatemode='020'  and
                 c.msgcode ='855'  );

       //bbep01 auf status '05' ==> 30.11.2021 auf '20' setzten
         exec sql
       //Achtung wechsel auf TVPF1!
       //update TVPFTEST/bbep01 a set EpBEST ='05'
         update     TVPF/bbep01 a set EpBEST ='05'
         where  a.epFIRM in
         (select c.EkFIRM from databoomi/intercompP c where
                 c.EKBEJJ = a.epBEJJ and
                 c.EKBENR = a.epBENR and
                 c.updatemode='020'  and
                 c.msgcode ='855'  );

       //confirmation UPDATEMODE ='020' setzten
         exec sql
         update databoomi/intercompP set
         TRDTSTAMP  = current timestamp,
         updatemode = '030'
         where UPDATEMODE ='020' and
               msgcode ='855';

       //for update files
       // if status='xxxxxxxxx';
       //    callP MOIFBP();
       // endif;

         eval status ='INTERCOMPP                                   ';
         exsr      SR_log;

       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'SCHLANSER ';
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


