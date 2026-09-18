
      //************************************************************************
      //
      //      Programmname       galaxusr
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang            s
      //
      //      Beschreibung       Meldung an galaxus Bestände
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      // CPYFRMIMPF FROMFILE(TVRELWAECO/GALAXUSIN) TOFILE(TVRELWAECO/FROM_EXCE3)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:       ftp.galaxus.ch
      // Restartmöglichkeiten:       User: dometic
      // _____________________       PW: 4t5QaveFrU
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      //
      // CRTSRCPF FILE(GALAXUSIN) RCDLEN(240) TEXT('importing items and prices')
      //
      //
      //
      // CPYFRMSTMF FROMSTMF('/GALAXUS/Mappe1.csv') TOMBR('/QSYS.LIB/TVRELWAECO.LIB
      // /GalaxusiN.FILE/GalaxusIN.MBR') MBROPT(*REPLACE)
      //
      // CPYFRMSTMF FROMSTMF('/GALAXUS/Galaxusin.csv')
      //        TOMBR('/QSYS.LIB/TVRELWAECO.LIB/GalaxusiN.FILE/GalaxusIN.MBR')
      //                 MBROPT(*REPLACE)
      //
      //  SELECT a.TETENR, B.TETBZ1 ,BESTAND,
      //        case when bestand <> 0
      //        then char( current date +3 days)
      //        else '00.00.00'          end
      //        from  abestand a ,teil01 b
      //  WHERE a.tetenr = b.tetenr and tefirm='55'
      //       and a.tetenr in
      //       (substr(SRCDTA, 5, 10) FROM galaxusin)
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
     D p_inFIL         s             24a
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


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for DSXSQL01R    ';
       exsr      SR_log;

       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
          exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          eval  suffix   = 'CH412 ';
       // exsr  file_out;
          exsr  SR_output;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

       eval status ='Ende  FTP Transfer for DSXSQL01R    ';
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
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/DSXSQL01) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/DSXSQL01)           ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;


          exec sql
            insert into tvrelwaeco/DSXSQL01
            SELECT RTRIM(TEIL_1.TEFIRM) AS Firma, RTRIM(TEIL_1.TETENR) AS
            Artnr, RTRIM(TEIL_1.TETBZ1) AS Bez1, RTRIM(TEIL_1.TETBZ2) AS
            Bez2, RTRIM(TEIL_1.TETEST) AS Status, TEIL_1.TESIBE AS SiBe,
            RTRIM(TEIL_1.TESTLF) AS Liefeant, RTRIM(LIEF_1.LFNAM1) AS Name,
            RTRIM(TEIL_1.TEDIEK) AS SBEK, RTRIM(#USER_1.TPTTXT) AS Name,
            RTRIM(TEIL_1.TESAEK) AS TESAEK, RTRIM(#USER_2.TPTTXT) AS Name,
            RTRIM(TEIL_1.TEMEIN) AS ME, LIEF_1.LFVSTA AS Vorlaufzeit,
            TEIL_1.TELVZ1 AS Lieferzeit, LFVSTA + TELVZ1 AS Summe,
            RTRIM(TEIL_1.TEPRGR) AS PRGR, RTRIM(#PRODG_1.TPTTXT) AS Text,
            RTRIM(TEEW_1.TEEWPRGR) AS DOMPRGR, RTRIM(#PRODGDOM_1.TPTTXT) AS
            Text FROM TVPF/TEIL AS TEIL_1 JOIN TVRELWAECO/##FIRMA AS
            ##FIRMA_1 ON (TEIL_1.TEFIRM=##FIRMA_1.FIRMA) LEFT JOIN TVPF/LIEF AS
            LIEF_1 ON (TEIL_1.TEFIRM=LIEF_1.LFFIRM AND
            TEIL_1.TESTLF=LIEF_1.LFLFNR) LEFT JOIN TVRELWAECO/#USER AS #USER_1
            ON (TEIL_1.TEDIEK=#USER_1.TPTCDE AND 0=#USER_1.TPTFLG AND
            'D'=#USER_1.TPSPCD AND TEIL_1.TEFIRM=#USER_1.TPFIRM) LEFT JOIN
            TVRELWAECO/#USER AS #USER_2 ON (TEIL_1.TESAEK=#USER_2.TPTCDE AND
            0=#USER_2.TPTFLG AND 'D'=#USER_2.TPSPCD AND
            TEIL_1.TEFIRM=#USER_2.TPFIRM) LEFT JOIN MODWAO/TEEW AS TEEW_1 ON
            (TEIL_1.TEFIRM=TEEW_1.TEEWFIRM AND TEIL_1.TETENR=TEEW_1.TEEWTENR)
            LEFT JOIN TVRELWAECO/#PRODGDOM AS #PRODGDOM_1 ON
            (TEEW_1.TEEWFIRM=#PRODGDOM_1.TPFIRM AND
            TEEW_1.TEEWPRGR=#PRODGDOM_1.TPTCDE AND 'D'=#PRODGDOM_1.TPSPCD) LEFT
            JOIN TVRELWAECO/#PRODG AS #PRODG_1 ON
            (TEIL_1.TEFIRM=#PRODG_1.TPFIRM AND TEIL_1.TEPRGR=#PRODG_1.TPTCDE
            AND 'D'=#PRODG_1.TPSPCD) WHERE (##FIRMA_1.LOKATION='EDC');

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
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'DSX additional Information';
       //               %char(%dec(%char(%date():*iso0):8:0)) +
       //               %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'DSXSQL01  ';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/DSX additional*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed DSX additional*        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object DSX additional*           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'DSXSQL01  ';

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
          status='Error by CVTDBF object DSX additional            ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'DSX additional';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(DSX additional Inform)    ';
       on-error;
          status='Error by chgaut object (DSX additional Inform)   ';
       endmon;

       //...
       //'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT10) '  +
           'FORMTYPE(''none'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'none';

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
       //output
       // CRTPF FILE(TVRELWAECO/GALAXUSR_O) RCDLEN(80) TEXT('output galaxus')
       //
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

         eval  transfer =  'DSX additional Information'           +
       //                   %char(%dec(%char(%date():*iso0):8:0)) +
       //                   %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'DSXSQL01';

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
                'TOFILE(TVRELWAECO/GALAXUSR_O) '+
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

         eval p_outfil  =  'GALAXUSR';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  GALAXUSR ;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(GALAXUSC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'GALAXUSR';

            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(GALAXUSL)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO/FTP)';
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


            eval p_outfil  =  'GALAXUSR';

       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'RPMS'    +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'GALAXUSR_O ' +
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
                   'FTP RMTSYS(''FTP.GALAXUS.CH'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;

            if err_msg = '1';
               status='error FTP.GALAXUS.CH  '    +
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
               eval p_outfil  =  'GALAXUSR';

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
                   'CHGOBJD OBJ(TVRELWAECO/GALAXUSR_O)' +
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


