
      //************************************************************************
      //      artnr= '9600004784'  artnr= '10546610'      149511 2019
      //      Programmname       RPMSALESM
      //      Erstellt  am       25.08.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Meldung an RPM sales    report
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  04.03.2024 M.Gang                ! Artikel f.Übergabe grundsätzlich
      //                                   ! aus Lieferschen (Basis Rechnung)
      //                                   !
      //  15.04.2024 M.Wolzenburg          ! SE811 Umrechnung mit Kurs  =SALES
      //   7.05.2024 M.Wolzenburg          ! SE811 Umrechnung mit Kurs  =STK
      //************************************************************************
      // Übersetzungshinweise:
      // create index tvrelwaeco/absatzb4l1 on tvrelwaeco/absatzb4
      // (APKDNR, JAHR)
      // create index tvrelwaeco/absatzb4#l on tvrelwaeco/absatzb4#
      // (AKFIRM, APKDNR, JAHR)
      // update rpm_load set status='  '
      //               MONITOR
      // B             DIV       A
      // Arr(B)        Dsply
      //               ON-ERROR  0102
      // 'Div by 0'    Dsply
      //               ON-ERROR  0121
      // 'Index Err'   Dsply
      //               ON-ERROR
      //*'Error'       Dsply
      //               ENDMON
      // Restartmöglichkeiten:
      // _____________________
      // alle abgeleiteten Datein stammen aus der Historiendatei,
      // die nach jedem Lauf gefüllt wird
      // rpmsales ==> rpmsales#
      // rpmsales# beinhaltet immer alle daten eines Laufs und entspricht
      // einer "copy paste" Funktion ohne filter oder Änderung
      // welche Daten werden gezogen aus einem Lauf?
      // rpm_load beinhalten alle möglichen Rechnungsdaten auf Basis
      // Lieferschein, also der kleinsten Einheit
      // Soll nun ein Satz (Rechnungssatz) erneut geladen werden,
      // muss der Status dieses Satztes auf *Blank gesetzt werden.
      // Damit wird erneut der Aufbau für RPM-Übergabe eingeleitet.
      //
      // Beispiel einer Zuordnung mit restart
      // ------------------------------------
      // update rpm_load  set status = ' '
      // WHERE (rkfirm='x1' and rkrgjj=2015 and rkrgnr ='149771' and
      // rklijj=2015 and rklinr=380090)
      //
      // der "UPDATE" reicht aus, um die Übergabe erneut einzuleiten
      // ===> aber die Historie muß auch bedient werden, daher alle Sätze,
      //      die neu eingestellt würden, aus der Historie löschen.
      //      (RPMitem  und RPMcust wären ggf. nicht korrekt)
      // delete  FROM rpmsales# WHERE doc like ('%2015/149771/2015/380090%')
      //        oder WHERE RKREDA > 20161200
      // beteiligte Dateien
      // __________________
      // rpm_load  :zugrundeliegende Rechnungen
      //           (update rpm_load set #CC=0, STATUS=' ')
      // rpmsales  :Datei, beinhaltet nach Laufzeit die verarbeiteten Dateien
      //            (des zugrundeliegenden Laufes !!)  +
      //            die fehlerbehafteten aus den Läufen davor
      // RPMSALES# :Historie aller Inhalte aus dem jeweiligen Lauf
      // RPMitem   :wird immer neu gebildet nach Abschluß (Kum_lauf)
      // RPMcust   :wird immer neu gebildet nach Abschluß (Kum_lauf)
      //
      // DSPDTAARA DTAARA(RPM_LOADR) keine steuernde Wirkung
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // sonstiges check
      // ===============
      // SELECT * FROM afko01, afpo01 WHERE afko01.akfirm='01' and AKAFST
      // ='90' and afko01.AKAFJJ > '2014' and afko01.akfirm not in (select
      // RPMSALES#.AKfirm from rpmsales# where afko01.AKAFJJ
      // =RPMSALES#.AKAFJJ and afko01.AKAFNR =RPMSALES#.AKAFNR ) and (
      // afko01.akfirm=afpo01.apfirm and afko01.AKAFJJ=afpo01.ApAFJJ and
      // afko01.AKAFNR=afpo01.ApAFNR ) and apafst = '90'
      // Datei RECHNUNG in TVRELWAECO wurde erstellt.
      //
      // SELECT * FROM rechnung WHERE AKFIRM not in (select rpfirm from
      // afrp01 where rpafnr =akafnr and rpafpo=apafpo)
      // Datei RECHNUNG2 in TVRELWAECO wurde erstellt.
      //
      //
      // SELECT sum(APGLMG), sum(RPNESU), RKWACD FROM rpmsales WHERE ARTsku
      // like '%HEL%' or art like '%HEL%' GROUP BY RKWACD
      // Beispiel für Headerkosten+Gutschrift
      // SELECT * FROM rpmsales# WHERE DOC like '2024/122785%' and ENTITY
      // ='DE411'
      //
      //
      //
      //
      // Abweichungen Artikel innerhalb der Meldesysteme
      // SELECT ITEM, ARTNR, ARTBEZFRA FROM rpmsales# WHERE ENTITY ='DE411'
      // and ( artnr<> ' ' and ARTBEZFRA <> ' ') and (item <> artnr or item
      // <> artbezfra or artnr <> artbezfra) GROUP BY ITEM, ARTNR, ARTBEZFRA
      // ORDER BY ITEM
      // Datei HAUSE in TVRELWAECO wurde ersetzt.
      //
      // update rpm_load  set status = ' '
      //                        WHERE RKFIRM ='55'
      // 34343 Zeilen in RPM_LOAD in TVRELWAECO aktualisiert.
      // delete   FROM rpmsales# WHERE ENTITY='CH412'
      // 93841 Zeilen aus RPMSALES# in TVRELWAECO gelöscht.
      //
      //
      // delete   FROM rpmsales# WHERE (ENTITY='DE411' or
      //                               ENTITY='DE411') and
      //                               RKREDA > 20190000
      //
      // update rpm_load  set status = ' ' WHERE (rkfirm='01'
      //                      or rkfirm='01') and
      //                      RKREDA > 20190000
      //
      //
      // ADDLIBLE LIB(DOMDATV7) POSITION(*LAST)
      // ADDLIBLE LIB(BAR_KALK) POSITION(*LAST)
      // CALL       PGM(RPMSALESM)
      // CALL PGM(RPMIISTK3R) PARM('DE411')
      //
      //
      //
      // update rpm_load  set status = ' '
      // select count(*) from rpm_load
      // where rkfirm in ( SELECT AKFIRM
      // FROM rpmsales# WHERE AKAFAT ='I55' and akfirm = '01' and
      // substr(doc, 01, 4)=RKRGJJ and substr(doc, 06, 6)=RKRGNR and
      // h4 = 'no upload')
      //
      // delete from rpmsales#
      // select count(*) from rpmsales#
      // WHERE AKAFAT ='I55' and akfirm = '01' and h4 = 'no upload'
      // and substr(doc, 01, 4) in (select RKRGJJ from rpm_load
      // where substr(doc, 06, 6)=RKRGNR and status = ' ')
      //
      //
      // für Michael:
      // addlible bar_kalk *last
      // addlible DOMDATV7 *last
      //
      //
      //   Fa    REJ   RE-Nr   LS-Jahr
      //   01  2.024   300361   2.024
      //   01  2.024   115610   2.024
      //   300361 eine Rechnung von Iglo an deren Kunde
      //   115610 eine Rechnung von UNS an Iglo
      //
      //   1../2.. ist Rechnung von IGLO
      //  select * from rpmsales where (RKRGNR ='300361' and RKRGJJ =2024) or
      //  (RKRGNR ='115610' and RKRGJJ =2024)
      //
      //
      //  SELECT * FROM rpmsales# WHERE ENTITY ='SE811'
      //  Datei SE811## in QTEMP wurde erstellt.
      //  update rpm_load  set status = ' '
      //  select *        from rpm_load
      //  where rkfirm in ( SELECT AKFIRM
      //  FROM SE811##   WHERE                   akfirm = '01' and
      //  substr(doc, 01, 4)=RKRGJJ and substr(doc, 06, 6)=RKRGNR and
      //  entity ='SE811') and rkreda > 20220909
      //
      //   update rpm_load  set status = ' '
      //   where rkfirm in ( SELECT AKFIRM
      //   FROM SE811##   WHERE                   akfirm = '01' and
      //   substr(doc, 01, 4)=RKRGJJ and substr(doc, 06, 6)=RKRGNR and
      //   entity ='SE811') and rkreda > 20220000
      //   1173 Zeilen in RPM_LOAD in TVRELWAECO aktualisiert.
      //   Datei SE811REST in TVRELWAECO wurde erstellt.
      //   SELECT ALFIRM , ALKDNR, ALAFJJ, ALAFNR, ALAFPO, ALRGJJ, ALRGNR,
      //   ALWKNR , ALLIJJ, ALLINR, ALLIPO FROM aflp01 WHERE alwknr='010' and
      //   ALRGJJ =2024
      //
      //   SELECT count(*) FROM SE811REST
      //
      //   SELECT * FROM rpm_load WHERE RKFIRM in (select ALFIRM from SE811REST
      //    where RKRGJJ = ALRGJJ and RKRGNR = ALRGNR and RKLIJJ = ALLIJJ and
      //   RKLINR = ALLINR and RKKDNR = ALKDNR)
      //
      //   update               rpm_load set status = '  '
      //          WHERE RKFIRM in (select ALFIRM from
      //   SE811REST where RKRGJJ = ALRGJJ and RKRGNR = ALRGNR and RKLIJJ =
      //   ALLIJJ and RKLINR = ALLINR and RKKDNR = ALKDNR)
      //   6616 Zeilen in RPM_LOAD in TVRELWAECO aktualisiert.
      //
      //
      //    update rpm_load  set status = ' '
      //     where rkfirm in ( SELECT AKFIRM
      //     FROM rpmsales  WHERE                   akfirm = '01' and
      //     substr(doc, 01, 4)=RKRGJJ and substr(doc, 06, 6)=RKRGNR and
      //     entity ='DE411') and rkreda > 20241017
      // ausschluss????? 30.09.2026
      // SELECT POSTDATE, ENTITY, COUNT_ISO, ITEM, ITEMDESC, DOCTYPE, DOC,
      // RKREDA, RKWACD, APPRGR, DIVISION, CUSTOMER#, CUSTOMER, RPMGROUP,
      // AKFIRM, AKAFJJ, AKAFNR, AKAFAT, TEPRGR FROM rpmsales# WHERE rkreda
      // > 20260000 and h4='no upload ' and h1<>'supplement' and
      // division<>'GROUP' and customer#<>'900089'
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

     frpm_load  uf   e             DISK    RENAME(rpm_load:PHY01R)

     frpmsales  o  a e             disk    USROPN

     fafrk01    if   e           k DISK

     fafrp01    if   e           k DISK

     fafko01    if   e           k DISK

     f#aflpL1   if   e           k DISK

     fkund01    if   e           k DISK

     fkueg01    if   e           k DISK

     fkdew01    if   e           k DISK

     fteil01    if   e           k DISK

     fteew01    if   e           k DISK

     fwaeh01    if   e           k DISK

     ftrtp01    if   e           k DISK

     fteos01    if   e           k DISK

     fkont01    if   e           k DISK

     fkalk_file2if   e           k DISK

     fabsatzb4l1if   e           k DISK    USROPN

     fabsatzb4#lif   e           k DISK    USROPN

     fitemsoem#lif   e           k DISK    USROPN

     fPSAVEAPL51if   e           k DISK    RENAME(PANFPOSF:LOG01R)

     fPANFPOSL51if   e           k DISK    RENAME(PANFPOSF:LOG02R)


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
     D RPM_LOADR       s             10p 0 dtaara


       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d rpm_load_i    E DS                  ExtName(rpm_load:*input)
     d                                     Qualified

     d rpm_load_o    E DS                  ExtName(rpm_load:*output)
     d                                     Qualified

     d afrk_k        E DS                  ExtName(afrk01:*key)
     d                                     Qualified

     d afrk_i        E DS                  ExtName(afrk01:*input)
     d                                     Qualified

     d afrp_k        E DS                  ExtName(afrp01:*key)
     d                                     Qualified

     d afrp_i        E DS                  ExtName(afrp01:*input)
     d                                     Qualified

     d afko_k        E DS                  ExtName(afko01:*key)
     d                                     Qualified

     d afko_i        E DS                  ExtName(afko01:*input)
     d                                     Qualified

     d #aflpL1_k     E DS                  ExtName(#aflpL1:*key)
     d                                     Qualified

     d #aflpL1_i     E DS                  ExtName(#aflpL1:*input)
     d                                     Qualified

     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
     d                                     Qualified

     d kdew_k        E DS                  ExtName(kdew01:*key)
     d                                     Qualified

     d kdew_i        E DS                  ExtName(kdew01:*input)
     d                                     Qualified

     d teew_k        E DS                  ExtName(teew01:*key)
     d                                     Qualified

     d teew_i        E DS                  ExtName(teew01:*input)
     d                                     Qualified

     d kueg_k        E DS                  ExtName(kueg01:*key)
     d                                     Qualified

     d kueg_i        E DS                  ExtName(kueg01:*input)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d waeh_k        E DS                  ExtName(waeh01:*key)
     d                                     Qualified

     d waeh_i        E DS                  ExtName(waeh01:*input)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp01:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp01:*input)
     d                                     Qualified

     d teos_k        E DS                  ExtName(teos01:*key)
     d                                     Qualified

     d teos_i        E DS                  ExtName(teos01:*input)
     d                                     Qualified

     d kont_k        E DS                  ExtName(kont01:*key)
     d                                     Qualified

     d kont_i        E DS                  ExtName(kont01:*input)
     d                                     Qualified

     d Kalk_k        E DS                  ExtName(KALK_file2:*key)
     d                                     Qualified

     d kalk_i        E DS                  ExtName(KALK_file2:*input)
     d                                     Qualified

     d rpmsales_o    E DS                  ExtName(RPMSALES:*output)
     d                                     Qualified

     d absatzb4l1_k  E DS                  ExtName(absatzb4l1:*key)
     d                                     Qualified

     d absatzb4l1_i  E DS                  ExtName(absatzb4l1:*input)
     d                                     Qualified

     d absatzb4#l_k  E DS                  ExtName(absatzb4#l:*key)
     d                                     Qualified

     d absatzb4#l_i  E DS                  ExtName(absatzb4#l:*input)
     d                                     Qualified

     d itemsoem#l_k  E DS                  ExtName(itemsoem#l:*key)
     d                                     Qualified

     d itemsoem#l_i  E DS                  ExtName(itemsoem#l:*input)
     d                                     Qualified

     d PSAVEAPL51_k  E DS                  ExtName(PSAVEAPL51:*Key)
     d                                     Qualified

     d PSAVEAPL51_i  E DS                  ExtName(PSAVEAPL51:*input)
     d                                     Qualified

     d PANFPOSL51_k  E DS                  ExtName(PANFPOSL51:*Key)
     d                                     Qualified

     d PANFPOSL51_i  E DS                  ExtName(PANFPOSL51:*input)
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
     IPHY01R
     I              status                      §status

      // ______________________________________________________________________
     IKALK_F1
     I              wakurs                      §§wakurs
     I              status                      §§status
     I              jahr                        §§jahr

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start FTP Transfer for RPM Sales    ';
       exsr      SR_log;

       exsr  srinit;

       if err_msg = ' ';
       //alle, die übertragen worden sind, werden gelöscht
          exec sql
            delete from  TVRELWAECO/RPMSALES
                         WHERE H4 ='upload ';

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
             rpm_loadr = rpm_loadr  + 1;
             out *dtaara;
          endif;

          open rpmsales;

          open absatzb4l1;

          open absatzb4#l;

          open itemsoem#l;

          read RPM_LOAD  RPM_LOAD_i;
          dow not %eof(RPM_LOAD);
       // dow not %eof(RPM_LOAD) or  week = 0;
       //für upload
             if  rpm_load_i.status = '  ';
                rpm_load_o  = rpm_load_i;
                exsr  sr_1000;

                rpm_load_o.status    = '10';
                rpm_load_o.#cc       = RPM_LOADR;
                rpm_load_o.UPDTSTAMP = %timestamp();

       //update
                update PHY01R    rpm_load_o;
                clear            rpm_load_o;
             endif;
             read RPM_LOAD  RPM_LOAD_i;
          enddo;

          eval  suffix   = 'DE411 ';
          exsr  file_out;

          eval  suffix   = 'BE111 ';
          exsr  file_out;

          eval  suffix   = 'NL411 ';
          exsr  file_out;

          eval  suffix   = 'CH412 ';
          exsr  file_out;

          eval  suffix   = 'AT411 ';
          exsr  file_out;

          eval  suffix   = 'DE117 ';
          exsr  file_out;

          eval  suffix   = 'SE811 ';
          exsr  file_out;

          close rpmsales;

          close  absatzb4l1;

          close  absatzb4#l;

          close  itemsoem#l;

       // exec sql
         // drop index   tvrelwaeco/absatzb4l1;

       // exec sql
          //drop index   tvrelwaeco/absatzb4#l;

       // exec sql
          //drop index   tvrelwaeco/itemsoem#l;

       endif;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

         MONITOR;
            Wrk.var1 =
                'CPYF FROMFILE(TVRELWAECO/RPMSALES) ' +
                'TOFILE(TVRELWAECO/RPMSALES#) ' +
                'MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CPYF FROMFILE(TVRELWAECO/RPMSALES) in RPMSALES#';
               exsr      SR_log;
       //      err_msg = '1';
         endmon;

       exsr statistik2;

       eval status ='Ende  FTP Transfer for RPM Sales    ';
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
                'CLRPFM FILE(TVRELWAECO/RPMSALES) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPMSALES)            ';
               exsr      SR_log;
         endmon;
       endif;

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(tvrelwaeco/RPMITEM) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(tvrelwaeco/RPMITEM)             ';
               exsr      SR_log;
         endmon;
       endif;

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(tvrelwaeco/RPMCUST) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(tvrelwaeco/RPMCUST)             ';
               exsr      SR_log;
         endmon;
       endif;

       exec sql
            create index tvrelwaeco/absatzb4l1 on
                         tvrelwaeco/absatzb4  (APKDNR, JAHR);

       exec sql
            create index tvrelwaeco/absatzb4#l on
                         tvrelwaeco/absatzb4#  (AKFIRM, APKDNR, JAHR);

       exec sql
            create index tvrelwaeco/itemsoem#l on
                         tvrelwaeco/itemsoem#  (ITEM);

       //balance INVOICES for erp ERP Trend-System
       exec sql
        insert into tvrelwaeco/RPM_LOAD
        select
        b.RKFIRM,b.RKRGJJ,b.RKRGNR,b.RKLIJJ,b.RKLINR,b.RKKDNR,b.rkreda
                                                        ,dec(0, 10) #cc,
        char('  ', 2) status,current date #date,current timestamp #tstamp,
        dec(0, 10) #count,current timestamp updtstamp,
        char(' ', 10) pgm,char(' ', 10) job,char(' ', 10) user,
        char(' ', 128) protokoll
        FROM afrk01 b WHERE b.RKRGJJ > 2023 and b.rkreda > 20241000  and
                          b.rkkdnr<>'xxxxxx' and  b.rkrgnr<>' ' and
        b.RKFIRM not in (select a.rkfirm from tvrelwaeco/RPM_LOAD a
                 where b.RKRGJJ=a.RKRGJJ and b.RKRGNR=a.RKRGNR and
                       b.RKLIJJ=a.RKLIJJ and b.RKLINR=a.RKLINR and
                       b.rkreda=a.rkreda );

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/RPM_LFS_1) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPM_LFS_1)           ';
               exsr      SR_log;
         endmon;
       endif;

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/RPM_LFS_2) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPM_LFS_2)           ';
               exsr      SR_log;
         endmon;
       endif;

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/RPM_LFS_3) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPM_LFS_3)           ';
               exsr      SR_log;
         endmon;
       endif;

       if err_msg = ' ';
         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/RPM_LFS_4) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPM_LFS_4)           ';
               exsr      SR_log;
         endmon;
       endif;

       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //kopf und Positionsdaten lesen   begsr sr_1000;
         // lesen afrk: Kopfdaten   +
         // lesen afrp: Positionen
       //-----------------------------------------------------------------------

       begsr sr_1000;

          clear            rpmsales_o;
       //afrk
          afrk_k.RKFIRM  =  rpm_load_i.RKFIRM;
          afrk_k.RKRGJJ  =  rpm_load_i.RKRGJJ;
          afrk_k.RKRGNR  =  rpm_load_i.RKRGNR;
          afrk_k.RKLIJJ  =  rpm_load_i.RKLIJJ;
          afrk_k.RKLINR  =  rpm_load_i.RKLINR;

          chain %kds(afrk_k:5) afrk01 afrk_I;
          if %found(afrk01);
       //afrp loop
             afrp_k.RpFIRM  =  rpm_load_i.RKFIRM;
             afrp_k.RpRGJJ  =  rpm_load_i.RKRGJJ;
             afrp_k.RpRGNR  =  rpm_load_i.RKRGNR;
             afrp_k.RpLIJJ  =  rpm_load_i.RKLIJJ;
             afrp_k.RpLINR  =  rpm_load_i.RKLINR;
             setll %kds(afrp_k:5) afrp01;
             reade %kds(afrp_k:5) afrp01  afrp_i;
             dow not %eof(afrp01);
       //rplipo=0 in der Schweiz für Rundungsdifferenzen
                if afrp_i.RPLIPO =  0;
       //Achtung Routine wird nicht versorgt, fehlende Trendzuordnungen
       //          exsr  srroundpos;
                endif;
                if afrp_i.RPUPOS =  0 and afrp_i.RPLIPO <> 0;
                   rpmsales_o.h4    = 'upload   ';
                   §§rpnesu         = AFRP_I.RPBRSU;
                   exsr sr_002;
                   §upload          = rpmsales_o.h4;
       //für weitere Unterergebnisse mit Ableitungsbedürfnis Ebene Kopf
       //rplipo=0 in der Schweiz für Rundungsdifferenzen
                   if afrk_i.rkerg1 <> *zero;
                      *IN(41) ='1';
                      *IN(42) ='0';
                      *IN(43) ='0';
                      *IN(44) ='0';
                      exsr  sr_002b;
                   endif;
                   rpmsales_o.h4 = §upload;
                   if afrk_i.rkerg2 <> *zero;
                      *IN(41) ='0';
                      *IN(42) ='1';
                      *IN(43) ='0';
                      *IN(44) ='0';
                      exsr  sr_002b;
                   endif;
                   rpmsales_o.h4 = §upload;
                   if afrk_i.rkerg3 <> *zero;
                      *IN(41) ='0';
                      *IN(42) ='0';
                      *IN(43) ='1';
                      *IN(44) ='0';
                      exsr  sr_002b;
                   endif;
                   rpmsales_o.h4 = §upload;
                   if afrk_i.rkerg4 <> *zero;
                      *IN(41) ='0';
                      *IN(42) ='0';
                      *IN(43) ='0';
                      *IN(44) ='1';
                      exsr  sr_002b;
                   endif;
                endif;
                clear            rpmsales_o;
                clear            §upload;
                if afrp_i.RPUPOS <> 0;
       //         Unterposition
                   #aflpL1_i.alnesu=afrp_i.rpnesu *100;
                   exsr srunterpos;
                endif;
                reade %kds(afrp_k:5) afrp01 afrp_i;
             enddo;
          else;
             eval status ='keine Positionen zu Kopf' +
                               afrk_k.RKFIRM         +
                         %char(afrk_k.RKRGJJ)        +
                               afrk_k.RKRGNR         +
                         %char(afrk_k.RKLIJJ)        +
                              (afrk_k.RKLINR);
             exsr      SR_log;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //Verarbeitung der Einzelsätze
         // lesen #aflpL1: Lieferscheinpositionen
         // lesen afko01:  Kopfdaten
         // lesen kund01:  Kundendaten
         // lesen kdew01:  Kundendaten Erweiterungen
       //-----------------------------------------------------------------------

       begsr sr_002;

          #aflpL1_k.alFIRM  =  rpm_load_i.RKFIRM;
          #aflpL1_k.alRGJJ  =  rpm_load_i.RKRGJJ;
          #aflpL1_k.alRGNR  =  rpm_load_i.RKRGNR;
          #aflpL1_k.alLIJJ  =  rpm_load_i.RKLIJJ;
          #aflpL1_k.alLINR  =  rpm_load_i.RKLINR;

          #aflpL1_k.allipo  =  afrp_i.rplipo;

          chain %kds(#aflpL1_k:6) #aflpL1 #aflpL1_I;
          if %found(#aflpL1);
             afko_k.akfirm  =  afrp_i.rpfirm;
             afko_k.akafjj  =  afrp_i.rpafjj;
             afko_k.akafnr  =  afrp_i.rpafnr;
             chain %kds(afko_k:3) afko01 afko_I;
             if %found(afko01);
       //afko  AKWKNR =  '001' usw.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                kund_k.kdfirm  =  afrk_i.RKFIRM;
                kund_k.kdkdnr  =  afrk_i.RKkdnr;
                chain %kds(kund_k:2) kund01 kund_I;
                if %found(kund01);
                   select;
                   when kund_i.kdfirm = '01';
                        rpmsales_o.ENTITY     = 'DE411';
                        select;
                        when afko_I.AKWKNR = '001';
                             rpmsales_o.ENTITY     = 'DE411';
                        when afko_I.AKWKNR = '002';
                             rpmsales_o.ENTITY     = 'NL411';
                        when afko_I.AKWKNR = '003';
                             rpmsales_o.ENTITY     = 'BE111';
                        when afko_I.AKWKNR = '004';
                             rpmsales_o.ENTITY     = 'AT411';
                        when afko_I.AKWKNR = '005';
                             rpmsales_o.ENTITY     = 'CH412';
                        when afko_I.AKWKNR = '010';
                             rpmsales_o.ENTITY     = 'SE811';
                        when afko_I.AKWKNR = '008';
                             rpmsales_o.ENTITY     = 'DE411';
                        other;
                             rpmsales_o.ENTITY     = 'ERROR';
                             eval rpmsales_o.h4    = 'no upload';
                        endsl;
                   when kund_i.kdfirm = '08';
                        rpmsales_o.ENTITY     = 'BE111';
                   when kund_i.kdfirm = '52';
                        rpmsales_o.ENTITY     = 'NL411';
                   when kund_i.kdfirm = '55';
                        rpmsales_o.ENTITY     = 'CH412';
                   when kund_i.kdfirm = '61';
                        rpmsales_o.ENTITY     = 'AT411';
                   when kund_i.kdfirm = '20';
                        rpmsales_o.ENTITY     = 'DE117';
                   other;
                        rpmsales_o.ENTITY     = 'ERROR';
                        eval rpmsales_o.h4    = 'no upload';
                   endsl;
                   if   kund_i.kdpold  = *blank;
                        eval rpmsales_o.h4    = 'no upload';
                   endif;
       //kdew
                   kdew_k.kdewfirm =  kund_i.kdfirm;
                   kdew_k.Kdewkdnr =  kund_i.kdkdnr;
                   chain %kds(kdew_k:2) kdew01 kdew_I;
                   if %found(kdew01);
                      select;
                         when kdew_I.KDEWKSST = '1001    ';
                             rpmsales_o.division   = 'RVOEM   ';
                         when kdew_I.KDEWKSST = '1002    ';
                             rpmsales_o.division   = 'RVAM    ';
                         when kdew_I.KDEWKSST = '1003    ';
                             rpmsales_o.division   = 'RETL    ';
                             rpmsales_o.division   = 'OUTD    ';
                         when kdew_I.KDEWKSST = '1004    ';
                             rpmsales_o.division   = 'LODG    ';
                             rpmsales_o.division   = 'HOSP    ';
                         when kdew_I.KDEWKSST = '1005    ';
                             rpmsales_o.division   = 'CPVOEM  ';
                         when kdew_I.KDEWKSST = '1006    ';
                             rpmsales_o.division   = 'CPVAM   ';
                         when kdew_I.KDEWKSST = '1007    ';
                             rpmsales_o.division   = 'MAOEM   ';
                         when kdew_I.KDEWKSST = '1008    ';
                             rpmsales_o.division   = 'MAAM    ';
                         when kdew_I.KDEWKSST = '1009    ';
                             if rpmsales_o.ENTITY     = 'DE411'
                             or rpmsales_o.ENTITY     = 'CH412'
                             or rpmsales_o.ENTITY     = 'AT411'
                             or rpmsales_o.ENTITY     = 'DE117';
                                rpmsales_o.division   = 'MEDI    ';
                                rpmsales_o.h4   = 'no upload';
                             endif;
                             if rpmsales_o.ENTITY     = 'NL411';
                                rpmsales_o.division   = 'RETL    ';
                             endif;
                             if rpmsales_o.ENTITY     = 'BE111';
                                rpmsales_o.division   = 'LODG    ';
                             endif;
                         when kdew_I.KDEWKSST = '1015    ';
                             rpmsales_o.division   = 'GROUP   ';
                             rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '1016    ';
                             rpmsales_o.division   = 'RESID   ';
                         when kdew_I.KDEWKSST = '1017    ';
                             rpmsales_o.division   = 'MOBDEL  ';
                         when kdew_I.KDEWKSST = '1020    ';
                             rpmsales_o.division   = 'OTHER   ';
                             rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '6050    ';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'OTHER   ';
       //                    rpmsales_o.h4   = 'no upload';
                         other;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
                      select;
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.division   = 'ERROR   ';
                                rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     <>'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     01';
       // 02.12.2019     Italienaufträge
                         when afko_i.akafat  = 'I55' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     I5';
                         when afko_i.akafat  = '01';
                             rpmsales_o.doctype = 'Sales Invoice     01';
                         when afko_i.akafat  = 'B2C';
                             rpmsales_o.doctype = 'Sales Invoice     2C';
                         when afko_i.akafat  = '03B';
                             rpmsales_o.doctype = 'Sales Invoice     3B';
                         when afko_i.akafat  = '02';
                             rpmsales_o.doctype = 'Sales Invoice     02';
                         when afko_i.akafat  = '03';
                             rpmsales_o.doctype = 'Sales Invoice     03';
                         when afko_i.akafat  = '04';
                             rpmsales_o.doctype = 'Sales Invoice     04';
                         when afko_i.akafat  = '05';
                             rpmsales_o.doctype = 'Sales Invoice     05';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '06';
                             rpmsales_o.doctype = 'Sales Invoice     06';
                         when afko_i.akafat  = '07';
                             rpmsales_o.doctype = 'Sales Invoice     07';
       // 20.09.2019         rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '08';
                             rpmsales_o.doctype = 'Sales Invoice     08';
                         when afko_i.akafat  = '10';
                             rpmsales_o.doctype = 'Sales Invoice     10';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '25';
                             rpmsales_o.doctype = 'Sales Invoice     25';
                         when afko_i.akafat  = '26';
                             rpmsales_o.doctype = 'Sales Invoice     26';
                         when afko_i.akafat  = '27';
                             rpmsales_o.doctype = 'Sales Invoice     27';
                         when afko_i.akafat  = '28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = 'A28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '55';
                             rpmsales_o.doctype = 'Sales Invoice     55';
                         when afko_i.akafat  = '59';
                             rpmsales_o.doctype = 'Sales Invoice     59';
                         when afko_i.akafat  = 'A55';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'I28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '54 ';
                             rpmsales_o.doctype = 'Sales Invoice     54';
                         when afko_i.akafat  = '54I';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '54S';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '510';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'N01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'B01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'C03';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '83';
                             rpmsales_o.doctype = 'Sales Invoice     83';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '88';
                             rpmsales_o.doctype = 'Sales Invoice     88';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '11';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 11';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '14';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 14';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '15';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 15';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '16';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 16';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '17';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 17';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '18';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 18';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '20';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 20';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '44';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 44';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '50';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 50';
                             rpmsales_o.h4         = 'no upload';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '70';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 70';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '71';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 71';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '72';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 72';
                         when afko_i.akafat  = '81';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 81';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '82';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 82';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '99';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 99';
                             rpmsales_o.h4         = 'no upload';
                         other;
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
       //             rpmsales_o.RPMGROUP   = %subst(kdew_I.kDEWRPMG:2:2);
       //umstellung auf neues customer classification feld 06.11.21 SC
                      rpmsales_o.RPMGROUP   = %subst(kdew_I.KDEWFL03:1:20);
                      rpmsales_o.PLANKUNDE  = kdew_I.KDEWKDPL;
                      if     rpmsales_o.RPMGROUP   = *blank;
       //Achtung Fehlererkennung aus 22.03.2022
                      //     rpmsales_o.h4   = 'no upload';
                      endif;
       //KUEG
                      kueg_k.kefirm  =  kund_i.kdfirm;
                      kueg_k.kekdnr  =  kund_i.kdkdnr;

                      chain %kds(kueg_k:2) kueg01 kueg_I;
                      if %found(kueg01);
                         eval   rpmsales_o.VAT#   = kueg_I.KEUSTI;
                      else;
                         clear  rpmsales_o.VAT#;
                      endif;
       //TEEW
                      if #aflpL1_i.altenr = '10711330  ';
                         #aflpL1_i.altenr = '10711330  ';
                      endif;
                      teew_k.teewfirm  =  #aflpL1_i.alFIRM;
                      teew_k.teewtenr  =  #aflpL1_i.altenr;
                      chain %kds(teew_k:2) teew01 teew_I;
                      if %found(teew01);
                         rpmsales_o.APPRGR  = teew_i.TEEWPRGR;
                         exsr $$TEEWPRGR;
                         if rpmsales_o.ENTITY     = 'NL411' or
                            rpmsales_o.ENTITY     = 'BE111';
                            if rpmsales_o.APPRGR  = '749';
                               rpmsales_o.APPRGR  = '610';
                            endif;
                         endif;
                         if   $$TEEWPRGR_ ='0';
                            rpmsales_o.APPRGR  = *blank;
                         endif;
                         if rpmsales_o.APPRGR  = *blank;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
       //                   rpmsales_o.h4   = 'no upload';
                         endif;
                      else;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                         rpmsales_o.APPRGR  = '000 ';
       //                rpmsales_o.h4   = 'no upload';
                      endif;
       //teil
                      teil_k.tefirm    =  #aflpL1_i.alFIRM;
                      teil_k.tetenr    =  #aflpL1_i.altenr;
                      chain %kds(teil_k:2) teil01 teil_I;
                      if %found(teil01);
                         rpmsales_o.COST_UNIT  = teil_i.testpr*100;
                         rpmsales_o.TEPRGR     = teil_i.TEPRGR;
                         rpmsales_o.TEDIAV     = teil_i.TEDIAV;
                      else;
                         rpmsales_o.COST_UNIT  = *zero;
                         rpmsales_o.h4         = 'no upload';
                      endif;
       //output
                      rpmsales_o.POSTDATE   =
                         %char(%dec(%char(%date():*iso0):8:0));

                      rpmsales_o.COUNT_ISO  =  kund_i.kdpold;
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;
       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
       //            keine Pfandwarenartikel
                      if  #aflpL1_i.altenr  = '8887100008' or
                          #aflpL1_i.altenr  = '8887100012' or
                          #aflpL1_i.altenr  = '8887100018' or
                          #aflpL1_i.altenr  = '8887100017' or
                          #aflpL1_i.altenr  = '8887100020' or
                          #aflpL1_i.altenr  = '8887100045' or
                          #aflpL1_i.altenr  = '8887100046' or
                          #aflpL1_i.altenr  = '8887100008-BE';
                         rpmsales_o.h4   = 'no upload';
                      endif;
                      rpmsales_o.ITEMDESC   =  #aflpL1_i.altbz1;
                      rpmsales_o.APGLMG     =  #aflpl1_i.alglmg;

                      §RKREDA    = afrk_i.rkreda;
                      §ENTRY#    = *blank;
                      exec sql
                        select char(days((date(substr(char(:§RKREDA), 1, 4)
                        concat '-'      concat substr(char(:§RKREDA), 5, 2)
                        concat '-'      concat substr(char(:§RKREDA), 7, 2)))))
                        into :§ENTRY#
                        from qsys2/qsqptabl;
                      rpmsales_o.ENTRY#     =  §ENTRY#;

       //             rpmsales_o.DOCTYPE
                      §rplipo = %EDITC(afrp_i.rplipo:'X');
       //             §rplipo = (%char(afrp_i.rplipo));
                      rpmsales_o.DOC        =  (%char(afrp_i.RPRGJJ)) + '/' +
                                                     (afrp_i.RPRGNR)  + '/' +
                                               (%char(afrp_i.rplijj)) + '/' +
                                                     (afrp_i.rplinr)  + '/' +
                                                            §rplipo   + '/' +
                                                     (afko_i.akafat)  + '/' +
                                                     (#aflpL1_i.allanr);
                      if rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                         rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                      endif;
                      rpmsales_o.RKREDA     =  afrk_i.rkreda;
       //             rpmsales_o.COST_UNIT
       //            attention gross total!
                      rpmsales_o.RPNESU     =  afrp_i.RPBRSU*100;
                      rpmsales_o.I_RPNESU   =  afrp_i.RPBRSU*100;
                      rpmsales_o.RKWACD     =  afrk_i.rkwacd;
                      rpmsales_o.I_RKWACD   =  afrk_i.rkwacd;
       //             rpmsales_o.APPRGR
       //            attention ...........!
       //            in be111 und nl411 alle Gruppen korrekt !!! Nina
       //            in de117                                !!! Nina   20.09.2019
                      if teil_i.TEPRGR     >'900';
       //            Aufheben #INC-377803  or                !!! Nina   29.10.2026
       //                teil_i.TEPRGR     ='000' or
       //                rpmsales_o.APPRGR ='000';
                         If (rpmsales_o.ENTITY     = 'BE111' or
                             rpmsales_o.ENTITY     = 'NL411' or
                             rpmsales_o.ENTITY     = 'DE117');
                         else;
                            rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
                      if teil_i.TEPRGR     ='190' or
                         teil_i.TEPRGR     ='199' or
                         teil_i.TEPRGR     ='290' or
                         teil_i.TEPRGR     ='299' or
       //                teil_i.TEPRGR     ='390' or
                         teil_i.TEPRGR     ='399' or
                         teil_i.TEPRGR     ='490' or
                         teil_i.TEPRGR     ='491' or
                         teil_i.TEPRGR     ='499' or
                         teil_i.TEPRGR     ='590' or
                         teil_i.TEPRGR     ='599' or
                         teil_i.TEPRGR     ='690' or
                         teil_i.TEPRGR     ='699' or
                         teil_i.TEPRGR     ='790' or
                         teil_i.TEPRGR     ='799';
       //            in de117                                !!! Nina   20.09.2019
                         if  rpmsales_o.ENTITY   <> 'DE117';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
       ////                 rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
       //             rpmsales_o.DIVISION
                      rpmsales_o.CUSTOMER#  =  kund_i.kdkdnr;
                      rpmsales_o.CUSTOMER   =  kund_i.KDNAM1;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDKNAM;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM2;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM3;
                      endif;
       //             rpmsales_o.RPMGROUP
       //             rpmsales_o.VAT#
       //             rpmsales_o.PLANKUNDE
       //             rpmsales_o.ABSATZAJ
       //             rpmsales_o.ABSATZVJ
       //             rpmsales_o.ABSATZVVJ
       //             rpmsales_o.ABSATZ_
                      rpmsales_o.AKFIRM     =  afko_i.AKFIRM;
                      rpmsales_o.AKAFJJ     =  afko_i.AKAFJJ;
                      rpmsales_o.AKAFNR     =  afko_i.AKAFNR;
                      rpmsales_o.AKAFAT     =  afko_i.AKAFAT;
                      rpmsales_o.ARTNR      =  *blank;
                      rpmsales_o.ARTSKU     =  *blank;
                      rpmsales_o.ARTBEZFRA  =  *blank;
                      rpmsales_o.ART        =  *blank;
                      exsr  $$LFS;
                      rpmsales_o.h1 = 'upload';
                      rpmsales_o.h2 = %date();
                      rpmsales_o.h3 = %timestamp();
                      rpmsales_o.h5 = %date();
                      rpmsales_o.h6 = %timestamp();

       //WAEH01      wenn Euro gefordert
                      if rpmsales_o.RKWACD    <> 'EUR' and
                         rpmsales_o.ENTITY    <> 'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'EUR';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;

       //WAEH01      wenn SEK  gefordert bei SE811
                      if rpmsales_o.RKWACD    =  'EUR' and
                         rpmsales_o.ENTITY    =  'SE811';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  'SEK';
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = 'SEK';
                            rpmsales_o.RKWACD = 'SEK';
                            rpmsales_o.COST_UNIT=
       //MW 07.5.24           (rpmsales_o.COST_UNIT *waeh_i.wakurs);
                               (rpmsales_o.COST_UNIT / waeh_i.wakurs);
                            rpmsales_o.rpnesu=
       //MW 15.4.24           (rpmsales_o.rpnesu*waeh_i.wakurs);
                               (rpmsales_o.rpnesu / waeh_i.wakurs);
                       //   readp waeh01  waeh_i;
                            leave;
                         enddo;
                      endif;

       //WAEH01      wenn CHF  gefordert
                      if rpmsales_o.RKWACD    <> 'CHF' and
                         rpmsales_o.ENTITY    =  'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'CHF';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM and
                            waeh_i.WASTWC = 'CHF'             and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'CHF';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;
                      rpmsales_o.h6 = %timestamp();

       //teos        Achtung evtl. sku-wechsel(!) in Verbindung mit
       //kalk_file2  wegen Lieferanten, die SKU Norm (!) verwenden
       //90025       DEFA ELTECH A.S  Ausnahmen
       //90489       DEFA Technology  "
       //90526       Tracer Products  "
                      teos_k.teosfirm =  #aflpL1_i.alFIRM;
       //            TEOS immer mit Firma 01 lesen, nur diese wurden seinerseits eingetragen
       //            entspricht dem Feld ARTSKU
                      teos_k.teosfirm =  '01';
                      teos_k.TEOSKLCD =  'SKU ';
                      teos_k.TEOSTENR =  #aflpL1_i.altenr;
                      Kalk_k.version =  '$$EL_PS_DB';
                      Kalk_k.artnr    =  #aflpL1_i.altenr;
                      chain %kds(kalk_k:2) kalk_file2 kalk_I;
                      if %found(kalk_file2);
                         if (kalk_i.artsku > '9103560727'  and
                            %subst(kalk_i.artsku:1:5)='91035');
       //$RPMSALESM        einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
                            eval kalk_i.lieferant1  =  '90484';
                         endif;
       //$RPMSALESM        90489 (DEFA Wuxi), 90025 is DEFA Norway       10.02.2020
                         if (kalk_i.artsku > '9600009999'  and
                             %subst(#aflpL1_i.altenr:1:1)='A') and
                            (kalk_i.lieferant1  =  '90489' or
                             kalk_i.lieferant1  =  '90025');
       //$RPMSALESM        einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
       //$RPMSALESM        lesen für TEOS      !!!!!
                            eval kalk_i.lieferant1  =  '90000';
                         endif;
                         if kalk_i.lieferant1  <> '90025' and
                            kalk_i.lieferant1  <> '90484' and
                            kalk_i.lieferant1  <> '92678' and
                            kalk_i.lieferant1  <> '90526';
                            chain %kds(teos_k:3) teos01 teos_I;
                            if %found(teos01) and teos_i.TEOSMM01 <> *blank
                               and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                     original aus TEOS         in rpmsales_o.ARTSKU
                               rpmsales_o.item       = teos_i.TEOSMM01;
                            endif;
       // start 25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            teew_k.teewfirm  =  #aflpL1_i.alFIRM;
                            teew_k.teewtenr  =  #aflpL1_i.altenr;
                            chain %kds(teew_k:2) teew01 teew_I;
                            if %found(teew01) and teew_i.TEEWSKUN <> *Blank
                                   and  %subst(teew_i.TEEWSKUN:01:03) <> '001';
                               rpmsales_o.item    = teew_i.TEEWSKUN;
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
                            endif;
       // ende  25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            if  %subst(kalk_i.artbezfra:01:03) <> '001' and
                                %subst(kalk_i.artbezfra:01:03) <> *blank;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                     original aus 2. Ableitung
                               rpmsales_o.item       = (kalk_i.artbezfra);
                               rpmsales_o.artbezfra  = (kalk_i.artbezfra);
                            endif;
                         endif;
                      else;
                      endif;
       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
                      if #aflpL1_i.altenr = 'VAS 6380/10B';
                         #aflpL1_i.altenr = 'VAS 6380/10B';
                      endif;
       //itemsoem#   Achtung evtl. sku-wechsel(!) in China für OEM
                      itemsoem#l_k.item    =  #aflpL1_i.altenr;
                      chain %kds(itemsoem#l_k:1) itemsoem#l  itemsoem#l_i;
                      if %found(itemsoem#l);
                         if itemsoem#l_I.cheng <> *blank;
       ///////!!!   and     itemsoem#l_I.cheng <> itemsoem#l_i.item;
       //                   itemsoem#l_I.item  <> rpmsales_o.ARTNR;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                     original aus China
                               rpmsales_o.item       =  itemsoem#l_I.cheng;
                               rpmsales_o.artbezfra  = 'CHENG OEM';
                         endif;
                      else;
                      endif;

       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
       //    Achtung 20 murcks bei Integration Ezetil !!!! 20180318
                      if rpmsales_o.item  = '10711330  ';
                         rpmsales_o.item  = '10711330  ';
                      endif;
                      if kund_i.kdfirm = '20';
                         teos_k.teosfirm =  '20';
                         teos_k.TEOSKLCD =  'SKU ';
                         teos_k.TEOSTENR =  rpmsales_o.item;
                         chain %kds(teos_k:3) teos01 teos_I;
                         if %found(teos01);
                         if teos_i.TEOSMM01 <> *blank
                            and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                  original aus Lieferschein in rpmsales_o.ARTNR
                            rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                  original aus TEOS         in rpmsales_o.ARTSKU
                            rpmsales_o.item       = teos_i.TEOSMM01;
                         endif;
                         endif;
                      endif;

                      §search              = ';';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = ',';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '"';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '`';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

       //             %scan(''':String);   ??????????
       //write
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;  // 20240304 übersteuert
       //Schweizer Artikel nach NorthStarProject                 // 20240304 übersteuert
                      if %subst(rpmsales_o.item:11:03) =  '-CH';  // 20240304 übersteuert
                         %subst(rpmsales_o.item:11:03)='   ';     // 20240304 übersteuert
                      endif;                                      // 20240304 übersteuert
                      exsr statistik;
                      write rpmsalesr  rpmsales_o;
       //             clear            rpmsales_o;
                   else;
                      rpmsales_o.h4         = 'no upload';
                      eval status ='Kundendaten für rpm fehlen in KDEW ' +
                            afrk_i.RKFIRM  +
                            afrk_i.RKkdnr  ;
                      exsr      SR_log;
                   endif;
                else;
                   rpmsales_o.h4         = 'no upload';
                   eval status ='Kunde fehlt aus Rechnungslauf in KUND ' +
                               afrk_i.RKFIRM  +
                               afrk_i.RKkdnr  ;
                   exsr      SR_log;
                endif;
             else;
                rpmsales_o.h4         = 'no upload';
                eval status ='keine Positionen zum Lieferschein' +
                                  afrk_k.RKFIRM         +
                            %char(afrk_k.RKRGJJ)        +
                                  afrk_k.RKRGNR         +
                            %char(afrk_k.RKLIJJ)        +
                                 (afrk_k.RKLINR)        +
                            %char(#aflpL1_i.allipo);
                exsr      SR_log;
             endif;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //kopf und Positionsdaten lesen   begsr sr_1000;
         // lesen afrk: Kopfdaten   +
         // lesen afrp: Positionen
       //-----------------------------------------------------------------------

       begsr SR_002B;

          if afrk_i.rknesu = 0;
             afrk_i.rknesu = 1;
          endif;
          select;
             when *IN(41)='1';
                  §rkkon  = afrk_i.rkkon1;
                  §rplipo = '0001';
                  §rpnesu = afrk_i.rkerg1;
                  eval(h) §rpnesu = afrk_i.rkerg1 * §§rpnesu / afrk_i.rknesu;
             when *IN(42)='1';
                  §rkkon  = afrk_i.rkkon2;
                  §rplipo = '0002';
                  §rpnesu = afrk_i.rkerg2;
                  eval(h) §rpnesu = afrk_i.rkerg2 * §§rpnesu / afrk_i.rknesu;
             when *IN(43) ='1';
                  §rkkon  = afrk_i.rkkon3;
                  §rplipo = '0003';
                  §rpnesu = afrk_i.rkerg3;
                  eval(h) §rpnesu = afrk_i.rkerg3 * §§rpnesu / afrk_i.rknesu;
             when *IN(44) ='1';
                  §rkkon  = afrk_i.rkkon4;
                  §rplipo = '0004';
                  §rpnesu = afrk_i.rkerg4;
                  eval(h) §rpnesu = afrk_i.rkerg4 * §§rpnesu / afrk_i.rknesu;
             other;
          endsl;

          trtp_k.tpfirm  =  rpm_load_i.RKFIRM;
          trtp_k.TPSPCD  =  'D';
          trtp_k.TPTART  =  'RBAT     ';
          trtp_k.TPTCDE  =  §rkkon;
          rpmsales_o.doctype = '                    ';

       //trtp
          chain %kds(trtp_k:4) trtp01 trtp_I;
          if %found(trtp01);
             rpmsales_o.ITEMDESC   =  trtp_i.TPTTXT;
          else;
             rpmsales_o.ITEMDESC   =  'no Text available';
             rpmsales_o.h4         = 'no upload';
          endif;

          rpmsales_o.§rkkon     = §rkkon;
          rpmsales_o.doctype    = *blank;

       //kont
          clear          kont_k;
          kont_k.ktfirm  =  rpm_load_i.RKFIRM;
          kont_k.KTBEGR  =  'KT8';
          kont_k.KTABTL  =  '001';
          kont_k.KTSTCD  =  §rkkon;
          kont_k.KTGADA  =  afrk_i.rkreda;

          rpmsales_o.doctype = '                    ';
          rpmsales_o.h4         = 'no upload';

          setgt %kds(kont_k:15) kont01;
          readp kont01  kont_i;
          dow not %eof(kont01)                  and
              kont_i.ktfirm = rpm_load_i.RKFIRM and
              kont_i.KTBEGR = 'KT8'             and
              kont_i.KTABTL = '001'             and
              kont_i.KTSTCD = §rkkon            and
              kont_i.KTGADA < afrk_i.rkreda;
              if kont_i.ktktin =  '108800 ';
                rpmsales_o.doctype = 'Sales CR/Adj Note   ';
                rpmsales_o.h4         = §upload;
              else;
              endif;
              readp  kont01  kont_i;
          enddo;

       //Ausnahme
          if §rkkon ='SKT';
             rpmsales_o.doctype = 'Sales CR/Adj Note   ';
             rpmsales_o.h4         = §upload;
          endif;

       //output
                      rpmsales_o.POSTDATE   =
                         %char(%dec(%char(%date():*iso0):8:0));

                      rpmsales_o.COUNT_ISO  =  kund_i.kdpold;
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;
       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
                      rpmsales_o.ITEMDESC   =  #aflpL1_i.altbz1;
                      rpmsales_o.APGLMG     =  0;

                      §RKREDA    = afrk_i.rkreda;

                      exec sql
                        select char(days((date(substr(char(:§RKREDA), 1, 4)
                        concat '-'      concat substr(char(:§RKREDA), 5, 2)
                        concat '-'      concat substr(char(:§RKREDA), 7, 2)))))
                        into :§ENTRY#
                        from qsys2/qsqptabl;
                      rpmsales_o.ENTRY#     =  §ENTRY#;
       //             rpmsales_o.DOCTYPE
       //             §rplipo = %EDITC(afrp_i.rplipo:'X');
       //             §rplipo = (%char(afrp_i.rplipo));
                      rpmsales_o.DOC        =  (%char(afrp_i.RPRGJJ)) + '/' +
                                                     (afrp_i.RPRGNR)  + '/' +
                                               (%char(afrp_i.rplijj)) + '/' +
                                                     (afrp_i.rplinr)  + '/' +
                                                            §rplipo   + '/' +
                                                     (afko_i.akafat)  + '/' +
                                                     (#aflpL1_i.allanr);
                      if rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                         rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                      endif;
                      rpmsales_o.RKREDA     =  afrk_i.rkreda;
       //             rpmsales_o.COST_UNIT
       //            attention gross total!
                      rpmsales_o.RPNESU     =  §rpnesu      *100;
                      rpmsales_o.I_RPNESU   =  §rpnesu      *100;
                      rpmsales_o.RKWACD     =  afrk_i.rkwacd;
                      rpmsales_o.I_RKWACD   =  afrk_i.rkwacd;
       //             rpmsales_o.TEDIAV
       //             rpmsales_o.APPRGR
       //            attention ...........!
       //             if teil_i.TEPRGR     >'900' or
       //                teil_i.TEPRGR     ='000' or
       //                rpmsales_o.APPRGR ='???';
       //                rpmsales_o.h4   = 'no upload';
       //             endif;
       //             rpmsales_o.DIVISION
                      rpmsales_o.CUSTOMER#  =  kund_i.kdkdnr;
                      rpmsales_o.CUSTOMER   =  kund_i.KDNAM1;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM2;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM3;
                      endif;
       //             rpmsales_o.RPMGROUP
       //             rpmsales_o.VAT#
       //             rpmsales_o.PLANKUNDE
       //             rpmsales_o.ABSATZAJ
       //             rpmsales_o.ABSATZVJ
       //             rpmsales_o.ABSATZVVJ
       //             rpmsales_o.ABSATZ_
                      rpmsales_o.AKFIRM     =  afko_i.AKFIRM;
                      rpmsales_o.AKAFJJ     =  afko_i.AKAFJJ;
                      rpmsales_o.AKAFNR     =  afko_i.AKAFNR;
                      rpmsales_o.AKAFAT     =  afko_i.AKAFAT;
                      rpmsales_o.ARTNR      =  *blank;
                      rpmsales_o.ARTSKU     =  *blank;
                      rpmsales_o.ARTBEZFRA  =  *blank;
                      rpmsales_o.ART        =  *blank;
                      exsr  $$LFS;
                      rpmsales_o.h1 = 'upload';
                      rpmsales_o.h2 = %date();
                      rpmsales_o.h3 = %timestamp();
                      rpmsales_o.h5 = %date();
                      rpmsales_o.h6 = %timestamp();

       //WAEH01      wenn Euro gefordert
                      if rpmsales_o.RKWACD    <> 'EUR' and
                         rpmsales_o.ENTITY    <> 'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'EUR';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;

       //WAEH01      wenn SEK  gefordert bei SE811
                      if rpmsales_o.RKWACD    =  'EUR' and
                         rpmsales_o.ENTITY    =  'SE811';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  'SEK';
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = 'SEK';
                            rpmsales_o.RKWACD = 'SEK';
                            rpmsales_o.COST_UNIT=
       //MW 07.5.24           (rpmsales_o.COST_UNIT *waeh_i.wakurs);
                               (rpmsales_o.COST_UNIT / waeh_i.wakurs);
                            rpmsales_o.rpnesu=
       //MW 15.4.24           (rpmsales_o.rpnesu*waeh_i.wakurs);
                               (rpmsales_o.rpnesu / waeh_i.wakurs);
                        //  readp waeh01  waeh_i;
                            leave;
                         enddo;
                      endif;

       //WAEH01      wenn CHF  gefordert
                      if rpmsales_o.RKWACD    <> 'CHF' and
                         rpmsales_o.ENTITY    =  'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'CHF';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM and
                            waeh_i.WASTWC = 'CHF'             and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'CHF';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;
                      rpmsales_o.h6 = %timestamp();

                      if kund_i.kdfirm = '20';
                         teos_k.teosfirm =  '20';
                         teos_k.TEOSKLCD =  'SKU ';
                         teos_k.TEOSTENR =  rpmsales_o.item;
                         chain %kds(teos_k:3) teos01 teos_I;
                         if %found(teos01);
                         if teos_i.TEOSMM01 <> *blank
                            and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                  original aus Lieferschein in rpmsales_o.ARTNR
                            rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                  original aus TEOS         in rpmsales_o.ARTSKU
                            rpmsales_o.item       = teos_i.TEOSMM01;
                         endif;
                         endif;
                      endif;

                      §search              = ';';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = ',';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '"';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '`';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;


       //write
          rpmsales_o.h1 = 'supplement';
       // rpmsales_o.h4 = 'no upload';
       //by supplemets no upload generally 29.11.2019 Nina
       //by supplemets no upload generally 19.05.2021 Nina off
       // rpmsales_o.h4 = 'no upload';
          rpmsales_o.ITEM       =  #aflpL1_i.altenr;              // 20240304 übersteuert
       //Schweizer Artikel nach NorthStarProject                 // 20240304 übersteuert
                      if %subst(rpmsales_o.item:11:03) =  '-CH';  // 20240304 übersteuert
                         %subst(rpmsales_o.item:11:03)='   ';     // 20240304 übersteuert
                      endif;                                      // 20240304 übersteuert
          exsr statistik;
          write rpmsalesr  rpmsales_o;
       // clear            rpmsales_o;

       endsr;

       //-----------------------------------------------------------------------
       //UNTERPOSITIONEN stehen nicht im Lieferscheinsatz
         // lesen afko01:  Kopfdaten
         // lesen kund01:  Kundendaten
         // lesen kdew01:  Kundendaten Erweiterungen
       //-----------------------------------------------------------------------

       begsr srunterpos;

             afko_k.akfirm  =  afrp_i.rpfirm;
             afko_k.akafjj  =  afrp_i.rpafjj;
             afko_k.akafnr  =  afrp_i.rpafnr;
             chain %kds(afko_k:3) afko01 afko_I;
             if %found(afko01);
       //kund
                kund_k.kdfirm  =  afrk_i.RKFIRM;
                kund_k.kdkdnr  =  afrk_i.RKkdnr;
                chain %kds(kund_k:2) kund01 kund_I;
                if %found(kund01);
                   select;
                   when kund_i.kdfirm = '01';
                        rpmsales_o.ENTITY     = 'DE411';
                        select;
                        when afko_I.AKWKNR = '001';
                             rpmsales_o.ENTITY     = 'DE411';
                        when afko_I.AKWKNR = '002';
                             rpmsales_o.ENTITY     = 'NL411';
                        when afko_I.AKWKNR = '003';
                             rpmsales_o.ENTITY     = 'BE111';
                        when afko_I.AKWKNR = '004';
                             rpmsales_o.ENTITY     = 'AT411';
                        when afko_I.AKWKNR = '005';
                             rpmsales_o.ENTITY     = 'CH412';
                        when afko_I.AKWKNR = '008';
                             rpmsales_o.ENTITY     = 'DE411';
                        when afko_I.AKWKNR = '010';
                             rpmsales_o.ENTITY     = 'SE811';
                        other;
                             rpmsales_o.ENTITY     = 'ERROR';
                             eval rpmsales_o.h4    = 'no upload';
                        endsl;
                   when kund_i.kdfirm = '08';
                        rpmsales_o.ENTITY     = 'BE111';
                   when kund_i.kdfirm = '52';
                        rpmsales_o.ENTITY     = 'NL411';
                   when kund_i.kdfirm = '55';
                        rpmsales_o.ENTITY     = 'CH412';
                   when kund_i.kdfirm = '61';
                        rpmsales_o.ENTITY     = 'AT411';
                   when kund_i.kdfirm = '20';
                        rpmsales_o.ENTITY     = 'DE117';
                   other;
                        rpmsales_o.ENTITY     = 'ERROR';
                        eval rpmsales_o.h4    = 'no upload';
                   endsl;
                   if   kund_i.kdpold  = *blank;
                        eval rpmsales_o.h4    = 'no upload';
                   endif;
       //kdew
                   kdew_k.kdewfirm =  kund_i.kdfirm;
                   kdew_k.Kdewkdnr =  kund_i.kdkdnr;
                   chain %kds(kdew_k:2) kdew01 kdew_I;
                   if %found(kdew01);
                      select;
                         when kdew_I.KDEWKSST = '1001    ';
                             rpmsales_o.division   = 'RVOEM   ';
                         when kdew_I.KDEWKSST = '1002    ';
                             rpmsales_o.division   = 'RVAM    ';
                         when kdew_I.KDEWKSST = '1003    ';
                             rpmsales_o.division   = 'RETL    ';
                             rpmsales_o.division   = 'OUTD    ';
                         when kdew_I.KDEWKSST = '1004    ';
                             rpmsales_o.division   = 'LODG    ';
                             rpmsales_o.division   = 'HOSP    ';
                         when kdew_I.KDEWKSST = '1005    ';
                             rpmsales_o.division   = 'CPVOEM  ';
                         when kdew_I.KDEWKSST = '1006    ';
                             rpmsales_o.division   = 'CPVAM   ';
                         when kdew_I.KDEWKSST = '1007    ';
                             rpmsales_o.division   = 'MAOEM   ';
                         when kdew_I.KDEWKSST = '1008    ';
                             rpmsales_o.division   = 'MAAM    ';
                         when kdew_I.KDEWKSST = '1009    ';
                             if rpmsales_o.ENTITY     = 'DE411'
                             or rpmsales_o.ENTITY     = 'CH412'
                             or rpmsales_o.ENTITY     = 'AT411'
                             or rpmsales_o.ENTITY     = 'DE117';
                                rpmsales_o.division   = 'MEDI    ';
                                rpmsales_o.h4   = 'no upload';
                             endif;
                             if rpmsales_o.ENTITY     = 'NL411';
                                rpmsales_o.division   = 'RETL    ';
                             endif;
                             if rpmsales_o.ENTITY     = 'BE111';
                                rpmsales_o.division   = 'LODG    ';
                             endif;
                         when kdew_I.KDEWKSST = '1015    ';
                             rpmsales_o.division   = 'GROUP   ';
                             rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '1016    ';
                             rpmsales_o.division   = 'RESID   ';
                         when kdew_I.KDEWKSST = '1017    ';
                             rpmsales_o.division   = 'MOBDEL  ';
                         when kdew_I.KDEWKSST = '1020    ';
                             rpmsales_o.division   = 'OTHER   ';
                             rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '6050    ';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'OTHER   ';
                             rpmsales_o.h4   = 'no upload';
                         other;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
                      select;
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.division   = 'ERROR   ';
                                rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     <>'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     01';
       // 02.12.2019     Italienaufträge
                         when afko_i.akafat  = 'I55' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     I5';
                         when afko_i.akafat  = '01';
                             rpmsales_o.doctype = 'Sales Invoice     01';
                         when afko_i.akafat  = 'B2C';
                             rpmsales_o.doctype = 'Sales Invoice     2C';
                         when afko_i.akafat  = '03B';
                             rpmsales_o.doctype = 'Sales Invoice     3B';
                         when afko_i.akafat  = 'C03';
                             rpmsales_o.doctype = 'Sales Invoice     C0';
                         when afko_i.akafat  = '02';
                             rpmsales_o.doctype = 'Sales Invoice     02';
                         when afko_i.akafat  = '03';
                             rpmsales_o.doctype = 'Sales Invoice     03';
                         when afko_i.akafat  = '04';
                             rpmsales_o.doctype = 'Sales Invoice     04';
                         when afko_i.akafat  = '05';
                             rpmsales_o.doctype = 'Sales Invoice     05';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '06';
                             rpmsales_o.doctype = 'Sales Invoice     06';
                         when afko_i.akafat  = '07';
                             rpmsales_o.doctype = 'Sales Invoice     07';
       // 20.09.2019         rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '08';
                             rpmsales_o.doctype = 'Sales Invoice     08';
                         when afko_i.akafat  = '10';
                             rpmsales_o.doctype = 'Sales Invoice     10';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '25';
                             rpmsales_o.doctype = 'Sales Invoice     25';
                         when afko_i.akafat  = '26';
                             rpmsales_o.doctype = 'Sales Invoice     26';
                         when afko_i.akafat  = '27';
                             rpmsales_o.doctype = 'Sales Invoice     27';
                         when afko_i.akafat  = '28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = 'A28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '55';
                             rpmsales_o.doctype = 'Sales Invoice     55';
                         when afko_i.akafat  = '59';
                             rpmsales_o.doctype = 'Sales Invoice     59';
                         when afko_i.akafat  = 'A55';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'I28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '54 ';
                             rpmsales_o.doctype = 'Sales Invoice     54';
                         when afko_i.akafat  = '54I';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '54S';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '510';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'N01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'B01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'C03';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '83';
                             rpmsales_o.doctype = 'Sales Invoice     83';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '88';
                             rpmsales_o.doctype = 'Sales Invoice     88';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '11';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 11';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '14';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 14';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '15';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 15';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '16';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 16';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '17';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 17';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '18';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 18';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '20';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 20';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '44';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 44';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '50';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 50';
                             rpmsales_o.h4         = 'no upload';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '70';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 70';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '71';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 71';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '72';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 72';
                         when afko_i.akafat  = '81';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 81';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '82';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 82';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '99';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 99';
                             rpmsales_o.h4         = 'no upload';
                         other;
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
       //             rpmsales_o.RPMGROUP   = %subst(kdew_I.kDEWRPMG:2:2);
       //umstellung auf neues customer classification feld 06.11.21 SC
                      rpmsales_o.RPMGROUP   = %subst(kdew_I.KDEWFL03:1:20);
                      rpmsales_o.PLANKUNDE  = kdew_I.KDEWKDPL;
       //Achtung Fehlererkennung aus 22.03.2022
                      if     rpmsales_o.RPMGROUP   = *blank;
          //                 rpmsales_o.h4   = 'no upload';
                      endif;
       //KUEG
                      kueg_k.kefirm  =  kund_i.kdfirm;
                      kueg_k.kekdnr  =  kund_i.kdkdnr;

                      chain %kds(kueg_k:2) kueg01 kueg_I;
                      if %found(kueg01);
                         eval   rpmsales_o.VAT#   = kueg_I.KEUSTI;
                      else;
                         clear  rpmsales_o.VAT#;
                      endif;
       //TEEW
                      teew_k.teewfirm  =  #aflpL1_i.alFIRM;
                      teew_k.teewtenr  =  #aflpL1_i.altenr;
                      chain %kds(teew_k:2) teew01 teew_I;
                      if %found(teew01);
                         rpmsales_o.APPRGR  = teew_i.TEEWPRGR;
                         exsr $$TEEWPRGR;
                         if rpmsales_o.ENTITY     = 'NL411' or
                            rpmsales_o.ENTITY     = 'BE111';
                            if rpmsales_o.APPRGR  = '749';
                               rpmsales_o.APPRGR  = '610';
                            endif;
                         endif;
                         if   $$TEEWPRGR_ ='0';
                            rpmsales_o.APPRGR  = *blank;
                         endif;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                         if rpmsales_o.APPRGR  = *blank;
       //                   rpmsales_o.h4   = 'no upload';
                         endif;
                      else;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                         rpmsales_o.APPRGR  = '000 ';
       //                rpmsales_o.h4   = 'no upload';
                      endif;
       //teil
                      teil_k.tefirm    =  #aflpL1_i.alFIRM;
                      teil_k.tetenr    =  #aflpL1_i.altenr;
                      chain %kds(teil_k:2) teil01 teil_I;
                      if %found(teil01);
                         rpmsales_o.COST_UNIT  = teil_i.testpr*100;
                         rpmsales_o.TEPRGR     = teil_i.TEPRGR;
                         rpmsales_o.TEDIAV     = teil_i.TEDIAV;
                      else;
                         rpmsales_o.COST_UNIT  = *zero;
                         rpmsales_o.h4         = 'no upload';
                      endif;
       //output
                      rpmsales_o.POSTDATE   =
                         %char(%dec(%char(%date():*iso0):8:0));

                      rpmsales_o.COUNT_ISO  =  kund_i.kdpold;
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;
       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
       //            keine Pfandwarenartikel
                      if  #aflpL1_i.altenr  = '8887100008' or
                          #aflpL1_i.altenr  = '8887100012' or
                          #aflpL1_i.altenr  = '8887100018' or
                          #aflpL1_i.altenr  = '8887100017' or
                          #aflpL1_i.altenr  = '8887100020' or
                          #aflpL1_i.altenr  = '8887100045' or
                          #aflpL1_i.altenr  = '8887100046' or
                          #aflpL1_i.altenr  = '8887100008-BE';
                         rpmsales_o.h4   = 'no upload';
                      endif;
                      rpmsales_o.ITEMDESC   =  #aflpL1_i.altbz1;
                      rpmsales_o.APGLMG     =  #aflpl1_i.alglmg;

                      §RKREDA    = afrk_i.rkreda;
                      §ENTRY#    = *blank;
                      exec sql
                        select char(days((date(substr(char(:§RKREDA), 1, 4)
                        concat '-'      concat substr(char(:§RKREDA), 5, 2)
                        concat '-'      concat substr(char(:§RKREDA), 7, 2)))))
                        into :§ENTRY#
                        from qsys2/qsqptabl;
                      rpmsales_o.ENTRY#     =  §ENTRY#;

       //             rpmsales_o.DOCTYPE
                      §rplipo = %EDITC(afrp_i.rplipo:'X');
       //             §rplipo = (%char(afrp_i.rplipo));
                      rpmsales_o.DOC        =  (%char(afrp_i.RPRGJJ)) + '/' +
                                                     (afrp_i.RPRGNR)  + '/' +
                                               (%char(afrp_i.rplijj)) + '/' +
                                                     (afrp_i.rplinr)  + '/' +
                                                            §rplipo   + '/' +
                                                     (afko_i.akafat)  + '/' +
                                                     (#aflpL1_i.allanr);
                      if rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                         rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                      endif;
                      rpmsales_o.RKREDA     =  afrk_i.rkreda;
       //             rpmsales_o.COST_UNIT
       //            attention gross total!
                      rpmsales_o.RPNESU     =  afrp_i.RPBRSU*100;
                      rpmsales_o.I_RPNESU   =  afrp_i.RPBRSU*100;
                      rpmsales_o.RKWACD     =  afrk_i.rkwacd;
                      rpmsales_o.I_RKWACD   =  afrk_i.rkwacd;
       //             rpmsales_o.APPRGR
       //            attention ...........!
       //            in be111 und nl411 alle Gruppen korrekt !!! Nina
       //            in DE117           alle Gruppen korrekt !!! Nina   20.09.2019
                      if teil_i.TEPRGR     >'900';
       //            Aufheben #INC-377803  or                !!! Nina   29.10.2026
       //                teil_i.TEPRGR     ='000' or
       //                rpmsales_o.APPRGR ='000';
                         If (rpmsales_o.ENTITY     = 'BE111' or
                             rpmsales_o.ENTITY     = 'NL411' or
                             rpmsales_o.ENTITY     = 'DE117');
                         else;
                            rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
                      if teil_i.TEPRGR     ='190' or
                         teil_i.TEPRGR     ='199' or
                         teil_i.TEPRGR     ='290' or
                         teil_i.TEPRGR     ='299' or
       //                teil_i.TEPRGR     ='390' or
                         teil_i.TEPRGR     ='399' or
                         teil_i.TEPRGR     ='490' or
                         teil_i.TEPRGR     ='491' or
                         teil_i.TEPRGR     ='499' or
                         teil_i.TEPRGR     ='590' or
                         teil_i.TEPRGR     ='599' or
                         teil_i.TEPRGR     ='690' or
                         teil_i.TEPRGR     ='699' or
                         teil_i.TEPRGR     ='790' or
                         teil_i.TEPRGR     ='799';
       //            in de117                                !!! Nina   20.09.2019
                         if  rpmsales_o.ENTITY   <> 'DE117';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
       ////                 rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
       //             rpmsales_o.DIVISION
                      rpmsales_o.CUSTOMER#  =  kund_i.kdkdnr;
                      rpmsales_o.CUSTOMER   =  kund_i.KDNAM1;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDKNAM;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM2;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM3;
                      endif;
       //             rpmsales_o.RPMGROUP
       //             rpmsales_o.VAT#
       //             rpmsales_o.PLANKUNDE
       //             rpmsales_o.ABSATZAJ
       //             rpmsales_o.ABSATZVJ
       //             rpmsales_o.ABSATZVVJ
       //             rpmsales_o.ABSATZ_
                      rpmsales_o.AKFIRM     =  afko_i.AKFIRM;
                      rpmsales_o.AKAFJJ     =  afko_i.AKAFJJ;
                      rpmsales_o.AKAFNR     =  afko_i.AKAFNR;
                      rpmsales_o.AKAFAT     =  afko_i.AKAFAT;
                      rpmsales_o.ARTNR      =  *blank;
                      rpmsales_o.ARTSKU     =  *blank;
                      rpmsales_o.ARTBEZFRA  =  *blank;
                      rpmsales_o.ART        =  *blank;
                      exsr  $$LFS;
                      rpmsales_o.h1 = 'upload';
                      rpmsales_o.h2 = %date();
                      rpmsales_o.h3 = %timestamp();
                      rpmsales_o.h5 = %date();
                      rpmsales_o.h6 = %timestamp();

       //WAEH01      wenn Euro gefordert
                      if rpmsales_o.RKWACD    <> 'EUR' and
                         rpmsales_o.ENTITY    <> 'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'EUR';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;

       //WAEH01      wenn SEK  gefordert bei SE811
                      if rpmsales_o.RKWACD    =  'EUR' and
                         rpmsales_o.ENTITY    =  'SE811';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  'SEK';
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = 'SEK';
                            rpmsales_o.RKWACD = 'SEK';
                            rpmsales_o.COST_UNIT=
       //MW 07.5.24           (rpmsales_o.COST_UNIT *waeh_i.wakurs);
                               (rpmsales_o.COST_UNIT / waeh_i.wakurs);
                            rpmsales_o.rpnesu=
       //MW 15.4.24           (rpmsales_o.rpnesu*waeh_i.wakurs);
                               (rpmsales_o.rpnesu / waeh_i.wakurs);
                        //  readp waeh01  waeh_i;
                            leave;
                         enddo;
                      endif;

       //WAEH01      wenn CHF  gefordert
                      if rpmsales_o.RKWACD    <> 'CHF' and
                         rpmsales_o.ENTITY    =  'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'CHF';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM and
                            waeh_i.WASTWC = 'CHF'             and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'CHF';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;
                      rpmsales_o.h6 = %timestamp();

       //teos        Achtung evtl. sku-wechsel(!) in Verbindung mit
       //kalk_file2  wegen Lieferanten, die SKU Norm (!) verwenden
       //90025       DEFA ELTECH A.S  Ausnahmen
       //90489       DEFA Technology  "
       //90526       Tracer Products  "
                      teos_k.teosfirm =  afrp_i.rpfirm;
       //            TEOS immer mit Firma 01 lesen, nur diese wurden seinerseits eingetragen
       //            entspricht dem Feld ARTSKU
                      teos_k.teosfirm =  '01';
                      teos_k.TEOSKLCD =  'SKU ';
                      teos_k.TEOSTENR =  afrp_i.rptenr;
                      Kalk_k.version =  '$$EL_PS_DB';
                      Kalk_k.artnr    =  afrp_i.rptenr;
                      chain %kds(kalk_k:2) kalk_file2 kalk_I;
                      if %found(kalk_file2);
                         if (kalk_i.artsku > '9103560727'  and
                            %subst(kalk_i.artsku:1:5)='91035');
       //                  einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
                            eval kalk_i.lieferant1  =  '90484';
                         endif;
       //$RPMSALESM        90489 (DEFA Wuxi), 90025 is DEFA Norway       10.02.2020
                         if (kalk_i.artsku > '9600009999'  and
                             %subst(#aflpL1_i.altenr:1:1)='A') and
                            (kalk_i.lieferant1  =  '90489' or
                             kalk_i.lieferant1  =  '90025');
       //$RPMSALESM        einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
       //$RPMSALESM        lesen für TEOS      !!!!!
                            eval kalk_i.lieferant1  =  '90000';
                         endif;
                         if kalk_i.lieferant1  <> '90025' and
                            kalk_i.lieferant1  <> '90484' and
                            kalk_i.lieferant1  <> '92678' and
                            kalk_i.lieferant1  <> '90526';
                            chain %kds(teos_k:3) teos01 teos_I;
                            if %found(teos01) and teos_i.TEOSMM01 <> *blank
                               and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  afrp_i.rptenr;
       //                     original aus TEOS         in rpmsales_o.ARTSKU
                               rpmsales_o.item       = teos_i.TEOSMM01;
                            endif;
       // start 25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            teew_k.teewfirm  =  #aflpL1_i.alFIRM;
                            teew_k.teewtenr  =  #aflpL1_i.altenr;
                            chain %kds(teew_k:2) teew01 teew_I;
                            if %found(teew01) and teew_i.TEEWSKUN <> *Blank
                                   and  %subst(teew_i.TEEWSKUN:01:03) <> '001';
                               rpmsales_o.item    = teew_i.TEEWSKUN;
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
                            endif;
       // ende  25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            if  %subst(kalk_i.artbezfra:01:03) <> '001' and
                                %subst(kalk_i.artbezfra:01:03) <> *blank;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                     original aus 2. Ableitung
                               rpmsales_o.item       = (kalk_i.artbezfra);
                               rpmsales_o.artbezfra  = (kalk_i.artbezfra);
                            endif;
                         endif;
                      else;
                      endif;

       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
       //itemsoem#   Achtung evtl. sku-wechsel(!) in China für OEM
                      itemsoem#l_k.item    =  #aflpL1_i.altenr;
                      chain %kds(itemsoem#l_k:1) itemsoem#l  itemsoem#l_i;
                      if %found(itemsoem#l);
                         if itemsoem#l_I.cheng <> *blank;
       ///////!!!   and     itemsoem#l_I.cheng <> itemsoem#l_i.item;
       //                   itemsoem#l_I.item  <> rpmsales_o.ARTNR;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  afrp_i.rptenr;
       //                     original aus China
                               rpmsales_o.item       =  itemsoem#l_I.cheng;
                               rpmsales_o.artbezfra  = 'CHENG OEM';
                         endif;
                      else;
                      endif;

       //    Achtung 20 murcks bei Integration Ezetil !!!! 20180318
                      if kund_i.kdfirm = '20';
                         teos_k.teosfirm =  '20';
                         teos_k.TEOSKLCD =  'SKU ';
                         teos_k.TEOSTENR =  rpmsales_o.item;
                         chain %kds(teos_k:3) teos01 teos_I;
                         if %found(teos01) and teos_i.TEOSMM01 <> *blank
                            and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                  original aus Lieferschein in rpmsales_o.ARTNR
                            rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                  original aus TEOS         in rpmsales_o.ARTSKU
                            rpmsales_o.item       = teos_i.TEOSMM01;
                         endif;
                      endif;

       //             %scan(';':String);
       //             %scan(',':String);
       //             %scan('"':String);
       //             %scan('´':String);
       //             %scan('`':String);
       //write
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;  // 20240304 übersteuert
       //Schweizer Artikel nach NorthStarProject                 // 20240304 übersteuert
                      if %subst(rpmsales_o.item:11:03) =  '-CH';  // 20240304 übersteuert
                         %subst(rpmsales_o.item:11:03)='   ';     // 20240304 übersteuert
                      endif;                                      // 20240304 übersteuert
                      exsr statistik;
                      rpmsales_o.h1 = 'sub_item  ';
                      rpmsales_o.h4 = 'no upload';
                      write rpmsalesr  rpmsales_o;
       //             clear            rpmsales_o;
                   else;
                      rpmsales_o.h4         = 'no upload';
                      eval status ='Kundendaten für rpm fehlen in KDEW ' +
                            afrk_i.RKFIRM  +
                            afrk_i.RKkdnr  ;
                      exsr      SR_log;
                   endif;
                else;
                   rpmsales_o.h4         = 'no upload';
                   eval status ='Kunde fehlt aus Rechnungslauf in KUND ' +
                               afrk_i.RKFIRM  +
                               afrk_i.RKkdnr  ;
                   exsr      SR_log;
                endif;
             else;
                rpmsales_o.h4         = 'no upload';
                eval status ='keine Positionen zum Lieferschein' +
                                  afrk_k.RKFIRM         +
                            %char(afrk_k.RKRGJJ)        +
                                  afrk_k.RKRGNR         +
                            %char(afrk_k.RKLIJJ)        +
                                 (afrk_k.RKLINR)        +
                            %char(#aflpL1_i.allipo);
                exsr      SR_log;
             endif;

       endsr;

       //-----------------------------------------------------------------------
       //SONDERFALL RUNDUNGSDIFFERENZEN Schweiz
       //rplipo=0 in der Schweiz für Rundungsdifferenzen
       //Achtung lesen mit rpfirm und rptenr !
       //Achtung Trend versorgt die Parameter RPAFJJ + RPAFNR nicht in diesem
       //Fall !!!!  die Routine failed
         // lesen afko01:  Kopfdaten
         // lesen kund01:  Kundendaten
         // lesen kdew01:  Kundendaten Erweiterungen
       //-----------------------------------------------------------------------

       begsr srroundpos;

       //lesen läuft im Fehlerfall!!
             afko_k.akfirm  =  afrp_i.rpfirm;
             afko_k.akafjj  =  afrp_i.rpafjj;
             afko_k.akafnr  =  afrp_i.rpafnr;
             chain %kds(afko_k:3) afko01 afko_I;
             if %found(afko01);
       //kund
                kund_k.kdfirm  =  afrk_i.RKFIRM;
                kund_k.kdkdnr  =  afrk_i.RKkdnr;
                chain %kds(kund_k:2) kund01 kund_I;
                if %found(kund01);
                   select;
                   when kund_i.kdfirm = '01';
                        rpmsales_o.ENTITY     = 'DE411';
                        select;
                        when afko_I.AKWKNR = '001';
                             rpmsales_o.ENTITY     = 'DE411';
                        when afko_I.AKWKNR = '002';
                             rpmsales_o.ENTITY     = 'NL411';
                        when afko_I.AKWKNR = '003';
                             rpmsales_o.ENTITY     = 'BE111';
                        when afko_I.AKWKNR = '004';
                             rpmsales_o.ENTITY     = 'AT411';
                        when afko_I.AKWKNR = '005';
                             rpmsales_o.ENTITY     = 'CH412';
                        when afko_I.AKWKNR = '008';
                             rpmsales_o.ENTITY     = 'DE411';
                        when afko_I.AKWKNR = '010';
                             rpmsales_o.ENTITY     = 'SE811';
                        other;
                             rpmsales_o.ENTITY     = 'ERROR';
                             eval rpmsales_o.h4    = 'no upload';
                        endsl;
                   when kund_i.kdfirm = '08';
                        rpmsales_o.ENTITY     = 'BE111';
                   when kund_i.kdfirm = '52';
                        rpmsales_o.ENTITY     = 'NL411';
                   when kund_i.kdfirm = '55';
                        rpmsales_o.ENTITY     = 'CH412';
                   when kund_i.kdfirm = '61';
                        rpmsales_o.ENTITY     = 'AT411';
                   when kund_i.kdfirm = '20';
                        rpmsales_o.ENTITY     = 'DE117';
                   other;
                        rpmsales_o.ENTITY     = 'ERROR';
                        eval rpmsales_o.h4    = 'no upload';
                   endsl;
                   if   kund_i.kdpold  = *blank;
                        eval rpmsales_o.h4    = 'no upload';
                   endif;
       //kdew
                   kdew_k.kdewfirm =  kund_i.kdfirm;
                   kdew_k.Kdewkdnr =  kund_i.kdkdnr;
                   chain %kds(kdew_k:2) kdew01 kdew_I;
                   if %found(kdew01);
                      select;
                         when kdew_I.KDEWKSST = '1001    ';
                             rpmsales_o.division   = 'RVOEM   ';
                         when kdew_I.KDEWKSST = '1002    ';
                             rpmsales_o.division   = 'RVAM    ';
                         when kdew_I.KDEWKSST = '1003    ';
                             rpmsales_o.division   = 'RETL    ';
                             rpmsales_o.division   = 'OUTD    ';
                         when kdew_I.KDEWKSST = '1004    ';
                             rpmsales_o.division   = 'LODG    ';
                             rpmsales_o.division   = 'HOSP    ';
                         when kdew_I.KDEWKSST = '1005    ';
                             rpmsales_o.division   = 'CPVOEM  ';
                         when kdew_I.KDEWKSST = '1006    ';
                             rpmsales_o.division   = 'CPVAM   ';
                         when kdew_I.KDEWKSST = '1007    ';
                             rpmsales_o.division   = 'MAOEM   ';
                         when kdew_I.KDEWKSST = '1008    ';
                             rpmsales_o.division   = 'MAAM    ';
                         when kdew_I.KDEWKSST = '1009    ';
                             if rpmsales_o.ENTITY     = 'DE411'
                             or rpmsales_o.ENTITY     = 'CH412'
                             or rpmsales_o.ENTITY     = 'AT411'
                             or rpmsales_o.ENTITY     = 'DE117';
                                rpmsales_o.division   = 'MEDI    ';
                                rpmsales_o.h4   = 'no upload';
                             endif;
                             if rpmsales_o.ENTITY     = 'NL411';
                                rpmsales_o.division   = 'RETL    ';
                             endif;
                             if rpmsales_o.ENTITY     = 'BE111';
                                rpmsales_o.division   = 'LODG    ';
                             endif;
                         when kdew_I.KDEWKSST = '1015    ';
                             rpmsales_o.division   = 'GROUP   ';
                             rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '1016    ';
                             rpmsales_o.division   = 'RESID   ';
                         when kdew_I.KDEWKSST = '1017    ';
                             rpmsales_o.division   = 'MOBDEL  ';
                         when kdew_I.KDEWKSST = '1020    ';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'OTHER   ';
       //                    rpmsales_o.h4   = 'no upload';
                         when kdew_I.KDEWKSST = '6050    ';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'OTHER   ';
                             rpmsales_o.h4   = 'no upload';
                         other;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
                      select;
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.division   = 'ERROR   ';
                                rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = 'A01' and
                             rpmsales_o.ENTITY     <>'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     01';
       // 02.12.2019     Italienaufträge
                         when afko_i.akafat  = 'I55' and
                             rpmsales_o.ENTITY     = 'DE411';
                                rpmsales_o.doctype = 'Sales Invoice     I5';
                         when afko_i.akafat  = '01';
                             rpmsales_o.doctype = 'Sales Invoice     01';
                         when afko_i.akafat  = 'B2C';
                             rpmsales_o.doctype = 'Sales Invoice     2C';
                         when afko_i.akafat  = '03B';
                             rpmsales_o.doctype = 'Sales Invoice     3B';
                         when afko_i.akafat  = 'C03';
                             rpmsales_o.doctype = 'Sales Invoice     C0';
                         when afko_i.akafat  = '02';
                             rpmsales_o.doctype = 'Sales Invoice     02';
                         when afko_i.akafat  = '03';
                             rpmsales_o.doctype = 'Sales Invoice     03';
                         when afko_i.akafat  = '04';
                             rpmsales_o.doctype = 'Sales Invoice     04';
                         when afko_i.akafat  = '05';
                             rpmsales_o.doctype = 'Sales Invoice     05';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '06';
                             rpmsales_o.doctype = 'Sales Invoice     06';
                         when afko_i.akafat  = '07';
                             rpmsales_o.doctype = 'Sales Invoice     07';
       // 20.09.2019         rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '08';
                             rpmsales_o.doctype = 'Sales Invoice     08';
                         when afko_i.akafat  = '10';
                             rpmsales_o.doctype = 'Sales Invoice     10';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '25';
                             rpmsales_o.doctype = 'Sales Invoice     25';
                         when afko_i.akafat  = '26';
                             rpmsales_o.doctype = 'Sales Invoice     26';
                         when afko_i.akafat  = '27';
                             rpmsales_o.doctype = 'Sales Invoice     27';
                         when afko_i.akafat  = '28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = 'A28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '55';
                             rpmsales_o.doctype = 'Sales Invoice     55';
                         when afko_i.akafat  = '59';
                             rpmsales_o.doctype = 'Sales Invoice     59';
                         when afko_i.akafat  = 'A55';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'I28';
                             rpmsales_o.doctype = 'Sales Invoice     28';
                         when afko_i.akafat  = '54 ';
                             rpmsales_o.doctype = 'Sales Invoice     54';
                         when afko_i.akafat  = '54I';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '54S';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '510';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'N01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'B01';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = 'C03';
                             rpmsales_o.doctype = 'Sales Invoice       ';
                         when afko_i.akafat  = '83';
                             rpmsales_o.doctype = 'Sales Invoice     83';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '88';
                             rpmsales_o.doctype = 'Sales Invoice     88';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '31';
                             rpmsales_o.doctype = 'Sales Invoice     31';
                         when afko_i.akafat  = '11';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 11';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '14';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 14';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '15';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 15';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '16';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 16';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '17';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 17';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '18';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 18';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '20';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 20';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '44';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 44';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '50';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 50';
                             rpmsales_o.h4         = 'no upload';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '70';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 70';
       //                   Korrketur auf Menge,
       //                   hier dürfen keine Mengen in die Statistik
                             #aflpl1_i.alglmg   = #aflpl1_i.alglmg *0   ;
                         when afko_i.akafat  = '71';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 71';
       //                   Korrketur auf Menge,
       //                   negative Mengen für Statistik
       //                    #aflpl1_i.alglmg   = #aflpl1_i.alglmg * -1 ;
                         when afko_i.akafat  = '72';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 72';
                         when afko_i.akafat  = '81';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 81';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '82';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 82';
                             rpmsales_o.h4         = 'no upload';
                         when afko_i.akafat  = '99';
                             rpmsales_o.doctype = 'Sales CR/Adj Note 99';
                             rpmsales_o.h4         = 'no upload';
                         other;
                             rpmsales_o.division   = 'ERROR   ';
                             rpmsales_o.h4         = 'no upload';
                      endsl;
       //             rpmsales_o.RPMGROUP   = %subst(kdew_I.kDEWRPMG:2:2);
       //umstellung auf neues customer classification feld 06.11.21 SC
                      rpmsales_o.RPMGROUP   = %subst(kdew_I.KDEWFL03:1:20);
                      rpmsales_o.PLANKUNDE  = kdew_I.KDEWKDPL;
       //Achtung Fehlererkennung aus 22.03.2022
                      if     rpmsales_o.RPMGROUP   = *blank;
          //                 rpmsales_o.h4   = 'no upload';
                      endif;
       //KUEG
                      kueg_k.kefirm  =  kund_i.kdfirm;
                      kueg_k.kekdnr  =  kund_i.kdkdnr;

                      chain %kds(kueg_k:2) kueg01 kueg_I;
                      if %found(kueg01);
                         eval   rpmsales_o.VAT#   = kueg_I.KEUSTI;
                      else;
                         clear  rpmsales_o.VAT#;
                      endif;
       //TEEW
                      teew_k.teewfirm  =  afrp_i.rpfirm;
                      teew_k.teewtenr  =  afrp_i.rptenr;
                      chain %kds(teew_k:2) teew01 teew_I;
                      if %found(teew01);
                         rpmsales_o.APPRGR  = teew_i.TEEWPRGR;
                         exsr $$TEEWPRGR;
                         if rpmsales_o.ENTITY     = 'NL411' or
                            rpmsales_o.ENTITY     = 'BE111';
                            if rpmsales_o.APPRGR  = '749';
                               rpmsales_o.APPRGR  = '610';
                            endif;
                         endif;
                         if   $$TEEWPRGR_ ='0';
                            rpmsales_o.APPRGR  = *blank;
                         endif;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                         if rpmsales_o.APPRGR  = *blank;
       //                   rpmsales_o.h4   = 'no upload';
                         endif;
                      else;
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
                         rpmsales_o.APPRGR  = '000 ';
       //                rpmsales_o.h4   = 'no upload';
                      endif;
       //teil
                      teil_k.tefirm    =  afrp_i.rpfirm;
                      teil_k.tetenr    =  afrp_i.rptenr;
                      chain %kds(teil_k:2) teil01 teil_I;
                      if %found(teil01);
                         rpmsales_o.COST_UNIT  = teil_i.testpr*100;
                         rpmsales_o.TEPRGR     = teil_i.TEPRGR;
                         rpmsales_o.TEDIAV     = teil_i.TEDIAV;
                      else;
                         rpmsales_o.COST_UNIT  = *zero;
                         rpmsales_o.h4         = 'no upload';
                      endif;
       //output
                      rpmsales_o.POSTDATE   =
                         %char(%dec(%char(%date():*iso0):8:0));

                      rpmsales_o.COUNT_ISO  =  kund_i.kdpold;
                      rpmsales_o.ITEM       =  afrp_i.rptenr;
       //            keine Pfandwarenartikel
                      if  afrp_i.rptenr =     '8887100008' or
                          afrp_i.rptenr =     '8887100012' or
                          afrp_i.rptenr =     '8887100018' or
                          afrp_i.rptenr =     '8887100017' or
                          afrp_i.rptenr =     '8887100020' or
                          afrp_i.rptenr =     '8887100045' or
                          afrp_i.rptenr =     '8887100046' or
                          afrp_i.rptenr =     '8887100008-BE';
                         rpmsales_o.h4   = 'no upload';
                      endif;
                      rpmsales_o.ITEMDESC   =  #aflpL1_i.altbz1;
                      rpmsales_o.APGLMG     =  #aflpl1_i.alglmg;

                      §RKREDA    = afrk_i.rkreda;
                      §ENTRY#    = *blank;
                      exec sql
                        select char(days((date(substr(char(:§RKREDA), 1, 4)
                        concat '-'      concat substr(char(:§RKREDA), 5, 2)
                        concat '-'      concat substr(char(:§RKREDA), 7, 2)))))
                        into :§ENTRY#
                        from qsys2/qsqptabl;
                      rpmsales_o.ENTRY#     =  §ENTRY#;

       //             rpmsales_o.DOCTYPE
                      §rplipo = %EDITC(afrp_i.rplipo:'X');
       //             §rplipo = (%char(afrp_i.rplipo));
                      rpmsales_o.DOC        =  (%char(afrp_i.RPRGJJ)) + '/' +
                                                     (afrp_i.RPRGNR)  + '/' +
                                               (%char(afrp_i.rplijj)) + '/' +
                                                     (afrp_i.rplinr)  + '/' +
                                                            §rplipo   + '/' +
                                                     (afko_i.akafat)  + '/' +
                                                     (#aflpL1_i.allanr);
                      if rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                         rpmsales_o.DOC ='2018/400402/2018/500419/0001/A01/';
                      endif;
                      rpmsales_o.RKREDA     =  afrk_i.rkreda;
       //             rpmsales_o.COST_UNIT
       //            attention gross total!
                      rpmsales_o.RPNESU     =  afrp_i.RPBRSU*100;
                      rpmsales_o.I_RPNESU   =  afrp_i.RPBRSU*100;
                      rpmsales_o.RKWACD     =  afrk_i.rkwacd;
                      rpmsales_o.I_RKWACD   =  afrk_i.rkwacd;
       //             rpmsales_o.APPRGR
       //            attention ...........!
       //            in be111 und nl411 alle Gruppen korrekt !!! Nina
       //            in de117                                !!! Nina   20.09.2019
                      if teil_i.TEPRGR     >'900';
       //            Aufheben #INC-377803  or                !!! Nina   29.10.2026
       //                teil_i.TEPRGR     ='000' or
       //                rpmsales_o.APPRGR ='000';
                         If (rpmsales_o.ENTITY     = 'BE111' or
                             rpmsales_o.ENTITY     = 'NL411' or
                             rpmsales_o.ENTITY     = 'DE117');
                         else;
                            rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
                      if teil_i.TEPRGR     ='190' or
                         teil_i.TEPRGR     ='199' or
                         teil_i.TEPRGR     ='290' or
                         teil_i.TEPRGR     ='299' or
       //                teil_i.TEPRGR     ='390' or
                         teil_i.TEPRGR     ='399' or
                         teil_i.TEPRGR     ='490' or
                         teil_i.TEPRGR     ='491' or
                         teil_i.TEPRGR     ='499' or
                         teil_i.TEPRGR     ='590' or
                         teil_i.TEPRGR     ='599' or
                         teil_i.TEPRGR     ='690' or
                         teil_i.TEPRGR     ='699' or
                         teil_i.TEPRGR     ='790' or
                         teil_i.TEPRGR     ='799';
       //            in de117                                !!! Nina   20.09.2019
                         if  rpmsales_o.ENTITY   <> 'DE117';
       //            Aufheben #INC-377803                    !!! Nina   29.10.2026
       ////                 rpmsales_o.h4   = 'no upload';
                         endif;
                      endif;
       //             rpmsales_o.DIVISION
                      rpmsales_o.CUSTOMER#  =  kund_i.kdkdnr;
                      rpmsales_o.CUSTOMER   =  kund_i.KDNAM1;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDKNAM;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM2;
                      endif;
                      if  rpmsales_o.CUSTOMER = *blank;
                         rpmsales_o.CUSTOMER   =  kund_i.KDNAM3;
                      endif;
       //             rpmsales_o.RPMGROUP
       //             rpmsales_o.VAT#
       //             rpmsales_o.PLANKUNDE
       //             rpmsales_o.ABSATZAJ
       //             rpmsales_o.ABSATZVJ
       //             rpmsales_o.ABSATZVVJ
       //             rpmsales_o.ABSATZ_
                      rpmsales_o.AKFIRM     =  afko_i.AKFIRM;
                      rpmsales_o.AKAFJJ     =  afko_i.AKAFJJ;
                      rpmsales_o.AKAFNR     =  afko_i.AKAFNR;
                      rpmsales_o.AKAFAT     =  afko_i.AKAFAT;
                      rpmsales_o.ARTNR      =  *blank;
                      rpmsales_o.ARTSKU     =  *blank;
                      rpmsales_o.ARTBEZFRA  =  *blank;
                      rpmsales_o.ART        =  *blank;
                      exsr  $$LFS;
                      rpmsales_o.h1 = 'upload';
                      rpmsales_o.h2 = %date();
                      rpmsales_o.h3 = %timestamp();
                      rpmsales_o.h5 = %date();
                      rpmsales_o.h6 = %timestamp();

       //WAEH01      wenn Euro gefordert
                      if rpmsales_o.RKWACD    <> 'EUR' and
                         rpmsales_o.ENTITY    <> 'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'EUR';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;


       //WAEH01      wenn SEK  gefordert bei SE811
                      if rpmsales_o.RKWACD    =  'EUR' and
                         rpmsales_o.ENTITY    =  'SE811';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'EUR';
                         waeh_k.WAWACD  =  'SEK';
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM  and
                            waeh_i.WASTWC = 'EUR'              and
                            waeh_i.WAWACD = 'SEK';
                            rpmsales_o.RKWACD = 'SEK';
                            rpmsales_o.COST_UNIT=
       //MW 07.5.24           (rpmsales_o.COST_UNIT *waeh_i.wakurs);
                               (rpmsales_o.COST_UNIT / waeh_i.wakurs);
                            rpmsales_o.rpnesu=
       //MW 15.4.24           (rpmsales_o.rpnesu*waeh_i.wakurs);
                               (rpmsales_o.rpnesu / waeh_i.wakurs);
                       //   readp waeh01  waeh_i;
                            leave;
                         enddo;
                      endif;

       //WAEH01      wenn CHF  gefordert
                      if rpmsales_o.RKWACD    <> 'CHF' and
                         rpmsales_o.ENTITY    =  'CH412';
                         waeh_k.WAFIRM  =  rpm_load_i.RKFIRM;
                         waeh_k.WASTWC  =  'CHF';
                         waeh_k.WAWACD  =  rpmsales_o.RKWACD;
                         waeh_k.WAGADA  =  afrk_i.rkreda;
                         setgt %kds(WAEH_k:4) WAEH01;
                         readp waeh01  waeh_i;
                         dow not %eof(WAEH01)                  and
                            waeh_i.WAFIRM = rpm_load_i.RKFIRM and
                            waeh_i.WASTWC = 'CHF'             and
                            waeh_i.WAWACD = rpmsales_o.RKWACD;
                            rpmsales_o.RKWACD = 'CHF';
                            rpmsales_o.rpnesu=
                               (rpmsales_o.rpnesu*waeh_i.wakurs);
                            readp waeh01  waeh_i;
                         enddo;
                      endif;
                      rpmsales_o.h6 = %timestamp();

       //teos        Achtung evtl. sku-wechsel(!) in Verbindung mit
       //kalk_file2  wegen Lieferanten, die SKU Norm (!) verwenden
       //90025       DEFA ELTECH A.S  Ausnahmen
       //90489       DEFA Technology  "
       //90526       Tracer Products  "
                      teos_k.teosfirm =  afrp_i.rpfirm;
       //            TEOS immer mit Firma 01 lesen, nur diese wurden seinerseits eingetragen
       //            entspricht dem Feld ARTSKU
                      teos_k.teosfirm =  '01';
                      teos_k.TEOSKLCD =  'SKU ';
                      teos_k.TEOSTENR =  afrp_i.rptenr;
                      Kalk_k.version =  '$$EL_PS_DB';
                      Kalk_k.artnr    =  afrp_i.rptenr;
                      chain %kds(kalk_k:2) kalk_file2 kalk_I;
                      if %found(kalk_file2);
                         if (kalk_i.artsku > '9103560727'  and
                            %subst(kalk_i.artsku:1:5)='91035');
       //                  einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
                            eval kalk_i.lieferant1  =  '90484';
                         endif;
       //$RPMSALESM        90489 (DEFA Wuxi), 90025 is DEFA Norway       10.02.2020
                         if (kalk_i.artsku > '9600009999'  and
                             %subst(#aflpL1_i.altenr:1:1)='A') and
                            (kalk_i.lieferant1  =  '90489' or
                             kalk_i.lieferant1  =  '90025');
       //$RPMSALESM        einfach übersteuern !!!!!  '9103560820' stand 09.04.2019
       //$RPMSALESM        lesen für TEOS      !!!!!
                            eval kalk_i.lieferant1  =  '90000';
                         endif;
                         if kalk_i.lieferant1  <> '90025' and
                            kalk_i.lieferant1  <> '90484' and
                            kalk_i.lieferant1  <> '92678' and
                            kalk_i.lieferant1  <> '90526';
                            chain %kds(teos_k:3) teos01 teos_I;
                            if %found(teos01) and teos_i.TEOSMM01 <> *blank
                               and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  afrp_i.rptenr;
       //                     original aus TEOS         in rpmsales_o.ARTSKU
                               rpmsales_o.item       = teos_i.TEOSMM01;
                            endif;
       // start 25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            teew_k.teewfirm  =  #aflpL1_i.alFIRM;
                            teew_k.teewtenr  =  #aflpL1_i.altenr;
                            chain %kds(teew_k:2) teew01 teew_I;
                            if %found(teew01) and teew_i.TEEWSKUN <> *Blank
                                   and  %subst(teew_i.TEEWSKUN:01:03) <> '001';
                               rpmsales_o.item    = teew_i.TEEWSKUN;
                               rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
                            endif;
       // ende  25.02.2020 lesen jetzt über TEEW , da Pflege über Fachabteilungen
                            if  %subst(kalk_i.artbezfra:01:03) <> '001' and
                                %subst(kalk_i.artbezfra:01:03) <> *blank;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  afrp_i.rptenr;
       //                     original aus 2. Ableitung
                               rpmsales_o.item       = (kalk_i.artbezfra);
                               rpmsales_o.artbezfra  = (kalk_i.artbezfra);
                            endif;
                         endif;
                      else;
                      endif;

       //Schweizer Artikel nach NorthStarProject
                      if %subst(rpmsales_o.item:11:03) =  '-CH';
                         %subst(rpmsales_o.item:11:03)='   ';
                      endif;
       //itemsoem#   Achtung evtl. sku-wechsel(!) in China für OEM
                      itemsoem#l_k.item    =  afrp_i.rptenr;
                      chain %kds(itemsoem#l_k:1) itemsoem#l  itemsoem#l_i;
                      if %found(itemsoem#l);
                         if itemsoem#l_I.cheng <> *blank;
       ///////!!!   and     itemsoem#l_I.cheng <> itemsoem#l_i.item;
       //                   itemsoem#l_I.item  <> rpmsales_o.ARTNR;
       //                     original aus Lieferschein in rpmsales_o.ARTNR
                               rpmsales_o.ARTNR      =  afrp_i.rptenr;
       //                     original aus China
                               rpmsales_o.item       =  itemsoem#l_I.cheng;
                               rpmsales_o.artbezfra  = 'CHENG OEM';
                         endif;
                      else;
                      endif;

       //    Achtung 20 murcks bei Integration Ezetil !!!! 20180318
                      if kund_i.kdfirm = '20';
                         teos_k.teosfirm =  '20';
                         teos_k.TEOSKLCD =  'SKU ';
                         teos_k.TEOSTENR =  rpmsales_o.item;
                         chain %kds(teos_k:3) teos01 teos_I;
                         if %found(teos01) and teos_i.TEOSMM01 <> *blank
                            and teos_i.TEOSMM01 <> rpmsales_o.item;
       //                  original aus Lieferschein in rpmsales_o.ARTNR
                            rpmsales_o.ARTNR      =  #aflpL1_i.altenr;
       //                  original aus TEOS         in rpmsales_o.ARTSKU
                            rpmsales_o.item       = teos_i.TEOSMM01;
                         endif;
                      endif;

                      §search              = ';';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = ',';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '"';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

                      §search              = '`';
                      §string              = rpmsales_o.ITEMDESC;
                      §replace             = ' ';
                      §pos                 = 0 ;
                      exsr      scanstr;
                      rpmsales_o.ITEMDESC  = §string;

       //             %scan(''':String);
                      rpmsales_o.ITEM       =  #aflpL1_i.altenr;  // 20240304 übersteuert
       //Schweizer Artikel nach NorthStarProject                 // 20240304 übersteuert
                      if %subst(rpmsales_o.item:11:03) =  '-CH';  // 20240304 übersteuert
                         %subst(rpmsales_o.item:11:03)='   ';     // 20240304 übersteuert
                      endif;                                      // 20240304 übersteuert
                      exsr statistik;
                      rpmsales_o.h1 = 'Rounding  ';
                      rpmsales_o.h4 = 'no upload';
                      write rpmsalesr  rpmsales_o;
       //             clear            rpmsales_o;
                   else;
                      rpmsales_o.h4         = 'no upload';
                      eval status ='Kundendaten für rpm fehlen in KDEW ' +
                            afrk_i.RKFIRM  +
                            afrk_i.RKkdnr  ;
                      exsr      SR_log;
                   endif;
                else;
                   rpmsales_o.h4         = 'no upload';
                   eval status ='Kunde fehlt aus Rechnungslauf in KUND ' +
                               afrk_i.RKFIRM  +
                               afrk_i.RKkdnr  ;
                   exsr      SR_log;
                endif;
             else;
                rpmsales_o.h4         = 'no upload';
                eval status ='keine Positionen zum Lieferschein' +
                                  afrk_k.RKFIRM         +
                            %char(afrk_k.RKRGJJ)        +
                                  afrk_k.RKRGNR         +
                            %char(afrk_k.RKLIJJ)        +
                                 (afrk_k.RKLINR)        +
                            %char(#aflpL1_i.allipo);
                exsr      SR_log;
             endif;

       endsr;


       //-----------------------------------------------------------------------
       //Grunddaten aus LFS
       //-----------------------------------------------------------------------

       begsr $$LFS;

             if #aflpL1_i.ALfirm = '01';
                      if %found(teil01);
                           %subst(rpmsales_o.ART:01:06) =
                           %subst(teil_i.testlf:01:06);
                      endif;
                      %subst(rpmsales_o.ART:11:03) =
                      %subst(#aflpL1_i.ALVSBD:01:03);

                      PANFPOSL51_K.APKONZ = 'EMS';
                      PANFPOSL51_K.APFIRM = 'DWI';
                      PANFPOSL51_K.APANR1 = 'K01' +
                                            %char(#aflpL1_i.ALKMJJ)+
                                            #aflpL1_i.ALKMNR;
                      setgt %kds(PANFPOSL51_k:3) PANFPOSL51;
                      readp PANFPOSL51 PANFPOSL51_i;
                      dow not %eof(PANFPOSL51)              and
                          PANFPOSL51_i.APKONZ = 'EMS'       and
                          PANFPOSL51_i.APFIRM = 'DWI'       and
                          PANFPOSL51_i.APANR1 = 'K01' +
                               %char(#aflpL1_i.ALKMJJ)+
                                     #aflpL1_i.ALKMNR;
                          if PANFPOSL51_I.APANRP = #aflpL1_i.ALKMPO;
                              %subst(rpmsales_o.ART:07:04) =
                              %subst(PANFPOSL51_I.APSTEU:01:04);
                              %subst(rpmsales_o.ART:11:04) =
                              %subst(PANFPOSL51_I.APVART:01:04);
                              %subst(rpmsales_o.ARTSKU:12:04) =
                              %subst(PANFPOSL51_I.aptour:01:04);
                          else;
                          endif;
                          readp PANFPOSL51 PANFPOSL51_i;
                      enddo;


                      PSAVEAPL51_K.APKONZ = 'EMS';
                      PSAVEAPL51_K.APFIRM = 'DWI';
                      PSAVEAPL51_K.APANR1 = 'K01' +
                                            %char(#aflpL1_i.ALKMJJ)+
                                            #aflpL1_i.ALKMNR;
                      setgt %kds(PSAVEAPL51_k:3) PSAVEAPL51;
                      readp PSAVEAPL51 PSAVEAPL51_i;
                      dow not %eof(PSAVEAPL51)              and
                          PSAVEAPL51_i.APKONZ = 'EMS'       and
                          PSAVEAPL51_i.APFIRM = 'DWI'       and
                          PSAVEAPL51_i.APANR1 = 'K01' +
                               %char(#aflpL1_i.ALKMJJ)+
                                     #aflpL1_i.ALKMNR;
                          if PSAVEAPL51_I.APANRP = #aflpL1_i.ALKMPO;
                              %subst(rpmsales_o.ART:07:04) =
                              %subst(PSAVEAPL51_I.APSTEU:01:04);
                              %subst(rpmsales_o.ART:11:04) =
                              %subst(PSAVEAPL51_I.APVART:01:04);
                              %subst(rpmsales_o.ARTSKU:12:04) =
                              %subst(PSAVEAPL51_I.aptour:01:04);
                          else;
                          endif;
                          readp PSAVEAPL51 PSAVEAPL51_i;
                      enddo;
             endif;

       endsr;
       // ______________________________________________________________________


       //-----------------------------------------------------------------------
       //Grunddaten prüfen in $$TEEWPRGR Domeic Group Definition level item
       //-----------------------------------------------------------------------

       begsr $$TEEWPRGR;

          trtp_k.tpfirm  =  rpm_load_i.RKFIRM;
          trtp_k.TPSPCD  =  'D';
          trtp_k.TPTART  =  '$$TEEWPRGR';
          trtp_k.TPTCDE  =  teew_i.TEEWPRGR;

       //trtp
          chain %kds(trtp_k:4) trtp01 trtp_I;
          if %found(trtp01);
             $$TEEWPRGR_ ='1';
          else;
             $$TEEWPRGR_ ='0';
          endif;

       endsr;
       // ______________________________________________________________________

       //-----------------------------------------------------------------------
       //Umsatzrelevante Wert
       //-----------------------------------------------------------------------

       begsr SR_umsa;

       // ______________________________________________________________________
         // lesen absatz/umsatz               APKDNR, JAHR

       if  %subst(kund_i.kdfirm:1:2) = '01';
          years = %subdt( %date(): *years );
          absatzb4l1_k.apkdnr  =  kund_i.kdkdnr;
          setll %kds(absatzb4l1_k:1) absatzb4l1;
          reade %kds(absatzb4l1_k:1) absatzb4l1  absatzb4l1_i;
          dow not %eof(absatzb4l1);
             select;
                when absatzb4l1_i.Jahr =      %char(years);
                     rpmsales_o.ABSATZAJ   = rpmsales_o.ABSATZAJ  +
                                              absatzb4l1_i.to;
                when absatzb4l1_i.Jahr =      %char(years -1);
                     rpmsales_o.ABSATZVJ   = rpmsales_o.ABSATZVJ  +
                                              absatzb4l1_i.to;
                when absatzb4l1_i.Jahr =      %char(years -2);
                     rpmsales_o.ABSATZVVJ  = rpmsales_o.ABSATZVVJ +
                                              absatzb4l1_i.to;
                other;
                     rpmsales_o.ABSATZ_    = rpmsales_o.ABSATZ_   +
                                              absatzb4l1_i.to;
             endsl;
             reade %kds(absatzb4l1_k:1) absatzb4l1  absatzb4l1_i;
          enddo;
       endif;


       if  %subst(kund_i.kdfirm:1:2) <> '01';
          years = %subdt( %date(): *years );
          absatzb4#l_k.akfirm  =  kund_i.kdfirm;
          absatzb4#l_k.apkdnr  =  kund_i.kdkdnr;
          setll %kds(absatzb4#l_k:2) absatzb4#l;
          reade %kds(absatzb4#l_k:2) absatzb4#l  absatzb4#l_i;
          dow not %eof(absatzb4#l);
                if  kund_i.kdkdnr  ='05089';
                   clear     breakpoint;
                endif;
             select;
                when absatzb4#l_i.Jahr =      %char(years);
                     rpmsales_o.ABSATZAJ   = rpmsales_o.ABSATZAJ  +
                                              absatzb4#l_i.to;
                when absatzb4#l_i.Jahr =      %char(years -1);
                     rpmsales_o.ABSATZVJ   = rpmsales_o.ABSATZVJ  +
                                              absatzb4#l_i.to;
                when absatzb4#l_i.Jahr =      %char(years -2);
                     rpmsales_o.ABSATZVVJ  = rpmsales_o.ABSATZVVJ +
                                              absatzb4#l_i.to;
                other;
                     rpmsales_o.ABSATZ_    = rpmsales_o.ABSATZ_   +
                                              absatzb4#l_i.to;
             endsl;
             reade %kds(absatzb4#l_k:2) absatzb4#l  absatzb4#l_i;
          enddo;
       endif;
       // ______________________________________________________________________

       endsr;

       //-----------------------------------------------------------------------
       //Statistik
       //-----------------------------------------------------------------------

       begsr statistik;


          rpmsales_o.j01     = %dec(%subst(%char(afrk_i.rkreda):1:4):4:0);
          §monat             = %dec(%subst(%char(afrk_i.rkreda):5:2):2:0);
          select;
             when §monat  = 01;
                  rpmsales_o.a01        = #aflpl1_i.alglmg;
                  rpmsales_o.u01        = rpmsales_o.rpnesu /100;
             when §monat  = 02;
                  rpmsales_o.a02        = #aflpl1_i.alglmg;
                  rpmsales_o.u02        = rpmsales_o.rpnesu /100;
             when §monat  = 03;
                  rpmsales_o.a03        = #aflpl1_i.alglmg;
                  rpmsales_o.u03        = rpmsales_o.rpnesu /100;
       //
             when §monat  = 04;
                  rpmsales_o.a04        = #aflpl1_i.alglmg;
                  rpmsales_o.u04        = rpmsales_o.rpnesu /100;
             when §monat  = 05;
                  rpmsales_o.a05        = #aflpl1_i.alglmg;
                  rpmsales_o.u05        = rpmsales_o.rpnesu /100;
             when §monat  = 06;
                  rpmsales_o.a06        = #aflpl1_i.alglmg;
                  rpmsales_o.u06        = rpmsales_o.rpnesu /100;
       //
             when §monat  = 07;
                  rpmsales_o.a07        = #aflpl1_i.alglmg;
                  rpmsales_o.u07        = rpmsales_o.rpnesu /100;
             when §monat  = 08;
                  rpmsales_o.a08        = #aflpl1_i.alglmg;
                  rpmsales_o.u08        = rpmsales_o.rpnesu /100;
             when §monat  = 09;
                  rpmsales_o.a09        = #aflpl1_i.alglmg;
                  rpmsales_o.u09        = rpmsales_o.rpnesu /100;
       //
             when §monat  = 10;
                  rpmsales_o.a10        = #aflpl1_i.alglmg;
                  rpmsales_o.u10        = rpmsales_o.rpnesu /100;
             when §monat  = 11;
                  rpmsales_o.a11        = #aflpl1_i.alglmg;
                  rpmsales_o.u11        = rpmsales_o.rpnesu /100;
             when §monat  = 12;
                  rpmsales_o.a12        = #aflpl1_i.alglmg;
                  rpmsales_o.u12        = rpmsales_o.rpnesu /100;
             other;
          endsl;

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
       //Statistik
       //AKAFAT not in ('30', '31', '41', '77', '88', '99',
       //              '10', '11', '14', '15', '82', '17', '18', '20')
       //nicht in Absatz/Umsatz
       //-----------------------------------------------------------------------

       begsr statistik2;

       exec sql
        insert into tvrelwaeco/RPMitem
        SELECT ENTITY,J01, ITEM, ITEMDESC,
               dec(sum(APGLMG), 13, 2) T_Absatz,
        dec(sum(RPNESU/100), 13, 2) T_umsatz,
        dec(sum(a01), 13, 2) jana, dec(sum(a02), 13, 2) feba,
        dec(sum(a03), 13, 2) maea, dec(sum(a04), 13, 2) apra,
        dec(sum(a05), 13, 2) maia, dec(sum(a06), 13, 2) juna,
        dec(sum(a07), 13, 2) jula, dec(sum(a08), 13, 2) auga,
        dec(sum(a09), 13, 2) sepa, dec(sum(a10), 13, 2) okta,
        dec(sum(a11), 13, 2) nova, dec(sum(a12), 13, 2) deza,
        dec(sum(u01), 13, 2) janu, dec(sum(u02), 13, 2) febu,
        dec(sum(u03), 13, 2) maeu, dec(sum(u04), 13, 2) apru,
        dec(sum(u05), 13, 2) maiu, dec(sum(u06), 13, 2) junu,
        dec(sum(u07), 13, 2) julu, dec(sum(u08), 13, 2) augu,
        dec(sum(u09), 13, 2) sepu, dec(sum(u10), 13, 2) oktu,
        dec(sum(u11), 13, 2) novu, dec(sum(u12), 13, 2) dezu,
        current timestamp tstamp
        FROM rpmsales# WHERE
             AKAFAT not in ('10','11','14','15','17','18','20',
                            '30','31','41','77','82','88','89')
             and not (h1 = 'supplement' and H4 <> 'upload' )
             and not (h1 = 'sub_item  ' and H4 <> 'upload' )
        GROUP BY entity, J01,ITEM,ITEMDESC;

       //sql handling
            exec sql
                     whenever not found CONTINUE;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;


       exec sql
        insert into tvrelwaeco/RPMcust
        SELECT ENTITY, j01, ITEM, ITEMDESC, CUSTOMER#, CUSTOMER,
        dec(sum(APGLMG), 13, 2) T_Absatz,
        dec(sum(RPNESU/100), 13, 2) T_umsatz,
        dec(sum(a01), 13, 2) jana, dec(sum(a02), 13, 2) feba,
        dec(sum(a03), 13, 2) maea, dec(sum(a04), 13, 2) apra,
        dec(sum(a05), 13, 2) maia, dec(sum(a06), 13, 2) juna,
        dec(sum(a07), 13, 2) jula, dec(sum(a08), 13, 2) auga,
        dec(sum(a09), 13, 2) sepa, dec(sum(a10), 13, 2) okta,
        dec(sum(a11), 13, 2) nova, dec(sum(a12), 13, 2) deza,
        dec(sum(u01), 13, 2) janu, dec(sum(u02), 13, 2) febu,
        dec(sum(u03), 13, 2) maeu, dec(sum(u04), 13, 2) apru,
        dec(sum(u05), 13, 2) maiu, dec(sum(u06), 13, 2) junu,
        dec(sum(u07), 13, 2) julu, dec(sum(u08), 13, 2) augu,
        dec(sum(u09), 13, 2) sepu, dec(sum(u10), 13, 2) oktu,
        dec(sum(u11), 13, 2) novu, dec(sum(u12), 13, 2) dezu,
        current timestamp tstamp
        FROM rpmsales# WHERE
             AKAFAT not in ('10','11','14','15','17','18','20',
                            '30','31','41','77','82','88','89')
             and not (h1 = 'supplement' and H4 <> 'upload' )
             and not (h1 = 'sub_item  ' and H4 <> 'upload' )
        GROUP BY entity, j01,ITEM, ITEMDESC,CUSTOMER#, CUSTOMER;

       //                    h1 <> 'supplement' and
       //                    h1 <> 'sub_items ' and
       //    and h6 > current timestamp -10 minutes


       //sql handling
            exec sql
                     whenever not found CONTINUE;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;
       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;

       //Ausgabe der einzelnen Files über variable
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6710';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'RPMS'         +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export Datei vorher vom Inhalt löschen
         MONITOR;
            Wrk.var1 =
                'clrpfm file(TVRELWAECO/'+ p_outfil +')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error clrpfm file ' +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval p_outfil  =  'RPMS'         +
                            suffix;

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
         eval p_md      =  suffix;

         eval p_msg     =  '#DC6710';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'RPMS'         +
                            suffix;
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:    p_print:
                        p_outfil: p_lib:    p_repadd);

         eval  transfer =  %trimr(suffix) +'-'                   +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.csv';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export in Übertragungsdatei
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/RPMII4_OUT RPMII4_OUT) '+
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

         eval p_outfil  =  'RPMS'         +
                            suffix;
         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from RPMII4_OUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(RPMSALESC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  'RPMS'         +
                               suffix;
            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(RPMSALESL)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO/FTP)';
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



            eval p_outfil  =  'RPMS'         +
                               suffix;
       //   clear  string_file;
       //   eval   string_file = 'APPEND ' +
       //                        'RPMS'    +
       //                        %trimr(suffix) + ' ' +
       //                        transfer;

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'RPMII4_OUT ' +
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
               status='error ftp.seit.dometic.com '    +
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
               eval p_outfil  =  'RPMS'         +
                                 suffix;
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


