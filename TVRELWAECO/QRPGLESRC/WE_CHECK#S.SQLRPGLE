     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
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
       //           ... Grunddaten

      //------------------------------------------------------------------------
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

     D §records        s              9s 0 inz

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

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z
     Doutbound         S              1a

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D info            DS
     D  infox                  1     50
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________


     D*
     I*-------------------------------------------------------------------------
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
      /FREE
                         Exsr      sr_log;
                         exsr      sr1000;
                         exsr      SR_report;
                         Exsr      sr_log;

                         EXSR      RETURN;

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/WE_CHECK';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='WE_CHECK konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/WE_CHECK_1';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='WE_CHECK_1 konnte nicht gelöscht werden        ';
          exsr      SR_log;
       endmon;
      /End-Free



     c                   if        outbound =  '1'
     c                   goto      ##1000
     c                   endif
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*1) Hauptdatei WE's  SSDTDI, SSTIDI  first write
     C*                      ____,   ____  first write
       exec sql
        insert into tvrelwaeco/we_check
        SELECT SSKONZ, SSFIRM, SSSST, SSLFDN, SSIDEN, SSBST1, SSBSTP,
        SSLIEF, SSWENR, SSWEPO, SSLSNR, SSLSNP, SSBSTM , SSQKZ, SSQSTA,
        SSQCHR, SSDTEE, SSDTZU, SSLM, SSBART, SSDTBU, SSTIBU, SSDTDI,
        SSTIDI, SSDTDU, SSTIDU ,
        SSDTDI, SSTIDI, char(' ', 1) status,
        zoned(0, 8, 0) TPDTPP, zoned(0, 6, 0) TPTIPP,
        zoned(0, 8, 0) TPDTEE, zoned(0, 8, 0) TPDTZU,
        zoned(0, 8, 0) tpdte, zoned(0, 8, 0) tptie,
        zoned(0, 8, 0) TPDTDI, zoned(0, 12, 0) TPTIDI,
        zoned(0, 8, 0) workdays,
        current timestamp tstamp FROM
        domdatv7/PBESTSS WHERE SSSST =110 or SSSST =115;

       //_offene WE's ermittel aus domdatv7/PBESTTP aus Transportaufträgen_
       exec sql
        update tvrelwaeco/we_check a set status = '1'
        where ssbst1 in (select tpbst1 from domdatv7/PBESTTP
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115'));

       //_TPDTPP___________________________________________________________
       exec sql
        update we_check a set a.TPDTPP =
        (select max(b.TPDTPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);

       //_TPTIPP___________________________________________________________
       exec sql
        update we_check a set a.TPTIPP =
        (select max(b.TPTIPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIPP) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTEE___________________________________________________________
       exec sql
        update we_check a set a.TPDTEE =
        (select max(b.TPDTEE) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTEE) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPDTDI___________________________________________________________
       exec sql
        update we_check a set a.TPDTDI =
        (select max(b.TPDTDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //_TPTIDI___________________________________________________________
       exec sql
        update we_check a set a.TPTIDI =
        (select max(b.TPTIDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIDI) from domdatv7/PBESTTP b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       //3.) integration  Lagerbewegungen__________________________________

       exec sql
        update we_check a set status = '2'
        where ssbst1 in (select bmbst1 from domdatv7/pbestlo
              where  SSBST1=bmBST1 and SSBSTP=bmBSTP and
                     SSWENR=bmwenr and sswepo=bmwepo and
                     SSKONZ=bmKONZ and SSFIRM=bmFIRM and status=' ');

       //__________Historie________________________________________________
       //__________________________________________________________________
       //offene WE's ermittel aus domdatv7/phisttp aus Transportaufträgen__
       exec sql
        update tvrelwaeco/we_check a set status = '3'
        where ssbst1 in (select tpbst1 from domdatv7/phisttp
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115'));

     //_TPDTPP___________________________________________________________
       exec sql
        update we_check a set a.TPDTPP =
        (select max(b.TPDTPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);

     //_TPTIPP___________________________________________________________
       exec sql
        update we_check a set a.TPTIPP =
        (select max(b.TPTIPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIPP) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


     //_TPDTEE___________________________________________________________
       exec sql
        update we_check a set a.TPDTEE =
        (select max(b.TPDTEE) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTEE) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


     //_tpdte _________Prüffeld_nur in Historie__________________________
       exec sql
        update we_check a set a.tpdte  =
        (select max(b.tpdte)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.tpdte)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


     //_tptie _________Prüffeld_nur in Historie__________________________
       exec sql
        update we_check a set a.tptie  =
        (select max(b.tptie)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.tptie)  from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       _TPDTDI___________________________________________________________
       exec sql
        update we_check a set a.TPDTDI =
        (select max(b.TPDTDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPDTDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       _TPTIDI___________________________________________________________
       exec sql
        update we_check a set a.TPTIDI =
        (select max(b.TPTIDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm)
        where exists
        (select max(b.TPTIDI) from domdatv7/phisttp b
              where  SSBST1=tpBST1 and SSBSTP=tpBSTP and
                     SSWENR=tpwenr and sswepo=tpwepo and
                     SSKONZ=tpKONZ and SSFIRM=tpFIRM and
                     (TPVSST ='110' or TPVSST ='115')
        group by tpbst1, tpbstp,tpwenr,tpwepo,tpkonz,tpfirm);


       _Berechnung Zeit__________________________________________________
       exec sql
        update we_check set workdays =
        (days (date(substr(tpdte , 1, 4)
        concat '-' concat substr(tpdte , 5, 2) concat '-' concat
        substr(tpdte , 7, 2)))
        -
        (days( date(substr(SSDTDI, 1, 4) concat
        '-' concat substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7,
        2))))) WHERE TPDTE <> 0;

       _Gruppierung______________________________________________________
       exec sql
        insert into tvrelwaeco/we_check_1
        SELECT
        SSSST,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2)))
        inpd, workdays, status, decimal((count(*)), 5, 0) rate,
        decimal(0, 5, 0) daytotal, decimal(0, 5, 0) daydone,
        decimal(0, 5, 0) freeday
        FROM we_check GROUP BY SSSST ,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))),
        workdays, status
        ORDER BY  SSSST ,
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))),
        workdays, status;

       _Gruppierung______________________________________________________
       exec sql
        update we_check_1 a set daytotal =
        (select count(*)      from tvrelwaeco/we_check b where
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))
        = inpd) and a.SSSST = b.SSSST)
        where exists
        (select count(*)      from tvrelwaeco/we_check b where
        ( date(substr(SSDTDI, 1, 4) concat '-' concat
        substr(SSDTDI, 5, 2) concat '-' concat substr(SSDTDI, 7, 2))
        = inpd) and a.SSSST = b.SSSST);

           ##1000        ENDSR

       //-----------------------------------------------------------------------
       //report customer
       //-----------------------------------------------------------------------

       begsr SR_report;

         eval p_infil   =  'WE_CHECK' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WE_CHECK';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/WE_CHECK*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'WE_CHECK';

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
          status='Error by CVTDBF object WE_CHECK                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECK';

       eval p_outfil  =  'WE_CHECK_1';

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
          status='Error by CVTDBF object WE_CHECK_1                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'WE_CHECK';

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''WE_CHECK'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'WE_CHECK';

       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
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

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C*.
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

      /FREE
       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'RPMSALESM2';
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

      /end-FREE


     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
