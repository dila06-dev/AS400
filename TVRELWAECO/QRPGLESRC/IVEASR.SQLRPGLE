
      //************************************************************************
      //
      //      Programmname       iveas
      //      Erstellt  am       17.11.2020
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Iveas interfaces auslesen
      //                         call t3aflkst
      //                         CALL PGM(IVEASR) PARM('001' '2020' 'L' '210547' ' ')
      //
      //      select * from VLF95DWE/frdtn a left outer join VLF95DWE/frdtp b on
      //      a.fir = b.fir and
      //      a.btnr = b.btnr and
      //      a.elj = b.elj and
      //      a.vsnr = b.vsnr and
      //      a.vspn = b.vspn
      //      where a.lnam1  like '%xxxxxxx%' or a.lnam2  like '%yyyyyyy%' or
      //            a.lnam1  like '%XXXXXXX%' or a.lnam2  like '%YYYYYYY%' or
      //            where a.lsnr ='2020480234'
      //
      //      CPYFRMSTMF FROMSTMF('/IVEAS/210547.BAK')
      //             TOMBR('/QSYS.LIB/QTEMP.LIB/IVEAS_I.FILE/IVEAS_I.MBR')
      //                      MBROPT(*REPLACE)
      //      Datenstromdatei in Objekt kopiert.
      //
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
      // CRTSRCPF FILE(TVRELWAECO/IVEAS_I) RCDLEN(2400)
      // TEXT('DATA STREAM FOR IVEAS 2400 BYTES')
      //
      // CPYFRMSTMF FROMSTMF('/IVEAS/478451.BAK')
      // TOMBR('/QSYS.LIB/TVRELWAECO.LIB/IVEAS_I.FILE/IVEASI.MBR')
      // MBROPT(*REPLACE)
      //
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

      /eject
      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------


     d IVEASR          PR
     d p_MANDANT                      3a
     d p_KJAHR                        4a
     d p_KRL                          1a
     d p_KRECHLIEF                    6a
     d p_cc                           1
      //                         CALL PGM(IVEASR) PARM('001' '2020' 'L' '210996' ' ')

     d IVEASR          PI
     d p_MANDANT                      3a
     d p_KJAHR                        4a
     d p_KRL                          1a
     d p_KRECHLIEF                    6a
     d p_cc                           1

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
       // WAOUPSSJ
       // ______________________________________________________________________
     D WAOUPSSJ        PR                  ExtPgm('WAOUPSSJ')
     D WKLIBL                        10A
     D WKFIRM                         2A
     D WKENVI                        10A

       // ______________________________________________________________________
       // §RTVJOBA
       // ______________________________________________________________________
     D §RTVJOBA        PR                  ExtPgm('§RTVJOBA')
     D fkt                           10A
     D §curlib                       10A
     D §usrlib                     2750A

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
       eval status ='Start Iveas Interface IVEASR ' + p_MANDANT   + ' ' +
                                                      p_Kjahr     + ' ' +
                                                      P_KRL       + ' ' +
                                                      p_KRECHLIEF + ' ' +
                                                      p_cc;
       exsr      SR_log;

       // exsr  file_out;
       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
          exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          exsr  file_out;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

       eval status ='Ende  Iveas Interface IVEASR ' + p_MANDANT   + ' ' +
                                                      p_Kjahr     + ' ' +
                                                      P_KRL       + ' ' +
                                                      p_KRECHLIEF + ' ' +
                                                      p_cc;
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
         p_cc    = '1';

       //temporäre Dateien bereinigen **********************************
         exsr sr_clrpfm;

       //CRTDUPOBJ Dateien erstellen **********************************
         exsr sr_crtdupo;

       //call auf Trend ***********************************************
       //               ersetzt (call t3aflkstSR)**********************
       //vorher Datei MODWAO/WAOUPS füllen ****************************
         WKLIBL = 'MODWAO   ';
         WKFIRM = '01';
         WKENVI = 'TEST     ';
         WKENVI = 'ECHT     ';

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(MODWAO/WAOUPS)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM MODWAO/WAOUPS                       ';
               exsr      SR_log;
               status = §§§MTX;
               p_cc    = 'E';
               exsr      SR_log;
         endmon;


       //Übertragung aus IVEAS Verzeichnis (stream)
         eval §DELIVER_N =  '/IVEAS/' +
                            p_KRECHLIEF +
                            '.TXT';

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(('''+ §DELIVER_N +'''))';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed AVAILABLE*             ';
       // exsr      SR_log;
       on-error;
          status='Error by rmvlnk object' +
          §DELIVER_N;
       // exsr      SR_log;
       endmon;


       if p_cc    = '1';
          if P_KRL   = 'R';
             exec sql
             insert into modwao/waoups
             select substr(:p_MANDANT, 2, 2)   as WAOUFIRM,
                    substr(:p_Kjahr, 1, 4)     as WAOURGJJ,
                    substr(:p_KRECHLIEF, 1, 6) as WAOURGNR,
                    00                         as WAOULIJJ,
                    ' '                        as WAOULINR
                    from  qsys2/qsqptabl;
          endif;
          if P_KRL   = 'L';
             exec sql
             insert into modwao/waoups
             select substr(:p_MANDANT, 2, 2)   as WAOUFIRM,
                    00                         as WAOURGJJ,
                    ' '                        as WAOURGNR,
                    substr(:p_Kjahr, 1, 4)     as WAOULIJJ,
                    substr(:p_KRECHLIEF, 1, 6) as WAOULINR
                    from  qsys2/qsqptabl;
          endif;
       endif;


       //call auf Sicherung der liblist********************************
         FKT    = 'LOAD  ';
         §CURLIB= *blank;
         §USRLIB= *blank;
         callP §RTVJOBA(FKT: §CURLIB: §USRLIB);

       //call auf Trend ***********************************************
       //               ersetzt (call t3aflkstSR)**********************
         callP WAOUPSSJ(WKLIBL: WKFIRM: WKENVI);

       //call auf RE Sicherung der liblist*****************************
         FKT    = 'RELOAD';
         callP §RTVJOBA(FKT: §CURLIB: §USRLIB);


         if err_msg = ' ';

         MONITOR;
            Wrk.var1 =
                'CHGCURDIR DIR(''/IVEAS/'')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CHGCURDIR                                  ';
       //      exsr      SR_log;
       //      status = §§§MTX;
       //      exsr      SR_log;
         endmon;

       //MONITOR;
       //Wrk.var1 =
       //  'DLYJOB DLY(3)';
       //  cmd = %TrimR(Wrk.Var1);
       //  L      = %Len(Cmd);
       //  QCMDEXC(cmd: %len(cmd));
       //on-error;
       //   status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
       //   exsr      SR_log;
       //endmon;


       //Übertragung aus IVEAS Verzeichnis (stream)
         eval §DELIVER_N =  '/IVEAS/' +
                            p_KRECHLIEF +
                            '.TXT';

       MONITOR;
       Wrk.var1 =
         'CPYFRMSTMF FROMSTMF('''+ §DELIVER_N +''') ' +
         'TOMBR(''/QSYS.LIB/QTEMP.LIB/IVEAS_I.FILE/IVEAS_I.MBR'')' +
         ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
          exsr      SR_log;
       endmon;

       //übertrag per sql
         §records=*zero;
       exec sql
         select count(*) into :§records
                from  qtemp/IVEAS_I;
          if §records =  *zero;
             p_cc       = '1';
          endif;

          if §records <> *zero and
            p_cc       = '1';
       //sql Strukturen, satzarten lösen
            exec sql
               insert into qtemp/IVEAS_I1
               SELECT SUBSTR( SRCDTA , 1, 1810) FROM qtemp/IVEAS_I WHERE
               SUBSTR( SRCDTA , 1, 1) = '1';
            exec sql
               insert into qtemp/IVEAS_I2
               SELECT SUBSTR( SRCDTA , 1, 0497) FROM qtemp/IVEAS_I WHERE
               SUBSTR( SRCDTA , 1, 1) = '2';
            exec sql
               insert into qtemp/IVEAS_I3
               SELECT SUBSTR( SRCDTA , 1, 1503) FROM qtemp/IVEAS_I WHERE
               SUBSTR( SRCDTA , 1, 1) = '3';
            exec sql
               insert into qtemp/IVEAS_I4
               SELECT SUBSTR( SRCDTA , 1, 0513) FROM qtemp/IVEAS_I WHERE
               SUBSTR( SRCDTA , 1, 1) = '4';

            MONITOR;
            Wrk.var1 =
              'CPYF FROMFILE(qtemp/IVEAS_I1) TOFILE(qtemp/IVEAS_SA1) ' +
              'MBROPT(*REPLACE) FMTOPT(*NOCHK)';
              cmd = %TrimR(Wrk.Var1);
              L      = %Len(Cmd);
              QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command appeared: CPYF FROMFILE(IVEAS_I1) ';
               exsr      SR_log;
               p_cc       = 'E';
            endmon;
            MONITOR;
            Wrk.var1 =
              'CPYF FROMFILE(qtemp/IVEAS_I2) TOFILE(qtemp/IVEAS_SA2) ' +
              'MBROPT(*REPLACE) FMTOPT(*NOCHK)';
              cmd = %TrimR(Wrk.Var1);
              L      = %Len(Cmd);
              QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command appeared: CPYF FROMFILE(IVEAS_I2) ';
               exsr      SR_log;
       //      p_cc       = 'E';
            endmon;
            MONITOR;
            Wrk.var1 =
              'CPYF FROMFILE(qtemp/IVEAS_I3) TOFILE(qtemp/IVEAS_SA3) ' +
              'MBROPT(*REPLACE) FMTOPT(*NOCHK)';
              cmd = %TrimR(Wrk.Var1);
              L      = %Len(Cmd);
              QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command appeared: CPYF FROMFILE(IVEAS_I3) ';
               exsr      SR_log;
               p_cc       = 'E';
            endmon;
            MONITOR;
            Wrk.var1 =
              'CPYF FROMFILE(qtemp/IVEAS_I4) TOFILE(qtemp/IVEAS_SA4) ' +
              'MBROPT(*REPLACE) FMTOPT(*NOCHK)';
              cmd = %TrimR(Wrk.Var1);
              L      = %Len(Cmd);
              QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error in command appeared: CPYF FROMFILE(IVEAS_I4) ';
       //      exsr      SR_log;
            endmon;

          endif;

          if §records <> *zero and
            p_cc       = '1';
       //schlüssel ermitteln aus sa1  =>  10, 50
            exec sql
            select MANDT, RENR into :Key1, :Key2
                   from  qtemp/IVEAS_sa1;
       //  schlüssel evtl. als Rechnung, Achtung Sammelrechnungen produzieren mehrere Lieferscheine
       //  ALAFJJ austauschen ALLIJJ
            if p_KRL = 'L';
               key3 = ' ';
               exec sql
                  SELECT char(ALLIJJ concat ALLINR, 50)
                  into  :Key3 FROM aflp01
                  WHERE ALRGNR = substr(:Key2, 5, 6)        and
                        char(ALRGJJ) = substr(:Key2, 1, 4)  and
                        ALFIRM = substr(:Key1, 2, 2)        and
                        ALLINR = :p_KRECHLIEF               and
                        char(ALLIJJ) = :p_KJAHR             and
                        ALFIRM = substr(:p_MANDANT, 2, 2);
                  if    key3 <> *blank;
                     status='Ermittlung über Rechnungsdaten:'  +
                                               %subst(key1: 1: 3) + ' '  +
                                               %subst(key2: 1: 10) + ' ' +
                                               'Key3:'                   +
                                               %subst(key3: 1: 10) ;
                     exsr      SR_log;
                     key2 = key3;
                  else;
       //  08.01.2021 nicht auf error setzten, Rechnung fehlt noch,
       //             zu diesem Prozessbeginn eigentlich standard
       //            p_cc       = 'E';
       //  08.01.2021.......
                     status='Fehler bei Ermittlung über Rechnungsdaten:' +
                                               %subst(key1: 1: 3) + ' '  +
                                               %subst(key2: 1: 10);
                     exsr      SR_log;
                  endif;
            endif;
       //  .................
            if key1 <> '001'                       or
               %subst(key2: 1: 4) = ' '            or
               %subst(key2: 5: 6) = ' '            or
               %subst(key2: 1: 4) <>  p_KJAHR      or
               %subst(key2: 5: 6) <>  p_KRECHLIEF;
               p_cc       = 'E';
               status='Fehler im Schlüssel: ' +  %subst(key1: 1: 3) + ' '  +
                                                 %subst(key2: 1: 10) + ' ' +
                                                'p_KJAHR :' + p_KJAHR + ' ' +
                                                'p_KRECHLIEF:' + p_KRECHLIEF;
               exsr      SR_log;
            else;
       //  schlüssel mandant
               exec sql
               update qtemp/IVEAS_sa1
               set MANDANT= ( substr(:KEY1, 1, 3));
               exec sql
               update qtemp/IVEAS_sa2
               set MANDANT= ( substr(:KEY1, 1, 3));
               exec sql
               update qtemp/IVEAS_sa3
               set MANDANT= ( substr(:KEY1, 1, 3));
               exec sql
               update qtemp/IVEAS_sa4
               set MANDANT= ( substr(:KEY1, 1, 3));
       //  schlüssel jahr
               exec sql
               update qtemp/IVEAS_sa1
               set Kjahr = dec( substr(:key2, 1, 4));
               exec sql
               update qtemp/IVEAS_sa2
               set Kjahr = dec( substr(:key2, 1, 4));
               exec sql
               update qtemp/IVEAS_sa3
               set Kjahr = dec( substr(:key2, 1, 4));
               exec sql
               update qtemp/IVEAS_sa4
               set Kjahr = dec( substr(:key2, 1, 4));
       //  Rechnung oder Lieferschein
               exec sql
               update qtemp/IVEAS_sa1
               set KRL     = :p_KRL;
               exec sql
               update qtemp/IVEAS_sa2
               set KRL     = :p_KRL;
               exec sql
               update qtemp/IVEAS_sa3
               set KRL     = :p_KRL;
               exec sql
               update qtemp/IVEAS_sa4
               set KRL     = :p_KRL;
       //  schlüssel Rechnungsnummer/Lieferscheinnummer
               exec sql
               update qtemp/IVEAS_sa1
               set KRECHLIEF = ( substr(:key2, 5, 6));
               exec sql
               update qtemp/IVEAS_sa2
               set KRECHLIEF = ( substr(:key2, 5, 6));
               exec sql
               update qtemp/IVEAS_sa3
               set KRECHLIEF = ( substr(:key2, 5, 6));
               exec sql
               update qtemp/IVEAS_sa4
               set KRECHLIEF = ( substr(:key2, 5, 6));
       //  Verarbeitungskennzeichen
               exec sql
               update qtemp/IVEAS_sa1
               set VERABKZ = '0';
               exec sql
               update qtemp/IVEAS_sa2
               set VERABKZ = '0';
               exec sql
               update qtemp/IVEAS_sa3
               set VERABKZ = '0';
               exec sql
               update qtemp/IVEAS_sa4
               set VERABKZ = '0';
             endif;
          endif;



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
       //CRTDUPOBJ Dateien erstellen **********************************
       //-----------------------------------------------------------------------

       begsr sr_crtdupo;

       //CRTDUPOBJ
       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_I) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_I) ';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_I1) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_I1)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_I2) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_I2)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_I3) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_I3)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_I4) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_I4)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_SA1) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_SA1)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_SA2) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_SA2)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_SA3) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_SA3)';
       // exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
         'CRTDUPOBJ OBJ(IVEAS_SA4) FROMLIB(TVRELWAECO) ' +
         'OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CRTDUPOBJ OBJ(IVEAS_SA4)';
       // exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //temporäre Dateien bereinigen **********************************
       //-----------------------------------------------------------------------

       begsr sr_clrpfm;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_I)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_I                       ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_I1)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_I1                      ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_I2)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_I2                      ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_I3)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_I3                      ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_I4)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_I4                      ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_SA1)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_SA1                     ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_SA2)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_SA2                     ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_SA3)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_SA3                     ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;


         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(QTEMP/IVEAS_SA4)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM QTEMP/IVEAS_SA4                     ';
       //      exsr      SR_log;
               status = §§§MTX;
       //      exsr      SR_log;
         endmon;

       endsr;

       //-----------------------------------------------------------------------
       //output
       // CRTPF FILE(TVRELWAECO/SCHLANSERO) RCDLEN(80) TEXT('output SCHLANSER  ')
       //
       //-----------------------------------------------------------------------

       begsr file_out;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  '......SER' +'-'                        +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'IVEAS_SA1';

         clear p_md;

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  qtemp/IVEAS_SA1;

       if §records <> *zero;
       else;
          status='Übertragungsdatei leer ' + p_outfil;
       //08.01.2021......
          p_cc       = 'E';
       //08.01.2021......
          exsr      SR_log;
       endif;



       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  p_KRECHLIEF +'_' + 'SA1' + ' ' +
                        %char(%dec(%char(%date():*iso0):8:0)) + ' ' +
                        p_KJAHR + p_KRECHLIEF + ' ' +
                        %char(%dec(%char(%time():*iso0):8:0));
         if  p_cc       = 'E';
             eval p_infil   = p_KRECHLIEF +'_' + 'Fehler' + ' ' + 'SA1' + ' ' +
                           %char(%dec(%char(%date():*iso0):8:0)) + ' ' +
                        p_KJAHR + p_KRECHLIEF + ' ' +
                           %char(%dec(%char(%time():*iso0):8:0));
         endif;

         eval p_outfil  =  'IVEAS_SA1';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       //MONITOR;
       //Wrk.var1 =
       //    'RMVLNK OBJLNK(''/IVEAS/RHENANIAout*'')';
       //  cmd = %TrimR(Wrk.Var1);
       //  l      = %Len(Cmd);
       //  QCMDEXC(cmd: %len(cmd));
       //   status='rmvlnk successful removed SCHLANSERout           ';
       //   exsr      SR_log;
       //on-error;
       //   status='Error by rmvlnk object SCHLANSERout              ';
       //   exsr      SR_log;
       //endmon;

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/IVEAS/RHENANIA/'+ p_infil +''  +
                      '.txt'') ' +
           'DBFILE(QTEMP/'+ p_outfil +') DBOUTFMT(*TXT) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for IVEAS                 ';
       // exsr      SR_log;
       on-error;
          status='Error by CVTDBF object for IVEAS                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'SCHLANSER';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/IVEAS/RHENANIA/'+ p_infil +''  +
                      '.txt'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(IVEAS)                    ';
       on-error;
          status='Error by chgaut object (IVEAS)                   ';
       endmon;


         eval p_outfil  =  'IVEAS_SA3';

         clear p_md;

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  qtemp/IVEAS_SA3;

       if §records <> *zero;
       else;
          status='Übertragungsdatei leer ' + p_outfil;
       //08.01.2021......
          exsr      SR_log;
       //08.01.2021......
       endif;


       //Ausgabe der einzelnen Files über variable
         eval p_infil   = p_KRECHLIEF +'_' + 'SA3' + ' ' +
                        %char(%dec(%char(%date():*iso0):8:0)) + ' ' +
                        p_KJAHR + p_KRECHLIEF + ' ' +
                        %char(%dec(%char(%time():*iso0):8:0));
         if  p_cc       = 'E';
             eval p_infil   = p_KRECHLIEF +'_' + 'Fehler' + ' ' + 'SA3' + ' ' +
                           %char(%dec(%char(%date():*iso0):8:0)) + ' ' +
                        p_KJAHR + p_KRECHLIEF + ' ' +
                           %char(%dec(%char(%time():*iso0):8:0));
         endif;
         eval p_outfil  =  'IVEAS_SA3';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       //MONITOR;
       //Wrk.var1 =
       //    'RMVLNK OBJLNK(''/IVEAS/RHENANIAout*'')';
       //  cmd = %TrimR(Wrk.Var1);
       //  l      = %Len(Cmd);
       //  QCMDEXC(cmd: %len(cmd));
       //   status='rmvlnk successful removed SCHLANSERout           ';
       //   exsr      SR_log;
       //on-error;
       //   status='Error by rmvlnk object SCHLANSERout              ';
       //   exsr      SR_log;
       //endmon;

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/IVEAS/RHENANIA/'+ p_infil +''  +
                      '.txt'') ' +
           'DBFILE(QTEMP/'+ p_outfil +') DBOUTFMT(*TXT) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for IVEAS                 ';
       // exsr      SR_log;
       on-error;
          status='Error by CVTDBF object for IVEAS                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'SCHLANSER';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/IVEAS/RHENANIA/'+ p_infil +''  +
                      '.txt'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(IVEAS)                    ';
       on-error;
          status='Error by chgaut object (IVEAS)                   ';
       endmon;


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


