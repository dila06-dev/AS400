
      //************************************************************************
      //
      //      Programmname       sievoIIR
      //      Erstellt  am       25.08.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an SDievo  purchasing report
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //  07102024    Gang                 !
      //41, 42, 43 integriert
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
      //
      //               MONITOR
      // B             DIV       A
      // Arr(B)        Dsply
      //               ON-ERROR  0102
      // 'Div by 0'    Dsply
      //               ON-ERROR  0121
      // 'Index Err'   Dsply
      //               ON-ERROR
      //*'Error'       Dsply
      //               ENDMON
      // Restartmöglichkeiten:
      // _____________________
      // beteiligte Dateien:
       //part 1
      // sievDSPM  workdatei, wird immer neu aufgebaut, alle bereits
      //                      prozessierten Sätze auf statusebene werden
      //                      gelöscht
      //
      // sievDSPMP Protokoll  beinhaltet all prozessierten Sätze auf statusebene
      // Beispiel für restart von stapel
      // delete                       sievDSPMP
      // where  TSTAMP ='2016-12-19-15.07.47.543000'
      //
      //
      // SIEVDSPMS beinhaltet alle prozessierten Originalsätze als Sicherung
      // DSPMpBE111 beinhalten letzte Übergabe, siehe Textbeschreibung für BE
      // DSPMpNL411 beinhalten letzte Übergabe, siehe Textbeschreibung für NL
      // DSPMpCH412 beinhalten letzte Übergabe, siehe Textbeschreibung für CH
      // DSPMpDE411 beinhalten letzte Übergabe, siehe Textbeschreibung für BE
      // DSPMpAT411 beinhalten letzte Übergabe, siehe Textbeschreibung für AT
      //
       //part 2
      // sievDSPMw workdatei, wird immer neu aufgebaut, alle bereits
      //                      prozessierten Sätze auf statusebene werden
      //                      gelöscht
      //
      // sievDSPMwp Protokoll beinhaltet all prozessierten Sätze auf statusebene
      // Beispiel für restart von stapel
      // delete                       sievDSPMwp
      // where  TSTAMP ='2016-12-19-15.17.40.817000'
      //
      //
      // SIEVDSPMwS beinhaltet alle prozessierten Originalsätze als Sicherung
      // DSPMgBE111 beinhalten letzte Übergabe, siehe Textbeschreibung für BE
      // DSPMgNL411 beinhalten letzte Übergabe, siehe Textbeschreibung für NL
      // DSPMgCH412 beinhalten letzte Übergabe, siehe Textbeschreibung für CH
      // DSPMgDE411 beinhalten letzte Übergabe, siehe Textbeschreibung für BE
      // DSPMgAT411 beinhalten letzte Übergabe, siehe Textbeschreibung für AT
      //
      // CALL  PGM(DUMMY512) PARM(' ' '#DC6721' ' ' ' '
      //          ' '  ' ' '  ')
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

     fsievDSPM  uf   e             DISK    usropn
     f                                     RENAME(sievdspmr:PHY01R)

     fsievDSPMw uf   e             DISK    usropn
     f                                     RENAME(sievdspmwr:PHY02R)

     fbbek01    if   e           k DISK

     fafrk01    if   e           k DISK

     fafrp01    if   e           k DISK

     fafko01    if   e           k DISK

     f#aflpL1   if   e           k DISK

     fkund01    if   e           k DISK

     flief01    if   e           k DISK

     fkueg01    if   e           k DISK

     fkdew01    if   e           k DISK

     fteil01    if   e           k DISK

     fteew01    if   e           k DISK

     fwaeh01    if   e           k DISK

     ftrtp01    if   e           k DISK

     fteos01    if   e           k DISK

     fkont01    if   e           k DISK

     fFPSKTO00  if   e           k DISK

     fbbea01    if   e           k DISK

     fbwae01    if   e           k DISK

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

       // ______________________________________________________________________
       // define data areas
       // ______________________________________________________________________
     D SIEVDSPMR       s              8p 0 dtaara

       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d sievDSPM_i    E DS                  ExtName(sievDSPM:*input)
     d                                     Qualified

     d sievDSPM_o    E DS                  ExtName(sievDSPM:*output)
     d                                     Qualified

     d sievDSPMw_i   E DS                  ExtName(sievDSPMw:*input)
     d                                     Qualified

     d sievDSPMw_o   E DS                  ExtName(sievDSPMw:*output)
     d                                     Qualified

     d afrk_k        E DS                  ExtName(afrk01:*key)
     d                                     Qualified

     d afrk_i        E DS                  ExtName(afrk01:*input)
     d                                     Qualified

     d bbek_k        E DS                  ExtName(bbek01:*key)
     d                                     Qualified

     d bbek_i        E DS                  ExtName(bbek01:*input)
     d                                     Qualified

     d afrp_k        E DS                  ExtName(afrp01:*key)
     d                                     Qualified

     d afrp_i        E DS                  ExtName(afrp01:*input)
     d                                     Qualified

     d afko_k        E DS                  ExtName(afko01:*key)
     d                                     Qualified

     d afko_i        E DS                  ExtName(afko01:*input)
     d                                     Qualified

     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
     d                                     Qualified

     d lief_k        E DS                  ExtName(lief01:*key)
     d                                     Qualified

     d lief_i        E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d kdew_k        E DS                  ExtName(kdew01:*key)
     d                                     Qualified

     d kdew_i        E DS                  ExtName(kdew01:*input)
     d                                     Qualified

     d teew_k        E DS                  ExtName(teew01:*key)
     d                                     Qualified

     d teew_i        E DS                  ExtName(teew01:*input)
     d                                     Qualified

     d kueg_k        E DS                  ExtName(kueg01:*key)
     d                                     Qualified

     d kueg_i        E DS                  ExtName(kueg01:*input)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d waeh_k        E DS                  ExtName(waeh01:*key)
     d                                     Qualified

     d waeh_i        E DS                  ExtName(waeh01:*input)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified

     d teos_k        E DS                  ExtName(teos01:*key)
     d                                     Qualified

     d teos_i        E DS                  ExtName(teos01:*input)
     d                                     Qualified

     d FPSKTO00_k    E DS                  ExtName(FPSKTO00:*key)
     d                                     Qualified

     d FPSKTO00_i    E DS                  ExtName(FPSKTO00:*input)
     d                                     Qualified

     d bbea_k        E DS                  ExtName(bbea01:*key)
     d                                     Qualified

     d bbea_i        E DS                  ExtName(bbea01:*input)
     d                                     Qualified

     d bwae_k        E DS                  ExtName(bwae01:*key)
     d                                     Qualified

     d bwae_i        E DS                  ExtName(bwae01:*input)
     d                                     Qualified

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

     D ttstamp         s               z   inz
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
     D #aemeng         s             11s 2 inz
     D §upload         s            256a   inz
     D §jahr           s              4s 0 inz
     D §monat          s              2s 0 inz
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §records        s              9s 0 inz
     D §text           s             48a   inz
     D $$TEEWPRGR_     s              1a   inz


      // Überschreibungen
      // ______________________________________________________________________
     IPHY01R
     I              status                      §status

     IPHY02R
     I              status                      §status

      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for DSPM Order   ';
       exsr      SR_log;

       //part one
       exsr  srinit;

       if err_msg = ' ';

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          if week > 0;
             in  *lock *dtaara;
             sievDSPMr = sievDSPMr  + 1;
             out *dtaara;
          endif;

          ttstamp              = %timestamp();
          open sievDSPM;

          read sievDSPM  sievDSPM_i;
          dow not %eof(sievDSPM) or  week = 0;
       //für upload
             if  sievDSPM_i.status = '  ';
                sievDSPM_o  = sievDSPM_i;
                exsr  sr_1000;

       //       sievDSPM_o.status    = '10';
       //       sievDSPM_o.#cc       = sievDSPMR;
                sievDSPM_o.tstamp    = ttstamp;

       //update
                update PHY01R    sievDSPM_o;
                clear            sievDSPM_o;
             endif;
             read sievDSPM  sievDSPM_i;
          enddo;
          close sievDSPM;

       //Übergabe
          exsr SR_2000;

          eval  suffix   = 'DE411 ';
          exsr  file_out;

          eval  suffix   = 'BE111 ';
          exsr  file_out;

          eval  suffix   = 'NL411 ';
          exsr  file_out;

          eval  suffix   = 'CH412 ';
          exsr  file_out;

          eval  suffix   = 'AT411 ';
          exsr  file_out;


       endif;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

         MONITOR;
            Wrk.var1 =
                'CPYF FROMFILE(TVRELWAECO/sievDSPM) ' +
                'TOFILE(TVRELWAECO/SIEVDSPMS) ' +
                'MBROPT(*ADD) CRTFILE(*NO) ' +
                'INCCHAR(STATUS 1 *EQ ''99'') FMTOPT(*NOCHK)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CPYF FROMFILE(sievDSPM) in sievDSPM#';
               exsr      SR_log;
       //      err_msg = '1';
         endmon;

       //part two
       exsr  srinit2;

       if err_msg = ' ';

          if week > 0;
             in  *lock *dtaara;
             sievDSPMr = sievDSPMr  + 1;
             out *dtaara;
          endif;

          ttstamp              = %timestamp();
          open sievDSPMw;

          read sievDSPMw sievDSPMw_i;
          dow not %eof(sievDSPMw) or  week = 0;
       //für upload
             if  sievDSPMw_i.status = '  ';
                sievDSPMw_o  = sievDSPMw_i;
                exsr  sr_3000;

       //       sievDSPMw_o.status    = '10';
       //       sievDSPMw_o.#cc       = sievDSPMR;
                sievDSPMw_o.tstamp    = ttstamp;

       //update
                update PHY02R    sievDSPMw_o;
                clear            sievDSPMw_o;
             endif;
             read sievDSPMw  sievDSPMw_i;
          enddo;
          close sievDSPMw;

       //Übergabe
          exsr SR_4000;

          eval  suffix   = 'DE411 ';
          exsr  file_out2;

          eval  suffix   = 'BE111 ';
          exsr  file_out2;

          eval  suffix   = 'NL411 ';
          exsr  file_out2;

          eval  suffix   = 'CH412 ';
          exsr  file_out2;

          eval  suffix   = 'AT411 ';
          exsr  file_out2;


       endif;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

         MONITOR;
            Wrk.var1 =
                'CPYF FROMFILE(TVRELWAECO/sievDSPMw) ' +
                'TOFILE(TVRELWAECO/SIEVDSPMws) ' +
                'MBROPT(*ADD) CRTFILE(*NO) ' +
                'INCCHAR(STATUS 1 *EQ ''99'') FMTOPT(*NOCHK)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CPYF FROMFILE(sievDSPMw) in sievDSPMw#';
               exsr      SR_log;
       //      err_msg = '1';
         endmon;

       eval status ='Ende  FTP Transfer for DSPM Order   ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei
       //-----------------------------------------------------------------------

       begsr srinit;

       clear     Wrk.var1;
       clear     status;
       err_msg = ' ';

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/sievDSPM)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/sievDSPM)            ';
               exsr      SR_log;
         endmon;
       endif;


       //balance orders from erp ERP Trend-System
       //65 ist 'Closed' wird als 'Invoiced' übergeben
       //when epbest = '30 ' then 'Delivered*' wird als open
       //when EPBEST = '36 ' then 'Invoiced* ' wird als open
       //when EPBEST = '45 ' then 'Invoiced* ' wird als open
       //when EPBEST = '50 ' then 'Invoiced* ' wird als open
       // 07102024    Gang  41, 42, 43 integriert
       //*************************************************************
       //update             bbep set epbete= 20221222
       //                        where epbete =            0
       //7 Zeilen in BBEP in TVPF aktualisiert.
       exec sql
        insert into tvrelwaeco/sievDSPM
        SELECT case
                     when epfirm ='01'
                      and EPWKNR ='001' then 'DE411'
                     when epfirm ='08'
                      and EPWKNR ='001' then 'BE111'
                     when epfirm ='52'
                      and EPWKNR ='001' then 'NL411'
                     when epfirm ='55'
                      and EPWKNR ='001' then 'CH412'
                     when epfirm ='61'
                      and EPWKNR ='001' then 'AT411'
                     when epfirm ='01'
                      and EPWKNR ='010' then 'SE811'
                     else 'UNDEF'
                     end  as  dcc,
        EPLFNR supplier, char(' ', 100) supplname,
        char ((char(digits(epbejj)) concat (EPBENR)), 10)
        punumbe, digits(EPBEPO) line,
          case
             when EPBEST < '30 ' then 'Open      '
             when epbest = '30 ' then 'Open      '
             when EPBEST = '35 ' then 'Open      '
             when EPBEST = '36 ' then 'Open      '
             when EPBEST = '38 ' then 'Returned  '
             when EPBEST = '40 ' then 'Delivered '
             when EPBEST = '43 ' then 'Delivered '
             when EPBEST = '45 ' then 'Open      '
             when EPBEST = '50 ' then 'Open      '
             when EPBEST = '60 ' then 'Invoiced  '
             when EPBEST = '41 ' then 'Invoiced  '
             when EPBEST = '42 ' then 'Invoiced  '
             when EPBEST = '65 ' then 'Invoiced  '
             when EPBEST = '92 ' then 'Cancelled '
             when EPBEST = '94 ' or EPBEST = '99 '    then 'Cancelled '
             else            char(EPBEST, 10)
          end as  statusord          , char(eptenr, 20) item,
          char(' ', 60) itemdesc, EPBETE requested,zoned((EPBETE), 8, 0)
          confirmed, EPMENG qrequested, zoned((EPMENG), 11, 2) qconfirmed,
          EPMEIN unititem,
          char(' ', 5) idco, ePLIBD incoterms, char('     ', 6)
          intDCC,  char(' ', 2) status,
                  current timestamp tstamp from bbep
          where  epbete >            0        and
                 date(date (date(substr(EPBETE, 1, 4)
                 concat '-' concat substr(EPBETE, 5, 2) concat '-' concat
                 substr(EPBETE, 7, 2)))) > current date - 385 day;


       //bereits als OK definierte herausnehmen
       exec sql
       delete from sievdspm a where
           DCC in (select DCCp from sievDSPMp b   where
                          PUNUMBE     = punumbep      and
                          line        = linep         and
                          STATUSORD   = STATUSORDp    and
                          a.REQUESTED = b.REQUESTED   and
                          a.CONFIRMED = b.CONFIRMED   and
                          a.QREQUESTED= b.QREQUESTED  and
                          a.QCONFIRMED= b.QCONFIRMED  and
                          STATUSP   = '99');

       if sqlcod < 0;
           err_msg = '1';
       endif;


       if err_msg = '1';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/sievDSPM) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error case CLRPFM FILE(TVRELWAECO/sievDSPM)        ';
               exsr      SR_log;
         endmon;
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
       //    Füllen Wareneingänge
       //-----------------------------------------------------------------------

       begsr srinit2;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/sievDSPMw)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/sievDSPMw)           ';
               exsr      SR_log;
         endmon;
       endif;


       //balance orders from erp ERP Trend-System
       //65 ist 'Closed' wird als 'Invoiced' übergeben
       exec sql
        insert into tvrelwaeco/sievDSPMw
        SELECT case
                     when aefirm ='01'
                      and aeWKNR ='001'then 'DE411'
                     when aefirm ='08'
                      and aeWKNR ='001'then 'BE111'
                     when aefirm ='52'
                      and aeWKNR ='001'then 'NL411'
                     when aefirm ='55'
                      and aeWKNR ='001'then 'CH412'
                     when aefirm ='61'
                      and aeWKNR ='001'then 'AT411'
                     when aefirm ='01'
                      and aeWKNR ='010'then 'SE811'
                     else 'UNDEF'
                     end  as  dcc,
        char(AEBLIN, 20) receptnote, (AEWEDA) deliveryd,
        char ((char(digits(AEBEJJ)) concat (AEBENR)), 10) punumbe,
        digits(AEBEPO) line,
        char(aetenr, 20) item, char(aetbz1, 60) itemdesc,
        aeMENG quantity,  aeMEIN unititem,
          case
             when AEWEST = '00 ' then 'Delivery  '
             when AEWEST = '05 ' then 'Return    '
             when AEWEST = '90 ' then 'to check  '
             else                 char(aewest, 10)
          end as  statusord,
        char(' ', 256) comment,
        char(' ', 2) status, current timestamp tstamp FROM bwae01
          where  date(date (date(substr(aeweda, 1, 4)
                 concat '-' concat substr(aeweda, 5, 2) concat '-' concat
                 substr(aeweda, 7, 2)))) > current date - 385 day;


       //bereits als OK definierte herausnehmen
       exec sql
       delete from sievdspmw a where
           DCC in (select DCCp from sievDSPMwp b   where
                          PUNUMBE      = punumbep      and
                          line         = linep         and
                          STATUSORD    = STATUSORDp    and
                          a.DELIVERYD  = b.DELIVERYD   and
                          a.RECEPTNOTE = b.RECEPTNOTE  and
                          STATUSP      = '99');

       if sqlcod < 0;
           err_msg = '1';
       endif;


       if err_msg = '1';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/sievDSPMw) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error case CLRPFM FILE(TVRELWAECO/sievDSPMw)        ';
               exsr      SR_log;
         endmon;
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
       //changes
       //-----------------------------------------------------------------------

       begsr sr_1000;

       //wir lesen immer mit Firma 01 !! wegen der Vollständigkeit
       //und ggf. dann nachlesen mit der eigentlichen Firma wenn ungleich 01
       //teos
          SIEVDSPM_o  = SIEVDSPM_i;

          teos_k.teosfirm =  '01';
          teos_k.TEOSKLCD =  'IDCO';
          teos_k.TEOSTENR =  SIEVDSPM_i.item;
          chain %kds(teos_k:3) teos01 teos_I;
          if %found(teos01) and teos_i.TEOSMM01 <> *blank;
             SIEVDSPM_o.idco       = teos_i.TEOSMM01;
          else;
             select;
                when SIEVDSPM_i.DCC = 'BE111';
                teos_k.teosfirm =  '08';
                when SIEVDSPM_i.DCC = 'NL411';
                teos_k.teosfirm =  '52';
                when SIEVDSPM_i.DCC = 'CH412';
                teos_k.teosfirm =  '55';
                when SIEVDSPM_i.DCC = 'AT411';
                teos_k.teosfirm =  '61';
             other;
             endsl;
             teos_k.TEOSKLCD =  'IDCO';
             teos_k.TEOSTENR =  SIEVDSPM_i.item;
             chain %kds(teos_k:3) teos01 teos_I;
             if %found(teos01) and teos_i.TEOSMM01 <> *blank;
                SIEVDSPM_o.idco       = teos_i.TEOSMM01;
             endif;
          endif;
          select;
             when SIEVDSPM_i.DCC = 'DE411';
             teil_k.tefirm   =  '01';
             when SIEVDSPM_i.DCC = 'BE111';
             teil_k.tefirm   =  '08';
             when SIEVDSPM_i.DCC = 'NL411';
             teil_k.tefirm   =  '52';
             when SIEVDSPM_i.DCC = 'CH412';
             teil_k.tefirm   =  '55';
             when SIEVDSPM_i.DCC = 'AT411';
             teil_k.tefirm   =  '61';
             other;
          endsl;

       //teew        TEEWIDCO
          Teew_k.Teewfirm     =  '01';
          Teew_k.Teewtenr     =  SIEVDSPM_i.item;
          chain %kds(Teew_k:2) Teew01  Teew_I;
          if %found(Teew01);
                SIEVDSPM_o.idco       = teew_i.TEEWIDCO;
          endif;

       //teil
          teil_k.tetenr    =  SIEVDSPM_i.item;
          chain %kds(teil_k:2) teil01 teil_I;
          if %found(teil01);
                SIEVDSPM_o.itemdesc   = teil_i.TETBZ1;
          endif;

          §search              = ';';
          §string              = SIEVDSPM_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPM_o.ITEMDESC  = §string;

          §search              = ',';
          §string              = SIEVDSPM_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPM_o.ITEMDESC  = §string;

          §search              = '"';
          §string              = SIEVDSPM_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPM_o.ITEMDESC  = §string;

          §search              = '`';
          §string              = SIEVDSPM_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPM_o.ITEMDESC  = §string;


       //kund
          lief_k.lffirm  =  teil_k.tefirm;
          lief_k.lflfnr  =  SIEVDSPM_i.SUPPLIER;
          chain %kds(lief_k:2) lief01 lief_I;
          if %found(lief01);
                SIEVDSPM_o.SUPPLNAME  = lief_i.lfnam1;
          endif;

       //bbek
       //klären Positionsbeziehung zum Kopf spezeil bei Teil .....
       //prüfen auf Vollständikeit über Kennzung -
       //mathematische Prüfung bei Teillieferunegn in Bezug auf Menge
       //Überlieferung gilt als erledigt Achtung wird bereits abgefragt
       //über Wareneingang
          if SIEVDSPM_i.INCOTERMS <> '   ';
             bbek_k.ekfirm  =  teil_k.tefirm;
             bbek_k.EKBEJJ  =  %dec(%subst(SIEVDSPM_i.PUNUMBE: 1: 4): 4: 0);
             bbek_k.ekbenr  =  %subst(SIEVDSPM_i.PUNUMBE: 5: 6);
             chain %kds(bbek_k:3) bbek01 bbek_I;
             if %found(bbek01);
                SIEVDSPM_o.INCOTERMS  = bbek_i.eklibd;
                trtp_k.tpfirm  =  bbek_i.ekfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'LIBD      ';
                trtp_k.TPTCDE  =  bbek_i.eklibd;
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   SIEVDSPM_o.INCOTERMS  =  %subst(trtp_i.TPTTXT: 1: 3);
                endif;
             endif;
          endif;

          if   %subst(SIEVDSPM_i.SUPPLIER:1:5)  ='92013';
               %subst(SIEVDSPM_i.SUPPLIER:1:5)  ='92013';
          endif;

          FPSKTO00_k.P0KTO       = '200000000';

          select;
          when SIEVDSPM_i.DCC = 'DE411';
               FPSKTO00_k.P0FA    =   51;
               %subst(FPSKTO00_k.P0KTO:2:5) = %subst(SIEVDSPM_i.SUPPLIER:1:5);
          when SIEVDSPM_i.DCC = 'BE111';
               FPSKTO00_k.P0FA    =   08;
               %subst(FPSKTO00_k.P0KTO:2:7) = %subst(SIEVDSPM_i.SUPPLIER:1:7);
          when SIEVDSPM_i.DCC = 'NL411';
               FPSKTO00_k.P0FA    =   52;
               %subst(FPSKTO00_k.P0KTO:2:7) = %subst(SIEVDSPM_i.SUPPLIER:1:7);
          when SIEVDSPM_i.DCC = 'CH412';
               FPSKTO00_k.P0FA    =   55;
               %subst(FPSKTO00_k.P0KTO:2:5) = %subst(SIEVDSPM_i.SUPPLIER:1:5);
          when SIEVDSPM_i.DCC = 'AT411';
               FPSKTO00_k.P0FA    =   61;
               %subst(FPSKTO00_k.P0KTO:2:6) = %subst(SIEVDSPM_i.SUPPLIER:1:6);
          other;
               FPSKTO00_k.P0FA    =  *zero;
          endsl;

          chain %kds(FPSKTO00_k:2) FPSKTO00  FPSKTO00_I;
          if %found(FPSKTO00);
       //    SIEVDSPM_o.INTDCC   =  FPSKTO00_i.P0VBMG;
          else;
       //    SIEVDSPM_o.INTDCC   =  *blank;
          endif;

       //bbea
             bbea_k.eafirm  =  teil_k.tefirm;
             bbea_k.EaBEJJ  =  %dec(%subst(SIEVDSPM_i.PUNUMBE: 1: 4): 4: 0);
             bbea_k.eabenr  =  %subst(SIEVDSPM_i.PUNUMBE: 5: 6);
             bbea_k.eabepo  =  %dec(%subst(SIEVDSPM_i.LINE: 1: 4): 4: 0);
             chain %kds(bbea_k:4) bbea01 bbea_I;
             if %found(bbea01);
                SIEVDSPM_o.requested  = bbea_i.eabete;
                SIEVDSPM_o.qrequested = bbea_i.eameng;
             endif;
             if SIEVDSPM_o.requested  = *zero;
                SIEVDSPM_o.requested  = SIEVDSPM_i.confirmed;
             endif;
             if SIEVDSPM_o.qrequested = *zero;
                SIEVDSPM_o.qrequested = SIEVDSPM_i.qconfirmed;
             endif;

       //waea
          if SIEVDSPM_o.STATUSORD =  'Open      ';
             #aemeng        =  0;
             bwae_k.aefirm  =  teil_k.tefirm;
             bwae_k.aeBEJJ  =  %dec(%subst(SIEVDSPM_i.PUNUMBE: 1: 4): 4: 0);
             bwae_k.aebenr  =  %subst(SIEVDSPM_i.PUNUMBE: 5: 6);
             bwae_k.aebepo  =  %dec(%subst(SIEVDSPM_i.LINE: 1: 4): 4: 0);
             setll %kds(bwae_k:4) bwae01;
             reade %kds(bwae_k:4) bwae01  bwae_i;
             dow not %eof(bwae01);
                #aemeng = #aemeng + bwae_i.AEMENG;
                if bwae_i.AETLKZ  = 'J' or
                   ( #AEMENG = SIEVDSPM_o.qconfirmed or
                     #AEMENG > SIEVDSPM_o.qconfirmed );
                   SIEVDSPM_o.STATUSORD =  'Delivered ';
                endif;
                reade %kds(bwae_k:4) bwae01  bwae_i;
             enddo;
          endif;

          SIEVDSPM_o.qrequested = SIEVDSPM_o.qrequested *100;
          SIEVDSPM_o.qconfirmed = SIEVDSPM_o.qconfirmed *100;

          SIEVDSPM_o.status =  '99';

          if SIEVDSPM_o.DCC       = 'UNDEF' or
             SIEVDSPM_o.IDCO      = *blank  or
             SIEVDSPM_o.INCOTERMS = *blank;
             SIEVDSPM_o.status =  'ER';
          endif;
          if SIEVDSPM_o.INCOTERMS =  'EXW' or
             SIEVDSPM_o.INCOTERMS =  'FCA' or
             SIEVDSPM_o.INCOTERMS =  'FAS' or
             SIEVDSPM_o.INCOTERMS =  'FOB' or
             SIEVDSPM_o.INCOTERMS =  'CFR' or
             SIEVDSPM_o.INCOTERMS =  'CIF' or
             SIEVDSPM_o.INCOTERMS =  'DAT' or
             SIEVDSPM_o.INCOTERMS =  'DAP' or
             SIEVDSPM_o.INCOTERMS =  'CPT' or
             SIEVDSPM_o.INCOTERMS =  'CIP' or
             SIEVDSPM_o.INCOTERMS =  'DDP';
          else;
             SIEVDSPM_o.status =  'ER';
          endif;
          if SIEVDSPM_o.STATUSORD =  'Open      '  or
             SIEVDSPM_o.STATUSORD =  'Delivered '  or
             SIEVDSPM_o.STATUSORD =  'Invoiced  '  or
       //    SIEVDSPM_o.STATUSORD =  'Closed    '  or
             SIEVDSPM_o.STATUSORD =  'Cancelled ';
          else;
             SIEVDSPM_o.status =  'ER';
          endif;
          select;
          when SIEVDSPM_o.UNITITEM  =  'S'  or
               SIEVDSPM_o.UNITITEM  =  's'  or
               SIEVDSPM_o.UNITITEM  =  'ST' or
               SIEVDSPM_o.UNITITEM  =  'sT';
               SIEVDSPM_o.UNITITEM  =  'PCS';
          when SIEVDSPM_o.UNITITEM  =  'K'  or
               SIEVDSPM_o.UNITITEM  =  'k';
               SIEVDSPM_o.UNITITEM  =  'KG ';
          when SIEVDSPM_o.UNITITEM  =  'M'  or
               SIEVDSPM_o.UNITITEM  =  'm';
               SIEVDSPM_o.UNITITEM  =  'M  ';
          other;
             SIEVDSPM_o.status =  'ER';
          endsl;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //changes
       //-----------------------------------------------------------------------

       begsr sr_3000;

          SIEVDSPMw_o  = SIEVDSPMw_i;

          §search              = ';';
          §string              = SIEVDSPMw_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPMw_o.ITEMDESC = §string;

          §search              = ',';
          §string              = SIEVDSPMw_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPMw_o.ITEMDESC = §string;

          §search              = '"';
          §string              = SIEVDSPMw_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPMw_o.ITEMDESC = §string;

          §search              = '`';
          §string              = SIEVDSPMw_o.ITEMDESC;
          §replace             = ' ';
          §pos                 = 0 ;
          exsr      scanstr;
          SIEVDSPMw_o.ITEMDESC = §string;


          SIEVDSPMw_o.QUANTITY = SIEVDSPMw_o.QUANTITY *100;

          SIEVDSPMw_o.status =  '99';

          if SIEVDSPMw_o.DCC       = 'UNDEF' or
             SIEVDSPMw_o.status =  'ER';
          endif;
          if SIEVDSPMw_o.STATUSORD =  'Delivery  '  or
             SIEVDSPMw_o.STATUSORD =  'Return    '  or
             SIEVDSPMw_o.STATUSORD =  'Correction'  or
             SIEVDSPMw_o.STATUSORD =  'Rework    '  or
             SIEVDSPMw_o.STATUSORD =  'Subcontrac';
          else;
             SIEVDSPMw_o.status =  'ER';
          endif;
          select;
          when SIEVDSPMw_o.UNITITEM  =  'S'  or
               SIEVDSPMw_o.UNITITEM  =  's'  or
               SIEVDSPMw_o.UNITITEM  =  'ST' or
               SIEVDSPMw_o.UNITITEM  =  'sT';
               SIEVDSPMw_o.UNITITEM  =  'PCS';
          when SIEVDSPMw_o.UNITITEM  =  'K'  or
               SIEVDSPMw_o.UNITITEM  =  'k';
               SIEVDSPMw_o.UNITITEM  =  'KG ';
          when SIEVDSPMw_o.UNITITEM  =  'M'  or
               SIEVDSPMw_o.UNITITEM  =  'm';
               SIEVDSPMw_o.UNITITEM  =  'M  ';
          other;
               SIEVDSPMw_o.status =  'ER';
          endsl;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Übergabevorbereitung erledigte markieren und speichern
       //-----------------------------------------------------------------------

       begsr sr_2000;

       //balance orders from erp ERP Trend-System
       exec sql
        insert into tvrelwaeco/sievDSPMp
        SELECT DCC dccp, PUNUMBE punumbep, line linep, STATUSORD
        STATUSORDp, REQUESTED, CONFIRMED, QREQUESTED, QCONFIRMED,
        status  STATUSp, tstamp tstamp FROM sievDSPM
        where status= '99';

       if sqlcod < 0;
           err_msg = '1';
       endif;


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;


       endsr;

       // ______________________________________________________________________
       //-----------------------------------------------------------------------
       //Übergabevorbereitung erledigte markieren und speichern
       //-----------------------------------------------------------------------

       begsr sr_4000;

       //balance orders from erp ERP Trend-System
       exec sql
        insert into tvrelwaeco/sievDSPMwp
        SELECT DCC dccp, PUNUMBE punumbep, line linep, STATUSORD
        STATUSORDp, DELIVERYD, RECEPTNOTE,
        status  STATUSp, tstamp tstamp FROM sievDSPMw
        where status= '99';

       if sqlcod < 0;
           err_msg = '1';
       endif;


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;


       endsr;

       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Statistik
       //-----------------------------------------------------------------------

       begsr statistik;


          §jahr           = %dec(%subst(%char(SIEVDSPM_i.REQUESTED):1:4):4:0);
          §monat          = %dec(%subst(%char(SIEVDSPM_i.REQUESTED):5:2):2:0);
          select;
             when §monat  = 01;
             when §monat  = 02;
             when §monat  = 03;
       //
             when §monat  = 04;
             when §monat  = 05;
             when §monat  = 06;
       //
             when §monat  = 07;
             when §monat  = 08;
             when §monat  = 09;
       //
             when §monat  = 10;
             when §monat  = 11;
             when §monat  = 12;
             other;
          endsl;

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
       //output
       //-----------------------------------------------------------------------

       begsr file_out;

       //Ausgabe der einzelnen Files über variable
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6720';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'DSPMP'        +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export Datei vorher vom Inhalt löschen
         MONITOR;
            Wrk.var1 =
                'clrpfm file(TVRELWAECO/'+ p_outfil +')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error clrpfm file ' +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval p_outfil  =  'DSPMP'        +
                            suffix;

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
       //      //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6720';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'DSPMP'        +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:    p_print:
                        p_outfil: p_lib:    p_repadd);

         eval  transfer =  %trimr(suffix) +'_' +'POL_'           +
                            %char(%dec(%char(%date():*iso0):8:0)) +
       //Achtung, Datei wird nur einmal täglich geladen
       //                   %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export in Übertragungsdatei
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/DSPM_OUT DSPM_OUT) '+
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

         eval p_outfil  =  'DSPMP'        +
                            suffix;
         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from DSPM_OUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(SIEVOIIRC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(SIEVOIIRC)   ';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'DSPMP'        +
                               suffix;
            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(SIEVOIIR)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO FTP)';
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



            eval p_outfil  =  'DSPMP'        +
                               suffix;
       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'DSPMP'   +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'DSPM_OUT ' +
                                 transfer;

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //FTP-Befehl    ftp.seit.dometic.com
       //          'FTP RMTSYS(''193.243.144.204'')';
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
               status='error ftp.seit.dometic.com '    +
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
               eval p_outfil  =  'DSPMP'        +
                                 suffix;
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

            endif;
       else;
          status='Übertragungsdatei leer ' + p_outfil;
          exsr      SR_log;
       endif;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out2;

       //Ausgabe der einzelnen Files über variable
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6721';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'DSPMG'        +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export Datei vorher vom Inhalt löschen
         MONITOR;
            Wrk.var1 =
                'clrpfm file(TVRELWAECO/'+ p_outfil +')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error clrpfm file ' +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval p_outfil  =  'DSPMG'        +
                            suffix;

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
       //      //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6721';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'DSPMG'        +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:    p_print:
                        p_outfil: p_lib:    p_repadd);

         eval  transfer =  %trimr(suffix) +'_' +'GRN_'           +
                            %char(%dec(%char(%date():*iso0):8:0)) +
       //Achtung, Datei wird nur einmal täglich geladen
       //                   %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export in Übertragungsdatei
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/DSPM_OUT DSPM_OUT) '+
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

         eval p_outfil  =  'DSPMG'        +
                            suffix;
         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from DSPM_OUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(SIEVOIIRC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(SIEVOIIRC)   ';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'DSPMG'        +
                               suffix;
            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(SIEVOIIR)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO FTP)';
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



            eval p_outfil  =  'DSPMG'        +
                               suffix;
       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'DSPMG'   +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'DSPM_OUT ' +
                                 transfer;

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //FTP-Befehl    ftp.seit.dometic.com
       //          'FTP RMTSYS(''193.243.144.204'')';
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
               status='error ftp.seit.dometic.com '    +
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
               eval p_outfil  =  'DSPMG'        +
                                 suffix;
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
       //  %Subarr(p_md:01)  = 'sievoIIR  ';
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


