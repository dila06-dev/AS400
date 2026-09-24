
      //************************************************************************
      //
      //      Programmname       LFS_SEGM
      //      Erstellt  am       30.08.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung
      //    ... status 1 Segmentierung mit Artikelzuordnung
      //    ... status 2 Segmentierungen freie ohne Artikelzuordnung
      //    ... status 3 ohne Segmentierung, aber definierte Bereiche
      //    ... status X zugeordnete aktuelle Bestandsdaten
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
      //
      // wenn Sätzte fehlen oft dann:
      //
      // Referenzsatz
      //
      //
      // (
      //
      //
      //
      //
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
     h dftactgrp(*NO) actgrp(*CALLER)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     flfs_perforuf   e             DISK    RENAME(lfs_perfor:PHY01R)
     f                                     USROPN

     flfs_perfoluf   e           K DISK    RENAME(lfs_perfor:LOG01R)
     f                                     USROPN

     fpbfstss   uf   e           K DISK    RENAME(pbfstssf:LOG03R)
     f
     fteil01    uf   e           K DISK    RENAME(teil1:LOG04R)
     f
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


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d lfs_perfor_i  E DS                  ExtName(lfs_perfor:*input)
     d                                     Qualified

     d lfs_perfor_o  E DS                  ExtName(lfs_perfor:*output)
     d                                     Qualified

     d lfs_perfol_k  E DS                  ExtName(lfs_perfol:*key)
     d                                     Qualified

     d lfs_perfol_i  E DS                  ExtName(lfs_perfol:*input)
     d                                     Qualified

     d lfs_perfol_o  E DS                  ExtName(lfs_perfol:*output)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified

     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D err_msg         s              1a   inz
     D #error          s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0
     d nowdate         s              8s 0
     DGoodDateV        S              1a
     DGoodDateB        S              1a
     D#ERRORS          s             60a
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     D p_inFIL         s             24a
     D §x              s              3s 0 inz
     D §item           s             28a   inz

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz

      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________
     IPHY01R
     I              status                      §status

     ILOG01R
     I              status                      §status

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start LFS_Optimierungen                   ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

       if §records <> *zero;
          exsr      SR_request;
          exsr      SR_report;
          exsr      SR_report2;
       endif;

       endif;

       // ______________________________________________________________________

       eval status ='Ende  LFS_SEGM                          ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei KPIF
       //-----------------------------------------------------------------------

       begsr srinit;

       err_msg   = '1';

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_SEGM) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_SEGM)             ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_DUPLI) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_DUPLI)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_PERFOR)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_PERFOR)           ';
             exsr      SR_log;
       endmon;

       //      1. current situation TVRELWAECO/LFS_SEGM Segmentierung
       //         aus domdatv7/PLPSKOP
       //         ==> status 1
       exec sql
         insert into TVRELWAECO/LFS_SEGM
         SELECT LKKONZ, LKFIRM, LKORT, LKBER, LKGNGE, LKGANG, LKREG, LKHOR,
         LKVER, LKANZV, LKFACH, LKRGKY, LKABC, LKLZON, LKSPKZ, LKFSTA,
         LKBMST, LKMAKO, LKMAFI, LKIDEN, LKQKZ, LKQCHR, LKMLM, LKELM,
         LKASEG, LKFSEG, LKSTH, LKLANZ, LKMNDF,dec(0, 4, 0) countart,
         dec(0, 4, 0) freePlace,
         char('1', 1) status, current timestamp tstamp, char(' ', 1) LOSTRA,
         char(' ', 3) LOORt, char(' ', 2) LOKBER,
         char(' ', 25) BMBST1, zoned(0, 6, 0) BMBSTP, char(' ', 15) BMLIEF,
         char(' ', 10) BMWENR, zoned(0, 6, 0) BMWEPO, char(' ', 25) BMANR1,
         zoned(0, 6, 0) BMANRP, char(' ', 10) BMKDNR, zoned(0, 11, 3) BMVMEN,
         zoned(0, 11, 3) BMEGEW, zoned(0, 11, 3) BMSGEW, zoned(0, 11, 3) BMTARA,
         char(' ', 03) BMME  , zoned(0, 11, 3) BMVPE,
         char(' ', 03) BMME1 , zoned(0, 11, 3) BMVPE2, char(' ', 03) BMME2 ,
         zoned(0, 08, 0) BMDTZU, char(' ', 3) BMTLM, char(' ', 3) BMLM,
         zoned(0, 11, 3) BMMLM, char(' ', 8) liefakt, char(' ', 3) LMakt
         FROM domdatv7/PLPSKOP WHERE
              LKKONZ='EMS' and (LKFIRM='DWI' or LKFIRM='SCH') and LKIDEN <> ' '
         order by LKKONZ, LKFIRM,  LKIDEN, LKORT;


       //      2. current situation duplicates TVRELWAECO/LFS_DUPLI
       exec sql
         insert into TVRELWAECO/LFS_DUPLI
         SELECT LKIDEN,
                dec(count(*), 4, 0) countart,
                dec(sum(LKFSEG), 4, 0) freePlace
         FROM lfs_segm WHERE STATUS <>'X' and LKFSEG >0
         GROUP BY LKIDEN HAVING count(*) > 1;

       //      3. current situation updates TVRELWAECO/LFS_SEGM
       //         multiple assignments done and counted here
       exec sql
         update TVRELWAECO/LFS_SEGM b set b.countart =
         (select a.countart from lfs_dupli a where
                 a.lkiden = b.lkiden and b.STATUS <>'X' and b.LKFSEG >0)
         where exists
         (select a.countart from lfs_dupli a where
                 a.lkiden = b.lkiden and b.STATUS <>'X' and b.LKFSEG >0);


       exec sql
         update TVRELWAECO/LFS_SEGM b set b.freeplace=
         (select a.freeplace from lfs_dupli a where
                 a.lkiden = b.lkiden and b.STATUS <>'X' and b.LKFSEG >0)
         where exists
         (select a.freeplace from lfs_dupli a where
                 a.lkiden = b.lkiden and b.STATUS <>'X' and b.LKFSEG >0);


       //      4. current situation unused places TVRELWAECO/LFS_SEGM
       //         aus Segmentierung (domdatv7/PLPSKOP)
       //         ==> status 2
       exec sql
         insert into   tvrelwaeco/lfs_segm
         SELECT distinct a.LKKONZ, a.LKFIRM, a.LKORT, a.LKBER, a.LKGNGE,
                                    a.LKGANG, a.LKREG, a.LKHOR,
         a.LKVER, 0 LKANZV, 0 LKFACH, 0 LKRGKY,
          ' ' LKABC, ' ' LKLZON, ' ' LKSPKZ, ' ' LKFSTA,
         ' ' LKBMST, ' ' LKMAKO, ' ' LKMAFI,
         ' ' LKIDEN, ' ' LKQKZ, ' ' LKQCHR, 0 LKMLM, ' ' LKMLM,
         0 LKASEG, 0 LKFSEG, 0 LKSTH, 0 LKLANZ, 0 LKMNDF,
         dec(0, 4, 0) countart,dec(0, 4, 0) freePlace, char('2', 1) status,
         current timestamp tstamp, char(' ', 1) LOSTRA, char(' ', 3) LOORt,
         char(' ', 2) LOKBER,
         char(' ', 25) BMBST1, zoned(0, 6, 0) BMBSTP, char(' ', 15) BMLIEF,
         char(' ', 10) BMWENR, zoned(0, 6, 0) BMWEPO, char(' ', 25) BMANR1,
         zoned(0, 6, 0) BMANRP, char(' ', 10) BMKDNR, zoned(0, 11, 3) BMVMEN,
         zoned(0, 11, 3) BMEGEW, zoned(0, 11, 3) BMSGEW, zoned(0, 11, 3) BMTARA,
         char(' ', 03) BMME  , zoned(0, 11, 3) BMVPE,
         char(' ', 03) BMME1 , zoned(0, 11, 3) BMVPE2, char(' ', 03) BMME2 ,
         zoned(0, 08, 0) BMDTZU, char(' ', 3) BMTLM, char(' ', 3) BMLM,
         zoned(0, 11, 3) BMMLM , char(' ', 8) liefakt, char(' ', 3) LMakt
         FROM domdatv7/PLPSKOP a WHERE
         a.LKKONZ='EMS' and (LKFIRM='DWI' or LKFIRM='SCH') and
         a.lkkonz not in (select  b.lkkonz from tvrelwaeco/lfs_segm b
         where a.LKFIRM = b.lkfirm and
               a.LKORT  = b.LKORT  and
               a.LKBER  = b.LKBER  and
               a.LKGNGE = b.LKGNGE and
               a.LKGANG = b.LKGANG and
               a.LKREG  = b.LKREG  and
               a.LKHOR  = b.LKHOR and
               a.LKver  = b.LKver )
         order by
             a.LKKONZ, a.LKFIRM, a.LKORT, a.LKBER, a.LKGNGE,
                                 a.LKGANG, a.LKREG, a.LKHOR, a.lkver;

       //      5. current situation undefined places TVRELWAECO/LFS_SEGM
       //         but in main stock definition (domdatv7/PLPSTAM)
       //         ==> status 3
       exec sql
         insert into   tvrelwaeco/lfs_segm
         SELECT distinct a.LpKONZ, a.LpFIRM, a.LpORT, a.LpBER, a.LpGNGE,
                                    a.LpGANG, a.LpREG, a.LpHOR,
           LpVER, 0 LKANZV, 0 LKFACH, 0 LKRGKY,
          ' ' LKABC, ' ' LKLZON, ' ' LKSPKZ, ' ' LKFSTA,
         ' ' LKBMST, ' ' LKMAKO, ' ' LKMAFI,
         ' ' LKIDEN, ' ' LKQKZ, ' ' LKQCHR, 0 LKMLM, ' ' LKMLM,
         0 LKASEG, 0 LKFSEG, 0 LKSTH, 0 LKLANZ, 0 LKMNDF,
         dec(0, 4, 0) countart, dec(0, 4, 0) freePlace, char('3', 1) status,
         current timestamp tstamp, char(' ', 1) LOSTRA, char(' ', 3) LOORt,
         char(' ', 2) LOKBER,
         char(' ', 25) BMBST1, zoned(0, 6, 0) BMBSTP, char(' ', 15) BMLIEF,
         char(' ', 10) BMWENR, zoned(0, 6, 0) BMWEPO, char(' ', 25) BMANR1,
         zoned(0, 6, 0) BMANRP, char(' ', 10) BMKDNR, zoned(0, 11, 3) BMVMEN,
         zoned(0, 11, 3) BMEGEW, zoned(0, 11, 3) BMSGEW, zoned(0, 11, 3) BMTARA,
         char(' ', 03) BMME  , zoned(0, 11, 3) BMVPE,
         char(' ', 03) BMME1 , zoned(0, 11, 3) BMVPE2, char(' ', 03) BMME2 ,
         zoned(0, 08, 0) BMDTZU, char(' ', 3) BMTLM, char(' ', 3) BMLM,
         zoned(0, 11, 3) BMMLM, char(' ', 8) liefakt, char(' ', 3) LMakt
         FROM domdatv7/PLPSTAM a WHERE
         a.LpKONZ='EMS' and (a.LpFIRM='DWI' or a.LpFirm='SCH') and
         a.lpkonz not in (select  b.lkkonz from tvrelwaeco/lfs_segm b
         where a.LpFIRM = b.lkfirm and
               a.LpORT  = b.LKORT  and
               a.LpBER  = b.LKBER  and
               a.LpGNGE = b.LKGNGE and
               a.LpGANG = b.LKGANG and
               a.LpREG  = b.LKREG  and
               a.LpHOR  = b.LKHOR and
               a.Lpver  = b.LKver )
         order by
             a.LpKONZ, a.LpFIRM, a.LpORT, a.LpBER, a.LpGNGE,
                                 a.LpGANG, a.LpREG, a.LpHOR, a.lpver;

       //      Bestände (ohne offene Transportaufträge)
       //         ==> status X
       exec sql
         insert into   tvrelwaeco/lfs_segm
         SELECT BMKONZ, BMFIRM, BMORT, BMBER, zoned(0, 4, 0) lkgnge,BMGANG,
         BMREG, BMHOR, BMVER , zoned(0, 2, 0), zoned(0, 2, 0),zoned(0, 4, 0),
         char(' ', 1), char(' ', 2), char(' ', 1), char(' ', 1), char(' ',
         12), char(' ', 3), char(' ', 3), BMIDEN, char(' ', 2), BMQCHR,
              zoned(0, 11, 3), char(' ', 3), zoned(0, 04, 0),zoned(0, 04, 0),
         zoned(0, 02, 0), zoned(0, 03, 0),zoned(0, 01, 0),dec(0, 04, 0),
         dec(0, 4, 0),char('X', 1) status,
         current timestamp tstamp, char(' ', 1) LOSTRA, char(' ', 3) LOORt,
          char(' ', 2) LOKBER ,
                BMBST1, BMBSTP, BMLIEF, BMWENR, BMWEPO, BMANR1, BMANRP,
         BMKDNR , BMVMEN, BMEGEW, BMSGEW, BMTARA, BMME, BMVPE, BMME1,
         BMVPE2, BMME2, BMDTZU, BMTLM, BMLM, BMMLM,
         char(' ', 8) liefakt, char(' ', 3) LMakt
         from domdatv7/PBESTLO ORDER BY BMIDEN;


       //      Bestände offene Transportaufträge PBESTTP
       //      von ==>
       //      Status = V
       exec sql
        insert into   tvrelwaeco/lfs_segm
        SELECT tpKONZ, tpFIRM, tpvORT, tpvBER, tpvGNG, tpGANG, tpvREG,
        tpvHOR, tpvVER, zoned(0, 2, 0), zoned(0, 2, 0),zoned(0, 4, 0),
        char(' ', 1), char(' ', 2), char(' ', 1), char(' ', 1),
        char(' ', 12), char(' ', 3), char(' ', 3), tpiden, char(' ', 2),
        tpQCHR, zoned(0, 11, 3), char(' ', 3), zoned(0, 04, 0),
        zoned(0, 04, 0),
        zoned(0, 02, 0), zoned(0, 03, 0),zoned(0, 01, 0),
        dec(0, 4, 0) countart, dec(0, 4, 0) freePlace, char('V', 1) status,
        current timestamp tstamp, char(' ', 1) LOSTRA, char(' ', 3) LOORt,
        char(' ', 2) LOKBER,tpBST1, tpBSTP, tpLIEF, tpWENR, tpWEPO, tpANR1,
        tpANRP, tpKDNR, tpVMEN,
        zoned(tpEGEW, 11, 3),zoned(tpsgew, 11, 3), zoned(tptara, 11, 3),
        tpME, tpVPE,
        tpME1, tpVPE2, tpME2, tpDTZU, tpTLM, tpLM, tpMLM,
        char(' ', 8) liefakt, char(' ', 3) LMakt
        FROM domdatv7/PBESTTP a WHERE tpKONZ='EMS' and ( tpFIRM='DWI'
                                              or  tpFIRM='SCH');



       //      Bestände offene Transportaufträge PBESTTP
       //      nach <==
       //      Status = N
       exec sql
        insert into   tvrelwaeco/lfs_segm
        SELECT tpKONZ, tpFIRM, tpnORT, tpnBER, tpnGNG, tpGANG, tpnREG,
        tpnHOR, tpnVER, zoned(0, 2, 0), zoned(0, 2, 0),zoned(0, 4, 0),
        char(' ', 1), char(' ', 2), char(' ', 1), char(' ', 1),
        char(' ', 12), char(' ', 3), char(' ', 3), tpiden, char(' ', 2),
        tpQCHR, zoned(0, 11, 3), char(' ', 3), zoned(0, 04, 0),
        zoned(0, 04, 0),
        zoned(0, 02, 0), zoned(0, 03, 0),zoned(0, 01, 0),
        dec(0, 4, 0) countart, dec(0, 4, 0) freePlace, char('N', 1) status,
        current timestamp tstamp, char(' ', 1) LOSTRA, char(' ', 3) LOORt,
        char(' ', 2) LOKBER,tpBST1, tpBSTP, tpLIEF, tpWENR, tpWEPO, tpANR1,
        tpANRP, tpKDNR, tpVMEN,
        zoned(tpEGEW, 11, 3),zoned(tpsgew, 11, 3), zoned(tptara, 11, 3),
        tpME, tpVPE,
        tpME1, tpVPE2, tpME2, tpDTZU, tpTLM, tpLM, tpMLM,
        char(' ', 8) liefakt, char(' ', 3) LMakt
        FROM domdatv7/PBESTTP a WHERE tpKONZ='EMS' and ( tpFIRM='DWI'
                                              or  tpFIRM='SCH');

       //      6. update aus PLOSTAM Kennung Strategie
       exec sql
         update TVRELWAECO/LFS_SEGM b set b.lostra   =
         (select a.LOSTRA   from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER )
         where exists
         (select a.LOSTRA   from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER );

       //      6. update aus PLOSTAM Kennung KommLagerort
       exec sql
         update TVRELWAECO/LFS_SEGM b set b.LOORT   =
         (select a.LOORT    from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER )
         where exists
         (select a.LOORT    from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER );

       //      7. update aus PLOSTAM Kennung KommLagerBereich
       exec sql
         update TVRELWAECO/LFS_SEGM b set b.LOKBER   =
         (select a.LOKBER   from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER )
         where exists
         (select a.LOKBER   from domdatv7/PLOSTAM a where
                 a.LOKONZ = b.LkKONZ and
                 a.LOFIRM = b.LkFIRM and
                 a.LOORT  = b.LkORT  and
                 a.LOBER  = b.LkBER );


         §records=*zero;
       exec sql
         select count(*) into :§records
                FROM  TVRELWAECO/LFS_SEGM
                WHERE status <>' ';

       if §records <> *zero;

       //           update Protokolldatei TVRELWAECO/LFS_SEGM
       exec sql
         update TVRELWAECO/LFS_SEGM  set status = '1'
         WHERE status ='0';
       endif;


       exec sql

       //           performance kick
       insert into   tvrelwaeco/lfs_perfor
       SELECT LKKONZ, LKFIRM, LKORT, LKBER, LKGNGE, LKGANG, LKREG, LKHOR,
       LKVER, LKANZV, LKFACH, LKRGKY, LKIDEN,LKASEG, LKFSEG, freeplace,
       lkkonz oplkkonz,lkfirm oplkfirm, lkort oplkort, lkber oplkber,
       LKGNGE oplkgnge,LKGANG opLKGANG, LKREG opLKREG, LKHOR opLKHOR,
       LKVER opLKVER,  LKANZV OPLKANZV, LKFACH OPLKFACH, LKRGKY OPLKRGKY,
       LKIDEN OPLKIDEN,LKASEG OPLKASEG, LKFSEG OPLKFSEG,
                                  countart,              freeplace opfree,
       char('0', 1) status, current timestamp tstamp,
       zoned(0, 13, 0) oprrn
       FROM lfs_segm WHERE
       freeplace > 0 and LKIDEN <>'#9105306240' ORDER BY lkiden,lkfseg;
       exec sql
         update TVRELWAECO/lfs_perfor set oprrn = rrn(lfs_perfor);

       exec sql
         update  lfs_perfor set oplkkonz= ' ', oplkfirm = ' ', oplkort
         = ' ', oplkber=' ', OPLKGNGE=0, OPLKGANG=0, opLKREG=0, opLKHOR=0,
         opLKVER=0, opLKANZV=0, opLKFACH=0, opLKRGKY=0, opLKIDEN=' ';

       exec sql
         update TVRELWAECO/LFS_SEGM b set b.liefakt  =
         (select a.TESTLF   from teil01    a where
                 a.tetenr = b.lkiden and a.tefirm='01')
         where exists
         (select a.TESTLF   from teil01    a where
                 a.tetenr = b.lkiden and a.tefirm='01');

       exec sql
         update TVRELWAECO/LFS_SEGM b set b.lmakt    =
         (select a.TZLM     from pbfstss   a where
                 a.tziden = b.lkiden and tzkonz = 'EMS' and
                                       (tzfirm = 'DWI' or   tzfirm = 'SCH'))
         where exists
         (select a.TZLM     from pbfstss   a where
                 a.tziden = b.lkiden and tzkonz = 'EMS' and
                                       (tzfirm = 'DWI' or   tzfirm = 'SCH'));

       exec sql
            create index tvrelwaeco/lfs_perfol on
                         tvrelwaeco/lfs_perfor(oprrn);

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       //-----------------------------------------------------------------------
       //Transportaufträge
       //-----------------------------------------------------------------------

       begsr SR_request;

          open lfs_perfoR;
          open lfs_perfoL;

          clear §item;
          read lfs_perfoR lfs_perfoR_i;
          dow not %eof(lfs_perfoR);
       //für upload
             if  lfs_perfoR_i.status = '0';
                if  lfs_perfoR_i.lkiden <> §item;
                   §x  =  1;
                   §item = lfs_perfoR_i.lkiden;
                 else;
                   §x  = §x + 1;
                endif;
                lfs_perfoR_o  = lfs_perfoR_i;
                exsr  SR_minus;
             endif;
             read lfs_perfoR lfs_perfoR_i;
          enddo;
          unlock lfs_perfoR;

          close lfs_perfoL;
          close lfs_perfoR;

       endsr;

       //-----------------------------------------------------------------------
       //Transportaufträge
       //-----------------------------------------------------------------------

       begsr SR_minus;

          lfs_perfoL_k.opRRN  =  lfs_perfoR_i.opRRN +
                                 lfs_perfoR_i.countart - §x;

       // chain %kds(lfs_perfol_k:1) lfs_perfol lfs_perfol_I;

          if (lfs_perfoR_i.opRRN + 0) < lfs_perfoL_k.opRRN;
          setgt %kds(lfs_perfol_k:1) lfs_perfol;
          readp lfs_perfol lfs_perfol_i;
          dow not %eof(lfs_perfol) and
             lfs_perfoL_i.lkiden = lfs_perfoR_i.lkiden;
             if lfs_perfoL_i.status = '0' and
                (lfs_perfoL_i.LKFSEG > lfs_perfoR_i.LKFSEG or
                 lfs_perfoL_i.LKFSEG = lfs_perfoR_i.LKFSEG );
       //für upload
                   lfs_perfoL_o           = lfs_perfoL_i;
                   lfs_perfoL_o.status    = '0';
                   lfs_perfoL_o.tstamp    = %timestamp();
                   lfs_perfoL_o.LKFSEG = lfs_perfoL_o.LKFSEG -
                                         lfs_perfoR_i.LKFSEG;
                   lfs_perfoL_o.opfree = lfs_perfoL_o.opfree -
                                         lfs_perfoR_i.LKFSEG;
                   if lfs_perfoL_o.LKFSEG = 0;
                      lfs_perfoL_o.status    = '-';
                   endif;
                   update LOG01R    lfs_perfoL_o;
       //Transportaufträge
                   lfs_perfoR_o.status    = '+';
                   lfs_perfoR_o.tstamp    = %timestamp();
                   lfs_perfoR_o.LKFSEG    = 0;
                   lfs_perfoR_o.OPLKKONZ  = lfs_perfoL_o.LKKONZ;
                   lfs_perfoR_o.OPLKFIRM  = lfs_perfoL_o.LKFIRM;
                   lfs_perfoR_o.OPLKORT   = lfs_perfoL_o.LKORT ;
                   lfs_perfoR_o.OPLKBER   = lfs_perfoL_o.LKBER ;
                   lfs_perfoR_o.OPLKGNGE  = lfs_perfoL_o.LKGNGE;
                   lfs_perfoR_o.OPLKGANG  = lfs_perfoL_o.LKGANG;
                   lfs_perfoR_o.OPLKREG   = lfs_perfoL_o.LKREG ;
                   lfs_perfoR_o.OPLKHOR   = lfs_perfoL_o.LKHOR ;
                   lfs_perfoR_o.OPLKVER   = lfs_perfoL_o.LKVER ;
                   lfs_perfoR_o.OPLKANZV  = lfs_perfoL_o.LKANZV;
                   lfs_perfoR_o.OPLKFACH  = lfs_perfoL_o.LKFACH;
                   lfs_perfoR_o.OPLKRGKY  = lfs_perfoL_o.LKRGKY;
                   lfs_perfoR_o.OPLKIDEN  = lfs_perfoL_o.LKIDEN;
                   lfs_perfoR_o.OPfree    = lfs_perfoL_o.opfree  ;
                   update PHY01R    lfs_perfoR_o;
                   clear            lfs_perfoR_o;
       //Transportaufträge
                   clear            lfs_perfoL_o;
                   leave;
             else;
                   if (lfs_perfoR_i.opRRN + 1) < lfs_perfoL_i.opRRN;
                      readp lfs_perfol lfs_perfol_i;
                   else;
                      unlock lfs_perfol;
                      leave;
                   endif;
             endif;

          enddo;
          unlock lfs_perfol;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //report customer
       //-----------------------------------------------------------------------

       begsr SR_report;

         eval p_infil   =  'LFS_SEGM' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'LFS_SEGM';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/LFS_SEGM*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed LFS_SEGM*              ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object LFS_SEGM*                 ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'LFS_SEGM';

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
          status='Error by CVTDBF object LFS_SEGM                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'LFS_SEGM';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(ELSEBERG MEIER) DTAAUT(*RWX) ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/USERI5) gang  ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/USERI5) gang ';
       endmon;


       exsr  SR_perfor;

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''LFS_SEGM'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'LFS_SEGM';

       //-----------------------------------------------------------------------
       //'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
       //''' '' '' '' '' '')';
       //-----------------------------------------------------------------------
       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT01'' ' +
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
       //report optimizing
       //-----------------------------------------------------------------------

       begsr SR_perfor;

         eval p_infil   =  'LFS_PERFOR' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'LFS_PERFOR';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/LFS_PERFOR*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed LFS_PERFO*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object LFS_PERFOR*               ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'LFS_PERFOR';

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
          status='Error by CVTDBF object LFS_PERFOR                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'LFS_PERFOR';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(ELSEBERG MEIER) DTAAUT(*RWX) ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/USERI5) gang  ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/USERI5) gang ';
       endmon;


       endsr;

       //-----------------------------------------------------------------------
       //report clients
       //-----------------------------------------------------------------------

       begsr SR_report2;

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


