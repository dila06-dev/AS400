
      //************************************************************************
      //
      //      Programmname       galaxusr
      //      Erstellt  am       19.04.2018
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an galaxus Bestände
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      // CPYFRMIMPF FROMFILE(TVRELWAECO/GALAXUSIN) TOFILE(TVRELWAECO/FROM_EXCE3)
      // MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:       ftp.galaxus.ch
      // Restartmöglichkeiten:       User: dometic
      // _____________________       PW: 4t5QaveFrU
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
      //  CRTPF FILE(tvrelwaeco/KUNDENAIMP) RCDLEN(100) TEXT('importing
      //         replanishment')
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


      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for BLOMGREN     ';
       exsr      SR_log;

       //for update files
       callP WE_CHECK();

       //for update files und uploading FTP scheduler inaktiv
       //03.07.2019
       callP SIEVOIIR();

       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 000000;
       // and NumSysTime < 090000;
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
       //output INVENTORY
       exec sql
         delete   FROM INVENTORY
         WHERE TETENR like '%,%' or TETENR like '%;%';
          exsr  file_out3;

       //output PURCHASEOR
          exsr  file_out4;

       //output CUSTOMOR
          exsr  file_out5;

       //output SKUSUPPLIE
          exsr  file_out6;

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
         on-error;
            status='error in command appeared: CPYFRMIMPF BESTANDZU   ';
            exsr      SR_log;
         endmon;

       //output BESTANDZUGANG ==> BESTANDIMP
          exsr  file_out7;

       //copy files from trend dxs support Kundenauftraege
         MONITOR;
            Wrk.var1 =
                'CPYFRMSTMF FROMSTMF'+
                '(''/trend/echt/edi/out/dsx/Kundenauftraege.txt'') '+
                'TOMBR'+
                '(''/QSYS.LIB/TVRELWAECO.LIB/KUNDENAUF.FILE/KUNDENAUF.MBR'') '+
                'MBROPT(*REPLACE) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
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
         on-error;
            status='error in command appeared: CPYFRMIMPF Kundenauf   ';
            exsr      SR_log;
         endmon;

       //output BESTANDZUGANG ==> KUNDENAIMP
          exsr  file_out8;


          clear     Wrk.var1;
          clear     status;
          err_msg = ' ';

       endif;

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
       exec sql
        insert into tvrelwaeco/ITEMMASTER
        SELECT * FROM teil01 WHERE TEFIRM ='01';

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

       exec sql
         update INVENTORY a set onhand   =
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('001', '001','100', '110', '094', '095', '096', '200') or
          substr(LBBSLANR, 1, 1)='7') GROUP BY LBBSTENR)
         where exists
         (select dec(sum(LBBSLAGB), 13, 2) from tvpf/lbbs01 b
          where a.tetenr = b.LBBSTENR and
          LBBSFIRM='01' and (LBBSLANR in
          ('001', '001','100', '110', '094', '095', '096', '200') or
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

       exec sql
         insert into tvrelwaeco/BLOMGREN_1
         SELECT DISTINCT * FROM tvrelwaeco/we_check5 WHERE ((#LBLBLSTC
         ='825' and #LBLBLANR in ('500', '510') ) or (#LBLBLSTC ='950' and
         #LBLBLANR in ('100', '110') ) and #LBLBJNAM <> 'WAIFLB' and
         #LBLBSTKZ =' ' ) ORDER BY #LBLBDAKY;

       exec sql
         update BLOMGREN_1 set #LBLBBWMG=#LBLBBWMG*-1
         where #LBLBLANR in ('100', '110');

       exec sql
         insert into tvrelwaeco/BLOMGREN_2
         SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
         #AEWENR, #LBLBTENR ,max(#LBLBBDAT) dateinput, max(#LBLBBDAT),
         #AELFNR, dec(sum(#LBLBBWMG), 13, 2) quantity FROM BLOMGREN_1 WHERE
         ((#LBLBLSTC ='825' and #LBLBLANR in ('500', '510') ) or (#LBLBLSTC
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

       exec sql
        insert into tvrelwaeco/TMPDELIVER
        SELECT #TSTAMP #LBLBLSTC,#WE#EL, #AEFIRM, #AEBEJJ, #AEBENR,
        #AEBEPO, #AELFNR, #AEWEJJ, #AEWENR, #LBLBBWMG, #LBLBTENR FROM
        datenkw/#lblb WHERE #we#el <> 0 and #TSTAMP > current date - 730 day;

       exec sql
        insert into tvrelwaeco/TMPframe
        SELECT EPFIRM, EPLFNR, EPBEJJ, EPBENR, EPTENR, dec(sum(epmeng), 13,
        2) epmeng, dec(count(*), 13, 0) pos FROM bbep WHERE EpFIRM ='01'
        and EPBEJJ ='2019' GROUP BY EPFIRM, EPLFNR, EPBEJJ, EPBENR, EPTENR
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
        where EPFIRM ='01' and
              rtrim(epBEJJ) concat rTRIM(epBENR)=PUNUMBE and
              line =dec(epBEPO))
        where exists
        (select epbete from bbep
        where EPFIRM ='01' and
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
                                 '81', '17', '18', 'A02')    and
                AFPO_1.APAFST<= '20'                         and
                AFPO_1.APFIRM= '01');



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
                    AND TEIL_1.TELFNR=LIEF_1.LFLFNR )
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

          update phy02r   CUSTOMOR_o;
          read CUSTOMOR CUSTOMOR_i;
       enddo;
       close SKUSUPPLIE;


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


