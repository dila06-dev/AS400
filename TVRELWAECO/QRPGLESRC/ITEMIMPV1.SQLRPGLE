
      //************************************************************************
      //
      //      Programmname       WATCHIFS
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang
      //                         CHGJOB     CCSID(1144) für sql
      //      Beschreibung
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //  CUSTOMOR ändern für 300 und 200  ! 17.10.2019
      //                                   !
      // CPYFRMIMPF FROMFILE(TVRELWAECO/GALAXUSIN) TOFILE(TVRELWAECO/FROM_EXCE3)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      // 
      //Dometic Product Groups_new-InRiver.csv
      // CRTSRCPF FILE(QTEMP/IMPORT) RCDLEN(240) TEXT('importing items and prices')
      //
      // CPYFRMSTMF FROMSTMF('/LAGER/SCM/Dometic Product Groups_new-InRiver.csv')
      // TOMBR('/QSYS.LIB/qtemp.LIB/IMPORT.FILE/IMPORT.MBR') MBROPT(*REPLACE)
      // select * from import
      // CPYFRMIMPF FROMFILE(qtemp/import) TOFILE(TVRELWAECO/domgrpv1)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      //
      // SELECT char(' ', 1), char('GANG ', 10), zoned(('20') concat
      // substr(char(current date +0 day), 7, 2) concat substr(char(current
      // date +0 day), 4, 2) concat substr(char(current date +0 day), 1, 2),
      // 8, 0), zoned(substr(char(current time), 1, 2) concat
      // substr(char(current time), 4, 2) concat substr(char(current time),
      // 7, 2), 6, 0) , 'GANG      ' , char('INRIVER   ', 10),
      // char('TVRELWAECO', 10), '01', 'D','$$TEEWPRGR',#PGRP, 0, #DESC2,
      // 0,00, ' ', ' '
      // FROM tvrelwaeco/domgrpv1
      // where #pgrp not in (select TPTCDE from
      //       trtp01 WHERE TPFIRM ='01' and TPTART='$$TEEWPRGR' and
      //                    TPSPCD ='D' )
      // 88 Zeilen in TRTP01 in TAMF eingefügt.
      //
      // update  trtp set   TPTTXT=
      // (select #DESC2 from tvrelwaeco/domgrpv1
      //  where TPFIRM ='01' and TPTART='$$TEEWPRGR' and TPSPCD ='D'
      //                     and TPTcde=#PGRP)
      // where exists
      // (select #DESC2 from tvrelwaeco/domgrpv1
      //  where TPFIRM ='01' and TPTART='$$TEEWPRGR' and TPSPCD ='D'
      //                     and TPTcde=#PGRP)
      //
      // update trtp set TPTTXT='*' concat substr(TPTTXT, 1, 39)
      // where
      // TPFIRM ='01' and TPTART='$$TEEWPRGR' and TPSPCD ='D' and TPTcde
      // not in (select #PGRP from tvrelwaeco/domgrpv1)
      //
      // select *          from trtp01
      //           where
      // TPFIRM ='55' and TPTART='$$TEEWPRGR' and TPSPCD ='D' and TPTcde
      // not in (select #PGRP from tvrelwaeco/domgrpv1_1)
      //
      //WAECO Product Groups_new.csv
      // CRTSRCPF FILE(QTEMP/IMPORT) RCDLEN(240) TEXT('importing items and prices')
      //
      // CPYFRMSTMF FROMSTMF('/LAGER/SCM/WAECO Product Groups_new.csv')
      // TOMBR('/QSYS.LIB/qtemp.LIB/IMPORT.FILE/IMPORT.MBR') MBROPT(*REPLACE)
      // select * from import
      // CPYFRMIMPF FROMFILE(qtemp/import) TOFILE(TVRELWAECO/domgrpv1)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      //
      // SELECT char(' ', 1), char('GANG ', 10), zoned(('20') concat
      // substr(char(current date +0 day), 7, 2) concat substr(char(current
      // date +0 day), 4, 2) concat substr(char(current date +0 day), 1, 2),
      // 8, 0), zoned(substr(char(current time), 1, 2) concat
      // substr(char(current time), 4, 2) concat substr(char(current time),
      // 7, 2), 6, 0) , 'GANG      ' , char('INRIVER   ', 10),
      // char('TVRELWAECO', 10), '01', 'D','PRGR      ',#PGRP, 0, #DESC2,
      // 0,00, ' ', ' '
      // FROM tvrelwaeco/domgrpv1
      // where #pgrp not in (select TPTCDE from
      //       trtp01 WHERE TPFIRM ='01' and TPTART='PRGR      ' and
      //                    TPSPCD ='D' )
      //  8 Zeilen in TRTP01 in TAMF eingefügt.
      //
      // update  trtp set   TPTTXT=
      // (select #DESC2 from tvrelwaeco/domgrpv1
      //  where TPFIRM ='01' and TPTART='PRGR      ' and TPSPCD ='D'
      //                     and TPTcde=#PGRP)
      // where exists
      // (select #DESC2 from tvrelwaeco/domgrpv1
      //  where TPFIRM ='01' and TPTART='PRGR      ' and TPSPCD ='D'
      //                     and TPTcde=#PGRP)
      //
      // update trtp set TPTTXT='*' concat substr(TPTTXT, 1, 39)
      // where
      // TPFIRM ='01' and TPTART='PRGR      ' and TPSPCD ='D' and TPTcde
      // not in (select #PGRP from tvrelwaeco/domgrpv1)
      //****************************************************************
      //
      //
      //
      // insert into tvrelwaeco/PRL1UPDOUT
      // SELECT '01', substr(b.#SKU, 1, 15), 'LP1', zoned(PREZPR*1, 9, 4) ,
      // 20200801, PRGBDA , PRWACD,
      // 'Uebernahme ITEMSUPLOADRV                  ', TESTLF , ' ', ' ',
      // ' ', 0,00, 0, 0, ' ', ' ', ' ', ' ' h1, current date h2, current
      // timestamp h3, ' ' h4, current date h5, current timestamp h6 FROM
      // ITEMIMPV1 b WHERE b.h1 = current date -0 day and
      //                   b.h5 > current time - 15 minutes  and
      //                    substr(b.#SKU, 1, 15) <> '1'
      // call PRL1UPDINR                   !
      //                                   !
      //                                   !
      // CFGDIRMAIL   auf 20:00 gesetzt    !
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
     H ALWNULL(*USRCTL)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------
     fITEMIMPV1Luf   e             disk    RENAME(ITEMIMPV1R:PHY01R)
     f                                     USROPN

     f$teil$$   if   e           k DISK    RENAME($teil01:log01R)
     f                                     usropn
     f$Teew$$   if   e           k DISK    RENAME($Teew01:log02R)
     f                                     usropn
     f$Tebb$$   if   e           k DISK    RENAME($Tebb01:log03R)
     f                                     usropn
     f$Teuf$$   if   e           k DISK    RENAME($Teuf01:log04R)
     f                                     usropn
     f$Teos$$   if   e           k DISK    RENAME($Teos01:log05R)
     f                                     usropn
     f
     fteil01    uf a e           k DISK
     f
     fTeew01    uf a e           k DISK
     f
     fTebb01    uf a e           k DISK
     f
     fTeuf01    uf a e           k DISK
     f
     fTeos01    uf a e           k DISK
     f
     fTeal01    uf a e           k DISK
     f
     flpif01    uf a e           k DISK
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
     dITEMIMPV1L_i   E DS                  ExtName(ITEMIMPV1L:*input)
     d                                     Qualified
     dITEMIMPV1L_o   E DS                  ExtName(ITEMIMPV1L:*output)
     d                                     Qualified
       //           TEIL 01
     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil_o        E DS                  ExtName(teil01:*output)
     d                                     Qualified

     d $teil$$_k     E DS                  ExtName($teil$$:*key)
     d                                     Qualified

     d $teil$$_i     E DS                  ExtName($teil$$:*input)
     d                                     Qualified

     d $teil$$_o     E DS                  ExtName($teil$$:*output)
     d                                     Qualified

       //           Teew 02
     d Teew_k        E DS                  ExtName(Teew01:*key)
     d                                     Qualified

     d Teew_i        E DS                  ExtName(Teew01:*input)
     d                                     Qualified

     d Teew_o        E DS                  ExtName(Teew01:*output)
     d                                     Qualified

     d $Teew$$_k     E DS                  ExtName($Teew$$:*key)
     d                                     Qualified

     d $Teew$$_i     E DS                  ExtName($Teew$$:*input)
     d                                     Qualified

     d $Teew$$_o     E DS                  ExtName($Teew$$:*output)
     d                                     Qualified


       //           Tebb 03
     d Tebb_k        E DS                  ExtName(Tebb01:*key)
     d                                     Qualified

     d Tebb_i        E DS                  ExtName(Tebb01:*input)
     d                                     Qualified

     d Tebb_o        E DS                  ExtName(Tebb01:*output)
     d                                     Qualified

     d $Tebb$$_k     E DS                  ExtName($Tebb$$:*key)
     d                                     Qualified

     d $Tebb$$_i     E DS                  ExtName($Tebb$$:*input)
     d                                     Qualified

     d $Tebb$$_o     E DS                  ExtName($Tebb$$:*output)
     d                                     Qualified

       //           Teuf 04
     d Teuf_k        E DS                  ExtName(Teuf01:*key)
     d                                     Qualified

     d Teuf_i        E DS                  ExtName(Teuf01:*input)
     d                                     Qualified

     d Teuf_o        E DS                  ExtName(Teuf01:*output)
     d                                     Qualified

     d $Teuf$$_k     E DS                  ExtName($Teuf$$:*key)
     d                                     Qualified

     d $Teuf$$_i     E DS                  ExtName($Teuf$$:*input)
     d                                     Qualified

     d $Teuf$$_o     E DS                  ExtName($Teuf$$:*output)
     d                                     Qualified

       //           Teos 05
     d teos_k        E DS                  ExtName(teos01:*key)
     d                                     Qualified

     d teos_i        E DS                  ExtName(teos01:*input)
     d                                     Qualified

     d teos_o        E DS                  ExtName(teos01:*output)
     d                                     Qualified

     d $teos$$_k     E DS                  ExtName($teos$$:*key)
     d                                     Qualified

     d $teos$$_i     E DS                  ExtName($teos$$:*input)
     d                                     Qualified

     d $teos$$_o     E DS                  ExtName($teos$$:*output)
     d                                     Qualified

       //           teal
     d teal_k        E DS                  ExtName(teal01:*key)
     d                                     Qualified

     d teal_i        E DS                  ExtName(teal01:*input)
     d                                     Qualified

     d teal_o        E DS                  ExtName(teal01:*output)
     d                                     Qualified

       //           Lpif
     d lpif_k        E DS                  ExtName(lpif01:*key)
     d                                     Qualified

     d lpif_i        E DS                  ExtName(lpif01:*input)
     d                                     Qualified

     d lpif_o        E DS                  ExtName(lpif01:*output)
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
       // PRL1UPDINR
       // ______________________________________________________________________
     D PRL1UPDINR      PR                  ExtPgm('PRL1UPDINR')

       // ______________________________________________________________________
       // PKDKUPDINR
       // ______________________________________________________________________
     D PKDKUPDINR      PR                  ExtPgm('PKDKUPDINR')

       // PPKGUPDINR
       // ______________________________________________________________________
     D PPKGUPDINR      PR                  ExtPgm('PPKGUPDINR')

      // _______________________________________________________________________
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

      // .......
      //------------------------------------------------------------------------
     D stat            PR            10I 0 ExtProc('stat')
     D   path                          *   value options(*string)
     D   buf                           *   value

     D p_statds        S               *
     D statds          DS                  BASED(p_statds)
     D  st_mode                      10U 0
     D  st_ino                       10U 0
     D  st_nlink                      5U 0
     D  st_pad                        2A
     D  st_uid                       10U 0
     D  st_gid                       10U 0
     D  st_size                      10I 0
     D  st_atime                     10I 0
     D  st_mtime                     10I 0
     D  st_ctime                     10I 0
     D  st_dev                       10U 0
     D  st_blksize                   10U 0
     D  st_allocsize                 10U 0
     D  st_objtype                   12A
     D  st_codepage                   5U 0
     D  st_reserved1                 62A
     D  st_ino_gen_id                10U 0

     D MyStat          S                   like(statds)
     D MySize          S             10I 0


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
     D #referenz       s             15a   inz
     d days            s              2s 0
     d months          s              2s 0
     d eofyear         s              8s 0
     d no_teos         s              1s 0

     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE

       //   * get stat info into "MyStat":
       if stat('/TREND/echt/edi/in/dsx/plandaten.txt':
                               %addr(mystat)) < 0;
       //                      if        stat('/path/to/file.txt':
       //                                      %addr(mystat)) < 0;
       //                      callp     EscErrno(errno)
                               clear     status;
                               else;
                               clear     status;
                               endif;

       //   * move structure to overlay the "mystat" info:
                               eval      p_statds = %addr(mystat);

       //   * read the file's size into MySize:
                               eval      MySize = st_size;




       eval status ='Start ITEMIMPV1                     ';
       exsr      SR_log;

       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000001;

       //file imports
          exsr  srinit;

       //Aus Prozess nehmen wegen Fehler
          exec sql
            update ITEMIMPV1 set "RELEASE" ='E'
            WHERE #SKU in ( select TeewSKUN
            from teew01 where teewfirm='01')
            and "RELEASE" ='J'
            and
            #SKU not in ( select tetenr
            from teil01 where tefirm='01');


          open  ITEMIMPV1L;
          read  ITEMIMPV1L  ITEMIMPV1L_i;
          dow not %eof(ITEMIMPV1L);
       //// ,,,
             if ITEMIMPV1L_i.REFERENZ <> *blank;
                if #REFERENZ = *Blank or
                   #REFERENZ <> ITEMIMPV1L_i.REFERENZ;
       //          #REFERENZ = 'ON';
                   #REFERENZ = ITEMIMPV1L_i.REFERENZ;
                   exsr SR_REFERENZ;
                   open $teil$$;
                   open $teew$$;
                   open $tebb$$;
                   open $teuf$$;
                   open $teos$$;
                endif;
                ITEMIMPV1L_o          =  ITEMIMPV1L_i;
                exsr sr_teil;
                exsr sr_teew;
                exsr sr_tebb;
                exsr sr_teuf;
                exsr sr_teos;
                exsr sr_lpif;
                exsr sr_teal;
                ITEMIMPV1L_o.RELEASE  =  '#';
                update phy01r   ITEMIMPV1L_o;
             endif;
             read ITEMIMPV1L ITEMIMPV1L_i;
          enddo;
          close ITEMIMPV1L;

       //// LP1 Preise updaten
       exec sql
         insert into tvrelwaeco/PRL1UPDOUT
         SELECT '01', substr(b.#SKU, 1, 15), 'LP1', zoned(PREZPR*1, 9, 4) ,
         PRGADA,   PRGBDA , PRWACD,
         'Uebernahme ITEMSUPLOADRV                  ', TESTLF , ' ', ' ',
         ' ', 0,00, 0, 0, ' ', ' ', ' ', ' ' h1, current date h2, current
         timestamp h3, ' ' h4, current date h5, current timestamp h6 FROM
         ITEMIMPV1 b WHERE b.h1 = current date -0 day and
                           b.h5 > current time - 03 minutes  and
                           PREZPR > 0                        and
                           TESTLF <> ' '                     and
                           PRWACD <> ' '                     and
                           substr(b.#SKU, 1, 15) <> '1'      and
                           #sku <> '  ';
          callP PRL1UPDINR();
          callP PKDKUPDINR();
          callP PPKGUPDINR();

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;
       eval status ='Ende  ITEMIMPV1                     ';
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


       //QAEZD0006D Hilfsfile
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/xxxxx0006D)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/xxxxD0006D)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //IMPORT2400 Hilfsfile
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/IMPORT2400)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/IMPORT2400)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //orders from customers still on going

       if error1 = *blank;
          MONITOR;
          Wrk.var1 =
              'CPYFRMSTMF FROMSTMF'+
              '(''/LAGER/SCM/ItemsUploadV1.1.csv'') '+
              'TOMBR'+
              '(''/QSYS.LIB/TVRELWAECO.LIB/IMPORT2400.FILE/IMPORT2400.MBR'') '+
              'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='erledigt                   CPYFRMSTMF IMPORT2400  ';
             exsr      SR_log;
          on-error;
             status='error in command appeared: CPYFRMSTMF IMPORT2400  ';
             exsr      SR_log;
          endmon;

       §records = 0;
       exec sql
         select count(*) into :§records
         from tvrelwaeco/IMPORT2400;


       if §records > 0;

          MONITOR;
          Wrk.var1 =
              'CPYFRMIMPF FROMFILE(TVRELWAECO/IMPORT2400) ' +
              'TOFILE(TVRELWAECO/ITEMIMPV1) MBROPT(*add) ' +
              'FLDDLM('';'') DECPNT(*COMMA)                    ' +
              'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='erledigt                   CPYFRMIMPF ITEMIMPV1   ';
             exsr      SR_log;
          on-error;
             status='error in command appeared: CPYFRMIMPF ITEMIMPV1   ';
             exsr      SR_log;
          endmon;

          MONITOR;
          Wrk.var1 =
              'CD DIR(''/lager/SCM'') ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='CD DIR successful FILE(TVRELWAECO/ITEMIMPV1 )    ';
          on-error;
             status='Error by CD DIR object (TVRELWAECO/ITEMIMPV1 )   ';
          endmon;

          MONITOR;
          Wrk.var1 =
              'RMVLNK OBJLNK(''/LAGER/SCM/' +
              'ItemsUploadV1.1. done*'')';
            cmd = %TrimR(Wrk.Var1);
            l      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='rmvlnk successful removed file done history      ';
             exsr      SR_log;
          on-error;
             status='Error by rmvlnk object file done history         ';
             exsr      SR_log;
          endmon;

          MONITOR;
          Wrk.var1 =
              'RNM OBJ(''ItemsUploadV1.1.csv'') '+
              'NEWOBJ(''ItemsUploadV1.1. done.csv'')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='rnm    successful FILE(TVRELWAECO/ITEMIMPV1 )    ';
          on-error;
             status='Error by clrpfm object (TVRELWAECO/ITEMIMPV1 )   ';
          endmon;

       endif;
       endif;


       endsr;

       //-----------------------------------------------------------------------
       //Referenzdaten
       //-----------------------------------------------------------------------

       begsr sr_referenz;

       mydate = %date();
       days   = %subdt( %date(): *days );
       months = %subdt( %date(): *months );
       years  = %subdt( %date(): *years );
       eofyear= years*10000+12*100+31;


       //           TEIL 01
       exec sql
         delete from tvrelwaeco/$TEIL01;

       exec sql
         insert into tvrelwaeco/$TEIL01
         SELECT * FROM teil01 WHERE TEFIRM ='01' and
       //         tetenr in (select DISTINCT referenz FROM ITEMIMPV1l);
                  tetenr = :#referenz;

       exec sql
         create index  $teil$$  on   $TEIL01
         (tefirm, tetenr);

       //           TEEW 02
       exec sql
         delete from tvrelwaeco/$TEEW01;

       exec sql
         insert into tvrelwaeco/$TEEW01
         SELECT * FROM TEEW01 WHERE  TEEWFIRM ='01' and
       //         TEEWTENR in (select DISTINCT referenz FROM ITEMIMPV1l);
                  TEEWTENR = :#referenz;

       exec sql
         create index  $teew$$  on   $TEEW01
         (TEEWFIRM, TEEWTENR);

       //           TEBB 03
       exec sql
         delete from tvrelwaeco/$TEBB01;

       exec sql
         insert into tvrelwaeco/$TEBB01
         SELECT * FROM TEBB01 WHERE  TEBBFIRM ='01' and
       //         TEBBTENR in (select DISTINCT referenz FROM ITEMIMPV1l);
                  TEBBTENR = :#referenz;

       exec sql
         create index  $tebb$$  on   $TEBB01
         (TEBBFIRM, TEBBTENR, TEBBAENR, TEBBABTL);

       //           TEUF 04
       exec sql
         delete from tvrelwaeco/$TEUF01;

       exec sql
         insert into tvrelwaeco/$TEUF01
         SELECT * FROM TEUF01 WHERE  TUFIRM   ='01' and
       //         TUTENR  in (select DISTINCT referenz FROM ITEMIMPV1l);
                  TUTENR   = :#referenz;

       exec sql
         create index  $teuf$$  on   $TEuf01
         (TUFIRM, TUTENR, TUMEIN);

       //           TEOS 05
       exec sql
         delete from tvrelwaeco/$TEOS01;

       exec sql
         insert into tvrelwaeco/$TEOS01
         SELECT * FROM TEOS01 WHERE  TEOSFIRM   ='01' and
       //         TEOSTENR  in (select DISTINCT referenz FROM ITEMIMPV1l);
                  TEOSTENR = :#referenz;

       exec sql
         create index  $teos$$  on   $TEos01
         (TEOSFIRM, TEOSKLCD, TEOSTENR);

       //           TEVP 06
       exec sql
         delete from tvrelwaeco/$TEVP01;

       exec sql
         insert into tvrelwaeco/$TEVP01
         SELECT * FROM TEVP01 WHERE  TEVPFIRM   ='01' and
       //         TEVPTENR  in (select DISTINCT referenz FROM ITEMIMPV1l);
                  TEVPTENR = :#referenz;

       exec sql
         create index  $tevp$$  on   $TEvp01
         (TEVPFIRM, TEVPTENR);

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Teil 01
       //-----------------------------------------------------------------------

       begsr sr_teil;
       //teil 01
          teil_k.tefirm     =  '01';
          teil_k.tetenr     =  ITEMIMPV1L_i.#sku;
          chain %kds(teil_k:2) teil01  teil_I;
          if %found(teil01);
       //    no action
             teil_o         =  teil_i;
             if ITEMIMPV1L_i.#EAN <> *blank;
                teil_o.TEEANR  = ITEMIMPV1L_i.#EAN;
             endif;
             if ITEMIMPV1L_i.#DESCENG <> *blank;
                teil_o.TETBZ1  = ITEMIMPV1L_i.#DESCENG;
             endif;
       //    27LIEF-VORL-ZT.E
             if ITEMIMPV1L_i.LPLZTG <> *zero;
                teil_o.TELVZ1  = ITEMIMPV1L_i.LPLZTG;
             endif;
       //    28LIEF-VORL-ARTE
             if ITEMIMPV1L_i.LPLZTD <> '0' and
                ITEMIMPV1L_i.LPLZTD <> *blank;
                teil_o.TELVA1  = ITEMIMPV1L_i.LPLZTD;
             endif;

             if ITEMIMPV1L_i.TESTLF <> *blank;
                teil_o.TESTLF  = ITEMIMPV1L_i.TESTLF;
             endif;
             if ITEMIMPV1L_i.TEABC1 <> '0' and
                ITEMIMPV1L_i.TEABC1 <> *blank;
                teil_o.TEABC1  = ITEMIMPV1L_i.TEABC1;
             endif;
             if ITEMIMPV1L_i.TESTPR <> *zero;
                teil_o.TESTPR  = ITEMIMPV1L_i.TESTPR;
             else;
             endif;
             if ITEMIMPV1L_i.TEWEMT <> '0' and
                ITEMIMPV1L_i.TEWEMT <> *blank;
                teil_o.TEWEMT  = ITEMIMPV1L_i.TEWEMT;
             endif;
             if ITEMIMPV1L_i.TETART <> '0' and
                ITEMIMPV1L_i.TETART <> *blank;
                teil_o.TETART  = ITEMIMPV1L_i.TETART;
             endif;
             if ITEMIMPV1L_i.TEMAGR <> ' 00' and
                ITEMIMPV1L_i.TEMAGR <> '   ';
                teil_o.TEMAGR  = ITEMIMPV1L_i.TEMAGR;
             endif;
             if ITEMIMPV1L_i.TEPRGR <> ' 00' and
                ITEMIMPV1L_i.TEPRGR <> '   ';
                teil_o.TEPRGR  = ITEMIMPV1L_i.TEPRGR;
             endif;
             if ITEMIMPV1L_i.TESAEK <> '000' and
                ITEMIMPV1L_i.TESAEK <> '   ';
                teil_o.TESAEK  = ITEMIMPV1L_i.TESAEK;
             endif;
             if ITEMIMPV1L_i.TEDIEK <> '000' and
                ITEMIMPV1L_i.TEDIEK <> '   ';
                teil_o.TEDIEK  = ITEMIMPV1L_i.TEDIEK;
             endif;
             if ITEMIMPV1L_i.TEURLD <> '000' and
                ITEMIMPV1L_i.TEURLD <> '   ';
                teil_o.TEURLD  = ITEMIMPV1L_i.TEURLD;
             endif;
             if ITEMIMPV1L_i.TEUREG <> '000' and
                ITEMIMPV1L_i.TEUREG <> '   ';
                teil_o.TEUREG  = ITEMIMPV1L_i.TEUREG;
             endif;
             if ITEMIMPV1L_i.TEMCBG <> *blank;
                teil_o.TEMCBG  = ITEMIMPV1L_i.TEMCBG;
             endif;
             if ITEMIMPV1L_i.TEARKZ <> '00' and
                ITEMIMPV1L_i.TEARKZ <> '  ';
                teil_o.TEARKZ  = ITEMIMPV1L_i.TEARKZ;
             endif;
             if ITEMIMPV1L_i.TEZPUR <> '00' and
                ITEMIMPV1L_i.TEZPUR <> '  ';
                teil_o.TEZPUR  = ITEMIMPV1L_i.TEZPUR;
             endif;
             if ITEMIMPV1L_i.TELANG# <> *zero;
                teil_o.TELANG  = ITEMIMPV1L_i.TELANG#*1  ;
             endif;
             if ITEMIMPV1L_i.TEBREI# <> *zero;
                teil_o.TEBREI  = ITEMIMPV1L_i.TEBREI#*1  ;
             endif;
             if ITEMIMPV1L_i.TEHOHE# <> *zero;
                teil_o.TEHOHE  = ITEMIMPV1L_i.TEHOHE#*1  ;
             endif;
             if ITEMIMPV1L_i.TEGWNT# <> *zero;
                teil_o.TEGWNT  = ITEMIMPV1L_i.TEGWNT#;
             endif;
             if ITEMIMPV1L_i.TEGWBR# <> *zero;
                teil_o.TEGWBR  = ITEMIMPV1L_i.TEGWBR#;
             endif;
             if ITEMIMPV1L_i.TEZOAN  =  'J'   or
                ITEMIMPV1L_i.TEZOAN  =  'N';
                teil_o.TEZOAN  = ITEMIMPV1L_i.TEZOAN;
             endif;
             if ITEMIMPV1L_i.#SUBST  <> *blank;
                teil_o.TEERTE  = ITEMIMPV1L_i.#SUBST;
             endif;

       // ?? teil_o.TETEST  = '41';
             if ITEMIMPV1L_i.TETEST  <> *blank;
                teil_o.TETEST  = ITEMIMPV1L_i.TETEST;
             endif;
             teil_o.TEJNAM  = §§§job;
             teil_o.TEJDAT  = %dec(%char(%date():*iso0):8:0);
             teil_o.TEJZEI  = %dec(%char(%time():*iso0):6:0);
             teil_o.TEUSER  = §§§usr;
             teil_o.TEPROG  = §§§pgm;
             update teil1     teil_o;
       //    no action
          else;
             $teil$$_k.tefirm  =  '01';
             $teil$$_k.tetenr  =  ITEMIMPV1L_i.REFERENZ;
             chain %kds($teil$$_k:2) $teil$$  $teil$$_I;
             if %found($teil$$);
                teil_o         =  $teil$$_i;
                teil_o.TEFIRM  ='01';
                teil_o.TETENR  = ITEMIMPV1L_i.#sku;
                if ITEMIMPV1L_i.#EAN <> *blank;
                   teil_o.TEEANR  = ITEMIMPV1L_i.#EAN;
                else;
                   teil_o.TEEANR  = '0000000000';
                endif;
                if ITEMIMPV1L_i.#DESCENG <> *blank;
                   teil_o.TETBZ1  = ITEMIMPV1L_i.#DESCENG;
                else;
                   teil_o.TETBZ1  = 'bitte ergänzen';
                endif;
       //       27LIEF-VORL-ZT.E
                if ITEMIMPV1L_i.LPLZTG <> *zero;
                   teil_o.TELVZ1  = ITEMIMPV1L_i.LPLZTG;
                endif;
       //       28LIEF-VORL-ARTE
                if ITEMIMPV1L_i.LPLZTD <> '0' and
                   ITEMIMPV1L_i.LPLZTD <> *blank;
                   teil_o.TELVA1  = ITEMIMPV1L_i.LPLZTD;
                endif;

                if ITEMIMPV1L_i.TESTLF <> *blank;
                   teil_o.TESTLF  = ITEMIMPV1L_i.TESTLF;
                endif;
                if ITEMIMPV1L_i.TEABC1 <> '0' and
                   ITEMIMPV1L_i.TEABC1 <> *blank;
                   teil_o.TEABC1  = ITEMIMPV1L_i.TEABC1;
                endif;
                if ITEMIMPV1L_i.TESTPR <> *zero;
                   teil_o.TESTPR  = ITEMIMPV1L_i.TESTPR;
                else;
                   teil_o.TESTPR  = *zero;
                endif;
                if ITEMIMPV1L_i.TEWEMT <> '0' and
                   ITEMIMPV1L_i.TEWEMT <> *blank;
                   teil_o.TEWEMT  = ITEMIMPV1L_i.TEWEMT;
                endif;
                if ITEMIMPV1L_i.TETART <> '0' and
                   ITEMIMPV1L_i.TETART <> *blank;
                   teil_o.TETART  = ITEMIMPV1L_i.TETART;
                endif;
                if ITEMIMPV1L_i.TEMAGR <> ' 00' and
                   ITEMIMPV1L_i.TEMAGR <> '   ';
                   teil_o.TEMAGR  = ITEMIMPV1L_i.TEMAGR;
                endif;
                if ITEMIMPV1L_i.TEPRGR <> ' 00' and
                   ITEMIMPV1L_i.TEPRGR <> '   ';
                   teil_o.TEPRGR  = ITEMIMPV1L_i.TEPRGR;
                endif;
                if ITEMIMPV1L_i.TESAEK <> '000' and
                   ITEMIMPV1L_i.TESAEK <> '   ';
                   teil_o.TESAEK  = ITEMIMPV1L_i.TESAEK;
                endif;
                if ITEMIMPV1L_i.TEDIEK <> '000' and
                   ITEMIMPV1L_i.TEDIEK <> '   ';
                   teil_o.TEDIEK  = ITEMIMPV1L_i.TEDIEK;
                endif;
                if ITEMIMPV1L_i.TEURLD <> '000' and
                   ITEMIMPV1L_i.TEURLD <> '   ';
                   teil_o.TEURLD  = ITEMIMPV1L_i.TEURLD;
                endif;
                if ITEMIMPV1L_i.TEUREG <> '000' and
                   ITEMIMPV1L_i.TEUREG <> '   ';
                   teil_o.TEUREG  = ITEMIMPV1L_i.TEUREG;
                endif;
                if ITEMIMPV1L_i.TEMCBG <> *blank;
                   teil_o.TEMCBG  = ITEMIMPV1L_i.TEMCBG;
                endif;
                if ITEMIMPV1L_i.TEARKZ <> '00' and
                   ITEMIMPV1L_i.TEARKZ <> '  ';
                   teil_o.TEARKZ  = ITEMIMPV1L_i.TEARKZ;
                endif;
                if ITEMIMPV1L_i.TEZPUR <> '00' and
                   ITEMIMPV1L_i.TEZPUR <> '  ';
                   teil_o.TEZPUR  = ITEMIMPV1L_i.TEZPUR;
                endif;
                if ITEMIMPV1L_i.TELANG# <> *zero;
                   teil_o.TELANG  = ITEMIMPV1L_i.TELANG#*1  ;
                endif;
                if ITEMIMPV1L_i.TEBREI# <> *zero;
                   teil_o.TEBREI  = ITEMIMPV1L_i.TEBREI#*1  ;
                endif;
                if ITEMIMPV1L_i.TEHOHE# <> *zero;
                   teil_o.TEHOHE  = ITEMIMPV1L_i.TEHOHE#*1  ;
                endif;
                if ITEMIMPV1L_i.TEGWNT# <> *zero;
                   teil_o.TEGWNT  = ITEMIMPV1L_i.TEGWNT#;
                endif;
                if ITEMIMPV1L_i.TEGWBR# <> *zero;
                   teil_o.TEGWBR  = ITEMIMPV1L_i.TEGWBR#;
                endif;
                if ITEMIMPV1L_i.TEZOAN  =  'J'   or
                   ITEMIMPV1L_i.TEZOAN  =  'N';
                   teil_o.TEZOAN  = ITEMIMPV1L_i.TEZOAN;
                endif;
                if ITEMIMPV1L_i.#SUBST  <> *blank;
                   teil_o.TEERTE  = ITEMIMPV1L_i.#SUBST;
                endif;

                teil_o.TETEST  = '41';
                if ITEMIMPV1L_i.TETEST  <> *blank;
                   teil_o.TETEST  = ITEMIMPV1L_i.TETEST;
                endif;
                teil_o.TEJNAM  = §§§job;
                teil_o.TEJDAT  = %dec(%char(%date():*iso0):8:0);
                teil_o.TEJZEI  = %dec(%char(%time():*iso0):6:0);
                teil_o.TEUSER  = §§§usr;
                teil_o.TEPROG  = §§§pgm;
                write  teil1     teil_o;
             endif;
          endif;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Teew 02
       //-----------------------------------------------------------------------

       begsr sr_teew;
       //Teew 02
          Teew_k.Teewfirm     =  '01';
          Teew_k.Teewtenr     =  ITEMIMPV1L_i.#sku;
          chain %kds(Teew_k:2) Teew01  Teew_I;
          if %found(Teew01);
       //    no action
             Teew_o         =  Teew_i;

             if Teew_o.TeewSKUN  = *blank;
                Teew_o.TeewSKUN  = ITEMIMPV1L_i.#sku;
             endif;

             Teew_o.TeewPACD  = ITEMIMPV1L_i.#PAREA;
             Teew_o.TeewPRGR  = ITEMIMPV1L_i.#PGRP ;

             Teew_o.TeewJNAM  = §§§job;
             Teew_o.TeewJDAT  = %dec(%char(%date():*iso0):8:0);
             Teew_o.TeewJZEI  = %dec(%char(%time():*iso0):6:0);
             Teew_o.TeewUSER  = §§§usr;
             Teew_o.TeewPROG  = §§§pgm;
             update Teew1     Teew_o;

       //    no action
          else;
             $Teew$$_k.Teewfirm  =  '01';
             $Teew$$_k.Teewtenr  =  ITEMIMPV1L_i.REFERENZ;
             chain %kds($Teew$$_k:2) $Teew$$  $Teew$$_I;
             if %found($Teew$$);
                Teew_o         =  $Teew$$_i;
                Teew_o.TeewFIRM  ='01';
                Teew_o.TeewTENR  = ITEMIMPV1L_i.#sku;

                Teew_o.TeewSKUN  = ITEMIMPV1L_i.#sku;
                Teew_o.TeewPACD  = ITEMIMPV1L_i.#PAREA;
                Teew_o.TeewPRGR  = ITEMIMPV1L_i.#PGRP ;

                Teew_o.TeewJNAM  = §§§job;
                Teew_o.TeewJDAT  = %dec(%char(%date():*iso0):8:0);
                Teew_o.TeewJZEI  = %dec(%char(%time():*iso0):6:0);
                Teew_o.TeewUSER  = §§§usr;
                Teew_o.TeewPROG  = §§§pgm;
                write  Teew1     Teew_o;
             endif;
          endif;

       endsr;
       // ______________________________________________________________________


       //-----------------------------------------------------------------------
       //Tebb 03 als Schleife?
       //-----------------------------------------------------------------------

       begsr sr_Tebb;
       //Tebb 03
          Tebb_k.Tebbfirm     =  '01';
          Tebb_k.Tebbtenr     =  ITEMIMPV1L_i.#sku;
          chain %kds(Tebb_k:2) Tebb01  Tebb_I;
          if %found(Tebb01);
       //    no action
             Tebb_o         =  Tebb_i;

             Tebb_o.TebbJNAM  = §§§job;
             Tebb_o.TebbJDAT  = %dec(%char(%date():*iso0):8:0);
             Tebb_o.TebbJZEI  = %dec(%char(%time():*iso0):6:0);
             Tebb_o.TebbUSER  = §§§usr;
             Tebb_o.TebbPROG  = §§§pgm;
             update  Tebb1     Tebb_o;
       //    no action
          else;
             $Tebb$$_k.Tebbfirm  =  '01';
             $Tebb$$_k.Tebbtenr  =  ITEMIMPV1L_i.REFERENZ;
             chain %kds($Tebb$$_k:2) $Tebb$$  $Tebb$$_I;
             if %found($Tebb$$);
                Tebb_o         =  $Tebb$$_i;
                Tebb_o.TebbFIRM  ='01';
                Tebb_o.TebbTENR  = ITEMIMPV1L_i.#sku;


                Tebb_o.TebbJNAM  = §§§job;
                Tebb_o.TebbJDAT  = %dec(%char(%date():*iso0):8:0);
                Tebb_o.TebbJZEI  = %dec(%char(%time():*iso0):6:0);
                Tebb_o.TebbUSER  = §§§usr;
                Tebb_o.TebbPROG  = §§§pgm;
                write  Tebb1     Tebb_o;
             endif;
          endif;

       endsr;
       // ______________________________________________________________________


       //-----------------------------------------------------------------------
       //Teuf 04 als Schleife!!!
       //-----------------------------------------------------------------------

       begsr sr_Teuf;

       //Teuf 04
          $Teuf$$_k.Tufirm  =  '01';
          $Teuf$$_k.Tutenr  =  ITEMIMPV1L_i.REFERENZ;
          setll %kds($Teuf$$_k:2) $Teuf$$;
          reade %kds($Teuf$$_k:2) $Teuf$$  $Teuf$$_I;
          dow not %eof($Teuf$$);

             Teuf_k.TUfirm     =  '01';
             Teuf_k.TUtenr     =  ITEMIMPV1L_i.#sku;
             Teuf_k.TUmein     =  $Teuf$$_i.TUmein;
             chain %kds(Teuf_k:3) Teuf01  Teuf_I;
             if %found(Teuf01);
       //       no action
                Teuf_o         =  teuf_i;

                Teuf_o.TuJNAM  = §§§job;
                Teuf_o.TuJDAT  = %dec(%char(%date():*iso0):8:0);
                Teuf_o.TuJZEI  = %dec(%char(%time():*iso0):6:0);
                Teuf_o.TuUSER  = §§§usr;
                Teuf_o.TuPROG  = §§§pgm;
                update Teuf1     Teuf_o;
       //       no action
             else;
                Teuf_o         =  $Teuf$$_i;
                Teuf_o.TuFIRM  ='01';
                Teuf_o.TuTENR  = ITEMIMPV1L_i.#sku;


                Teuf_o.TuJNAM  = §§§job;
                Teuf_o.TuJDAT  = %dec(%char(%date():*iso0):8:0);
                Teuf_o.TuJZEI  = %dec(%char(%time():*iso0):6:0);
                Teuf_o.TuUSER  = §§§usr;
                Teuf_o.TuPROG  = §§§pgm;
                write  Teuf1     Teuf_o;
             endif;
             reade %kds($Teuf$$_k:2) $Teuf$$  $Teuf$$_I;
          enddo;
       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Teos 05 als schleife!!!
       //-----------------------------------------------------------------------

       begsr sr_Teos;
       //Teos 05
          no_teos = 0;
          $Teos$$_k.Teosfirm  =  '01';
          setll %kds($Teos$$_k:1) $Teos$$;
          reade %kds($Teos$$_k:1) $Teos$$  $Teos$$_I;
          dow not %eof($Teos$$);
             if $Teos$$_i.Teostenr  =  ITEMIMPV1L_i.REFERENZ;
                Teos_k.Teosfirm     =  '01';
                Teos_k.TeosKLCD     =  $Teos$$_i.TEOSKLCD;
                Teos_k.Teostenr     =  ITEMIMPV1L_i.#sku;
                chain %kds(Teos_k:3) Teos01  Teos_I;
                if %found(Teos01);
       //          no action
                   teos_o         =  teos_i;
                   if teos_o.teosKLCD = 'SKU';
                      teos_o.TEOSMM01  = ITEMIMPV1L_i.#sku;
                   endif;
                   if teos_o.teosKLCD = 'IDCO';
                      teos_o.TEOSMM01  = ITEMIMPV1L_i.TEOSMM01;
                   endif;

                   teos_o.teosJNAM  = §§§job;
                   teos_o.teosJDAT  = %dec(%char(%date():*iso0):8:0);
                   teos_o.teosJZEI  = %dec(%char(%time():*iso0):6:0);
                   teos_o.teosUSER  = §§§usr;
                   teos_o.teosPROG  = §§§pgm;
                   update teos1     teos_o;
       //          no action
                   no_teos = 1;
                else;
                   teos_o         =  $teos$$_i;
                   teos_o.teosFIRM  ='01';
                   teos_o.teosTENR  = ITEMIMPV1L_i.#sku;
                   if teos_o.teosKLCD = 'SKU';
                      teos_o.TEOSMM01  = ITEMIMPV1L_i.#sku;
                   endif;
                   if teos_o.teosKLCD = 'IDCO';
                      teos_o.TEOSMM01  = ITEMIMPV1L_i.TEOSMM01;
                   endif;

                   teos_o.teosJNAM  = §§§job;
                   teos_o.teosJDAT  = %dec(%char(%date():*iso0):8:0);
                   teos_o.teosJZEI  = %dec(%char(%time():*iso0):6:0);
                   teos_o.teosUSER  = §§§usr;
                   teos_o.teosPROG  = §§§pgm;
                   write  teos1     teos_o;
                   no_teos = 1;
                endif;
             endif;
             reade %kds($Teos$$_k:1) $Teos$$  $Teos$$_I;
          enddo;

          Teos_k.Teosfirm     =  '01';
          Teos_k.TeosKLCD     =  'SKU ';
          Teos_k.Teostenr     =  ITEMIMPV1L_i.#sku;
          chain %kds(Teos_k:3) Teos01  Teos_I;
          if %found(Teos01);
       //    no action
             no_teos = 1;
          else;
             Teos_k.Teosfirm     =  '01';
             Teos_k.TeosKLCD     =  'IDCO';
             Teos_k.Teostenr     =  ITEMIMPV1L_i.#sku;
             chain %kds(Teos_k:3) Teos01  Teos_I;
             if %found(Teos01);
       //       no action
                no_teos = 1;
             endif;
          endif;

          if no_teos = 0;
             clear teos_o;
             teos_o.teosFIRM  ='01';
             teos_o.teosTENR  = ITEMIMPV1L_i.#sku;
             teos_o.teosKLCD = 'SKU';
             teos_o.TEOSMM01  = ITEMIMPV1L_i.#sku;

             teos_o.teosJNAM  = §§§job;
             teos_o.teosJDAT  = %dec(%char(%date():*iso0):8:0);
             teos_o.teosJZEI  = %dec(%char(%time():*iso0):6:0);
             teos_o.teosUSER  = §§§usr;
             teos_o.teosPROG  = §§§pgm;
             write  teos1     teos_o;

             teos_o.teosKLCD = 'IDCO';
             teos_o.TEOSMM01  = ITEMIMPV1L_i.TEOSMM01;
             write  teos1     teos_o;

          endif;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //LPIF
       //-----------------------------------------------------------------------

       begsr sr_lpif;
       //Lpif
          Lpif_k.LPFIRM       =  '01';
          Lpif_k.LPLFNR       =  ITEMIMPV1L_i.TESTLF;
          Lpif_k.LPTENR       =  ITEMIMPV1L_i.#SKU;
          if  ITEMIMPV1L_i.PRGADA = *zero;
              Lpif_k.LPGADA       =  %dec(%char(%date():*iso0):8:0);
          else;
              Lpif_k.LPGADA       =  ITEMIMPV1L_i.PRGADA;
          endif;
          chain %kds(Lpif_k:4) Lpif01  Lpif_I;
          if %found(Lpif01);
       //    no action
       //Achtung ab Datum teil des Schlüssels

       //    no action
          else;
       //    LPIF_o NEU; ******
             clear  LPIF_o;
             Lpif_o.LPFIRM  ='01';
             Lpif_o.LPLFNR  = ITEMIMPV1L_i.TESTLF;
             Lpif_o.LPTENR  = ITEMIMPV1L_i.#sku;
             if  ITEMIMPV1L_i.PRGADA = *zero;
                 Lpif_o.LPGADA       =  %dec(%char(%date():*iso0):8:0);
             else;
                 Lpif_o.LPGADA       =  ITEMIMPV1L_i.PRGADA;
             endif;
             Lpif_o.LPIDEN  = ITEMIMPV1L_i.LPIDEN;
             Lpif_o.LPMIBM  = ITEMIMPV1L_i.LPMIBM;
             Lpif_o.LPLZTG  = ITEMIMPV1L_i.LPLZTG;
             Lpif_o.LPLZTD  = ITEMIMPV1L_i.LPLZTD;
             Lpif_o.LPHKLD  = ITEMIMPV1L_i.teURLD;
             Lpif_o.LPUREG  = ITEMIMPV1L_i.teUREG;

             Lpif_o.LPBONU  = 'J';
             Lpif_o.LPDRIB  = 'J';
             Lpif_o.LPLFKZ  = 'J';

             Lpif_o.LPJNAM  = §§§job;
             Lpif_o.LPJDAT  = %dec(%char(%date():*iso0):8:0);
             Lpif_o.LPJZEI  = %dec(%char(%time():*iso0):6:0);
             Lpif_o.LPUSER  = §§§usr;
             Lpif_o.LPPROG  = §§§pgm;
             if     Lpif_o.LPFIRM <> Lpif_i.LPFIRM  or
                    Lpif_o.LPLFNR <> Lpif_i.LPLFNR  or
                    Lpif_o.LPTENR <> Lpif_i.LPTENR  or
                    Lpif_o.LPIDEN <> Lpif_i.LPIDEN  or
                    Lpif_o.LPMIBM <> Lpif_i.LPMIBM  or
                    Lpif_o.LPLZTG <> Lpif_i.LPLZTG  or
                    Lpif_o.LPLZTD <> Lpif_i.LPLZTD  or
                    Lpif_o.LPHKLD <> Lpif_i.LPHKLD  or
                    Lpif_o.LPUREG <> Lpif_i.LPUREG  or
                    Lpif_o.LPBONU <> Lpif_i.LPBONU  or
                    Lpif_o.LPDRIB <> Lpif_i.LPDRIB  or
                    Lpif_o.LPLFKZ <> Lpif_i.LPLFKZ;
                    write  Lpif1     Lpif_o;
             endif;
          endif;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //teal
       //-----------------------------------------------------------------------

       begsr sr_teal;
       //teal über #sku
          teal_k.TLFIRM       =  '01';
          teal_k.TLTENR       =  ITEMIMPV1L_i.#SKU;
          chain %kds(teal_k:2) teal01  teal_I;
          if %found(teal01);
       //    no action
             teal_o         =  teal_i;
       //    teal_o.TLALTE  = ITEMIMPV1L_i.#SUBST;
             teal_o.TLALTE  = ITEMIMPV1L_i.TLALTE;

             teal_o.TLJNAM  = §§§job;
             teal_o.TLJDAT  = %dec(%char(%date():*iso0):8:0);
             teal_o.TLJZEI  = %dec(%char(%time():*iso0):6:0);
             teal_o.TLUSER  = §§§usr;
             teal_o.TLPROG  = §§§pgm;
             if teal_o.TLALTE  <> *Blank and
                teal_o.TLALTE  <> teal_i.TLALTE;
                update teal1     teal_o;
             endif;
       //    no action
          else;
       //    teal_o NEU; ******
             clear  teal_o;
             teal_o.TLFIRM  ='01';
             teal_o.TLTENR  = ITEMIMPV1L_i.#sku;

       //    teal_o.TLALTE  = ITEMIMPV1L_i.#SUBST;
             teal_o.TLALTE  = ITEMIMPV1L_i.TLALTE;

             teal_o.TLJNAM  = §§§job;
             teal_o.TLJDAT  = %dec(%char(%date():*iso0):8:0);
             teal_o.TLJZEI  = %dec(%char(%time():*iso0):6:0);
             teal_o.TLUSER  = §§§usr;
             teal_o.TLPROG  = §§§pgm;
             if teal_o.TLALTE  <> *Blank;
                write  teal1     teal_o;
             endif;
          endif;

       //teal über #SUBST
          teal_k.TLFIRM       =  '01';
          teal_k.TLTENR       =  ITEMIMPV1L_i.#SUBST;
          chain %kds(teal_k:2) teal01  teal_I;
          if %found(teal01);
       //    no action
             teal_o         =  teal_i;
             teal_o.TLALTE  = ITEMIMPV1L_i.#SKU;

             teal_o.TLJNAM  = §§§job;
             teal_o.TLJDAT  = %dec(%char(%date():*iso0):8:0);
             teal_o.TLJZEI  = %dec(%char(%time():*iso0):6:0);
             teal_o.TLUSER  = §§§usr;
             teal_o.TLPROG  = §§§pgm;
             if teal_o.TLALTE  <> *Blank and
                teal_o.TLALTE  <> teal_i.TLALTE;
                update teal1     teal_o;
             endif;
       //    no action
          else;
       //    teal_o NEU; ******
             clear  teal_o;
             teal_o.TLFIRM  ='01';
             teal_o.TLALTE  = ITEMIMPV1L_i.#SKU;

             teal_o.TLJNAM  = §§§job;
             teal_o.TLJDAT  = %dec(%char(%date():*iso0):8:0);
             teal_o.TLJZEI  = %dec(%char(%time():*iso0):6:0);
             teal_o.TLUSER  = §§§usr;
             teal_o.TLPROG  = §§§pgm;
             if teal_o.TLALTE  <> *Blank;
                write  teal1     teal_o;
             endif;
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
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/UEBERGABE) '+
                'MBROPT(*REPLACE) STRDLM(''"'') '+
                'RMVBLANK(*BOTH) FLDDLM('';'') DECPNT(*COMMA) ';
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


