
      //************************************************************************
      //
      //      Programmname       IGLOOR
      //      Erstellt  am       20.06.2024
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Igloo Transfer Daten      e
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //
      //
      //
      //
      //************************************************************************
      // Übersetzungshinweise:
      // Restartmöglichkeiten:
      // _____________________
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      //
      //
      //
      //
      //
      //
      ///################################
      ///
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

     fAFVS_AFSPluf   e           k DISK    usropn
     f                                     RENAME(AFVS_AFSP:LOG01R)

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


       // define files
       // ______________________________________________________________________
     d AFVS_AFSPl_i  e ds                  ExtName(AFVS_AFSPl:*input)
     d                                     Qualified

     d AFVS_AFSPl_o  E DS                  ExtName(AFVS_AFSPl:*output)
     d                                     Qualified

     d AFVS_AFSPl_k  E DS                  ExtName(AFVS_AFSPl:*key)
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
     D §SNDREC         s              3a   inz
     D §PRTNUM         s             35a   inz
     D §MSGTYP         s              6a   inz
     D §MAIKEY         s             35a   inz
     D §HRCLVL         s              9a   inz
     D §LINNUM         s              6s 0 inz

     IPHY01R
     I              status                      §status
      /eject

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start FTP Transfer for AKTIVBANKR   ';

       exsr      SR_log;

       //Urspungsland Update



       eval status ='Ende  FTP Transfer for AKTIVBANKR   ';
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
       //-------------------------------------------------------cc--------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';




       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //create index tvrelwaeco/AFVS_AFSPl on tvrelwaeco/AFVS_AFSP
       //(U_AFSP,U_AFVS,AKWKNR,AKAFJJ, AKAFNR, WERK2 desc, JAHR2, AUFTRAG2)
       //-----------------------------------------------------------------------

       begsr AFVS_AFSP0;

          open AFVS_AFSPl;
          AFVS_AFSPl_k.U_AFSP  =  *blank;
          AFVS_AFSPl_k.U_AFVS  =  *blank;
          setll %kds(AFVS_AFSPl_k:1) AFVS_AFSPl;
          reade %kds(AFVS_AFSPl_k:1) AFVS_AFSPl  AFVS_AFSPl_i;
          dow not %eof(AFVS_AFSPl);
             if AFVS_AFSPl_i.U_AFSP = *blank and
                AFVS_AFSPl_i.U_AFVS = *blank;
                if AFVS_AFSPl_i.WERK2    <> *blank and
                   AFVS_AFSPl_i.JAHR2    <> *zero  and
                   AFVS_AFSPl_i.AUFTRAG2 <> *blank;
       //1.) alte Kommnummer sichern und Aufgaben ableiten
       //2.) alte Lieferantennummer für afsp überschreiben aus
       //    nachkommendem Satz                ==> prüfen
                   a_AMFIRM = AFVS_AFSPl_i.AMFIRM;
                   a_AMKMJJ = AFVS_AFSPl_i.AMKMJJ;
                   a_AMKMNR = AFVS_AFSPl_i.AMKMNR;
                else;
       //                            Aufgaben ableiten
                else;
                endif;
             endif;
             AFVS_AFSPl_i.U_AFSP = '1';
             AFVS_AFSPl_i.U_AFVS = '1';
             AFVS_AFSPl_o = AFVS_AFSPl_i;
             update phy01r   AFVS_AFSPl_o;
             eval status ='####  IGLOOR1300   ' + a_AMFIR  + ' '
                                                + a_AMKMJJ + ' '
                                                + a_AMKMNR  ;
       //no log exsr      SR_log;

             endif;
          enddo;

          close AFVS_AFSPl;

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

       //callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
       //               p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       endsr;


