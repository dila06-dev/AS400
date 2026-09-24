
      //************************************************************************
      //
      //      Programmname       galaxusr
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung            Bestände
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
      //  tvpf/lbbs01
      //  LBBSLANR
      //  LBBSFIRM='01' and (LBBSLANR not in ('001',
      //  '001','100', '110', '094', '095', '096',
      //  '200') and not substr(LBBSLANR, 1, 1)='7')
      //  LBBSLANR
      //
      //  CRTSRCPF FILE(TVRELWAECO/BESTANDZU) RCDLEN(120) MBR(BESTANDZU) TEXT('impo
      //  rting for replanishment')
      //
      //  CRTPF FILE(tvrelwaeco/BESTANDIMP) RCDLEN(100) TEXT('importing replanishment')
      //
      //  CRTSRCPF FILE(TVRELWAECO/KUNDENAUF) RCDLEN(120) MBR(KUNDENAUF) TEXT('impo
      //         rting for replanishment')
      //
      //  CRTSRCPF FILE(TVRELWAECO/RUCKSTAND) RCDLEN(120) MBR(RUCKSTAND) TEXT('impo
      //         rting for replanishment')
      //  CPYFRMSTMF FROMSTMF('/trend/echt/edi/out/dsx/Rueckstaende01.txt') TOMBR('
      //  /QSYS.LIB/TVRELWAECO.LIB/RUCKSTAND.FILE/RUCKSTAND.MBR') MBROPT(*REPLACE)
      //  Datenstromdatei in Objekt kopiert.
      //
      //  CRTPF FILE(tvrelwaeco/KUNDENAIMP) RCDLEN(100) TEXT('importing
      //         replanishment')
      //
      //  CRTPF FILE(tvrelwaeco/RUCKSTANDI) RCDLEN(100) TEXT('importing
      //         replanishment')
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/itemmaster.csv')
      //  DBFILE(TVRELWAECO/itemmaster) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/itemmaster.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/PURCHASEOR.csv')
      //  DBFILE(TVRELWAECO/PURCHASEOR) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/PURCHASEOR.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/INTRANSIT.csv')
      //  DBFILE(TVRELWAECO/PURCHASEOR) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/INTRANSIT.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/INVENTORY.csv')
      //  DBFILE(TVRELWAECO/PURCHASEOR) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/INVENTORY.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/CUSTOMOR.csv')
      //  DBFILE(TVRELWAECO/PURCHASEOR) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/CUSTOMOR.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/SKUSUPPLIE.csv')
      //  DBFILE(TVRELWAECO/itemmaster) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/SKUSUPPLIE.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
      //
      //  CVTDBF OBJ('/Lager/Stammdaten/SUPPLNRNAM.csv')
      //  DBFILE(TVRELWAECO/itemmaster) DBOUTFMT(*CSV)
      //  DBFLDDSC(*YES)
      //
      //  CHGAUT OBJ('/Lager/Stammdaten/SUPPLNRNAM.csv')
      //  USER(*PUBLIC) DTAAUT(*RWX)
      //  OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
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
     fSKUSUPPLIEuf   e             disk    RENAME(SKUSUPPLIE:PHY01R)
     f                                     USROPN

     fCUSTOMOR  uf   e             disk    RENAME(CUSTOMOR  :PHY02R)
     f                                     USROPN

     fitemmasteruf   e             disk    RENAME(itemmaster:PHY03R)
     f                                     prefix('$')
     f                                     USROPN


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
     dSKUSUPPLIE_i   E DS                  ExtName(SKUSUPPLIE:*input)
     d                                     Qualified
     dSKUSUPPLIE_o   E DS                  ExtName(SKUSUPPLIE:*output)
     d                                     Qualified
     dCUSTOMOR_i     E DS                  ExtName(CUSTOMOR:*input)
     d                                     Qualified
     dCUSTOMOR_o     E DS                  ExtName(CUSTOMOR:*output)
     d                                     Qualified
     ditemmaster_i   E DS                  ExtName(ITEMMASTER:*input)
     d                                     Qualified
     ditemmaster_o   E DS                  ExtName(ITEMMASTER:*output)
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
     d SIEVOIIR        PR                  ExtPgm('SIEVOIIR')
     d WAO065SJ        PR                  ExtPgm('WAO065SJ')
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

     C     *ENTRY        PLIST
     C                   PARM                    fkt               1

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




       eval status ='Start FTP Transfer for BLOMGREN     ';
       exsr      SR_log;

       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 050000
          and NumSysTime < 070000;
       endif;
       // if fkt        = '1';
       if fkt        = '1';
       //for update files
          callP WE_CHECK();

       //for update files und uploading FTP scheduler inaktiv
       //03.07.2019
          callP SIEVOIIR();

          exsr  srinit;

          exsr      scan  ;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          eval  suffix   = 'DE411 ';
       //output ITEMMASTER
          exsr  file_out1;
       //output INTRANSIT
          exsr  file_out2;
       //output INVENTORY vorher bereinigen tetenr wenn Komma
       exec sql
         delete   FROM INVENTORY
         WHERE TETENR like '%,%' or TETENR like '%;%';
          exsr  file_out3;

       //output PURCHASEOR
          exsr  file_out4;

       //output CUSTOMOR
          exsr  file_out5;

       //output SKUSUPPLIE
       // exsr  file_out6;

       //output SUPPLNRNAM  new version of SKUSUPPLIE
          exsr  file_out6b;
       //output REP_CODES
          exsr  file_out7b;
          exsr  file_savI5;
       endif;

       if fkt        = '2';

       //copy files from trend dxs support  Bestandszugang
         MONITOR;
            Wrk.var1 =
                'CPYFRMSTMF FROMSTMF'+
                '(''/trend/echt/edi/out/dsx/BESTANDZUGANG.txt'') '+
                'TOMBR'+
                '(''/QSYS.LIB/TVRELWAECO.LIB/BESTANDZU.FILE/BESTANDZU.MBR'') '+
                'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
               status='erledigt cpyf BESTANDZUGANG                      ';
               exsr      SR_log;
            on-error;
               status='error cpyf BESTANDZUGANG                         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
         Wrk.var1 =
             'CPYFRMIMPF FROMFILE(TVRELWAECO/BESTANDZU) ' +
             'TOFILE(TVRELWAECO/BESTANDIMP) MBROPT(*REPLACE) '  +
             'FLDDLM(*TAB)';
           cmd = %TrimR(Wrk.Var1);
           L      = %Len(Cmd);
           QCMDEXC(cmd: %len(cmd));
            status='erledigt                   CPYFRMIMPF BESTANDZU   ';
            exsr      SR_log;
         on-error;
            status='error in command appeared: CPYFRMIMPF BESTANDZU   ';
            exsr      SR_log;
         endmon;
       //output BESTANDZUGANG ==> BESTANDIMP
          exsr  file_out7;


       //copy files from trend dxs support Kundenauftraege
       // ===> CPYFRMSTMF FROMSTMF('/trend/echt/edi/out/dsx/Kundenauftraege01.txt') TOMBR
       //('/QSYS.LIB/TVRELWAECO.LIB/KUNDENAUF.FILE/KUNdenauf.mbr') MBROPT(*REPLACE)
         MONITOR;
            Wrk.var1 =
                'CPYFRMSTMF FROMSTMF'+
                '(''/trend/echt/edi/out/dsx/Kundenauftraege01.txt'') '+
                'TOMBR'+
                '(''/QSYS.LIB/TVRELWAECO.LIB/KUNDENAUF.FILE/KUNDENAUF.MBR'') '+
                'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
               status='erledigt cpyf Kundenauftraege                    ';
               exsr      SR_log;
            on-error;
               status='error cpyf Kundenauftraege                       ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
         Wrk.var1 =
             'CPYFRMIMPF FROMFILE(TVRELWAECO/Kundenauf) ' +
             'TOFILE(TVRELWAECO/KUNDENAIMP) MBROPT(*REPLACE) '  +
             'FLDDLM(*TAB)';
           cmd = %TrimR(Wrk.Var1);
           L      = %Len(Cmd);
           QCMDEXC(cmd: %len(cmd));
            status='erledigt                   CPYFRMIMPF Kundenauf   ';
            exsr      SR_log;
         on-error;
            status='error in command appeared: CPYFRMIMPF Kundenauf   ';
            exsr      SR_log;
         endmon;

       //output Kundenauftraege ==> KUNDENAIMP
          exsr  file_out8;

       //copy files from trend dxs support Rueckstaende01
       // ===> CPYFRMSTMF FROMSTMF('/trend/echt/edi/out/dsx/Rueckstaende01.txt') TOMBR
       //('/QSYS.LIB/TVRELWAECO.LIB/RUCKSTAND.FILE/RUCKSTAND.mbr') MBROPT(*REPLACE)
         MONITOR;
            Wrk.var1 =
                'CPYFRMSTMF FROMSTMF'+
                '(''/trend/echt/edi/out/dsx/Rueckstaende01.txt'') '+
                'TOMBR'+
                '(''/QSYS.LIB/TVRELWAECO.LIB/RUCKSTAND.FILE/RUCKSTAND.MBR'') '+
                'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
               status='erledigt cpyf Rückstände                         ';
               exsr      SR_log;
            on-error;
               status='error cpyf Rückstände                            ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
         Wrk.var1 =
             'CPYFRMIMPF FROMFILE(TVRELWAECO/RUCKSTAND) ' +
             'TOFILE(TVRELWAECO/RUCKSTANDI) MBROPT(*REPLACE) '  +
             'FLDDLM(*TAB)';
           cmd = %TrimR(Wrk.Var1);
           L      = %Len(Cmd);
           QCMDEXC(cmd: %len(cmd));
            status='erledigt                   CPYFRMIMPF RUCKSTAND   ';
            exsr      SR_log;
         on-error;
            status='error in command appeared: CPYFRMIMPF RUCKSTAND   ';
            exsr      SR_log;
         endmon;

       //output RUCKSTAND       ==> RUCKSTANDI
          exsr  file_out9;

       //output FORECASTS01 neu 10.04.2026 start
       //copy files from trend dxs support Forecasts01.txt
       // ===> CPYFRMSTMF FROMSTMF('/trend/echt/edi/out/dsx/Forecasts01.txt') TOMBR
       //('/QSYS.LIB/TVRELWAECO.LIB/FORECAST.FILE/FORECAST.mbr') MBROPT(*REPLACE)
         MONITOR;
            Wrk.var1 =
                'CPYFRMSTMF FROMSTMF'+
                '(''/trend/echt/edi/out/dsx/Forecasts01.txt'') '+
                'TOMBR'+
                '(''/QSYS.LIB/TVRELWAECO.LIB/FORECAST.FILE/FORECAST.MBR'') '+
                'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
               status='erledigt cpyf FORECAST done                      ';
               exsr      SR_log;
            on-error;
               status='error cpyf FORECAST error                        ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
         Wrk.var1 =
             'CPYFRMIMPF FROMFILE(TVRELWAECO/FORECAST) ' +
             'TOFILE(TVRELWAECO/FORECASTI) MBROPT(*REPLACE) '  +
             'FLDDLM(*TAB)';
           cmd = %TrimR(Wrk.Var1);
           L      = %Len(Cmd);
           QCMDEXC(cmd: %len(cmd));
            status='erledigt                   CPYFRMIMPF FORECAST    ';
            exsr      SR_log;
         on-error;
            status='error in command appeared: CPYFRMIMPF FORECAST    ';
            exsr      SR_log;
         endmon;

       //output forecast        ==> forecastI
          exsr  file_outX;

       //output FORECASTS01 neu 10.04.2026 ende

       endif;

       if fkt        = '3';
       //CALL PGM(WAO065SJ)  ohne Parameter 6:15
       // callP WAO065SJ(), liest plandaten.txt ein
          MONITOR;
             Wrk.var1 =
                 'SBMJOB CMD(CALL PGM(MODWAO/WAO065SJ) ' +
                 'PARM(''MODWAO'' ''01'' ''ECHT'')) ' +
                 'JOB(DSX_IMP_PL) JOBQ(TAMP/JQTFX01)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                status='erledigt SBMJOB CMD(CALL PGM(MODWAO/WAO065SJ))';
                exsr      SR_log;
             on-error;
                status='error SBMJOB CMD(CALL PGM(MODWAO/WAO065SJ))';
                exsr      SR_log;
          endmon;

          MONITOR;
             Wrk.var1 =
                 'DLYJOB DLY(0600)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                status = 'DLYJOB (0600) nach TVPP/WAO065SJ                ';
                exsr      SR_log;
             on-error;
                status = 'error DLYJOB nach TVPP/WAO065SJ                 ';
                exsr      SR_log;
          endmon;

       //CALL PGM(TRBO05SJ)  ohne Parameter 6:15  Bernd
       // callP TRBP05SJ(), verarbeitet diese zu Absatzplänen
       // und muß nach wao065sj laufen
          MONITOR;
             Wrk.var1 =
                 'SBMJOB CMD(CALL PGM(TVPP/TRBP05SJ) ' +
                 'PARM(''01'' ''MODWAO'' ''99'' ''001'' ''ECHT'')) ' +
                 'JOB(DSX_IMP_PL) JOBQ(TAMP/JQTFX01)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                status='erledigt SBMJOB CMD(CALL PGM(TVPP/TRBP05SJ))';
                exsr      SR_log;
             on-error;
                status='error SBMJOB CMD(CALL PGM(TVPP/TRBP05SJ))';
                exsr      SR_log;
          endmon;

          MONITOR;
             Wrk.var1 =
                 'DLYJOB DLY(0600)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                status = 'DLYJOB (0600) nach TVPP/TRBP05SJ                ';
                exsr      SR_log;
             on-error;
                status = 'error DLYJOB nach TVPP/TRBP05SJ                 ';
                exsr      SR_log;
          endmon;

       //CALL PGM(TRRG09SJ)  ohne Parameter 6:15 ehemals aus wrkjobscde TRDDISPO01
       // CALL PGM(TVPP/TRRG09SJ) PARM('MODWAO' '01'), Reorganisation Dispo Firma 01
          MONITOR;
             Wrk.var1 =
                 'SBMJOB CMD(CALL PGM(TVPP/TRRG09SJ) ' +
                 'PARM(''MODWAO'' ''01'')) ' +
                 'JOB(DSX_IMP_PL) JOBQ(TAMP/JQTFX01)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                status='erledigt SBMJOB CMD(CALL PGM(TVPP/TRRG09SJ))';
                exsr      SR_log;
             on-error;
                status='error SBMJOB CMD(CALL PGM(TVPP/TRRG09SJ))';
                exsr      SR_log;
          endmon;
       endif;


       //Bereitgestellte Daten von Trend ab 07:00
       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 063000
          and NumSysTime < 190000;
       endif;

          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';


       eval status ='Ende  FTP Transfer for BLOMGREN     ';
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
                'CLRPFM FILE(TVRELWAECO/ITEMMASTER)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/ITEMMASTER)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/PURCHASEOR)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/PURCHASEOR)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/INTRANSIT)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/INTRANSIT)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;
       //
       //Inventory data (SKU, Onhand (LFS Bestand), verfügbarer
       //                Bestand, Reservierter Bestand
       //                Onhand-Reservierter Bestand=verfügbarer
       //                Bestand
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/INVENTORY)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/INVENTORY)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //
       //orders from customers still on going
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/CUSTOMOR)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/CUSTOMOR)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //
       //SKUSUPPLIE
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/SKUSUPPLIE)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/SKUSUPPLIE)       ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;


       //
       //REP_CODES
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/REP_CODES)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/REP_CODES)        ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

       //SUPPLNRNAM
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/SUPPLNRNAM)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/SUPPLNRNAM)       ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
       //BLOMGREN_1 Zwischenträger
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/BLOMGREN_1)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/BLOMGREN_1)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
       //BLOMGREN_2 Zwischenträger
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/BLOMGREN_2)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/BLOMGREN_2)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
       //TMPDELIVER Zwischenträger
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/TMPDELIVER)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/TMPDELIVER)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;

         MONITOR;
       //TMPDELIVE2 Zwischenträger
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/TMPDELIVE2)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/TMPDELIVE2)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;


         MONITOR;
       //TMPDELIVER Zwischenträger
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/TMPframe)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/TMPframe)         ';
               exsr      SR_log;
               status = §§§MTX;
               exsr      SR_log;
         endmon;
       endif;

       //for itemmaster
       //heraus ohne 80, 81, 90

       //LFVOBU             LIEF               B-Urlaub ab
       //LFBIBU             LIEF               Betr-Url.  bis
       exec sql
        insert into tvrelwaeco/ITEMMASTER
        SELECT  TELOCK, TEJNAM, TEJDAT, TEJZEI, TEUSER, TEPROG, TEBIBL,
        TEFIRM, TETENR, TEEZNR, TEINDX, TERALN, TEWKNR, TETBZ1, TETBZ2,
        TEZINR, TETEST, TEMCBG, TEERTE, TETART, TEMEIN, TEMAGR, TEARKZ,
        TEZIFM, TENOAR, TENONR, TEGWDI, TEEANR, TEWKST, TEFRDA, TEAEDA,
        TEAEND, TENGKZ, TEGWNT, TEGWBR, TEERDA, TEERUS, TESAAV, TEDIAV,
        TELOGR, TEAUSF, TEAUSA, TEVOZ1, TEVOA1, TEALDI, TEBESL, TEGKKZ,
        TERPZT, TEFBKZ, TESITG, TESIBE, TEMEAV, TEABC1, TEABC2, TEABC3,
        TEPDAV, TEDUP2, TEVEP2, TEV2DA, TEVEPV, TESTPV, TESTDA, TESTPR,
        TEINPR, TEINDA, TEUMDA, TEUMMG, TEBGKZ, TEAPKZ, TESAEK, TEDIEK,
        TEMEEK, TEMPEK, TELVZ1, TEEWPF, TELVA1, TELVZ2, TELVA2, TEZOTN,
        TELFNR, TESTLF, TEMIBM, TEPDEK, TEHOBS, TELEEK, TELEBS, TELENE,
        TELBPB, TELERE, TELBPN, TEDUPR, TEDUDA, TEVEPR, TEVEDA, TELPGR,
        TEACDA, TEQSEK, TEPDVK, TEMWST, TEMPVK, TEURLD, TEUREG, TEMEVK,
        TEVPEI, TESAVK, TEFRTA, TEPRGR, TEKOKZ, TEZOAN, TEZPUR, TEEBKZ,
        TEABC4, TEABC5, TEABC6, TEZUAB, TEKASL, TEWBKT, TEEBKT, TEKOTR,
        TELANR, TEEPFG, TEPAM1, TEIVPE, TELANG, TEBSKZ, TEGBKZ, TEGPKZ,
        TECTKZ, TERPKZ, TEDALA, TEDALZ, TEDOKZ, TECHKZ, TEWEMT, TEQSME,
        TEGUZT, TEGUDI, TEAWKZ, TEKDGR, TEBONU, TEVLZ1, TEVLA1, TEGBST,
        TEIAKZ, TEPEOB, TEAFKZ, TEFAKZ, TEVIKZ, TEHIKZ, TEVAKZ, TEVOLA,
        TELORT, TETLWP, TETLWN, TETLKZ, TEVOLU, TEDART, TEPRPL, TEVTLI,
        TEKTTR, TEHPGR, TEWKPZ, TEPPKZ, TEVSKZ, TEGWRE, TEGUZM, TEGUDM,
        TEBESC, TEBREI, TESTDV, TEBSEI, TESAQK, TEKAFE, TEBLAT, TELBQM,
        TEVODI, TEKLSP, TEINHP, TEGNPA, TEGFGN, TEGFGS, TEHOHE, TEFREX,
        dec(0,00, 03, 0) LFVSTA, dec(0,00, 04, 0) IOQ, char(' ', 3)
        TEEWTART, zoned( 0, 8) LFVOBU, zoned( 0, 8) LFBIBU,
        char(' ', 10) TEEWPACD,char(' ', 04) TEEWPRGR,
        TESTLF LFKOLF
        FROM teil01
        WHERE TEFIRM ='01' and tetest not in ('81', '90');
       //Montag 06:00
       //SELECT TPTCDE, TPTTXT FROM trtp01 WHERE TPFIRM = '01' and TPTART'
       //='$$TEEWPRGR' and TPTFLG = 0                                    '
       //
       //SELECT SYTPTCDE ,SYTPTTXT FROM sytp01 WHERE SYTPFIRM = '01' and
       //SYTPTART ='$$PAC' and SYTPTFLG = 0

       //Abfrage auf Auftragsbestand nicht weiter verfolgen
       //bei Auslaufartikeln! Damit könnten Stammdaten fehlen!
       // or (tetest ='80' and  tetenr in
       //    (select aptenr from afpo where APAFST = '17'));
       //Achtung 21.03.2023 status 80 integrieren
       // alt: WHERE TEFIRM ='01' and tetest not in ('80', '81', '90');

       //Achtung 21.07.2023 geändert auf Stamm-LF #INC-259065
       // TELFNR             ITEMMASTER         Lieferanten-Nr
       // TESTLF             ITEMMASTER         Stamm-LF
       exec sql
        update tvrelwaeco/ITEMMASTER a set a.LFVSTA =
        (select b.LFVSTA from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TESTLF)
        where exists
        (select b.LFVSTA from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TESTLF);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.TEEWTART =
        (select b.TEEWTART from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR)
        where exists
        (select b.TEEWTART from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.TEEWPACD =
        (select b.TEEWPACD from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR)
        where exists
        (select b.TEEWPACD from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.TEEWPRGR =
        (select b.TEEWPRGR from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR)
        where exists
        (select b.TEEWPRGR from teew01 b where
         b.teewFIRM=a.tefirm and b.teewTenr=a.TETENR);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.LFVOBU =
        (select b.LFVOBU from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TELFNR)
        where exists
        (select b.LFVOBU from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TELFNR);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.LFVOBU =
        19010101 where a.LFVOBU = 0;

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.LFBIBU =
        (select b.LFBIBU from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TELFNR)
        where exists
        (select b.LFBIBU from LIEF01 b where
         b.LFFIRM=a.tefirm and b.lfLFNR=a.TELFNR);

       exec sql
        update tvrelwaeco/ITEMMASTER a set a.LFBIBU =
        19010101 where a.LFBIBU = 0;

       exec sql
        update tvrelwaeco/ITEMMASTER
          set IOQ=1;

       //Konditionslieferant Dometic Impex Co.
         exec sql
         update TVRELWAECO/itemmaster a set a.LFKOLF =
         (select b.LFKOLF from TVPFTEST/lief01 b
         where b.lffirm='01' and b.LFKOLF ='90733'
               and a.LFKOLF = b.LFLFNR)
         where exists
         (select b.LFKOLF from TVPFTEST/lief01 b
         where b.lffirm='01' and b.LFKOLF ='90733'
               and a.LFKOLF = b.LFLFNR);

       //for INVENTORY, Inventory data (SKU, Onhand, Non-allocated Qty)
       //exec sql
       // insert into tvrelwaeco/INVENTORY
       // SELECT DISTINCT BMIDEN,tstamp, dec(sum(bmbmen), 13, 2) onhand
       // ,dec(0,00, 13, 2) reserved, dec(0,00, 13, 2) available FROM
       // pbestlo# WHERE tstamp > '2018-01-01-00.00.00.000001' GROUP BY
       // bmiden, tstamp;


       //alle basierend auf itemmaster(hat alle!!)
       //SELECT DISTINCT LBBSLANR, LBBSTENR,decimal(sum(LBBSLAGB ), 13, 2)
       //amount FROM LBBs a, lbsd b WHERE LBBSFIRM='01' and (LBBSLANR in
       //('001', '001','100', '110', '094', '095', '096', '200') or
       //substr(LBBSLANR, 1, 1)='7') GROUP BY LBBSLANR, LBBSTENR
       //*
       //exec sql
       // insert into tvrelwaeco/INVENTORY
       // SELECT DISTINCT tetenr, dec(sum(bmbmen),
       // 13, 2) onhand ,dec(0,00, 13, 2) reserved, dec(0,00, 13, 2)
       // available, current timestamp tstamp
       // FROM tvrelwaeco/ITEMMASTER FULL OUTER JOIN
       //      domdatv7/pbestlo on tetenr = bmiden
       //                                 GROUP BY tetenr;
       exec sql
        insert into tvrelwaeco/INVENTORY
        SELECT DISTINCT tetenr, dec(sum(LBBSLAGB)*0,
        13, 2) onhand ,dec(0,00, 13, 2) reserved, dec(0,00, 13, 2)
        available, current timestamp tstamp
        FROM tvrelwaeco/ITEMMASTER FULL OUTER JOIN
             tvpf/lbbs01           on tetenr = LBBSTENR
             GROUP BY tetenr;

       //Lager 011 additiv Rohloff 27.07.2020 wegen 590 goods in transit
       exec sql
         update INVENTORY a set onhand   =
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('001', '011', '001','100', '110', '094', '095', '096', '200') or
          substr(LBBSLANR, 1, 1)='7') GROUP BY LBBSTENR)
         where exists
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('001', '011', '001','100', '110', '094', '095', '096', '200') or
          substr(LBBSLANR, 1, 1)='7') GROUP BY LBBSTENR);

       exec sql
         update INVENTORY a set available=
         (select BESTAND  from abestand b
          where a.tetenr = b.tetenr)
         where exists
         (select BESTAND  from abestand b
          where a.tetenr = b.tetenr);


       //alle Lager beginnend mit 7** sind avalibale stock on hand
       //(Lager für OEM 794, 785, 760, 781 in jedem Fall!!! ggf. prüfen
       //ob dieses bei anderen auch zutrifft)
       //Achtung, die Regle unterstützt auch reservierungsmenge!
       //Ident-Nr     ONHAND   RESERVED   AVAILABLE   TSTAMP
       //9105330630   109,00      24,00       85,00   2019-06-11-10.36.08.543457

       exec sql
         update INVENTORY a set AVAILABLE = AVAILABLE +
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('794', '785','760', '781', '094', '095', '096', '200'))
                   GROUP BY LBBSTENR )
         where exists
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('794', '785','760', '781', '094', '095', '096', '200'))
                   GROUP BY LBBSTENR );

       exec sql
         update tvrelwaeco/inventory
         set RESERVED = ONHAND-AVAILABLE
         where onhand > 0;

       //InTransitDate (SKU, InHouseDate, Qty) - invoiced, not received
       //INTRANSIT
       //alle Lager beginnend mit 7** sind avalibale stock on hand
       //(Lager für OEM 794, 785, 760, 781 in jedem Fall!!! ggf. prüfen
       //ob dieses bei anderen auch zutrifft)



       //InTransitDate (SKU, InHouseDate, Qty) - invoiced, not received
       //INTRANSIT

       //590 goods in transit additiv 27.07.2020 Roloff
       exec sql
         insert into tvrelwaeco/BLOMGREN_1
         SELECT DISTINCT * FROM tvrelwaeco/we_check5 WHERE
         ((#LBLBLSTC = '825' and #LBLBLANR in ('500', '510' ) ) or
          (#LBLBLSTC <>'950' and #LBLBLANR in ('590'))         or
                                                     (#LBLBLSTC ='950' and
         #LBLBLANR in ('100', '110') ) and #LBLBJNAM <> 'WAIFLB' and
         #LBLBSTKZ =' ' ) ORDER BY #LBLBDAKY;

       exec sql
         update BLOMGREN_1 set #LBLBBWMG=#LBLBBWMG*-1
         where #LBLBLANR in ('100', '110');

       //590 goods in transit additiv 27.07.2020 Roloff
       exec sql
         insert into tvrelwaeco/BLOMGREN_2
         SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
         #AEWENR, #LBLBTENR ,max(#LBLBBDAT) dateinput, max(#LBLBBDAT),
         #AELFNR, dec(sum(#LBLBBWMG), 13, 2) quantity FROM BLOMGREN_1 WHERE
         ((#LBLBLSTC = '825' and #LBLBLANR in ('500', '510') ) or
          (#LBLBLSTC <>'950' and #LBLBLANR in ('590'))         or
                                                                 (#LBLBLSTC
         ='950' and #LBLBLANR in ('100', '110') ) and #LBLBJNAM <> 'WAIFLB'
         ) GROUP BY #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
         #AEWENR, #LBLBTENR,#AELFNR ORDER BY #AEWEJJ, #AEWENR;

       exec sql
         insert into tvrelwaeco/INTRANSIT
         SELECT char(rtrim(#AEBEJJ) concat rTRIM(#AEBENR), 10) PUNUMBE,
                                  #AEBEPO, #AELFNR, #LBLBTENR, DATEINPUT,
         quantity, dec(0, 08, 0) estimdate ,current timestamp tstamp FROM
         BLOMGREN_2 WHERE #AEFIRM <> ' ' and QUANTITY <> 0 and QUANTITY > 0;

       exec sql
         delete from tvrelwaeco/INTRANSIT;

       exec sql
         insert into tvrelwaeco/INTRANSIT
         SELECT char ((char(digits(aebejj)) concat (aeBENR)), 10) punumbe,
         digits(aeBEPO) line, AELFNR , AETENR, AEWEDA, AEMENG, aeweda,
         current timestamp FROM bwae WHERE aeFIRM
         ='01' and AEUWJJ =0 and AEBWLA in('500', '590', '510') and
         AEWKNR ='001';

       exec sql
        update intransit set ESTIMDATE=
        (select epbete from bbep
        where EPFIRM ='01' and PUNUMBE =
              rtrim(epBEJJ)  concat rTRIM(epBENR)  and
              #AEBEPO=dec(epBEPO))
        where exists
        (select epbete from bbep
        where EPFIRM ='01' and PUNUMBE =
              rtrim(epBEJJ)  concat rTRIM(epBENR)  and
              #AEBEPO=dec(epBEPO));


       //PURCHASEOR and not invoiced
       //11.03.2025 Stornos werden nicht berücksichtigt

       exec sql
        insert into tvrelwaeco/TMPDELIVER
        SELECT #TSTAMP #LBLBLSTC,#WE#EL, #AEFIRM, #AEBEJJ, #AEBENR,
        #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBBWMG, #LBLBTENR FROM
        datenkw/#lblb WHERE #we#el <> 0 and #TSTAMP > current date - 730 day
        and (#LBLBWKNR ='001' or #LBLBWKNR ='   ') and
        #STORNO = ' ';

       //ältere noch auszuliefende Bestellungen ermitteln (Teillieferung)
       //(BBEP01.EPMENG> BBEP01.EPGLMG ) and (BBEp01.Eptenr='9600000131');
       exec sql
        insert into tvrelwaeco/TMPDELIVE2
         SELECT DISTINCT TMPDELIVER.#AEFIRM, TMPDELIVER.#AEBEJJ,
         TMPDELIVER.#AEBENR, TMPDELIVER.#AEBEPO, TMPDELIVER.#AELFNR,
         TMPDELIVER.#LBLBTENR , BBEP01.EPMENG, BBEP01.EPGLMG,
         dec(BBEP01.EPMENG-BBEP01.EPGLMG, 13, 2) rest , current timestamp as
         tstamp FROM tvrelwaeco/TMPDELIVER, bbep01 , bbek01 WHERE
         TMPDELIVER.#AEFIRM= BBEP01.EPFIRM and TMPDELIVER.#AEBEJJ=
         BBEP01.EPBEJJ and TMPDELIVER.#AEBENR= BBEP01.EPBENR and
         TMPDELIVER.#AEBEPO= BBEP01.EPBEPO and TMPDELIVER.#AEFIRM=
         BBEk01.EkFIRM and TMPDELIVER.#AEBEJJ= BBEk01.EkBEJJ and
         TMPDELIVER.#AEBENR= BBEk01.EkBENR and BBEP01.EPBEST = '30' and
         (BBEP01.EPMENG> BBEP01.EPGLMG ) and EKWKNR='001' and epWKNR ='001';


       //diese müssen herausgenommen werden, da alle in
       //tmpdeliver  befindlichen po#s später herausgenommen werden
       exec sql
        delete   from tmpdeliver a
           where a.#AEFIRM in ( select  b.#aefirm from tmpdelive2 b
                                where   b.#AEBEJJ = a.#AEBEJJ and
                                        b.#AEBENR = a.#AEBENR and
                                        b.#AEBEPO = a.#AEBEPO );

       exec sql
        insert into tvrelwaeco/TMPframe
        SELECT EPFIRM, EPLFNR, EPBEJJ, EPBENR, EPTENR, dec(sum(epmeng), 13,
        2) epmeng, dec(count(*), 13, 0) pos FROM bbep WHERE EpFIRM ='01'
        and EPBEJJ ='2019' and epWKNR='001'
                           GROUP BY EPFIRM, EPLFNR, EPBEJJ, EPBENR, EPTENR
        HAVING count(*) > 1 ORDER BY EPFIRM, EPBEJJ, EPBENR;


       exec sql
        insert into tvrelwaeco/PURCHASEOR
        SELECT PUNUMBE,line,
             ITEM, dec((QREQUESTED/100), 13, 2) REQUESTED,
        dec((QCONFIRMED/100), 13, 2) CONFIRMED,
        dec(0, 08, 0) estimdate , dec(0, 13, 2) epmeng,
        dec(0, 13, 0) pos       ,current timestamp tstamp
        FROM sievdspm WHERE DCC ='DE411' and STATUSORD <>
        'Invoiced ' and STATUSORD <> 'Cancelled'
                    and STATUSORD <> 'Delivered' and PUNUMBE not in
        (select rtrim(#AEBEJJ) concat rTRIM(#AEBENR) from TMPDELIVER
         where line =dec( #AEBEPO )) and ITEM <>'xxxxxxxxxx';


       exec sql
        update PURCHASEOR set estimdate=
        (select epbete from bbep
        where EPFIRM ='01' and epWKNR='001' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE and
              line =dec(epBEPO))
        where exists
        (select epbete from bbep
        where EPFIRM ='01' and epWKNR='001' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE and
              line =dec(epBEPO));

       exec sql
        update PURCHASEOR a set a.epmeng   =
        (select b.epmeng from TMPframe b
        where EPFIRM ='01' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE
              and item=EPTENR)
        where exists
        (select b.epmeng from TMPframe b
        where EPFIRM ='01' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE
              and item=EPTENR);

       exec sql
        update PURCHASEOR a set a.pos      =
        (select b.pos    from TMPframe b
        where EPFIRM ='01' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE
              and item=EPTENR)
        where exists
        (select b.pos    from TMPframe b
        where EPFIRM ='01' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE
              and item=EPTENR);

       //ältere noch auszuliefende Bestellungen ermitteln (Teillieferung)
       //Korrekturen 27.05.2022
       exec sql
        update PURCHASEOR a set a.REQUESTED=
        (select b.rest      from tmpdelive2 b
        where rtrim(#aeBEJJ) concat rTRIM(#aeBENR)=PUNUMBE
              and item=#LBLBTENR  and LINE=#AEBEPO )
        where exists
        (select b.rest      from tmpdelive2 b
        where
              rtrim(#aeBEJJ) concat rTRIM(#aeBENR)=PUNUMBE
              and item=#LBLBTENR  and LINE=#AEBEPO );
       exec sql
        update PURCHASEOR a set a.CONFIRMED=
        (select b.rest      from tmpdelive2 b
        where rtrim(#aeBEJJ) concat rTRIM(#aeBENR)=PUNUMBE
              and item=#LBLBTENR  and LINE=#AEBEPO )
        where exists
        (select b.rest      from tmpdelive2 b
        where
              rtrim(#aeBEJJ) concat rTRIM(#aeBENR)=PUNUMBE
              and item=#LBLBTENR  and LINE=#AEBEPO );



       //A54 IGLOO #SR-272562  15.11.2023
       exec sql
        insert into tvrelwaeco/CUSTOMOR
        SELECT
                RTRIM(AFKO_1.AKFIRM) AS AKFIRM,
                AFKO_1.AKAFJJ AS AKAFJJ,
                RTRIM(AFKO_1.AKAFST) AS AKAFST,
                AFKO_1.AKAFNN AS AKAFNN,
                RTRIM(AFKO_1.AKAFAT) AS AKAFAT,
                RTRIM(AFKO_1.AKAFST) AS AKAFST,
                RTRIM(AFPO_1.APAFST) AS APAFST,
                RTRIM(AFPO_1.APKDNR) AS APKDNR,
                RTRIM(AFPO_1.APSABE) AS APSABE,
                RTRIM(TEIL_1.TEABC1) AS TEABC1,
                RTRIM(TEIL_1.TEPRGR) AS TEPRGR,
                RTRIM(AFPO_1.APTENR) AS APTENR,
                RTRIM(AFPO_1.APTBZ1) AS APTBZ1,
                AFPO_1.APLFTE AS APLFTE,
                RTRIM(AFKO_1.AKKOSP) AS AKKOSP,
                AFPO_1.APBSMG AS APBSMG,
                AFPO_1.APGLMG AS APGLMG,
                APBSMG - APGLMG AS CALCFIELD_1,
                RTRIM(AFPO_1.APVKGB) AS APVKGB,
                RTRIM(AFPO_1.APKDGR) AS APKDGR,
                RTRIM(AFPO_1.APVTN1) AS APVTN1,
                RTRIM(AFPO_1.APVTN2) AS APVTN2,
                RTRIM(AFPO_1.APVTN3) AS APVTN3,
                AFPO_1.APRSDA AS APRSDA,
                AFPO_1.APPREI AS APPREI,
                AFPO_1.APNESU AS APNESU,
                current timestamp tstamp
           FROM
                AFKO AS AFKO_1
           JOIN
               AFPO AS AFPO_1
                   ON (AFKO_1.AKAFJJ=AFPO_1.APAFJJ
                       AND AFKO_1.AKAFNR=AFPO_1.APAFNR
                       AND AFKO_1.AKFIRM=AFPO_1.APFIRM)
           LEFT JOIN
               TEIL AS TEIL_1
                   ON (AFPO_1.APTENR=TEIL_1.TETENR
                       AND AFPO_1.APFIRM=TEIL_1.TEFIRM)
           JOIN
               ##FIRMA AS ##FIRMA_1
                   ON (AFKO_1.AKFIRM=##FIRMA_1.FIRMA)
        WHERE (AFKO_1.AKFIRM= '01' and
               AFKO_1.AKAFAT in ('01', '08', '25', '26', '27', '28',
                                 '45', '11', '16', '20', '41', '44',
                                 '81', '17', '18', 'A02', '55', 'A55',
                                 'A54'                           ) and
                AFKO_1.AKWKNR='001'                          and
                AFPO_1.APFIRM= '01'                          and
                AFPO_1.APWKNR='001'                          and
                AFKO_1.AKFIRM= '01' and APTENR <> ' '        and
                APAFST <> '90' and APAFST <> '94'  and APAFST <> '80');

       //Konfektionsdaten zum Prüfen am ende mit einfliessen lassen
       //später integrieren Axmann 22.10.2019  300
       exec sql
          insert into CUSTOMOR
          SELECT UKFIRM,UKPPJJ,UKppst, UKPPNN ,UKPPAT, UKppst, UKppst,
          '090999    ' APKDNR,uksabe,' ' TEABC1, ' ' TEPRGR, UMKOTE,UMTBZ1,
            UKPRST ,' ' AKKOSP,UMGSMG,UMGSMG*0, UMGSMG, ' ' APVKGB, ' '
          APKDGR, ' ' APVTN1, ' ' APVTN2, ' ' APVTN3,UKPRST, 0,00 APPREI,
           0,00 APNESU, current timestamp as tstamp
                                        FROM pauk01,paum01
          WHERE UKWKNR='001' and
                ukfirm=umFIRM and UKPPJJ = umPPJJ and UKPPNR=umPPNR and
          ukfirm='01' and UKPPAT='300' and UKPRE1=0 and UKppst<>'28' and
          UKppst<'05' ORDER BY UKPPJJ, UKPPNR, UKtenr;

       //Produktion 100
       //später integrieren Axmann 22.10.2019
       exec sql
          insert into CUSTOMOR
          SELECT UKFIRM,UKPPJJ,UKppst, UKPPNN ,UKPPAT, UKppst, UKppst,
          '090999    ' APKDNR,uksabe,' ' TEABC1, ' ' TEPRGR, UMKOTE,UMTBZ1,
            UKPRST ,' ' AKKOSP,UMGSMG,UMGSMG*0, UMGSMG, ' ' APVKGB, ' '
          APKDGR, ' ' APVTN1, ' ' APVTN2, ' ' APVTN3,UKPRST, 0,00 APPREI,
           0,00 APNESU, current timestamp as tstamp
                                        FROM pauk01,paum01
          WHERE UKWKNR='001' and
                ukfirm=umFIRM and UKPPJJ = umPPJJ and UKPPNR=umPPNR and
          ukfirm='01' and UKPPAT='100' and UKPRE1=0 and UKppst<>'28' and
          UKppst<'05' ORDER BY UKPPJJ, UKPPNR, UKtenr;


       //Produktion 110
       //später integrieren Axmann 22.10.2019
       exec sql
          insert into CUSTOMOR
          SELECT UKFIRM,UKPPJJ,UKppst, UKPPNN ,UKPPAT, UKppst, UKppst,
          '090999    ' APKDNR,uksabe,' ' TEABC1, ' ' TEPRGR, UMKOTE,UMTBZ1,
            UKPRST ,' ' AKKOSP,UMGSMG,UMGSMG*0, UMGSMG, ' ' APVKGB, ' '
          APKDGR, ' ' APVTN1, ' ' APVTN2, ' ' APVTN3,UKPRST, 0,00 APPREI,
           0,00 APNESU, current timestamp as tstamp
                                        FROM pauk01,paum01
          WHERE UKWKNR='001' and
                ukfirm=umFIRM and UKPPJJ = umPPJJ and UKPPNR=umPPNR and
          ukfirm='01' and UKPPAT='110' and UKPRE1=0 and UKppst<>'28' and
          UKppst<'05' ORDER BY UKPPJJ, UKPPNR, UKtenr;



       exec sql
        insert into tvrelwaeco/SKUSUPPLIE
        SELECT
               RTRIM(TEIL_1.TEFIRM) AS TEFIRM,
               RTRIM(TEIL_1.TETENR) AS TETENR,
               RTRIM(TEIL_1.TETBZ1) AS TETBZ1,
               RTRIM(TEIL_1.TETEST) AS TETEST,
               RTRIM(TEIL_1.TEERTE) AS TEERTE,
               RTRIM(TEIL_1.TESAEK) AS TESAEK,
               RTRIM(TEIL_1.TEDIEK) AS TEDIEK,
               RTRIM(TEIL_1.TELFNR) AS TELFNR,
               RTRIM(TEIL_1.TESTLF) AS TESTLF,
               RTRIM(LIEF_1.LFLFST) AS LFLFST,
               RTRIM(LIEF_1.LFNAM1) AS LFNAM1,
               RTRIM(LIEF_1.LFPOLD) AS LFPOLD,
               RTRIM(LIEF_1.LFWORT) AS LFWORT,
               RTRIM(TEIL_1.TEPRGR) AS TEPRGR,
               RTRIM(#PRODG_1.TPTTXT) AS TPTTXT,
               RTRIM(LPIF_2.LPIDEN) AS LPIDEN,
               RTRIM(LPIF_2.LPIBZ1) AS LPIBZ1,
               RTRIM(LPIF_2.LPIBZ2) AS LPIBZ2,
               RTRIM(LPIF_2.LPSTAT) AS LPSTAT,
               current timestamp tstamp
        FROM
            TVPF/TEIL AS TEIL_1
        LEFT JOIN
            TVPF/LIEF AS LIEF_1
                ON (TEIL_1.TEFIRM=LIEF_1.LFFIRM
                    AND TEIL_1.testlf=LIEF_1.LFLFNR )
           JOIN
            #PRODG AS #PRODG_1
                ON ( TEIL_1.TEFIRM=#PRODG_1.TPFIRM
                     AND TEIL_1.TEPRGR=#PRODG_1.TPTCDE )
        LEFT JOIN
            LPIF AS LPIF_2
                ON ( TEIL_1.TEFIRM=LPIF_2.LPFIRM
                     AND TEIL_1.TETENR=LPIF_2.LPTENR )
        WHERE
                ( TEIL_1.TEFIRM= '01');

       //SELECT TPTCDE, TPTTXT FROM trtp01 WHERE TPFIRM = '01' and TPTART'
       //='$$TEEWPRGR' and TPTFLG = 0                                    '
       //
       //SELECT SYTPTCDE ,SYTPTTXT FROM sytp01 WHERE SYTPFIRM = '01' and
       //SYTPTART ='$$PAC' and SYTPTFLG = 0

       // for INVENTORY, Inventory data (SKU, Onhand, Non-allocated Qty)
       exec sql
        insert into tvrelwaeco/REP_CODES
        SELECT TPTCDE, TPTTXT, current timestamp xtimestamp FROM trtp01
        WHERE TPFIRM = '01' and TPTART ='$$TEEWPRGR' and TPTFLG = 0;
       exec sql
        insert into tvrelwaeco/REP_CODES
        SELECT SYTPTCDE ,SYTPTTXT , current timestamp xtimestamp FROM
        sytp01 WHERE SYTPFIRM = '01' and SYTPTART ='$$PAC' and SYTPTFLG = 0;


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;


       //-----------------------------------------------------------------------
       //% can Zeichen(§search) ersetzten durch(§replace) in string(§string)
       //-----------------------------------------------------------------------

       begsr scan;

       open  SKUSUPPLIE;
       read  SKUSUPPLIE  SKUSUPPLIE_i;
       dow not %eof(SKUSUPPLIE);
       //,,,
       //;
          SKUSUPPLIE_o  = SKUSUPPLIE_i;
          §search               = ';';
          §string               = SKUSUPPLIE_o.TETBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.TETBZ1   = §string;

          §search               = ';';
          §string               = SKUSUPPLIE_o.LFNAM1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LFNAM1   = §string;

          §search               = ';';
          §string               = SKUSUPPLIE_o.LPIBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ1   = §string;

          §search               = ';';
          §string               = SKUSUPPLIE_o.LPIBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ2   = §string;

          §search               = '"';
          §string               = SKUSUPPLIE_o.TETBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.TETBZ1   = §string;

       //"
          §search               = '"';
          §string               = SKUSUPPLIE_o.LFNAM1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LFNAM1   = §string;

          §search               = '"';
          §string               = SKUSUPPLIE_o.LPIBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ1   = §string;

          §search               = '"';
          §string               = SKUSUPPLIE_o.LPIBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ2   = §string;


       //"
          §search               = '"';
          §string               = SKUSUPPLIE_o.LFNAM1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LFNAM1   = §string;

          §search               = '"';
          §string               = SKUSUPPLIE_o.LPIBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ1   = §string;

          §search               = '"';
          §string               = SKUSUPPLIE_o.LPIBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          SKUSUPPLIE_o.LPIBZ2   = §string;

          update phy01r   SKUSUPPLIE_o;
          read SKUSUPPLIE SKUSUPPLIE_i;
       enddo;
       close SKUSUPPLIE;


       open  CUSTOMOR  ;
       read  CUSTOMOR    CUSTOMOR_i;
       dow not %eof(CUSTOMOR);
       //,,,
          CUSTOMOR_o    = CUSTOMOR_i;
          §search               = ';';
          §string               = CUSTOMOR_o.APTBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          CUSTOMOR_o.APTBZ1   = §string;

          §search               = '"';
          §string               = CUSTOMOR_o.APTBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          CUSTOMOR_o.APTBZ1   = §string;

          update phy02r   CUSTOMOR_o;
          read CUSTOMOR CUSTOMOR_i;
       enddo;
       close CUSTOMOR;


       open  ITEMMASTER;
       read  ITEMMASTER  ITEMMASTER_i;
       dow not %eof(ITEMMASTER);
       //,,,
          ITEMMASTER_o  = ITEMMASTER_i;
          if ITEMMASTER_o.tetenr ='8881400708';
             ITEMMASTER_o.tetenr ='8881400708';
          endif;
          ITEMMASTER_o  = ITEMMASTER_i;
          §search               = ';';
          §string               = ITEMMASTER_o.TETBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ1   = §string;

          §search               = '"';
          §string               = ITEMMASTER_o.TETBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ1   = §string;

          §search               = '"';
          §string               = ITEMMASTER_o.TETBZ1;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ1   = §string;

          §search               = ';';
          §string               = ITEMMASTER_o.TETBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ2   = §string;

          §search               = '"';
          §string               = ITEMMASTER_o.TETBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ2   = §string;

          §search               = '"';
          §string               = ITEMMASTER_o.TETBZ2;
          §replace              = ' ';
          §pos                  = 0 ;
          exsr      scanstr;
          ITEMMASTER_o.TETBZ2   = §string;

          update phy03r   ITEMMASTER_o;
          read ITEMMASTER ITEMMASTER_i;
       enddo;
       close ITEMMASTER;

       //neue Version
       exec sql
          insert into tvrelwaeco/SUPPLNRNAM
          SELECT DISTINCT TESTLF, LFNAM1
          FROM tvrelwaeco/SKUSUPPLIE;


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
       //output INTRANSIT
       // CRTPF FILE(TVRELWAECO/uebergabe) RCDLEN(1252) TEXT('transfer files')
       //-----------------------------------------------------------------------

       begsr file_out2;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'INTRANSIT' + '-'                      +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'INTRANSIT';

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

         eval p_outfil  =  'INTRANSIT';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  INVENTORY;

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

            eval p_outfil  =  'INTRANSIT';

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


            eval p_outfil  =  'INTRANSIT';

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
               eval p_outfil  =  'INTRANSIT';

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
       //output INVENTORY
       // CRTPF FILE(TVRELWAECO/uebergabe) RCDLEN(1252) TEXT('transfer files')
       //-----------------------------------------------------------------------

       begsr file_out3;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'INVENTORY' + '-'                      +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'INVENTORY';

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

         eval p_outfil  =  'INVENTORY';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  INVENTORY;

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

            eval p_outfil  =  'INVENTORY';

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


            eval p_outfil  =  'INVENTORY';

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
               eval p_outfil  =  'INVENTORY';

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
       //output PURCHASEOR
       // CRTPF FILE(TVRELWAECO/uebergabe) RCDLEN(1252) TEXT('transfer files')
       //-----------------------------------------------------------------------

       begsr file_out4;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'PURCHASEOR' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'PURCHASEOR';

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

         eval p_outfil  =  'PURCHASEOR';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  PURCHASEOR;

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

            eval p_outfil  =  'PURCHASEOR';

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


            eval p_outfil  =  'PURCHASEOR';

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
               eval p_outfil  =  'PURCHASEOR';

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
       //output CUSTOMOR
       // CRTPF FILE(TVRELWAECO/uebergabe) RCDLEN(1252) TEXT('transfer files')
       //-----------------------------------------------------------------------

       begsr file_out5;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'CUSTOMOR' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'CUSTOMOR';

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

         eval p_outfil  =  'CUSTOMOR';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  CUSTOMOR;

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

            eval p_outfil  =  'CUSTOMOR';

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


            eval p_outfil  =  'CUSTOMOR';

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
               eval p_outfil  =  'CUSTOMOR';

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
       //output SKUSUPPLIE
       //
       //-----------------------------------------------------------------------

       begsr file_out6;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'SKUSUPPLIE' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'SKUSUPPLIE';

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

         eval p_outfil  =  'SKUSUPPLIE';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  SKUSUPPLIE;

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

            eval p_outfil  =  'SKUSUPPLIE';

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


            eval p_outfil  =  'SKUSUPPLIE';

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
               eval p_outfil  =  'SKUSUPPLIE';

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
       //output SKUSUPPLIE
       //
       //-----------------------------------------------------------------------

       begsr file_out6b;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'SUPPLNRNAM' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'SUPPLNRNAM';

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

         eval p_outfil  =  'SUPPLNRNAM';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  SUPPLNRNAM;

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

            eval p_outfil  =  'SUPPLNRNAM';

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


            eval p_outfil  =  'SKUSUPPLIE';

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
               eval p_outfil  =  'SUPPLNRNAM';

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
       //output REP_CODES
       //
       //-----------------------------------------------------------------------

       begsr file_out7b;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'REP_CODES' + '-'                      +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'REP_CODES';

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

         eval p_outfil  =  'REP_CODES';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  REP_CODES;

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

            eval p_outfil  =  'REP_CODES';

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


            eval p_outfil  =  'REP_CODES';

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
               eval p_outfil  =  'REP_CODES';

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
       //output BESTANDIMP
       //
       //-----------------------------------------------------------------------

       begsr file_out7;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'BESTANDIMP' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'BESTANDIMP';

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
                'MBROPT(*REPLACE) STRDLM('''') '+
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

         eval p_outfil  =  'BESTANDIMP';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  BESTANDIMP;

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

            eval p_outfil  =  'BESTANDIMP';

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


            eval p_outfil  =  'BESTANDIMP';

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
               eval p_outfil  =  'BESTANDIMP';

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
       //output KUNDENAIMP
       //
       //-----------------------------------------------------------------------

       begsr file_out8;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'KUNDENAIMP' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'KUNDENAIMP';

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
                'MBROPT(*REPLACE) STRDLM('''') '+
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

         eval p_outfil  =  'KUNDENAIMP';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  KUNDENAIMP;

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

            eval p_outfil  =  'KUNDENAIMP';

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


            eval p_outfil  =  'KUNDENAIMP';

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
               eval p_outfil  =  'KUNDENAIMP';

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
       //output RUCKSTANDI
       //
       //-----------------------------------------------------------------------

       begsr file_out9;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'Rueckstaende01' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'RUCKSTANDI';

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
                'MBROPT(*REPLACE) STRDLM('''') '+
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

         eval p_outfil  =  'RUCKSTANDI';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  RUCKSTANDI;

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

            eval p_outfil  =  'RUCKSTANDI';

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


            eval p_outfil  =  'RUCKSTANDI';

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
               eval p_outfil  =  'RUCKSTANDI';

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
       //output ForecastI
       //
       //-----------------------------------------------------------------------

       begsr file_outX;

         clear     Wrk.var1;
         clear     status;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval  transfer =  'Forecastde01' + '-'                     +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         eval p_outfil  =  'FORECASTI';

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
                'MBROPT(*REPLACE) STRDLM('''') '+
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

         eval p_outfil  =  'FORECASTI';

         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from  FORECASTi;

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

            eval p_outfil  =  'FORECASTI';

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


            eval p_outfil  =  'FORECASTI';

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
               eval p_outfil  =  'FORECASTI';

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
       //Sicherung auf I5
       //
       //-----------------------------------------------------------------------

       begsr file_savI5;

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/itemmaster.csv'') '  +
           'DBFILE(TVRELWAECO/itemmaster) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory itemmaster             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/PURCHASEOR.csv'') '  +
           'DBFILE(TVRELWAECO/PURCHASEOR) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory PURCHASEOR             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/INTRANSIT.csv'') '  +
           'DBFILE(TVRELWAECO/INTRANSIT) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory INTRANSIT              ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/INVENTORY.csv'') '  +
           'DBFILE(TVRELWAECO/INVENTORY) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory INVENTORY              ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/CUSTOMOR.csv'') '  +
           'DBFILE(TVRELWAECO/CUSTOMOR) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory CUSTOMOR               ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/CUSTOMOR.csv'') '  +
           'DBFILE(TVRELWAECO/CUSTOMOR) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory CUSTOMOR               ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/SKUSUPPLIE.csv'') '  +
           'DBFILE(TVRELWAECO/SKUSUPPLIE) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory SKUSUPPLIE             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/REP_CODES.csv'') '  +
           'DBFILE(TVRELWAECO/REP_CODES) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory REP_CODES              ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/SUPPLNRNAM.csv'') '  +
           'DBFILE(TVRELWAECO/SUPPLNRNAM) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory SUPPLNRNAM             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/itemmaster.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory itemmaster             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/PURCHASEOR.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory PURCHASEOR             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/INTRANSIT.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory INTRANSIT              ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/INVENTORY.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory INVENTORY              ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/CUSTOMOR.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory CUSTOMOR               ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/SKUSUPPLIE.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory SKUSUPPLIE             ';
          exsr      SR_log;
       endmon;
      /End-Free

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/SUPPLNRNAM.csv'') '  +
           'USER(*PUBLIC) DTAAUT(*RWX) '  +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory SUPPLNRNAM             ';
          exsr      SR_log;
       endmon;
      /End-Free


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


