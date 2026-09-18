
      //************************************************************************
      //
      //      Programmname       galaxusr
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Übernahme Produktaerecodes (permanent update)
      //
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
      // TEEWTENR ='9105302940'
      //
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
     fSCMUPDLFO1uf   e             DISK    RENAME(SCMUPDLFo:PHY01R)
     f                                     USROPN
     f
     flief01    uf   e           k DISK    RENAME(lief1:LOG02R)
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
     d SCMUPDLFO1_i  E DS                  ExtName(SCMUPDLFO1:*input)
     d                                     Qualified

     d SCMUPDLFO1_o  E DS                  ExtName(SCMUPDLFO1:*output)
     d                                     Qualified

     d lief01_i      E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d lief01_o      E DS                  ExtName(lief01:*output)
     d                                     Qualified

     d lief01_k      E DS                  ExtName(lief01:*key)
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
     d WE_CHECK        PR                  ExtPgm('WE_CHECK')
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
     D §waeco          s              3a   inz
     D §dometic        s              3a   inz
     D §AERACODE       s              6a   inz
     D error1          s              1a   inz
     D run             s              1a   inz
     D p_inFIL         s             24a   inz


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start Übergabe Stammdaten für SCM_SUPPL  ';
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
                'CLRPFM FILE(TVRELWAECO/SCMUPDi)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/SCMUPDi)         ';
               exsr      SR_log;
         endmon;

       //copy files from last input ...
       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/Lager/SCM/' +
           'SCM Upload file TREND Shipping dates.csv'') ' +
           'TOMBR(''/QSYS.LIB/TVRELWAECO.LIB/SCMUPDi.FILE/SCMUPDi.MBR'') '+
           ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF SCM_SUPPL ';
          exsr      SR_log;
          error1 ='1';
       endmon;


       //copy files from last input aerecodes
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/SCMUPDi) ' +
           'TOFILE(TVRELWAECO/SCMUPDLFo) MBROPT(*Add) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF SCM_SUPPL   ';
       // exsr      SR_log;
          error1 ='0';
       endmon;

       §records = 0;
       exec sql
          select count(*) into :§records
          from tvrelwaeco/SCMUPDLFO1;

       if error1='0' and §records > 0;

          MONITOR;
          Wrk.var1 =
              'RMVLNK OBJLNK(''/LAGER/SCM/' +
              'SCM Upload file TREND Shipping dates done*'')';
            cmd = %TrimR(Wrk.Var1);
            l      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             status='rmvlnk successful removed file done history      ';
             exsr      SR_log;
          on-error;
             status='Error by rmvlnk object file done history         ';
             exsr      SR_log;
          endmon;


          open SCMUPDLFO1;
          open lief01;
          §upd             =  '0';
          read SCMUPDLFO1 SCMUPDLFO1_i;
          SCMUPDLFO1_o  = SCMUPDLFO1_i;
          SCMUPDLFO1_o.state   = '0';
       //LIEF01 initialisiert mit Mandant
          dow not %eof(SCMUPDLFO1);
             LIEF01_k.LFFIRM = SCMUPDLFO1_i.LFFIRM;
             LIEF01_k.LFLFNR = SCMUPDLFO1_i.LFLFNR;
             chain %kds(LIEF01_k:2) LIEF01    LIEF01_I;
             if %found(LIEF01);
                LIEF01_o  = LIEF01_i;
                if
                   (LIEF01_i.LFVSTA  <> SCMUPDLFO1_i.LFVSTA and
                    SCMUPDLFO1_i.LFVSTA <> *Zero )   or
                   (LIEF01_i.LFSBAD  <> SCMUPDLFO1_i.LFSBAD and
                    SCMUPDLFO1_i.LFSBAD <> *Blank)   or
                   (LIEF01_i.LFSBOP  <> SCMUPDLFO1_i.LFSBOP and
                    SCMUPDLFO1_i.LFSBOP <> *Blank);

                    if (LIEF01_i.LFVSTA  <> SCMUPDLFO1_i.LFVSTA and
                       SCMUPDLFO1_i.LFVSTA <> *Zero );
                          SCMUPDLFO1_o.LFVSTA_ = LIEF01_i.LFVSTA;
                          lief01_o.LFVSTA  = SCMUPDLFO1_i.LFVSTA;
                    endif;
                    if (LIEF01_i.LFSBAD  <> SCMUPDLFO1_i.LFSBAD and
                       SCMUPDLFO1_i.LFSBAD <> *Zero );
                          SCMUPDLFO1_o.LFSBAD_ = LIEF01_i.LFSBAD;
                          lief01_o.LFSBAD  = SCMUPDLFO1_i.LFSBAD;
                    endif;
                    if (LIEF01_i.LFSBOP  <> SCMUPDLFO1_i.LFSBOP and
                       SCMUPDLFO1_i.LFSBOP <> *Zero );
                          SCMUPDLFO1_o.LFSBOP_ = LIEF01_i.LFSBOP;
                          lief01_o.LFSBOP  = SCMUPDLFO1_i.LFSBOP;
                    endif;

                    lief01_o.lfuser = §§§usr;
                    lief01_o.lfPROG = §§§pgm;
                    lief01_o.lfjnam = §§§job;
                    lief01_o.lfbibl = §§§LIB;
                    lief01_o.lfJDAT = %dec(%char(%date():*iso0):8:0);
                    lief01_o.lfJZEI = %dec(%char(%time():*iso0):6:0);
                    SCMUPDLFO1_o.state   = '1';
                    update LOG02R    lief01_o;
                    status='change   ' + lief01_k.LFLFNR;
                    exsr      SR_log;
                endif;
             endif;
             update phy01r   SCMUPDLFO1_o;
             read SCMUPDLFO1 SCMUPDLFO1_i;
             SCMUPDLFO1_o  = SCMUPDLFO1_i;
             SCMUPDLFO1_o.state   = '0';
             §upd             =  '0';
          enddo;
          unlock    lief01;
          close SCMUPDLFO1;
          close lief01;
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
          status='CD DIR successful FILE(TVRELWAECO/SCM_SUPPL )    ';
       on-error;
          status='Error by CD DIR object (TVRELWAECO/SCM_SUPPL )   ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'RNM OBJ(''SCM Upload file TREND Shipping dates.csv'') '+
           'NEWOBJ(''SCM Upload file TREND Shipping dates done.csv'')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rnm    successful FILE(TVRELWAECO/SCM_SUPPL )    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/SCM_SUPPL )   ';
       endmon;


       //Protokoll
       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/SCM_SUPPL )';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/SCM_SUPPL )    ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/SCM_SUPPL )   ';
       endmon;

       //ermitteln über Tabelle
             exec sql
                insert into tvrelwaeco/SCM_SUPPL
                SELECT * FROM job_run
                WHERE PGM ='SCM_SUPPL' and cd = current date and
                            ct > current time - 30 minutes;
       exsr SR_report;

       //run = '1' endif
       endif;
       //NumSysTime > 000000 endif
       endif;

       eval status ='Ende  SCM_SUPPL                      ';
       exsr      SR_log;

       *inlr = *on;

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
       //report im Verzeichnis ablegen  ==> Job_run
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_report;

       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'PACodes' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'UMMFILE3';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/MMMMM/LFS_STEUERUNG/Prod/********'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed PACodes*               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object PACodes*                  ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'PACodes';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/LFS_STEUERUNG/Prod/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for PACodes               ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object PACodes                   ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'PACodes';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/LFS_STEUERUNG/Prod/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/PACodes)       ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/PACodes)      ';
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


