     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
      *               CHGJOB     CCSID(1144)
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
      * CALL PGM(TRSP18SB) PARM('RHENANIA')
      * call trtrtpst   über trsp18
      * upddta  trtp01
      * Firmennummer:    01
      * Sprachcode:      D
      * Tabellenart:     RHENANIA
      * Tabellencode:    BA05
      * Folgenr:
      * Satz-Sperre:
      * L.Änd. Jobname:  GANG_PC_S2
      * L.Änd. Jobdatum: 20170123
      * L.Änd. Jobzeit:   94256
      * L.Änd. Benutzer: GANG
      * L.Änd. Programm: TRTRTPST
      * L.Änd. Bibl:     TAMP
      * Tabellentext:    Spedition Batolini NN
      * Tabellenwert:     9222500000
      * int.Freifeld:
      * ext.Freifeld:
      * update        waoe set WAOESTAT='10'
      *               WHERE (WAOEKMNR ='278691' and WAOEKMJJ =2018)
      *
      * update waoe set WAOESTAT='10'
      * WHERE WAOEFIRM ='01' and WAOEKDNR ='040631' and
      * WAOEKMNR ='308509'
      * SELECT * FROM txbe WHERE TBFIRM ='01' and
      * TBAFNR ='757555' and TBTCDE ='TXVS'
      * update waoe set WAOESTAT='10'
      * WHERE WAOEFIRM ='01' and WAOEKDNR ='078678' and
      * WAOEKMNR ='182184'
      *
      *  VLF95DWE/VEMMBR
      *  VLF95DWE/VEMMBR
      *  call trtrtpst mit TRSP18
      *  Programme
      *  TRSP18-Verarbeiten Speditionsdaten
      *  TRSP18CL-Verarbeiten Speditionsdaten
      *  TRSP18SB-Verarbeiten Speditionsdaten
      *
      *  Dateien
      *  WAOE-Empfang Speditionsdaten
      *
      *
      *  Beschreibung
      *  Die Länge für den auszugebenden Text für den Begriff "INHALT" beträgt 910
      *  Zeichen.
      *  Dieser setzt sich zusammen aus 14 x 65 Zeichen.
      *  Die Tabellentexte in Eintrag TRSP18/INHALT haben je 40 Zeichen. Diese werden in
      *  Programm TRSP18 in einen String mit 910 Zeichen aneinanergekettet.
      *  Daraus werden die Ergebniszeilen mit je 65 Zeichen ausgeschnitten.
      *  Berücksichtigt werden die Tabellentexte von Zeile 1 - 23. Von Zeile 23 nur die
      *  ersten 30 Zeichen. (23 x 40 = 920).
      *  In Zeile 0 steht die Anrede, die extra gesetzt wird.
      *  Die Konstante "Referenz:" muss auf Zeile 31 stehen.
      *  Die Variablen werden dahinter gesetzt.
      *
      *  Für die Ausgabe einer E-Mail Nachricht ist folgendes erforderlich:
      *  Der Status in WAOE muss auf '10' stehen.
      *  Der Dateiname in WAOEDATN muss mit dem Dateinamen beim Aufruf von TRSP18CL
      *  übereinstimmen.
      *  Der Dateiname ist normalerweise 'RHENANIA'.
      *  Programm TRSP18CL muss wie folgt aufgerufen werden: CALL TRSP18CL 'RHENANIA'.
      *
      *
      *  Installationshinweise
      *  TRTK -> TRSP18
      *  TRTP -> TRSP18/ABSENDER
      *         TRSP18/BETREFF
      *   CRTDUPOBJ OBJ(FRDTN) FROMLIB(VLF95DWE) OBJTYPE(*FILE) TOLIB(TESTGANG)
      *             VLF95DWE
      *   SELECT * FROM frdtn WHERE VSNR  = '0002401891'
      *   Datei FRDTN in TESTGANG wurde erstellt.
      *   VLF95DWE          VLF95DWE/FRDTN
      *   VLPLGUSR
      *   VLF95USR
      *   VLNABUSR27
      *
      *   Sprach-Code.... 2
      *   Tabellen-Art... TRSP18      Texte eMail Be
      *   __________________________________________
      *   2=Ändern  3=Kopieren  4=Löschen
      *
      *   01 TRSP18     Texte eMail Benachrichtigung
      *      ABSENDER   no-reply-igloo@igloo.com
      *
      *  28.01.2026
      * ... wenn erledigt
      *  SELECT * FROM domdatv7/psaveat WHERE ATAPN = '102527081'
      * ... wenn noch nicht erledigt
      *  SELECT * FROM domdatv7/panftxt WHERE ATAPN = '102527081'
      *  SELECT * FROM DOMDATV7/ppaket WHERE PKANRP <> '0' and
      *  pkapn='102527107' ORDER BY pkapn
      *
      *  SELECT * FROM DOMDATV7/ppaket WHERE PKANRP <> '0' and
      *  pkapn='102527165' ORDER BY pkapn
      *  SELECT * FROM domdatv7/psaveat WHERE ATAPN = '102527165'
      *
      *  insert into tvrelwaeco/ISSII
      *  SELECT DISTINCT PKKONZ,PKFIRM,PKLFDN,PKANR1,pkapn,ATRA4,ATTXT,
      *                  PKKDNR,PKVENR,PKVART,PKSSC,PKEGEW,
      *    dec(0, 10) #cc, char('  ', 2) status, current date #date, current
      *  timestamp #tstamp FROM DOMDATV7/ppaket ,domdatv7/psaveat WHERE
      *  PKANRP <> '0' and pkapn='102527165' and pkapn =ATAPN and
      *  atkonz=PKKONZ and atfirm=PKFIRM and ATRA4='MAIL' and
      *  PKDTDI > 20260000                       and  pkAPN not in
      *  (select pkAPN from tvrelwaeco/ISSII)
      *  order by PKKONZ, PKFIRM ,pkapn,PKANR1
      *
      *
      *  Ablösung für Rhenania Mail
      *
      *  delete FROM tvrelwaeco/ISSII WHERE PKANR1 ='K012025227758'
      *  delete FROM tvrelwaeco/ISSII WHERE PKANR1 ='K012026100590'
      *
      *  select * from ISSII WHERE PKANR1 ='K012025227758'
      *
      *
      *
      *  K012026107369
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
     fISSII     uf   e             DISK    RENAME(ISSII:PHY02R)
     f                                     USROPN
     f
     fwaoe      uf a e           k disk    rename(waoe1:phy01r)
     f                                     USROPN

     ftrtp01    if   e           k DISK

     fafkm01    if   e           k disk

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      //d IFDTRELNII      PR
      //d p_cc                           1

      //d IFDTRELNII      PI
      //d p_cc                           1

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
       // TRSP18CL
       // ______________________________________________________________________
     D TRSP18CL        PR                  ExtPgm('TRSP18CL')
     D mailfile                      10a

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

       // ______________________________________________________________________
       // TRSP18CL
       // ______________________________________________________________________
     D mailfile        s             10a


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

     d ISSII_i       E DS                  ExtName(ISSII:*input)
     d                                     Qualified

     d ISSII_o       E DS                  ExtName(ISSII:*output)
     d                                     Qualified

     d waoe_o        E DS                  ExtName(waoe:*output)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified

     d afkm01_k      E DS                  ExtName(afkm01:*key)
     d                                     Qualified

     d afkm01_I      E DS                  ExtName(afkm01:*input)
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
     D#success         S              1a
     D#error           S              1a
     D p_inFIL         s             24a
     D $$BEALFIRM      s              2a   inz
     D $$BEALKMJJ      s              4s 0 inz
     D $$BEALKMNR      s              6a   inz
     D $$BEALBZFI      s              2a   inz
     D $$BEALBZKJ      s              4s 0 inz
     D $$BEALBZKM      s              6a   inz
     D $$kund          s             10a   inz

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     dp_cc             s              1
     D
     D §vsbd           s              4a   inz
     D §VBSPED         s             10a   inz
     D §PKANR1         s             25a   inz
     D §ATTXT          s             80a   inz
     D §i              s              3s 0 inz
     D §PKVENR         s             46a   inz
     D #PKVENR         s             46a   inz
     D #ATTXT          s             80a   inz
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
     IPHY02R
b    I              status                      §status
b
b
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

       //:::
      /FREE

          status='start ISSII                                        ';
          Exsr      sr_log;
          Exsr      sr_insert;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/*********) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/*********)            ';
             exsr      SR_log;
       endmon;

       mailfile  =  'RHENANIA  ';
       ISSII_i.PKANR1 =  ISSII_i.PKANR1;
       if status =  *blank;
          open ISSII;
          open waoe;
       //alle einlesen, wo ein Packstück vorliegt (ISSII)
          read ISSII          ISSII_i;
          dow not %eof(ISSII);
          if ISSII_i.status =  *blank and
             ISSII_i.ATRA4   =  'MAIL';
             clear p_cc;

             status = *blank;
             status = ISSII_i.PKFIRM + ' ' + ISSII_i.PKANR1 +
                                       ' ' + ISSII_i.PKKDNR;
             exsr      SR_log;

                clear  waoe_o;
                waoe_o.WAOELOCK = *blank;
                waoe_o.WAOejnam = §§§job;
                waoe_o.WAOeJDAT = %dec(%char(%date():*iso0):8:0);
                waoe_o.WAOeJZEI = %dec(%char(%time():*iso0):6:0);
                waoe_o.WAOeuser = §§§usr;
                waoe_o.WAOePROG = §§§pgm;
                waoe_o.WAOebibl = §§§LIB;
                waoe_o.WAOEFREI = *blank;
             //vsrhf Referenz aus lfs (Eindeutigkeit)
                   waoe_o.WAOEFIRM = %subst(ISSII_i.PKANR1:02:02);
                   waoe_o.WAOEKMJJ = %dec(%subst(ISSII_i.PKANR1:04:04):4:0);
                   waoe_o.WAOEKMNR = %subst(ISSII_i.PKANR1:08:06);
             //Achtung Igloo-Wechsel, prüfen auf Igloo Kunde
             //SELECT BEALFIRM, BEALKMJJ, BEALKMNR, BEALBZFI, BEALBZKJ, BEALBZKM
             //FROM beal01 WHERE BEALFIRM ='01' and BEALKMJJ = 2024 and BEALKMNR
             //='110296'  Wechsel auf Igloodaten ==> BEALBZFI, BEALBZKJ, BEALBZKM
                   trtp_k.tpfirm  =  %subst(ISSII_i.PKANR1:02:02);
                   trtp_k.TPSPCD  =  'D';
                   trtp_k.TPTART  =  'IGLOO';
                   trtp_k.TPTCDE  =  %subst(ISSII_i.PKKDNR:01:06);
                   chain %kds(trtp_k:4) trtp01 trtp_I;
                   if %found(trtp01);
                      $$BEALFIRM  = waoe_o.WAOEFIRM;
                      $$BEALKMJJ  = waoe_o.WAOEKMJJ;
                      $$BEALKMNR  = waoe_o.WAOEKMNR;
             //   Achtung Wechsel der Kommissionierdaten
          exec sql
            SELECT DISTINCT BEALBZFI, BEALBZKJ, BEALBZKM
                   into     :$$BEALBZFI, :$$BEALBZKJ, :$$BEALBZKM
                   FROM      beal01
            WHERE BEALFIRM = :$$BEALFIRM         and
                  BEALKMJJ = :$$BEALKMJJ         and
                  BEALKMNR = :$$BEALKMNR;

                      waoe_o.WAOEFIRM = $$BEALBZFI;
                      waoe_o.WAOEKMJJ = $$BEALBZKJ;
                      waoe_o.WAOEKMNR = $$BEALBZKM;

       //Afkm01  lese für Kundennummer
                      AfKm01_k.AMFIRM = $$BEALBZFI;
                      AfKm01_k.AMKMJJ = $$BEALBZKJ;
                      AfKm01_k.AMKMNR = $$BEALBZKM;
                      chain %kds(AfKm01_k:3) AfKm01 AfKm01_I;
                      $$kund      = *blank;
                      if %found(AfKm01);
                         $$kund      = afkm01_i.amkdnr;
                      endif;

                      waoe_o.WAOEFREI = $$BEALFIRM  + ' ' +
                                 %char ($$BEALKMJJ) + ' ' +
                                        $$BEALKMNR  + ' ' +
                                        $$kund;
                   endif;
             //Achtung Igloo-Wechsel-Ende

          §vsbd  = ISSII_i.PKVART;
          exec sql
            SELECT VBSPED  into :§VBSPED from VSBD01
            where  VBFIRM ='01' and  VBVSBD= :§vsbd;

          if §VBSPED = *blank;
             §VBSPED  = '00000';
          endif;

          waoe_o.WAOESPED = §VBSPED;

                if ISSII_i.PKANR1   <> §PKANR1;
                   §i =      0;
                endif;

                if ISSII_i.PKANR1   <> §PKANR1 or
                   ISSII_i.PKVENR   <> §PKVENR;
                   §i = §i + 1;
                   waoe_o.WAOEKMPO = §i;
                   §PKANR1   = ISSII_i.PKANR1;
                   §PKVENR   = ISSII_i.PKVENR;
                else;
                   waoe_o.WAOEKMPO = §i;
                endif;

                if ISSII_i.ATTXT  <> §ATTXT;
                   §ATTXT  = ISSII_i.ATTXT ;
                   §records = *zero;
                   exec sql
                       select count(*) into :§records
                       FROM  tvrelwaeco/ISSII
                       where PKANR1 = :§PKANR1 and
            //               PKVENR = :§PKVENR;
                             cast(attxt as char(80) ccsid 1144)
                                    = :§ATTXT ;
                endif;

                waoe_o.WAOEUPOS = *zero;
                waoe_o.WAOEKDNR = %subst(ISSII_i.PKKDNR:01:06);
                if $$kund <> *blank;
                   waoe_o.WAOEKDNR = $$kund;
                endif;
                $$kund      = *blank;
             //****   steuernde Wirkung! waoe_o.WAOEDATN
                waoe_o.WAOEDATN = 'RHENANIA ';
                waoe_o.WAOEDPDN = 'Paket#';
                waoe_o.WAOEPAKN = %subst(ISSII_i.PKVENR:01:20);
      * :       DPD Sonderegelung 92214
                if waoe_o.WAOESPED  = '92214     ';
                   waoe_o.WAOEPAKN = %subst(ISSII_i.PKVENR:09:14);
                endif;
                waoe_o.WAOEVPMI = *blank;
                waoe_o.WAOEAZVP = §records;
                waoe_o.WAOEGWBR = ISSII_i.PKEGEW;
                waoe_o.WAOEGWDI = 'K';
                waoe_o.WAOESEDA =
                    %dec(%char(%date():*iso0):8:0);
                waoe_o.WAOEvsbd = §VBSPED;

             //****
                waoe_o.WAOESTAT = '10';
             //basis ist nur noch das Paketstück und nicht beteiligte Positionen des AU
                if #PKVENR   =  ISSII_i.PKVENR  and
                   #ATTXT    =  ISSII_i.ATTXT;
                   waoe_o.WAOESTAT = '90';
                   waoe_o.WAOEDPDN = 'Paket# 90';
                endif;
             //****
             // waoe_o.WAOESTAT = '99';
                waoe_o.WAOEVPM2 = *blank;
                waoe_o.WAOEAZV2 = 0;
                waoe_o.WAOEHINW = *blank;
                #PKVENR   =  ISSII_i.PKVENR;
                #ATTXT    =  ISSII_i.ATTXT;
                write  phy01R    waoe_o;
             endif;
             ISSII_o          =  ISSII_i;
             ISSII_o.status  = '10';
             update phy02r       ISSII_o;
             read ISSII          ISSII_i;
          enddo;

          close waoe;
          close ISSII;
       // callP trsp18cl(mailfile);
       endif;

       // exsr SR_report;
          status='ende  ISSII                                        ';
       Exsr sr_log;

       //statistik
      /end-FREE
     c
     c                   EXSR      RETURN

       //-----------------------------------------------------------------------
       //relevanten Sätze laden ins Protokoll
       //-----------------------------------------------------------------------

      /FREE
       begsr sr_insert;

          exec sql
             insert into tvrelwaeco/ISSII
             SELECT DISTINCT PKKONZ,PKFIRM,PKLFDN,PKANR1,pkapn,ATRA4,ATTXT,
                             PKKDNR,PKVENR,PKVART,PKSSC,PKEGEW,
                    dec(0, 10) #cc, char('  ', 2) status,
                    current date #date, current timestamp #tstamp
             from   DOMDATV7/ppaket ,domdatv7/psaveat
             where
        //   pkapn='102527165' and
             PKANRP <> '0' and pkapn =ATAPN and
             atkonz=PKKONZ and atfirm=PKFIRM and ATRA4='MAIL' and
             PKDTDI > 20260000
             and pkAPN not in (select pkAPN from tvrelwaeco/ISSII)
             order by PKKONZ, PKFIRM ,pkapn,PKANR1,PKVENR,ATTXT;

       endsr;

      /end-FREE


       //-----------------------------------------------------------------------
       //report customer
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_report;

         eval p_infil   =  'KHTRESULT' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'KHTRESULT';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/KHTRESULT*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed KHTRESULT             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object KHTRESULT                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'KHTRESULT';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object KHTRESULT                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'KHTRESULT';


       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
           'FORMTYPE(''KHTRESULT'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'KHTRESULT';

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
      /end-FREE

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
