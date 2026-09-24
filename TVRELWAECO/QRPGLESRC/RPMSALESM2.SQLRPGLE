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
      * SELECT "LOCATION", ITEM, a.ARTNR, LADEM, LFSL, LFSH, LFSB, LFSQ,
      * JANA, FEBA, MAEA, APRA, MAIA, JUNA, JULA, AUGA, SEPA, OKTA, NOVA,
      * DEZA, AKTA, JANH, FEBH, MAEH, APRH, MAIH, JUNH, JULH, AUGH, SEPH,
      * OKTH, NOVH, DEZH, AKTH, TEERTE, B.LIEFERANT1, B.LIEFERANT2 FROM
      * RPM_LFS_Q1 a, bar_kalk/kalk_file b WHERE (A.ARTNR = b.ARTNR
      *                                 or a.item=b.artnr) and
      * b.version='$$EL_PS_DB'
      **Datei RPM_LFS_QX in TVRELWAECO wurde erstellt.
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

     fRPM_LFS   uf   e             DISK    RENAME(RPM_LFS:PHY01R)
     f                                     USROPN
     f
     fpbfstss   if   e           K DISK    RENAME(pbfstssf:LOG01R)
     f
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
     d RPM_LFS_i     E DS                  ExtName(RPM_LFS:*input)
     d                                     Qualified

     d RPM_LFS_o     E DS                  ExtName(RPM_LFS:*output)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified

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
     IPHY01R
     I              monat                       §monat
     I              jahr                        §jahr


     D*
     I*-------------------------------------------------------------------------
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   Exsr      sr_log
     c                   exsr      sr1000
      /FREE
          open RPM_LFS;

          read RPM_LFS   RPM_LFS_i;
          dow not %eof(RPM_LFS);
             RPM_LFS_o  = RPM_LFS_i;
             pbfstss_k.tzkonz = 'EMS';
             pbfstss_k.tzfirm = 'DWI';
             pbfstss_k.tziden = RPM_LFS_i.ITEM;
             chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
             if %found(pbfstss);
       //pbfstss
                RPM_LFS_o.Ladem = pbfstss_i.TZLM;
                RPM_LFS_o.lfsl  = pbfstss_i.TZVLL;
                RPM_LFS_o.lfsb  = pbfstss_i.TZVLB;
                RPM_LFS_o.lfsh  = pbfstss_i.TZVLH;
                RPM_LFS_o.lfsq  = pbfstss_i.TZMLM;
       //update
                update PHY01R    RPM_LFS_o;
                clear            RPM_LFS_o;
             else;
                pbfstss_k.tzkonz = 'EMS';
                pbfstss_k.tzfirm = 'DWI';
                pbfstss_k.tziden = RPM_LFS_i.ARTNR;
                chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
                if %found(pbfstss);
       //pbfstss
                   RPM_LFS_o.Ladem = pbfstss_i.TZLM;
                   RPM_LFS_o.lfsl  = pbfstss_i.TZVLL;
                   RPM_LFS_o.lfsb  = pbfstss_i.TZVLB;
                   RPM_LFS_o.lfsh  = pbfstss_i.TZVLH;
                   RPM_LFS_o.lfsq  = pbfstss_i.TZMLM;
       //update
                   update PHY01R    RPM_LFS_o;
                   clear            RPM_LFS_o;
                else;
                   unlock RPM_LFS;
                endif;
                unlock RPM_LFS;
             endif;
             read RPM_LFS  RPM_LFS_i;
          enddo;

          close RPM_LFS;
      /End-FREE
       //statistik
     c                   exsr      sr2000
     c                   movel     'EDC       '  location         10
     c                   exsr      sr3000
     c                   movel     'SCHILGEN  '  location         10
     c                   exsr      sr4000
     c                   movel     'SILFOX    '  location         10
     c                   exsr      sr5000
     c                   movel     'OpenOrders'  location         10
     c                   exsr      sr6000

       // ... Artikel mit Beständen aber ohne Verkauf zugeordnet unique nach Lager
     c/exec sql
     c+ insert into RPM_LFS_Q1
     c+ SELECT distinct
     c+        'SCHILGEN*', lkiden, ' ', ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     c+ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ' '
     c+ FROM tvrelwaeco/lfs_segm a WHERE status='X' and lkber in
     c+ ('60', '61', '62', '63', '64', '65')
     c+  and status='X' and a.LKIDEN not in (select b.item from
     c+ rpm_lfs_q1 b)
     c/end-exec

       // ... Artikel mit Beständen aber ohne Verkauf zugeordnet unque nach Lager
     c/exec sql
     c+ insert into RPM_LFS_Q1
     c+ SELECT distinct
     c+        'EDC*     ', lkiden, ' ', ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     c+ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ' '
     c+ FROM tvrelwaeco/lfs_segm a WHERE status='X' and lkber not in
     c+ ('60', '61', '62', '63', '64', '65')
     c+ and status='X' and a.LKIDEN not in (select b.item from
     c+ rpm_lfs_q1 b)
     c/end-exec

       // ... Ersatzartikel ohne Auslauf preparieren
       // ... wo ist der neue Artikel überall enthalten?
       // ... mit * beginnend sind neue Hauptartikel (item)
       // ... hinter dem Stern steht der alte Artikel, dessen
       // ... Werte auch übernommen werden müssen im teil 2
     c/exec sql
     c+ update rpm_lfs_q1 a set a.teerte=substr(a.teerte, 1, 1) concat
     c+ (select substr(max(b.tetenr), 1, 14) from teil01 b
     c+   WHERE substr(a.teerte, 1, 1) = '*' and
     c+     a.item = b.teerte and b.tefirm='01'
     c+     group by b.teerte)
     c+  where exists
     c+ (select substr(max(b.tetenr), 1, 14) from teil01 b
     c+   WHERE substr(a.teerte, 1, 1) = '*' and
     c+     a.item = b.teerte and b.tefirm='01'
     c+     group by b.teerte)
     c/end-exec

       // ... ====> teil2  januar
     c/exec sql
     c+ update rpm_lfs_q1 a set a.jana = a.jana +
     c+ (sELECT sum(b.jana)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.jana)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  februar
     c/exec sql
     c+ update rpm_lfs_q1 a set a.feba = a.feba +
     c+ (sELECT sum(b.feba)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.feba)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  maerz
     c/exec sql
     c+ update rpm_lfs_q1 a set a.maea = a.maea +
     c+ (sELECT sum(b.maea)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.maea)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  april
     c/exec sql
     c+ update rpm_lfs_q1 a set a.apra = a.apra +
     c+ (sELECT sum(b.apra)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.apra)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  mai
     c/exec sql
     c+ update rpm_lfs_q1 a set a.maia = a.maia +
     c+ (sELECT sum(b.maia)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.maia)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  juni
     c/exec sql
     c+ update rpm_lfs_q1 a set a.juna = a.juna +
     c+ (sELECT sum(b.juna)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.juna)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  juli
     c/exec sql
     c+ update rpm_lfs_q1 a set a.jula = a.jula +
     c+ (sELECT sum(b.jula)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.jula)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  august
     c/exec sql
     c+ update rpm_lfs_q1 a set a.auga = a.auga +
     c+ (sELECT sum(b.auga)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.auga)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  september
     c/exec sql
     c+ update rpm_lfs_q1 a set a.sepa = a.sepa +
     c+ (sELECT sum(b.sepa)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.sepa)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  oktober
     c/exec sql
     c+ update rpm_lfs_q1 a set a.okta = a.okta +
     c+ (sELECT sum(b.okta)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.okta)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec


       // ... ====> teil2  november
     c/exec sql
     c+ update rpm_lfs_q1 a set a.nova = a.nova +
     c+ (sELECT sum(b.nova)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.nova)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  dezember
     c/exec sql
     c+ update rpm_lfs_q1 a set a.deza = a.deza +
     c+ (sELECT sum(b.deza)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.deza)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  aktuell
     c/exec sql
     c+ update rpm_lfs_q1 a set a.akta = a.akta +
     c+ (sELECT sum(b.akta)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.akta)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  januar
     c/exec sql
     c+ update rpm_lfs_q1 a set a.janh = a.janh +
     c+ (sELECT sum(b.janh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.janh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  februar
     c/exec sql
     c+ update rpm_lfs_q1 a set a.febh = a.febh +
     c+ (sELECT sum(b.febh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.febh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  maerz
     c/exec sql
     c+ update rpm_lfs_q1 a set a.maeh = a.maeh +
     c+ (sELECT sum(b.maeh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.maeh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  april
     c/exec sql
     c+ update rpm_lfs_q1 a set a.aprh = a.aprh +
     c+ (sELECT sum(b.aprh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.aprh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  mai
     c/exec sql
     c+ update rpm_lfs_q1 a set a.maih = a.maih +
     c+ (sELECT sum(b.maih)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.maih)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  juni
     c/exec sql
     c+ update rpm_lfs_q1 a set a.junh = a.junh +
     c+ (sELECT sum(b.junh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.junh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  juli
     c/exec sql
     c+ update rpm_lfs_q1 a set a.julh = a.julh +
     c+ (sELECT sum(b.julh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.julh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  august
     c/exec sql
     c+ update rpm_lfs_q1 a set a.augh = a.augh +
     c+ (sELECT sum(b.augh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.augh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  september
     c/exec sql
     c+ update rpm_lfs_q1 a set a.seph = a.seph +
     c+ (sELECT sum(b.seph)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.seph)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  oktober
     c/exec sql
     c+ update rpm_lfs_q1 a set a.okth = a.okth +
     c+ (sELECT sum(b.okth)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.okth)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec


       // ... ====> teil2  november
     c/exec sql
     c+ update rpm_lfs_q1 a set a.novh = a.novh +
     c+ (sELECT sum(b.novh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.novh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  dezember
     c/exec sql
     c+ update rpm_lfs_q1 a set a.dezh = a.dezh +
     c+ (sELECT sum(b.dezh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.dezh)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

       // ... ====> teil2  aktuell
     c/exec sql
     c+ update rpm_lfs_q1 a set a.akth = a.akth +
     c+ (sELECT sum(b.akth)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c+  where exists
     c+ (sELECT sum(b.akth)  FROM rpm_lfs_q1 b where
     c+         substr(a.teerte, 1, 01)='*'  and
     c+         b."LOCATION" = a."LOCATION"  and
     c+         substr(b.teerte, 1, 14) = a.item
     c+         group by b."LOCATION", b.teerte )
     c/end-exec

     c                   call      'LFS_PICKSR'
     c                   Exsr      sr_log

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c                   clear                   outbound          1

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_1';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_1 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_2';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_2 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_3';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_3 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free



      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_4';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_4 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_5';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_5 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_6';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_6 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_7';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_7 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_LFS_8';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_LFS_8 konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q1';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q1 konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q2';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q2 konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q3';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q3 konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q4';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q4 konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q5';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q5 konnte nicht gelöscht werden          ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_lfs_Q6';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='RPM_lfs_Q5 konnte nicht gelöscht werden          ';
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

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/rpm_lfs
     c+ SELECT substr(char(rkreda), 1, 4) Jahr,
     c+        substr(char(rkreda), 5, 2) Monat,
     c+        ENTITY, COUNT_ISO, ITEM, ITEMDESC, APGLMG, ENTRY#, RKREDA,
     c+ COST_UNIT, RPNESU, RKWACD, APPRGR, DIVISION, CUSTOMER#, CUSTOMER,
     c+ RPMGROUP, AKFIRM, AKAFJJ, AKAFNR, AKAFAT, TEPRGR, TEDIAV, ARTNR,
     c+ doc, substr(ART, 1, 6) lieferant , substr(ART, 7, 4) Steuerer,
     c+ substr(ART, 11, 4) VSBD, substr(ARTsku, 11, 5) tour, dec(0, 4, 0)
     c+ I1, dec(0, 4, 0) I2,dec(0, 4, 0) I3, dec(0, 13, 2) turnover,
     c+ dec(0, 13, 2) quantity , char(' ', 1) akkmat,
     c+ char(' ', 3) abc, char(' ', 1) AKLIAR,char(' ', 1) set,
     c+ dec(0, 4, 0) I4, dec(0, 13, 2) turnover2 , dec(0, 13, 2) quantity2,
     c+ dec(0, 1, 0) edc, dec(0, 1, 0) Schilgen, dec(0, 1, 0) SILFOX,
     c+ char(' ', 3) Ladem, dec(0, 9, 3) lfsl, dec(0, 9, 3) lfsh,
     c+ dec(0, 9, 3) lfsb, dec(0, 9, 3) lfsq
     c+ FROM rpmsales# WHERE ENTITY ='DE411'
     c+ and h1 <> 'supplement' and substr(TEPRGR, 1, 1)<>'9' and
     c+ AKAFAT not in ('02', '03', '04', '05', '14', '31', '50', '62',
     c+               '63', '70', '71', '72', '84', '85', '88', '89')
     c/end-exec


     C*insert Auftragsbestand
     c/exec sql
     c+ insert into tvrelwaeco/rpm_lfs
     c+ SELECT substr(char(APLFTE), 1, 4) Jahr,
     c+        substr(char(APLFTE), 5, 2) Monat, 'DE411', 'DE',
     c+        ITEM, ITEMDESC, APGLMG, 'open orders' ENTRY#, aplfte,
     c+ 0,00,  wert      , RKWACD, APPRGR, DIVISION, CUSTOMER#, CUSTOMER,
     c+ RPMGROUP, AKFIRM, AKAFJJ, AKAFNR, ApAFAT, TEPRGR, ' '   , ARTNR,
     c+ apsabei, substr(ART, 1, 6) lieferant , substr(ART, 7, 4) Steuerer,
     c+ substr(ART, 11, 4) VSBD, substr(ARTsku, 11, 5) tour, dec(0, 4, 0)
     c+ I1, dec(0, 4, 0) I2,dec(0, 4, 0) I3, dec(0, 13, 2) turnover,
     c+ dec(0, 13, 2) quantity , char(' ', 1) akkmat,
     c+ char(' ', 3) abc, char(' ', 1) AKLIAR,char(' ', 1) set,
     c+ dec(0, 4, 0) I4, dec(0, 13, 2) turnover2 , dec(0, 13, 2) quantity2,
     c+ dec(0, 1, 0) edc, dec(0, 1, 0) Schilgen, dec(0, 1, 0) SILFOX,
     c+ char(' ', 3) Ladem, dec(0, 9, 3) lfsl, dec(0, 9, 3) lfsh,
     c+ dec(0, 9, 3) lfsb, dec(0, 9, 3) lfsq
     c+ FROM RPMEXPECM0 WHERE YEAR#= year(current date) and week#=
     c+                       week(current date) - 0 and APGLMG <> 0
     c+                       and akfirm='01'
     c/end-exec

     c/exec sql
     c+ update rpm_lfs  set artnr=' '
     c+  where  artnr= item
     c/end-exec

     C*__________________________________________________________________
     c/exec sql
     c+ insert into RPM_LFS_1
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , LIEFERANT , dec(count(*), 5, 0) i1
     c+ FROM rpm_lfs
     c+ where ENTRY# <> 'open orders'
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR, LIEFERANT
     c/end-exec

     c/exec sql
     c+ insert into RPM_LFS_2
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR,dec(count(*), 5, 0) i1 FROM rpm_lfs_1
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.i1 =
     c+ (select b.i1 from rpm_lfs_2 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c+  where exists
     c+ (select b.i1 from rpm_lfs_2 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c/end-exec
     C*__________________________________________________________________

     c/exec sql
     c+ update rpm_lfs a set a.abc =
     c+ (select b.teabc1 from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.item  =b.tetenr)
     c+  where exists
     c+ (select b.teabc1 from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.item  =b.tetenr)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.abc =
     c+ (select b.teabc1 from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.artnr =b.tetenr and
     c+   a.abc = ' ')
     c+  where exists
     c+ (select b.teabc1 from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.artnr =b.tetenr and
     c+  a.abc = ' ')
     c/end-exec

     C*__________________________________________________________________
     C*Hilfsdatei in Verbindung mit den definierten Lieferanten
     c/exec sql
     c+ insert into RPM_LFS_3
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , LIEFERANT , dec(count(*), 5, 0) i1
     c+ FROM rpm_lfs
     c+ where (lieferant in ('90363', '92013', '92013')
     c+        and ENTRY# <> 'open orders'            )
     c***+        or
     c***+       (lieferant =   '90862'
     c***+        and item in  (select ARTNEGATIV from RPM_LFSART)
     c***+        and ENTRY# <> 'open orders'            )
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR, LIEFERANT
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.i2 =
     c+ (select sum(b.i1) from rpm_lfs_3 b where a.akfirm=b.akfirm and
     c+                                          a.akafjj=b.akafjj and
     c+                                          a.akafnr=b.akafnr
     c+    group by b.akfirm, b.akafjj, b.akafnr)
     c+  where exists
     c+ (select sum(b.i1) from rpm_lfs_3 b where a.akfirm=b.akfirm and
     c+                                          a.akafjj=b.akafjj and
     c+                                          a.akafnr=b.akafnr
     c+    group by b.akfirm, b.akafjj, b.akafnr)
     c/end-exec
     C*__________________________________________________________________

     c/exec sql
     c+ insert into RPM_LFS_4
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , LIEFERANT , doc,
     c+        dec(sum(rpnesu), 13, 0)
     c+ turnover,dec(sum(apglmg), 13, 2) quantity
     c+ FROM rpm_lfs
     c+ where (lieferant in ('90363', '92013', '92013')
     c+        and ENTRY# <> 'open orders'             )
     c*****+        or
     c*****+       (lieferant =   '90862'
     c*****+        and item in  (select ARTNEGATIV from RPM_LFSART)
     c*****+        and ENTRY# <> 'open orders'            )
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR, LIEFERANT, doc
     c/end-exec


     c/exec sql
     c+ update rpm_lfs a set a.turnover =
     c+ (select b.turnover from rpm_lfs_4 b where a.akfirm=b.akfirm
     c+                                   and     a.akafjj=b.akafjj
     c+                                   and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c+  where exists
     c+ (select b.turnover from rpm_lfs_4 b where a.akfirm=b.akfirm
     c+                                   and     a.akafjj=b.akafjj
     c+                                   and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.quantity =
     c+ (select b.quantity from rpm_lfs_4 b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c+  where exists
     c+ (select b.quantity from rpm_lfs_4 b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.akkmat   =
     c+ (select b.akkmat   from afko01    b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr)
     c+  where exists
     c+ (select b.akkmat   from afko01    b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.akliar   =
     c+ (select b.akliar   from afko01    b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr)
     c+  where exists
     c+ (select b.akliar   from afko01    b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.set =
     c+ (select b.tetart from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.artnr =b.tetenr and
     c+   b.tetart='P')
     c+  where exists
     c+ (select b.tetart from teil01 b where a.akfirm=b.tefirm and
     c+                                      a.artnr =b.tetenr and
     c+   b.tetart='P')
     c/end-exec

     C*Protokoll 90021 Bielefelder Hohlträger
     c/exec sql
     c+ insert into RPM_LFS_5
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , LIEFERANT , dec(count(*), 5, 0) i1
     c+ FROM rpm_lfs
     c+ where lieferant in ('90021')
     c+       and ENTRY# <> 'open orders'
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR, LIEFERANT
     c/end-exec


     c/exec sql
     c+ update rpm_lfs a set a.i4 =
     c+ (select b.i1 from rpm_lfs_5 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c+  where exists
     c+ (select b.i1 from rpm_lfs_5 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c/end-exec

     c/exec sql
     c+ insert into RPM_LFS_6
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , LIEFERANT , doc,
     c+        dec(sum(rpnesu), 13, 0)
     c+ turnover,dec(sum(apglmg), 13, 2) quantity
     c+ FROM rpm_lfs
     c+ where lieferant in ('90021')
     c+       and ENTRY# <> 'open orders'
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR, LIEFERANT, doc
     c/end-exec


     c/exec sql
     c+ update rpm_lfs a set a.turnover2=
     c+ (select b.turnover from rpm_lfs_6 b where a.akfirm=b.akfirm
     c+                                   and     a.akafjj=b.akafjj
     c+                                   and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c+  where exists
     c+ (select b.turnover from rpm_lfs_6 b where a.akfirm=b.akfirm
     c+                                   and     a.akafjj=b.akafjj
     c+                                   and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.quantity2=
     c+ (select b.quantity from rpm_lfs_6 b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c+  where exists
     c+ (select b.quantity from rpm_lfs_6 b where a.akfirm=b.akfirm
     c+                                    and     a.akafjj=b.akafjj
     c+                                    and     a.akafnr=b.akafnr
     c+                             and     a.lieferant=b.lieferant
     c+                             and     a.doc      =b.doc      )
     c/end-exec

     C*________Gesamtanzahl der Positionen eines Auftrags________________
     c/exec sql
     c+ insert into RPM_LFS_7
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR,dec(count(*), 5, 0) i1 FROM rpm_lfs
     c+ where     ENTRY# <> 'open orders'
     c+ GROUP BY AKFIRM, AKAFJJ, AKAFNR
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.i3 =
     c+ (select b.i1 from rpm_lfs_7 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c+  where exists
     c+ (select b.i1 from rpm_lfs_7 b where a.akfirm=b.akfirm and
     c+                                     a.akafjj=b.akafjj and
     c+                                     a.akafnr=b.akafnr )
     c/end-exec
     C*__________________________________________________________________

     C*Versandbedingungen +
     C*Lieferantenausschluss, die in jedem Fall im EDC angelegt sind
     c/exec sql
     c+ update rpm_lfs set edc  ='1'
     c+  where vsbd in ('078', '074', '070', '061', '056', '047', '026',
     c+                 '018', '001', '002', '013') or
     c+                  substr(VSBD, 1, 1) ='5'    or
     c+                  (i2 =0 and i4=0 )
     c/end-exec
       // ... Änderung hinweis auf beteiligter Lieferant aus Seletion
     c***/exec sql
     c***+ update        RPM_LFS   set i2 = 1 where i2 > 0
     c***/end-exec

       // ... Schilgen auf '1' setzten wenn nur 1 Position im Auftrag
       //     Schilgen zugeordnet mit einer Position(i3)
       //     auf schilgen
       // ... keine Berechnung ab jetzt 20.10.2016
     c***/exec sql
     c***+ update RPM_LFS set SCHILGEN='1'
     c***+ WHERE i1=1 and i2=1 and i3=1 and i4=0
     c***+  and edc=0 and schilgen =0
     c***/end-exec

       // ... alle Positionen(I2=i3) sind Schilgen zugeordnet
     c/exec sql
     c+ update rpm_lfs set schilgen = 1 WHERE
     c+       (edc=0 and schilgen=0 and lieferant in
     c+ ('90363', '92013', '92013') and i2 = i3
     c+   and vsbd in ('003', '113', '225', '226', '227',
     c+              '228', '229', '213')
     c+  and edc=0 and schilgen =0 )
     c*****+        or
     c*****+       (edc=0 and schilgen=0 and lieferant in
     c*****+ ('90862')                   and I2 = i3
     c*****+   and vsbd in ('003', '113', '225', '226', '227',
     c*****+              '228', '229', '213')
     c*****+        and item in  (select ARTNEGATIV from RPM_LFSART)
     c*****+  and edc=0 and schilgen =0)
     c/end-exec

       // ... alles über Silfox Definitionen wenn Aktionsgeschäft
     c/exec sql
     c+ update rpm_lfs set silfox = 1
     c+ WHERE  akkmat = 'S' and AKAFAT ='28' and
     c+  edc=0 and schilgen =0 and silfox=0
     c/end-exec


       // ... alle Silfox Definitionen werden abgewickelt in
       // ... edc  Ausnahme Aktionen
     c/exec sql
     c+ update rpm_lfs set edc = 1
     c+ WHERE  i4 <> 0 and
     c+  edc=0 and schilgen =0 and silfox=0
     c/end-exec

       // ... alle übrigen nicht zugewiesenen über EDC
     c/exec sql
     c+ update  RPM_LFS set edc=1 wHERE edc=0 and schilgen=0 and silfox=0
     c/end-exec

       // ... alle Amazone-Aufträge werden jetzt über Schilgen abgewickelt
       // ... interne
       // ... keine Berechnung ab jetzt 20.10.2016
     c***/exec sql
     c***+ update  RPM_LFS set edc=0, schilgen='1', silfox='0'
     c***+ WHERE   CUSTOMER#  in ('091613', '091611', '091610')
     c***/end-exec

       // ... alle Amazone-Aufträge werden jetzt über Schilgen abgewickelt
       // ... externe über SC's
       // ... keine Berechnung ab jetzt 20.10.2016
     c***/exec sql
     c***+ update  RPM_LFS set edc=0, schilgen='1', silfox='0'
     c***+ WHERE (VSBD = '024' or VSBD = '025')  and
     c***+       CUSTOMER# in ('088505', '040631', '055278', '078146')
     c***/end-exec

       // ... Ausnahmen aus dem Regelwerk I
       // ... bestimmte Artikel nur über Schilgen im Falle, wenn
       // ... der Auftrag ausschliesslich Artikel beinaltet in RPM_LFSART


     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_8
     c+ SELECT AKFIRM, AKAFJJ, AKAFNR , I1 anzahlLief, I2 schilgenpos, I3
     c+ auPosition, EDC, SCHILGEN, SILFOX ,dec(count(*), 3, 0) anzahl FROM
     c+ rpm_lfs WHERE item in (select ARTNEGATIV from RPM_LFSART) GROUP BY
     c+ AKFIRM, AKAFJJ, AKAFNR, I1, I2, I3, EDC, SCHILGEN, SILFOX
     c/end-exec

     c/exec sql
     c+ update rpm_lfs a set a.silfox = 0, a.schilgen=1, a.edc=0
     c+ WHERE a.akfirm in (select b.akfirm from RPM_LFS_8 b
     c+                    where a.akfirm=b.akfirm and
     c+                          a.AKAFJJ=b.AKAFJJ and
     c+                          a.AKAFNR=b.AKAFNR and
     c+                          b.AUPOSITION=b.anzahl)
     c/end-exec


       // ... Ausnahmen aus dem Regelwerk II
       // ... bestimmte Artikel nur über Schilgen im Falle, wenn
       // ... der Disponent TEDIEK = 'LR' ist


     c/exec sql
     c+ update rpm_lfs a set a.silfox = 0, a.schilgen=1, a.edc=0
     c+ WHERE a.akfirm in (select b.tefirm from teil01 b
     c+                    where a.akfirm=b.tefirm and
     c+                          a.item  =b.tetenr and
     c+                                   b.TEDIEK='LR')
     c/end-exec



     C     ##1000        ENDSR

     C**************************************************************************
     C*part two     total
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##2000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q1
     c+ select distinct char('Total', 10) location,
     c+ ITEM, ARTNR, LADEM, LFSL, LFSH, LFSB, LFSq, dec(0, 08, 0)
     c+ JanA,dec(0, 08, 0) FEBA,dec(0, 08, 0) MAEA, dec(0, 08, 0)
     c+ APRA,dec(0, 08, 0) MaiA,dec(0, 08, 0) junA, dec(0, 08, 0)
     c+ JulA,dec(0, 08, 0) augA,dec(0, 08, 0) sepA, dec(0, 08, 0)
     c+ oktA,dec(0, 08, 0) novA,dec(0, 08, 0) dezA, dec(0, 08, 0) akta,
     c+                                             dec(0, 08, 0)
     c+ Janh,dec(0, 08, 0) FEBh,dec(0, 08, 0) MAEh, dec(0, 08, 0)
     c+ APRh,dec(0, 08, 0) Maih,dec(0, 08, 0) junh, dec(0, 08, 0)
     c+ Julh,dec(0, 08, 0) augh,dec(0, 08, 0) seph, dec(0, 08, 0)
     c+ okth,dec(0, 08, 0) novh,dec(0, 08, 0) dezh, dec(0, 08, 0) akth,
     c+ char(' ', 15) TEERTE
     c+ FROM rpm_lfs where ENTRY# <> 'open orders'
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' ')
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' ')
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q2
     c+ SELECT JAHR, MONAT, ITEM, zoned(sum(APGLMG), 10, 0),
     c+ dec(count(*), 10, 0 ) anzahl from rpm_lfs
     c+ where jahr = year(current date) or jahr = year(current date -1 year)
     c+ and  ENTRY# <> 'open orders'
     c+ GROUP BY JAHR, MONAT, ITEM
     c/end-exec

       // ... current year and current month Absatz
     c/exec sql
     c+ update RPM_LFS_Q1 a set akta=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec


       // ... absatz 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jana=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set feba=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=02  and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maea=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set apra=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maia=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set juna=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

       // ... absatz 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jula=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set auga=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09  or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set sepa=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okta=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set nova=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12  or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set deza=
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec


       // ... current year and current month commonness
     c/exec sql
     c+ update RPM_LFS_Q1 a set akth=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec


       // ... commonness 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set janh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set febh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maeh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set aprh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maih=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set junh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

       // ... commonness 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set julh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set augh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09 or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set seph=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okth=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set novh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12 or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set dezh=
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q2 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+  group by  jahr, monat)
     c/end-exec

       // ... Filter erledigte items, gibt es Ersatz für
     c/exec sql
     c+ update  RPM_LFS_Q1 set   TEERTE =  '*'
     c+ WHERE TEERTE =  ' ' and item   in (select teerte from RPM_LFS_Q1)
     c/end-exec


     C     ##2000        ENDSR

     C**************************************************************************
     C*part two     edc
     C*-------------------------------------------------------------------------

     C     sr3000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##3000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q1
     c+ select distinct char('EDC       ', 10) location,
     c+ ITEM, ARTNR, LADEM, LFSL, LFSH, LFSB, LFSq, dec(0, 08, 0)
     c+ JanA,dec(0, 08, 0) FEBA,dec(0, 08, 0) MAEA, dec(0, 08, 0)
     c+ APRA,dec(0, 08, 0) MaiA,dec(0, 08, 0) junA, dec(0, 08, 0)
     c+ JulA,dec(0, 08, 0) augA,dec(0, 08, 0) sepA, dec(0, 08, 0)
     c+ oktA,dec(0, 08, 0) novA,dec(0, 08, 0) dezA, dec(0, 08, 0) akta,
     c+                                             dec(0, 08, 0)
     c+ Janh,dec(0, 08, 0) FEBh,dec(0, 08, 0) MAEh, dec(0, 08, 0)
     c+ APRh,dec(0, 08, 0) Maih,dec(0, 08, 0) junh, dec(0, 08, 0)
     c+ Julh,dec(0, 08, 0) augh,dec(0, 08, 0) seph, dec(0, 08, 0)
     c+ okth,dec(0, 08, 0) novh,dec(0, 08, 0) dezh, dec(0, 08, 0) akth,
     c+ char(' ', 15) TEERTE
     c+ FROM rpm_lfs where EDC ='1' and ENTRY# <> 'open orders'
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q3
     c+ SELECT JAHR, MONAT, ITEM, zoned(sum(APGLMG), 10, 0),
     c+ dec(count(*), 10, 0 ) anzahl from rpm_lfs
     c+ where (jahr = year(current date) or jahr = year(current date -1 year))
     c+ and   edc= 1  and ENTRY# <> 'open orders'
     c+ GROUP BY JAHR, MONAT, ITEM
     c/end-exec

       // ... current year and current month Absatz
     c/exec sql
     c+ update RPM_LFS_Q1 a set akta=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... absatz 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jana=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set feba=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=02  and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maea=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set apra=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maia=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set juna=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... absatz 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jula=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set auga=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09  or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set sepa=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okta=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set nova=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12  or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set deza=
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... current year and current month commonness
     c/exec sql
     c+ update RPM_LFS_Q1 a set akth=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... commonness 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set janh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set febh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maeh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set aprh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maih=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set junh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... commonness 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set julh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set augh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09 or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set seph=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okth=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set novh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12 or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set dezh=
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q3 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... Filter erledigte items, gibt es Ersatz für
     c/exec sql
     c+ update  RPM_LFS_Q1 set   TEERTE =  '*'
     c+ WHERE TEERTE =  ' ' and item   in (select teerte from RPM_LFS_Q1)
     c+       and location=:LOCATION
     c/end-exec


     C     ##3000        ENDSR

     C**************************************************************************
     C*part two     SCHILGEN
     C*-------------------------------------------------------------------------

     C     sr4000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##4000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q1
     c+ select distinct char('SCHILGEN  ', 10) location,
     c+ ITEM, ARTNR, LADEM, LFSL, LFSH, LFSB, LFSq, dec(0, 08, 0)
     c+ JanA,dec(0, 08, 0) FEBA,dec(0, 08, 0) MAEA, dec(0, 08, 0)
     c+ APRA,dec(0, 08, 0) MaiA,dec(0, 08, 0) junA, dec(0, 08, 0)
     c+ JulA,dec(0, 08, 0) augA,dec(0, 08, 0) sepA, dec(0, 08, 0)
     c+ oktA,dec(0, 08, 0) novA,dec(0, 08, 0) dezA, dec(0, 08, 0) akta,
     c+                                             dec(0, 08, 0)
     c+ Janh,dec(0, 08, 0) FEBh,dec(0, 08, 0) MAEh, dec(0, 08, 0)
     c+ APRh,dec(0, 08, 0) Maih,dec(0, 08, 0) junh, dec(0, 08, 0)
     c+ Julh,dec(0, 08, 0) augh,dec(0, 08, 0) seph, dec(0, 08, 0)
     c+ okth,dec(0, 08, 0) novh,dec(0, 08, 0) dezh, dec(0, 08, 0) akth,
     c+ char(' ', 15) TEERTE
     c+ FROM rpm_lfs where SCHILGEN ='1' and ENTRY# <> 'open orders'
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q4
     c+ SELECT JAHR, MONAT, ITEM, zoned(sum(APGLMG), 10, 0),
     c+ dec(count(*), 10, 0 ) anzahl from rpm_lfs
     c+ where (jahr = year(current date) or jahr = year(current date -1 year))
     c+ and   schilgen=1 and ENTRY# <> 'open orders'
     c+ GROUP BY JAHR, MONAT, ITEM
     c/end-exec

       // ... current year and current month Absatz
     c/exec sql
     c+ update RPM_LFS_Q1 a set akta=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... absatz 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jana=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set feba=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=02  and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maea=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set apra=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maia=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set juna=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... absatz 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jula=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set auga=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09  or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set sepa=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okta=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set nova=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12  or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set deza=
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... current year and current month commonness
     c/exec sql
     c+ update RPM_LFS_Q1 a set akth=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... commonness 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set janh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set febh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maeh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set aprh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maih=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set junh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... commonness 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set julh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set augh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09 or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set seph=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okth=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set novh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12 or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set dezh=
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q4 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... Filter erledigte items, gibt es Ersatz für
     c/exec sql
     c+ update  RPM_LFS_Q1 set   TEERTE =  '*'
     c+ WHERE TEERTE =  ' ' and item   in (select teerte from RPM_LFS_Q1)
     c+       and location=:LOCATION
     c/end-exec


     C     ##4000        ENDSR

     C**************************************************************************
     C*part two     Silfox
     C*-------------------------------------------------------------------------

     C     sr5000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##5000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q1
     c+ select distinct char('SILFOX    ', 10) location,
     c+ ITEM, ARTNR, LADEM, LFSL, LFSH, LFSB, LFSq, dec(0, 08, 0)
     c+ JanA,dec(0, 08, 0) FEBA,dec(0, 08, 0) MAEA, dec(0, 08, 0)
     c+ APRA,dec(0, 08, 0) MaiA,dec(0, 08, 0) junA, dec(0, 08, 0)
     c+ JulA,dec(0, 08, 0) augA,dec(0, 08, 0) sepA, dec(0, 08, 0)
     c+ oktA,dec(0, 08, 0) novA,dec(0, 08, 0) dezA, dec(0, 08, 0) akta,
     c+                                             dec(0, 08, 0)
     c+ Janh,dec(0, 08, 0) FEBh,dec(0, 08, 0) MAEh, dec(0, 08, 0)
     c+ APRh,dec(0, 08, 0) Maih,dec(0, 08, 0) junh, dec(0, 08, 0)
     c+ Julh,dec(0, 08, 0) augh,dec(0, 08, 0) seph, dec(0, 08, 0)
     c+ okth,dec(0, 08, 0) novh,dec(0, 08, 0) dezh, dec(0, 08, 0) akth,
     c+ char(' ', 15) TEERTE
     c+ FROM rpm_lfs where SILFOX   ='1' and ENTRY# <> 'open orders'
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q5
     c+ SELECT JAHR, MONAT, ITEM, zoned(sum(APGLMG), 10, 0),
     c+ dec(count(*), 10, 0 ) anzahl from rpm_lfs
     c+ where (jahr = year(current date) or jahr = year(current date -1 year))
     c+ and   silfox  =1 and ENTRY# <> 'open orders'
     c+ GROUP BY JAHR, MONAT, ITEM
     c/end-exec

       // ... current year and current month Absatz
     c/exec sql
     c+ update RPM_LFS_Q1 a set akta=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... absatz 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jana=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set feba=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=02  and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maea=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set apra=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maia=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set juna=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... absatz 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jula=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set auga=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09  or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set sepa=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okta=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set nova=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12  or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set deza=
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... current year and current month commonness
     c/exec sql
     c+ update RPM_LFS_Q1 a set akth=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... commonness 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set janh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set febh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maeh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set aprh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maih=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set junh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... commonness 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set julh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set augh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09 or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set seph=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okth=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set novh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12 or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set dezh=
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q5 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... Filter erledigte items, gibt es Ersatz für
     c/exec sql
     c+ update  RPM_LFS_Q1 set   TEERTE =  '*'
     c+ WHERE TEERTE =  ' ' and item   in (select teerte from RPM_LFS_Q1)
     c+       and location=:LOCATION
     c/end-exec


     C     ##5000        ENDSR

     C**************************************************************************
     C*part four    open orders
     C*-------------------------------------------------------------------------

     C     sr6000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##6000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q1
     c+ select distinct char('OpenOrders', 10) location,
     c+ ITEM, ARTNR, LADEM, LFSL, LFSH, LFSB, LFSq, dec(0, 08, 0)
     c+ JanA,dec(0, 08, 0) FEBA,dec(0, 08, 0) MAEA, dec(0, 08, 0)
     c+ APRA,dec(0, 08, 0) MaiA,dec(0, 08, 0) junA, dec(0, 08, 0)
     c+ JulA,dec(0, 08, 0) augA,dec(0, 08, 0) sepA, dec(0, 08, 0)
     c+ oktA,dec(0, 08, 0) novA,dec(0, 08, 0) dezA, dec(0, 08, 0) akta,
     c+                                             dec(0, 08, 0)
     c+ Janh,dec(0, 08, 0) FEBh,dec(0, 08, 0) MAEh, dec(0, 08, 0)
     c+ APRh,dec(0, 08, 0) Maih,dec(0, 08, 0) junh, dec(0, 08, 0)
     c+ Julh,dec(0, 08, 0) augh,dec(0, 08, 0) seph, dec(0, 08, 0)
     c+ okth,dec(0, 08, 0) novh,dec(0, 08, 0) dezh, dec(0, 08, 0) akth,
     c+ char(' ', 15) TEERTE
     c+ FROM rpm_lfs where  ENTRY# =  'open orders'
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm ='01'    and
     c+                                      a.item  =b.tetenr
     c+        and location=:LOCATION)
     c/end-exec

     c/exec sql
     c+ update rpm_lfs_q1 a set a.TEERTE =
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c+  where exists
     c+ (select b.TEERTE from teil01 b where tefirm   ='01'     and
     c+                                      a.artnr  =b.tetenr and
     c+                                      a.teerte =' '
     c+        and location=:LOCATION)
     c/end-exec

       // ... statistische Werte
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LFS_Q6
     c+ SELECT JAHR, MONAT, ITEM, zoned(sum(APGLMG), 10, 0),
     c+ dec(count(*), 10, 0 ) anzahl from rpm_lfs
     c+ where (jahr = year(current date) or jahr = year(current date -1 year))
     c+ and   ENTRY# = 'open orders'
     c+ GROUP BY JAHR, MONAT, ITEM
     c/end-exec

       // ... current year and current month Absatz
     c/exec sql
     c+ update RPM_LFS_Q1 a set akta=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... absatz 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jana=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set feba=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=02  and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maea=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set apra=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maia=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set juna=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... absatz 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set jula=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set auga=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09  or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set sepa=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okta=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set nova=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12  or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set deza=
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(APGLMG) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... current year and current month commonness
     c/exec sql
     c+ update RPM_LFS_Q1 a set akth=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr = year(current date) and
     c+        monat=month(current date) and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec


       // ... commonness 1. Halbjahr
     c                   clear                   j                 4 0
     c                   if        (monat) = 01 or
     c                             (monat) < 01
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set janh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=01 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 02 or
     c                             (monat) < 02
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set febh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=02 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 03 or
     c                             (monat) < 03
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maeh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=03 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 04 or
     c                             (monat) < 04
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set aprh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=04 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 05 or
     c                             (monat) < 05
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set maih=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=05 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 06 or
     c                             (monat) < 06
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set junh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=06 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... commonness 2. Halbjahr
     c                   if        (monat) = 07 or
     c                             (monat) < 07
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set julh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=07 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 08 or
     c                             (monat) < 08
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set augh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=08 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 09 or
     c                             (monat) < 09
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set seph=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=09 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 10 or
     c                             (monat) < 10
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set okth=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=10 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 11 or
     c                             (monat) < 11
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set novh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=11 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

     c                   if        (monat) = 12 or
     c                             (monat) < 12
     c                   eval      j = jahr - 1
     c                   else
     c                   eval      j = jahr
     c                   endif
     c/exec sql
     c+ update RPM_LFS_Q1 a set dezh=
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c+  where exists
     c+ (select sum(anzahl) from RPM_LFS_Q6 b
     c+  where jahr=:j   and monat=12 and
     c+        (b.item=a.item  or b.item=a.TEERTE)
     c+        and location=:LOCATION
     c+  group by  jahr, monat)
     c/end-exec

       // ... Filter erledigte items, gibt es Ersatz für
     c/exec sql
     c+ update  RPM_LFS_Q1 set   TEERTE =  '*'
     c+ WHERE TEERTE =  ' ' and item   in (select teerte from RPM_LFS_Q1)
     c+       and location=:LOCATION
     c/end-exec


     C     ##6000        ENDSR

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
