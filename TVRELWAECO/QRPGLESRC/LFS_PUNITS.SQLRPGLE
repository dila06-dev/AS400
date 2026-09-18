
      //************************************************************************
      //
      //      Programmname       LFS_PUNITS
      //      Erstellt  am       30.08.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung
      //
      // ==> TVRELWAECO/LFSUPDIN    gefüllt über LFS_LM.dtt
      //
      //     CPYFRMIMPF FROMFILE(TVRELWAECO/LFSUPDIN)
      //            TOFILE(TVRELWAECO/LFS_LM) MBROPT(*REPLACE)
      //                   FLDDLM(';') DECPNT(*COMMA)
      //                          FROMRCD(2) RPLNULLVAL(*FLDDFT)
      //     27995 Sätze aus Teildatei LFSUPDIN kopiert.
      //
      // insert into   tvrelwaeco/kht_PBM
      // SELECT char(lkiden, 15), char('Palette', 15), zoned(0, 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4),zoned(0, 12, 4), zoned(0, 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4), char(' ', 20),
      // char(BMLMNEU, 10), current  date, current timestamp,
      //   char(' ', 256),             current date, current timestamp FROM
      // TVRELWAECO/lfs_lm
      // 27995 Zeilen in KHT_PBM in TVRELWAECO eingefügt.
      //
      //
      // insert into   tvrelwaeco/kht_PBM
      // SELECT char(lkiden, 15),char('Palette', 15),zoned((MENGELM), 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4),zoned(0, 12, 4), zoned(0, 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4), char(' ', 20),
      // char(BMLMNEU, 10), current  date, current timestamp,
      //   char(' ', 256),             current date, current timestamp FROM
      // TVRELWAECO/lfs_lm
      // 318 Zeilen in KHT_PBM in TVRELWAECO eingefügt.
      //
      //
      //  ... Grunddaten
      // CPYFRMIMPF FROMFILE(TVRELWAECO/CSV_ITEMS) TOFILE(TVRELWAECO/KHT_PBM_EX)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      //
      // insert into   tvrelwaeco/kht_PBM
      // SELECT char(item, 15), char('Palette', 15), zoned(MENGELM*1, 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4),zoned(0, 12, 4), zoned(0, 12,
      // 4),zoned(0, 12, 4), zoned(0, 12, 4), char(' ', 20),
      // char(lm, 10), current  date, current timestamp,
      //   char(' ', 256),  current date, current timestamp FROM
      // TVRELWAECO/KHT_PBM_EX
      // where lm <> 'x' and lm <> ' '
      //
      // insert into  tvrelwaeco/KHT_PBM
      // SELECT char(item, 15), char('kl,Einheit', 15), zoned(MENGEST*1, 12,
      // 4),zoned(LENGTH*1, 12, 4), zoned(WIDTH*1, 12, 4),zoned(HEIGHT*1,
      // 12, 4),zoned(0, 12, 4),zoned(0, 12, 4), zoned(0, 12, 4), char(' ',
      // 20), char(' ', 10), current date, current timestamp, char(' ', 256),
      // current date, current timestamp FROM TVRELWAECO/KHT_PBM_EX
      // where length > 0 and width > 0 and height > 0
      //
      //             monitor;
      //                 callp ExcCmd(%Trim(@CmdStr) :
      //                           %Len(%Trim(@CmdStr)));
      //             on-error;
      //               select;
      //                 when errmsgID = 'CPFA09E';
      //                    callp ExcCmd('DLYJOB DLY(3)':13);
      //                    $count = $count + 1;
      //                    iter;
      //                 other;
      //                    leave;
      //               endsl;
      //             endmon;
      //
      //
      //
      //
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

     fkht_pbm   uf   e             DISK    RENAME(kht_pbmr:PHY01R)
     f                                     USROPN
     f
     fpbfstss   uf   e           K DISK    RENAME(pbfstssf:LOG01R)
     f                                     USROPN
     f
     fteil01    uf   e           K DISK    RENAME(teil1:LOG02R)
     f                                     USROPN
     f
     flbpm01    uf a e           K DISK    RENAME(lbpm1:LOG03R)
     f                                     USROPN

     fPBESTLOL1 uf   e           K DISK    RENAME(Pbestlof:LOG10R)
      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------

      // System-Datenstruktur

       //user
     d LFS_PUNITS      PR
     d p_User                        10a

     d LFS_PUNITS      PI
     d p_User                        10a


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
     d kht_pbm_i     E DS                  ExtName(kht_pbm:*input)
     d                                     Qualified

     d kht_pbm_o     E DS                  ExtName(kht_pbm:*output)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_o     E DS                  ExtName(pbfstss:*output)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified

     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_o      E DS                  ExtName(teil01:*output)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d lbpm01_i      E DS                  ExtName(lbpm01:*input)
     d                                     Qualified

     d lbpm01_o      E DS                  ExtName(lbpm01:*output)
     d                                     Qualified

     d lbpm01_k      E DS                  ExtName(lbpm01:*key)
     d                                     Qualified

     d PBESTLOL1_i   E DS                  ExtName(PBESTLOl1:*input)
     d                                     Qualified

     d PBESTLOL1_k   E DS                  ExtName(PBESTLOl1:*key)
     d                                     Qualified

     d PBESTLOL1_o   E DS                  ExtName(PBESTLOl1:*output)
     d                                     Qualified

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D err_msg         s              1a   inz
     D #error          s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz
     D lademittel      s              3a   inz

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
     D §l              s             12s 4 inz
     D §b              s             12s 4 inz
     D §h              s             12s 4 inz
     D §s              s             04s 0 inz
     D §               s             12s 4 inz
     D sort            s              1a   inz
     D §upd            s              1a   inz
     D §zwf            s             13s 4 inz

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz

      // ______________________________________________________________________
      // Überschreibungen
      // ______________________________________________________________________

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start LFS_Punits ' + p_User;
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //

       if §records <> *zero and
          p_User   =  *blank;
          exsr      SR_request;
          exsr      SR_report;
          exsr      SR_report2;
       endif;

       endif;

       // ______________________________________________________________________

       eval status ='Ende  LFS_PUNITS ' + p_User;
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

       if p_User   =  *blank;
          MONITOR;
          Wrk.var1 =
              'CPYFRMIMPF FROMFILE(TVRELWAECO/KHT_PBMIN) ' +
              'TOFILE(TVRELWAECO/KHT_PBM) MBROPT(*ADD) '  +
              'FLDDLM('';'') DECPNT(*COMMA) ' +
              'FROMRCD(2) RPLNULLVAL(*FLDDFT)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error in command appeared: CPYFRMIMPF             ';
             exsr      SR_log;
          endmon;

          MONITOR;
             Wrk.var1 =
                 'CLRPFM FILE(TVRELWAECO/KHT_PBMIN)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error CLRPFM FILE(TVRELWAECO/KHT_PBMIN)            ';
                exsr      SR_log;
          endmon;
       endif;

       //1. Einzel Menge Stück
          exsr SR_einzel;

       //4. Lademittel
          exsr SR_Ladem;

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



       endsr;

       //-----------------------------------------------------------------------
       //kl,Einheit
       //-----------------------------------------------------------------------

       begsr SR_EINZEL;

          open kht_pbm;
          open pbfstss;
          open teil01;

          read KHT_PBM   KHT_PBM_i;
          dow not %eof(KHT_PBM);
       //für upload
       //       KHT_PBM_i.item     = '9108001034 '  and
       //       %subst(KHT_PBM_i.h4:101:001)  = ' ' and
       //    if %subst(KHT_PBM_i.h4:001:001)  = '1' and

             if %subst(KHT_PBM_i.h4:001:206) = *blank    and
                KHT_PBM_i.UNITVPE  = 'kl,Einheit' and
       //Userabgleich
                p_User = %subst(KHT_PBM_i.h4:207:10);
                KHT_PBM_o  = KHT_PBM_i;
                KHT_PBM_o.h4        = 'E';
       //      Maschine liefert in dm²
       //      für lfs in cm² Volumeneinheiten
                KHT_PBM_i.VOLUME = KHT_PBM_i.VOLUME * 1000;
                if KHT_PBM_i.VOLUME  = *zero;
                   KHT_PBM_i.VOLUME  = (KHT_PBM_i.LENGTH *
                                        KHT_PBM_i.WIDTH  *
                                        KHT_PBM_i.HEIGHT );
                endif;
       //      Maschine liefert in cm
       //      für lfs in mm Längeneinheiten
                KHT_PBM_i.LENGTH = KHT_PBM_i.LENGTH * 10;
                KHT_PBM_i.WIDTH  = KHT_PBM_i.WIDTH  * 10;
                KHT_PBM_i.HEIGHT = KHT_PBM_i.HEIGHT * 10;

       //      Sortierung?
                sort  =  '0';
                §s    =  1;
                if      sort = '1';
                   dow     §s = 1;
                      §s    =  0;
                      if KHT_PBM_i.LENGTH < KHT_PBM_i.WIDTH;
                         §                = KHT_PBM_i.LENGTH;
                         KHT_PBM_i.LENGTH = KHT_PBM_i.WIDTH;
                         KHT_PBM_i.WIDTH  = §;
                         §s    =  1;
                      endif;
                      if KHT_PBM_i.LENGTH < KHT_PBM_i.HEIGHT;
                         §                = KHT_PBM_i.LENGTH;
                         KHT_PBM_i.LENGTH = KHT_PBM_i.HEIGHT;
                         KHT_PBM_i.HEIGHT = §;
                         §s    =  1;
                      endif;
                      if KHT_PBM_i.WIDTH  < KHT_PBM_i.HEIGHT;
                         §                = KHT_PBM_i.WIDTH;
                         KHT_PBM_i.WIDTH  = KHT_PBM_i.HEIGHT;
                         KHT_PBM_i.HEIGHT = §;
                         §s    =  1;
                      endif;
                   enddo;
                endif;

                exsr  sr_2000LFS;
                exsr  SR_2000SCH;
                if p_User <> *blank;
                   exsr  run_stock;
                endif;
                exsr  sr_2000TR;

                KHT_PBM_o.h5        = %date();
                KHT_PBM_o.h6        = %timestamp();
       //update
                update PHY01R    KHT_PBM_o;
                clear            KHT_PBM_o;
             endif;
             read KHT_PBM  KHT_PBM_i;
          enddo;

          close teil01;
          close pbfstss;
          close kht_pbm;

       endsr;

       //-----------------------------------------------------------------------
       //kl,Einheit LFS für DWI
       //-----------------------------------------------------------------------

       begsr SR_2000LFS;

          pbfstss_k.tzkonz = 'EMS';
          pbfstss_k.tzfirm = 'DWI';
          pbfstss_k.tziden = KHT_PBM_i.ITEM;
          chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
          if %found(pbfstss);
       //pbfstss
             pbfstss_o  = pbfstss_i;
             §upd             =  '0';
             if pbfstss_i.TZVLL <> KHT_PBM_i.LENGTH;
                pbfstss_o.TZVLL = KHT_PBM_i.LENGTH ;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZVLB <> KHT_PBM_i.WIDTH;
                pbfstss_o.TZVLB = KHT_PBM_i.WIDTH;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZVLH <> KHT_PBM_i.HEIGHT;
                pbfstss_o.TZVLH = KHT_PBM_i.HEIGHT;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZCM3 <> KHT_PBM_i.VOLUME;
                pbfstss_o.TZCM3 =  KHT_PBM_i.VOLUME;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZBRUT <> KHT_PBM_i.CROSS_W;
                pbfstss_o.TZBRUT =  KHT_PBM_i.CROSS_W;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZNETT <> KHT_PBM_i.nett_W;
                pbfstss_o.TZNETT =  KHT_PBM_i.nett_W;
                §upd             =  '1';
             endif;
             if §upd             =  '1';
                KHT_PBM_o.h4        = '1' + ' ' +
                                      pbfstss_i.TZLM + ' '     +
                                      %char(pbfstss_i.TZVLL)  + ' ' +
                                      %char(pbfstss_i.TZVLB)  + ' ' +
                                      %char(pbfstss_i.TZVLH)  + ' ' +
                                      %char(pbfstss_i.TZMLM)   + ' ' +
                                      %char(pbfstss_i.TZCM3)  + ' ' +
                                      %char(pbfstss_i.TZBRUT) + ' ' +
                                      %char(pbfstss_i.TZNETT) + ' ';
                update LOG01R    pbfstss_o;
             else;
                KHT_PBM_o.h4        = '1 *no changes';
             endif;
          endif;
          unlock pbfstss;

       endsr;

       //-----------------------------------------------------------------------
       //kl,Einheit LFS für SCH ab 13.01.2020 Gang
       //-----------------------------------------------------------------------

       begsr SR_2000SCH;

          pbfstss_k.tzkonz = 'EMS';
          pbfstss_k.tzfirm = 'SCH';
          pbfstss_k.tziden = KHT_PBM_i.ITEM;
          chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
          if %found(pbfstss);
       //pbfstss
             pbfstss_o  = pbfstss_i;
             §upd             =  '0';
             if pbfstss_i.TZVLL <> KHT_PBM_i.LENGTH;
                pbfstss_o.TZVLL = KHT_PBM_i.LENGTH ;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZVLB <> KHT_PBM_i.WIDTH;
                pbfstss_o.TZVLB = KHT_PBM_i.WIDTH;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZVLH <> KHT_PBM_i.HEIGHT;
                pbfstss_o.TZVLH = KHT_PBM_i.HEIGHT;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZCM3 <> KHT_PBM_i.VOLUME;
                pbfstss_o.TZCM3 =  KHT_PBM_i.VOLUME;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZBRUT <> KHT_PBM_i.CROSS_W;
                pbfstss_o.TZBRUT =  KHT_PBM_i.CROSS_W;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZNETT <> KHT_PBM_i.nett_W;
                pbfstss_o.TZNETT =  KHT_PBM_i.nett_W;
                §upd             =  '1';
             endif;
             if §upd             =  '1';
                KHT_PBM_o.h4        = '1' + ' ' +
                                      pbfstss_i.TZLM + ' '     +
                                      %char(pbfstss_i.TZVLL)  + ' ' +
                                      %char(pbfstss_i.TZVLB)  + ' ' +
                                      %char(pbfstss_i.TZVLH)  + ' ' +
                                      %char(pbfstss_i.TZMLM)   + ' ' +
                                      %char(pbfstss_i.TZCM3)  + ' ' +
                                      %char(pbfstss_i.TZBRUT) + ' ' +
                                      %char(pbfstss_i.TZNETT) + ' ';
                update LOG01R    pbfstss_o;
             else;
                KHT_PBM_o.h4        = '1 *no changes';
             endif;
          endif;
          unlock pbfstss;

       endsr;

       //-----------------------------------------------------------------------
       //kl,Einheit Trend
       //-----------------------------------------------------------------------

       begsr SR_2000TR;

          teil01_k.TEFIRM = '01';
          teil01_k.TETENR = KHT_PBM_i.ITEM;
          chain %kds(teil01_k:2) teil01    teil01_I;
          if %found(teil01);
             teil01_o  = teil01_i;
             §upd          =  '0';
             eval(h) §zwf = KHT_PBM_i.VOLUME  /1000000;
             if teil01_i.TEVOLU <> §zwf and
             //Umrechnen jetzt von cm³ auf m³ in Trend
                KHT_PBM_i.VOLUME > *zero;
                eval(h) teil01_o.TEVOLU  =  KHT_PBM_i.VOLUME /1000000;
                if teil01_o.TEVOLU  = *zero;
                   teil01_o.TEVOLU  = 0,0001;
                endif;
                §upd             =  '1';
             endif;
             if teil01_i.TEEANR <> KHT_PBM_i.EAN and
             //kein update zur Zeit!!!!
                KHT_PBM_i.EAN  <> *blank;
                teil01_o.TEEANR  =  KHT_PBM_i.EAN;
                §upd             =  '1';
             endif;
             if teil01_i.tegwbr <> KHT_PBM_i.cross_w and
                KHT_PBM_i.cross_w  <> *zero;
                teil01_o.tegwbr  =  KHT_PBM_i.cross_w;
                §upd             =  '1';
             endif;
             if teil01_i.tegwnt <> KHT_PBM_i.NETT_W and
                KHT_PBM_i.NETT_W  <> *zero;
                teil01_o.tegwnt  =  KHT_PBM_i.NETT_W;
                §upd             =  '1';
             endif;
             //Einheiten in cm in Trend  !!!!!!!!!!!!
             //Achtung db-Beschreibung ist unterschiedlich
             if teil01_i.TELANG <> KHT_PBM_i.LENGTH /10 and
                KHT_PBM_i.LENGTH  <> *zero;
                teil01_o.TELANG  =  KHT_PBM_i.LENGTH /10;
                §upd             =  '1';
             endif;
             if teil01_i.TEBREI <> KHT_PBM_i.WIDTH /10 and
                KHT_PBM_i.WIDTH   <> *zero;
                teil01_o.TEBREI  =  KHT_PBM_i.WIDTH /10;
                §upd             =  '1';
             endif;
             if teil01_i.TEHOHE <> KHT_PBM_i.HEIGHT /10 and
                KHT_PBM_i.HEIGHT  <> *zero;
                teil01_o.TEHOHE  =  KHT_PBM_i.HEIGHT /10;
                §upd             =  '1';
             endif;
             if  §upd      =  '1';
             endif;
             if §upd             =  '1';
                teil01_o.teuser = §§§usr;
                teil01_o.tePROG = §§§pgm;
                teil01_o.tejnam = §§§job;
                teil01_o.tebibl = §§§LIB;
                teil01_o.teJDAT = %dec(%char(%date():*iso0):8:0);
                teil01_o.teJZEI = %dec(%char(%time():*iso0):6:0);
                KHT_PBM_o.h4        = %subst(KHT_PBM_o.h4:001:100) +
                                      '1' + ' ';
       eval status ='bis hier         ' + p_User;
       exsr      SR_log;
             MONITOR;
             Wrk.var1 =
                 'DSPJOBLOG OUTPUT(*PRINT) ';
               cmd = %TrimR(Wrk.Var1);

               l      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error in DSPJOBLOG OUTPUT(*PRINT)';
                exsr      SR_log;
             endmon;
                update(e) LOG02R    teil01_o;
             if %error;
                status = 'TEIL01 UPDATE ERROR STATUS=' +
                         %char(%status(teil01));
                exsr SR_log;
             else;
                status = 'TEIL01 UPDATE OK';
                exsr SR_log;
             endif;








       eval status ='bis hier 2       ' + p_User;
       exsr      SR_log;
             else;
                KHT_PBM_o.h4        = %subst(KHT_PBM_o.h4:001:100) +
                                      '2 *no changes';
             endif;
          endif;
          unlock teil01;

       endsr;

       //-----------------------------------------------------------------------
       //Lademittel
       //-----------------------------------------------------------------------

       begsr SR_Ladem;

          open kht_pbm;
          open pbfstss;
          open lbpm01;

          read KHT_PBM   KHT_PBM_i;
          dow not %eof(KHT_PBM);
       //für upload
             if %subst(KHT_PBM_i.h4:001:206) = *blank    and
       //    if %subst(KHT_PBM_i.h4:101:001)  = ' ' and
       //       KHT_PBM_i.item     = '039001'  and
                KHT_PBM_i.UNITVPE  = 'Palette' and
       //Userabgleich
                p_User = %subst(KHT_PBM_i.h4:207:10);
                KHT_PBM_o  = KHT_PBM_i;
                KHT_PBM_o.h4        = 'E';
                lademittel     = *blank;
       //      Lademitteleingabe über Excel file;
                if KHT_PBM_i.h1 <> *blank;
                   select;
                   when KHT_PBM_i.h1='108';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT =  800/10;
                   when KHT_PBM_i.h1='112       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT = 1200/10;
                   when KHT_PBM_i.h1='116       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT = 1600/10;
                   when KHT_PBM_i.h1='117       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT = 1700/10;
                   when KHT_PBM_i.h1='119       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT = 1900/10;
                   when KHT_PBM_i.h1='122       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  =  800/10;
                      KHT_PBM_i.HEIGHT = 2200/10;
                   when KHT_PBM_i.h1='212       ';
                      KHT_PBM_i.LENGTH = 1000/10;
                      KHT_PBM_i.WIDTH  = 1000/10;
                      KHT_PBM_i.HEIGHT = 1200/10;
                   when KHT_PBM_i.h1='216       ';
                      KHT_PBM_i.LENGTH = 1000/10;
                      KHT_PBM_i.WIDTH  = 1000/10;
                      KHT_PBM_i.HEIGHT = 1600/10;
                   when KHT_PBM_i.h1='219       ';
                      KHT_PBM_i.LENGTH = 1200/10;
                      KHT_PBM_i.WIDTH  = 1000/10;
                      KHT_PBM_i.HEIGHT = 1900/10;
                   when KHT_PBM_i.h1='222       ';
                      KHT_PBM_i.LENGTH = 1000/10;
                      KHT_PBM_i.WIDTH  = 1000/10;
                      KHT_PBM_i.HEIGHT = 2200/10;
                   when KHT_PBM_i.h1='235       ';
                      KHT_PBM_i.LENGTH = 1000/10;
                      KHT_PBM_i.WIDTH  = 1350/10;
                      KHT_PBM_i.HEIGHT = 2200/10;
                   when KHT_PBM_i.h1='236       ';
                      KHT_PBM_i.LENGTH = 1600/10;
                      KHT_PBM_i.WIDTH  = 0800/10;
                      KHT_PBM_i.HEIGHT = 1600/10;
                   when KHT_PBM_i.h1='237       ';
                      KHT_PBM_i.LENGTH = 1410/10;
                      KHT_PBM_i.WIDTH  = 1000/10;
                      KHT_PBM_i.HEIGHT = 2200/10;
                   when KHT_PBM_i.h1='302       ';
                      KHT_PBM_i.LENGTH =  300/10;
                      KHT_PBM_i.WIDTH  =  200/10;
                      KHT_PBM_i.HEIGHT =  100/10;
                   endsl;
                endif;
       //      für lfs in cm² Volumeneinheiten
                KHT_PBM_i.VOLUME  = (KHT_PBM_i.LENGTH *
                                     KHT_PBM_i.WIDTH  *
                                     KHT_PBM_i.HEIGHT );
       //      Maschine liefert in cm
       //      für lfs in mm Längeneinheiten
                KHT_PBM_i.LENGTH = KHT_PBM_i.LENGTH * 10;
                KHT_PBM_i.WIDTH  = KHT_PBM_i.WIDTH  * 10;
                KHT_PBM_i.HEIGHT = KHT_PBM_i.HEIGHT * 10;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT =  800;
                    lademittel = '108';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT = 1200;
                    lademittel = '112';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT = 1600;
                    lademittel = '116';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT = 1700;
                    lademittel = '117';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT = 1900;
                    lademittel = '119';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  =  800    and
                    KHT_PBM_i.HEIGHT = 2200;
                    lademittel = '122';
                endif;
                if  KHT_PBM_i.LENGTH = 1000    and
                    KHT_PBM_i.WIDTH  = 1000    and
                    KHT_PBM_i.HEIGHT = 1200;
                    lademittel = '212';
                endif;
                if  KHT_PBM_i.LENGTH = 1000    and
                    KHT_PBM_i.WIDTH  = 1000    and
                    KHT_PBM_i.HEIGHT = 1600;
                    lademittel = '216';
                endif;
                if  KHT_PBM_i.LENGTH = 1200    and
                    KHT_PBM_i.WIDTH  = 1000    and
                    KHT_PBM_i.HEIGHT = 1900;
                    lademittel = '219';
                endif;
                if  KHT_PBM_i.LENGTH = 1000    and
                    KHT_PBM_i.WIDTH  = 1000    and
                    KHT_PBM_i.HEIGHT = 2200;
                    lademittel = '222';
                endif;
                if  KHT_PBM_i.LENGTH = 1000    and
                    KHT_PBM_i.WIDTH  = 1350    and
                    KHT_PBM_i.HEIGHT = 2200;
                    lademittel = '235';
                endif;
                if  KHT_PBM_i.LENGTH = 1600    and
                    KHT_PBM_i.WIDTH  = 0800    and
                    KHT_PBM_i.HEIGHT = 1600;
                    lademittel = '236';
                endif;
                if  KHT_PBM_i.LENGTH = 1410    and
                    KHT_PBM_i.WIDTH  = 1000    and
                    KHT_PBM_i.HEIGHT = 2200;
                    lademittel = '237';
                endif;
                if  KHT_PBM_i.LENGTH =  300    and
                    KHT_PBM_i.WIDTH  =  200    and
                    KHT_PBM_i.HEIGHT =  100;
                    lademittel = '302';
                endif;
                if lademittel <> *Blank;
                   exsr  sr_5000LFS;
                   exsr  sr_5000SCH;
                   exsr  sr_5000TR;
                endif;
                KHT_PBM_o.h5        = %date();
                KHT_PBM_o.h6        = %timestamp();
       //update
                update PHY01R    KHT_PBM_o;
                clear            KHT_PBM_o;
             endif;
             read KHT_PBM  KHT_PBM_i;
          enddo;

          close lbpm01;
          close pbfstss;
          close kht_pbm;

       endsr;

       //-----------------------------------------------------------------------
       //Lademittel
       //-----------------------------------------------------------------------

       begsr SR_5000LFS;
          pbfstss_k.tzkonz = 'EMS';
          pbfstss_k.tzfirm = 'DWI';
          pbfstss_k.tziden = KHT_PBM_i.ITEM;
          chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
          if %found(pbfstss) and lademittel <> *blank;
       //afrp loop
             pbfstss_o  = pbfstss_i;
             §upd             =  '0';
             if pbfstss_i.TZEAN <> KHT_PBM_i.EAN and
            // kein update zur Zeit!!!!
                KHT_PBM_i.EAN  <> *blank;
                pbfstss_o.TZEAN  =  KHT_PBM_i.EAN;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZLM   <> LADEMITTEL;
                pbfstss_o.TZLM   =  LADEMITTEL;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLL <> KHT_PBM_i.LENGTH;
                pbfstss_o.TZ3VLL =  KHT_PBM_i.LENGTH ;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLB <> KHT_PBM_i.WIDTH;
                pbfstss_o.TZ3VLB =  KHT_PBM_i.WIDTH;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLH <> KHT_PBM_i.HEIGHT;
                pbfstss_o.TZ3VLH =  KHT_PBM_i.HEIGHT;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZMLM  <> KHT_PBM_i.QUANTVPE;
                pbfstss_o.TZMLM  =  KHT_PBM_i.QUANTVPE;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3CM3 <> KHT_PBM_i.VOLUME;
                pbfstss_o.TZ3CM3 =  KHT_PBM_i.VOLUME;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3BRUT <> KHT_PBM_i.CROSS_W;
                pbfstss_o.TZ3BRUT =  KHT_PBM_i.CROSS_W;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3NETT <> KHT_PBM_i.nett_W;
                pbfstss_o.TZ3NETT =  KHT_PBM_i.nett_W;
                §upd             =  '1';
             endif;
             if §upd             =  '1';
                KHT_PBM_o.h4        = '1' + ' ' +
                                      pbfstss_i.TZLM + ' '     +
                                      %char(pbfstss_i.TZ3VLL)  + ' ' +
                                      %char(pbfstss_i.TZ3VLB)  + ' ' +
                                      %char(pbfstss_i.TZ3VLH)  + ' ' +
                                      %char(pbfstss_i.TZMLM)   + ' ' +
                                      %char(pbfstss_i.TZ3CM3)  + ' ' +
                                      %char(pbfstss_i.TZ3BRUT) + ' ' +
                                      %char(pbfstss_i.TZ3NETT) + ' ';
                update LOG01R    pbfstss_o;
             else;
                KHT_PBM_o.h4        = '1 *no changes';
             endif;
          endif;
          unlock pbfstss;

       endsr;

       //-----------------------------------------------------------------------
       //Lademittel Gang 20.01.2020
       //-----------------------------------------------------------------------

       begsr SR_5000SCH;
          pbfstss_k.tzkonz = 'EMS';
          pbfstss_k.tzfirm = 'SCH';
          pbfstss_k.tziden = KHT_PBM_i.ITEM;
          chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
          if %found(pbfstss) and lademittel <> *blank;
       //afrp loop
             pbfstss_o  = pbfstss_i;
             §upd             =  '0';
             if pbfstss_i.TZEAN <> KHT_PBM_i.EAN and
            // kein update zur Zeit!!!!
                KHT_PBM_i.EAN  <> *blank;
                pbfstss_o.TZEAN  =  KHT_PBM_i.EAN;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZLM   <> LADEMITTEL;
                pbfstss_o.TZLM   =  LADEMITTEL;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLL <> KHT_PBM_i.LENGTH;
                pbfstss_o.TZ3VLL =  KHT_PBM_i.LENGTH ;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLB <> KHT_PBM_i.WIDTH;
                pbfstss_o.TZ3VLB =  KHT_PBM_i.WIDTH;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3VLH <> KHT_PBM_i.HEIGHT;
                pbfstss_o.TZ3VLH =  KHT_PBM_i.HEIGHT;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZMLM  <> KHT_PBM_i.QUANTVPE;
                pbfstss_o.TZMLM  =  KHT_PBM_i.QUANTVPE;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3CM3 <> KHT_PBM_i.VOLUME;
                pbfstss_o.TZ3CM3 =  KHT_PBM_i.VOLUME;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3BRUT <> KHT_PBM_i.CROSS_W;
                pbfstss_o.TZ3BRUT =  KHT_PBM_i.CROSS_W;
                §upd             =  '1';
             endif;
             if pbfstss_i.TZ3NETT <> KHT_PBM_i.nett_W;
                pbfstss_o.TZ3NETT =  KHT_PBM_i.nett_W;
                §upd             =  '1';
             endif;
             if §upd             =  '1';
                KHT_PBM_o.h4        = '1' + ' ' +
                                      pbfstss_i.TZLM + ' '     +
                                      %char(pbfstss_i.TZ3VLL)  + ' ' +
                                      %char(pbfstss_i.TZ3VLB)  + ' ' +
                                      %char(pbfstss_i.TZ3VLH)  + ' ' +
                                      %char(pbfstss_i.TZMLM)   + ' ' +
                                      %char(pbfstss_i.TZ3CM3)  + ' ' +
                                      %char(pbfstss_i.TZ3BRUT) + ' ' +
                                      %char(pbfstss_i.TZ3NETT) + ' ';
                update LOG01R    pbfstss_o;
             else;
                KHT_PBM_o.h4        = '1 *no changes';
             endif;
          endif;
          unlock pbfstss;

       endsr;

       //-----------------------------------------------------------------------
       //Lademittel
       //-----------------------------------------------------------------------

       begsr SR_5000TR;

          LBPM01_k.LBPMFIRM = '01';
          LBPM01_k.LBPMTENR = KHT_PBM_i.ITEM;
          chain %kds(LBPM01_k:2) LBPM01    LBPM01_I;
          if %found(LBPM01);
             LBPM01_o  = LBPM01_i;
             §upd          =  '0';
             if LBPM01_i.LBPMVPMI <> lademittel;
                LBPM01_o.LBPMVPMI =  lademittel;
                §upd             =  '1';
             endif;
             if LBPM01_i.LBPMGWBR <> KHT_PBM_i.CROSS_W;
                LBPM01_o.LBPMGWBR =  KHT_PBM_i.CROSS_W;
                §upd             =  '1';
             endif;
             if LBPM01_i.LBPMAZME <> KHT_PBM_i.QUANTVPE;
                LBPM01_o.LBPMAZME =  KHT_PBM_i.QUANTVPE;
                §upd             =  '1';
             endif;
             //Einheiten in cm in Trend
             if LBPM01_i.LBPMLDLA <> KHT_PBM_i.LENGTH /10 and
                KHT_PBM_i.LENGTH  <> *zero;
                LBPM01_o.LBPMLDLA  =  KHT_PBM_i.LENGTH /10;
                §upd             =  '1';
             endif;
             if LBPM01_i.LBPMLDBR <> KHT_PBM_i.WIDTH /10 and
                KHT_PBM_i.WIDTH   <> *zero;
                LBPM01_o.LBPMLDBR  =  KHT_PBM_i.WIDTH /10;
                §upd             =  '1';
             endif;
             if LBPM01_i.LBPMLDHO <> KHT_PBM_i.HEIGHT /10 and
                KHT_PBM_i.HEIGHT  <> *zero;
                LBPM01_o.LBPMLDHO  =  KHT_PBM_i.HEIGHT /10;
                §upd             =  '1';
             endif;
             if  §upd      =  '1';
             endif;
             if §upd             =  '1';
                LBPM01_o.LBPMuser = §§§usr;
                LBPM01_o.LBPMPROG = §§§pgm;
                LBPM01_o.LBPMjnam = §§§job;
                LBPM01_o.LBPMbibl = §§§LIB;
                LBPM01_o.LBPMJDAT = %dec(%char(%date():*iso0):8:0);
                LBPM01_o.LBPMJZEI = %dec(%char(%time():*iso0):6:0);
                LBPM01_o.LBPMTSTP = %timestamp;
                KHT_PBM_o.h4        = %subst(KHT_PBM_o.h4:001:100) +
                                      '1' + ' ';
                update LOG03R    LBPM01_o;
             else;
                KHT_PBM_o.h4        = %subst(KHT_PBM_o.h4:001:100) +
                                      '2 *no changes';
             endif;
          else;
             clear  LBPM01_o;
             LBPM01_o.LBPMFIRM = '01';
             LBPM01_o.LBPMTENR = KHT_PBM_i.ITEM;
             LBPM01_o.LBPMVPMI = lademittel;
             LBPM01_o.LBPMGWBR =  KHT_PBM_i.CROSS_W;
             LBPM01_o.LBPMAZME =  KHT_PBM_i.QUANTVPE;
             //Einheiten in cm in Trend
             LBPM01_o.LBPMLDLA  =  KHT_PBM_i.LENGTH /10;
             LBPM01_o.LBPMLDBR  =  KHT_PBM_i.WIDTH /10;
             LBPM01_o.LBPMLDHO  =  KHT_PBM_i.HEIGHT /10;
             LBPM01_o.LBPMuser = §§§usr;
             LBPM01_o.LBPMPROG = §§§pgm;
             LBPM01_o.LBPMjnam = §§§job;
             LBPM01_o.LBPMbibl = §§§LIB;
             LBPM01_o.LBPMJDAT = %dec(%char(%date():*iso0):8:0);
             LBPM01_o.LBPMJZEI = %dec(%char(%time():*iso0):6:0);
             LBPM01_o.LBPMTSTP = %timestamp;
             KHT_PBM_o.h4        = %subst(KHT_PBM_o.h4:001:100) +
                                    '1' + 'Lademittel Generiert '
                                        + Lademittel;
             write  LOG03R    LBPM01_o;
          endif;
          unlock LBPM01;


       endsr;

       //-----------------------------------------------------------------------
       //Korrektur alte Wareneingänge nicht Lademittelebene
       //-----------------------------------------------------------------------

       begsr run_stock;

          PBESTLOL1_k.bmKONZ  = 'EMS';
          PBESTLOL1_k.bmFIRM  = 'DWI';
          PBESTLOL1_k.BMIDEN  = KHT_PBM_i.ITEM;

          setll %kds(PBESTLOl1_k:3) PBESTLOl1;
          reade %kds(PBESTLOl1_k:3) PBESTLOl1  PBESTLOl1_i;
          dow not %eof(PBESTLOl1);
       //       alert
                if PBESTLOl1_i.BMEGEW <> KHT_PBM_i.CROSS_W;
                   PBESTLOl1_o  = PBESTLOl1_i;
                   PBESTLOl1_o.BMEGEW =  KHT_PBM_i.CROSS_W;
                   eval status = *blank;
                   eval status ='Alert: ' + KHT_PBM_i.ITEM + ' '
                                          + %char(PBESTLOl1_i.BMEGEW)
                                          + ' '
                                          + %char(PBESTLOl1_o.BMEGEW);
                   exsr      SR_log;
        //         if status= ' ';
                      update LOG10R    PBESTLOl1_o;
        //         endif;
                endif;
             reade %kds(PBESTLOl1_k:3) PBESTLOl1   PBESTLOl1_i;
          enddo;

          PBESTLOL1_k.bmKONZ  = 'EMS';
          PBESTLOL1_k.bmFIRM  = 'SCH';
          PBESTLOL1_k.BMIDEN  = KHT_PBM_i.ITEM;

          setll %kds(PBESTLOl1_k:3) PBESTLOl1;
          reade %kds(PBESTLOl1_k:3) PBESTLOl1  PBESTLOl1_i;
          dow not %eof(PBESTLOl1);
       //       alert
                if PBESTLOl1_i.BMEGEW <> KHT_PBM_i.CROSS_W;
                   PBESTLOl1_o  = PBESTLOl1_i;
                   PBESTLOl1_o.BMEGEW =  KHT_PBM_i.CROSS_W;
                   eval status = *blank;
                   eval status ='Alert: ' + KHT_PBM_i.ITEM + ' '
                                          + %char(PBESTLOl1_i.BMEGEW)
                                          + ' '
                                          + %char(PBESTLOl1_o.BMEGEW);
                   exsr      SR_log;
        //         if status= ' ';
                      update LOG10R    PBESTLOl1_o;
        //         endif;
                endif;
             reade %kds(PBESTLOl1_k:3) PBESTLOl1   PBESTLOl1_i;
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

         eval p_infil   =  'LFS_PUNITS' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'LFS_PUNITS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/LFS_PUNITS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed LFS_PUNITS*            ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object LFS_PUNITS*               ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'LFS_PUNITS';

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
          status='Error by CVTDBF object LFS_PUNITS                ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'LFS_PUNITS';

       exsr  SR_perfor;

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''LFS_PUNITS'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'LFS_PUNITS';

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
                     %char(§§§JNO)        +
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


