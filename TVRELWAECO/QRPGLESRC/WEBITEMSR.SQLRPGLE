
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
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
     h datfmt(*EUR)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2015')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------


      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d WEBITEMSR       PR
     d p_User                        50a
     d p_Pword                       20a
       //Übergabe Datenstruktur
     d p_item                        15a
     d p_itemdes                     30a
       //Abmessungen
     d p_Laenge                       8s 4
     d p_Breite                       8s 4
     d p_Hoehe                        8s 4
       //Gewichte
     d p_BrtGew                       8s 4
     d p_NetGew                       8s 4
       //Lademittel
     d p_LM                           3a
     d p_LMMenge                      8s 4
       //EAN
     d p_EAN                         13a
     d p_Message3                    80a
     d p_cc                           1

     d WEBITEMSR       PI
     d p_User                        50a
     d p_Pword                       20a
       //Übergabe Datenstruktur
     d p_item                        15a
     d p_itemdes                     30a
       //Abmessungen
     d p_Laenge                       8s 4
     d p_Breite                       8s 4
     d p_Hoehe                        8s 4
       //Gewichte
     d p_BrtGew                       8s 4
     d p_NetGew                       8s 4
       //Lademittel
     d p_LM                           3a
     d p_LMMenge                      8s 4
       //EAN
     d p_EAN                         13a
     d p_Message3                    80a
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


     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

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


       // ______________________________________________________________________
       // KHT_INSERT
       // ______________________________________________________________________
     D KHT_INSERT      PR                  ExtPgm('KHT_INSERT')
     d p_tenr#                       15a
     d p_quan#                       11p02
     d p_lang#                       11p02
     d p_brei#                       11p02
     d p_hohe#                       11p02
     d p_gwbr#                       11p02
     d p_gwnt#                       11p02
     d p_ean#                        15a
     d p_lm#                          3a
     d p_cc#                          1
     d p_user#                       50a


     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz

     d p_tenr#         s             15a
     d p_quan#         s             11p02
     d p_lang#         s             11p02
     d p_brei#         s             11p02
     d p_hohe#         s             11p02
     d p_gwbr#         s             11p02
     d p_gwnt#         s             11p02
     d p_ean#          s             15a
     d p_lm#           s              3a
     d p_cc#           s              1
     d p_user#         s             50a

     D w_rrn           s              2  0 inz
     D status          s            132A   inz

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



       //übergabe enthält Information
       p_tenr#   =  p_item   ;
       p_quan#   =  p_LMMenge;
       p_lang#   =  p_Laenge ;
       p_brei#   =  p_Breite ;
       p_hohe#   =  p_Hoehe  ;
       p_gwbr#   =  p_BrtGew ;
       p_gwnt#   =  p_NetGew ;
       p_ean#    =  p_EAN    ;
       p_lm#     =  p_LM     ;
       p_cc#     =  '0'      ;
       p_user#   =  p_user   ;

       eval status ='Start WebItemsr aufgerufen                ';
       exsr      SR_log;
          eval status ='Start callP KHT_INSERT                    ';
          exsr      SR_log;
          callP KHT_INSERT(P_tenr# : P_quan# : P_lang# : P_brei# : P_hohe# :
                           P_gwbr# : P_gwnt# : P_ean#  : P_lm#   : P_cc# :
                           P_user#);
          eval status ='Ende  callP KHT_INSERT                    ';
          exsr      SR_log;
       eval status ='Ende WebItemsr                            ';
       exsr      SR_log;

       *inlr = *on;

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
