
      //************************************************************************
      //
      //      Programmname       HELL_LFSR
      //      Erstellt  am       15.06.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Übergabe Hellmann
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
      // SELECT count(*) FROM HELL_LFSP a WHERE status ='1' and a.APANR1 in
      // (SELECT b.APANR1 FROM domdatv7/PSAVEAp b where b.APAPPO = a.APAPPO)
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

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz

      // Überschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start HELL_LFSR                           ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

       if §records <> *zero;
          exsr      SR_report;
          exsr      SR_report2;
       endif;

       endif;

       // ______________________________________________________________________

       eval status ='Ende  HELL_LFSR                         ';
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
              'CLRPFM FILE(tvrelwaeco/HELL_LFS) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/HELL_LFS)             ';
             exsr      SR_log;
       endmon;

       //           TVRELWAECO/HELL_LFSP Protokolleinträge
       //           Achtung: ohne Steuer!!!!   aksteu='HEL'
       //           aksteu=hel neu ab 24.06.2016 Klärung Peter bergmann
       //           hier nachwievor gemäss Absprache
       //           24.06.2016 013 mit aufnehmen als VSBD und wieder entfernt
       //           27.06.2016 013 mit integriert
       //           30.06.2016 013 AKSTS1<>'2'   Mery
       //           01.07.2016 018 vsbd 018 integriert
       //           01.07.2016 018 akfa1 in ('H', 'E', 'S', ' ') reeh mail
       //      1.
       exec sql
         insert into TVRELWAECO/HELL_LFSP
         SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
         apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
         akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
         char(AKTNR)          Auftrag, current timestamp tstamp, APDUUSR,
         APDUUSRB,APAPPO,AKpsts ,apalm , char('0', 1) status,
         current timestamp updated
         FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
         WHERE AKFIRM ='DWI' and AKTOUR ='HELL' and
               akfa1 in ('H', 'E', ' ', 'S') and
               AKAPN  = APAPN and APRESM <> 0   and AKpsts = 20 and
               AKFRG  = 'F'   and AKALKZ = 'A'  and  AKSTS1<>'2' and
               AKVART in ('003', '008', '057', '069', '078', '103',
                          '113', '220', '221', '222', '223', '224',
                          '225', '226', '227', '228', '577', '580', '581',
                          '578', '579', '582', '013', '018', '009', '016',
                          '062', '019'       ) and
               APAPN not  in (select APAPN from HELL_LFSP where
                               PANFpos.APAPPO = HELL_LFSP.APAPPO and
                               PANFpos.apanr1 = HELL_LFSP.apanr1 );

       //           AKTOUR ='SCHWED' and AKSTEU='HEL'
       //      2.   prüfen ob nur noch H
       //           30.06.2016 013 AKSTS1<>'2'   Mery
       //           01.07.2016 018 vsbd 018 integriert
       //           01.07.2016 018 akfa1 in ('H', 'E', ' ') reeh mail
       exec sql
         insert into TVRELWAECO/HELL_LFSP
         SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
         apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
         akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
         char(AKTNR)          Auftrag, current timestamp tstamp, APDUUSR,
         APDUUSRB,APAPPO,AKpsts ,apalm , char('0', 1) status,
         current timestamp updated
         FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
         WHERE AKFIRM ='DWI' and AKTOUR ='SCHWED' and AKSTEU='HEL' and
               akfa1 in ('H', 'E', ' ', 'S')  and AKSTS1<>'2' and
               AKAPN  = APAPN and APRESM <> 0   and AKpsts = 20 and
               AKFRG  = 'F'   and AKALKZ = 'A'  and
               AKVART in ('003', '008', '057', '069', '078', '103',
                          '113', '220', '221', '222', '223', '224',
                          '225', '226', '227', '228', '577', '580', '581',
                          '578', '579', '582', '013', '018', '009', '016',
                          '062', '019'       ) and
               APAPN not  in (select APAPN from HELL_LFSP where
                               PANFpos.APAPPO = HELL_LFSP.APAPPO and
                               PANFpos.apanr1 = HELL_LFSP.apanr1 );


       //           einzelsatz ausnahme   SONDERFALL
       //      3.   prüfen ob nur noch H
       //           30.06.2016 013 AKSTS1<>'2'   Mery
       //           01.07.2016 018 vsbd 018 integriert
       //           01.07.2016 018 akfa1 in ('H', 'E', ' ') reeh mail
       exec sql
         insert into TVRELWAECO/HELL_LFSP
         SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
         apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
         akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
         char(AKTNR)          Auftrag, current timestamp tstamp, APDUUSR,
         APDUUSRB,APAPPO,AKpsts ,apalm , char('0', 1) status,
         current timestamp updated
         FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
         WHERE AKFIRM ='DWI' and
               akfa1 in ('H', 'E', ' ', 'S') and apanr1='K012016227498' and
               AKAPN  = APAPN and APRESM <> 0   and AKpsts = 20 and
               AKFRG  = 'F'   and AKALKZ = 'A'  and AKSTS1<>'2' and
               AKVART in ('003', '008', '029', '057', '069', '078', '103',
                          '113', '129', '220', '221', '222', '223', '224',
                          '225', '226', '227', '228', '577', '580', '581',
                          '578', '579', '582', '013', '018') and
               APAPN not  in (select APAPN from HELL_LFSP where
                              PANFpos.APAPPO = HELL_LFSP.APAPPO and
                              PANFpos.apanr1 = HELL_LFSP.apanr1 );


       //  ....28.06.2016 Freigabe Bley mail von B. Kolthoff Definition
       //           30.06.2016 013 AKSTS1<>'2'   Mery
       //           01.07.2016 018 vsbd 018 integriert
       //           01.07.2016 018 akfa1 in ('H', 'E', ' ') reeh mail
       //      4.
       exec sql
         insert into TVRELWAECO/HELL_LFSP
         SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
         apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
         akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
         char(AKTNR)          Auftrag, current timestamp tstamp, APDUUSR,
         APDUUSRB,APAPPO,AKpsts ,apalm , char('0', 1) status,
         current timestamp updated
         FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
         WHERE AKFIRM ='DWI' and AKAART ='HEL' and    AKSTEU='HEL' and
               akfa1 in ('H', 'E', ' ', 'S') and AKSTS1 <>'2' and
               AKAPN  = APAPN and APRESM <> 0   and AKpsts = 20 and
               AKFRG  = 'F'   and AKALKZ = 'A'  and
               AKVART in ('003', '113', '225', '226', '227', '228',
                          '057', '008', '220', '221', '222', '223', '224',
                          '069', '103', '013', '078', '577',
                          '578', '579', '580', '581', '582', '019', '018',
                          '009', '016', '062'              ) and
               APAPN not  in (select APAPN from HELL_LFSP where
                               PANFpos.APAPPO = HELL_LFSP.APAPPO and
                               PANFpos.apanr1 = HELL_LFSP.apanr1 );



         §records=*zero;
       exec sql
         select count(*) into :§records
                FROM  TVRELWAECO/HELL_LFSP
                WHERE status ='0';

       if §records <> *zero;
       //           TVRELWAECO/HELL_LFS  Übergabedatei
       exec sql
         insert into TVRELWAECO/HELL_LFS
         SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
         apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
         akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
         Auftrag
         FROM  TVRELWAECO/HELL_LFSP
         WHERE status ='0';

       //           update Protokolldatei TVRELWAECO/HELL_LFSP
       exec sql
         update TVRELWAECO/HELL_LFSP set status = '1',
         updated = current timestamp
         WHERE status ='0';
       endif;

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

         eval p_infil   =  'HELL_LFS' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'HELL_LFS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/HELL_LFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'HELL_LFS';

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
          status='Error by CVTDBF object HELL_LFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'HELL_LFS';

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''HELL_LFS'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'HELL_LFS';

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
       //report clients
       //-----------------------------------------------------------------------

       begsr SR_report2;

       //Ableitung Ausgabe aller Order zu Hellmann
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/HELL_ORDER) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/HELL_ORDER)          ';
               exsr      SR_log;
         endmon;

       //Ableitung Ausgabe Verbindung zu Rhenania
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/HELL_RHENA) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/HELL_RHENA)          ';
               exsr      SR_log;
         endmon;

       //Ableitung Ebene Key
       exec sql
         insert into hell_order
           SELECT DISTINCT APANR1 FROM hell_lfsp;

       //Ableitung Ebene Key
       exec sql
         insert into hell_rhena
          SELECT * FROM hell_order, outbound
          WHERE apanr1 = substr(VSRHF, 1, 13);


       //    update Protokolldatei TVRELWAECO/HELL_LFSP
       //    erledigt bei Rhenania?
       exec sql
         update  hell_lfsp  set status='2'
                 where hell_lfsp.apanr1 in
                 (select HELL_RHENA.apanr1 from HELL_RHENA);


       exec sql
       update  hell_lfsp  set apduusrb =substr(APDUUSRB, 1, 8)
               concat '  ';

       //    Achtung: wurden verarbeitet, Aufträge wurden
       //    zusammengeführt, BEIPACK
       exec sql
         update hell_lfsp a set apduusrb =substr(APDUUSRB, 1, 8)  concat
         (select max(b.akpsts) from domdatv7/PSAVEAk b
             where b.akanr1 = a.apanr1  and status='1'
             group by b.akpsts )
         where exists
         (select max(b.akpsts) from domdatv7/PSAVEAk b
             where b.akanr1 = a.apanr1  and status='1'
             group by b.akpsts );

       exec sql
         update  hell_lfsp  set status='3'
                 where substr(APDUUSRB, 9, 2) <> '  ';


       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       //report client HELL_LFSP
         eval p_infil   =  'HELL_LFSP' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'HELL_LFSP';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/HELL_LFSP*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'HELL_LFSP';

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
          status='Error by CVTDBF object HELL_LFSP                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'HELL_LFS';

       //report client HELL_RHENA
         eval p_infil   =  'HELL_RHENA' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'HELL_RHENA';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/HELL_RHENA*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'HELL_RHENA';

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
          status='Error by CVTDBF object HELL_RHENA                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'HELL_RHENA';


       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''HELL_LFSP'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'HELL_LFS';

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


