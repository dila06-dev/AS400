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
     f
     fpbfstss   if   e           K DISK    RENAME(pbfstssf:LOG01R)
     f
     fteil01    if   e           K DISK    RENAME(teil1:LOG02R)
     f
     flbpm01    if   e           K DISK    RENAME(lbpm1:LOG03R)
      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
     d KHT_ITEMR       PR
     d p_firm                         2a
     d p_fkt                          3a
     d p_tenr                        15a
     d lfz_ean                       15a
     d lfz_lang                      11p02
     d lfz_brei                      11p02
     d lfz_hohe                      11p02
     d lfz_gwbr                      11p02
     d lfz_gwnt                      11p02
     d lfz_lm                         3a
     d tr_ean                        15a
     d tr_lang                       11p02
     d tr_brei                       11p02
     d tr_hohe                       11p02
     d tr_gwbr                       11p02
     d tr_gwnt                       11p02
     d tr_lm                          3a
     d p_cc                           1

     d KHT_ITEMR       PI
     d p_firm                         2a
     d p_fkt                          3a
     d p_tenr                        15a
     d lfz_ean                       15a
     d lfz_lang                      11p02
     d lfz_brei                      11p02
     d lfz_hohe                      11p02
     d lfz_gwbr                      11p02
     d lfz_gwnt                      11p02
     d lfz_lm                         3a
     d tr_ean                        15a
     d tr_lang                       11p02
     d tr_brei                       11p02
     d tr_hohe                       11p02
     d tr_gwbr                       11p02
     d tr_gwnt                       11p02
     d tr_lm                          3a
     d p_cc                           1

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

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified


     d teil01_i      E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil01_k      E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d lbpm01_i      E DS                  ExtName(lbpm01:*input)
     d                                     Qualified

     d lbpm01_k      E DS                  ExtName(lbpm01:*key)
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

     D*
     I*-------------------------------------------------------------------------
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

      /FREE
       //:::
             Exsr      sr_log;

             clear lfz_ean;
             clear lfz_lang;
             clear lfz_brei;
             clear lfz_hohe;
             clear lfz_gwbr;
             clear lfz_gwnt;
             clear lfz_lm;
             clear tr_ean;
             clear tr_lang;
             clear tr_brei;
             clear tr_hohe;
             clear tr_gwbr;
             clear tr_gwnt;
             clear tr_lm;
             clear p_cc;

             pbfstss_k.tzkonz = 'EMS';
             pbfstss_k.tzfirm = 'DWI';
             pbfstss_k.tziden = P_tenr;
             chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
             if %found(pbfstss);
       //pbfstss kl.Einheit
                if p_fkt ='II ';
                   lfz_ean           = pbfstss_i.TZEAN;
                   lfz_lang          = pbfstss_i.TZVLL/10;
                   lfz_brei          = pbfstss_i.TZVLB/10;
                   lfz_hohe          = pbfstss_i.TZVLH/10;
                   lfz_gwbr          = pbfstss_i.TZBRUT;
                   lfz_gwnt          = pbfstss_i.TZNETT;
                   lfz_lm           = '???';
                   if   pbfstss_i.TZLM <> '   ';
                      lfz_lm            = pbfstss_i.TZLM;
                   endif;
                endif;
                p_cc            = '1';
             else;
                p_cc            = 'E';
             endif;

             teil01_k.TEFIRM = '01';
             teil01_k.TETENR = P_tenr;
             chain %kds(teil01_k:2) teil01    teil01_I;
             if %found(teil01);
       //pbfstss kl.Einheit
                if p_fkt ='II ';
                   tr_ean           = teil01_i.TEEANR;
                   tr_lang          = teil01_i.TELANG*1;
                   tr_brei          = teil01_i.TEBREI*1;
                   tr_hohe          = teil01_i.TEHOHE*1;
                   tr_gwbr          = teil01_i.tegwbr;
                   tr_gwnt          = teil01_i.tegwnt;
                   tr_lm            = '???';
                   LBPM01_k.LBPMFIRM = '01';
                   LBPM01_k.LBPMTENR = P_tenr;
                   chain %kds(LBPM01_k:2) LBPM01    LBPM01_I;
                   if %found(LBPM01);
                      tr_lm            = LBPM01_i.LBPMVPMI;
                   endif;
                endif;
             else;
                p_cc            = 'E';
             endif;

      /End-FREE
       //statistik
     c                   Exsr      sr_log

     C                   EXSR      RETURN

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
