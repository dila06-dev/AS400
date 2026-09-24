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
      * SELECT APFIRM, APAFAT,APAFJJ, APAFNR, APAFPO, 0 , APKDNR, APVSBD,
      * APLIBD,apvpei, APLANR, APLORT , APKMJK, APKMTE, APTENR,APMEIN ,
      * current date apdate, current timestamp aptstamp,char(' ') apstatus
      * , char('250') referenz
      * FROM afpo WHERE apfirm='01' and apafjj=2016
      *//Prüfen aus welchem Feld
      *//01-03 check up Auftragsarten Prüfung 1           Datei AFKO
      *//11-12
      *//Prüfen quantity check
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
     f
     fab64l1    uf   e             DISK    RENAME(ab64:PHY01R)
     f                                     USROPN
     f
     fpbfstss   if   e           K DISK    RENAME(pbfstssf:LOG01R)
     f                                     USROPN
     f
     fteil01    if   e           K DISK    RENAME(teil1:LOG02R)
     f
     fafko01    if   e           K DISK    RENAME(afko1:LOG03R)
     f
     fafpo01    if   e           K DISK    RENAME(afpo1:LOG04R)
     f
     ftrtp01    if   e           k DISK
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

     d ab64l1_i      E DS                  ExtName(ab64l1:*input)
     d                                     Qualified

     d ab64l1_o      E DS                  ExtName(ab64l1:*output)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified


     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d afpo01_i      E DS                  ExtName(afpo01:*input)
     d                                     Qualified

     d afpo01_k      E DS                  ExtName(afpo01:*key)
     d                                     Qualified

     d afko01_i      E DS                  ExtName(afko01:*input)
     d                                     Qualified

     d afko01_k      E DS                  ExtName(afko01:*key)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D P_cc            s              1A   inz
     D schilgen        s              1A   inz
     D edc             s              1A   inz
     D silfox          s              1A   inz
     D §schilgen       s              1s 0 inz
     D §edc            s              1s 0 inz
     D §silfox         s              1s 0 inz
     D §Lager          s              2s 0 inz
     D §fieldname      s             40A   inz
     D §APFIRM         s              2A   inz
     D §APAFJJ         s              4s 0 inz
     D §APAFNR         s              6A   inz
     D §AKLIAR         s              1A   inz
     D §complete       s              1s 0 inz
     D §standard       s             10a   inz
     D rep             s              1a   inz

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0
     d nowdate         s              8s 0
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

      /FREE
       //:::

       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(GANG) POSITION(*LAST)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDLIBLE LIB(GANG) POSITION(*LAST)';
             exsr      SR_log;
       endmon;

       eval status ='Start TRKOMLFSR                         ';
       Exsr      sr_log;
       exsr  srinit;

          open pbfstss;
          open ab64l1;

          read ab64l1   ab64l1_i;
          §APFIRM =  ab64l1_i.sqFIRM;
          §APAFJJ =  ab64l1_i.sqAFJJ;
          §APAFNR =  ab64l1_i.sqAFNR;
          dow not %eof(ab64l1);
       //für upload

       //   zur Bearbeitung anstehend
             if ab64l1_i.sqstatus = *blank and
                (ab64l1_i.sqAFNR = '600010' or
                 ab64l1_i.sqAFNR = '600011' or
                 ab64l1_i.sqAFNR = '600012' or
                 ab64l1_i.sqAFNR = '600013' or
                 ab64l1_i.sqAFNR = '600014' or
                 ab64l1_i.sqAFNR = '600015' or
                 ab64l1_i.sqAFNR = '600016' or
                 ab64l1_i.sqAFNR = '600017');
                ab64l1_o  = ab64l1_i;
                if §APFIRM <> ab64l1_i.sqFIRM  or
                   §APAFJJ <> ab64l1_i.sqAFJJ  or
                   §APAFNR <> ab64l1_i.sqAFNR;
                   §lager = §edc+§schilgen+§silfox;
       //         mehrere Lager wurden angesprochen
       //         der Auftrag muss übersteuert werden
       //         er wird über EDC abgewickelt
       //Achtung wir brauchen noch eine Bedingung Achtung !!!!!!!!!
       //         check up Teillieferung  J ==> NUR KOMPLETT LIEFERN!!!
                   if §lager > 1 and  §akliar         = 'J';
       //            ggf. muss bei Komplettlieferung das Lager im Falle
       //            von mehreren Zuordnungen das dort abgelegte Lager
       //            genommen werden. Standard erhält neue Zuordnung
                      trtp_k.TPTCDE  =  §akliar;
                      §fieldname = 'AKLIAR    ';
                      exsr  SR_trtp;
                      select;
                      when trtp_i.tptnum = 1;
                         §standard            = 'EDC     ';
                      when trtp_i.tptnum = 2;
                         §standard            = 'Schilgen';
                      when trtp_i.tptnum = 3;
                         §standard            = 'Silfox  ';
                      other;
                         §standard            = 'EDC     ';
                      endsl;
       //            Abhängige Werte werden initialisiert z.B. edc
                      §akliar         = ' ';
                   endif;
                   If §lager > 1 and §complete = 1;
                      exec sql
                         update qtemp/ab64 b
                         set b.sqlort = :§STANDARD
                         where sqFIRM = :§APFIRM and
                               sqAFJJ = :§APAFJJ and
                               sqAFNR = :§APAFNR;
                   endif;
       //         Auftragskopfebene Initialisierung
                   §edc      = 0;
                   §schilgen = 0;
                   §silfox   = 0;
                   §APFIRM =  ab64l1_i.sqFIRM;
                   §APAFJJ =  ab64l1_i.sqAFJJ;
                   §APAFNR =  ab64l1_i.sqAFNR;
                   §lager    = 0;
                endif;

       //Positionsebene
                edc      = '0';
                schilgen = '0';
                silfox   = '0';

       //afko lesen für Prüfungen
                exsr  sr_afko;
       //   Protokoll, Entscheidung ist am Ende des Auftrags repräsentativ
       //   für alle beteiligten Positionen
       //   AKLIAR     1 J
                rep = ' ';
                %subst(#ab64l1_o.REFERENZ:160:14)='AKLIAR    ' +
                  ' ' + rep + ' ' + afko01_I.AKLIAR;
       //   Protokoll, Entscheidung ist am Ende des Auftrags repräsentativ
       //   für alle beteiligten Positionen
       //   COMPLETE   1 J
                rep = ' ';
                %subst(#ab64l1_o.REFERENZ:175:25)='COMPLETE  ' +
                  ' ' + %char(§complete) + ' ' + §standard;
       //afpo lesen
                exsr  sr_afpo;

       //Standardverhalten
                select;
                when edc      = '1';
                   ab64l1_i.sqlort    = 'EDC     ';
                   §edc     =  1 ;
                when schilgen = '1';
                   ab64l1_i.sqlort    = 'Schilgen';
                   §schilgen=  1 ;
                when silfox   = '1';
                   ab64l1_i.sqlort    = 'Silfox  ';
                   §silfox  =  1 ;
                other;
                   ab64l1_i.sqlort    = 'EDC     ';
                   §edc     =  1 ;
                endsl;
       //Ausnahmen vom Standard hier:

       //Protokoll
                ab64l1_i.sqDATE    = %date();
                ab64l1_i.sqTSTAMP  = %timestamp();
       //update
                update PHY01R    ab64l1_o;
                clear            ab64l1_o;
             endif;
             read ab64l1    ab64l1_i;
          enddo;

       //Abschluss Nacharbeit
          §lager = §edc+§schilgen+§silfox;
       //mehrere Lager wurden angesprochen
       //der Auftrag muss übersteuert werden
       //er wird über EDC abgewickelt
       //Achtung wir brauchen noch eine Bedingung Achtung !!!!!!!!!
          if §lager > 1 and  §akliar         = 'J';
       //   ggf. muss bei Komplettlieferung das Lager im Falle
       //   von mehreren Zuordnungen das dort abgelegte Lager
       //   genommen werden. Standard erhält neue Zuordnung
             trtp_k.TPTCDE  =  §akliar;
             §fieldname = 'AKLIAR    ';
             exsr  SR_trtp;
             select;
             when trtp_i.tptnum = 1;
                §standard            = 'EDC     ';
             when trtp_i.tptnum = 2;
                §standard            = 'Schilgen';
             when trtp_i.tptnum = 3;
                §standard            = 'Silfox  ';
             other;
                §standard            = 'EDC     ';
             endsl;
       //   Abhängige Werte werden initialisiert z.B. edc
             §akliar         = ' ';
          endif;
          If §lager > 1 and §complete = 1;
             exec sql
                update qtemp/ab64 b
                set b.sqlort = :§STANDARD
                where sqFIRM = :§APFIRM and
                      sqAFJJ = :§APAFJJ and
                      sqAFNR = :§APAFNR;
          endif;

          close ab64l1;
          close pbfstss;

       //eoj

       MONITOR;
          Wrk.var1 =
              'RMVLIBLE LIB(DOMDATV7)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error RMVLIBLE LIB(DOMDATV7)                ';
             exsr      SR_log;
       endmon;

          eval status ='Ende  TRKOMLFSR                         ';
          Exsr      sr_log;


       MONITOR;
          Wrk.var1 =
              'RMVLIBLE LIB(GANG)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error RMVLIBLE LIB(GANG)                   ';
             exsr      SR_log;
       endmon;

       *inlr = *on;


       //-----------------------------------------------------------------------
       //afko-lesen für Prüfungen
       //-----------------------------------------------------------------------

       begsr SR_afko;

             afko01_k.AkFIRM = ab64l1_i.sqFIRM;
             afko01_k.AkAFJJ = ab64l1_i.sqAFJJ;
             afko01_k.AkAFNR = ab64l1_i.sqAFNR;
             chain %kds(afko01_k:3) afko01    afko01_I;
             if %found(afko01);
       //check up Aktionskennzeichen nur in Verbindung mit AA 28
                if afko01_I.AKAFAT ='28 ' and
                   afko01_I.AKKMAT ='S' and
       //          trtp_k.TPTCDE  =  afko01_I.akkmat;
                   trtp_k.TPTCDE  =  'AKTION    ';
                   §fieldname = 'AKTION    ';
                   exsr  SR_trtp;
                endif;
       //check up Teillieferung  J ==> NUR KOMPLETT LIEFERN!!!
       //auf Ebene des ganzen Auftrags
                §akliar =  AFKO01_I.AKLIAR;
       //       if AFKO01_I.AKLIAR = 'J';
       //          trtp_k.TPTCDE  =  afko01_I.akliar;
       //          §fieldname = 'AKLIAR    ';
       //          exsr  SR_trtp;
       //       endif;

       //check up Auftragsarten Prüfung 1
                trtp_k.TPTCDE  =  afko01_I.akafat;
                §fieldname = 'AKAFAT    ';
                exsr  SR_trtp;

       //check up Kundennummer  Prüfung 2
                trtp_k.TPTCDE  =  afko01_I.akkdnr;
                §fieldname = 'AKKDNR    ';
                exsr  SR_trtp;
             else;
                p_cc            = 'E';
             endif;
       endsr;

       //-----------------------------------------------------------------------
       //afpo-lesen für Prüfungen
       //-----------------------------------------------------------------------

       begsr SR_afpo;

             afpo01_k.APFIRM = ab64l1_i.sqFIRM;
             afpo01_k.APAFJJ = ab64l1_i.sqAFJJ;
             afpo01_k.APAFNR = ab64l1_i.sqAFNR;
             afpo01_k.APAFPO = ab64l1_i.sqAFPO;
             chain %kds(afpo01_k:4) afpo01    afpo01_I;
             if %found(afpo01);
       //check up Artikel
                trtp_k.TPTCDE  =  ab64l1_i.sqtenr;
                §fieldname = 'APTENR    ';
                exsr  SR_trtp;

       //check up Versandbedingung
                trtp_k.TPTCDE  =  ab64l1_i.sqvsbd;
                §fieldname = 'APVSBD    ';
                exsr  SR_trtp;

       //check up über Artikelstamm
                exsr SR_teil;

             else;
                p_cc            = 'E';
             endif;
       endsr;

       //-----------------------------------------------------------------------
       //teil-lesen für Lieferanten (derzeit)
       //-----------------------------------------------------------------------

       begsr SR_teil;

             teil01_k.TEFIRM = ab64l1_i.sqfirm;
             teil01_k.TETENR = ab64l1_i.sqtenr;
             chain %kds(teil01_k:2) teil01    teil01_I;
             if %found(teil01);

       //check up Lieferantenzurodnung aus Artikelstamm
                trtp_k.TPTCDE  =  teil01_i.TESTLF;
                §fieldname = 'TESTPR    ';
                exsr  SR_trtp;
             else;
                p_cc            = 'E';
             endif;

       endsr;

       //-----------------------------------------------------------------------
       //Grunddaten prüfen in Domeic Group Definition
       //-----------------------------------------------------------------------

       begsr sr_trtp;

          trtp_k.tpfirm  =  ab64l1_i.sqfirm;
          trtp_k.TPSPCD  =  'D';
          trtp_k.TPTART  =  'TRKOMLFSR ';
       //aus execute
       // trtp_k.TPTCDE  =  ???

       //trtp                                         TPTTXT
          chain %kds(trtp_k:4) trtp01 trtp_I;
          if %found(trtp01) and
             %subst(trtp_i.TPTTXT:1:10) = §fieldname;
             rep      = ' ';
             select;
             when trtp_i.tptnum = 1;
                edc      = '1';
                rep      = '1';
             when trtp_i.tptnum = 2;
                schilgen = '1';
                rep      = '2';
             when trtp_i.tptnum = 3;
                silfox   = '1';
                rep      = '3';
             other;
             endsl;
             select;
       //   1234567890123456789012345678901234567890123456789012
       //   AKKMAT     1 J AKAFAT     1 A02 AKKDNR     1 044605
       //   123456789012345
       //   AKKMAT     1 J
             when %subst(trtp_i.TPTTXT:1:10)='AKTION    ';
                %subst(#ab64l1_o.REFERENZ:01:15)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
       //   67890123456789012
       //   AKAFAT     1 A02
             when %subst(trtp_i.TPTTXT:1:10)='AKAFAT    ';
                %subst(#ab64l1_o.REFERENZ:16:17)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
       //   34567890123456789012
       //   AKKDNR     1 044605
             when %subst(trtp_i.TPTTXT:1:10)='AKKDNR    ';
                %subst(#ab64l1_o.REFERENZ:33:20)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
       //   34567890123456789012345678901
       //   APTENR     1 123456789012345
             when %subst(trtp_i.TPTTXT:1:10)='APTENR    ';
                %subst(#ab64l1_o.REFERENZ:62:29)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
       //   34567890123456789
       //   APVSBD     1 025
             when %subst(trtp_i.TPTTXT:1:10)='APVSBD    ';
                %subst(#ab64l1_o.REFERENZ:91:17)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
       //   0123456789012345678
       //   TESTPR     1 92013
             when %subst(trtp_i.TPTTXT:1:10)='TESTPR    ';
                %subst(#ab64l1_o.REFERENZ:117:19)=%subst(trtp_i.TPTTXT:1:10) +
                  ' ' + rep + ' ' + trtp_k.TPTCDE;
             other;
             endsl;
          else;
             trtp_i.tptnum = 0;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //items check
       //-----------------------------------------------------------------------

       begsr SR_items;

             pbfstss_k.tzkonz = 'EMS';
             pbfstss_k.tzfirm = 'DWI';
             pbfstss_k.tziden = aptenr;
             chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
             if %found(pbfstss);
       //pbfstss kl.Einheit
                p_cc            = '1';
             else;
                p_cc            = 'E';
             endif;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

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

       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei KPIF
       //-----------------------------------------------------------------------

       begsr srinit;

       mydate  = %date();
       days    = %subdt( %date(): *days );
       months  = %subdt( %date(): *months );
       years   = %subdt( %date(): *years );
       eofyear = years*10000+12*100+31;
       nowdate = (%dec(%char(%date()- %days(1):*iso0):8:0));

       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(DOMDATV7) POSITION(*LAST)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDLIBLE LIB(DOMDATV7) POSITION(*LAST)';
             exsr      SR_log;
       endmon;

         exec sql
              create index qtemp/ab64l1
              on qtemp/ab64 (sqFIRM, sqAFJJ, sqAFNR, sqAFPO);

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       //check up COMPLETE Kennzeichen gilt übergeordnet
       //müssen alle Auftragspositionen über ein Lager geführt werden
       //siehe 'COMPLETE  ' wenn ja Standardlager hierfür ist 'STANDARD  '
         ab64l1_i.sqfirm ='01';
         trtp_k.TPTCDE  =  'JA';
         §fieldname = 'COMPLETE  ';
         exsr  SR_trtp;
         §complete = trtp_i.tptnum;
         trtp_k.TPTCDE  =  'LAGER';
         §fieldname = 'STANDARD  ';
         exsr  SR_trtp;
         select;
         when trtp_i.tptnum = 1;
            §standard            = 'EDC     ';
         when trtp_i.tptnum = 2;
            §standard            = 'Schilgen';
         when trtp_i.tptnum = 3;
            §standard            = 'Silfox  ';
         other;
            §standard            = 'EDC     ';
         endsl;
         ab64l1_i.sqfirm ='01';
       //Kopfparameter neu initialisieren
         §edc      = 0;
         §schilgen = 0;
         §silfox   = 0;
       //Positionsparameter neu initialisieren
         edc      = '0';
         schilgen = '0';
         silfox   = '0';

       endsr;


