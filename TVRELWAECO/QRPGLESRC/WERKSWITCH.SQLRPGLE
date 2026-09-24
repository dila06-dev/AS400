
      //************************************************************************
      //
      //      Programmname       WERKSWITCH
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       ...........................
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   ! MODWAO/QCLPSRC
      //  tt.mm.jjjj  xx01  .............. !      STRMODWAO
      //                                   !
      //                                   ! a1#1='1'
      //                                   !
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
     D p_inFIL         s             25a   inz

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

       // Aufruf Edison Auftragsverarbeitung in Trend
       // ______________________________________________________________________
     d TRED80SJ        PR                  ExtPgm('TRED80SJ')
     d Ver_lib                       10a
     d Ver_firma                      2a
       // ______________________________________________________________________
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
     D error1          s              1a   inz

     d Ver_lib         s             10a
     d Ver_firma       s              2a

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start WERKSWITCH                             ';
       exsr      SR_log;


       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
          exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

       eval status ='Ende WERKSWITCH                              ';
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

       if err_msg = ' ';
          eval   Ver_lib='MODWAO    ';
          eval   Ver_firma='01';
          callP  TRED80SJ(Ver_lib: Ver_firma);

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(GANG) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(GANG) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(TVRELWAECO) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(TVRELWAECO) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;



       //Protokoll Job_run für werk 010 ORDERS
          exec sql
            INSERT INTO TVRELWAECO/JOB_RUN
            SELECT 'WERKSWITCH' ,current timestamp, current date,
             current time, 'Ref: ' concat IFAKREF1
             concat 'Kunde: ' concat IFAKKDNR concat  ' Key: ' concat IFAKIFNR
            FROM TVPF/ifak01 a  WHERE IFakIFFI ='01' and IFAKWKNR='001' and
            IFakIFFI in ( SELECT IFedIFFI FROM TVPF/ifed01 WHERE IFEDLFBK =
            '7315090000001' and a.IFAKIFNR =IFedIFNR);

       //keine weiteren Prüfungen oder Aktivitäten
       //Umbuchung auf anderes Werk direkt! ORDERS
          exec sql
            update TVPF/ifak01 set IFAKWKNR='010'
            WHERE IFakIFFI ='01' and IFAKWKNR='001' and
            IFAKWKNR <> '010' and
            IFakIFFI in
             (SELECT IFedIFFI FROM TVPF/ifed01 WHERE IFEDLFBK =
            '7315090000001' and IFAKIFNR =IFedIFNR);

       //Auftragsart ändern auf 54, war vorher immer 25,
       //da Standarddefinition über EDI 01 Eddyson
       //I28 Aktionsgeschäft IGLOO
          exec sql
            update TVPF/ifak01 set IFAKAFAT='54 '
            WHERE IFakIFFI ='01' and IFAKWKNR='010' and
                  IFAKAFAT <> '54'                 and
            IFakIFFI in
             (SELECT IFedIFFI FROM TVPF/ifed01 WHERE IFEDLFBK =
            '7315090000001' and IFAKIFNR =IFedIFNR);

       // für             Testfälle und Umgebung
       //Feststellung, ob Testfälle und Protokollieren
       //ORDERS, und a1#1='1' bedeutet Teastfälle!
       //Achtung edi Aufträge unter 01 haben/sollten immer Mandant 01 haben
       //Achtung bitte auf Lieferadresse achten VSEDIL => GLN-Nummer !!!
       //ansonsten landet der Auftrag in der Echtumgebung
       //a14#1 Werks#, a14#2 Abladestelle integriert 29.22.2023
          exec sql
            insert   into tvrelwaeco/edi_test
            SELECT a.maikey, a.a35#07, a.a35#01, a.a17#3,
                   VSEDIL, VSKDNR ,IFAKIFNR, ifakkdnr,
                   a14#1, a14#2,
                   char(' ', 1) status, current timestamp as tstamp FROM
            edifact/stddat a, tvpf/kdvs01, tvpf/ifak01 WHERE
            MSGTYP = 'ORDERS' and
            (VSEDIL=a17#3 and a17#3<>' ') and vsfirm='01' and
            a1#1='1' and
            IFAKIFFI='01' and                   IFAKref1= a35#07
       //!! IFAKIFFI='01' and ifakfirm='01' and IFAKref1= a35#07    !!!
             and a.maikey not in (select b.maikey from edi_test b where
                 a.a35#07=b.a35#07);

       // für             Testfälle und Umgebung
       //Kunde DAF: IFAKref1 enthält den Warenempfänger, wird
       //als a17#3 in STDDAT übertragen
       //a14#1 Werks#, a14#2 Abladestelle integriert 29.22.2023
       //

          exec sql
            insert   into tvrelwaeco/edi_test
            SELECT a.maikey, a.a35#07, a.a35#01, a.a17#3,
                   VSEDIL, VSKDNR ,IFAKIFNR, ifakkdnr,
                   a14#1, a14#2,
                   char(' ', 1) status, current timestamp as tstamp FROM
            edifact/stddat a, tvpf/kdvs01, tvpf/ifak01 WHERE
            MSGTYP = 'ORDERS' and
            (VSEDIL=a17#3 and a17#3<>' ') and vsfirm='01' and
            a1#1='1' and
            IFAKIFFI='01' and                   IFAKref1= a17#3
       //!! IFAKIFFI='01' and ifakfirm='01' and IFAKref1= a35#07    !!!
             and a.maikey not in (select b.maikey from edi_test b where
                 a.a35#07=b.a35#07);


       // für             Testfälle und Umgebung
       //Feststellung, ob Testfälle und Protokollieren
       //ORDERS, und a1#1='1' bedeutet Teastfälle!
       //Achtung edi Aufträge unter 01 haben/sollten immer Mandant 01 haben
       //Erweiterung: Die Funktion schliesst jetzt auch Eingänge ein,
       //die ein TestByte haben aber keine Zuordnung zu Lieferadressen
       //a14#1 Werks#, a14#2 Abladestelle integriert 29.22.2023
          exec sql
            insert   into tvrelwaeco/edi_test
            SELECT a.maikey, a.a35#07, a.a35#01, a.a17#3,
                   '  ',   '  '   ,IFAKIFNR, ifakkdnr,
                   a14#1, a14#2,
                   char(' ', 1) status, current timestamp as tstamp FROM
            edifact/stddat a, ifak01 WHERE MSGTYP = 'ORDERS' and
            (a17#3 <> ' ') and
            a1#1='1' and
            IFAKIFFI='01' and  IFAKref1= a35#07
             and a.maikey not in (select b.maikey from edi_test b where
                 a.a35#07=b.a35#07);


       //Zwischensicherung wenn Abladestelle und nicht TEST
       //Zwischensicherung der Verladestelle in tvrelwaeco/edi_prod
       //a14#2 Abladestelle und nicht !!! test also a1#1<>'1'
       //a14#1 Kundenwerk oder a14#2 (AbSt) muss befuehlt sein

          exec sql
            insert into tvrelwaeco/edi_prod
            SELECT distinct a.maikey, a.a35#07, a.a35#01, a.a17#3,
                   VSEDIL, VSKDNR ,IFAKIFNR, ifakkdnr,
                   a14#1, a14#2,
                   char(' ', 1) status, current timestamp as tstamp FROM
            edifact/stddat a, tvpf/kdvs01, tvpf/ifak01 WHERE
            MSGTYP = 'ORDERS' and
            (VSEDIL=a17#3 and a17#3<>' ') and vsfirm='01' and
            (a14#1 <> ' ' or a14#2 <> ' ') and
            a1#1<>'1' and IFAKref1= a35#07 and
            (a14#1<>' ' or a14#2<>' ') and HRCLVL = '100000000' and
            CHAR(substr(a.WRTDAT, 1, 4), 4)=CHAR(substr(IFAKIFNR, 1, 4), 4)
            and a.maikey not in
            (select b.maikey from tvrelwaeco/edi_prod b where
             a.a35#07=b.a35#07);


       //Achtung Werknummer und Abladestelle des Kunden nachträglich updaten
       //nach Trentlauf (Erstellung IFAK-Daten für den Auftrag)
       //diese werden in der Folge für DESADV benötigt, siehe update AKTIVBANKR
       //ORDRSP benötigt
       //ifed
         exec sql
         update TVPF/IFed01 a   set (a.IFEDWKKD, a.IFEDABST)=
         (SELECT distinct  b.IFEDWKKD, b.IFEDABST FROM tvrelwaeco/edi_prod b
         where a.IFedIFFI ='01' and a.IFedIFNR  = b.IFAkIFNR and
         (b.IFEDWKKD <> ' ' or  b.IFEDABST <> ' ') and b.status = ' ')
         where exists
         (SELECT distinct b.IFEDWKKD, b.IFEDABST FROM tvrelwaeco/edi_prod b
         where a.IFedIFFI ='01' and a.IFedIFNR  = b.IFAkIFNR and
         (b.IFEDWKKD <> ' ' or  b.IFEDABST <> ' ') and b.status = ' ');

       //insert into Test environment aufgrund der
       //Feststellung, ob Testfälle und des Protokolls

       //ifak  99
         exec sql
         insert into TVPFtest/ifak01
         SELECT * FROM TVPF/ifak01 a
         where a.IFAKIFFI ='01'  and
               a.IFAKIFNR in (select b.IFAKIFNR from tvrelwaeco/edi_test b
                              where  a.IFAKKDNR = b.IFAKKDNR  and status=' ')
                              and
               a.IFAKIFNR not in (select b.IFAKIFNR from TVPFtest/ifak01 b
                     where b.IFAKIFFI ='01' and
                           a.IFAKKDNR = b.IFAKKDNR);

       //ifap
         exec sql
         insert into TVPFtest/ifap01
         SELECT * FROM TVPF/ifap01 a
         where a.IFApIFFI ='01'  and
               a.IFApIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFApIFNR not in (select b.IFApIFNR from TVPFtest/ifap01 b
                     where b.IFApIFFI ='01');

       //ifad
         exec sql
         insert into TVPFtest/ifad01
         SELECT * FROM TVPF/ifad01 a
         where a.IFAdIFFI ='01'  and
               a.IFAdIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAdIFNR not in (select b.IFAdIFNR from TVPFtest/ifad01 b
                     where b.IFAdIFFI ='01');

       //ifat
         exec sql
         insert into TVPFtest/ifat01
         SELECT * FROM TVPF/ifat01 a
         where a.IFAtIFFI ='01'  and
               a.IFAtIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAtIFNR not in (select b.IFAtIFNR from TVPFtest/ifat01 b
                     where b.IFAtIFFI ='01');

       //ifan
         exec sql
         insert into TVPFtest/ifan01
         SELECT * FROM TVPF/ifan01 a
         where a.IFAnIFFI ='01'  and
               a.IFAnIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAnIFNR not in (select b.IFAnIFNR from TVPFtest/ifan01 b
                     where b.IFAnIFFI ='01');

       //ifed
         exec sql
         insert into TVPFtest/IFed01
         SELECT * FROM TVPF/IFed01 a
         where a.IFedIFFI ='01'  and
               a.IFedIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFedIFNR not in (select b.IFedIFNR from TVPFtest/ifed01 b
                     where b.IFedIFFI ='01');

       //ifep
         exec sql
         insert into TVPFtest/IFep01
         SELECT * FROM TVPF/IFep01 a
         where a.IFepIFFI ='01'  and
               a.IFepIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFepIFNR not in (select b.IFepIFNR from TVPFtest/IFep01 b
                     where b.IFepIFFI ='01');

       //modwao
       //exec sql
       //insert into modwaotest/wao8
       //SELECT * FROM modwao/wao8 a
       //WHERE a.wao8IFFI ='00099' and a.wao8IFNR not in
       //(select b.wao8IFNR from modwaotest/wao8 b
       // where b.wao8IFFI ='00099');


       //delete from Prod environment

       //ifak  99
         exec sql
         delete   FROM TVPF/ifak01 a
         where a.IFAKIFFI ='01'  and
               a.IFAKIFNR in (select b.IFAKIFNR from tvrelwaeco/edi_test b
                              where  a.IFAKKDNR = b.IFAKKDNR  and status=' ')
                              and
               a.IFAKIFNR     in (select b.IFAKIFNR from TVPFtest/ifak01 b
                     where b.IFAKIFFI ='01' and
                           a.IFAKKDNR = b.IFAKKDNR);

       //ifap
         exec sql
         delete   FROM TVPF/ifap01 a
         where a.IFApIFFI ='01'  and
               a.IFApIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFApIFNR     in (select b.IFApIFNR from TVPFtest/ifap01 b
                     where b.IFApIFFI ='01');

       //ifad
         exec sql
         delete   FROM TVPF/ifad01 a
         where a.IFAdIFFI ='01'  and
               a.IFAdIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAdIFNR     in (select b.IFAdIFNR from TVPFtest/ifad01 b
                     where b.IFAdIFFI ='01');

       //ifat
         exec sql
         delete   FROM TVPF/ifat01 a
         where a.IFAtIFFI ='01'  and
               a.IFAtIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAtIFNR     in (select b.IFAtIFNR from TVPFtest/ifat01 b
                     where b.IFAtIFFI ='01');

       //ifan
         exec sql
         delete   FROM TVPF/ifan01 a
         where a.IFAnIFFI ='01'  and
               a.IFAnIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFAnIFNR     in (select b.IFAnIFNR from TVPFtest/ifan01 b
                     where b.IFAnIFFI ='01');

       //ifed
         exec sql
         delete   FROM TVPF/IFed01 a
         where a.IFedIFFI ='01'  and
               a.IFedIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFedIFNR     in (select b.IFedIFNR from TVPFtest/ifed01 b
                     where b.IFedIFFI ='01');

       //ifep
         exec sql
         delete   FROM TVPF/IFep01 a
         where a.IFepIFFI ='01'  and
               a.IFepIFNR in (select b.IFAkIFNR from tvrelwaeco/edi_test b
                              where                               status=' ')
                              and
               a.IFepIFNR     in (select b.IFepIFNR from TVPFtest/IFep01 b
                     where b.IFepIFFI ='01');

       //modwao
       //exec sql
       //insert into modwaotest/wao8
       //SELECT * FROM modwao/wao8 a
       //WHERE a.wao8IFFI ='00099' and a.wao8IFNR not in
       //(select b.wao8IFNR from modwaotest/wao8 b
       // where b.wao8IFFI ='00099');


         exec sql
          update tvrelwaeco/edi_test
          set status = '1' where status =' ';

         exec sql
          update tvrelwaeco/edi_prod
          set status = '1' where status =' ';
       endif;

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


