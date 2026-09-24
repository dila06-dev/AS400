
      //************************************************************************
      //
      //      Programmname       SCM_IMPORT
      //      Erstellt  am       19.04.2020
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Übernahme Produktaerecodes (permanent update)
      //                         SELECT * FROM SCMUPDO WHERE TETENR ='9600051210'
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      // CRTSRCPF FILE(TVRELWAECO/SCMUPD) RCDLEN(240) TEXT  ('
      // import Data stream for SCM')      !
      //
      // wrklnk ('/Lager/SCM/translation table product area code.csv')
      //
      // TEEWTENR ='9105302940'   Protokoll lesen alma
      // SELECT * FROM TVRELWAECO/SCMUPDO WHERE TETENR ='9103100507'
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
      // update  teil01 a set a.TETEST =
      // (select  TETEST_ FROM SCMUPDO b
      //          WHERE H1 ='10.01.23' and  TETEST_ <> ' '  and
      //          a.tetenr = b.tetenr  and a.tefirm='01'        )
      //   where exists
      // (select  TETEST_ FROM SCMUPDO b
      //          WHERE H1 ='10.01.23' and  TETEST_ <> ' '  and
      //          a.tetenr = b.tetenr  and a.tefirm='01'        )
      //
      //
      //  update  teil01 a set a.TETEST = '01' where a.tetenr in
      //  (select b.tetenr FROM SCMUPDO b
      //           WHERE H1 ='10.01.23' and  TETEST_ <> ' '  and
      //                 b.tetest='1'   and a.tefirm='01' )
      //  67 Zeilen in TEIL01 in TVPF aktualisiert.
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
     H ALWNULL(*USRCTL)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------
     fSCMUPD1   uf   e             DISK    RENAME(SCMUPDo:PHY01R)
     f                                     USROPN
     f
     fteil01    uf   e           k DISK    RENAME(teil1:LOG01R)
     f                                     USROPN
     f
     flief01    uf   e           k DISK    RENAME(lief1:LOG02R)
     f                                     USROPN
     f
     flpif01    uf   e           k DISK    RENAME(lpif1:LOG03R)
     f                                     USROPN
     f
     fteew01    uf   e           k DISK    RENAME(teew1:LOG04R)
     f                                     USROPN
     f
     ftrtp01    if   e           k DISK
     f                                     USROPN
     f
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
     d SCMUPD1_i     E DS                  ExtName(SCMUPD1:*input)
     d                                     Qualified

     d SCMUPD1_o     E DS                  ExtName(SCMUPD1:*output)
     d                                     Qualified

     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_o      E DS                  ExtName(teil01:*output)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d lief01_i      E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d lief01_o      E DS                  ExtName(lief01:*output)
     d                                     Qualified

     d lief01_k      E DS                  ExtName(lief01:*key)
     d                                     Qualified


     d lpif01_k      E DS                  ExtName(lpif01:*key)
     d                                     Qualified

     d lpif01_i      E DS                  ExtName(lpif01:*input)
     d                                     Qualified

     d lpif01_o      E DS                  ExtName(lpif01:*output)
     d                                     Qualified


     d teew01_k      E DS                  ExtName(teew01:*key)
     d                                     Qualified

     d teew01_i      E DS                  ExtName(teew01:*input)
     d                                     Qualified

     d teew01_o      E DS                  ExtName(teew01:*output)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified


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
     d SCM_SUPPL       PR                  ExtPgm('SCM_SUPPL')
     d ITEMIMPV1       PR                  ExtPgm('ITEMIMPV1')
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
     D §upd            s              1a   inz
     D §upd2           s              1a   inz
     D §waeco          s              3a   inz
     D §dometic        s              3a   inz
     D §AERACODE       s              6a   inz
     D error1          s              1a   inz
     D run             s              1a   inz
     D p_inFIL         s             24a   inz
     D rc              s              1s 0 inz


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start Übergabe Stammdaten für SCM_IMPORT ';
       exsr      SR_log;
       error1='0';
       run = '1';

       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
       // exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;
       if run='1';

       //copy files from last input aerecodes
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/SCMUPDO#)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/SCMUPDO#)        ';
               exsr      SR_log;
         endmon;

       //copy files from last input aerecodes
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/SCMUPDi)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/SCMUPDi)         ';
               exsr      SR_log;
         endmon;

       //copy files from last input ...      ==> TVRELWAECO/SCMUPDi
       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/Lager/SCM/' +
           'SCM Upload file TREND.csv'') ' +
           'TOMBR(''/QSYS.LIB/TVRELWAECO.LIB/SCMUPDi.FILE/SCMUPDi.MBR'') '+
           ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF SCM_IMPORT';
          exsr      SR_log;
          error1 ='1';
       endmon;


       //copy files from last input aerecodes ==> TVRELWAECO/SCMUPDo
       //06.11.2025 Achtung windows scheiss delimiter geändert auf Komma
       //           'FLDDLM('','') DECPNT(*COMMA) ' vorher ;
       //copy files from last input aerecodes ==> TVRELWAECO/SCMUPDo
       //26.11.2025 Achtung windows scheiss delimiter geändert auf Semikolon
       //           'FLDDLM('';'') DECPNT(*COMMA) ' vorher ,
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/SCMUPDi) ' +
           'TOFILE(TVRELWAECO/SCMUPDo) MBROPT(*Add) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF SCM_IMPORT  ';
       // exsr      SR_log;
          error1 ='0';
       endmon;

       §records = 0;
       exec sql
          select count(*) into :§records
          from tvrelwaeco/SCMUPD1;

       if error1='0' and §records > 0;

          MONITOR;
          Wrk.var1 =
              'RMVLNK OBJLNK(''/LAGER/SCM/SCM Upload file TREND done*'')';
            cmd = %TrimR(Wrk.Var1);
            l      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='rmvlnk successful removed file done history      ';
             exsr      SR_log;
          on-error;
             status='Error by rmvlnk object file done history         ';
             exsr      SR_log;
          endmon;


       //...  SCMUPD1         ==>  S STATE                     CMP(EQ ' ' )
          open SCMUPD1;
          open teil01;
          open lief01;
          open lpif01;
          open teew01;
          open trtp01;
          §upd             =  '0';
          §upd2            =  '0';
          read SCMUPD1   SCMUPD1_i;
          SCMUPD1_o  = SCMUPD1_i;
          SCMUPD1_o.state   = '0';
       //teil01 initialisiert mit Mandant
          dow not %eof(SCMUPD1);
             teil01_k.TEFIRM = SCMUPD1_i.TEFIRM;
             teil01_k.TETENR = SCMUPD1_i.TETENR;
             chain %kds(teil01_k:2) teil01    teil01_I;
             if %found(teil01);
                teil01_o  = teil01_i;
                if
                   (teil01_i.TETEST  <> SCMUPD1_i.TETEST and
                    SCMUPD1_i.TETEST <> *Blank)             or
                   (teil01_i.TEBESL  <> SCMUPD1_i.TEBESL and
                    SCMUPD1_i.TEBESL <> *Blank)             or
                   (teil01_i.TESIBE  <> SCMUPD1_i.TESIBE and
                    SCMUPD1_i.TESIBE <> *Zero )             or
                   (teil01_i.TEABC1  <> SCMUPD1_i.TEABC1 and
                    SCMUPD1_i.TEABC1 <> *Blank)             or
                   (teil01_i.TESAEK  <> SCMUPD1_i.TESAEK and
                    SCMUPD1_i.TESAEK <> *Blank)             or
                   (teil01_i.TEDIEK  <> SCMUPD1_i.TEDIEK and
                    SCMUPD1_i.TEDIEK <> *Blank)             or
       ///         (teil01_i.telvz1  <> SCMUPD1_i.telvz1 and
       ///          SCMUPD1_i.telvz1 <> *Zero )             or
                   (teil01_i.TEZOTN  <> SCMUPD1_i.TEZOTN and
                    SCMUPD1_i.TEZOTN <> *Blank)             or
                   (teil01_i.temibm  <> SCMUPD1_i.LPMIBM and
                    SCMUPD1_i.LPMIBM <> *Zero )             or
       ///         (teil01_i.LFVSTA  <> SCMUPD1_i.LFVSTA and
       ///         (teil01_i.LPMIBM  <> SCMUPD1_i.LPMIBM and
                   (teil01_i.TEABC4  <> SCMUPD1_i.TEABC4 and
                    SCMUPD1_i.TEABC4 <> *Blank)             or
                   (teil01_i.TEEANR  <> SCMUPD1_i.TEEANR and
                    SCMUPD1_i.TEEANR <> *Blank)             or
                   (teil01_i.TEPRGR  <> SCMUPD1_i.TEPRGR and
                    SCMUPD1_i.TEPRGR <> *Blank)             or
                   (teil01_i.TEABC2  <> SCMUPD1_i.TEABC2 and
                    SCMUPD1_i.TEABC2 <> *Blank);
                      §upd             =  '1';
                endif;
                if §upd             =  '1';
                   if (teil01_i.TETEST  <> SCMUPD1_i.TETEST and
                       SCMUPD1_i.TETEST <> *Blank           and
                       teil01_i.TETEST  <> '42'             and
                       teil01_i.TETEST  <> '82'             and
                       teil01_i.TEZOTN  <> *Blank);
                      SCMUPD1_o.TETEST_ = teil01_i.TETEST;
                      teil01_o.TETEST   = SCMUPD1_i.TETEST;
       /// Achtung Prüfungen Statusänderung !!!! alma 26.04.2023
       ///            42, 82, nicht änderbar
       ///            zolltarifnummer fehlt keine Änderung (TEZOTN)
                   endif;
       ///         Beschaff-Code           PRÜFUNG
                   if (teil01_i.TEBESL  <> SCMUPD1_i.TEBESL and
                       SCMUPD1_i.TEBESL <> *Blank);
                       trtp_k.TPTART  =  'BESL      ';
                       trtp_k.TPTCDE  =  SCMUPD1_i.TEBESL;
                       exsr sr_trtp;
                       if RC = 0;
                          SCMUPD1_o.TEBESL_ = teil01_i.TEBESL;
                          teil01_o.TEBESL  = SCMUPD1_i.TEBESL;
                       else;
                          SCMUPD1_o.TEBESL_ = '?';
                       endif;
                   endif;
       ///         Sicherheitsbestand
                   if (teil01_i.TESIBE  <> SCMUPD1_i.TESIBE and
                       SCMUPD1_i.TESIBE <> *Zero );
                      SCMUPD1_o.TESIBE_ = teil01_i.TESIBE;
                      teil01_o.TESIBE  = SCMUPD1_i.TESIBE;
                   endif;
                   if (teil01_i.TEABC1  <> SCMUPD1_i.TEABC1 and
                       SCMUPD1_i.TEABC1 <> *Blank);
                      SCMUPD1_o.TEABC1_ = teil01_i.TEABC1;
                      teil01_o.TEABC1  = SCMUPD1_i.TEABC1;
                   endif;
                   if (teil01_i.TESAEK  <> SCMUPD1_i.TESAEK and
                       SCMUPD1_i.TESAEK <> *Blank);
                       trtp_k.TPTART  =  'SABE      ';
                       trtp_k.TPTCDE  =  SCMUPD1_i.TESAEK;
                       exsr sr_trtp;
                       if RC = 0;
                          SCMUPD1_o.TESAEK_ = teil01_i.TESAEK;
                          teil01_o.TESAEK  = SCMUPD1_i.TESAEK;
                       else;
                          SCMUPD1_o.TESAEK_ = '?';
                       endif;
                   endif;
                   if (teil01_i.TEDIEK  <> SCMUPD1_i.TEDIEK and
                       SCMUPD1_i.TEDIEK <> *Blank);
                       trtp_k.TPTART  =  'SABE      ';
                       trtp_k.TPTCDE  =  SCMUPD1_i.TEDIEK;
                       exsr sr_trtp;
                       if RC = 0;
                          SCMUPD1_o.TEDIEK_ = teil01_i.TEDIEK;
                          teil01_o.TEDIEK  = SCMUPD1_i.TEDIEK;
                       else;
                          SCMUPD1_o.TEDIEK_ = '?';
                       endif;
                   endif;
       ///         Vorlauf-Zt. EK
       //Achtung TELVZ1 jetzt nach LPLZTG !!!
       ///         if (teil01_i.telvz1  <> SCMUPD1_i.telvz1 and
       ///             SCMUPD1_i.telvz1 <> *Zero );
       ///            SCMUPD1_o.telvz1_ = teil01_i.telvz1;
       ///            teil01_o.telvz1  = SCMUPD1_i.telvz1;
       ///         endif;
       ///         Zolltarif-Nrnummer
                   if (teil01_i.TEZOTN  <> SCMUPD1_i.TEZOTN and
                       SCMUPD1_i.TEZOTN <> *Blank);
                      SCMUPD1_o.TEZOTN_ = teil01_i.TEZOTN;
                      teil01_o.TEZOTN  = SCMUPD1_i.TEZOTN;
                   endif;
                   if (teil01_i.TEABC4  <> SCMUPD1_i.TEABC4 and
                       SCMUPD1_i.TEABC4 <> *Blank);
                      SCMUPD1_o.TEABC4_ = teil01_i.TEABC4;
                      teil01_o.TEABC4  = SCMUPD1_i.TEABC4;
                   endif;
                   if (teil01_i.TEMIBM  <> SCMUPD1_i.LPMIBM and
                       SCMUPD1_i.LPMIBM <> *Zero );
                      SCMUPD1_o.TEMIBM_ = teil01_i.TEMIBM;
                      teil01_o.TEMIBM  = SCMUPD1_i.LPMIBM;
                   endif;
                   if (teil01_i.TEEANR  <> SCMUPD1_i.TEEANR and
                       SCMUPD1_i.TEEANR <> *Blank);
                      SCMUPD1_o.TEEANR_ = teil01_i.TEEANR;
                      teil01_o.TEEANR  = SCMUPD1_i.TEEANR;
                   endif;
                   if (teil01_i.TEPRGR  <> SCMUPD1_i.TEPRGR and
                       SCMUPD1_i.TEPRGR <> *Blank);
                       trtp_k.TPTART  =  'PRGR      ';
                       trtp_k.TPTCDE  =  SCMUPD1_i.TEPRGR;
                       exsr sr_trtp;
                       if RC = 0;
                          SCMUPD1_o.TEPRGR_ = teil01_i.TEPRGR;
                          teil01_o.TEPRGR  = SCMUPD1_i.TEPRGR;
                       else;
                          SCMUPD1_o.TEPRGR_ = '?';
                       endif;
                   endif;
                   if (teil01_i.TEABC2  <> SCMUPD1_i.TEABC2 and
                       SCMUPD1_i.TEABC2 <> *Blank);
                       trtp_k.TPTART  =  'TEILABC2  ';
                       trtp_k.TPTCDE  =  SCMUPD1_i.TEABC2;
                       exsr sr_trtp;
                       if RC = 0;
                          SCMUPD1_o.TEABC2_ = teil01_i.TEABC2;
                          teil01_o.TEABC2  = SCMUPD1_i.TEABC2;
                       else;
                          SCMUPD1_o.TEABC2_ = '?';
                       endif;
                   endif;
                   teil01_o.teuser = §§§usr;
                   teil01_o.tePROG = §§§pgm;
                   teil01_o.tejnam = §§§job;
                   teil01_o.tebibl = §§§LIB;
                   teil01_o.teJDAT = %dec(%char(%date():*iso0):8:0);
                   teil01_o.teJZEI = %dec(%char(%time():*iso0):6:0);
                   SCMUPD1_o.state   = '1';
                   update LOG01R    teil01_o;
                   status='change   ' + teil01_k.TETENR;
                   exsr      SR_log;
                endif;
                if SCMUPD1_i.LFVSTA <> *Zero;
       //LIEF01 initialisiert mit Mandant
                   LIEF01_k.LFFIRM = teil01_i.TEFIRM;
                   LIEF01_k.LFLFNR = teil01_i.TELFNR;
                   chain %kds(LIEF01_k:2) LIEF01    LIEF01_I;
                   if %found(LIEF01);
                      LIEF01_o  = LIEF01_i;
                      if
                         (LIEF01_i.LFVSTA  <> SCMUPD1_i.LFVSTA and
                          SCMUPD1_i.LFVSTA <> *Zero );
                          SCMUPD1_o.LFVSTA_ = LIEF01_i.LFVSTA;
                          lief01_o.LFVSTA  = SCMUPD1_i.LFVSTA;
                          lief01_o.lfuser = §§§usr;
                          lief01_o.lfPROG = §§§pgm;
                          lief01_o.lfjnam = §§§job;
                          lief01_o.lfbibl = §§§LIB;
                          lief01_o.lfJDAT = %dec(%char(%date():*iso0):8:0);
                          lief01_o.lfJZEI = %dec(%char(%time():*iso0):6:0);
                          SCMUPD1_o.state   = '1';
                          update LOG02R    lief01_o;
                          status='change   ' + lief01_k.LFLFNR;
                          exsr      SR_log;
                       endif;
                   endif;
                endif;
       //Achtung TELVZ1 jetzt nach LPLZTG !!!
                if SCMUPD1_i.LPMIBM <> *Zero or
                   SCMUPD1_i.TELVZ1 <> *Zero;
       //Lpif01 initialisiert mit Mandant
                   Lpif01_k.LPFIRM = teil01_i.TEFIRM;
                   Lpif01_k.LPLFNR = teil01_i.TELFNR;
                   Lpif01_k.LPTENR = teil01_i.TETENR;
                   Lpif01_k.LPGADA = %dec(%char(%date():*iso0):8:0);
       //          chain %kds(Lpif01_k:3) Lpif01    Lpif01_I;
       //          setll %kds(Lpif01_k:3) Lpif01    ;
                   setgt %kds(Lpif01_k:3) Lpif01    ;
                   readp Lpif01 Lpif01_i;
                   if %found(Lpif01) and
                   Lpif01_i.LPFIRM = teil01_i.TEFIRM and
                   Lpif01_i.LPLFNR = teil01_i.TELFNR and
                   Lpif01_i.LPTENR = teil01_i.TETENR;
                      Lpif01_o  = Lpif01_i;
                      if
                         (Lpif01_i.LPMIBM  <> SCMUPD1_i.LPMIBM and
                          SCMUPD1_i.LPMIBM <> *Zero )          or
       //Achtung TELVZ1 jetzt nach LPLZTG !!!
                         (Lpif01_i.LPLZTG  <> SCMUPD1_i.TELVZ1 and
                          SCMUPD1_i.TELVZ1 <> *Zero );
                          §upd2 = '1';
                          if §upd2 = '1';
                             if SCMUPD1_i.LPMIBM <> *zero;
                                SCMUPD1_o.LPMIBM_ = Lpif01_i.LPMIBM;
                                Lpif01_o.LPMIBM  = SCMUPD1_i.LPMIBM;
                             endif;
       //Achtung TELVZ1 jetzt nach LPLZTG !!! und immer Tage!!!!!
                             if SCMUPD1_i.TELVZ1 <> *zero;
                                SCMUPD1_o.TELVZ1_ = Lpif01_i.LPLZTG;
                                Lpif01_o.LPLZTG  = SCMUPD1_i.TELVZ1;
                                Lpif01_o.LPLZTD  = 'T';
                             endif;
                             Lpif01_o.lpuser = §§§usr;
                             Lpif01_o.lpPROG = §§§pgm;
                             Lpif01_o.lpjnam = §§§job;
                             Lpif01_o.lpbibl = §§§LIB;
                             Lpif01_o.lpJDAT = %dec(%char(%date():*iso0):8:0);
                             Lpif01_o.lpJZEI = %dec(%char(%time():*iso0):6:0);
                             SCMUPD1_o.state   = '1';
                             update LOG03R    Lpif01_o;
                             status='change   ' + Lpif01_k.LpLFNR + ' ' +
                                                  Lpif01_k.Lptenr;
                             exsr      SR_log;
                          endif;
                      endif;
                   else;
       //als Fehlermeldung
                      SCMUPD1_o.TETENR_ = teil01_i.TELFNR;
                   endif;
                endif;
                if SCMUPD1_i.TEEWPRGR <> *Blank or
                   SCMUPD1_i.TEEWTART <> *Blank;
       //teew01 initialisiert mit Mandant
                   teew01_k.teewFIRM = SCMUPD1_i.TEFIRM;
                   teew01_k.teewTENR = SCMUPD1_i.TETENR;
                   chain %kds(TEEW01_k:2) TEEW01    TEEW01_I;
                   if %found(TEEW01);
                      TEEW01_o  = TEEW01_i;
                      if
                          ((TEEW01_i.TEEWPRGR  <> SCMUPD1_i.TEEWPRGR and
                            SCMUPD1_i.TEEWPRGR <> *Blank) or
                           (TEEW01_i.TEEWTART  <> SCMUPD1_i.TEEWTART and
                            SCMUPD1_i.TEEWTART <> *Blank));

                          if (TEEW01_i.TEEWPRGR  <> SCMUPD1_i.TEEWPRGR and
                              SCMUPD1_i.TEEWPRGR <> *Blank);
                              SCMUPD1_o.TEEWPRGR_ = TEEW01_i.TEEWPRGR;
                               TEEW01_o.TEEWPRGR  = SCMUPD1_i.TEEWPRGR;
                          endif;
                          if (TEEW01_i.TEEWTART  <> SCMUPD1_i.TEEWTART and
                              SCMUPD1_i.TEEWTART <> *Blank);
                              SCMUPD1_o.TEEWTART_ = TEEW01_i.TEEWTART;
                               TEEW01_o.TEEWTART  = SCMUPD1_i.TEEWTART;
                          endif;

                          TEEW01_o.TEEWuser = §§§usr;
                          TEEW01_o.TEEWPROG = §§§pgm;
                          TEEW01_o.TEEWjnam = §§§job;
                          TEEW01_o.TEEWbibl = §§§LIB;
                          TEEW01_o.TEEWJDAT = %dec(%char(%date():*iso0):8:0);
                          TEEW01_o.TEEWJZEI = %dec(%char(%time():*iso0):6:0);
                          SCMUPD1_o.state   = '1';
                          update LOG04R    TEEW01_o;
                          status='change   ' + TEEW01_k.teewTENR;
                          exsr      SR_log;
                      endif;
                   endif;
                endif;
             endif;
             update phy01r   SCMUPD1_o;
             read SCMUPD1    SCMUPD1_i;
             SCMUPD1_o  = SCMUPD1_i;
             SCMUPD1_o.state   = '0';
             §upd             =  '0';
             §upd2            =  '0';
          enddo;
          unlock    teil01;
          unlock    lief01;
          unlock    lpif01;
          unlock    teew01;
          close SCMUPD1;
          close teil01;
          close lief01;
          close lpif01;
          close teew01;
          close trtp01;
       endif;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       MONITOR;
       Wrk.var1 =
           'CD DIR(''/lager/SCM'') ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CD DIR successful FILE(TVRELWAECO/SCM_IMPORT)    ';
       on-error;
          status='Error by CD DIR object (TVRELWAECO/SCM_IMPORT)   ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'RNM OBJ(''SCM Upload file TREND.csv'') '+
           'NEWOBJ(''SCM Upload file TREND done.csv'')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rnm    successful FILE(TVRELWAECO/SCM_IMPORT)    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/SCM_IMPORT)   ';
       endmon;


       //Protokoll
       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/SCM_IMPORT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/SCM_IMPORT)    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/SCM_IMPORT)   ';
       endmon;

       //ermitteln über Tabelle
             exec sql
                insert into tvrelwaeco/SCM_IMPORT
                SELECT * FROM job_run
                WHERE PGM ='SCM_IMPORT' and cd = current date and
                            ct > current time - 30 minutes;
       if §records > 0;
          exsr SR_report;
       endif;

       //run = '1' endif
       endif;
       //NumSysTime > 000000 endif
       endif;

       eval status ='Ende  SCM_IMPORT                     ';
       exsr      SR_log;


       //Verschiffungstage Lieferant
       callP SCM_SUPPL();

       //Artikelübernahme und ggf. LP1 Preise
       callP ITEMIMPV1();



       *inlr = *on;

       //-----------------------------------------------------------------------
       //Grunddaten prüfen in Domeic Group Definition
       //Firmennummer:    01
       //Sprachcode:      D
       //Tabellenart:     TEILABC2
       //Tabellencode:    A
       //Folgenr:
       //
       //-----------------------------------------------------------------------

       begsr sr_trtp;

          trtp_k.tpfirm  =  '01';
          trtp_k.TPSPCD  =  'D';
       // trtp_k.TPTART  =  'TEILABC2  ';
       //aus execute  ==> trtp_k.TPTCDE
       // trtp_k.TPTCDE  =  ???
          trtp_k.TPTFLG  =  0;

       //trtp
          chain %kds(trtp_k:5) trtp01 trtp_I;
          if %found(trtp01);
             rc    = 0;
          else;
             rc    = 1;
          endif;

       endsr;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************

       begsr sqlstatus;

       //-----------------------------------------------------------------------
       //log report
       //    If SQLCODE = 0 and SQLWARN0 is blank, execution was successful.
       //    If SQLCODE = 100, no data was found. For example, a FETCH statemen
       //       because the cursor was positioned after the last row of the res
       //    If SQLCODE > 0 and not = 100, execution was successful with a warn
       //    If SQLCODE = 0 and SQLWARN0 = 'W', execution was successful with a
       //    If SQLCODE < 0, execution was not successful.
       //
       //-----------------------------------------------------------------------

        if SQLCOD <> 0 or SQLWARN(1) ='W';
           eval status ='SQLCOD: '   + %char(sqlcod) +
                        ' SQLWARN: '  + SQLWARN(1);
       //  exsr      SR_log;
           eval status ='SQLERRMC: '  + SQLERRMC;
       //  exsr      SR_log;
           eval status ='SQLERM: '  + SQLERM;
       //  exsr      SR_log;
           eval status ='Kombination Waeco: ' + §waeco  +
                        ' Dometic: ' + §dometic + 'fehlt in Tab';
           exsr      SR_log;
       //  MONITOR;
       //  Wrk.var1 =
       //      'DSPJOBLOG OUTPUT(*PRINT) ';
       //    cmd = %TrimR(Wrk.Var1);
       //
       //    l      = %Len(Cmd);
       //    QCMDEXC(cmd: %len(cmd));
       //  on-error;
       //     status='error in DSPJOBLOG OUTPUT(*PRINT)';
       //     exsr      SR_log;
       //  endmon;
        endif;
       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //%scan Zeichen(§search) ersetzten durch(§replace) in string(§string)
       //-----------------------------------------------------------------------

       begsr scanstr;

             §pos = %scan(§search: §string);
             dow §pos > 0;
                §string = %replace(§replace: §string: §pos: %len(§search));
                if (§pos+%len(§replace) > %len(§string));
                   §pos = 0;
                else;
                   §pos = %scan(§search: §string: §pos+%len(§replace));
                endif;
             enddo;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //SELECT * FROM TVRELWAECO/SCMUPDO WHERE h2 >
       //'2024-01-11-14.19.27.328128'
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_report;

       exec sql
          insert into   TVRELWAECO/SCMUPDO#
          SELECT * FROM TVRELWAECO/SCMUPDO WHERE h2
          > current timestamp -5 minutes;

       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'SCMUPDO' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'SCMUPDO#';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/SCM/#*******'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed SCMUPDO*               ';
       // exsr      SR_log;
       on-error;
          status='Error by rmvlnk object SCMUPDO*                  ';
       // exsr      SR_log;
       endmon;

       eval p_outfil  =  'SCMUPDO#';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/SCM/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for SCMUPDO               ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object SCMUPDO                   ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'PACodes';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/SCM/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/SCMUPDO)       ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/SCMUPDO)      ';
       endmon;


       endsr;

       //-----------------------------------------------------------------------
       //output ITEMMASTER
       // CRTPF FILE(TVRELWAECO/uebergabe) RCDLEN(1252) TEXT('transfer files')
       //-----------------------------------------------------------------------

       begsr file_out1;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'ITEMMASTER' + '-'                      +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'ITEMMASTER';

       //Aufbereitung für Export Datei Info in Beschreibung
       //MONITOR;
       //   Wrk.var1 =
       //       'CHGOBJD OBJ(TVRELWAECO/'+ p_outfil +')' +
       //       ' OBJTYPE(*FILE)'                         +
       //       ' TEXT(''+
       //       '+ §text +'+
       //       '''+
       //       ')';
       //   cmd = %TrimR(Wrk.Var1);
       //   L      = %Len(Cmd);
       //   QCMDEXC(cmd: %len(cmd));
       //   on-error;
       //      status='error CHGOBJD OBJ ' +
       //              p_outfil;
       //      //Aufbereitung für Export  Abbruch
       //      exsr      SR_log;
       //endmon;

         clear p_md;

       //Aufbereitung für Export in Übertragungsdatei
       //06.11.2025 Achtung windows scheiss delimiter geändert auf Komma
       //           'FLDDLM('','') DECPNT(*COMMA) ' vorher ;
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/UEBERGABE) '+
                'MBROPT(*REPLACE) STRDLM(''"'') '+
                'RMVBLANK(*BOTH) FLDDLM('','') DECPNT(*COMMA) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CPYTOIMPF FROMFILE '  +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         eval p_outfil  =  'ITEMMASTER';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  ITEMMASTER;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(BLOMGRENRC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'ITEMMASTER';

            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(BLOMGRENRL)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT2 TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

       //Info in Outfile timestamp
            clear p_md;
            eval p_msg     =  '#DC0010';
            eval p_msgf    =  *blank;
            eval p_print   =  *blank;
            eval p_outfil  =  'OUTPUT    ';
            eval p_lib     =  'TVRELWAECO';
            eval p_repadd  =  '*ADD';

            callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                           p_outfil: p_lib:    p_repadd);


            eval p_outfil  =  'ITEMMASTER';

       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'RPMS'    +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'UEBERGABE ' +
                                 transfer;

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //FTP-Befehl
            MONITOR;
               Wrk.var1 =
                   'FTP RMTSYS(''ftp.seit.dometic.com'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;

            if err_msg = '1';
               status='error ftp.seit.dometic.com' +
                                                  %trimr(suffix) + ' ' +
                                                  transfer             +
                                                  ' '                  +
                                                  %char(§records);
               exsr      SR_log;
            else;
               status='transfer successful '    +
                                                  %trimr(suffix) + ' ' +
                                                  transfer             +
                                                  ' '                  +
                                                  %char(§records);
               exsr      SR_log;
               eval p_outfil  =  'ITEMMASTER';

               §text          = *blank;
               §text          = %trimr(suffix) + ' ' +
                                transfer             +
                                ' '                  +
                                %char(§records);

       //Aufbereitung für Export Datei Info in Beschreibung
               MONITOR;
               Wrk.var1 =
                   'CHGOBJD OBJ(TVRELWAECO/'+ p_outfil +')' +
                   ' OBJTYPE(*FILE)'                         +
                   ' TEXT(''+
                   '+ §text +'+
                   '''+
                   ')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error CHGOBJD OBJ ' +
                         p_outfil;
                  //Aufbereitung für Export  Abbruch
                  exsr      SR_log;
            endmon;
               MONITOR;
               Wrk.var1 =
                   'CHGOBJD OBJ(TVRELWAECO/UEBERGABE)' +
                   ' OBJTYPE(*FILE)'                         +
                   ' TEXT(''+
                   '+ §text +'+
                   '''+
                   ')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error CHGOBJD OBJ ' +
                         p_outfil;
                  //Aufbereitung für Export  Abbruch
                  exsr      SR_log;
            endmon;

            endif;
       else;
          status='Übertragungsdatei leer ' + p_outfil;
          exsr      SR_log;
       endif;

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


