
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //      SELECT * FROM WATCHJOBS WHERE WATCHJOBS like '%$#IFBLT%' and
      //      substr(watchjobs, 151, 26) = current date
      //
      //      SELECT * FROM job_run WHERE PGM like '%WATCHLFS1%' and CD =current
      //      date
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
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
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // Lieferscheinkopf
     fwatchjobs uf   e           k disk    RENAME(watchjobs:PHY01R)
     f                                     prefix('$')
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur



      // System-Datenstruktur
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

     d watchjobs_k   E DS                  ExtName(watchjobs:*key)
     d                                     Qualified
     d watchjobs_i   E DS                  ExtName(watchjobs:*input)
     d                                     Qualified
     d watchjobs_o   E DS                  ExtName(watchjobs:*output)
     d                                     Qualified

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------
      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         500A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            520A   varying

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

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D P_INFIL         s             21A   inz
     D §RECORDS        s              7  0 inz
     D §RECORDS2       s              7  0 inz
     D §COUNTS         s              7  0 inz
     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz
     D error4          s              1a   inz
     D error5          s              1a   inz
     D Quser           s             10a   inz
     D Qjob            s             10a   inz
     D Qnumber         s              6a   inz
     D link            s             26a   inz
     D output          s              1a   inz

     d NumSysTime      s              6s 0
     Dweek             s              1s 0
      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       eval status ='Start Aufbau für WATCHLFS1 eingeleitet    ';
       exsr      SR_log;

          if Qjob  =  'b1        ';
       //for ...
             MONITOR;
             Wrk.var1 =
              'SBMJOB CMD(CALL PGM(TVRELWAECO/#IFBLT)) JOB($#IFBLT) ' +
              'JOBD(*USRPRF) JOBQ(GANG/GANG) USER(GANG) ACGCDE(*USRPRF) ' +
              'INLLIBL(TSTPGMV7 TSTCOMV7 '  +
              'TSTDATV7 MODWAOTEST VLF95DWET VLPLGUSR VLF95USR VLNABUSR27 ' +
              'TSTSRCV7 TSTHLPV7 TSTDEMV7 QPDA QTEMP TMNP TEVMFTEST ' +
              'TEVMF1 TEVMP TAMFTEST TAMP1 TVPFTEST TVPP1 TFXF DOMGENT ' +
              'DOMGEN ' +
              'TVRELWAECO SFBF SFB SASF SAS SEAXCALP MODWAOQRY QGPL '  +
              '#LIBRARY QSSP GANG DOMCOMV7 DOMDATV7 DOMDTATST)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                error1 ='1';
                status='error in command appeared: SBMJOB für $#IFBLT     ';
                exsr      SR_log;
             endmon;
          endif;

       //for ...
       MONITOR;
       Wrk.var1 =
           'RGZPFM FILE(TVRELWAECO/WATCHJOBS)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: RGZPFM                 ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'WRKACTJOB OUTPUT(*PRINT) SBS(GANG)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKACTJOB              ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CRTPF FILE(TVRELWAECO/WATCHJOBS) RCDLEN(200) TEXT(WATCHJOBS)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
       // status='error in command appeared: CRTPF                  ';
       // exsr      SR_log;
       endmon;

       //MONITOR;
       //   Wrk.var1 =
       //       'CLRPFM FILE(TVRELWAECO/WATCHJOBS)';
       //   cmd = %TrimR(Wrk.Var1);
       //   L      = %Len(Cmd);
       //   QCMDEXC(cmd: %len(cmd));
       //   on-error;
       //      status='error CLRPFM FILE(TVRELWAECO/WATCHJOBS)             ';
       //      exsr      SR_log;
       //endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPDSPAJB) TOFILE(TVRELWAECO/WATCHJOBS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CRTPF                  ';
          exsr      SR_log;
       endmon;

       §records= *zero;
       exec sql
          update WATCHJOBS set
          watchjobs = substr(WATCHJOBS, 001, 150) concat
          current timestamp where
          substr(WATCHJOBS, 150, 026) = ' ';

       exec sql
          select count(*) into :§records
          from WATCHJOBS
          WHERE ( WATCHJOBS like '%$#IFBLP%'  or
                  WATCHJOBS like '%$#IFBLT%') and
          substr(watchjobs, 151, 26) > current timestamp - 01 minutes;

       //************************************************************
       //nur msgw!! auf $#IFBLP   Produktion!
       exec sql
          select substr(WATCHJOBS, 04, 10),
                 substr(WATCHJOBS, 17, 10),
                 substr(WATCHJOBS, 29, 06) into :Qjob, :Quser, :Qnumber
          from WATCHJOBS
          WHERE WATCHJOBS like '%$#IFBLP%' and
                substr(WATCHJOBS, 116, 04) = 'MSGW' and
          substr(watchjobs, 151, 26) > current timestamp - 01 minutes;

       //und Reaktion
       if Quser <> *blank and Qjob <> *blank;
          exsr      sr_restart;
       endif;
       //************************************************************

       Quser   = *blank;
       Qjob    = *blank;
       Qnumber = *blank;
       link    = *blank;

       //************************************************************
       //nur msgw!! auf $#IFBLT   Testsystem!
       exec sql
          select substr(WATCHJOBS, 04, 10),
                 substr(WATCHJOBS, 17, 10),
                 substr(WATCHJOBS, 29, 06) into :Qjob, :Quser, :Qnumber
          from WATCHJOBS
          WHERE WATCHJOBS like '%$#IFBLT%' and
                substr(WATCHJOBS, 116, 04) = 'MSGW' and
          substr(watchjobs, 151, 26) > current timestamp - 01 minutes;

       //und Reaktion
       if Quser <> *blank and Qjob <> *blank;
          exsr      sr_restart;
       endif;

       //Erweiterung loop Situation for ==> LIVE
       //der Hauptjob läuft derzeit alle 10 Minuten
       //und produziert einen Protokollsatz
       //************************************************************
       §counts = *zero;

       exec sql
          SELECT count(*) into :§counts FROM WATCHJOBS
          WHERE date (substr(WATCHJOBS, 151, 10))= current date   and
                time (substr(WATCHJOBS, 162, 08))> current time -
                      055 minutes and
                substr(WATCHJOBS, 116, 10) = 'RUN' and
                substr(WATCHJOBS, 190, 10)<>'*looping' and
                substr(WATCHJOBS, 004, 10) = '$#IFBLP';
       // ORDER BY substr(WATCHJOBS, 001, 10),         //
       //          substr(WATCHJOBS, 151, 26);         //

       if §counts > 3;
       exec sql
          SELECT max(substr(WATCHJOBS, 04, 10)),
                 max(substr(WATCHJOBS, 17, 10)),
                 max(substr(WATCHJOBS, 29, 06)) into :Qjob, :Quser, :Qnumber
                   FROM WATCHJOBS
          WHERE date (substr(WATCHJOBS, 151, 10))= current date   and
                time (substr(WATCHJOBS, 162, 08))> current time -
                      055 minutes and
                substr(WATCHJOBS, 116, 10) = 'RUN' and
                substr(WATCHJOBS, 004, 10) = '$#IFBLP';
       //und Reaktion
          if Quser <> *blank and Qjob <> *blank;
             exsr      sr_restart;
          exec sql
             update watchjobs set watchjobs=
                    substr(WATCHJOBS, 001, 189) concat
                    '*looping'                  concat
                    substr(WATCHJOBS, 198, 003)
             WHERE date (substr(WATCHJOBS, 151, 10))= current date and
                   time (substr(WATCHJOBS, 162, 08))> current time -
                         055 minutes and
                   substr(WATCHJOBS, 116, 10) = 'RUN' and
                   substr(WATCHJOBS, 004, 10) = :Qjob     and
                   substr(WATCHJOBS, 017, 10) = :Quser    and
                   substr(WATCHJOBS, 029, 06) = :Qnumber;
          endif;

       endif;

       //Erweiterung loop Situation for ==> Test
       //der Hauptjob läuft derzeit alle 10 Minuten
       //und produziert einen Protokollsatz
       //************************************************************
       §counts = *zero;

       exec sql
          SELECT count(*) into :§counts FROM WATCHJOBS
          WHERE date (substr(WATCHJOBS, 151, 10))= current date   and
                time (substr(WATCHJOBS, 162, 08))> current time -
                      055 minutes and
                substr(WATCHJOBS, 116, 10) = 'RUN' and
                substr(WATCHJOBS, 190, 10)<>'*looping' and
                substr(WATCHJOBS, 004, 10) = '$#IFBLT';
       // ORDER BY substr(WATCHJOBS, 001, 10),         //
       //          substr(WATCHJOBS, 151, 26);         //

       if §counts > 3;
       exec sql
          SELECT max(substr(WATCHJOBS, 04, 10)),
                 max(substr(WATCHJOBS, 17, 10)),
                 max(substr(WATCHJOBS, 29, 06)) into :Qjob, :Quser, :Qnumber
                   FROM WATCHJOBS
          WHERE date (substr(WATCHJOBS, 151, 10))= current date   and
                time (substr(WATCHJOBS, 162, 08))> current time -
                      055 minutes and
                substr(WATCHJOBS, 116, 10) = 'RUN' and
                substr(WATCHJOBS, 004, 10) = '$#IFBLT';
       //und Reaktion
          if Quser <> *blank and Qjob <> *blank;
             exsr      sr_restart;
          exec sql
             update watchjobs set watchjobs=
                    substr(WATCHJOBS, 001, 189) concat
                    '*looping'                  concat
                    substr(WATCHJOBS, 198, 003)
             WHERE date (substr(WATCHJOBS, 151, 10))= current date and
                   time (substr(WATCHJOBS, 162, 08))> current time -
                         055 minutes and
                   substr(WATCHJOBS, 116, 10) = 'RUN' and
                   substr(WATCHJOBS, 004, 10) = :Qjob     and
                   substr(WATCHJOBS, 017, 10) = :Quser    and
                   substr(WATCHJOBS, 029, 06) = :Qnumber;
          endif;

       endif;

       //************************************************************

       //Protokolldaten
       open  watchjobs;

       read watchjobs   watchjobs_i;
       dow not %eof(watchjobs);
          watchjobs_o   = watchjobs_i;
       //,,,
          if  %subst(watchjobs_o: 004: 10) = '$#IFBLP   ' or
              %subst(watchjobs_o: 004: 10) = '$#IFBLT   ';
              if %subst(watchjobs_i: 116: 04) = 'MSGW';
                 if %subst(watchjobs_o: 190: 08) = '        ';
                     %subst(watchjobs_o: 190: 08) = '*deleted';
                     update phy01r   watchjobs_o;
                     output = '1';
                 endif;
              else;
                 if %subst(watchjobs_o: 190: 08) = '        ';
                     %subst(watchjobs_o: 190: 08) = '*ok     ';
                     update phy01r   watchjobs_o;
                     output = '1';
                 endif;
              endif;
          else;
              delete watchjobs;
          endif;
          read watchjobs   watchjobs_i;
       enddo;

       close watchjobs;

       if output = '1';
          exsr SR_output;
       endif;

       //Protokoll aktive Sätze verfolgen
       NumSysTime = %Dec(%Time(): *ISO);

       exec sql
         select  dec(DAYOFWEEK_iso(current date ), 1, 0)
                 into            :week
                 from   qsys2/qsqptabl;

       //Mon-Frei von 07:31:00 - 21:00:00 IFBL-Übergabe
       if week < 6  and NumSysTime > 073100
                    and NumSysTime < 210000;
       // exsr sr_IFBL01;
       endif;
       //Mon-Frei von 09:01:00 - 19:05:00 Auftragsübergabe Orderh
       if week < 6  and NumSysTime > 080100
                    and NumSysTime < 190500;
       // exsr sr_orderh;
       endif;
       //Samstag  von 07:31:00 - 19:00:00 IFBL-Übergabe
       if week = 6  and NumSysTime > 073100
                    and NumSysTime < 190000;
       // exsr sr_IFBL01;
       endif;

       exec sql
          delete
          from WATCHJOBS
          WHERE ( WATCHJOBS like '%$#IFBLP%'  or
                  WATCHJOBS like '%$#IFBLT%') and
          substr(watchjobs, 151, 26) < current timestamp -   1 day
               and substr(watchjobs, 190, 08) = '*ok     ';

       eval status ='Ende Aufbau für WATCHLFS1  eingeleitet    ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //break and restart reaction cases
       //-----------------------------------------------------------------------

       begsr sr_restart;

          link = qnumber + '/' + %trimr(quser) + '/' + %trimr(qjob);

       //for ...
          MONITOR;
          Wrk.var1 =
              'DSPJOBLOG JOB(' + %trimr(LINK) +') ' +
              'OUTPUT(*PRINT)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             error1 ='1';
             status='error in command appeared: DSPJOBLOG              ';
             exsr      SR_log;
          endmon;

       //for ...
          MONITOR;
          Wrk.var1 =
              'ENDJOB JOB(' + %trimr(LINK) +') OPTION(*IMMED)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             error1 ='1';
             status='error in command appeared: ENDJOB                 ';
             exsr      SR_log;
          endmon;

       //for ...
          MONITOR;
          Wrk.var1 =
              'DLYJOB DLY(25)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             error1 ='1';
             status='error in command appeared: DLYJOB                 ';
             exsr      SR_log;
          endmon;

       //hier Testsystem, wenn das geprüft werden sollte
       //hier WRKOBJ OBJ(*ALL/CTST*) OBJTYPE(*LIB)
       //hier Testsystem, wenn das geprüft werden sollte
          if Qjob  =  '$#IFBLT   ';
       //for ...
             MONITOR;
             Wrk.var1 =
              'SBMJOB CMD(CALL PGM(TVRELWAECO/#IFBLT)) JOB($#IFBLT) ' +
              'JOBD(*USRPRF) JOBQ(GANG/GANG) USER(GANG) ACGCDE(*USRPRF) ' +
              'INLLIBL(TSTPGMV7 TSTCOMV7 '  +
              'TSTDATV7 MODWAOTEST VLF95DWET VLPLGUSR VLF95USR VLNABUSR27 ' +
              'TSTSRCV7 TSTHLPV7 TSTDEMV7 QPDA QTEMP TMNP TEVMFTEST ' +
              'TEVMF1 TEVMP TAMFTEST TAMP1 TVPFTEST TVPP1 TFXF DOMGENT ' +
              'DOMGEN ' +
              'TVRELWAECO SFBF SFB SASF SAS SEAXCALP MODWAOQRY QGPL '  +
              '#LIBRARY QSSP GANG DOMCOMV7 DOMDATV7 DOMDTATST)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                error1 ='1';
                status='error in command appeared: SBMJOB für $#IFBLT     ';
                exsr      SR_log;
             endmon;
          endif;

       //hier LIVeSystem, wenn das geprüft werden sollte
          if Qjob  =  '$#IFBLP   ';
       //for ...
             MONITOR;
             Wrk.var1 =
              'SBMJOB CMD(CALL PGM(TVRELWAECO/#IFBL)) JOB($#IFBLP) ' +
              'JOBD(*USRPRF) JOBQ(GANG/GANG) USER(GANG) ACGCDE(*USRPRF) ' +
              'INLLIBL(QPDA TMNP MODWAO TEVMF TEVMP TAMF TAMP TVPF ' +
              'TVPP SEAXCALP TVRELWAECO DOMDTAPRD EDIFACT SASF SAS ' +
              'SFBF SFB SFBA QGPL GANG DOMCOMV7 DOMGEN)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                error1 ='1';
                status='error in command appeared: SBMJOB für $#IFBLP     ';
                exsr      SR_log;
             endmon;
          endif;

       endsr;


       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'WATCHLFS_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WATCHJOBS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Rhenania/WATCHLFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/WATCHLFS_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/WATCHLFS_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WATCHLFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WATCHLFS)      ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WATCHLFS)     ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/IT/WATCHLFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /IR/WATCHLFS_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /IT/WATCHLFS_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/IT/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WATCHLFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'WATCHJOBS';

       endsr;


       //-----------------------------------------------------------------------
       //space watchdog  sr_space inaktiv in spool übernehmen
       //-----------------------------------------------------------------------

       begsr sr_space;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CRTPF FILE(TVRELWAECO/WATCHSPACE) RCDLEN(200) TEXT(WATCHSPACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
       // status='error in command appeared: CRTPF                  ';
       // exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPEZDISK) TOFILE(TVRELWAECO/WATCHSPACE) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CRTPF                  ';
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

       //-----------------------------------------------------------------------
       //log report alert Aktualisierung IFBL01 findet statt ???
       //SELECT 'DAYS:' as Days, (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26))))*1440) Tage,
       //'MINUTES:' as MINUTES,
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) Minuten,
       //CTSTAMP,JOBDESC FROM job_run WHERE PGM ='IFBL01    ' and
       //substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //
       //SELECT 'MINU:' as MINU, (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440 Tage,
       //
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) Minuten,
       //CTSTAMP,JOBDESC FROM job_run WHERE PGM ='IFBL01    ' and
       //substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //SELECT 'inaktiv in Minuten für: ' concat substr(JOBDESC, 4, 40)
       //as letzte_Uebergabe,                  (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440      +
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) inaktiv_Minuten,
       //CTSTAMP as letzte_Zeitmessung FROM job_run WHERE PGM ='IFBL01    '
       //and substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //
       //
       //
       //
       //
       //                    SELECT 'ORDERH    ' as pgm, current timestamp,
       //current date, current time,
       //'0  ',
       //max(H370) FROM orderh WHERE h330='HDXORDER' and H350 ='10'
       //
       //Fehler Konzept
       //update        ifbl01 set IFBLSTAT ='50'
       //WHERE IFBLDANA ='LGWE' and IFBLSTAT ='00'
       //294 Zeilen in IFBL01 in TVPF aktualisiert.
       //
       //
       //
       //-----------------------------------------------------------------------

       begsr sr_IFBL01;
       //...
       exec sql
          update  job_run set jobdesc='1' concat substr(jobdesc, 2, 127)
          where pgm='IFBL01    '   and   substr(JOBDESC, 1, 1 ) ='0';

       exec sql
          insert into job_run SELECT 'IFBL01    ' as pgm, current timestamp,
          current date, current time,
          '0  ' concat  IFBLDANA concat IFBLSTAT concat '  ' concat
          max(IFBLTSTP) FROM ifbl01 WHERE IFBLSTAT='90' or IFBLSTAT='90'
          GROUP BY IFBLDANA, IFBLSTAT ORDER BY IFBLDANA,IFBLSTAT;

       exec sql
          insert into job_run SELECT 'IFBL01    ' as pgm, current timestamp,
          current date, current time,
          '0  ' concat  IFBLDANA concat IFBLSTAT concat '  ' concat
          min(IFBLTSTP) FROM ifbl01 WHERE IFBLSTAT='00' or IFBLSTAT='00'
          GROUP BY IFBLDANA, IFBLSTAT ORDER BY IFBLDANA,IFBLSTAT;

       ///2079770
       //exec sql
       // insert into job_run SELECT 'IFBL01    ' as pgm, current timestamp,
       // current date, current time,
       // '0  ' concat  IFBLDANA concat IFBLSTAT concat '  ' concat
       // min(IFBLTSTP) FROM ifbl01 WHERE IFBLSTAT='00' or IFBLSTAT='00'
       // GROUP BY IFBLDANA, IFBLSTAT ORDER BY IFBLDANA,IFBLSTAT;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/LFS_VERZUG)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/lfs_verzug)            ';
               exsr      SR_log;
         endmon;

       //log report alert Aktualisierung IFBL01 findet statt ???
       //wird eigentlich nicht gebraucht!
       //exec sql
       // insert into lfs_verzug
       // SELECT 'DAYS:' as Days, (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26))))*1440) Tage,
       // 'MINUTES:' as MINUTES,
       // (
       // (hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       // 26))))) *60 ) + ((minute(time(CTSTAMP)) -
       // minute(time(timestamp(substr(JOBDESC, 18, 26)))))) Minuten,
       // CTSTAMP,JOBDESC FROM job_run WHERE PGM ='IFBL01    ' and
       // substr(jobdesc, 01, 01)='0' and
       // (substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       //  days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       // ((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       // 26))))) *60 ) + ((minute(time(CTSTAMP)) -
       // minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          );

       //...
       //> 60 Minuten Meldung WATCHLFS1# Achtung nur AFKM
       exec sql
          insert into job_run
          SELECT 'WATCHLFS1#',current timestamp,
                              current date, current time,
                 'inaktiv in Minuten für: ' concat substr(JOBDESC, 4, 40)
          concat '  ==>  ' concat            char(((days(date(CTSTAMP)) -
          days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440      +
          (
          (hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 18, 26))))))))  concat '  '
          concat CTSTAMP as letzte_Zeitmessung FROM job_run
          WHERE PGM ='IFBL01    ' and substr(jobdesc, 01, 01)='0' and
          ( JOBDESC like '%AFKM%'or JOBDESC like '%AFKM%')        and
          (substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
           days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
          ((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 18, 26))))))>60          );

       //...
       //> 105 Minuten Meldung WATCHLFS1# Achtung nur BWAE
       exec sql
          insert into job_run
          SELECT 'WATCHLFS1#',current timestamp,
                              current date, current time,
                 'inaktiv in Minuten für: ' concat substr(JOBDESC, 4, 40)
          concat '  ==>  ' concat            char(((days(date(CTSTAMP)) -
          days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440      +
          (
          (hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 18, 26))))))))  concat '  '
          concat CTSTAMP as letzte_Zeitmessung FROM job_run
          WHERE PGM ='IFBL01    ' and substr(jobdesc, 01, 01)='0' and
          ( JOBDESC like '%BWAE%'or JOBDESC like '%BWAE%')        and
          (substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
           days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
          ((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 18, 26))))))>105         );

       §records2= *zero;

       exec sql
          select count(*) into :§records2
                 FROM job_run WHERE PGM ='WATCHLFS1#'
                 and CTSTAMP > current timestamp - 01  minutes;
       if §records2 > *zero;
       //...
          MONITOR;
          Wrk.var1 =
              'OVRPRTF FILE(QPQXPRTF) '  +
              'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
              'PAGESIZE(*N 132) '  +
              'FORMTYPE(''LFS_VERZUG'') OVRSCOPE(*JOB)';
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
          clear p_md;
           eval p_md      =  §§§PGM         +
                             §§§JOB         +
                             §§§USR         +
                             status;

           eval p_msg     =  '#AL0006';
           eval p_msgf    =  *blank;
           eval p_print   =  'PRT55';
           eval p_outfil  =  ' ';
           eval p_lib     =  ' ';
           eval p_repadd  =  ' ';

           callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                          p_outfil: p_lib:    p_repadd);
           clear status;
       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       MONITOR;
          Wrk.var1 =
              'DLTOVR FILE(QPQXPRTF) LVL(*JOB)        ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error DLTOVR FILE(QPQXPRTF) LVL(*JOB)           ';
             exsr      SR_log;
       endmon;
       endif;

       endsr;


       //-----------------------------------------------------------------------
       //log report alert Aktualisierung IFBL01 findet statt ???
       //SELECT 'DAYS:' as Days, (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26))))*1440) Tage,
       //'MINUTES:' as MINUTES,
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) Minuten,
       //CTSTAMP,JOBDESC FROM job_run WHERE PGM ='IFBL01    ' and
       //substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //
       //SELECT 'MINU:' as MINU, (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440 Tage,
       //
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) Minuten,
       //CTSTAMP,JOBDESC FROM job_run WHERE PGM ='IFBL01    ' and
       //substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //SELECT 'inaktiv in Minuten für: ' concat substr(JOBDESC, 4, 40)
       //as letzte_Uebergabe,                  (days(date(CTSTAMP)) -
       //days(date(timestamp(substr(JOBDESC, 18, 26)))))*1440      +
       //(
       //(hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26)))))) inaktiv_Minuten,
       //CTSTAMP as letzte_Zeitmessung FROM job_run WHERE PGM ='IFBL01    '
       //and substr(jobdesc, 01, 01)='0' and
       //(substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
       // days(date(timestamp(substr(JOBDESC, 18, 26)))))>0 or
       //((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 18,
       //26))))) *60 ) + ((minute(time(CTSTAMP)) -
       //minute(time(timestamp(substr(JOBDESC, 18, 26))))))>30          )
       //
       //
       //
       //
       //
       //
       //                    SELECT 'ORDERH    ' as pgm, current timestamp,
       //current date, current time,
       //'0  ',
       //max(H370) FROM orderh WHERE h330='HDXORDER' and H350 ='10'
       //
       //
       //
       //-----------------------------------------------------------------------

       begsr sr_orderh;
       //...
       exec sql
          update  job_run set jobdesc='1' concat substr(jobdesc, 2, 127)
          where pgm='ORDERH    '   and   substr(JOBDESC, 1, 1 ) ='0';

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' HDXORDER ' concat
          max(H370) FROM orderh WHERE h330='HDXORDER' and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' TECCOM   ' concat
          max(H370) FROM orderh WHERE h330='TECCOM  ' and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' FRANCE   ' concat
          max(H370) FROM orderh WHERE H030 =88505     and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' GreatBri ' concat
          max(H370) FROM orderh WHERE H030 =40631     and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' Italy    ' concat
          max(H370) FROM orderh WHERE H030 =55278     and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' Siegen   ' concat
          max(H370) FROM orderh WHERE H030 =98264     and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' Sweden   ' concat
          max(H370) FROM orderh WHERE H030 = 8138     and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       exec sql
          insert into job_run SELECT 'ORDERH    ' as pgm, current timestamp,
          current date, current time,
          '0 ' concat ' Poland   ' concat
          max(H370) FROM orderh WHERE H030 = 78678    and (H350 ='10' or
                                H350 ='  ' or H350 ='00');

       //...
       //> 75 Minuten Meldung WATCHLFS1$
       exec sql
          insert into job_run
          SELECT 'WATCHLFS1$',current timestamp,
                              current date, current time,
                 'inaktiv in Minuten für: ' concat substr(JOBDESC, 4, 40)
          concat '  ==>  ' concat            char(((days(date(CTSTAMP)) -
          days(date(timestamp(substr(JOBDESC, 13, 26)))))*1440      +
          (
          (hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 13,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 13, 26))))))))  concat '  '
          concat CTSTAMP as letzte_Zeitmessung FROM job_run
          WHERE PGM ='ORDERH    ' and substr(jobdesc, 01, 01)='0' and
          (substr(jobdesc, 01, 01)='0' and (days(date(CTSTAMP)) -
           days(date(timestamp(substr(JOBDESC, 13, 26)))))>0 or
          ((hour(time(CTSTAMP)) - hour(time(timestamp(substr(JOBDESC, 13,
          26))))) *60 ) + ((minute(time(CTSTAMP)) -
          minute(time(timestamp(substr(JOBDESC, 13, 26))))))>75          );

       §records2= *zero;

       exec sql
          select count(*) into :§records2
                 FROM job_run WHERE PGM ='WATCHLFS1$'
                 and CTSTAMP > current timestamp - 01  minutes;
       if §records2 > *zero;
       //...
          MONITOR;
          Wrk.var1 =
              'OVRPRTF FILE(QPQXPRTF) '  +
              'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
              'PAGESIZE(*N 132) '  +
              'FORMTYPE(''ORDERH    '') OVRSCOPE(*JOB)';
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
          clear p_md;
           eval p_md      =  §§§PGM         +
                             §§§JOB         +
                             §§§USR         +
                             status;

           eval p_msg     =  '#AL0007';
           eval p_msgf    =  *blank;
           eval p_print   =  'PRT55';
           eval p_outfil  =  ' ';
           eval p_lib     =  ' ';
           eval p_repadd  =  ' ';

           callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                          p_outfil: p_lib:    p_repadd);
           clear status;
       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       MONITOR;
          Wrk.var1 =
              'DLTOVR FILE(QPQXPRTF) LVL(*JOB)        ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error DLTOVR FILE(QPQXPRTF) LVL(*JOB)           ';
             exsr      SR_log;
       endmon;
       endif;

       endsr;
