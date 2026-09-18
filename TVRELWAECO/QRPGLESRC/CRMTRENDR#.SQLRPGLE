
      //************************************************************************
      //
      //      Programmname       EDCPurch   WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://
      //      http://
      //      http://
      // URL: http://
      //
      // Username: _____________
      // Passwort: _____________
      //
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************

      //------------------------------------------------------------------------
      //    S T E U E R - B E S T I M M U N G E N
      //------------------------------------------------------------------------
     h datfmt(*ISO)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // Orderkopf und Positionen
     fcrmtrend  uf a e             disk    RENAME(crmtrend:notes)
     f                                     USROPN
     F                                     INFDS(DSF1)
     fkund01    if   e           k DISK
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d CRMTRENDr       PR
       //Übergabe position
     d p_von                         10a
     d p_bis                         10a
     d p_adat                         8s 0
     d p_position                          dim(0100)
     d                                     likeds(p_array1)
     d p_Message                     80a
     d p_cc                           1

     d CRMTRENDr       PI
       //Übergabe items
     d p_von                         10a
     d p_bis                         10a
     d p_adat                         8s 0
     d p_position                          dim(0100)
     d                                     likeds(p_array1)
     d p_Message                     80a
     d p_cc                           1

      // System-Datenstruktur
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

     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0

     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

     d CRMTREND_I    E DS                  ExtName(CRMTREND:*input)
     d                                     Qualified
     d CRMTREND_O    E DS                  ExtName(CRMTREND:*output)
     d                                     Qualified
     d kund_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified
     d kund_i        E DS                  ExtName(kund01:*input)
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

     D w_rrn           s              5  0 inz
     D status          s            132A   inz
       //currently mobicool
     D p_supplier      s             10A   inz ('90363     ')
     D p_email         s            132A   inz ('manfred.gang@dometic.com')
     D headerdone      s              1a   inz
     D error1          s              1a   inz
       // D UsaDate         s               d   DatFmt(*USA) Inz(d'07/04/2008')
       // D EurDate         s               d   DatFmt(*EUR) Inz(d'25122000')
     D IsoDate         s               d   DatFmt(*ISO) Inz(d'2008-10-31')

       //Übergabe Datenstruktur Position
      // d p_Array1      e ds                  qualified dim(0100)
      //          per sql erstellt        extname(CRMTREND:*input)

     d p_Array1        ds                  qualified dim(0100)
     d                                     export
     D KDKDST                         2a   inz
     D KDJDAT                         8s 0 inz
     D KDJZEI                         6s 0 inz
     D KDFIRM                         2a   inz
     D KDKDNR                        10a   inz
     D KDMCBG                        10a   inz
     D KDNAM1                        30a   inz
     D KDNAM2                        30a   inz
     D KDNAM3                        30a   inz
     D KDSTRA                        30a   inz
     D KDHSNR                        10a   inz
     D KDKSTC                         3a   inz
     D KDPOLD                         3a   inz
     D KDPOLZ                        10a   inz
     D KDWORT                        30a   inz
     D KDPOFA                        10a   inz
     D KDKNAM                        30a   inz
     D KDTLNR                        20a   inz
     D KDTXNR                        20a   inz
     D KDTFNR                        20a   inz
     D KDLAND                         3a   inz
     D KDZABD                         3a   inz
     D KDVKGB                         4a   inz
     D KDKDGR                         4a   inz
     D KDNIGB                         3a   inz
     D KDAFWS                         9s 0 inz
     D KDOPSU                         9s 0 inz
     D KDKLSU                         9s 0 inz
     D KDEWJDAT                       8s 0 inz
     D KDEWJZEI                       6p 0 inz
     D KDEWKSST                      10a   inz
     D VZJDAT                         8s 0 inz
     D VZJZEI                         6s 0 inz
     D VZKDLI                        10a   inz
     D VZGADA                         8s 0 inz
     D VZGBDA                         8s 0 inz
     D VZVTN1                        10a   inz
     D VZVTN2                        10a   inz
     D VZVTN3                        10a   inz
     D VZVTN4                        10a   inz
     D VZVTN5                        10a   inz

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       p_cc       = '0';
       //übergabe enthält Information ASN

       eval status ='Start WebService CrmOutput eingeleitet       ';
       exsr      SR_log;
       p_cc      = '1';

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(LOTUS) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(LOTUS) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(TVPF) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(TVPF) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

       open  kund01;
       open  crmtrend;
       w_rrn = 1;
       read CRMTREND   CRMTREND_i;
       dow not %eof(CRMTREND) and
       //maxwert
          w_rrn < 0099;
          if headerdone    <> '*';
       //kund01
             kund_k.kdFIRM = '01';
             kund_k.kdkdnr = p_supplier;
             chain %kds(kund_k:1) kund01 kund_I;
             if %found(kund01);
                exsr srheader;
             else;
                p_Message = 'Client unknown in setting for this option';
                leave;
             endif;
             headerdone  ='*';
          endif;
       //update
       // if F1RRN > 8950;
             exsr srline;
             p_Message = 'Notes Custerm forCRM generated: ' +
                          %char(w_rrn) + ' records ' +%char(f1rrn);
             eval status = p_Message;
             exsr      SR_log;
             p_cc      = '0';
       // endif;
          read CRMTREND   CRMTREND_i;
       // if F1RRN > 8950;
             w_rrn=w_rrn + 1;
       // endif;
       enddo;

       close kund01;
       close crmtrend;

       eval status = p_Message;
       exsr      SR_log;
       eval status ='Ende WebService CrmOutput eingeleitet     ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //header
       //-----------------------------------------------------------------------

       begsr srheader;
         clear p_Array1;
         clear p_position;
       endsr;

       //-----------------------------------------------------------------------
       //line
       //-----------------------------------------------------------------------

       begsr srline;

       P_Array1(w_RRN).KDKDST     = crmTrend_i.KDKDST   ;
       P_Array1(w_RRN).KDJDAT     = crmTrend_i.KDJDAT   ;
       P_Array1(w_RRN).KDJZEI     = crmTrend_i.KDJZEI   ;
       P_Array1(w_RRN).KDFIRM     = crmTrend_i.KDFIRM   ;
       P_Array1(w_RRN).KDKDNR     = crmTrend_i.KDKDNR   ;
       P_Array1(w_RRN).KDMCBG     = crmTrend_i.KDMCBG   ;
       P_Array1(w_RRN).KDNAM1     = crmTrend_i.KDNAM1   ;
       P_Array1(w_RRN).KDNAM2     = crmTrend_i.KDNAM2   ;
       P_Array1(w_RRN).KDNAM3     = crmTrend_i.KDNAM3   ;
       P_Array1(w_RRN).KDSTRA     = crmTrend_i.KDSTRA   ;
       P_Array1(w_RRN).KDHSNR     = crmTrend_i.KDHSNR   ;
       P_Array1(w_RRN).KDKSTC     = crmTrend_i.KDKSTC   ;
       P_Array1(w_RRN).KDPOLD     = crmTrend_i.KDPOLD   ;
       P_Array1(w_RRN).KDPOLZ     = crmTrend_i.KDPOLZ   ;
       P_Array1(w_RRN).KDWORT     = crmTrend_i.KDWORT   ;
       P_Array1(w_RRN).KDPOFA     = crmTrend_i.KDPOFA   ;
       P_Array1(w_RRN).KDKNAM     = crmTrend_i.KDKNAM   ;
       P_Array1(w_RRN).KDTLNR     = crmTrend_i.KDTLNR   ;
       P_Array1(w_RRN).KDTXNR     = crmTrend_i.KDTXNR   ;
       P_Array1(w_RRN).KDTFNR     = crmTrend_i.KDTFNR   ;
       P_Array1(w_RRN).KDLAND     = crmTrend_i.KDLAND   ;
       P_Array1(w_RRN).KDZABD     = crmTrend_i.KDZABD   ;
       P_Array1(w_RRN).KDVKGB     = crmTrend_i.KDVKGB   ;
       P_Array1(w_RRN).KDKDGR     = crmTrend_i.KDKDGR   ;
       P_Array1(w_RRN).KDNIGB     = crmTrend_i.KDNIGB   ;
       P_Array1(w_RRN).KDAFWS     = crmTrend_i.KDAFWS   ;
       P_Array1(w_RRN).KDOPSU     = crmTrend_i.KDOPSU   ;
       P_Array1(w_RRN).KDKLSU     = crmTrend_i.KDKLSU   ;
       P_Array1(w_RRN).KDEWJDAT   = crmTrend_i.KDEWJDAT ;
       P_Array1(w_RRN).KDEWJZEI   = crmTrend_i.KDEWJZEI ;
       P_Array1(w_RRN).KDEWKSST   = crmTrend_i.KDEWKSST ;
       P_Array1(w_RRN).VZJDAT     = crmTrend_i.VZJDAT   ;
       P_Array1(w_RRN).VZJZEI     = crmTrend_i.VZJZEI   ;
       P_Array1(w_RRN).VZKDLI     = crmTrend_i.VZKDLI   ;
       P_Array1(w_RRN).VZGADA     = crmTrend_i.VZGADA   ;
       P_Array1(w_RRN).VZGBDA     = crmTrend_i.VZGBDA   ;
       P_Array1(w_RRN).VZVTN1     = crmTrend_i.VZVTN1   ;
       P_Array1(w_RRN).VZVTN2     = crmTrend_i.VZVTN2   ;
       P_Array1(w_RRN).VZVTN3     = crmTrend_i.VZVTN3   ;
       P_Array1(w_RRN).VZVTN4     = crmTrend_i.VZVTN4   ;
       P_Array1(w_RRN).VZVTN5     = crmTrend_i.VZVTN5   ;
       p_position(w_rrn)          = p_Array1(w_rrn)     ;
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
