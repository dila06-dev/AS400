
      //************************************************************************
      //
      //      Programmname       LFS_picksr
      //      Erstellt  am       30.08.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung
      //    ...
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
      // SELECT "LOCATION", ITEM, LADEM, LFSL, LFSH, LFSB, LFSQ,
      // dec((JANA+FEBA+MAEA+APRA+MAIA+JUNA+ JULA+AUGA+SEPA+OKTA+NOVA+DEZA),
      // 12, 3) absatz , dec((JANh+FEBh+MAEh+APRh+MAIh+JUNh+
      // JULh+AUGh+SEPh+OKTh+NOVh+DEZh), 12, 3) picks FROM rpm_lfs_q1
      //                                                      ORDER BY ITEM
      // ,"LOCATION", ITEM
      // Datei LFS_PICKS in TVRELWAECO wurde erstellt.
      // (
      // SELECT "LOCATION", LFS_PICKS.ITEM, LADEM, LFSL, LFSH,
      // LFS_PICKS.LFSB, LFSQ, ABSATZ, PICKS, FACH, LPKONZ, LPFIRM, LPORT,
      // LPBER, LPGNGE, LPGANG, LPTRPA, LPREG, LPHOR, LPVER, LPRFZ, LPFACH,
      // LPASEG, LPFSEG, LPELM, LPSM, LPBMST , char(' ') status,
      // current timestamp tstamp                       fROM lfs_picks,
      // domdatv7/PLPSTAM
      //
      // SELECT "LOCATION", ITEM, LADEM, LFSL, LFSH, LFSB, LFSQ, ABSATZ,
      // PICKS, FACH, LPKONZ, LPFIRM, LPORT, LFS_PLACE.LPBER, LPGNGE,
      // LPGANG, LPTRPA, LPREG, LPHOR, LPVER, LPRFZ, LPFACH, LPASEG, LPFSEG,
      // LPELM, LPSM, LPBMST, STATUS, TSTAMP,BMIDEN, BMLENR, BMZULE, BMBST1,
      // BMBSTP, BMWENR, BMWEPO, BMANR1, BMANRP, BMTLM, BMBMEN, BMVMEN FROM
      // lfs_place, PBESTLO WHERE ITEM = PBESTLO.BMIDEN and item='9102900232'
      //
      //
      // rpm_lfs_q1:aus RPM Grunddaten Verkaufsstatitik mit Zuordnungen
      //            zum lager, rollierend Jahresübersicht Picks u. Absatz
      //            *input
      // lfs_picks: Additionen mit möglichen Bewertungen(Saison) + Stamm-
      //            daten ausgehend von rpm_lfs_q1
      //             *output
      // pbfstss  : Stammdaten   *input
      // pschluel3: Stammdaten   *input
      // teil01   : Stammdaten   *input
      // #plpstam : Stammdaten aus plpstam nach Sortierung *input
      //
      // lfs_picksl:Sortierreihenfolge der (lfs_picks *output)    *input
      // lfs_magl  :Steuertabelle                                 *input
      //
      // lfs_place :Platzzuordnung Lager nach Regeln
      //             *output
      // lfs_placel:Sort für Organisation *input
      //
      //
      // #Pbestlo l:Sortierung            *input
      // PBESTLOL1l:Sortierung            *input
      //          l:Sort für Organisation *input
      // lfs_minusl:Sort für Organisation *input
      //
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

     frpm_lfs_q1if   e             DISK    RENAME(rpm_lfs_q1:PHY01R)
     f                                     USROPN

     flfs_picks o  a e             DISK    RENAME(lfs_picks:phy02R)
     f                                     USROPN

     fpbfstss   if   e           K DISK    RENAME(pbfstssf:LOG03R)
     f
     fpschluel3 if   e           K DISK
     f
     fteil01    if   e           K DISK    RENAME(teil1:LOG05R)
     f
     f
      //PLPSTAMl10if   e           K DISK    RENAME(PLPSTAMf:LOG06R)
      //
     f#plpstam  if   e           K DISK    RENAME(PLPSTAMf:LOG06R)
     f                                     USROPN
     f
     flfs_picksluf   e           K DISK    RENAME(lfs_picks:LOG07R)
     f                                     USROPN
     f
     flfs_magl  if   e           k DISK    RENAME(lfs_mag:LOG08R)
     f                                     USROPN

     flfs_place o  a e             DISK    RENAME(lfs_place:phy03R)
     f                                     USROPN

     flfs_placelif   e           K DISK    RENAME(lfs_place:LOG09R)
     f                                     USROPN
     f
      //Pbestlo   if   e           K DISK    RENAME(Pbestlof:LOG10R)
      //
     f#Pbestlo  if   e           K DISK    RENAME(Pbestlof:LOG10R)
     f                                     USROPN
     f
     fPBESTLOL1 if   e           K DISK    RENAME(Pbestlof:LOG11R)

     flfs_minuslif   e           K DISK    RENAME(lfs_minus:LOG12R)
     f                                     USROPN
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
     d rpm_lfs_q1_i  E DS                  ExtName(rpm_lfs_q1:*input)
     d                                     Qualified

     d rpm_lfs_q1_o  E DS                  ExtName(rpm_lfs_q1:*output)
     d                                     Qualified

     d lfs_picks_o   E DS                  ExtName(lfs_picks:*output)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified

     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d pschluel3_i   E DS                  ExtName(pschluel3:*input)
     d                                     Qualified

     d pschluel3_k   E DS                  ExtName(pschluel3:*key)
     d                                     Qualified

     d PLPSTAM_i     E DS                  ExtName(#plpstam:*input)
     d                                     Qualified

     d PLPSTAM_k     E DS                  ExtName(#plpstam:*key)
     d                                     Qualified

     d LFS_PICKSL_i  E DS                  ExtName(LFS_PICKSL:*input)
     d                                     Qualified

     d lfs_magl_i    E DS                  ExtName(lfs_magl:*input)
     d                                     Qualified

     d lfs_magl_k    E DS                  ExtName(lfs_magl:*key)
     d                                     Qualified

     d lfs_place_o   E DS                  ExtName(lfs_place:*output)
     d                                     Qualified

     d LFS_PLACEL_k  E DS                  ExtName(LFS_PLACEL:*key)
     d                                     Qualified

     d LFS_PLACEL_i  E DS                  ExtName(LFS_PLACEL:*input)
     d                                     Qualified

     d PBESTLO_i     E DS                  ExtName(#PBESTLO:*input)
     d                                     Qualified

     d PBESTLO_k     E DS                  ExtName(#PBESTLO:*key)
     d                                     Qualified

     d PBESTLOL1_i   E DS                  ExtName(PBESTLOl1:*input)
     d                                     Qualified

     d PBESTLOL1_k   E DS                  ExtName(PBESTLOl1:*key)
     d                                     Qualified

     d LFS_MINUSL_k  E DS                  ExtName(LFS_MINUSL:*key)
     d                                     Qualified

     d LFS_MINUSL_i  E DS                  ExtName(LFS_MINUSL:*input)
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
     D §pos            s              2s 0 inz
     D §01             s              2s 0 inz
     D §02             s              2s 0 inz
     D §03             s              2s 0 inz
     D §04             s              2s 0 inz
     D §05             s              2s 0 inz
     D §06             s              2s 0 inz
     D §07             s              2s 0 inz
     D §08             s              2s 0 inz
     D §09             s              2s 0 inz
     D §10             s              2s 0 inz
     D §11             s              2s 0 inz
     D §12             s              2s 0 inz
     D §success        s              1s 0 inz
     D #write          s              1a   inz

      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________
     Ilog08R
     I              status                      §status

     Ilog09R
     I              status                      §status

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start LFS_PICKSR                          ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

          if §records =  *zero;
             exsr      SR_request;
             exsr      SR_report;
          endif;

       endif;

       //________________________________
       //

       eval status ='Ende  LFS_PICKSR                        ';
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
       §01  = 1;
       §02  = 1;
       §03  = 1;
       §04  = 1;
       §05  = 1;
       §06  = 1;
       §07  = 1;
       §08  = 1;
       §09  = 1;
       §10  = 1;
       §11  = 1;
       §12  = 1;

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_PICKS) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_PICKS)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_PLACE) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_PLACE)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/LFS_MINUS) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/LFS_MINUS)            ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'DLTF FILE(QTEMP/#PBESTLO)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error DLTF FILE(QTEMP/#PBESTLO)                    ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'DLTF FILE(QTEMP/#PLPSTAM)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error DLTF FILE(QTEMP/#PLPSTAM)                    ';
             exsr      SR_log;
       endmon;

       //nur für Definition !!!__________
       // exec sql
       //   insert into tvrelwaeco/lfs_picks
       //   SELECT "LOCATION", ITEM, LADEM, LFSL, LFSH, LFSB, LFSQ, dec(0,0, 9,
       //   3) lfbrt, dec(0,0, 9, 3) lfnet,char(' ', 2) sta   ,char(' ', 50) bz,
       //    dec((JANA+FEBA+MAEA+APRA+MAIA+JUNA+JULA+AUGA+SEPA+OKTA+NOVA+DEZA),
       //   12, 3) absatz ,
       //   dec((JANh+FEBh+MAEh+APRh+MAIh+JUNh+JULh+AUGh+SEPh+OKTh+NOVh+DEZh),
       //   12, 3) picks, char('  ', 50) fach, ARTNR, teerte FROM rpm_lfs_q1
       //   ORDER BY ITEM ,"LOCATION", ITEM
       //   ORDER BY ITEM ,"LOCATION", ITEM;




       //Achtung aus Testsystem__________
       exec sql
            insert into tvrelwaeco/lfs_mag
            SELECT DISTINCT
            a.lpKONZ,a.LPFIRM,a.LPORT,a.LPBER,zoned(0, 2, 0) vertikal
            ,char(' ', 10) lager, zoned(0, 2, 0) sort1,
            zoned(0, 2, 0) sort2, zoned(0, 2,
            0) sort3, zoned(0, 2, 0) sort4, zoned(0, 2, 0) sort5,
            char(' ', 3) Lademittel, char(' ', 50) txt,
            char('I', 1) status,  current timestamp tstamp
            FROM domdatv7/PLPSTAM a WHERE a.LPKONZ ='EMS'
            and a.lpkonz not in (select b.lpkonz from tvrelwaeco/lfs_mag
             b where a.LPFIRM=b.LPFIRM and a.LPORT=b.LPORT and a.LPBER=b.LPBER)
                            GROUP BY LPKONZ, LPFIRM, LPORT, LPBER;

       //Achtung aus Testsystem__________
       exec sql
            insert into tvrelwaeco/LFS_MINUS
            sELECT BMKONZ, BMFIRM, BMORT, BMBER, BMGANG, BMREG, BMHOR, BMVER,
            BMSEGM, BMIDEN, BMLM, BMABKZ, BMBMEN FROM pbestlo;

       exec sql
            create index tvrelwaeco/lfs_picksl on
                         tvrelwaeco/lfs_picks("LOCATION",PICKS desc, ITEM);

       exec sql
            create index tvrelwaeco/lfs_magl   on
                         tvrelwaeco/lfs_mag(status,lpkonz,lpfirm, lager,
                          sort1 desc, sort2 desc, sort3 desc, sort4 desc,
                          sort5 desc);

       exec sql
            create index tvrelwaeco/lfs_placel on
                         tvrelwaeco/lfs_place(lpkonz,lpfirm,LPORT,LPber,
                                            lpreg,lphor,lpver);

       exec sql
            create index tvrelwaeco/LFS_MINUSl on tvrelwaeco/lfs_minus
                   (BMfirm, BMIDEN, BMKONZ, BMBMEN,
                    BMORT, BMBER, BMGANG, BMREG, BMHOR, BMVER);

       exec sql
            create index qtemp/#pbestlo   on PBESTLO
                   (bmKONZ, bmFIRM, bmORT , bmBER , bmVER, bmREG, bmHOR);

       exec sql
            create index qtemp/#plpstam   on PLPSTAM
                   (lpKONZ, lpFIRM, lpORT , lpBER , lpVER, lpREG, lpHOR);

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
       //1.Ableitung
       //-----------------------------------------------------------------------

       begsr SR_request;

          open rpm_lfs_q1;
          open lfs_picks;

          clear lfs_picks_o;
          read rpm_lfs_q1 rpm_lfs_q1_i;
          dow not %eof(rpm_lfs_q1);
       //für upload
             lfs_picks_o.LOCATION = rpm_lfs_q1_i.LOCATION;
             lfs_picks_o.ITEM     = rpm_lfs_q1_i.ITEM;
             lfs_picks_o.LADEM    = rpm_lfs_q1_i.LADEM;
             lfs_picks_o.LFSL     = rpm_lfs_q1_i.LFSL;
             lfs_picks_o.LFSH     = rpm_lfs_q1_i.LFSH;
             lfs_picks_o.LFSB     = rpm_lfs_q1_i.LFSB;
             lfs_picks_o.LFSQ     = rpm_lfs_q1_i.LFSQ;
             if rpm_lfs_q1_i.ARTNR <> rpm_lfs_q1_i.ITEM;
                lfs_picks_o.ARTNR    = rpm_lfs_q1_i.ARTNR;
             endif;
             lfs_picks_o.teerte   = rpm_lfs_q1_i.teerte;

                §01  = 1;
                §02  = 1;
                §03  = 1;
                §04  = 1;
                §05  = 1;
                §06  = 1;
                §07  = 1;
                §08  = 1;
                §09  = 1;
                §10  = 1;
                §11  = 1;
                §12  = 1;

             teil01_k.TEFIRM = '01';
             teil01_k.TETENR = rpm_lfs_q1_i.ITEM;
             chain %kds(teil01_k:2) teil01    teil01_I;
             if %found(teil01);
                if teil01_i.tETEST = '90';
                   PBESTLOL1_k.bmKONZ  = 'EMS';
                   PBESTLOL1_k.bmFIRM  = 'DWI';
                   PBESTLOL1_k.BMIDEN  = rpm_lfs_q1_i.ITEM;
                   chain %kds(PBESTLOl1_k:3) PBESTLOl1  PBESTLOl1_i;
                   if %found(PBESTLOl1);
                   else;
                      §01 =  0;
                      §03 =  0;
                      §05 =  0;
                      §07 =  0;
                      §09 =  0;
                      §11 =  0;
                      §02 =  0;
                      §03 =  0;
                      §06 =  0;
                      §08 =  0;
                      §10 =  0;
                      §12 =  0;
                   endif;
                else;
                endif;
             else;
             endif;

             lfs_picks_o.absatz =
                rpm_lfs_q1_i.JANA*§01 + rpm_lfs_q1_i.FEBA*§02 +
                rpm_lfs_q1_i.MAEA*§03 + rpm_lfs_q1_i.APRA*§03 +
                rpm_lfs_q1_i.MAIA*§05 + rpm_lfs_q1_i.JUNA*§06 +
                rpm_lfs_q1_i.JULA*§07 + rpm_lfs_q1_i.AUGA*§08 +
                rpm_lfs_q1_i.SEPA*§09 + rpm_lfs_q1_i.OKTA*§10 +
                rpm_lfs_q1_i.NOVA*§11 + rpm_lfs_q1_i.DEZA*§12;

             lfs_picks_o.picks  =
                rpm_lfs_q1_i.JANh*§01 + rpm_lfs_q1_i.FEBh*§02 +
                rpm_lfs_q1_i.MAEh*§03 + rpm_lfs_q1_i.APRh*§03 +
                rpm_lfs_q1_i.MAIh*§05 + rpm_lfs_q1_i.JUNh*§06 +
                rpm_lfs_q1_i.JULh*§07 + rpm_lfs_q1_i.AUGh*§08 +
                rpm_lfs_q1_i.SEPh*§09 + rpm_lfs_q1_i.OKTh*§10 +
                rpm_lfs_q1_i.NOVh*§11 + rpm_lfs_q1_i.DEZh*§12;

                pschluel3_k.slkonz = 'EMS';
                pschluel3_k.SLKGRP = 'DWI';

       //Lademittel B100
                pschluel3_k.slid   = 'B100';
                pschluel3_k.slkey   = rpm_lfs_q1_i.LADEM;
                chain %kds(pschluel3_k:4) pschluel3   pschluel3_I;
                if %found(pschluel3);
       //Fachgrösse A100
                   pschluel3_k.slid   = 'A100';
                   clear          pschluel3_k.slkey;
                   %subst(pschluel3_k.slkey:1:2) =
                                     %editc(pschluel3_i.SLFACH:'X');
                   chain %kds(pschluel3_k:4) pschluel3   pschluel3_I;
                   if %found(pschluel3);
                      lfs_picks_o.fach     = pschluel3_i.slkey;
                   endif;
                endif;
       //pbfstss
             pbfstss_k.tzkonz = 'EMS';
             pbfstss_k.tzfirm = 'DWI';
             pbfstss_k.tziden = rpm_lfs_q1_i.ITEM;
             chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
             if %found(pbfstss);
                lfs_picks_o.lfbrt = pbfstss_i.TZBRUT;
                lfs_picks_o.lfnet = pbfstss_i.TZNETT;
                %subst(lfs_picks_o.bz:1:30)= pbfstss_i.TzBEZ1;
             else;
                pbfstss_k.tziden = rpm_lfs_q1_i.ARTNR;
                chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
                if %found(pbfstss);
                   lfs_picks_o.lfbrt = pbfstss_i.TZBRUT;
                   lfs_picks_o.lfnet = pbfstss_i.TZNETT;
                   %subst(lfs_picks_o.bz:1:30)= pbfstss_i.TzBEZ1;
                endif;
             endif;
       //teil
             lfs_picks_o.sta  =teil01_i.tETEST;
             write PHY02R     lfs_picks_o;
             clear lfs_picks_o;

             read rpm_lfs_q1 rpm_lfs_q1_i;
          enddo;

          close lfs_picks;
          close rpm_lfs_q1;
          exsr SR_request2;

       endsr;

       //-----------------------------------------------------------------------
       //2.Auftrag lesen der Lagerstämme
       //-----------------------------------------------------------------------

       begsr SR_request2;

          open LFS_place;
          open lfs_picksl;
          open LFS_MAGL;
          open LFS_placel;
          open lfs_minusl;
          open #Pbestlo;
          open #Plpstam;

          §success =  0;
          clear lfs_place_o;
          read lfs_picksl lfs_picksl_i;
          dow not %eof(lfs_picksl);
       //für upload wenn picks grösser null
             if lfs_picksl_i.picks <> 0                and
                ( lfs_picksl_i.location = 'EDC       ' or
                  lfs_picksl_i.location = 'SCHILGEN  ' or
                  lfs_picksl_i.location = 'SILFOX    ' ) and
                  lfs_picksl_i.LADEM   <> '***';
                lfs_magl_k.status  = 'A';
                lfs_magl_k.lpkonz  = 'EMS';
                lfs_magl_k.LPFIRM  = 'DWI';
                lfs_magl_k.Lager   = lfs_picksl_i.LOCATION;
                setll %kds(lfs_magl_k:4) lfs_magl;
                reade %kds(lfs_magl_k:4) lfs_magl  lfs_magl_i;
                dow not %eof(lfs_magl) and §success =  0;
                   if lfs_magl_i.status =  'A' and §success =  0 and
                      ( lfs_magl_i.lademittel ='  '  or
                        lfs_magl_i.lademittel = lfs_picksl_i.LADEM);
       //            gültig für upload
                      plpstam_k.LPKONZ   = lfs_magl_i.lpkonz;
                      plpstam_k.LPFIRM   = lfs_magl_i.LPFIRM;
                      plpstam_k.LPORT    = lfs_magl_i.LPORT;
                      plpstam_k.LPBER    = lfs_magl_i.LPBER;
                      clear  plpstam_k.LPREG;
                      clear  plpstam_k.LPHOR;
                      clear  plpstam_k.LPVER;
                      setll %kds(plpstam_k:7) #plpstam;
                      reade %kds(plpstam_k:4) #plpstam    plpstam_i;
                      dow not %eof(#plpstam) and §success =  0;
                         if  plpstam_i.LPSPKZ <> 'X';
       //                  lfs_place
                            exsr run_out;
       //                  nur wenn Zuordnung mit Fach identisch oder kleiner
       //                  lfs_place_o.lpfach = Inhalt aus Lagerplatz
                            if ( %subst(lfs_place_o.FACH:1:2) =
                                         %editc(lfs_place_o.lpfach:'X') or
                                 %subst(lfs_place_o.FACH:1:2) <
                                         %editc(lfs_place_o.lpfach:'X'));
       //                     nuller raus
                               if ( lfs_placel_k.LPHOR <> 0 and
                                    lfs_placel_k.LPVER <> 0);
                                  chain %kds(lfs_placel_k:7)
                                             lfs_placel lfs_placel_I;
       //                        nur wenn noch nicht besetzt
                                  if %found(lfs_placel);
                                  else;
                                     exsr run_stock;
                                     write PHY03R     lfs_place_o;
                                     delete           lfs_picksl;
                                     exsr run_local;
                                     clear lfs_place_o;
                                     §success =  1;
                                     leave;
                                  endif;
                               endif;
                            endif;
                         endif;
                         reade %kds(plpstam_k:4) #plpstam  plpstam_i;
                      enddo;
                   endif;
                   reade %kds(lfs_magl_k:4) lfs_magl  lfs_magl_i;
                enddo;
             endif;
       //    if §success =  0;
       //       eval lfs_place_o.FACH:1:2 =
       //    else;
                read lfs_picksl lfs_picksl_i;
       //    endif;
             §success =  0;
          enddo;
       // unlock LFS_place;

          close #Plpstam;
          close #Pbestlo;
          close LFS_minusl;
          close LFS_placel;
          close LFS_MAGL;
          close lfs_picksl;
          close LFS_place;

       endsr;
       //-----------------------------------------------------------------------
       //output erzeugen
       //-----------------------------------------------------------------------

       begsr run_out;

          lfs_place_o.LOCATION = lfs_picksl_i.LOCATION;
          lfs_place_o.ITEM     = lfs_picksl_i.ITEM;
          lfs_place_o.LADEM    = lfs_picksl_i.LADEM;
          lfs_place_o.LFSL     = lfs_picksl_i.LFSL;
          lfs_place_o.LFSH     = lfs_picksl_i.LFSH;
          lfs_place_o.LFSB     = lfs_picksl_i.LFSB;
          lfs_place_o.LFSQ     = lfs_picksl_i.LFSQ;
          lfs_place_o.ABSATZ   = lfs_picksl_i.ABSATZ;
          lfs_place_o.PICKS    = lfs_picksl_i.PICKS;
          lfs_place_o.FACH     = lfs_picksl_i.FACH;
       //   *
          lfs_place_o.LPKONZ   = plpstam_i.LPKONZ;
          lfs_place_o.LPFIRM   = plpstam_i.LPFIRM;
          lfs_place_o.LPORT    = plpstam_i.LPORT;
          lfs_place_o.LPBER    = plpstam_i.LPBER;
          lfs_place_o.LPGNGE   = plpstam_i.LPGNGE;
          lfs_place_o.LPGANG   = plpstam_i.LPGANG;
          lfs_place_o.LPTRPA   = plpstam_i.LPTRPA;
          lfs_place_o.LPREG    = plpstam_i.LPREG;
          lfs_place_o.LPHOR    = plpstam_i.LPHOR;
          lfs_place_o.LPVER    = plpstam_i.LPVER;
          lfs_place_o.LPRFZ    = plpstam_i.LPRFZ;
          lfs_place_o.LPFACH   = plpstam_i.LPFACH;
          lfs_place_o.LPASEG   = plpstam_i.LPASEG;
          lfs_place_o.LPFSEG   = plpstam_i.LPFSEG;
          lfs_place_o.LPELM    = plpstam_i.LPELM;
          lfs_place_o.LPSM     = plpstam_i.LPSM;
          lfs_place_o.LPBMST   = plpstam_i.LPBMST;
          lfs_place_o.STATUS   = 'A';
          lfs_place_o.tstamp   =  %timestamp();
       //Ursprung festhalten,
       //schon in Verwendung ? Schlüsselübergabe Prüfung
          lfs_placel_k.LPKONZ = plpstam_i.LPKONZ;
          lfs_placel_k.LPFIRM = plpstam_i.LPFIRM;
          lfs_placel_k.LPORT  = plpstam_i.LPORT;
          lfs_placel_k.LPBER  = plpstam_i.LPBER;
          lfs_placel_k.LPREG  = plpstam_i.LPREG;
          lfs_placel_k.LPHOR  = plpstam_i.LPHOR;
          lfs_placel_k.LPVER  = plpstam_i.LPVER;

       endsr;


       //-----------------------------------------------------------------------
       //derzeitigen Lagerbestand ermitteln
       //von Artikel, der derzeit auf dem Ort liegt
       //-----------------------------------------------------------------------

       begsr run_stock;

          PBESTLO_k.bmKONZ   = plpstam_i.LPKONZ;
          PBESTLO_k.bmFIRM   = plpstam_i.LPFIRM;
          PBESTLO_k.bmORT    = plpstam_i.LPORT;
          PBESTLO_k.bmBER    = plpstam_i.LPBER;
          PBESTLO_k.bmREG    = plpstam_i.LPREG;
          PBESTLO_k.bmHOR    = plpstam_i.LPHOR;
          PBESTLO_k.bmVER    = plpstam_i.LPVER;

          setll %kds(PBESTLO_k:7) #PBESTLO;
          reade %kds(PBESTLO_k:7) #PBESTLO  PBESTLO_i;
          dow not %eof(#PBESTLO);
             if  PBESTLO_i.BMIDEN <> *blank;
       //      gültig für upload, derzeit gelagertes Material
                lfs_place_o.BMIDEN = PBESTLO_i.BMIDEN;
                lfs_place_o.BMLENR = PBESTLO_i.BMLENR;
                lfs_place_o.BMZULE = PBESTLO_i.BMZULE;
                lfs_place_o.BMBST1 = PBESTLO_i.BMBST1;
                lfs_place_o.BMBSTP = PBESTLO_i.BMBSTP;
                lfs_place_o.BMWENR = PBESTLO_i.BMWENR;
                lfs_place_o.BMWEPO = PBESTLO_i.BMWEPO;
                lfs_place_o.BMANR1 = PBESTLO_i.BMANR1;
                lfs_place_o.BMANRP = PBESTLO_i.BMANRP;
                lfs_place_o.BMTLM  = PBESTLO_i.BMTLM;
                lfs_place_o.BMBMEN = PBESTLO_i.BMBMEN;
                lfs_place_o.BMVMEN = PBESTLO_i.BMVMEN;
                leave;
             endif;
             reade %kds(PBESTLO_k:7) #PBESTLO   PBESTLO_i;
          enddo;

       endsr;

       //-----------------------------------------------------------------------
       //derzeitigen Lagerbestand/Ort ermitteln von den
       //Artikeln, die jetzt Hauptartikel sind
       //ggf hier Sortierungsschlüssel später ändern
       //da die Segmentierung derzeit nicht gewünscht ist, erfolgt
       //eine Summierung und die Segmentierung wird initialisiert
       //daher der die Gruppenwechselabfrage
       //-----------------------------------------------------------------------

       begsr run_local;

          lfs_minusl_k.bmKONZ   = plpstam_i.LPKONZ;
          lfs_minusl_k.BMIDEN   = lfs_picksl_i.ITEM;
          lfs_minusl_k.bmFIRM   = plpstam_i.LPFIRM;

          #write = '0';
          setll %kds(lfs_minusl_k:3) lfs_minusl;
          reade %kds(lfs_minusl_k:3) lfs_minusl  lfs_minusl_i;
          dow not %eof(lfs_minusl);
             if lfs_minusl_i.BMIDEN = lfs_picksl_i.ITEM;
                if lfs_place_o.AKTBMKONZ = *blank and
                   lfs_place_o.AKTBMFIRM = *blank;
                   lfs_place_o.AKTBMKONZ = lfs_minusl_i.BMKONZ;
                   lfs_place_o.AKTBMFIRM = lfs_minusl_i.BMFIRM;
                   lfs_place_o.AKTBMORT  = lfs_minusl_i.BMORT ;
                   lfs_place_o.AKTBMBER  = lfs_minusl_i.BMBER ;
                   lfs_place_o.AKTBMGANG = lfs_minusl_i.BMGANG;
                   lfs_place_o.AKTBMREG  = lfs_minusl_i.BMREG ;
                   lfs_place_o.AKTBMHOR  = lfs_minusl_i.BMHOR ;
                   lfs_place_o.AKTBMVER  = lfs_minusl_i.BMVER ;
                endif;

                if lfs_place_o.AKTBMKONZ <> lfs_minusl_i.BMKONZ or
                   lfs_place_o.AKTBMFIRM <> lfs_minusl_i.BMFIRM or
                   lfs_place_o.AKTBMORT  <> lfs_minusl_i.BMORT  or
                   lfs_place_o.AKTBMBER  <> lfs_minusl_i.BMBER  or
                   lfs_place_o.AKTBMGANG <> lfs_minusl_i.BMGANG or
                   lfs_place_o.AKTBMREG  <> lfs_minusl_i.BMREG  or
                   lfs_place_o.AKTBMHOR  <> lfs_minusl_i.BMHOR  or
                   lfs_place_o.AKTBMVER  <> lfs_minusl_i.BMVER;
                   write PHY03R     lfs_place_o;
                   #write = '0';
                   lfs_place_o.AKTBMSEGM = *zero;
                   lfs_place_o.AKTBMBMEN = *zero;
                   lfs_place_o.AKTBMABKZ = *blank;
       //         neuaufbau
                   lfs_place_o.AKTBMKONZ = lfs_minusl_i.BMKONZ;
                   lfs_place_o.AKTBMFIRM = lfs_minusl_i.BMFIRM;
                   lfs_place_o.AKTBMORT  = lfs_minusl_i.BMORT ;
                   lfs_place_o.AKTBMBER  = lfs_minusl_i.BMBER ;
                   lfs_place_o.AKTBMGANG = lfs_minusl_i.BMGANG;
                   lfs_place_o.AKTBMREG  = lfs_minusl_i.BMREG ;
                   lfs_place_o.AKTBMHOR  = lfs_minusl_i.BMHOR ;
                   lfs_place_o.AKTBMVER  = lfs_minusl_i.BMVER ;
                   lfs_place_o.AKTBMSEGM = lfs_minusl_i.BMSEGM;
                   lfs_place_o.AKTBMSEGM = *zero;
                   lfs_place_o.AKTBMIDEN = lfs_minusl_i.BMIDEN;
                   lfs_place_o.AKTBMIDEN = *blank;
                   lfs_place_o.AKTBMLM   = lfs_minusl_i.BMLM  ;
                   lfs_place_o.AKTBMLM   = *zero;
       //          lfs_place_o.AKTBMABKZ = lfs_minusl_i.BMABKZ;
                   if lfs_minusl_i.BMABKZ <> *BLANK;
                      lfs_place_o.AKTBMABKZ = lfs_minusl_i.BMABKZ;
                   endif;
       //          lfs_place_o.AKTBMBMEN = lfs_minusl_i.BMBMEN;
                   lfs_place_o.AKTBMBMEN = lfs_place_o.AKTBMBMEN +
                                           lfs_minusl_i.BMBMEN;
                   #write = '1';
                else;
       //         gültig für upload, derzeit gelagertes Material
                   lfs_place_o.AKTBMKONZ = lfs_minusl_i.BMKONZ;
                   lfs_place_o.AKTBMFIRM = lfs_minusl_i.BMFIRM;
                   lfs_place_o.AKTBMORT  = lfs_minusl_i.BMORT ;
                   lfs_place_o.AKTBMBER  = lfs_minusl_i.BMBER ;
                   lfs_place_o.AKTBMGANG = lfs_minusl_i.BMGANG;
                   lfs_place_o.AKTBMREG  = lfs_minusl_i.BMREG ;
                   lfs_place_o.AKTBMHOR  = lfs_minusl_i.BMHOR ;
                   lfs_place_o.AKTBMVER  = lfs_minusl_i.BMVER ;
                   lfs_place_o.AKTBMSEGM = lfs_minusl_i.BMSEGM;
                   lfs_place_o.AKTBMSEGM = *zero;
                   lfs_place_o.AKTBMIDEN = lfs_minusl_i.BMIDEN;
                   lfs_place_o.AKTBMIDEN = *blank;
                   lfs_place_o.AKTBMLM   = lfs_minusl_i.BMLM  ;
                   lfs_place_o.AKTBMLM   = *zero;
       //          lfs_place_o.AKTBMABKZ = lfs_minusl_i.BMABKZ;
                   if lfs_minusl_i.BMABKZ <> *BLANK;
                      lfs_place_o.AKTBMABKZ = lfs_minusl_i.BMABKZ;
                   endif;
       //          lfs_place_o.AKTBMBMEN = lfs_minusl_i.BMBMEN;
                   lfs_place_o.AKTBMBMEN = lfs_place_o.AKTBMBMEN +
                                           lfs_minusl_i.BMBMEN;
                   #write = '1';
                endif;
             endif;
             reade %kds(lfs_minusl_k:3) lfs_minusl  lfs_minusl_i;
          enddo;
          if #write = '1';
             write PHY03R     lfs_place_o;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //variante 2 alle einzelsätze, derzeit inaktiv da Summierung gewollt
       //derzeitigen Lagerbestand/Ort ermitteln von den
       //Artikeln, die jetzt Hauptartikel sind
       //ggf hier Sortierungsschlüssel später
       //-----------------------------------------------------------------------

       begsr run_local2;

          lfs_minusl_k.bmKONZ   = plpstam_i.LPKONZ;
          lfs_minusl_k.BMIDEN   = lfs_picksl_i.ITEM;
          lfs_minusl_k.bmFIRM   = plpstam_i.LPFIRM;

          setll %kds(lfs_minusl_k:3) lfs_minusl;
          reade %kds(lfs_minusl_k:3) lfs_minusl  lfs_minusl_i;
          dow not %eof(lfs_minusl);
             if lfs_minusl_i.BMIDEN = lfs_picksl_i.ITEM;
       //      gültig für upload, derzeit gelagertes Material
                lfs_place_o.AKTBMKONZ = lfs_minusl_i.BMKONZ;
                lfs_place_o.AKTBMFIRM = lfs_minusl_i.BMFIRM;
                lfs_place_o.AKTBMORT  = lfs_minusl_i.BMORT ;
                lfs_place_o.AKTBMBER  = lfs_minusl_i.BMBER ;
                lfs_place_o.AKTBMGANG = lfs_minusl_i.BMGANG;
                lfs_place_o.AKTBMREG  = lfs_minusl_i.BMREG ;
                lfs_place_o.AKTBMHOR  = lfs_minusl_i.BMHOR ;
                lfs_place_o.AKTBMVER  = lfs_minusl_i.BMVER ;
                lfs_place_o.AKTBMSEGM = lfs_minusl_i.BMSEGM;
                lfs_place_o.AKTBMIDEN = lfs_minusl_i.BMIDEN;
                lfs_place_o.AKTBMLM   = lfs_minusl_i.BMLM  ;
                lfs_place_o.AKTBMABKZ = lfs_minusl_i.BMABKZ;
                lfs_place_o.AKTBMBMEN = lfs_minusl_i.BMBMEN;
                write PHY03R     lfs_place_o;
             endif;
             reade %kds(lfs_minusl_k:3) lfs_minusl  lfs_minusl_i;
          enddo;

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

         eval p_infil   =  'LFS_PLACE' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'LFS_PLACE';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/LFS_PLACE*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed LFS_PLACE              ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object LFS_PLACE                 ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'LFS_PLACE';

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
          status='Error by CVTDBF object LFS_PLACE                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'LFS_PLACE';

       exsr  SR_perfor;

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
           'FORMTYPE(''LFS_PLACE'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'LFS_PLACE';

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

         eval p_infil   =  'LFS_PICKS' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'LFS_PICKS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/LFS_PICKS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed LFS_PICKS*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object LFS_PICKS*                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'LFS_PICKS';

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
          status='Error by CVTDBF object LFS_PICKS                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'LFS_PICKS';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(KOLTHOFF MEIER) DTAAUT(*RWX) ' +
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


