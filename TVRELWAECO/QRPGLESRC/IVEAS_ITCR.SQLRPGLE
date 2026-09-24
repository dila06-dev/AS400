
      //************************************************************************
      //
      //      Programmname       IVEAS_ITCR
      //      Erstellt  am       13.01.2025
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       iveas interface
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
      //
      // Restartmöglichkeiten:
      // _____________________
      //
      // SELECT TEFIRM, TEWKNR, TETENR ,dec(0, 10) #cc, current date #date,
      // current timestamp TSTAMP_I, char('  ', 2) STATUS_M, current
      // timestamp TSTAMP_M, char('  ', 2) STATUS_R, current timestamp
      // TSTAMP_r FROM teil01 WHERE tetenr='15118.514.070'  and tefirm
      // ='01'
      // Datei IVEAS_ITC in TVRELWAECO wurde erstellt.
      // von 42 auf 82 auf 41 auf 83
      //
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

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     fIVEAS_ITC uf   e             DISK    RENAME(IVEAS_ITC:PHY01R)

     fIVEAS_IT1 o  a e             disk    RENAME(IVEAS_IT1:PHY02R)

     fteil01    if   e           k DISK

     flief01    if   e           k DISK
     f
     flpif01    if   e           k DISK
     f
     fteew01    if   e           k DISK
     f
     fzotn01    if   e           k DISK
     f
     f#preil5   if   e           k DISK
     f

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
       // define data areas
       // ______________________________________________________________________
     D IVEAS_LOAD      s             10p 0 dtaara


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d IVEAS_ITCi    E DS                  ExtName(IVEAS_ITC:*input)
     d                                     Qualified

     d IVEAS_ITCo    E DS                  ExtName(IVEAS_ITC:*output)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d lief_k        E DS                  ExtName(lief01:*key)
     d                                     Qualified

     d lief_i        E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d lpif_k        E DS                  ExtName(lpif01:*key)
     d                                     Qualified

     d lpif_i        E DS                  ExtName(lpif01:*input)
     d                                     Qualified

     d IVEAS_IT1i    E DS                  ExtName(IVEAS_IT1:*input)
     d                                     Qualified

     d IVEAS_IT1o    E DS                  ExtName(IVEAS_IT1:*output)
     d                                     Qualified

     d zotn_k        E DS                  ExtName(zotn01:*key)
     d                                     Qualified

     d zotn_i        E DS                  ExtName(zotn01:*input)
     d                                     Qualified


     d prei_k        E DS                  ExtName(#preil5:*key)
     d                                     Qualified

     d prei_i        E DS                  ExtName(#preil5:*input)
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
     D $$TEEWPRGR_     s              1a   inz


      // Überschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for Iveas_Load   ';
       exsr      SR_log;

       exsr  srinit;

       //sql handling
          exec sql
                     whenever not found CONTINUE;;
          exec sql
                     WHENEVER SQLWARNING CONTINUE;
          exec sql
                     WHENEVER SQLERROR  CONTINUE;

          week = 0;
          exec sql
            select dec(DAYOFWEEK_iso(current date ), 1, 0)
                   into :week from qsys2/qsqptabl;

          if week > 0;
             in  *lock *dtaara;
             iveas_load = iveas_load  + 1;
             out *dtaara;
          endif;

          read IVEAS_ITC IVEAS_ITCi;
          dow not %eof(IVEAS_ITC) or  week = 0;
       //für upload
             if  IVEAS_ITCi.status_M = '  ';
                IVEAS_ITCo  = IVEAS_ITCi;
                exsr  sr_1000;
       //für message an IVEAS
                IVEAS_ITCo.STATUS_M  = '10';
                IVEAS_ITCo.#cc       = IVEAS_LOAD;
                IVEAS_ITCo.TSTAMP_M  = %timestamp();

       //update
                update PHY01R    IVEAS_ITCo;
                clear            IVEAS_ITCo;
             endif;
             read IVEAS_ITC IVEAS_ITCi;
          enddo;


         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

       eval status ='Ende  FTP Transfer for Iveas_Load   ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei
       //-----------------------------------------------------------------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';


       //Protokolldatei IVEAS_ITC füllen
       exec sql
          insert into tvrelwaeco/IVEAS_ITC
          SELECT
          b.TEFIRM, b.TEWKNR, b.TETENR,
          dec(0, 10) #cc, current date #date,
          current timestamp TSTAMP_I, char('  ', 2) STATUS_M,
          current timestamp TSTAMP_M, char('  ', 2) STATUS_R,
          current timestamp TSTAMP_r
       // from teil01 b WHERE b.tetenr='15118.514.070' and b.tefirm
          FROM teil01 b WHERE        b.tetest='42'     and b.tefirm
          ='01' and
          b.TEFIRM not in
                   (select a.tefirm from tvrelwaeco/IVEAS_ITC a
                    where a.tetenr=b.tetenr and a.STATUS_M = '  ');

       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //Schreiben Iveas Interface
       //-----------------------------------------------------------------------

       begsr sr_1000;

          clear               IVEAS_IT1o;
       // IVEAS_IT1o.#date    = %date();
       // IVEAS_IT1o.TSTAMP_M = %timestamp();
       //teil
          teil_k.tefirm    = IVEAS_ITCi.TEFIRM;
          teil_k.tetenr    = IVEAS_ITCi.TETENR;
          chain %kds(teil_k:2) teil01 teil_I;
          if %found(teil01);
             exsr sr_lief;
             exsr sr_lpif;
             exsr sr_zotn;
             exsr sr_prei;
             iveas_IT1o.SATZART1   = '1';
             iveas_IT1o.MANDT      = *blank;
             iveas_IT1o.ITEM       = teil_i.tetenr;
             iveas_IT1o.BESCHREIB1 = teil_i.TETBZ1 + teil_i.TETBZ2;
             iveas_IT1o.BESCHREIB2 = *blank;
             iveas_IT1o.ZOLLDBESCH = zotn_i.ZOTNABEZ;
             iveas_IT1o.EIGENSCH   = *blank;
             iveas_IT1o.ZOLLTARIF# = teil_i.TEZOTN;
             iveas_IT1o.ZUSATZZT#1 = *blank;
             iveas_IT1o.ZUSATZZT#2 = *blank;
             iveas_IT1o.MASSEINH   = zotn_i.ZOTNMEIN;
             iveas_IT1o.UMR_ME     = *blank;
             iveas_IT1o.MASSEINHZ1 = *blank;
             iveas_IT1o.FZMASSME1  = *blank;
             iveas_IT1o.MASSEINHZ2 = *blank;
             iveas_IT1o.FZMASSME2  = *blank;
             iveas_IT1o.VERPACKART = *blank;
             iveas_IT1o.LIEFERERKL = *blank;
             iveas_IT1o.DAT_LLEEND = *blank;
             iveas_IT1o.SAKZ       = *blank;
             iveas_IT1o.PRODGRP    = *blank;
             iveas_IT1o.MATERGRP   = *blank;
             iveas_IT1o.MATERKLAS  = *blank;
             iveas_IT1o.MWSTZOLL   = *blank;
             iveas_IT1o.WAEHRUNG   = prei_i.PRWACD;
             iveas_IT1o.PREIS      = %char(prei_i.PREZPR);
             iveas_IT1o.PREISEH    = *blank;
             iveas_IT1o.EXWPREIS   = *blank;
             iveas_IT1o.NETTOGEW   =%char(teil_i.TEGWNT);
             iveas_IT1o.BRUTTOGEW  =%char(teil_i.TEGWBR);
             iveas_IT1o.EINHEITGEW = teil_i.TEMEIN;
             iveas_IT1o.VZTA_ORD#  = *blank;
             iveas_IT1o.VZTA_OFD#  = *blank;
             iveas_IT1o.VZTA_BEMER = *blank;
             iveas_IT1o.VZTA_ANTRA = *blank;
             iveas_IT1o.VZTA_ABLAU = *blank;
             iveas_IT1o.VZTA_ERTEI = *blank;
             iveas_IT1o.URSPLAND   = lpif_i.LPHKLD;
             iveas_IT1o.URSPREGION = lpif_i.LPUREG;
             iveas_IT1o.PRAEFERENZ = *blank;
             iveas_IT1o.PRAEFULAND = *blank;
             iveas_IT1o.INHCODE1   = *blank;
             iveas_IT1o.INHPGRAD1  = *blank;
             iveas_IT1o.INHCODE2   = *blank;
             iveas_IT1o.INHPGRAD2  = *blank;
             iveas_IT1o.INHCODE3   = *blank;
             iveas_IT1o.INHPGRAD3  = *blank;
             iveas_IT1o.INHCODE4   = *blank;
             iveas_IT1o.INHPGRAD4  = *blank;
             iveas_IT1o.IVERBCODE1 = *blank;
             iveas_IT1o.IVERBMASS1 = *blank;
             iveas_IT1o.IVERBUMR1  = *blank;
             iveas_IT1o.IVERBGRAD1 = *blank;
             iveas_IT1o.IVERBWERT1 = *blank;
             iveas_IT1o.IVERBCODE2 = *blank;
             iveas_IT1o.IVERBMASS2 = *blank;
             iveas_IT1o.IVERBUMR2  = *blank;
             iveas_IT1o.IVERBGRAD2 = *blank;
             iveas_IT1o.IVERBWERT2 = *blank;
             iveas_IT1o.IVERBCODE3 = *blank;
             iveas_IT1o.IVERBMASS3 = *blank;
             iveas_IT1o.IVERBUMR3  = *blank;
             iveas_IT1o.IVERBGRAD3 = *blank;
             iveas_IT1o.IVERBWERT3 = *blank;
             iveas_IT1o.TABAKST    = *blank;
          endif;

       //write
          write PHY02R     IVEAS_IT1o;
          clear            IVEAS_IT1o;

       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_lief
       //-----------------------------------------------------------------------

       begsr sr_lief;

       //LIEF01 initialisiert mit Mandant
          LIEF_k.LFFIRM = teil_i.TEFIRM;
          LIEF_k.LFLFNR = teil_i.TELFNR;
          chain %kds(LIEF_k:2) LIEF01  LIEF_I;
          if %found(LIEF01);
          else;
             clear               LIEF_I;
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_lpif
       //-----------------------------------------------------------------------

       begsr sr_lpif;

       //lpif01 lesen
          Lpif_k.LPFIRM = teil_i.TEFIRM;
          Lpif_k.LPLFNR = teil_i.TELFNR;
          Lpif_k.LPTENR = teil_i.TETENR;
          Lpif_k.LPGADA = %dec(%char(%date():*iso0):8:0);
       //          chain %kds(Lpif_k:3) Lpif01    Lpif_I;
       //          setll %kds(Lpif_k:3) Lpif01    ;
          setgt %kds(Lpif_k:3) Lpif01    ;
          readp Lpif01 Lpif_i;
          if %found(lpif01);
          else;
             clear               Lpif_I;
          endif;
       endsr;

       //-----------------------------------------------------------------------
       //lesen sr_zotn
       //-----------------------------------------------------------------------

       begsr sr_zotn;

       //LIEF01 initialisiert mit Mandant
          LIEF_k.LFLFNR = teil_i.TEZOTN;
          chain %kds(ZOTN_k:1) ZOTN01  ZOTN_I;
          if %found(ZOTN01);
          else;
             clear               ZOTN_I;
          endif;
       endsr;


       //-----------------------------------------------------------------------
       //lesen sr_prei
       //-----------------------------------------------------------------------

       begsr sr_prei;

       //#preil5 lesen
          prei_k.PRFIRM = teil_i.TEFIRM;
          prei_k.PRBEGR = 'LP1';
          prei_k.PRKDLI = teil_i.TESTLF;
          prei_k.PRTENR = teil_i.TETENR;
          prei_k.PRWACD = 'EUR';
          prei_k.PRGADA = %dec(%char(%date():*iso0):8:0);

       //          chain %kds(Lpif_k:3) Lpif01    Lpif_I;
       //          setll %kds(Lpif_k:3) Lpif01    ;
          setgt %kds(prei_k:3) #preil5  ;
       // dow not %eof(#preil5);           für schleife
             readp #preil5 prei_i;
             if %found(#preil5);
             else;
                clear               prei_i;
             endif;
       // enddo;                            für Schleife
       endsr;
       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'RPMSALESM ';
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


