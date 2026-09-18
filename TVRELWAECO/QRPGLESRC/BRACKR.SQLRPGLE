
      //************************************************************************
      //
      //      Programmname       brackr
      //      Erstellt  am       19.01.2022
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an BRACK Bestände
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
      // Übersetzungshinweise:       sftp://files.competec.ch/pricelistimport
      // Restartmöglichkeiten:       User: A5363
      // _____________________       PW: kK#3dz6glIQcEiJL
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      //
      // CRTSRCPF FILE(BrackIN) RCDLEN(240) TEXT('importing items and prices')
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
     D p_inFIL         s             24a   inz

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


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for BRACKR       ';
       exsr      SR_log;


       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 090000;
       // and NumSysTime < 090000;
          exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          eval  suffix   = 'CH412 ';
          exsr  file_out;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

       eval status ='Ende  FTP Transfer for BRACKR       ';
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
       endif;

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(VLF95SFTP) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDLIBLE LIB(VLF95SFTP) POSITION(*LAST)    ';
             exsr      SR_log;
       endmon;



         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/Brackin)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/Brackin)            ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/BrackIMP)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/Brackimp)           ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/brackout)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/Brackout)          ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/brack_p)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/Brack_p)           ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //CRTSRCPF FILE(BrackIN) RCDLEN(240) TEXT('importing items and prices')
       ///Brack/Brackin.csv  =>> TVRELWAECO/BrackIN          !!!!!!!!!!!
       //qddssrc//BrackIMP
       ///TVRELWAECO/BrackIN =>> TVRELWAECO/BrackIMP         !!!!!!!!!!!
       //tvrelwaeco/BrackIMP sql
       ////TVRELWAECO/BrackOUT  sqlfunktion                  !!!!!!!!!!!
       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/BRACK/Brackin.csv'') ' +
           'TOMBR(''/QSYS.LIB/TVRELWAECO.LIB/BrackiN.FILE/BrackIN.MBR'') ' +
           ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/BrackIN) ' +
           'TOFILE(TVRELWAECO/BrackIMP) MBROPT(*REPLACE) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;

       //balance INVOICES for erp ERP Trend-System
       exec sql
        insert into brackout
        SELECT DOM, ITEM, NET, BRUTT, RAB, NETTEX, TOTAL,
               b.TETENR, B.TETBZ1, B.TETBZ2, char(b.teprgr, 25) TEPRGR ,
               b.TEZOTN,char(b.TEURLD, 25) TEURLD,b.TEEANR,
               c.TZVLL, c.TZVLB , c.TZVLH, c.TZBRUT,c.TZNETT,
               char(' ', 15) altitem,char(' ', 25) group, BESTAND,
               case when bestand <> 0
               then char(char( current date +3 days), 8)
               else char('00.00.00', 8)          end,
               dec((NET+ NETTEX), 11, 2) wertneu
               from  abestand a ,teil01 b,DOMDATV7/pbfstss c,
                    brackimp
        WHERE (a.tetenr = b.tetenr and tefirm='01') and
              (a.tetenr = c.tziden and tzkonz = 'EMS' and
                                       tzfirm = 'DWI')
              and substr(a.tetenr, 1, 15) = item;



       //balance INVOICES for erp ERP Trend-System
       exec sql
         update brackout set teurld=substr(teurld, 1, 3)
         concat ' ' concat
         (select substr(LNLBEZ, 1, 21) from
         land WHERE substr(teurld, 1, 3) =LNLDNR)
         where exists
         (select substr(LNLBEZ, 1, 21) from
         land WHERE substr(teurld, 1, 3) =LNLDNR);


       //balance INVOICES for erp ERP Trend-System
       exec sql
        update brackout set TEPRGR=substr(TEPRGR, 1, 3)
        concat ' ' concat
        (select substr(TPTTXT, 1, 21) from
        trtp WHERE TPFIRM ='01' and TPTART ='PRGR' and TPTFLG=0
        and  TPTCDE = substr(TEPRGR, 1, 3))
        where exists
        (select substr(TPTTXT, 1, 21) from
        trtp WHERE TPFIRM ='01' and TPTART ='PRGR' and TPTFLG=0
        and  TPTCDE = substr(TEPRGR, 1, 3));


       //balance INVOICES for erp ERP Trend-System
       exec sql
        update brackout set group  =
        (select substr(TEEWPRGR, 1, 10) from TEEW
         WHERE TEEWFIRM ='01' and TEEWTENR=item)
        where exists
        (select substr(TEEWPRGR, 1, 10) from TEEW
         WHERE TEEWFIRM ='01' and TEEWTENR=item);


       //balance INVOICES for erp ERP Trend-System
       exec sql
        update brackout set group =substr(group, 1, 3)
        concat ' ' concat
        (select substr(TPTTXT, 1, 21) from
        trtp WHERE TPFIRM ='01' and TPTART ='$$TEEWPRGR'
        and  TPTCDE = substr(group, 1, 3))
        where exists
        (select substr(TPTTXT, 1, 21) from
        trtp WHERE TPFIRM ='01' and TPTART ='$$TEEWPRGR'
        and  TPTCDE = substr(group, 1, 3));


       //wechsel der Item nummer von alt auf neu
       exec sql
         update brackout set altitem=
         (select TLALTE                from teal
         WHERE TLFIRM ='55' and Tlfirm =item)
         where exists
         (select TLALTE                from teal
         WHERE TLFIRM ='55' and Tlfirm =item);


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //Ausgabe für den Kunden Protokolldaten für seinen Import
       // CRTPF FILE(TVRELWAECO/Brack_P)    RCDLEN(300) TEXT('output Brack  ')
       //-----------------------------------------------------------------------

       begsr file_out;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'BRACK' +'-'                           +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

       //eval  transfer =  *blank;     wieder wie vorher
       //eval  transfer =  'BRACK' +
       //                   '.csv';

         eval p_outfil  =  'BRACKOUT';

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
                'TOFILE(TVRELWAECO/BRACK_P) '+
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

         eval p_outfil  =  'BRACKOUT';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  BRACKOUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT BRACKC
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(BRACKC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'BRACKOUT';

            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(BRACKL)';
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


            eval p_outfil  =  'BRACKOUT';

       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'RPMS'    +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'BRACK_P ' +
                                 transfer;
       //   clear  string_file;                 wieder wie vorher
       //   eval   string_file = 'APPEND ' +
       //                        'BRACK_P ';

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //FTP-Befehl     'FTP RMTSYS(''FTP.GALAXUS.CH'')';
       //          'FTP RMTSYS(''sftp://files.competec.ch/pricelistimport'')';
            MONITOR;
               Wrk.var1 =
                   'FTP RMTSYS(''files.competec.ch'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;


       //   MONITOR;
       //      Wrk.var1 =
       //          'CALL PGM(IFDW49) PARM(''VLF95SFTP '' ''BRACK     '')';
       //      cmd = %TrimR(Wrk.Var1);
       //      L      = %Len(Cmd);
       //      QCMDEXC(cmd: %len(cmd));
       //      on-error;
       //         status='error by SFTP                                    ';
       //         err_msg = '1';
       //         exsr      SR_log;
       //   endmon;






            if err_msg = '1';
               status='error sftp://files.competec.ch/pricelistimport '    +
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
               eval p_outfil  =  'BRACKOUT';

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
                   'CHGOBJD OBJ(TVRELWAECO/BRACK_P)' +
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

       //... output



       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'BRACKout' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
       //eval p_infil   =  *blank;            wieder wie vorheer
       //eval p_infil   =  'BRACKout';
         eval p_outfil  =  'BRACKOUT';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/BRACK/BRACKout*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed BRACKout               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object BRACKout                  ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'BRACKOUT';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/BRACK/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for BRACKout              ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object BRACKout                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'BRACKOUT';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/BRACK/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/BRACK)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/BRACK)    ';
       endmon;



       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'BRACK     ';
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


