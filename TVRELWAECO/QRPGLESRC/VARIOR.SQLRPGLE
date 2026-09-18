
      //************************************************************************
      //
      //      Programmname       GALAXUSIR
      //      Erstellt  am       15.03.2024
      //      Erstellt von       D.Langlitz
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
      // CRTSRCPF FILE(TVRELWAECO/GALAXUSDIN) RCDLEN(240) TEXT('importing items and prices')
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
      //  WHERE a.tetenr = b.tetenr and tefirm='01'
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
     D p_inFIL         s             27a   inz

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
       eval status ='Start FTP Transfer for VARIOR    ';
       exsr      SR_log;


       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
          exsr  srinit;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          eval  suffix   = 'DE411 ';
          exsr  file_out;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

       eval status ='Ende  FTP Transfer for VARIOR       ';
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

       //VARIOin hier wird die .csv hineinkopiert, vorher clear
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/VARIOIN)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/VARIOIN)          ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //VARIOOUT Ausgabedatei als Ergebnis über sql angelegt
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/VARIOOUT)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/VARIOOUT)          ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //GALAXUSR_D Übergabedatei zum Kunden hin
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/VARIO_D) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/VARIO_D)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;
       endif;


       //>>> PC(Verzeichnis) file nach GalaxusDin
       //>>> CRTSRCPF FILE(TVRELWAECO/GALAXUSDIN) RCDLEN(320) TEXT('importing items and prices')
       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/VARIO/varioNEU.csv'') ' +
           'TOMBR' +
           '(''/QSYS.LIB/TVRELWAECO.LIB/VARIOIN.FILE/VARIOIN.MBR'') ' +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
          exsr      SR_log;
       endmon;

       //>>>      aus dem PC(Verzeichnis) erstellte Datei
       //>>>      weiter nach GALAXUSDMP, wo dann eine Struktur existiert
       //>>>      GALAXUSDMP über qddssrc angelegt
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/VARIOIN) ' +
           'TOFILE(TVRELWAECO/VARIODMP) MBROPT(*REPLACE) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;

       //>> eigentliche Ausgabedatei angereichert: galaxusDut
       //>> diese neue Datei erstelle ich einmalig über sql-ausgabe
       exec sql
        insert into VARIOOUT
        SELECT DOM, ITEM, NET, BRUTT, RAB, NETTEX, TOTAL,
               b.TETENR, B.TETBZ1, B.TETBZ2, char(b.teprgr, 25) TEPRGR,
               b.TEZOTN,char(b.TEURLD, 25) TEURLD,b.TEEANR,
               c.TZVLL, c.TZVLB , c.TZVLH, c.TZBRUT,c.TZNETT,
               char(' ', 15) altitem,char(' ', 25) group, BESTAND,
               case when bestand <> 0
               then char(char(current date +3 days), 8)
               else char('00.00.00', 8)          end,
               dec((NET+ NETTEX), 11, 2) wertneu
               from  abestand a ,teil01 b,DOMDATV7/pbfstss c,
                    VARIODMP
        WHERE (a.tetenr = b.tetenr and tefirm='01') and
              (a.tetenr = c.tziden and tzkonz = 'EMS' and
                                       tzfirm = 'DWI')
              and substr(a.tetenr, 1, 15) = item;



       //balance INVOICES for erp ERP Trend-System
       exec sql
         update VARIOOUT set teurld=substr(teurld, 1, 3)
         concat ' ' concat
         (select substr(LNLBEZ, 1, 21) from
         land WHERE substr(teurld, 1, 3) =LNLDNR)
         where exists
         (select substr(LNLBEZ, 1, 21) from
         land WHERE substr(teurld, 1, 3) =LNLDNR);


       //balance INVOICES for erp ERP Trend-System
       exec sql
        update VARIOOUT set TEPRGR=substr(TEPRGR, 1, 3)
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
        update VARIOOUT set group  =
        (select substr(TEEWPRGR, 1, 10) from TEEW
         WHERE TEEWFIRM ='01' and TEEWTENR=item)
        where exists
        (select substr(TEEWPRGR, 1, 10) from TEEW
         WHERE TEEWFIRM ='01' and TEEWTENR=item);


       //balance INVOICES for erp ERP Trend-System
       exec sql
        update VARIOOUT set group =substr(group, 1, 3)
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
         update VARIOOUT set altitem=
         (select TLALTE                from teal
         WHERE TLFIRM ='01' and Tlfirm =item)
         where exists
         (select TLALTE                from teal
         WHERE TLFIRM ='01' and Tlfirm =item);


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //output
       // CRTPF FILE(TVRELWAECO/GALAXUSR_O) RCDLEN(80) TEXT('output galaxus')
       //
       // CRTPF FILE(TVRELWAECO/GALAXUSR_D) RCDLEN(352) TEXT('output galaxus')
       //-----------------------------------------------------------------------

       begsr file_out;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'VARIOR' +'-'                        +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'VARIOOUT';


         clear p_md;

       //Aufbereitung für Export in Übertragungsdatei
       // CRTPF FILE(TVRELWAECO/GALAXUSI_D) RCDLEN(352) TEXT('output galaxus')
       //>> 1) GALAXUSDUT nach  GALAXUSR_D
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/VARIO_D) '+
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

         eval p_outfil  =  'VARIOOUT';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  VARIOOUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT
       //>> 2) Vorbereitung FTP Befehle in GALAXUSDC
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(VARIOC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'VARIOOUT';

            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
       //>> 3) Vorbereitung Logfile
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(VARIOL)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT2 TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

       //Info in Outfile timestamp
       //>> 4) Logfile-Eintrag
            clear p_md;
            eval p_msg     =  '#DC0010';
            eval p_msgf    =  *blank;
            eval p_print   =  *blank;
            eval p_outfil  =  'OUTPUT    ';
            eval p_lib     =  'TVRELWAECO';
            eval p_repadd  =  '*ADD';

            callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                           p_outfil: p_lib:    p_repadd);


            eval p_outfil  =  'VARIOOUT';

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'VARIO_D ' +
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
                   'FTP RMTSYS(''ftps.kundertvario.ch'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;

            if err_msg = '1';
               status='error ftps.kundertvario.ch '    +
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
               eval p_outfil  =  'VARIOOUT';

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
                   'CHGOBJD OBJ(TVRELWAECO/VARIO_D)' +
                   ' OBJTYPE(*FILE)'                          +
                   '+ §text +'+
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



       //>>> Verzeichnisse updaten <<<
       //Ausgabe der einzelnen Files über variable
         eval p_infil = 'VARIOOUT' + '_' +
                         %trim(%char(%dec(%char(%date():*iso0):8:0))) +
                         %trim(%char(%dec(%char(%time():*iso0):8:0))) +
                         '.csv';

         eval p_outfil  =  'VARIOOUT';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       //Aus Verzeichnis alte Datei löschen
       //Achtung die datei heisst GALAXUSout, die
       //als Ausgabe ausgewiesen wird!! ... und nicht GALAXUSdut
       //        eval p_infil   =  'GALAXUSout' + '_'  +
       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/VARIO/VARIOOUT*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed VARIOOUT             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object VARIOOUT                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'VARIOOUT';

       //in Verzeichnis neue Datei einstellen
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/VARIO/'+ p_infil + ''') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for VARIOOUT            ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object VARIOOUT                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'VARIOOUT';


       //im Verzeichnis für neue Datei Objektberechtigung anpassen
       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/VARIO/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/VARIOIN)    ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/VARIOIN)   ';
       endmon;




       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
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


       endsr;


