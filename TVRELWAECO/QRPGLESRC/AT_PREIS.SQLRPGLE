
      //************************************************************************
      //
      //      Programmname       AT_PREIS
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Preise Österreich updates
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

     fitemserv  if   e             DISK
     f                                     RENAME(itemserv:PHY01R)
     f                                     usropn
     fteil01    if   e           k DISK

      // PKG
     f#PREIL1   if   e           k disk    RENAME(prei1:log01r)

      // PVK (Artikel)
     f#PREIL3   if   e           k disk    RENAME(prei1:log02r)

     fPRl1UPDOUTo  a e             disk    RENAME(PRl1UPDOUT:PHY02R)

     fPREIUPDOUTo  a e             disk    RENAME(PREIUPDOUT:PHY03R)

     fPRKGUPDOUTo  a e             disk    RENAME(PRKGUPDOUT:PHY04R)

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
       // deliverya genereiren der itemserv (wird im Call bereits initialisiert)
       // ______________________________________________________________________
     D DELIVERYRA      PR                  ExtPgm('DELIVERYRA')
     D p_customer                    10a

       // ______________________________________________________________________
       // PREISE UPDATE PKG
       // ______________________________________________________________________
     D PREIUPDINR      PR                  ExtPgm('PREIUPDINR')

       // ______________________________________________________________________
       // PREISE UPDATE LP1
       // ______________________________________________________________________
     D PRL1UPDINR      PR                  ExtPgm('PRL1UPDINR')

       // ______________________________________________________________________
       // PREISE UPDATE PKG
       // ______________________________________________________________________
     D PRKGUPDINR      PR                  ExtPgm('PRKGUPDINR')


     d itemserv_k    E DS                  ExtName(itemserv:*key)
     d                                     Qualified

     d itemserv_i    E DS                  ExtName(itemserv:*input)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d #PREIL1_k     E DS                  ExtName(#PREIL1:*key)
     d                                     Qualified

     d #PREIL1_i     E DS                  ExtName(#PREIL1:*input)
     d                                     Qualified

     d #PREIL3_k     E DS                  ExtName(#PREIL3:*key)
     d                                     Qualified

     d #PREIL3_i     E DS                  ExtName(#PREIL3:*input)
     d                                     Qualified

     d PRl1UPDOUT_o  E DS                  ExtName(PRl1UPDOUT:*output)
     d                                     Qualified

     d PREIUPDOUT_o  E DS                  ExtName(PREIUPDOUT:*output)
     d                                     Qualified

     d PRKGUPDOUT_o  E DS                  ExtName(PRKGUPDOUT:*output)
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
     D #call           s              1a   inz
     D #073            s             12s 4 inz
     D #073_von        s              8s 0 inz
     D #073_bis        s              8s 0 inz

     D #173            s             12s 4 inz
     D #173_von        s              8s 0 inz
     D #173_bis        s              8s 0 inz

     D #273            s             12s 4 inz
     D #273_von        s              8s 0 inz
     D #273_bis        s              8s 0 inz

     D #373            s             12s 4 inz
     D #373_von        s              8s 0 inz
     D #373_bis        s              8s 0 inz

     D #400            s             12s 4 inz
     D #400_von        s              8s 0 inz
     D #400_bis        s              8s 0 inz

     D #473            s             12s 4 inz
     D #473_von        s              8s 0 inz
     D #473_bis        s              8s 0 inz

     D #PVK            s             12s 4 inz
     D #PVK_von        s              8s 0 inz
     D #PVK_bis        s              8s 0 inz

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0


      // Überschreibungen
      // ______________________________________________________________________
     IPHY01R
     I              status                      §status
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start AT_preise Österreich ermitteln      ';
       exsr      SR_log;

       exsr  srinit;
       err_msg   = '0';
       if err_msg   = '0';
          p_customer = '054939';
          if p_customer = '054939';
             callP DELIVERYRA(p_customer);
          endif;

         exec sql
            delete  FROM itemserv WHERE prodgroup= 'x_x';
          //delete  from itemserv WHERE item not in
          //                      ('ACFC01    ', 'ACFL01    ');

          open itemserv;
          read itemserv itemserv_i;
          dow not %eof(itemserv);
             teil_k.tefirm  =  '01';
             teil_k.tetenr  =  itemserv_i.item;
             if  itemserv_i.item ='9103103391';
                itemserv_i.item ='9103103391';
             endif;
             chain %kds(teil_k:2) teil01 teil_I;
       //    exsr PKG_price;
             exsr PVK_price;
             if %found(teil01) and
       //       itemserv_i.ICS_2     <> teil_I.TESTPR or
       //       itemserv_i.ICS_price <> teil_I.TESTPR;
       //      in ICS_price steht der ermittelte LP1 für Österreich
                ( #PVK           <> itemserv_i.enduserpnj ) or
                (itemserv_i.ICS_2 <> itemserv_i.ICS_price and
                 itemserv_i.pricegroup <> 'PVK');
       //      LP1 in Firma 61 mit uns als Lieferant
       //      ab 14.11.2015 LP1 in Firma 61 ableiten aus
       //      ==> Firma 01 173 PKG
                clear  PRL1UPDOUT_o;
                eval   PRL1UPDOUT_o.company     = '61';
                eval   PRL1UPDOUT_o.item        = teil_I.tetenr;
                eval   PRL1UPDOUT_o.kind        = 'LP1';
                eval   PRL1UPDOUT_o.pvknetto    = teil_I.TESTPR;
       //      ab 14.11.2015 LP1
                eval   PRL1UPDOUT_o.pvknetto    = itemserv_i.ICS_2;
                eval   PRL1UPDOUT_o.fromdat     =
                                (%dec(%char(%date() + %days(001):*iso0):8:0));
                eval   PRL1UPDOUT_o.untildat    =
                                (%dec(%char(%date() + %days(365):*iso0):8:0));
                eval   PRL1UPDOUT_o.untildat    = 00000000;
                eval   PRL1UPDOUT_o.CURRENTCY   = 'EUR';
                eval   PRL1UPDOUT_o.reference   = 'LP1 AT_PREIS ' +
                                                  'itemserv_i ICS_2 ' +
                                                   %char(%timestamp());
                eval   PRL1UPDOUT_o.lieferant   = '000999';
                if itemserv_i.ICS_2 <>itemserv_i.ICS_price;
       //          and  #call = '_';
                   write phy02r     PRL1UPDOUT_o;
                endif;
       //      PVK in Firma 01
       //      ab 14.11.2015 PVK in Firma 61 ableiten aus
       //      ==> Firma 01     PVK    aus ENDUSERPNJ
                clear  PREIUPDOUT_o;
                eval   PREIUPDOUT_o.company     = '61';
                eval   PREIUPDOUT_o.item        = teil_I.tetenr;
                eval   PREIUPDOUT_o.kind        = 'PVK';
                eval   PREIUPDOUT_o.pvknetto    = teil_I.TESTPR;
       //      ==> Firma 01     PVK    aus ENDUSERPNJ
                eval   PREIUPDOUT_o.pvknetto    = itemserv_I.ENDUSERPNJ;
                eval   PREIUPDOUT_o.fromdat     =
                                (%dec(%char(%date() + %days(001):*iso0):8:0));
                eval   PREIUPDOUT_o.untildat    =
                                (%dec(%char(%date() + %days(365):*iso0):8:0));
                eval   PREIUPDOUT_o.untildat    =  00000000;
                eval   PREIUPDOUT_o.CURRENTCY   = 'EUR';
                eval   PREIUPDOUT_o.reference   = 'PVK AT_PREIS ' +
                                                  'itemserv_i ENDUSERPNJ ' +
                                               %char(%timestamp());
                if  #PVK <>itemserv_i.enduserpnj;
                   write phy03r     PREIUPDOUT_o;
                endif;
       //      PKG in Firma 01
       //      ab 14.11.2015 nicht mehr relevant, da über Gruppe 173
       //      und keine eigene Gruppe mehr Hause 13.11.2015
                clear  PRKGUPDOUT_o;
                eval   PRKGUPDOUT_o.company     = '01';
                eval   PRKGUPDOUT_o.item        = teil_I.tetenr;
                eval   PRKGUPDOUT_o.kind        = 'PKG';
                eval   PRKGUPDOUT_o.group       = '473 ';
                eval   PRKGUPDOUT_o.pvknetto    = teil_I.TESTPR;
                eval   PRKGUPDOUT_o.fromdat     =
                                (%dec(%char(%date() + %days(001):*iso0):8:0));
                eval   PRKGUPDOUT_o.untildat    =
                                (%dec(%char(%date() + %days(365):*iso0):8:0));
                eval   PRKGUPDOUT_o.untildat    =  00000000;
                eval   PRKGUPDOUT_o.CURRENTCY   = 'EUR';
                eval   PRKGUPDOUT_o.reference   = 'PKG AT_PREIS TESTPR ' +
                                               %char(%timestamp());
                #call = ' ';
                if #call = '1';
                   write phy04r     PRKGUPDOUT_o;
                endif;
       //      STK in Teilestamm laden über Programm AT_Items !!!!
       //      ab 14.11.2015 nicht mehr relevant, da über Gruppe 173
       //      und keine eigene Gruppe mehr Hause 13.11.2015
             else;
       //   fehlt im Teilestamm
             endif;
          read itemserv itemserv_i;
          enddo;
          close itemserv;

       //PKG Preise verarbeiten
          callP PREIUPDINR();
       //LP1 Preise verarbeiten
          callP PRL1UPDINR();
       //PKG Preise verarbeiten
          callP PRKGUPDINR();
       endif;

       // ______________________________________________________________________

       eval status ='Ende AT_preise Österreich ermitteln     ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************

       //-----------------------------------------------------------------------
       //    current PKG price group
       //-----------------------------------------------------------------------

       begsr PKG_price;

       #073     = *zero;
       #073_von = *zero;
       #073_bis = *zero;
       #173     = *zero;
       #173_von = *zero;
       #173_bis = *zero;
       #273     = *zero;
       #273_von = *zero;
       #273_bis = *zero;
       #373     = *zero;
       #373_von = *zero;
       #373_bis = *zero;
       #400     = *zero;
       #400_von = *zero;
       #400_bis = *zero;
       #473     = *zero;
       #473_von = *zero;
       #473_bis = *zero;

       #PREIL1_k.PRFIRM  =  '61';
       #PREIL1_k.PRBEGR  =  'PKG';
       #PREIL1_k.PRTENR  =  teil_I.tetenr;
       #PREIL1_k.PRWACD  =  'EUR';
       setll %kds(#PREIL1_k:4) #PREIL1;
       reade %kds(#PREIL1_k:4) #PREIL1  #PREIL1_i;
       dow not %eof(#PREIL1);
          if (#preil1_i.PRGADA  < %dec(%char(%date():*iso0):8:0)   or
              #preil1_i.PRGADA  = %dec(%char(%date():*iso0):8:0) )   and
             (#preil1_i.PRGBDA  > %dec(%char(%date():*iso0):8:0)   or
              #preil1_i.PRGBDA  = %dec(%char(%date():*iso0):8:0)   or
              #preil1_i.PRGBDA  =0);
              select;
                 when  #preil1_i.PRKDLG  ='073';
                    #073     = #preil1_i.PREZPR;
                    #073_von = #preil1_i.PRGADA;
                    #073_bis = #preil1_i.PRGBDA;
                 when  #preil1_i.PRKDLG  ='173';
                    #173     = #preil1_i.PREZPR;
                    #173_von = #preil1_i.PRGADA;
                    #173_bis = #preil1_i.PRGBDA;
                 when  #preil1_i.PRKDLG  ='273';
                    #273     = #preil1_i.PREZPR;
                    #273_von = #preil1_i.PRGADA;
                    #273_bis = #preil1_i.PRGBDA;
                 when  #preil1_i.PRKDLG  ='373';
                    #373     = #preil1_i.PREZPR;
                    #373_von = #preil1_i.PRGADA;
                    #373_bis = #preil1_i.PRGBDA;
                 when  #preil1_i.PRKDLG  ='400';
                    #400     = #preil1_i.PREZPR;
                    #400_von = #preil1_i.PRGADA;
                    #400_bis = #preil1_i.PRGBDA;
                 when  #preil1_i.PRKDLG  ='473';
                    #473     = #preil1_i.PREZPR;
                    #473_von = #preil1_i.PRGADA;
                    #473_bis = #preil1_i.PRGBDA;
                 other;
              endsl;
          endif;
          reade %kds(#PREIL1_k:4) #PREIL1  #PREIL1_i;
       enddo;

       endsr;


       //-----------------------------------------------------------------------
       //    current PVK price group
       //-----------------------------------------------------------------------

       begsr PVK_price;

       #PVK     = *zero;
       #PVK_von = *zero;
       #PVK_bis = *zero;

       #PREIL3_k.PRFIRM  =  '61';
       #PREIL3_k.PRBEGR  =  'PVK';
       #PREIL3_k.PRTENR  =  teil_I.tetenr;
       #PREIL3_k.PRWACD  =  'EUR';
       setll %kds(#PREIL3_k:4) #PREIL3;
       reade %kds(#PREIL3_k:4) #PREIL3  #PREIL3_i;
       dow not %eof(#PREIL3);
          if (#preil3_i.PRGADA  < %dec(%char(%date():*iso0):8:0)   or
              #preil3_i.PRGADA  = %dec(%char(%date():*iso0):8:0) )   and
             (#preil3_i.PRGBDA  > %dec(%char(%date():*iso0):8:0)   or
              #preil3_i.PRGBDA  = %dec(%char(%date():*iso0):8:0)   or
              #preil3_i.PRGBDA  =0);
                    #PVK     = #preil3_i.PREZPR;
                    #PVK_von = #preil3_i.PRGADA;
                    #PVK_bis = #preil3_i.PRGBDA;
          endif;
          reade %kds(#PREIL3_k:4) #PREIL3  #PREIL3_i;
       enddo;

       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei KPIF
       //-----------------------------------------------------------------------

       begsr srinit;

       err_msg   = '1';

       mydate = %date();
       days   = %subdt( %date(): *days );
       months = %subdt( %date(): *months );
       years  = %subdt( %date(): *years );
       eofyear= years*10000+12*100+31;

       exec sql
         delete from itemserv;
       exec sql
         delete from PRL1UPDIN;
       exec sql
         delete from PREIUPDIN;
       exec sql
         delete from PRKGUPDIN;
       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       err_msg   = '0';

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'AT_preis  ';
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


