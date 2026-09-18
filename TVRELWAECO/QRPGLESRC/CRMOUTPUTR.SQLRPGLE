
      //************************************************************************
      //
      //      Programmname       AT_item
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Items  Österreich updates
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      // easy update
      // update             vezu  set vzvtn1='002'
      //                         WHERE VZFIRM ='08'
      // and vzvtn1='024'
      // 546 Zeilen in VEZU in TVPF aktualisiert.
      //
      //
      // wenn Sätzte fehlen oft dann:
      //
      // Referenzsatz
      // insert into qtemp/x
      // SELECT * FROM vezu01 WHERE VZFIRM ='08' and VZBEGR ='VE3' and
      // VZKDLI ='6165919'
      //
      // alle betroffenen Filtern als Kundennummer
      // insert into qtemp/y
      // SELECT KDKDNR FROM kund01 WHERE kdfirm ='08' and kdkdnr not in
      // (select VZKDLI from vezu01 where VZFIRM ='08' and VZBEGR ='VE3')
      //
      // SELECT VZLOCK, VZJNAM, VZJDAT, VZJZEI, VZUSER, VZPROG, VZBIBL,
      // VZFIRM, VZBEGR, VZLAND, kdkdnr, VZVSNR, VZKDLG, VZPRGR, VZVKGB,
      // VZPOLZ, VZTENR, VZWACD, VZGADA, VZGBDA, VZVTN1, VZFR01, VZVTN2,
      // VZFR02, VZVTN3, VZFR03, VZPJNR, VZVTN4, VZVTN5, VZFREX FROM x , y
      // Datei Z in QTEMP wurde erstellt.
      //
      // update z  set vzjdat=20160413
      // update z set vzjzei=100000
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

     fCRMOUTPUT uf a e             DISK    RENAME(CRMOUTPUTr:phy01R)
     f                                     usropn

     fCRMnotesl uf a e           k DISK    RENAME(CRMNOTES:phy02R)
     f                                     usropn
     fkund01    if   e           k DISK

     fkdew01    if   e           k DISK

     fkdvs01    if   e           k DISK

     ftrtp01    if   e           k DISK

     fvezu01    if   e           k DISK

     fvert01    if   e           k DISK

     fkdbw01    if   e           k DISK

     fFOPPK03   if   e           k DISK

     fFPSKTO00  if   e           k DISK

      //------für part2---------------------------------------------------------
     fafkn01    if   e           k DISK

     fafko01    if   e           k DISK

     fafpo09    if   e           k DISK

     fwaeh01    if   e           k DISK

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
       //           CRM Grunddaten

     d CRMOUTPUT_o   E DS                  ExtName(CRMOUTPUT:*output)
     d                                     Qualified

     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
     d                                     Qualified

     d kdew_k        E DS                  ExtName(kdew01:*key)
     d                                     Qualified

     d kdew_i        E DS                  ExtName(kdew01:*input)
     d                                     Qualified

     d kdvs_k        E DS                  ExtName(kdvs01:*key)
     d                                     Qualified

     d kdvs_i        E DS                  ExtName(kdvs01:*input)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified

     d vezu_k        E DS                  ExtName(vezu01:*key)
     d                                     Qualified

     d vezu_i        E DS                  ExtName(vezu01:*input)
     d                                     Qualified

     d vert_k        E DS                  ExtName(vert01:*key)
     d                                     Qualified

     d vert_i        E DS                  ExtName(vert01:*input)
     d                                     Qualified

     d kdbw_k        E DS                  ExtName(kdbw01:*key)
     d                                     Qualified

     d kdbw_i        E DS                  ExtName(kdbw01:*input)
     d                                     Qualified

     d FOPPK03_K     E DS                  ExtName(FOPPK03:*key)
     d                                     Qualified

     d FOPPK03_I     E DS                  ExtName(FOPPK03:*input)
     d                                     Qualified

     d FPSKTO00_k    E DS                  ExtName(FPSKTO00:*key)
     d                                     Qualified

     d FPSKTO00_i    E DS                  ExtName(FPSKTO00:*input)
     d                                     Qualified
      //------------------------------------------------------------------------

     d afkn_k        E DS                  ExtName(afkn01:*key)
     d                                     Qualified

     d afkn_i        E DS                  ExtName(afkn01:*input)
     d                                     Qualified

     d afko_k        E DS                  ExtName(afko01:*key)
     d                                     Qualified

     d afko_i        E DS                  ExtName(afko01:*input)
     d                                     Qualified

     d afpo_k        E DS                  ExtName(afpo09:*key)
     d                                     Qualified

     d afpo_i        E DS                  ExtName(afpo09:*input)
     d                                     Qualified

     d waeh_k        E DS                  ExtName(waeh01:*key)
     d                                     Qualified

     d waeh_i        E DS                  ExtName(waeh01:*input)
     d                                     Qualified

     d CRMnotes_k    E DS                  ExtName(CRMnotesl:*key)
     d                                     Qualified
     d CRMnotes_i    E DS                  ExtName(CRMnotesl:*input)
     d                                     Qualified
     d CRMnotes_o    E DS                  ExtName(CRMnotesl:*output)
     d                                     Qualified

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

     D p_customer      s             10a   inz

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

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz

      // Überschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start CRMOUTPUTR                          ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //Firma 01 teil
          open CRMOUTPUT;
          open CRMnotesl;
          clear            crmoutput_o;
          read kund01 kund_i;
          dow not %eof(kund01);
             IF kund_i.kdfirm = '61';
       //       kund_i.kdkdnr = '197979 ';
                     crmoutput_o.ENTITY     = 'DE411';
       //       kund_i.kdkdnr = '001248 ';
             endif;
             IF kund_i.kdfirm = '08'   and
                kund_i.kdkdnr = '6165919';
                kund_i.kdkdnr = '6165919';
             endif;
             if kund_i.KDKDST <> '90';
                select;
                when kund_i.kdfirm = '01';
                     crmoutput_o.ENTITY     = 'DE411';
                when kund_i.kdfirm = '08';
                     crmoutput_o.ENTITY     = 'BE111';
                when kund_i.kdfirm = '52';
                     crmoutput_o.ENTITY     = 'NL411';
                when kund_i.kdfirm = '55';
                     crmoutput_o.ENTITY     = 'CH412';
                when kund_i.kdfirm = '61';
                     crmoutput_o.ENTITY     = 'AU411';
                other;
                     crmoutput_o.ENTITY     = 'ERROR';
                endsl;
                crmoutput_o.KDKDNR#  =  kund_i.KDKDNR;
                crmoutput_o.KDNAM1#  =  kund_i.KDNAM1;
                crmoutput_o.KDNAM2#  =  kund_i.KDNAM2;
                crmoutput_o.KDNAM3#  =  kund_i.KDNAM3;
                crmoutput_o.KDSTRA#  =  kund_i.KDSTRA;
                crmoutput_o.KDPOLD#  =  kund_i.KDPOLD;
                crmoutput_o.KDPOLZ#  =  kund_i.KDPOLZ;
                crmoutput_o.KDWORT#  =  kund_i.KDWORT;
                crmoutput_o.KDPOFA#  =  kund_i.KDPOFA;
                crmoutput_o.KDKNAM#  =  kund_i.KDKNAM;
                crmoutput_o.KDHINW#  =  kund_i.KDHINW;
                crmoutput_o.KDKDGR#  =  kund_i.KDKDGR;

                crmoutput_o.KDKDB1#  =  kund_i.KDKDB1;
                kdbw_k.kdbwfirm  =  kund_i.kdfirm;
                kdbw_k.KDBWKABC  =  kund_i.KDKDB1;
                chain %kds(kdBW_k:2) kdBw01 kdBw_I;
                if %found(kdbw01);
                   crmoutput_o.KDBWBEZ1 =  kdbw_i.KDBWBEZ1;
                   crmoutput_o.KDBWWERT1=  kdbw_i.KDBWWERT;
                endif;
                crmoutput_o.KDKDB2#  =  kund_i.KDKDB2;
                kdbw_k.kdbwfirm  =  kund_i.kdfirm;
                kdbw_k.KDBWKABC  =  kund_i.KDKDB2;
                chain %kds(kdBW_k:2) kdBw01 kdBw_I;
                if %found(kdbw01);
                   crmoutput_o.KDBWBEZ2 =  kdbw_i.KDBWBEZ1;
                   crmoutput_o.KDBWWERT2=  kdbw_i.KDBWWERT;
                endif;
                crmoutput_o.KDKDB3#  =  kund_i.KDKDB3;
                kdbw_k.kdbwfirm  =  kund_i.kdfirm;
                kdbw_k.KDBWKABC  =  kund_i.KDKDB3;
                chain %kds(kdBW_k:2) kdBw01 kdBw_I;
                if %found(kdbw01);
                   crmoutput_o.KDBWBEZ3 =  kdbw_i.KDBWBEZ1;
                   crmoutput_o.KDBWWERT3=  kdbw_i.KDBWWERT;
                endif;
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'KDGR     ';
                trtp_k.TPTCDE  =  kund_i.KDKDGR;
          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDKDGRS   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDKDGRS   =  'no Text available';
                endif;
                crmoutput_o.KDLANR#  =  kund_i.KDLANR;
                crmoutput_o.KDTLNR#  =  kund_i.KDTLNR;
                crmoutput_o.KDVSBD#  =  kund_i.KDVSBD;
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'VSBD     ';
                trtp_k.TPTCDE  =  kund_i.KDVSBD;
          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDVSBDS   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDVSBDS   =  'no Text available';
                endif;
                crmoutput_o.KDLIBD#  =  kund_i.KDLIBD;
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'LIBD     ';
                trtp_k.TPTCDE  =  kund_i.KDLIBD;
          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDLIBDS   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDLIBDS   =  'no Text available';
                endif;
                crmoutput_o.KDKSTC#  =  kund_i.KDKSTC;
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'KSTC     ';
                trtp_k.TPTCDE  =  kund_i.KDKSTC;
          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDKSTCS   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDKSTCS   =  'no Text available';
                endif;
                crmoutput_o.KDZABD#  =  kund_i.KDZABD;
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'ZABD     ';
                trtp_k.TPTCDE  =  kund_i.KDZABD;
          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDZABDS   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDZABDS   =  'no Text available';
                endif;
                crmoutput_o.KDKDGR#  =  kund_i.KDKDGR;
       //kdvs
                kdvs_k.VSFIRM =  kund_i.kdfirm;
                kdvs_k.VSKDNR =  kund_i.kdkdnr;
                #error    = '1';
                chain %kds(kdvs_k:2) kdvs01 kdvs_I;
                if %found(kdvs01);
                   crmoutput_o.VSNAM1#  =  kdvs_i.VSNAM1;
                   crmoutput_o.VSNAM2#  =  kdvs_i.VSNAM2;
                   crmoutput_o.VSNAM3#  =  kdvs_i.VSNAM3;
                   crmoutput_o.VSSTRA#  =  kdvs_i.VSSTRA;
                   crmoutput_o.VSPOLD#  =  kdvs_i.VSPOLD;
                   crmoutput_o.VSPOLZ#  =  kdvs_i.VSPOLZ;
                   crmoutput_o.VSWORT#  =  kdvs_i.VSWORT;
                   crmoutput_o.VSTLNR#  =  kdvs_i.VSTLNR;
                   crmoutput_o.VSTXNR#  =  kdvs_i.VSTXNR;
       //          crmoutput_o.vzvtn1#  =  kdvs_i.vzvtn1;
                   crmoutput_o.KDNIGB#  =  kund_i.KDNIGB;
                   #error    = '0';
                else;
       //achtung durchlauf treffer
                   #error    = '0';
                endif;

       //kdew
                kdew_k.kdewfirm =  kund_i.kdfirm;
                kdew_k.Kdewkdnr =  kund_i.kdkdnr;
                chain %kds(kdew_k:2) kdew01 kdew_I;
                if %found(kdew01) and #error    = '0';
                   select;
                   when kdew_I.KDEWKSST = '1001    ';
                        crmoutput_o.division  = 'RVOEM   ';
                   when kdew_I.KDEWKSST = '1002    ';
                        crmoutput_o.division = 'RVAM    ';
                   when kdew_I.KDEWKSST = '1003    ';
                        crmoutput_o.division = 'RETL    ';
                   when kdew_I.KDEWKSST = '1004    ';
                        crmoutput_o.division = 'LODG    ';
                   when kdew_I.KDEWKSST = '1005    ';
                        crmoutput_o.division = 'CPVOEM  ';
                   when kdew_I.KDEWKSST = '1006    ';
                        crmoutput_o.division = 'CPVAM   ';
                   when kdew_I.KDEWKSST = '1007    ';
                        crmoutput_o.division = 'MAOEM   ';
                   when kdew_I.KDEWKSST = '1008    ';
                        crmoutput_o.division = 'MAAM    ';
                   when kdew_I.KDEWKSST = '1009    ';
                       if crmoutput_o.ENTITY    = 'DE411'
                       or crmoutput_o.ENTITY    = 'AU411'
                       or crmoutput_o.ENTITY    = 'CH412';
                          crmoutput_o.division  = 'MEDI    ';
                       endif;
                       if crmoutput_o.ENTITY    = 'NL411';
                          crmoutput_o.division  = 'RETL    ';
                       endif;
                       if crmoutput_o.ENTITY    = 'BE111';
                          crmoutput_o.division  = 'LODG    ';
                       endif;
                   when kdew_I.KDEWKSST = '1015    ';
                       crmoutput_o.division  = 'GROUP   ';
                   when kdew_I.KDEWKSST = '1020    ';
                       crmoutput_o.division  = 'OTHER   ';
                   when kdew_I.KDEWKSST = '6050    ';
                       crmoutput_o.division  = 'OTHER   ';
                   other;
                       crmoutput_o.division  = 'ERROR   ';
                   endsl;
                   crmoutput_o.RPMGROUP =  %subst(kdew_I.kDEWRPMG:2:2);
                else;
                   #error    = '1';
                endif;
             if #error    = '0';
                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'KOST     ';
                trtp_k.TPTCDE  =  kdew_I.KDEWKSST;

          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.DIVISIONS = kdew_I.KDEWKSST + ' ' +
                                           trtp_i.TPTTXT;
                else;
                   crmoutput_o.DIVISIONS =  kdew_I.KDEWKSST + ' ' +
                                            'no Text available';
                endif;

                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  '$$WAORPMG';
                trtp_k.TPTCDE  =  '0' +  %subst(kdew_I.kDEWRPMG:2:2);

          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.rpmDESC   =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.rpmDESC   =  'no Text available';
                endif;

                trtp_k.tpfirm  =  kund_i.kdfirm;
                trtp_k.TPSPCD  =  'D';
                trtp_k.TPTART  =  'NIGB     ';
                trtp_k.TPTCDE  =  kund_i.KDNIGB;

          //trtp
                chain %kds(trtp_k:4) trtp01 trtp_I;
                if %found(trtp01);
                   crmoutput_o.KDNIGBDES =  trtp_i.TPTTXT;
                else;
                   crmoutput_o.KDNIGBDES =  'no Text available';
                endif;

                crmoutput_o.h2 = %date();
                crmoutput_o.h3 = %timestamp();
                crmoutput_o.h5 = %date();
                crmoutput_o.h6 = %timestamp();

                vezu_k.vzFIRM  =  kund_i.kdfirm;
                vezu_k.vzbegr  =  'VE3';
                vezu_k.vzland  =  *blank;
                vezu_k.VZKDLI  =  kund_i.kdkdnr;
                if vezu_k.VZKDLI  =  '001248' or
                   vezu_k.VZKDLI  =  '197979';
                   vezu_k.VZKDLI  =  kund_i.kdkdnr;
                endif;
                setll %kds(vezu_k:4) vezu01;
                reade %kds(vezu_k:4) vezu01  vezu_i;
                dow not %eof(vezu01);
                   #ERRORS  = *blank;
                   GoodDateV='1';
                   GoodDateB='1';
                   monitor;
                      Date_in_V=%date(%char(vezu_i.VZGADA):*iso0);
                         On-error *all;
                         GoodDateV='0';
                         eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                      %char(vezu_i.VZGADA) ;
                   endmon;

                   if vezu_i.VZGBDA<> 0;
                   monitor;
                      Date_in_B=%date(%char(vezu_i.VZGBDA):*iso0);
                         On-error *all;
                         GoodDateB='0';
                         eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                      %char(vezu_i.VZGADA) ;
                   endmon;
                   endif;

                   if Date_in_V > %date() + %days(1) and GoodDateV='1';
                      eval #ERRORS ='Von Datum zu groß  ' +
                                                %char(Date_in_V);
                   endif;

                   if (Date_in_B <  Date_in_V + %days(1) and
                       vezu_i.VZGBDA<> 0              and GoodDateB='1')
                       or
                      (Date_in_B <  %date() + %days(1) and
                       vezu_i.VZGBDA<> 0              and GoodDateB='1');
                      eval #ERRORS ='Bis Datum zu klein '    +
                                             %char(Date_in_B);
                   endif;

                   if kund_i.kdfirm ='61';
                      #errors = *blank;
                   endif;

                   if #errors = *blank;
                      crmoutput_o.vzvtn1#  =  vezu_i.vzvtn1;
                      crmoutput_o.vzvtn2#  =  vezu_i.vzvtn2;
                      crmoutput_o.vzvtn3#  =  vezu_i.vzvtn3;
                      crmoutput_o.vzvtn4#  =  vezu_i.vzvtn4;
                      crmoutput_o.vzvtn5#  =  vezu_i.vzvtn5;
                      //vert
                      vert_k.vtfirm  =  vezu_i.vzfirm;
                      vert_k.vtvtnr  =  vezu_i.vzvtn1;
                      chain %kds(vert_k:2) vert01 vert_I;
                      if %found(vert01);
                         crmoutput_o.VTNAM1#   =  vert_i.VTNAM1;
                      else;
                         crmoutput_o.VTNAM1#   =  *blank;
                      endif;
                      vert_k.vtfirm  =  vezu_i.vzfirm;
                      vert_k.vtvtnr  =  vezu_i.vzvtn2;
                      chain %kds(vert_k:2) vert01 vert_I;
                      if %found(vert01);
                         crmoutput_o.VTNAM2#   =  vert_i.VTNAM1;
                      else;
                         crmoutput_o.VTNAM2#   =  *blank;
                      endif;
                      vert_k.vtfirm  =  vezu_i.vzfirm;
                      vert_k.vtvtnr  =  vezu_i.vzvtn3;
                      chain %kds(vert_k:2) vert01 vert_I;
                      if %found(vert01);
                         crmoutput_o.VTNAM3#   =  vert_i.VTNAM1;
                      else;
                         crmoutput_o.VTNAM3#   =  *blank;
                      endif;
                      vert_k.vtfirm  =  vezu_i.vzfirm;
                      vert_k.vtvtnr  =  vezu_i.vzvtn4;
                      chain %kds(vert_k:2) vert01 vert_I;
                      if %found(vert01);
                         crmoutput_o.VTNAM4#   =  vert_i.VTNAM1;
                      else;
                         crmoutput_o.VTNAM4#   =  *blank;
                      endif;
                      vert_k.vtfirm  =  vezu_i.vzfirm;
                      vert_k.vtvtnr  =  vezu_i.vzvtn5;
                      chain %kds(vert_k:2) vert01 vert_I;
                      if %found(vert01);
                         crmoutput_o.VTNAM5#   =  vert_i.VTNAM1;
                      else;
                         crmoutput_o.VTNAM5#   =  *blank;
                      endif;

                      exsr schilling;
                      exsr orders;

                      §search              = ';';
                      §string              = crmoutput_o.KDNAM1#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.kdnam1# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDNAM2#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.kdnam2# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDNAM3#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.kdnam3# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDSTRA#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.KDSTRA# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDWORT#;
                      §replace             = ',';
                      exsr      scanstr;
                      crmoutput_o.KDWORT# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDKNAM#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.KDKNAM# = §string;
                      §search              = ';';
                      §string              = crmoutput_o.KDHINW#;
                      §replace             = ' ';
                      exsr      scanstr;
                      crmoutput_o.KDHINW# = §string;
                      write phy01r     crmoutput_o;
                      exsr             #crmnotes;
                   endif;

                   reade %kds(vezu_k:4) vezu01 vezu_i;

                enddo;

             if kund_i.kdfirm = '61';
                exsr schilling;
                exsr orders;
                §search              = ';';
                §string              = crmoutput_o.KDNAM1#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.kdnam1# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDNAM2#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.kdnam2# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDNAM3#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.kdnam3# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDSTRA#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.KDSTRA# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDWORT#;
                §replace             = ',';
                exsr      scanstr;
                crmoutput_o.KDWORT# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDKNAM#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.KDKNAM# = §string;
                §search              = ';';
                §string              = crmoutput_o.KDHINW#;
                §replace             = ' ';
                exsr      scanstr;
                crmoutput_o.KDHINW# = §string;
                write phy01r     crmoutput_o;
                exsr             #crmnotes;
             endif;

             endif;
             clear            crmoutput_o;
             read kund01     kund_i;
             else;
             read kund01     kund_i;
             endif;
          enddo;

          close CRMOUTPUT;
          close crmnotesl;
          exsr      SR_report;

       endif;

       // ______________________________________________________________________

       eval status ='CRMOUTPUTR                              ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************

       //-----------------------------------------------------------------------
       //Buchungswerte
       //-----------------------------------------------------------------------

       begsr schilling;

          FOPPK03_k.OPKTO        = '100000000';
          FPSKTO00_k.P0KTO       = '100000000';
          select;
          when kund_i.kdfirm = '01';
               FOPPK03_k.OPFA     =   51;
               FPSKTO00_k.P0FA    =   51;
               %subst(FOPPK03_k.OPKTO:2:6)  = %subst(kund_i.KDKDNR:1:6);
               %subst(FPSKTO00_k.P0KTO:2:6) = %subst(kund_i.KDKDNR:1:6);
          when kund_i.kdfirm = '08';
               FOPPK03_k.OPFA     =   08;
               FPSKTO00_k.P0FA    =   08;
               %subst(FOPPK03_k.OPKTO:2:7)  = %subst(kund_i.KDKDNR:1:7);
               %subst(FPSKTO00_k.P0KTO:2:7) = %subst(kund_i.KDKDNR:1:7);
          when kund_i.kdfirm = '52';
               FOPPK03_k.OPFA     =   52;
               FPSKTO00_k.P0FA    =   52;
               %subst(FOPPK03_k.OPKTO:2:7)  = %subst(kund_i.KDKDNR:1:7);
               %subst(FPSKTO00_k.P0KTO:2:7) = %subst(kund_i.KDKDNR:1:7);
          when kund_i.kdfirm = '55';
               FOPPK03_k.OPFA     =   55;
               FPSKTO00_k.P0FA    =   55;
               %subst(FOPPK03_k.OPKTO:2:5)  = %subst(kund_i.KDKDNR:1:5);
               %subst(FPSKTO00_k.P0KTO:2:5) = %subst(kund_i.KDKDNR:1:5);
          when kund_i.kdfirm = '61';
               FOPPK03_k.OPFA     =   61;
               FPSKTO00_k.P0FA    =   61;
               %subst(FOPPK03_k.OPKTO:2:6)  = %subst(kund_i.KDKDNR:1:6);
               %subst(FPSKTO00_k.P0KTO:2:6) = %subst(kund_i.KDKDNR:1:6);
          other;
               FOPPK03_k.OPFA    =   *zero;
               FPSKTO00_k.P0FA    =  *zero;
          endsl;

          FOPPK03_k.OPOPAR       = *blank;

       // FOPPK03_k.OPBGJT       = (%dec(%char(%date()- %days(365):*iso0):8:0));
          FOPPK03_k.OPBGJT       = (%char(%date()- %days(365):*iso0));
       //             receivable  and due
          setll %kds(FOPPK03_k:4) FOPPK03;
          reade %kds(FOPPK03_k:3) FOPPK03 FOPPK03_i;
          dow not %eof(FOPPK03);
             if FOPPK03_i.OPstat <> '7';
                crmoutput_o.receivable = crmoutput_o.receivable +
                                         FOPPK03_i.OPURDM;
             if FOPPK03_i.OPFLJT < (%char(%date()- %days(0):*iso0));
                crmoutput_o.dueamount  = crmoutput_o.dueamount +
                                         FOPPK03_i.OPURDM;
             endif;
             endif;
          reade %kds(FOPPK03_k:3) FOPPK03 FOPPK03_i;
          enddo;

          chain %kds(FPSKTO00_k:2) FPSKTO00  FPSKTO00_I;
          if %found(FPSKTO00);
             crmoutput_o.CCLINE   =  FPSKTO00_i.P0L1;
          else;
             crmoutput_o.CCLINE   =  *zero;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //orders
       //-----------------------------------------------------------------------

       begsr orders;

          clear  #openquan;
          clear  #expected;
          afpo_k.apfirm  =  kund_i.kdfirm;
          afpo_k.apkdnr  =  kund_i.kdkdnr;
       //   afpo Positionen                afkn_i.anwtnt
          setll %kds(afpo_k:2) afpo09;
          reade %kds(afpo_k:2) afpo09  afpo_i;
             dow not %eof(afpo09);
                if afpo_i.apafst < '81';
                   afko_k.akfirm  =  afpo_i.APFIRM;
                   afko_k.akafjj  =  afpo_i.APAFJJ;
                   afko_k.AKAFNR  =  afpo_i.APAFNR;
                   chain %kds(afko_k:3) afko01 afko_I;
                   if %found(afko01) and
                       afko_i.AKAFST < '90';
                       if afpo_i.apafnr ='667705';
                          #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       endif;
                       #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       if afpo_i.APWACD <> 'EUR';
                          waeh_k.WAFIRM  =  afpo_i.apfirm;
                          waeh_k.WASTWC  =  'EUR';
                          waeh_k.WAWACD  =  afpo_i.APWACD;
                          waeh_k.WAGADA  =  (%dec(%char(%date():*iso0):8:0));
                          setgt %kds(WAEH_k:4) WAEH01;
                          readp waeh01  waeh_i;
                          dow not %eof(WAEH01)                  and
                             waeh_i.WAFIRM = afpo_i.apfirm      and
                             waeh_i.WASTWC = 'EUR'              and
                             waeh_i.WAWACD = afpo_i.APWACD;
                             #expected =          (#openquan*afpo_i.APPREI
                                         *waeh_i.wakurs);
                             readp waeh01  waeh_i;
                          enddo;
                       else;
                          #expected =          (#openquan*afpo_i.APPREI);
                       endif;
                   endif;
                endif;
                reade %kds(afpo_k:2) afpo09 afpo_i;
             enddo;
             crmoutput_o.OPORDER = #expected;

       endsr;

       //-----------------------------------------------------------------------
       //%scan Zeichen(§search) ersetzten durch(§replace) in string(§string)
       //-----------------------------------------------------------------------

       begsr scanstr;

             §pos                 = 0 ;

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

       //           CRMOUTPUT
       exec sql
         delete from tvrelwaeco/CRMOUTPUT;

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //crmnotes
       //-----------------------------------------------------------------------

       begsr #crmnotes;

       crmnotes_k.ENTITY     =  crmoutput_o.ENTITY;
       crmnotes_k.KDKDNR#    =  crmoutput_o.KDKDNR#;
       chain %kds(crmnotes_k:2) crmnotesl crmnotes_I;
       if %found(crmnotesl);
          if crmoutput_o.ENTITY      <> crmnotes_i.ENTITY        or
             crmoutput_o.KDKDNR#     <> crmnotes_i.KDKDNR#       or
             crmoutput_o.KDNAM1#     <> crmnotes_i.KDNAM1#       or
             crmoutput_o.KDNAM2#     <> crmnotes_i.KDNAM2#       or
             crmoutput_o.KDNAM3#     <> crmnotes_i.KDNAM3#       or
             crmoutput_o.KDSTRA#     <> crmnotes_i.KDSTRA#       or
             crmoutput_o.KDPOLD#     <> crmnotes_i.KDPOLD#       or
             crmoutput_o.KDPOLZ#     <> crmnotes_i.KDPOLZ#       or
             crmoutput_o.KDWORT#     <> crmnotes_i.KDWORT#       or
             crmoutput_o.KDPOFA#     <> crmnotes_i.KDPOFA#       or
             crmoutput_o.KDKNAM#     <> crmnotes_i.KDKNAM#       or
             crmoutput_o.KDHINW#     <> crmnotes_i.KDHINW#       or
             crmoutput_o.KDLANR#     <> crmnotes_i.KDLANR#       or
             crmoutput_o.KDTLNR#     <> crmnotes_i.KDTLNR#       or
             crmoutput_o.VZVTN1#     <> crmnotes_i.VZVTN1#       or
             crmoutput_o.VTNAM1#     <> crmnotes_i.VTNAM1#       or
             crmoutput_o.VZVTN2#     <> crmnotes_i.VZVTN2#       or
             crmoutput_o.VTNAM2#     <> crmnotes_i.VTNAM2#       or
             crmoutput_o.VZVTN3#     <> crmnotes_i.VZVTN3#       or
             crmoutput_o.VTNAM3#     <> crmnotes_i.VTNAM3#       or
             crmoutput_o.VZVTN4#     <> crmnotes_i.VZVTN4#       or
             crmoutput_o.VTNAM4#     <> crmnotes_i.VTNAM4#       or
             crmoutput_o.VZVTN5#     <> crmnotes_i.VZVTN5#       or
             crmoutput_o.VTNAM5#     <> crmnotes_i.VTNAM5#       or
             crmoutput_o.VSNAM1#     <> crmnotes_i.VSNAM1#       or
             crmoutput_o.VSNAM2#     <> crmnotes_i.VSNAM2#       or
             crmoutput_o.VSNAM3#     <> crmnotes_i.VSNAM3#       or
             crmoutput_o.VSSTRA#     <> crmnotes_i.VSSTRA#       or
             crmoutput_o.VSPOLD#     <> crmnotes_i.VSPOLD#       or
             crmoutput_o.VSPOLZ#     <> crmnotes_i.VSPOLZ#       or
             crmoutput_o.VSWORT#     <> crmnotes_i.VSWORT#       or
             crmoutput_o.VSTLNR#     <> crmnotes_i.VSTLNR#       or
             crmoutput_o.VSTXNR#     <> crmnotes_i.VSTXNR#       or
             crmoutput_o.KDKDGR#     <> crmnotes_i.KDKDGR#       or
             crmoutput_o.KDKDGRS     <> crmnotes_i.KDKDGRS       or
             crmoutput_o.KDKSTC#     <> crmnotes_i.KDKSTC#       or
             crmoutput_o.KDKSTCS     <> crmnotes_i.KDKSTCS       or
             crmoutput_o.KDVSBD#     <> crmnotes_i.KDVSBD#       or
             crmoutput_o.KDVSBDS     <> crmnotes_i.KDVSBDS       or
             crmoutput_o.KDLIBD#     <> crmnotes_i.KDLIBD#       or
             crmoutput_o.KDLIBDS     <> crmnotes_i.KDLIBDS       or
             crmoutput_o.KDZABD#     <> crmnotes_i.KDZABD#       or
             crmoutput_o.KDZABDS     <> crmnotes_i.KDZABDS       or
             crmoutput_o.KDGRON#     <> crmnotes_i.KDGRON#       or
             crmoutput_o.KDNIGB#     <> crmnotes_i.KDNIGB#       or
             crmoutput_o.KDNIGBDES   <> crmnotes_i.KDNIGBDES     or
             crmoutput_o.DIVISION    <> crmnotes_i.DIVISION      or
             crmoutput_o.DIVISIONS   <> crmnotes_i.DIVISIONS     or
             crmoutput_o.RPMGROUP    <> crmnotes_i.RPMGROUP      or
             crmoutput_o.RPMDESC     <> crmnotes_i.RPMDESC       or
             crmoutput_o.TURNOVER    <> crmnotes_i.TURNOVER      or
             crmoutput_o.CURRENCY    <> crmnotes_i.CURRENCY      or
             crmoutput_o.TURNOVERE   <> crmnotes_i.TURNOVERE     or
             crmoutput_o.CCLINE      <> crmnotes_i.CCLINE        or
             crmoutput_o.OPORDER     <> crmnotes_i.OPORDER       or
             crmoutput_o.RECEIVABLE  <> crmnotes_i.RECEIVABLE    or
             crmoutput_o.DUEAMOUNT   <> crmnotes_i.DUEAMOUNT     or
             crmoutput_o.KDKDB1#     <> crmnotes_i.KDKDB1#       or
             crmoutput_o.KDBWBEZ1    <> crmnotes_i.KDBWBEZ1      or
             crmoutput_o.KDBWWERT1   <> crmnotes_i.KDBWWERT1     or
             crmoutput_o.KDKDB2#     <> crmnotes_i.KDKDB2#       or
             crmoutput_o.KDBWBEZ2    <> crmnotes_i.KDBWBEZ2      or
             crmoutput_o.KDBWWERT2   <> crmnotes_i.KDBWWERT2     or
             crmoutput_o.KDKDB3#     <> crmnotes_i.KDKDB3#       or
             crmoutput_o.KDBWBEZ3    <> crmnotes_i.KDBWBEZ3      or
             crmoutput_o.KDBWWERT3   <> crmnotes_i.KDBWWERT3     or
             crmoutput_o.#INFO       <> crmnotes_i.#INFO         or
             crmoutput_o.ENTITY      <> crmnotes_i.ENTITY;
             crmnotes_o     = crmoutput_o;
             update PHY02R    crmnotes_o;
          endif;
       else;
          crmnotes_o    =  crmoutput_o;
          write phy02r     crmnotes_o;
       endif;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_report;

         eval p_infil   =  'CRMOUTPUT' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'CRMOUTPUT';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/SALESCOMPANY/crmoutput*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'CRMOUTPUT';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object CRMOUTPUT                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'CRMOUTPUT';

       //kein run aufgrund der grösse
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''CRMOUTPUTR'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'CRMOUTPUT';

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


