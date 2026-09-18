
      //************************************************************************
      //
      //      Programmname       job_r
      //      Erstellt  am       30.06.2016
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       ...
      //      $INTERFACE   #RGZ_C  Protokollbereinigungen
      // ----------------------------------+------------------------------------
      // Geändert am K+rzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // ébersetzungshinweise:
      // CALL PGM(GANG/#CHGPFM) PARM('JOB_R' 'qrpglesrc' 'TVRELWAECO' '25')
      // Hinweis Dimitri: DOMDATV7 und die BAR_KALK
      //
      //
      // SELECT WAOFVEUR item, artbez descrip, char(ID_ART, 5) prodType,
      // char(statnr, 5) prodGroup , char(artgrp, 5) prodcateg, char(' ', 2)
      // salesunit, STK3_FIX , ARTSTATUS artstatus, dec(0, 8, 0) datemove,
      // dec(0, 8, 0) datebuy FROM RPMKALKUL WHERE statnr in ('299', '299',
      // '399', '499', '699', '190', '490', '491', '499')
      // Datei DATABASE1 in TVRELWAECO wurde erstellt.
      //
      // update database1 set salesunit =
      //  (select TEMPEK# from bar_kalk/kalk_file
      //  WHERE version='$$EL_PS_DB' and artnr=item)
      // where exists
      //  (select TEMPEK# from bar_kalk/kalk_file
      //  WHERE version='$$EL_PS_DB' and artnr=item)
      //
      //
      //  SELECT char (aKFIRM concat AKAFJJ concat AKAFNR concat ' ' concat
      //  doc, 45 ) orderline , ITEM, APGLMG , RKREDA, char('DE411 ', 6)
      //  stock FROM rpmsales# WHERE TEPRGR in ('299', '299', '399', '499',
      //  '699', '190', '490', '491', '499')
      //  Datei DATABASE3 in TVRELWAECO wurde erstellt.
      //
      //  update database1 a set datemove   =
      //   (select max(rkreda) from DATABASE3 b
      //   WHERE a.item=b.item and substr(orderline, 01, 02) ='01'
      //   group by b.item)
      //  where exists
      //   (select max(rkreda) from DATABASE3 b
      //   WHERE a.item=b.item and substr(orderline, 01, 02) ='01'
      //    group by b.item)
      //  2183 Zeilen in DATABASE1 in TVRELWAECO aktualisiert.
      //
      // update database1 a set datebuy    =
      //  (select max(LBLBBDAT) from lblb01    b
      //  WHERE a.item=b.LBLBTENR and LBLBFIRM='01'
      //  and lblblstc='825' group by b.LBLBTENR)
      // where exists
      //  (select max(LBLBBDAT) from lblb01    b
      //  WHERE a.item=b.LBLBTENR and LBLBFIRM='01'
      //  and lblblstc='825' group by b.LBLBTENR)
      //  8927 Zeilen in DATABASE1 in TVRELWAECO aktualisiert.
      //
      //
      //  insert into database2
      //  SELECT BMIDEN item ,BMBMEN onstock, char(bmort concat bmber concat
      //  digits(BMGANG) concat digits(BMREG) concat digits(BMHOR) concat
      //  digits(BMver) concat digits(BMSEGM) concat digits(BMCELL) concat
      //  digits(BMSEGM) concat bmlm, 35) location,
      //                                 char(bmlm, 20) zone FROM
      //  domdatv7/PBESTLO where bmiden in ( select artnr from
      //  bar_kalk/kalk_file where version='$$EL_PS_DB' and
      //  statnr in ('299', '299',
      //             '399', '499', '699', '190', '490', '491', '499'))
      //
      //  exec sql
      //     update TVRELWAECO/database2  set ZONE      = case
      //     When ZONE     = '          ' then 'Floor     '
      //     When ZONE     = 'GB        ' then 'OUTSIDE   '
      //     When ZONE     = '108       ' then 'Pallet    '
      //     When ZONE     = '112       ' then 'Pallet    '
      //     When ZONE     = '116       ' then 'Pallet    '
      //     When ZONE     = '122       ' then 'Pallet    '
      //     When ZONE     = '212       ' then 'Pallet    '
      //     When ZONE     = '216       ' then 'Pallet    '
      //     When ZONE     = '222       ' then 'Pallet    '
      //     When ZONE     = '235       ' then 'Pallet    '
      //     When ZONE     = '236       ' then 'Pallet    '
      //     When ZONE     = '302       ' then 'SHELVES   '
      //     When ZONE     = '600       ' then 'Pallets   '
      //     else 'undefined'
      //     end
      //
      //     nina 01.02.2018 stklcp für comany
      //
      // CALL PGM(DELIVERYRA) PARM('054939')
      // SELECT char('61', 2) cc, item, ICS_2 , ITEM , PRICEGROUP, current
      // timestamp tstamp FROM itemserv WHERE PRICEGROUP in ( select kdkdgr
      // from kund01 where kdfirm='01' and KDKDNR ='054939')
      // Datei IC_STKLCP in TVRELWAECO wurde erstellt.
      //
      // CALL PGM(DELIVERYRA) PARM('098848')
      // insert into tvrelwaeco/IC_STKLCP
      // SELECT char('20', 2) cc, item, ICS_2 , ITEM , PRICEGROUP, current
      // timestamp tstamp FROM itemserv WHERE PRICEGROUP in ( select kdkdgr
      // from kund01 where kdfirm='01' and KDKDNR ='098848')
      //
      // CALL PGM(DELIVERYRA) PARM('002921')
      // insert into tvrelwaeco/IC_STKLCP
      // SELECT char('55', 2) cc, item, ICS_2 , ITEM , PRICEGROUP, current
      // timestamp tstamp FROM itemserv WHERE PRICEGROUP in ( select kdkdgr
      // from kund01 where kdfirm='01' and KDKDNR ='002921')
      //
      // update  teil01 set testda=20180130, TESTPR=
      // (select ICS_2    from IC_STKLCP
      //  WHERE tefirm = cc and tetenr=item
      //        and ICS_2 > 0)
      // where exists
      // (select ICS_2    from IC_STKLCP
      //  WHERE tefirm = cc and tetenr=item
      //        and ICS_2 > 0)
      //
      //
      //
      //
      //
      //   OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) MBR(RPMSALESL)
      //   sql
      //   DLTOVR FILE(INPUT)
      //   select *  from   rhgefahrn
      //         inner join  domdatv7/ppaket
      //         on rgtenr = pkiden
      //         left outer join teil01
      //         on tefirm=rgfirm and tetenr =rgtenr
      //         where pkpknr > 101437860
      //
      //
      // SELECT APKMTE, zoned($YEAR*10000+ $month*100+ $day, 8, 0) x,$date,
      // (date(substr((APKMTE), 1, 4) concat '-' concat
      //       substr((APKMTE), 5, 2) concat '-' concat
      //       substr((APKMTE), 7, 2)  ) +7 days )newkom,
      // zoned(('20') concat
      // substr(char($date +7 day), 7, 2)  concat
      // substr(char($date +7 day), 4, 2)  concat
      // substr(char($date +7 day), 1, 2), 8, 0)   newkom2
      // FROM calenderl1 ,afpo01
      // where APFIRM='01' and APAFJJ=2018 and APAFNR in ('659964') and
      //       $date > (date(substr((APKMTE), 1, 4) concat '-' concat
      //                     substr((APKMTE), 5, 2) concat '-' concat
      //                     substr((APKMTE), 7, 2)  ) +7 days )  and
      //                     DE  <> 1                             and
      //       $NAMEDAY <> 'Samstag' and $NAMEDAY <> 'Sonntag'
      // ORDER BY $DATE
      // limit 1
      //
      //  SELECT STATNR ,TEEWPRGR,ARTGRP, #TESAAV, #TEDIAV, count(*) FROM
      //  bar_kalk/kalk_file, teew01 WHERE version='$$EL_PS_DB' and
      //  KALK_FILE.ARTNR =TEEWTENR and TEEWFIRM='01' GROUP BY STATNR
      //  ,TEEWPRGR,ARTGRP, #TESAAV, #TEDIAV ORDER BY STATNR
      //  ,TEEWPRGR,ARTGRP, #TESAAV, #TEDIAV
      //
      //
       //prüfen der Objekte, Objekte in der Ausnahmeliste wurden inhaltlich gelòscht
       //bis auf TSTDATV7 in QGPL
      //  SELECT * FROM TVRELWAECO/#OBJEKTE WHERE ((ODDDAT =300919 or ODDDAT
      //  =310819 ) and ODOBTP ='*FILE') or ODOBNM in ('TRANSFERP#',
      //  'LFS_INPUT', 'DB_TWO_PE#', 'TSTDATV7', 'Z', 'RPMSALES#S',
      //  'RPMIIUPLO#') ORDER BY ODOBSZ,ODOBNM, ODLBNM
      //
      //  update  teil01 set testda=20200803, TESTPR=
      //  (select round((ics_2*1,08), 3) from itemserv
      //   WHERE tefirm = 55 and tetenr=item
      //         and ICS_2 > 0 and PRICEGROUP ='173')
      //  where exists
      //  (select round((ics_2*1,08), 3) from itemserv
      //   WHERE tefirm = 55 and tetenr=item
      //         and ICS_2 > 0 and PRICEGROUP ='173')
      //  5782 Zeilen in TEIL01 in TVPF aktualisiert.
      //
      //  update  teil01 set testda=20200911, TESTPR=
      //  (select round((ics_2*1,00), 3) from itemserv
      //   WHERE tefirm = 08 and tetenr=item
      //         and ICS_2 > 0 and PRICEGROUP ='173')
      //  where exists
      //  (select round((ics_2*1,00), 3) from itemserv
      //   WHERE tefirm = 08 and tetenr=item
      //         and ICS_2 > 0 and PRICEGROUP ='173')
      //  6165 Zeilen in TEIL01 in TVPF aktualisiert.
      //
      //
      // Referenzsatz
      //
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
     h dftactgrp(*NO) actgrp(*CALLER)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     f#NetServerIf   e             DISK    RENAME(#NETSERVER:PHY01R)
     f                                     USROPN
     fPANFKOP   uf   e             DISK    RENAME(PANFKOPf:PHY02R)
     f                                     USROPN
     fCalenderl1If   e           k DISK    RENAME(calender:PHY03R)
     f                                     USROPN
     fKomDatEL  uf   e             DISK    RENAME(KomDatEL:PHY04R)
     f                                     USROPN
     fAFPO01    uf   e           k DISK    RENAME(afpo1:PHY05R)
     f                                     USROPN
     fpanftxt   uf   e             DISK    RENAME(panftxtf:PHY06R)
     f                                     USROPN

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
       // Sicherung pbestlo
       // ______________________________________________________________________
     d PBESTLO_R       PR                  ExtPgm('PBESTLO_R')
       // ______________________________________________________________________
       // Intercompany Purchase orders EMEA to APAC( in Job PBESTLO-R Routine)
       // ______________________________________________________________________
     d INTERCOMP2      PR                  ExtPgm('INTERCOMP2')
       // ______________________________________________________________________
       // Abgleich
       // ______________________________________________________________________
     d SWAPC           PR                  ExtPgm('SWAPC')
       // ______________________________________________________________________
       // STK3ébergabe und Ausgabe in Verzeichnis
       // ______________________________________________________________________
     d RPMIISTK3R      PR                  ExtPgm('RPMIISTK3R')
     d for_run                        6a
       // ______________________________________________________________________
       // Stücklistenbereinigung
       // ______________________________________________________________________
     d STUECKL_R       PR                  ExtPgm('STUECKL_R')
       // ______________________________________________________________________
       // Stücklistenbereinigung
       // ______________________________________________________________________
     d BACKORDERS      PR                  ExtPgm('BACKORDERS')
       // ______________________________________________________________________
       // userprofiles für NetServer freigeben
       // ______________________________________________________________________
     d $QZLSCHSI       PR                  ExtPgm('$QZLSCHSI')
     d f#NetUser                     10a
       // ______________________________________________________________________
       // TRSP18CL maildaten mit Lieferschein ausgeben
       // ______________________________________________________________________
     D TRSP18CL        PR                  ExtPgm('TRSP18CL')
     D mailfile                      10a
       // ______________________________________________________________________
       // TRED80SJ Übernahme EDI Orders nach TREND IF
       // ______________________________________________________________________
     D TRED80SJ        PR                  ExtPgm('TRED80SJ')
     D system_e                      10a
     D mandant_e                      2a
       // ______________________________________________________________________
       // Spools kontrolliert löschen
       // ______________________________________________________________________
     d WATCHSPL1       PR                  ExtPgm('WATCHSPL1')
       // ______________________________________________________________________
       // objekte abgleichen
       // ______________________________________________________________________
     d #OBJEKTE        PR                  ExtPgm('#OBJEKTE')
       // ______________________________________________________________________
       // TRIFWE01 maildaten mit Lieferschein ausgeben
       // ______________________________________________________________________
     D TRIFWE01        PR                  ExtPgm('TRIFWE01')
       // ______________________________________________________________________
       // TRIFWE01 maildaten mit Lieferschein ausgeben
       // ______________________________________________________________________
     D ABSATZ2C        PR                  ExtPgm('ABSATZ2C')
       // ______________________________________________________________________
       // FTP-Bankdaten
       // ______________________________________________________________________
     d BANKFTP         PR                  ExtPgm('BANKFTP')
       // ______________________________________________________________________
       // TRACKINGR
       // ______________________________________________________________________
     d TRACKINGR       PR                  ExtPgm('TRACKINGR')
       // ______________________________________________________________________
     D LP1OUTPUTR      PR                  ExtPgm('LP1OUTPUTR')
       // LP1OUTPUTR LP1 Preise ermitteln letzten 365 Tage
       // ______________________________________________________________________
       // WERKSWITCH  ==> fktwrkswt
       // ______________________________________________________________________
     d WERKSWITCH      PR                  ExtPgm('WERKSWITCH')
       // ______________________________________________________________________
       // ______________________________________________________________________
       // SANKTION2R  ==> fktsankti2
       // ______________________________________________________________________
     d SANKTION2R      PR                  ExtPgm('SANKTION2R')
       // ______________________________________________________________________
       //           ... Grunddaten
       // ______________________________________________________________________
       // define data areas
       // ______________________________________________________________________
     D #swapc          s             08a   dtaara
     D JOB_R_run       s             01a   dtaara

       // ______________________________________________________________________
       // define files
       // ______________________________________________________________________
     d #NetServer_i  E DS                  ExtName(#NetServer:*input)
     d                                     Qualified
     d PANFKOP_i     E DS                  ExtName(PANFKOP:*input)
     d                                     Qualified
     d PANFKOP_o     E DS                  ExtName(PANFKOP:*output)
     d                                     Qualified
     d Calender_i    E DS                  ExtName(Calenderl1:*input)
     d                                     Qualified
     d Calender_k    E DS                  ExtName(Calenderl1:*key)
     d                                     Qualified
     d KomDatEL_i    E DS                  ExtName(KomDatEL:*input)
     d                                     Qualified
     d KomDatEL_o    E DS                  ExtName(KomDatEL:*output)
     d                                     Qualified
     d afpo01_k      E DS                  ExtName(afpo01:*key)
     d                                     Qualified
     d afpo01_I      E DS                  ExtName(afpo01:*input)
     d                                     Qualified
     d afpo01_o      E DS                  ExtName(afpo01:*output)
     d                                     Qualified
     d panftxt_i     E DS                  ExtName(panftxt:*input)
     d                                     Qualified
     d panftxt_o     E DS                  ExtName(panftxt:*output)
     d                                     Qualified

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
     D §x              s              8s 0 inz

      // qmhsndpm
      // ______________________________________________________________________
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz

      // for_run
      //------------------------------------------------------------------------
     D for_run         s              6a   inz

      // $QZLSCHSI
      //------------------------------------------------------------------------

       // ______________________________________________________________________
       // TRSP18CL maildaten mit Lieferschein ausgeben
       // ______________________________________________________________________
     D mailfile        s             10a   inz

       // ______________________________________________________________________
       // TRED80SJ Übernahme EDI Orders nach TREND IF
       // ______________________________________________________________________
     D system_e        s             10a
     D mandant_e       s              2a

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D err_msg         s              1a   inz
     D #error          s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz
     D #run            s              1a   inz
     D #dirmail        s              1a   inz
     D checkd          s              8s 0 inz
     D checkx          s              8s 0 inz
     D p               s             15p 0
     D update#         s              1a   inz
     D upderr#         s              1a   inz
     D §success        s              1s 0 inz

       //fkt_ Funktionsbereiche
     D fkt             s             12a   inz
     D fktpbestlo      s              1a   inz
     D fktswapc        s              1a   inz
     D fktlag_bst      s              1a   inz
     D fkttrigger      s              1a   inz
     D fktstk3kal      s              1a   inz
     D fktrpmsale      s              1a   inz
     D fktritemq       s              1a   inz
     D fktropenor      s              1a   inz
     D fktqm_items     s              1a   inz
     D fktstueckl      s              1a   inz
     D fktediKund      s              1a   inz
     D fktQZLSCHSI     s              1a   inz
     D fkttrmail       s              1a   inz
     D fktavailab      s              1a   inz
     D fktprj015p      s              1a   inz
     D fktbackord      s              1a   inz
     D fktedccall      s              1a   inz
     D fktunicode      s              1a   inz
     D fktunicode2     s              1a   inz
     D fktSPOOL        s              1a   inz
     D fktABCCODEP     s              1a   inz
     D fktcheckou      s              1a   inz
     D fkttr_lfs       s              1a   inz
     D fktpdap7        s              1a   inz
     D fktclrpfm       s              1a   inz
     D fktobjekte      s              1a   inz
     D fktWATCHLF      s              1a   inz
     D fktWATCadr      s              1a   inz
     D fktTRIFWE       s              1a   inz
     D fktteiloff      s              1a   inz
     D fktteilon       s              1a   inz
     D fktafko         s              1a   inz
     D fktrezit1       s              1a   inz
     D fktreAT1        s              1a   inz
     D fktabsatz2c     s              1a   inz
     D fktrhgefahr     s              1a   inz
     D fktKomDat       s              1a   inz
     D fktTEGNPA       s              1a   inz
     D fktLP1OUT       s              1a   inz
     D fktblomgr       s              1a   inz
     D fkt_scm         s              1a   inz
     D fktrpm          s              1a   inz
     D fktbankftp      s              1a   inz
     D fktTRACKP       s              1a   inz
     D fktTRED80S      s              1a   inz
     D fktbestand      s              1a   inz
     D fktwrkswt       s              1a   inz
     D fktjobrunc      s              1a   inz
     D fktwup          s              1a   inz
     D fktcwl          s              1a   inz
     D fktsankti2      s              1a   inz

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d NumSysTime      s              6s 0
     d NumTESTime      s              6s 0
     d myDate          s               d
     d tomorrow        s               d
     d twechsel        s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d tommonths       s              2s 0
     d eofyear         s              8s 0
     d yearmonth       s              6s 0
     d nowdate         s              8s 0
     Dweek             s              1s 0
     DGoodDateV        S              1a
     DGoodDateB        S              1a
     Derror1           s              1a   inz
     Derror2           s              1a   inz
     Derror3           s              1a   inz
     Derror4           s              1a   inz
     Derror5           s              1a   inz
     D#ERRORS          s             60a
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     D p_inFIL         s             22a

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz


     D #i              S             10I 0
       //ucs2
     D $ch             S              1c
     d $temp           S           5001A   VARYING inz(' ')
       //ucs2
     D $string         S           5000c
       //ucs2 chinesisch!
     D $stringc        S           5000g
      // éberschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE


       // in
       // exsr stk3Kalk;
       // out

       eval status ='Start JOB_R                               ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';
          #run = '1';
       //____stop___________time ___________________Tageswechsel_______
          dow #run = '1' and NumSysTime < 235959 and tomorrow = twechsel and
              JOB_R_run= '1';
             eval status =*blank;
             eval status ='run     JOB_R                           ';
             exsr      SR_log;
             exsr  function;
             eval status =*blank;
             eval status ='end run JOB_R now on  delay 0600        ';
             exsr      SR_log;
             MONITOR;
                Wrk.var1 =
                    'DLYJOB DLY(0600)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status = 'error DLYJOB                                    ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
                   #run = '0';
             endmon;
             NumSysTime = %Dec(%Time(): *ISO);
             twechsel  = %date() +  %days(01);
             in  *lock *dtaara;
             JOB_R_run  =  JOB_R_run;
             out *dtaara;
          enddo;
       //________________________________
       //

       if §records <> *zero;
       endif;

       endif;

       // ______________________________________________________________________

       if error1 =  '0';
       //liblist
          MONITOR;
             Wrk.var1 =
                 'RMVLIBLE LIB(GANG)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                status='error  RMVLIBLE LIB(GANG)                       ';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
                error1 ='1';
          endmon;
       endif;

       eval status ='Ende  JOB_R                             ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //
       //    %dec(Datum:*iso) => JJJJMMTT
       //    %dec(Datum:*eur) => TTMMJJJJ
       //    %dec(Datum:*jul) => JJJJTTT
       //-----------------------------------------------------------------------

       begsr srinit;
       checkd =20160505;
       checkx =20160205;

       monitor;
          Date_in_V=%date(%char(checkd):*iso0);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;
       monitor;
          Date_in_V= date_in_V + %days(07);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;
       monitor;
          Date_in_V=(%date(%char(checkd):*iso0)) + %days(07);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;

       monitor;
          Date_in_V=(%date(%char(checkd):*iso0)) + %days(07);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;

       monitor;
          Date_in_b=%date(%char(checkx):*iso0);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;

       monitor;
             p= %DIFF (Date_in_V: Date_in_b: *days);
             On-error *all;
             GoodDateV='0';
             eval #ERRORS ='Von Datum kein reguläres Datum ' +
                          %char(checkd) ;
       endmon;


       //JOB_R_run ='1' job wird ausgeführt, '0' = job wird beendet
       in  *lock *dtaara;
       JOB_R_run  =  JOB_R_run;
       out *dtaara;

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(GANG) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(GANG) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

       //Funktionsbereiche
       fktpbestlo  = '1';  // Sicherung pbestlo  +
                           // Intercompany Purchase orders EMEA to APAC( in Job PBESTLO-R Routine)
       fktswapc    = '1';  // alte Dateien auslagern aus tvrelwaeco/orderinput
       fktlag_bst  = '0';  // Lagerbestände aus life LFS nach Trend Test bringen
       fkttrigger  = '0';  // Trigger Datenbank Testsystem
       fktstk3kal  = '1';  //STK3-Kalkulation ausführen
       fktrpmsale  = '1';  // Salestransaktionen bereitsellen für Lagerbewertungen
       fktritemq   = '1';  // Prüfung des Artikelstamms mit Fehlerprotokoll
       fktropenor  = '1';  // offene Kundenaufträge ableiten
       fktqm_items = '1';  // QM Absatz und Wareneingänge
       fktstueckl  = '1';  // Stücklistenaufbau in bar_kalk einleiten für Folgeprozesse
       fktediKund  = '1';  // Kontrolle EDI-Kundenübersicht
       fktQZLSCHSI = '1';  // NetServer Freigabe user profile
       fkttrmail   = '1';  // Mail an Trend über inklusive delivery note
       fktavailab  = '1';  // availibility prüfen
       fktprj015p  = '1';  // Aktualisierung fktprj015p44 PS -System Zollnr und ABC Kennung
       fktbackord  = '1';  // run Backorders ermitteln Achtung ist call we_check und RPMEXPECM
       fktedccall  = '0';  // update EDC-Display Daten      21.07.2023
       fktunicode  = '1';  // unicode Einträge UCS-2-Felder PANFKOP
       fktunicode2 = '1';  // unicode Einträge UCS-2-Felder PANFTXT
       fktSPOOL    = '1';  // Spoolbereinigung WATCHSPL1
       fktABCCODEP = '1';  // ABC Code PBFSTSS attention!!!! Prod über domgen/ABCCODEP
       fktcheckou  = '1';  // call checkoutr Analyse über rpm ==> checkout2 ==> checkout3
       fkttr_lfs   = '1';  // Ermittlung ébergabe Kopf und Positionssätze Trend LFS
       fktpdap7    = '1';  // laden Daten für pdap7
       fktclrpfm   = '1';  // Dateien für clrpfm
       fktobjekte  = '1';  // objekte prüfen aus *usrlibl ==> OUTFILE(TVRELWAECO/#OBJEKTE)
       fktWATCHLF  = '1';  // Läuft LFS noch im Hintergrund?
       fktWATCadr  = '1';  // Läuft Adressabgleich Trend und Schilling
       fktTRIFWE   = '1';  // TRIFWE01 RPGLE Permanente ébernahme Interface Wareneingang
       fktteiloff  = '0';  // teil trigger off
       fktteilon   = '0';  // teil trigger on
       fktafko     = '1';  // afko Versandbedingungen updaten bei fehlenden VSBS's
       fktrezit1   = '0';  // Ezitel Stammdatenabgleich Artikel
       fktreAT1    = '0';  // Ezitel Stammdatenabgleich çsterreich AT
       fktabsatz2c = '1';  // Umweltmanagement DE411 und AT411
       fktrhgefahr = '1';  // tvrelwaeco/RHGEFAHRN füllen aus Teilestamm
       fktKOMDat   = '1';  // KomDat für spezielle Aufträge aus Siegen anpassen in AFPO
       fktTEGNPA   = '1';  // Geluwe Artikel TEGNPA brauchen ein 'J' für ébernahme
       FKTLP1OUT   = '1';  // LP1 PREISE LADEN IN SALESCOMPANY/RPMII für LETZTEN 365 TAGE
       FKTBLOMGR   = '1';  // Statistik für Blomgren, Niklas call BLOMGREN
       fkt_scm     = '1';  // ändern Stammdaten für scm
       fktrpm      = '1';  // letzte RPM Monat in Verzeichnis ableiten!
       fktbankftp  = '1';  // Bankdaten holen täglich Wochentag / stündlich
       fktTRACKP   = '0';  // TRACKING
       fktTRED80S  = '1';  // Übernahme EDI Orders nach TREND IF
       fktbestand  = '1';  // Bestand täglich zum Ende aus Trend Pierre
       fktwrkswt   = '1';  // Übernahme EDI Orders nach TREND Werknummern Korrektur!
       fktjobrunc  = '1';  // clean Job_run datei über sql vorher in #DC0008
       fktwup      = '1';  // call WUPINPUTR für wup/format
       fktcwl      = '1';  // Start sbmjob SC40670_RR CWL England
       fktsankti2  = '1';  // Start sbmjob Sanktionsmonitor2 SANKTION2R
       //*************************************************************************************************************

       //*************************************************************************************************************
       err_msg     = '1';
       NumSysTime = %Dec(%Time(): *ISO);
       //  If MyNumTime = NumSysTime;
       //  //2. Convert numeric Time (HHMMSS) into a real time
       //  RealTime = %Time(MyNumTime: *ISO);
       //  If RealTime = %Time();

       mydate   = %date();
       days     = %subdt( %date(): *days );
       months   = %subdt( %date(): *months );
       years    = %subdt( %date(): *years );
       eofyear  = years*10000+12*100+31;
       yearmonth= years*100+months;
       nowdate  = (%dec(%char(%date()- %days(1):*iso0):8:0));

       tomorrow  = %date() +  %days(01);
       twechsel  = %date() +  %days(01);
       tommonths = %subdt( %date() + %days(01): *months );


       //      1...
       exec sql
         insert into TVRELWAECO/xxxxx
         SELECT *
         FROM lbbs WHERE LBBSFIRM = '01';


         §records=*zero;
       exec sql
         select count(*) into :§records
                FROM  TVRELWAECO/xxxxx;

       if §records <> *zero;
       endif;

       exec sql
         select  dec(DAYOFWEEK_iso(current date ), 1, 0)
                 into            :week
                 from   qsys2/qsqptabl;

       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found continue;
         exec sql
                  WHENEVER SQLWARNING continue;
         exec sql
                  WHENEVER SQLERROR  continue;

       endsr;

       //-----------------------------------------------------------------------
       //Funtionen
       //-----------------------------------------------------------------------

       begsr function;

       //________________________________
       //________________________________
       //________________________________
       //Job_run bereinigen 1. Tätigkeit
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 8              and #run='1' and NumSysTime > 000000;
          if fktjobrunc  ='1';
             eval fkt = 'fktjobrunc  ';
             eval fktjobrunc  ='0';
             eval status ='Start Job_run Protokoll bereinigen        ';
             exsr Cl_job_run;
             eval status ='Ende  Job_run Protokoll bereinigen        ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //Sicherung mit Zeitstempel______    +
       //Intercompany Purchase orders EMEA to APAC( in Job PBESTLO-R Routine)
       //die Datei pbestlo wird zum Monatsende gesichert
       NumSysTime = %Dec(%Time(): *ISO);
       if   tommonths <> months and #run='1' and NumSysTime > 224500;
          if fktpbestlo ='1';
             eval fkt = 'fktpbestlo ';
             eval fktpbestlo ='0';
             eval status ='Start callP PBESTLO_R                     ';
             exsr      SR_log;
             callP PBESTLO_R();
             eval status ='Ende  callP PBESTLO_R                     ';
             exsr      SR_log;
             eval status ='Start callP INTERCOMP2                    ';
             exsr      SR_log;
             callP INTERCOMP2();
             eval status ='Ende  callP INTERCOMP2                    ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //rpm_daten letzter Monat ausgeben als Protokoll
       //Verzeichnis:
       NumSysTime = %Dec(%Time(): *ISO);
       if   tommonths <> months and #run='1' and NumSysTime > 224500;
          if fktrpm     ='1';
             eval fkt = 'fktrpm     ';
             eval fktrpm     ='0';
             eval status ='Start rpm_daten letzter Monat ausgeben    ';
             exsr      SR_log;
             exsr      rpm_month;
             eval status ='Ende  rpm_daten letzter Monat ausgeben    ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;
       //________________________________
       exsr      rpm_month;
       //________________________________
       //________________________________
       //________________________________
       //________________________________
       //orderinput/tvrelwaeco bereinigen
       //Achtung dtaara swapc ändern, ansonsten erfolgt Erimttlung
       //und ggf. Sicherungsordner anlegen und anpassen
       //und ggf. Sicherungsordner anlegen und anpassen
       NumSysTime = %Dec(%Time(): *ISO);
       if   tommonths <> months and #run='1' and NumSysTime > 223000;
          if fktswapc   ='1';
             eval fkt = 'fktswapc   ';
             fktswapc   ='0';
             in  *lock *dtaara;
             #swapc     =  %char(years) + %EDITC(months:'X')  + '00';
       //    #swapc     =  '20170000';
             out *dtaara;
             eval status ='Start callP SWAPC                         ';
             exsr      SR_log;
             callP SWAPC();
             eval status ='Ende  callP SWAPC;                        ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Bestände aus LFS werden in die Testumgebung abegleitet
       NumSysTime = %Dec(%Time(): *ISO);
       if #run='1' and NumSysTime > 223000;
          if fktlag_bst ='1';
             eval fkt = 'fktlag_bst ';
             fktlag_bst ='0';
             eval status ='Start Lagerbestand holen aus pbestlo KumWerte';
             exsr      SR_log;
             exsr LAG_BEST;
             eval status ='Ende Lagerbestand holen aus pbestlo KumWerte ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Bestand täglich zum Ende aus Trend Pierrere Buss
       NumSysTime = %Dec(%Time(): *ISO);
       if #run='1' and NumSysTime > 230000;
          if fktbestand ='1';
             eval fkt = 'fktbestand ';
             fktbestand ='0';
             eval status ='Start Bestand täglich zum Ende aus Trend Pierre';
             exsr      SR_log;
             exsr fktPierre;
             eval status ='Ende Bestand täglich zum Ende aus Trend Pierre';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Trigger setzten für Testumgebung
       NumSysTime = %Dec(%Time(): *ISO);
       if #run='1' and NumSysTime < 065500;
          if fkttrigger ='1';
             eval fkt = 'fkttrigger ';
             fkttrigger ='0';
             eval status ='Start Trigger für Testumgebung in Trend      ';
             exsr      SR_log;
             exsr TriggerT;
             eval status ='Ende Trigger für Testumgebung in Trend       ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //STK3Werte ébergabe ____________
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime < 190000
                                             and NumSysTime > 183000;
          if fktstk3kal ='1';
             eval fkt = 'fktstk3kal ';
             eval fktstk3kal ='0';
             eval status ='Start callP RPMIISTK3R                    ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'ADDLIBLE LIB(BAR_KALK) POSITION(*LAST) ';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                   error2 ='0';
                on-error;
                   status='error ADDLIBLE LIB(BAR_KALK) POSITION(*LAST)    ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
                   error2 ='1';
             endmon;

             exsr      SR_log;
       //    for_run = 'DE411 ';
             for_run = *blank;
             callP RPMIISTK3R(for_run);
             exsr stk3Kalk;
             eval status ='Ende  callP RPMIISTK3R                    ';
             exsr      SR_log;
             if error2 =  '0';
       //      liblist
                MONITOR;
                   Wrk.var1 =
                       'RMVLIBLE LIB(BAR_KALK)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                      error2 ='0';
                   on-error;
                      status='error  RMVLIBLE LIB(BAR_KALK)                   ';
                      exsr      SR_log;
                      status = §§§MTX;
                      exsr      SR_log;
                      error2 ='1';
                endmon;
             endif;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Salestransaktion für Lagerführung bereitstellen
       //Achtung: Es werden Daten aus dem call RPMEXPECM benòtigt
       //         für die offenen Kundenaufträge.
       NumSysTime = %Dec(%Time(): *ISO);
       if week = 3              and #run='1' and NumSysTime > 184500;
          if fktrpmsale ='1';
             eval fkt = 'fktrpmsale ';
             eval fktrpmsale ='0';
             eval status ='Start sbmjob RPMSALESM2                   ';
             if fktropenor ='1';
                eval fktropenor ='0';
                eval status ='Start sbmjob RPMEXPECM offene Kundenorder ';
                exsr srRPMEXPECM;
                eval status ='Ende  sbmjob RPMEXPECM offene Kundenorder ';
                exsr      SR_log;
             endif;
       //   sbmjob
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/RPMSALESM2)) ' +
                    'JOB(RPMSALESM2) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/RPMSALESM2))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob RPMSALESM2                   ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Prüfen der Stammdaten
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 123000
                                             and NumSysTime < 134500;
          if fktritemq  ='1';
             eval fkt = 'fktritemq  ';
             eval fktritemq  ='0';
             eval status ='Start sbmjob KHT_RESULT Stammdaten        ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/KHT_RESULT)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/KHT_RESULT))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob KHT_RESULT Stammdaten        ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //CWL Logdaten für Kunde in England ermitteln aus LFS SC40670_RR
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 223000
                                             and NumSysTime < 224500;
          if fktcwl     ='1';
             eval fkt = 'fktcwl     ';
             eval fktcwl     ='0';
             eval status ='Start sbmjob SC40670_RR CWL               ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/SC40670_RR)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/SC40670_RR))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob SC40670_RR                   ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //offene Kundenaufträge ableiten
       NumSysTime = %Dec(%Time(): *ISO);
       eval fktropenor ='0';
       //Ableitung in Verbindung mit anderen Job's
       if week < 7                     and #run='1' and NumSysTime > 224600;
          if fktropenor ='1';
             eval fkt = 'fktropenor ';
             eval fktropenor ='0';
             eval status ='Start sbmjob RPMEXPECM offene Kundenorder ';
             exsr srRPMEXPECM;
             eval status ='Ende  sbmjob RPMEXPECM offene Kundenorder ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //QM Absatz und Wareneingänge
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 5              and #run='1' and NumSysTime > 184500;
          if fktqm_items ='1';
             eval fkt = 'fktqm_items ';
             eval fktqm_items ='0';
             eval status ='Start QM Absatz und Wareneingänge         ';
             exsr qm_items;
             eval status ='Ende  QM Absatz und Wareneingänge         ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Stücklistenaufbau in BAR_KALK/SLAZS
       //Achtung! Beistellung wird aus Lauf RPMIISTK3R ermittelt
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 190000;
          if fktstueckl ='1';
             eval fkt = 'fktstueckl  ';
             eval fktstueckl ='0';
             eval status ='Start sbmjob STUECKL_R Stuecklistenaufbau ';
             exsr srstueckl;
             eval status ='Ende  sbmjob STUECKL_R Stuecklistenaufbau ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //________________________________
       //Kontrolle EDI_kunden Ausgabe in EDI_KUNDEN
       NumSysTime = %Dec(%Time(): *ISO);
       if week = 4              and #run='1' and NumSysTime > 110000;
          if fktediKund ='1';
             eval fkt = 'fktediKund  ';
             eval fktediKund ='0';
             eval status ='Start EDI_Kunden Ausgabe in EDI_KUNDEN';
             exsr srEDIKUND;
             eval status ='Ende  EDI_Kunden Ausgabe in EDI_KUNDEN';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //NetServer Freigaben einleiten
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 32 and week < 8  and #run='1' and
               ( NumSysTime > 054500 and NumSysTime < 160000 or
                 NumSysTime > 054500 and NumSysTime < 160000 )   ;
          if fktQZLSCHSI ='1';
             eval fkt = 'fktQZLSCHSI ';
             eval fktQZLSCHSI ='1';
             eval status ='Start NetServer Freigaben einleiten       ';
             exsr      SR_log;
       //für change
             open  #NetServer;
       //    if not %found;
       //    msgdta = 'Error by open      ';
       //    QMHSNDPM( 'CPF9897': 'QCPFMSG *LIBL'
       //    : msgdta: %len(msgdta): '*ESCAPE'
       //    : '*PGMBDY': 1: MsgKey: err );


             read #NetServer  #NetServer_i;
             dow not %eof(#NetServer);
       //für change
                if (#netServer_i.#NETUSERA='A');
                   callP $QZLSCHSI(#netServer_i.#NETUSER);
                endif;
                read #NetServer  #NetServer_i;
             enddo;
             close #NetServer;
             eval status ='Ende  NetServer Freigaben einleiten       ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Maildaten inklusive delivery note ausgeben
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 063000
                                             and NumSysTime < 234500;
          if fkttrmail  ='1';
             eval fkt = 'fkttrmail  ';
             eval fkttrmail  ='1';
             mailfile = 'RHENANIA   ';
             eval status ='Start sbmjob Mailausgabe Trend an Kunden ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TRSP18CL) PARM(''RHENANIA   '')) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(CALL PGM(TRSP18CL) ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Mailausgabe Trend an Kunden ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //'Übernahme EDI Orders nach TREND IF'
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7  and #run='1' and
          (
             NumSysTime > 070500 and NumSysTime < 072300 or
             NumSysTime > 080500 and NumSysTime < 082300 or
             NumSysTime > 090500 and NumSysTime < 092300 or
             NumSysTime > 100500 and NumSysTime < 102300 or
             NumSysTime > 110500 and NumSysTime < 112300 or
             NumSysTime > 120500 and NumSysTime < 122300 or
             NumSysTime > 130500 and NumSysTime < 132300 or
             NumSysTime > 140500 and NumSysTime < 142300 or
             NumSysTime > 150500 and NumSysTime < 152300 or
             NumSysTime > 160500 and NumSysTime < 162300 or
             NumSysTime > 180500 and NumSysTime < 182300
          );
          if fktTRED80S ='1';
             eval fkt = 'fkttred80s ';
             eval fktTRED80S ='1';
             system_e = 'MODWAO     ';
             mandant_e= '01';
             eval status ='Start sbmjob stddat abarbeiten           ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD' +
                    '(CALL PGM(TRED80SJ) PARM(''MODWAO    '' ''01'')) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(CALL PGM(TRED80SJ) ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob stddat abarbeiten           ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Für Igloo und Testumgebung
       //Update der Werksnummer, Auftragsart, Werk-Kunde, Abladestelle
       //Übernahme EDI Orders nach TREND IFak
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 7 and #run='1' and
          (
             NumSysTime > 082500 and NumSysTime < 084000 or
             NumSysTime > 092500 and NumSysTime < 094000 or
             NumSysTime > 102500 and NumSysTime < 104000 or
             NumSysTime > 112500 and NumSysTime < 114000 or
             NumSysTime > 122500 and NumSysTime < 124000 or
             NumSysTime > 132500 and NumSysTime < 134000 or
             NumSysTime > 142500 and NumSysTime < 144000 or
             NumSysTime > 152500 and NumSysTime < 154000 or
             NumSysTime > 162500 and NumSysTime < 164000 or
             NumSysTime > 182500 and NumSysTime < 184000
          );
          if fktwrkswt  ='1';
             eval fkt = 'fktwrkswt  ';
             eval fktwrkswt  ='1';
             eval status ='Start sbmjob WERKSWITCH                   ';
             exsr      SR_log;
       //   sbmjob
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/WERKSWITCH)) ' +
                    'JOB(WERKSWITCH) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/WERKSWITCH))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval fkt = 'fktwrkswt  ';
             eval status ='Ende  sbmjob WERKSWITCH                   ';
             exsr      SR_log;
          endif;
       endif;

       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Sanktionsmonitor Sperre bestimmter Länder
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 7 and #run='1' and
          (
             NumSysTime > 000001 and NumSysTime < 255000
          );
          if fktsankti2  ='1';
             eval fkt = 'fktsankti2 ';
             eval fktsankti2 ='0';
             eval status ='Start sbmjob Sanktionsmonitor             ';
             exsr      SR_log;
       //   sbmjob
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/SANKTION2R)) ' +
                    'JOB(SANKTION2R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/SANKTION2R))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval fkt = 'fktsankti2 ';
             eval status ='Ende  sbmjob SANKTION2R                   ';
             exsr      SR_log;
          endif;
       endif;

       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //AVAILABLER
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 230000;
          if fktavailab ='1';
             eval fkt = 'fktavailab  ';
             eval fktavailab ='0';
             eval status ='Start sbmjob AVAILABLER Stammdaten        ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/AVAILABLER)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/AVAILABLER))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob AVAILABLER Stammdaten        ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //prj015p44 für elps aktualisieren ZOLL# u ABC
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 191500;
          if fktprj015p ='1';
             eval fkt = 'fktprj015p ';
             eval fktprj015p ='0';
             eval status ='Start prj015p44 für elps aktualisieren ZOLL# u ABC';
             exsr      SR_log;
             exsr      prj015p44;
             eval status ='Ende  prj015p44 für elps aktualisieren ZOLL# u ABC';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Einkauf und Backorder berechnen
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 223000
                                             and NumSysTime < 231500;
          if fktbackord ='1';
             eval fkt = 'fktbackord ';
             eval fktbackord ='0';
             eval status ='Start sbmjob BACKORDERR                   ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/BACKORDERR)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/BACKORDERR))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob BACKORDERR                   ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //edccall Display update, Daten aufbereiten
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 063000
                                             and NumSysTime < 220000;
          if fktedccall ='1';
             eval fkt = 'fktedccall ';
             eval fktedccall ='1';
             eval status ='Start sbmjob  edccall Display, Daten aufbereiten  ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/EDCCALL)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/EDCCALL   ))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob  edccall Display, Daten aufbereiten  ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //                   CHGJOB     CCSID(1144)
       //update             domdatv7/pbfstss set tzbez1='SPX single Display
       //'                                   WHERE TZIDEN ='4450029253'
       //pbfstsf_________________________
       //________________________________
       //________________________________
       //UCS2 Unicode Error Handling einleiten
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 32 and week < 8  and #run='1' and
               ( NumSysTime > 050000 and NumSysTime < 220000 or
                 NumSysTime > 050000 and NumSysTime < 220000 )   ;
          if fktunicode  ='1';
             eval fkt = 'fktunicode ';
             eval fktunicode  ='1';
             eval status ='Start Unicode UCS2 Freigaben einleiten       ';
             exsr      SR_log;

       //liblist
             MONITOR;
             Wrk.var1 =
                 'ADDLIBLE LIB(DOMDATV7) POSITION(*LAST) ';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                error5 ='0';
             on-error;
                status='error ADDLIBLE LIB(DOMDATV7) POSITION(*LAST)        ';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
                error5 ='1';
             endmon;
       //LibList ok
             if error5 ='0' or error5 ='1';
       //für change
                open  PANFKOP;
       //       if not %found;
       //       msgdta = 'Error by open      ';
       //       QMHSNDPM( 'CPF9897': 'QCPFMSG *LIBL'
       //       : msgdta: %len(msgdta): '*ESCAPE'
       //       : '*PGMBDY': 1: MsgKey: err );


                read PANFKOP    PANFKOP_i;
                dow not %eof(PANFKOP);
       //für change
                   update# = '0';
                   upderr# = '0';
                   eval status = *blank;
                   eval status = '*LFS ' +
                                 %char(PANFKOP_i.AKAPN) +' '+ PANFKOP_i.AKANR1;
                   PANFKOP_o =  PANFKOP_i;
       //für change AKAN1
                   $string  = PANFKOP_i.AKAN1;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKAN1   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKAN1*';
                   endif;
       //für change AKAN2
                   $string  = PANFKOP_i.AKAN2;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKAN2   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKAN2*';
                   endif;
       //für change AKAN3
                   $string  = PANFKOP_i.AKAN3;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKAN3   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKAN3*';
                   endif;
       //für change AKAN4
                   $string  = PANFKOP_i.AKAN4;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKAN4   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKAN4*';
                   endif;
       //für change AKSTR
                   $string  = PANFKOP_i.AKSTR;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKSTR   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKSTR*';
                   endif;
       //für change AKLORT
                   $string  = PANFKOP_i.AKLORT;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKLORT  = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKLORT*';
                   endif;
       //für change AKLOTL
                   $string  = PANFKOP_i.AKLOTL;
                   clear               $temp;
                   exsr unicode_x;
                   PANFKOP_o.AKLOTL  = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' AKLOTL*';
                   endif;
                   if update# = '1';
                      if update# = '1';
                         update PHY02R    PANFKOP_o;
                      endif;
                      exsr      SR_log;
                   else;
                      unlock       PANFKOP;
                   endif;
                   clear           PANFKOP_o;
                   read PANFKOP    PANFKOP_i;
                enddo;
                close PANFKOP;
                eval status ='Ende  Unicode UCS2 Freigaben einleiten    ';
                exsr      SR_log;
       //liblist
                MONITOR;
                   Wrk.var1 =
                   'RMVLIBLE LIB(DOMDATV7)';
                    cmd = %TrimR(Wrk.Var1);
                    L      = %Len(Cmd);
                    QCMDEXC(cmd: %len(cmd));
                    error5 ='0';
                on-error;
                    status='error  RMVLIBLE LIB(DOMDATV7)                   ';
                    exsr      SR_log;
                    status = §§§MTX;
                    exsr      SR_log;
                    error5 ='1';
                endmon;
             endif;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //________________________________
       //UCS2 Unicode Error Handling einleiten panftxt
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 32 and week < 8  and #run='1' and
               ( NumSysTime > 050000 and NumSysTime < 220000 or
                 NumSysTime > 050000 and NumSysTime < 220000 )   ;
          if fktunicode2 ='1';
             eval fkt = 'fktunicode2';
             eval fktunicode2 ='1';
             eval status ='Start Unicode UCS2 Freigaben einleiten 2     ';
             exsr      SR_log;

       //liblist
             MONITOR;
             Wrk.var1 =
                 'ADDLIBLE LIB(DOMDATV7) POSITION(*LAST) ';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                error5 ='0';
             on-error;
                status='error ADDLIBLE LIB(DOMDATV7) POSITION(*LAST)        ';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
                error5 ='1';
             endmon;
       //LibList ok
             if error5 ='0' or error5 ='1';
       //für change
                open  PANFTXT;
       //       if not %found;
       //       msgdta = 'Error by open      ';
       //       QMHSNDPM( 'CPF9897': 'QCPFMSG *LIBL'
       //       : msgdta: %len(msgdta): '*ESCAPE'
       //       : '*PGMBDY': 1: MsgKey: err );


                read panftxt    panftxt_i;
                dow not %eof(panftxt);
       //für change
                   update# = '0';
                   upderr# = '0';
                   eval status = *blank;
                   eval status = '*LFS ' +
                                 %char(panftxt_i.ATAPN) + ' '+ panftxt_i.ATRA4 ;
                   panftxt_o =  panftxt_i;
       //für change ATTXT
                   $string  = panftxt_i.ATTXT;
                   clear               $temp;
                   exsr unicode_x;
                   panftxt_o.ATTXT   = $temp;
                   if upderr# = '1';
                      status = %trim(status) + ' ATTXT*';
                   endif;
                   if update# = '1';
                      if update# = '1';
                         update PHY06R    panftxt_o;
                      endif;
                      exsr      SR_log;
                   else;
                      unlock       panftxt;
                   endif;
                   clear           panftxt_o;
                   read panftxt    panftxt_i;
                enddo;
                close panftxt;
                eval status ='Ende  Unicode UCS2 Freigaben einleiten 2  ';
                exsr      SR_log;
       //liblist
                MONITOR;
                   Wrk.var1 =
                   'RMVLIBLE LIB(DOMDATV7)';
                    cmd = %TrimR(Wrk.Var1);
                    L      = %Len(Cmd);
                    QCMDEXC(cmd: %len(cmd));
                    error5 ='0';
                on-error;
                    status='error  RMVLIBLE LIB(DOMDATV7)                   ';
                    exsr      SR_log;
                    status = §§§MTX;
                    exsr      SR_log;
                    error5 ='1';
                endmon;
             endif;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //RPM-Checkout update, Daten aus RMP über CHECKOUTR aufbereiten
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 223000
                                             and NumSysTime < 233000;
          if fktcheckou ='1';
             eval fkt = 'fktcheckou ';
             eval fktcheckou ='0';
             eval status ='Start sbmjob CHECKOUTR, Daten aus RPM aufbereiten  ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/CHECKOUTR)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/CHECKOUTR ))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob CHECKOUTR, Daten aus RPM aufbereiten ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //Spools bereinigen  Space alert triggern
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 8  and #run='1' and
          (NumSysTime > 060000 and NumSysTime < 061500 or
           NumSysTime > 070000 and NumSysTime < 071500 or
           NumSysTime > 080000 and NumSysTime < 081500 or
           NumSysTime > 090000 and NumSysTime < 091500 or
           NumSysTime > 100000 and NumSysTime < 101500 or
           NumSysTime > 110000 and NumSysTime < 111500 or
           NumSysTime > 120000 and NumSysTime < 121500 or
           NumSysTime > 130000 and NumSysTime < 131500 or
           NumSysTime > 140000 and NumSysTime < 141500 or
           NumSysTime > 150000 and NumSysTime < 151500 or
           NumSysTime > 160000 and NumSysTime < 161500 or
           NumSysTime > 170000 and NumSysTime < 171500 or
           NumSysTime > 180000 and NumSysTime < 181500 or
           NumSysTime > 190000 and NumSysTime < 191500 or
           NumSysTime > 200000 and NumSysTime < 201500 or
           NumSysTime > 210000 and NumSysTime < 211500 or
           NumSysTime > 220000 and NumSysTime < 221500);

          if fktSPOOL ='1';
             eval fkt = 'fktSPOOL   ';
             eval fktSPOOL   ='1';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'WRKSYSSTS OUTPUT(*PRINT)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error WRKSYSSTS OUTPUT(*PRINT)           ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Start callP WATCHSPL1                     ';
             exsr      SR_log;
             callP WATCHSPL1();
             eval status ='Ende  callP WATCHSPL1                     ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //ABC Code PBFSTSS attention!!!! Prod  über domgen/ABCCODEP
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 8  and #run='1' and
          (NumSysTime > 060000 and NumSysTime < 061200 or
           NumSysTime > 114500 and NumSysTime < 120000);

          if fktABCCODEP ='1';
             eval fkt = 'fktABCCODEP';
             eval fktABCCODEP='1';
             eval status ='Start SBMJOB DOMGEN/ABCCODEP              ';
             exsr      SR_log;
       //    callP ABCCODEP();
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(DOMGEN/ABCCODEP)) ' +
                    'JOB(ABCCODEP) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMGEN DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(DOMGEN/ABCCODEP ))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  SBMJOB DOMGEN/ABCCODEP              ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Ermittlung ébergabe Kopf und Positionssätze Trend LFS
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 060000
                                             and NumSysTime < 233000;
          if fkttr_lfs ='1';
             eval fkt = 'fkttr_lfs  ';
             eval fkttr_lfs ='1';
             eval status ='Start sbmjob TR_LFS_R, Kopf/Position trend=>lfs   ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/TR_LFS_R)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/TR_LFS_R ))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob TR_LFS_R, Kopf/Position trend=>lfs  ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________gestoppt bugt immer Zeig pgm überlauf
       //________________________________
       //Ermittlung Daten für pdap7
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 195000
                                             and NumSysTime < 230000;
          eval fktpdap7  ='0';
          if fktpdap7  ='1';
             eval fkt = 'fktpdap7   ';
             eval fktpdap7  ='0';
             eval status ='Start sbmjob PDACL001, PDAP7 versorgen            ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(DOMGEN/PDACL001    )) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMGEN DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/PDACL001 ))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende sbmjob PDACL001, PDAP7 versorgen           ' ;
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //dateien für clrpfm
       NumSysTime = %Dec(%Time(): *ISO);
       if week > 5              and #run='1' and NumSysTime > 050000
                                             and NumSysTime < 064500;
          if fktclrpfm ='1';
             eval fkt = 'fktclrpfm  ';
             eval fktclrpfm ='0';
             eval status ='Start clrpfm                                      ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'CLRPFM FILE(tvrelwaeco/TOMCATLOG)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error CLRPFM FILE(tvrelwaeco/TOMCATLOG)         ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende Start clrpfm                               ' ;
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //gegenwärtige Objekte in *usrlibl ==> OUTFILE(TVRELWAECO/#OBJEKTE)
       NumSysTime = %Dec(%Time(): *ISO);
       if   tommonths <> months and #run='1' and NumSysTime > 230000;
          if fktobjekte ='1';
             eval fkt = 'fktobjekte ';
             fktobjekte ='0';
             eval status ='Start callP #OBJEKTE==>OUTFILE(TVRELWAECO/#OBJEKTE)';
             exsr      SR_log;
             callP       #OBJEKTE();
             eval status ='Ende  callP #OBJEKTE==>OUTFILE(TVRELWAECO/#OBJEKTE)';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //WATCHLFS1 prüfen, läuft LFS noch?
       NumSysTime = %Dec(%Time(): *ISO);
       if week > 0              and #run='1' and NumSysTime > 040000;
          if fktWATCHLF ='1';
             eval fkt = 'fktWATCHLF ';
             eval FKTWATCHLF ='1';
             eval status ='Start sbmjob WATCHLFS1 LFS aktiv?         ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/WATCHLFS1)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/WATCHLFS1))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob WATCHLFS1 LFS aktiv?         ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //________________________________
       //WATCHADR1 prüfen, läuft LFS noch?
       NumSysTime = %Dec(%Time(): *ISO);
       if week > 0              and #run='1' and NumSysTime > 050000;
          if fktWATCadr ='1';
             eval fkt = 'fktWATCadr ';
             eval fktWATCadr ='0';
             eval status ='Start sbmjob WATCHADR1 Adressabgleich     ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/WATCHADR1)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/WATCHADR1))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob WATCHADR1 Adressabgleich     ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Permanente ébernahme Interface Wareneingang
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 063000
                                             and NumSysTime < 224500;
       // if fktTRIFWE  ='x';
          if fktTRIFWE  ='1';
             eval fkt = 'fktTRIFWE  ';
          §records=*zero;
          exec sql
          select count(*) into :§records
          FROM ifwe01
          WHERE IFWEFIRM ='01' and IFWESTAT < '90';
             if §records <> *zero;
                eval fktTRIFWE  ='1';
                eval status ='Permanente ébernahme Interface Wareneingang';
                exsr      SR_log;
       //      liblist
                MONITOR;
                   Wrk.var1 =
       //  'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
       //  ''' '' '' '' '' '')';
                'SBMJOB CMD(CALL PGM(TRIFWE01##) PARM(''MODWAO'' ''01'')) ' +
                       'JOB(JOB_R) JOBD(GANG/GANG) ' +
                       'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                       'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                       'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                       'GANG DIRMAIL DIRWEB)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error SBMJOB CMD(CALL PGM(CALL PGM(TRIFWE01) ';
                      exsr      SR_log;
                      status = §§§MTX;
                      exsr      SR_log;
                endmon;
                eval status ='Ende  sbmjob Permanente ébernahme Interface WE';
                exsr      SR_log;
             endif;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Trigger für update deaktivieren bei teil
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and NumSysTime > 065900
                                             and NumSysTime < 220000;
          if fktteiloff ='1';
             fktteiloff ='0';
             fktteilon  ='1';
             eval fkt = 'fktteiloff ';
             eval status ='Start Trigger für update deaktivieren bei teil     ';
             exsr      SR_log;
                MONITOR;
                   Wrk.var1 =
                       'RMVPFTRG FILE(TVPF/TEIL) TRGTIME(*AFTER) ' +
                       'TRGEVENT(*UPDATE) TRGLIB(MODWAO) ';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error RMVPFTRG FILE(TVPF/TEIL) TRGTIME(*AFTER)  ';
                      exsr      SR_log;
                      status = §§§MTX;
                      exsr      SR_log;
                      fktteilon  ='0';
                endmon;
             eval status ='Ende  Trigger für update deaktivieren bei teil     ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Trigger für update aktivieren bei teil
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and (NumSysTime < 065900
                                             or NumSysTime > 220000);
          if fktteilon ='1';
             fktteilon ='0';
             fktteiloff ='1';
             eval fkt = 'fktteilon  ';
             eval status ='Start Trigger für update aktivieren bei teil       ';
             exsr      SR_log;
                MONITOR;
                   Wrk.var1 =
                       'ADDPFTRG FILE(TVPF/TEIL) TRGTIME(*AFTER) ' +
                       'TRGEVENT(*UPDATE) PGM(MODWAO/TGIFTEILSB) ' +
                       'TRGUPDCND(*CHANGE)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error ADDPFTRG FILE(TVPF/TEIL) *change modus    ';
                      exsr      SR_log;
                      status = §§§MTX;
                      exsr      SR_log;
       //             fktteiloff ='0';
                endmon;
             eval status ='Ende  Trigger für update aktivieren bei teil       ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Auftragsdaten updaten, wenn VSBD fehlt
       //UK Orders from web without VSBD
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and
          (NumSysTime > 060000 and NumSysTime < 061500 or
           NumSysTime > 070000 and NumSysTime < 071500 or
           NumSysTime > 080000 and NumSysTime < 081500 or
           NumSysTime > 090000 and NumSysTime < 091500 or
           NumSysTime > 100000 and NumSysTime < 101500 or
           NumSysTime > 110000 and NumSysTime < 111500 or
           NumSysTime > 120000 and NumSysTime < 121500 or
           NumSysTime > 130000 and NumSysTime < 131500 or
           NumSysTime > 140000 and NumSysTime < 141500 or
           NumSysTime > 150000 and NumSysTime < 151500 or
           NumSysTime > 160000 and NumSysTime < 161500 or
           NumSysTime > 170000 and NumSysTime < 171500 or
           NumSysTime > 180000 and NumSysTime < 181500 or
           NumSysTime > 190000 and NumSysTime < 191500 or
           NumSysTime > 200000 and NumSysTime < 201500 or
           NumSysTime > 210000 and NumSysTime < 211500 or
           NumSysTime > 220000 and NumSysTime < 221500);
          if fktafko    ='1';
             eval fkt = 'fktafko    ';
             eval status ='Start Auftragsdaten update, wenn VSBD fehlt => Afko';
             exsr      SR_log;
             exec sql
             update orderh set H310=
             substr(h310, 1, 416) concat '220'                concat
                                         substr(h310, 420, 093)
             WHERE (H030 =40631 or H030 =78678) and
                   (substr(H310, 417, 03)='000' and
                    H360 > current date -5 days);

             exec sql
             update afko set akvsbd =
             (select distinct substr(H310, 417, 03) from orderh
              where h050 =akmaaf and akkdnr= (h040)
                    and substr(H310, 417, 03) <> ' ')
              where akvsbd= ' ' and (AKAFST <>'90'
                     and AKAFST <>'94' and akafst <> '89');
             eval status ='Ende Auftragsdaten update, wenn VSBD fehlt => Afko';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Prüfen der Stammdaten EZITEL  Achtung itemserv wird nicht geteilt
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 180500
                                             and NumSysTime < 183500;
          if fktrezit1  ='1';
             eval fkt = 'fktrezit1  ';
             eval fktrezit1  ='0';
             eval status ='Start sbmjob Prüfen der Stammdaten EZITEL ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/EZ_ITEM)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/EZ_ITEM))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Prüfen der Stammdaten EZITEL ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Prüfen der Stammdaten çsterreich Achtung itemserv wird nicht geteilt
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 190500
                                             and NumSysTime < 193500;
          if fktreAT1   ='1';
             eval fkt = 'fktreAT1   ';
             eval fktreAT1   ='0';
             eval status ='Start sbmjob Prüfen der Stammdaten çsterreich';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/AT_ITEM)) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/AT_ITEM))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Prüfen der Stammdaten çsterreich';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //Umweltmanagementdaten für DE411 und AT411
       NumSysTime = %Dec(%Time(): *ISO);
       if week <> 0 and week < 7  and #run='1' and NumSysTime > 120000
                                             and NumSysTime < 130000;
          if fktABSATZ2c ='1';
             eval fkt = 'fktABSATZ2c';
             eval fktABSATZ2c ='0';
             eval status ='Start callP ABSATZ2c  dualer Punkt DE411/AT411';
             exsr      SR_log;
             callP ABSATZ2C();
             eval status ='Ende  callP ABSATZ2c  dualer Punkt DE411/AT411';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //tvrelwaeco/RHGEFAHRN füllen über Teilestamm
       NumSysTime = %Dec(%Time(): *ISO);
       if week <> 0 and week < 6  and #run='1' and NumSysTime > 060000;

          if fktrhgefahr ='1'  and
             (NumSysTime > 060000 and NumSysTime < 061500 or
              NumSysTime > 070000 and NumSysTime < 071500 or
              NumSysTime > 080000 and NumSysTime < 081500 or
              NumSysTime > 090000 and NumSysTime < 091500 or
              NumSysTime > 100000 and NumSysTime < 101500 or
              NumSysTime > 110000 and NumSysTime < 111500 or
              NumSysTime > 120000 and NumSysTime < 121500 or
              NumSysTime > 130000 and NumSysTime < 131500 or
              NumSysTime > 140000 and NumSysTime < 141500 or
              NumSysTime > 150000 and NumSysTime < 151500 or
              NumSysTime > 160000 and NumSysTime < 161500 or
              NumSysTime > 170000 and NumSysTime < 171500 or
              NumSysTime > 180000 and NumSysTime < 181500 or
              NumSysTime > 190000 and NumSysTime < 191500 or
              NumSysTime > 200000 and NumSysTime < 201500 or
              NumSysTime > 210000 and NumSysTime < 211500 or
              NumSysTime > 220000 and NumSysTime < 221500);
             eval fkt = 'fktrhgefahr';
             eval fktrhgefahr ='1';
             eval status ='Start tvrelwaeco/RHGEFAHRN füllen über Teilestamm';
             exsr      SR_log;
             exsr  rhgefahrn;
             eval status ='Ende  tvrelwaeco/RHGEFAHRN füllen über Teilestamm';
             exsr      SR_log;
          endif;
          if fktrhgefahr ='1'  and
             (NumSysTime > 230000 and NumSysTime < 231500);
             eval status ='Start bereinigen Testumgebung VLF95GFT/RHGEFAHRN ';
             exsr      SR_log;
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'CLRPFM FILE(VLF95GFT/RHGEFAHRN)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error CLRPFM FILE(VLF95GFT/RHGEFAHRN)           ';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
       //   liblist
             MONITOR;
             Wrk.var1 =
                 'CPYF FROMFILE(TVRELWAECO/RHGEFAHRN)' +
                 'TOFILE(VLF95GFT/RHGEFAHRN) MBROPT(*ADD)' +
                 'FMTOPT(*MAP *DROP)';
               cmd = %TrimR(Wrk.Var1);
               l      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error in CPYF FROMFILE(rhgefahrn) to VLF95GFT)';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
             endmon;
             eval status ='Ende  bereinigen Testumgebung VLF95GFT/RHGEFAHRN ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //________________________________
       //KomDatum abändern für Siegen bei bestimmten Kunden
       NumSysTime = %Dec(%Time(): *ISO);
       if days < 32 and week < 8  and #run='1' and
               ( NumSysTime > 054500 and NumSysTime < 174500 or
                 NumSysTime > 054500 and NumSysTime < 174500 )   ;
          if fktKOMDat   ='1';
             eval fkt = 'fktKOMDat   ';
             eval fktKOMDat   ='1';
             eval status ='Start  KomDatum abändern für Siegen ';
             exsr      SR_log;

             exec sql
             insert into tvrelwaeco/KomDatEL
             SELECT DISTINCT
                    a.APFIRM, a.APAFJJ, a.APAFNR, a.APAFPO, a.APMAAF, a.APKMTE,
                    a.apkmte KomDatNew, L190, H020, H030,H040, l170,
                    char('0', 1) changed, current timestamp tstamp
             from   afpo01 a, orderl, orderh
             WHERE  a.apfirm='01' and a.APAFST <'40' and a.APKDNR='098264' and
                    a.APMAAF = L040 and a.APKDNR = L250 and L190= H370 and
                    a.APLOCK = ' '  and H340='J' and a.apfirm not in
                    (select b.apfirm from KomDatEl b
                     where a.APAFJJ=b.apafjj and a.APAFnr=b.APAFNR and
                           a.APAFPO=b.APAFPO);

             open  KomdatEL;
             open  Afpo01;
       //für Ermittlung des neuen KomDatums
             read KomDatEL  KomDatEL_i;
             dow not %eof(KomDatEL);
       //für change
                if (KomDatEL_i.changed='0');
                   §x = KomDatEL_i.APKMTE;
                   exsr KomDat;
                   KomDatEL_o    =  KomDatEL_i;
                   KomDatEL_o.KomDatNew = §x;
                   //Afpo01                                     ffff
                   Afpo01_k.apFIRM = KomDatEL_i.apFIRM;
                   Afpo01_k.APAFJJ = KomDatEL_i.APAFJJ;
                   Afpo01_k.APAFNR = KomDatEL_i.APAFNR;
                   Afpo01_k.APAFPO = KomDatEL_i.APAFPO;
                   chain %kds(Afpo01_k:4) Afpo01 Afpo01_I;
                   if %found(Afpo01)  and
                      Afpo01_i.APKMTE <> KomDatEL_o.KomDatNew;
                      Afpo01_o        =  Afpo01_i;
                      Afpo01_o.APKMTE = KomDatEL_o.KomDatNew;

                      Afpo01_o.APjnam = §§§job;
                      Afpo01_o.APJDAT = %dec(%char(%date():*iso0):8:0);
                      Afpo01_o.APJZEI = %dec(%char(%time():*iso0):6:0);
                      Afpo01_o.APuser = §§§usr;
                      Afpo01_o.APPROG = §§§pgm;
                      Afpo01_o.APbibl = §§§LIB;

                      update PHY05R    Afpo01_o;
                      eval status =*blank;
                      eval status ='KoMDat °nderung: ' + '/' +
                                      Afpo01_k.apFIRM  + '/' +
                                %char(Afpo01_k.APAFJJ) + '/' +
                                      Afpo01_k.APAFNR  + '/' +
                                %char(Afpo01_k.APAFPO) + ' ' +
                                %char(KomDatEL_o.APKMTE) + ' ' +
                                                         '==>' +
                                %char(KomDatEL_o.KomDatNew);
                      exsr      SR_log;
                      KomDatEL_o.changed   = '1';
                   else;
                      KomDatEL_o.changed   = 'E';
                   endif;
                   update PHY04R    KomDatEL_o;
                endif;
                read KomDatEL    KomDatEL_i;
             enddo;
             close KomDatEL;
             close Afpo01;
             eval status ='Ende  KomDatum abändern für Siegen        ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //Geluwe Artikel benòtigen eine Flag für die ébergabe
       //bei AA 58 PERMANENTE éBERPRéFUNG
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8              and #run='1' and
          (NumSysTime > 060000 and NumSysTime < 061500 or
           NumSysTime > 070000 and NumSysTime < 071500 or
           NumSysTime > 090000 and NumSysTime < 091500 or
           NumSysTime > 110000 and NumSysTime < 111500 or
           NumSysTime > 130000 and NumSysTime < 131500 or
           NumSysTime > 150000 and NumSysTime < 151500 or
           NumSysTime > 170000 and NumSysTime < 171500 or
           NumSysTime > 190000 and NumSysTime < 191500 or
           NumSysTime > 220000 and NumSysTime < 221500);
          if fkttegnpa  ='1';
             eval fkt = 'fkttegnpa  ';
             eval status ='Start Geluwe Kennung tegnpa auf J setzten   => Teil';
             exsr      SR_log;
             exec sql
                update teil01 set TEGNPA = 'J' where
                TEFIRM ='01' and TEPRGR in ('349', '343') and
                TEGNPA <> 'J';
             eval status ='Ende Geluwe Kennung tegnpa auf J setzten   => Teil';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //LP1 Preise laden in Salescompany/RPMII
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 8 and days = 01 and #run='1';
          if fktLP1OUT  ='1';
             eval fkt = 'fktLP1OUT  ';
             eval status ='Start LP1 Preise laden in Salescompany/RPMII/      ';
             exsr      SR_log;
             callP LP1OUTPUTR();
             eval status ='Ende LP1 Preise laden in Salescompany/RPMII/      ';
             exsr      SR_log;
          endif;
       endif;
       eval fkt = *blank;


       //________________________________
       //________________________________
       //________________________________
       //Prüfen der Stammdaten
       //Es läuft ein zweiter Job 07:00, wo Trend Daten gesammelt werden.
       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 055000 and
          NumSysTime < 055800;
       // eval fktblomgr  ='1';
       endif;

       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 055500
                                             and NumSysTime < 070000;
          if fktblomgr  ='1';
             eval fkt = 'fktblomgr  ';
             eval fktblomgr  ='0';
             eval status ='Start Niklas Blomgren Stammdaten          ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN) PARM(''1'')) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Niklas Blomgren Stammdaten   ';
             exsr      SR_log;
             eval fktblomgr  ='2';
          endif;
       endif;

       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 061500
                                             and NumSysTime < 062500;
          if fktblomgr  ='2';
             eval fkt = 'fktblomgr  ';
             eval fktblomgr  ='0';
             eval status ='Start Niklas Blomgren Stammdaten          ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN) PARM(''3'')) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Niklas Blomgren Stammdaten   ';
             exsr      SR_log;
             eval fktblomgr  ='3';
          endif;
       endif;

       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 063000
                                             and NumSysTime < 070000;
          if fktblomgr  ='3';
             eval fkt = 'fktblomgr  ';
             eval fktblomgr  ='0';
             eval status ='Start Niklas Blomgren Stammdaten          ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN) PARM(''2'')) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/BLOMGREN))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Niklas Blomgren Stammdaten   ';
             exsr      SR_log;
             eval fktblomgr  ='0';
          endif;
       endif;
       eval fkt = *blank;

       //________________________________
       //________________________________
       //________________________________
       //ändern Stammdaten für scm
       NumSysTime = %Dec(%Time(): *ISO);
       if NumSysTime > 060000 and
          NumSysTime < 060500;
       // eval fkt_scm    ='1';
       endif;

       NumSysTime = %Dec(%Time(): *ISO);
       if week < 7              and #run='1' and NumSysTime > 060000;
          if fkt_scm    ='1' and
             (NumSysTime > 060000 and NumSysTime < 061000 or
              NumSysTime > 070000 and NumSysTime < 071000 or
              NumSysTime > 080000 and NumSysTime < 081000 or
              NumSysTime > 090000 and NumSysTime < 091000 or
              NumSysTime > 100000 and NumSysTime < 101000 or
              NumSysTime > 110000 and NumSysTime < 111000 or
              NumSysTime > 120000 and NumSysTime < 121000 or
              NumSysTime > 130000 and NumSysTime < 131000 or
              NumSysTime > 140000 and NumSysTime < 141000 or
              NumSysTime > 150000 and NumSysTime < 151000 or
              NumSysTime > 160000 and NumSysTime < 161000 or
              NumSysTime > 170000 and NumSysTime < 171000 or
              NumSysTime > 180000 and NumSysTime < 181000 or
              NumSysTime > 190000 and NumSysTime < 191000 or
              NumSysTime > 200000 and NumSysTime < 201000 or
              NumSysTime > 210000 and NumSysTime < 211000 or
              NumSysTime > 220000 and NumSysTime < 221000);
             eval fkt = 'fkt_scm    ';
             eval fkt_scm    ='0';
             eval status ='Start °ndern Stammdaten für SCM           ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/SCM_IMPORT) ) ' +
                    'JOB(JOB_R) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/SCM_IMPORT))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob Stammdaten für SCM           ';
             exsr      SR_log;
             fkt_scm    ='0' ;
          endif;
       endif;
       if (NumSysTime > 063000 and NumSysTime < 064500 or
           NumSysTime > 073000 and NumSysTime < 074500 or
           NumSysTime > 083000 and NumSysTime < 084500 or
           NumSysTime > 093000 and NumSysTime < 094500 or
           NumSysTime > 103000 and NumSysTime < 104500 or
           NumSysTime > 113000 and NumSysTime < 114500 or
           NumSysTime > 123000 and NumSysTime < 124500 or
           NumSysTime > 133000 and NumSysTime < 134500 or
           NumSysTime > 143000 and NumSysTime < 144500 or
           NumSysTime > 153000 and NumSysTime < 154500 or
           NumSysTime > 163000 and NumSysTime < 164500 or
           NumSysTime > 173000 and NumSysTime < 174500 or
           NumSysTime > 183000 and NumSysTime < 184500 or
           NumSysTime > 193000 and NumSysTime < 194500 or
           NumSysTime > 203000 and NumSysTime < 204500 or
           NumSysTime > 213000 and NumSysTime < 214500 or
           NumSysTime > 223000 and NumSysTime < 224500);
             fkt_scm    ='1' ;
       endif;

       //________________________________
       //________________________________
       //Spools bereinigen  Space alert triggern
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 6  and #run='1' and
          (NumSysTime > 060000 and NumSysTime < 061500 or
           NumSysTime > 070000 and NumSysTime < 071500 or
           NumSysTime > 080000 and NumSysTime < 081500 or
           NumSysTime > 090000 and NumSysTime < 091500 or
           NumSysTime > 100000 and NumSysTime < 101500 or
           NumSysTime > 110000 and NumSysTime < 111500 or
           NumSysTime > 120000 and NumSysTime < 121500 or
           NumSysTime > 130000 and NumSysTime < 131500 or
           NumSysTime > 140000 and NumSysTime < 141500 or
           NumSysTime > 150000 and NumSysTime < 151500 or
           NumSysTime > 160000 and NumSysTime < 161500 or
           NumSysTime > 170000 and NumSysTime < 171500 or
           NumSysTime > 180000 and NumSysTime < 181500 or
           NumSysTime > 220000 and NumSysTime < 221500);

          if fktbankftp = '1';
       //liblist
          MONITOR;
             Wrk.var1 =
                 'ADDLIBLE LIB(BAR_FTP) POSITION(*LAST) ';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                status='error ADDLIBLE LIB(BAR_FTP) POSITION(*LAST)     ';
                exsr      SR_log;
                error1 ='1';
          endmon;
             eval fkt = 'fktbankftp ';
             eval fktbankftp ='1';
       //   liblist
             eval status ='Start callP PGM(BAR_FTP/BANKFTP)          ';
             exsr      SR_log;
             callP BANKFTP();
             eval status ='Ende  callP PGM(BAR_FTP/BANKFTP)          ';
             exsr      SR_log;
          endif;
       //liblist
          MONITOR;
             Wrk.var1 =
                 'RMVLIBLE LIB(BAR_FTP)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
                error1 ='0';
             on-error;
                status='error  RMVLIBLE LIB(BAR_FTP)                    ';
                exsr      SR_log;
                status = §§§MTX;
                exsr      SR_log;
                error1 ='1';
          endmon;
       endif;

       //________________________________
       //________________________________
       //TRACKING AUSSTEUERN
       NumSysTime = %Dec(%Time(): *ISO);
       if week >  0 and week < 6  and #run='1' and
          (
           NumSysTime > 070000 and NumSysTime < 071500 or
           NumSysTime > 150000 and NumSysTime < 151500 or
           NumSysTime > 180000 and NumSysTime < 181500 or
           NumSysTime > 220000 and NumSysTime < 221500);

          if fktTRACKP  = '1';
             eval fkt = 'fktTRACKP ';
             eval fktTRACKP ='1';
       //   liblist
             eval status ='Start callP PGM(TVRELWAECO/TRACKINGR)     ';
             exsr      SR_log;
             callP TRACKINGR();
             eval status ='Ende  callP PGM(TVRELWAECO/TRACKINGR)     ';
             exsr      SR_log;
          endif;
       endif;


       //________________________________
       //________________________________
       //________________________________
       //wupaufbau für WUP/Format
       NumSysTime = %Dec(%Time(): *ISO);
       if week < 6              and #run='1' and NumSysTime > 213000
                                             and NumSysTime < 224500;
          if fktwup     ='1';
             eval fkt = 'fktwup     ';
             eval fktwup     ='0';
             eval status ='Start sbmjob WUP-aufbau Stammdaten        ';
       //   liblist
             MONITOR;
                Wrk.var1 =
                    'SBMJOB CMD(CALL PGM(TVRELWAECO/WUPINPUTR)) ' +
                    'JOB(WUPINPUT) JOBD(GANG/GANG) ' +
                    'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                    'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                    'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                    'GANG DOMDATV7 BAR_KALK DIRMAIL DIRWEB)';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                on-error;
                   status='error SBMJOB CMD(CALL PGM(TVRELWAECO/WUPINPUT))';
                   exsr      SR_log;
                   status = §§§MTX;
                   exsr      SR_log;
             endmon;
             eval status ='Ende  sbmjob WUP-Aufbau Stammdaten        ';
             exsr      SR_log;
          endif;
       endif;

       eval fkt = *blank;


       endsr;

       //-----------------------------------------------------------------------
       //Job_run-cleaning #DC0008                                         -----
       //                                                                  -----
       //-----------------------------------------------------------------------

       begsr Cl_job_run;

          exec sql
             delete   FROM job_run WHERE CD < current date - 62 days;
          exec sql
             delete   FROM job_run WHERE CD < current date - 05 days
                      and pgm in ('LFPBFSTSS2', 'WATCHADR1');

       endsr;


       //-----------------------------------------------------------------------
       //Kalenderdaten                                                    -----
       //                                                                  -----
       //-----------------------------------------------------------------------

       begsr KomDat;

             §records = *zero;
             §success =  0;
             open  Calenderl1;
             eval Calender_k.$CDATEISO=
                                     %subst(%char(§x):01:04) +
                                                '-'         +
                                     %subst(%char(§x):05:02) +
                                                '-'         +
                                     %subst(%char(§x):07:02);
             setll %kds(Calender_k:1) Calenderl1;
             readp Calenderl1 Calender_i;
             dow not %eof(Calenderl1) and §success =  0;
                 if Calender_I.$NAMEDAY = 'Samstag' or
                    Calender_I.$NAMEDAY = 'Sonntag' or
                    Calender_I.DE       = 1;
                 else;
                    §records = §records + 1;
                 endif;
       //für change       hier   orh514  = 'J'
                if §records = 3;
                   §success = 1;
                   eval §x  =
                   %dec((%subst(Calender_i.$CDATEISO:01:04)):8:0)*10000 +
                   %dec((%subst(Calender_i.$CDATEISO:06:02)):8:0)*100   +
                   %dec((%subst(Calender_i.$CDATEISO:09:02)):8:0);
                endif;
                readp Calenderl1 Calender_i;
             enddo;
             close Calenderl1;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr unicode_x;
       //für change
       //         dcl-pi *N;
       //            $string ucs2(5000);
       //         end-pi;

       //         dcl-s #i    int(10);
       //         dcl-s $ch   ucs2(1);
       //         dcl-s $temp varchar(5001) inz('');
                  upderr# = '0';
                  for #i = 1 to %len(%trim($string));
                             $ch = %char(%subst($string:#i:1));
                             if    $ch =  u'0009'
                               or  $ch =  u'000A'
                               or  $ch =  u'000D'
                               or ($ch >= u'0020' and $ch <= u'D7FF')
                               or ($ch >= u'E000' and $ch <= u'FFFD')
                               or ($ch >= u'00010000' and $ch <= u'0010FFFF');
                               $temp = $temp + %char($ch);
                             else;
                               $temp   = $temp + ' ';
                               update# = '1';
                               upderr# = '1';
                             endif;
                           endfor;
                           $string = $temp;

       endsr;

       //-----------------------------------------------------------------------
       //LAG_BEST Lagerbestand pbestlo
       //-----------------------------------------------------------------------

       begsr LAG_BEST;

       exec sql
         insert into tvrelwaeco/LAG_BEST
         SELECT BMiDEN,
          char((case when bmqkz ='96' then '096'
                     when bmqkz ='94' then '094'
                     when bmqkz ='92' then '092'
                     when bmqkz ='  ' then '001'
                     else '???'                  end), 3) lager ,
         dec(sum(BMBMEN), 13, 2) Bmbmen,
         dec(count(*), 13, 2) count,
         current timestamp tstamp,
         char (' ', 1) rstatus
         FROM domdatv7/pBESTLO
         GROUP BY BMIDEN ,BMQKZ ORDER BY BMIDEN ,BMQKZ;

       exec sql
         update  TVPFTEST/lbbs set  LBBSLAGB  =
         (select Bmbmen from tvrelwaeco/LAG_BEST where lbbstenr = bmiden
                 and LBBSLANR = lager and LBBSFIRM ='01' and rstatus = ' ')
         where exists
         (select Bmbmen from tvrelwaeco/LAG_BEST where lbbstenr = bmiden
                 and LBBSLANR = lager and LBBSFIRM ='01' and rstatus = ' ');

       exec sql
         update tvrelwaeco/LAG_BEST set rstatus = '1' where bmiden in
         ( select lbbstenr from TVPFTEST/lbbs  where
                  LBBSLANR = lager and LBBSFIRM ='01');

       exec sql
          update tvrelwaeco/LAG_BEST set rstatus = '0' where rstatus= ' ';

       exec sql
          insert into  TVPFTEST/lbbs
          select * from    TVPF/lbbs    where lbbstenr in
          ( select bmiden from tvrelwaeco/LAG_BEST where  LBBSLANR = lager
                    and rstatus = '0' ) and LBBSFIRM ='01';
       //ggf. auch update fahren, fehlt derzeit noch

       exec sql
          update tvrelwaeco/LAG_BEST set rstatus = '1' where bmiden in
          ( select lbbstenr from TVPFTEST/lbbs  where
                   LBBSLANR = lager and LBBSFIRM ='01');


       endsr;

       //-----------------------------------------------------------------------
       //fktPierre  Bestand täglich zum Ende aus Trend Pierre
       //-----------------------------------------------------------------------

       begsr fktPierre;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/TGLBESTAND)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/TGLBESTAND)        ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       exec sql
         insert into tvrelwaeco/TGLBESTAND
         select RTRIM(LBBS_1.LBBSFIRM) AS LBBSFIRM,
                RTRIM(LBBS_1.LBBSTENR) AS LBBSTENR,
                RTRIM(TEIL_1.TEMCBG) AS TEMCBG,
                RTRIM(TEIL_1.TETBZ1) AS TETBZ1,
                RTRIM(TEIL_1.TETBZ2) AS TETBZ2,
                RTRIM(TEIL_1.TEPRGR) AS TEPRGR,
                RTRIM(TEIL_1.TEZINR) AS TEZINR,
                RTRIM(LBBS_1.LBBSLANR) AS LBBSLANR,
                LBBS_1.LBBSLAGB AS LBBSLAGB,
                TEIL_1.TESTPR AS TESTPR,
                LBBSLAGB * TESTPR AS CALCFIELD_1,
                current timestamp as tstamp
         FROM
             LBBS AS LBBS_1
         JOIN
             TEIL AS TEIL_1
                 ON (LBBS_1.LBBSFIRM=TEIL_1.TEFIRM
                     AND LBBS_1.LBBSTENR=TEIL_1.TETENR)
         WHERE
                 (   LBBS_1.LBBSFIRM= '01'   )
         ORDER BY
             LBBS_1.LBBSFIRM ASC,
             LBBS_1.LBBSLANR ASC;

       eval p_infil   =  'TGLBESTAND' +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
       eval p_outfil =  'TGLBESTAND';

       eval p_msgf    =  *blank;
       eval p_print   =  *blank;
       eval p_lib     =  'TVRELWAECO';

       clear     Wrk.var1;
       clear     status;

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Controlling/KALKULATION/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done TGLBESTAND                ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object TGLBESTAND                ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       eval p_outfil =  'TGLBESTAND';

       #dirmail = '0';
       if #dirmail = '1';
       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''--------'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object ' +
                         p_outfil +'csv';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       eval p_outfil =  'TGLBESTAND';

       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
           ''' '' '' '' '' '')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done TGLBESTAND               ';
          exsr      SR_log;
       on-error;
          status='Error by DUMMY512                        ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       endif;

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Controlling/KALKULATION/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/TGLBESTAND)    ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/TGLBESTAND)   ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //Trigger für Test
       //SELECT * FROM job_run WHERE PGM ='JOB_R' and JOBDESC like '%ADDPF%'
       //
       //ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEEWSB)
       //
       //ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER)
       //       TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEEWSB)
       //
       //ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER)
       //       TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEEWSB) TRGUPDCND(*CHANGE)
       //
       //ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEILSB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER)
       //       TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEILSB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER)
       //       TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEILSB) TRGUPDCND(*CHANGE)
       //
       //ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEMASB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER)
       //       TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEMASB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER)
       //       TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEMASB) TRGUPDCND(*CHANGE)
       //
       //ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEUFSB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER)
       //       TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEUFSB)
       //
       //ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER)
       //       TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEUFSB) TRGUPDCND(*CHANGE)
       //
       //ADDPFTRG FILE(TVPFTEST/AFKM) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFAFKMSB)
       //
       //ADDPFTRG FILE(TVPFTEST/BBKM) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFBBKMSB)
       //
       //ADDPFTRG FILE(TVPFTEST/BWAE) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFBWAESB)
       //
       //ADDPFTRG FILE(TVPFTEST/BWAE) TRGTIME(*AFTER)
       //       TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFBWAESB) TRGUPDCND(*CHANGE)
       //
       //ADDPFTRG FILE(TVPFTEST/LGWE) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFLGWESB)
       //
       //ADDPFTRG FILE(TVPFTEST/PARK) TRGTIME(*AFTER)
       //       TRGEVENT(*INSERT) PGM(MODWAO1/TGIFPARKSB)
       //-----------------------------------------------------------------------

       begsr TriggerT;

       //TEEW
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEEWSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(MODWAOTEST/TEEW) insert     ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER) ' +
              'TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEEWSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(MODWAOTEST/TEEW) delete     ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(MODWAOTEST/TEEW) TRGTIME(*AFTER) ' +
              'TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEEWSB) TRGUPDCND(*CHANGE)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(MODWAOTEST/TEEW) update     ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //TEIL
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEILSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEIL) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER) ' +
              'TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEILSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEIL) delete       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEIL) TRGTIME(*AFTER) ' +
              'TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEILSB) TRGUPDCND(*CHANGE)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEIL) update       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //TEMA
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEMASB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEMA) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER) ' +
              'TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEMASB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEMA) delete       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEMA) TRGTIME(*AFTER) ' +
              'TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEMASB) TRGUPDCND(*CHANGE)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEMA) update       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //TEUF
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFTEUFSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEUF) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER) ' +
              'TRGEVENT(*DELETE) PGM(MODWAO1/TGIFTEUFSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEUF) delete       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/TEUF) TRGTIME(*AFTER) ' +
              'TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFTEUFSB) TRGUPDCND(*CHANGE)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/TEUF) update       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;


       //AFKM
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/AFKM) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFAFKMSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/AFKM) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //BBKM
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/BBKM) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFBBKMSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/BBKM) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //BWAE
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/BWAE) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFBWAESB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/BWAE) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //BWAE
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/BWAE) TRGTIME(*AFTER) ' +
              'TRGEVENT(*UPDATE) PGM(MODWAO1/TGIFBWAESB) TRGUPDCND(*CHANGE)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/BWAE) update       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //LGWE
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/LGWE) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFLGWESB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/LGWE) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       //PARK
       MONITOR;
          Wrk.var1 =
              'ADDPFTRG FILE(TVPFTEST/PARK) TRGTIME(*AFTER) ' +
              'TRGEVENT(*INSERT) PGM(MODWAO1/TGIFPARKSB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error ADDPFTRG FILE(TVPFTEST/PARK) insert       ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //STK3 Kalkulation
       //-----------------------------------------------------------------------

       begsr stk3Kalk;

       eval p_infil   =  'STK3KALK' +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
       eval p_outfil =  'RPMKALKUL';

       eval p_msgf    =  *blank;
       eval p_print   =  *blank;
       eval p_lib     =  'TVRELWAECO';

       clear     Wrk.var1;
       clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Controlling/KALKULATION/STK3KALK*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed STK3KALK               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object   STK3KALK                ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;

       eval p_outfil =  'RPMKALKUL';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Controlling/KALKULATION/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done STK3KALK                  ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object STK3KALK                  ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       eval p_outfil =  'RPMKALKUL';

       #dirmail = '0';
       if #dirmail = '1';
       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''--------'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object ' +
                         p_outfil +'csv';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       eval p_outfil =  'RPMKALKUL';

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
          status = §§§MTX;
          exsr      SR_log;
       endmon;
       endif;

       endsr;

       //-----------------------------------------------------------------------
       //Ermittlung der Rückstände und offene Kundenaufträge ableiten
       //-----------------------------------------------------------------------

       begsr srRPMEXPECM;

       MONITOR;
          Wrk.var1 =
              'SBMJOB CMD(CALL PGM(TVRELWAECO/RPMEXPECM)) ' +
              'JOB(JOB_R) JOBD(GANG/GANG) ' +
              'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
              'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
              'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
              'GANG DOMDATV7 DOMCOMV7 DIRMAIL DIRWEB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error SBMJOB CMD(CALL PGM(TVRELWAECO/RPMEXPECM))';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //Aufruf Aktualisierung der Stücklisten
       //-----------------------------------------------------------------------

       begsr srstueckl;

       MONITOR;
          Wrk.var1 =
              'SBMJOB CMD(CALL PGM(TVRELWAECO/STUECKL_R)) ' +
              'JOB(JOB_R) JOBD(GANG/GANG) ' +
              'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
              'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
              'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
              'GANG BAR_KALK DIRMAIL DIRWEB)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error SBMJOB CMD(CALL PGM(TVRELWAECO/STUECKL_R))';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //Kontrolldatei aufbauen für EDI_Kundenübersicht
       //-----------------------------------------------------------------------

       begsr srEDIKUND;

       exec sql
         delete from tvrelwaeco/EDI_KUNDEN
            where substr(kdkdnr, 8, 1) ='*';

       exec sql
         insert into tvrelwaeco/EDI_KUNDEN
         SELECT distinct
                kdkdnr,KDNAM1,KDNAM2 ,KDKOKD ,KDRAKD,KDDBKD,KDKDGR,KDKSTC,
         KDABST,char(ZVDAKDNR, 10) ZVDA_Kunde,  char(' ', 25) INbound,
                 ZVDAOFLS,ZVDAOFRE, char(KDZRKDNR, 10) KDZR_Kunde,kDZRZRKD,
         char(KZKDNR, 10)   ZKUN_Kunde,KZDFUE,KZKLAB,KZKFAB,KZKGUT,KZKZLS,
         KZKZRE,KZKDLS,KZKDRE,KZUNBN,KZKPIF,KZEDIU,KZEDIF,KZEDIB,KZZNRN,
         KZEDIL,KZORSP,KZDRRG,KZDRGU,KZPDFK,VSABST, VSEDIL,VSREAD,
         current timestamp as tstamp   FROM kund01
         left  join               zvda01 on
                        (ZVDAKDNR=KDKDNR and ZVDAfirm=KDfirm)
         left  join               kdzr01 on
                        (KDZRKDNR=KDKDNR and KDZRFIRM=KDfirm)
         left  join               zkun01 on
                        (  kzKDNR=KDKDNR and   kzFIRM=KDfirm)
         left  join               kdvs01 on
                        (  vsKDNR=KDKDNR and   vsFIRM=KDfirm)
         where  kdfirm='01' and KDKDST ='01'   order by KDKDNR;


       exec sql
         insert into tvrelwaeco/EDI_KUNDEN
         SELECT
         substr(a.kdkdnr, 1, 6) concat ' *  ',
         a.kdNAM1,a.KDNAM2,a.KDKOKD,a.KDRAKD,
         a.KDDBKD,a.kDKDGR,a.KDKSTC , a.KDABST,
         char(' ', 6), char(' ', 25),
         char(' ', 25), char(' ', 25),
         char(' ', 6), char(' ', 10), char(' ', 6),
         char(' ', 1), char(' ', 1), char(' ', 1),
         char(' ', 1), char(' ', 1), char(' ', 1),
         char(' ', 10), char(' ', 10), char(' ', 35),
         char(' ', 1), char(' ', 1), char(' ', 2),
         char(' ', 13), char(' ', 10), char(' ', 1),
         char(' ', 1), char(' ', 1), char(' ', 1),char(' ', 1),
         char(' ', 20), char(' ', 13), char(' ', 1),
         current timestamp as tstamp   FROM kund01 a
         where a.kdfirm='01' and a.KDKDST ='01'
                                             and a.kdkdnr not in
         (select b.kdkdnr from tvrelwaeco/EDI_KUNDEN b);


       exec sql
         update edi_kunden set KDRAKD = '***' concat substr(KDRAKD, 1, 7)
         where substr(KDRAKD, 1, 1) <> '*' and KDRAKD in (select KDKDNR from
         kund01 where KDfirm ='01' and KDKDST = '90');

       exec sql
         update edi_kunden set KDZRZRKD= '***' concat substr(KDZRZRKD, 1, 7)
         where substr(KDZRZRKD, 1, 1) <> '*' and KDZRZRKD in (select KDKDNR
         from kund01 where KDfirm ='01' and KDKDST = '90');

       exec sql
         update edi_kunden set ZVDA_Kunde= '***' concat
         substr(ZVDA_Kunde, 1, 7)
         where substr(ZVDA_Kunde, 1, 1) <> '*' and ZVDA_Kunde in
         (select KDKDNR from kund01 where KDfirm ='01' and KDKDST = '90');

       exec sql
         update edi_kunden set KDZR_Kunde= '***' concat
         substr(KDZR_Kunde, 1, 7)
         where substr(KDZR_Kunde, 1, 1) <> '*' and KDZR_Kunde in
         (select KDKDNR from kund01 where KDfirm ='01' and KDKDST = '90');

       exec sql
         update edi_kunden set ZKUN_Kunde= '***' concat
         substr(ZKUN_Kunde, 1, 7)
         where substr(ZKUN_Kunde, 1, 1) <> '*' and ZKUN_Kunde in
         (select KDKDNR from kund01 where KDfirm ='01' and KDKDST = '90');

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/EDI_TRANSF)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/EDI_TRANSF)        ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;


       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/EDI_KUNDE$)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/EDI_KUNDE$)        ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       exec sql
         insert into tvrelwaeco/EDI_TRANSF
         SELECT DISTINCT IFAKIFFI, IFAKKDNR, IFEDLFBK, IFEDILNR,
         dec(count(*), 8, 0) count, current timestamp tstamp FROM
         ifak01,ifed01 WHERE ifakiffi in('01', '00002', '00003') and
         IFakfirm ='01' and ifakiffi=ifediffi and ifakifnr=ifedifnr and
         ifakfirm=ifedfirm GROUP BY IFAKIFFI, IFAKKDNR, IFEDLFBK, IFEDILNR
         ORDER BY IFEDILNR;

       exec sql
         update edi_kunden set inbound =  'TECCOM'
         where KDKDNR in ( select IFAKKDNR from EDI_TRANSF
                           where kdkdnr=IFAKKDNR and ifakiffi='00003');
       exec sql
         update edi_kunden a set inbound = 'TEC001' where a.KDKDNR in
          (select b.KDEWKDNR from kdew01 b where KDEWFL09 ='TEC001' and
                          kdewfirm='01');

       exec sql
         update edi_kunden set inbound =  'HDX   '
         where KDKDNR in ( select IFAKKDNR from EDI_TRANSF
                           where kdkdnr=IFAKKDNR and ifakiffi='00002');

       exec sql
         delete from edi_transf  where
         IFEDILNR not in (select prtnum from stddat);

       exec sql
         update edi_kunden set inbound =
         ( select max(IFEDILNR) from EDI_TRANSF
                  where kdkdnr=IFAKKDNR and IFEDILNR <> ' '
                        and    inbound = ' ' and IFAKIFFI ='01'
                        group by (IFAKKDNR) )
         where exists
         ( select max(IFEDILNR) from EDI_TRANSF
                  where kdkdnr=IFAKKDNR and IFEDILNR <> ' '
                        and    inbound = ' ' and IFAKIFFI ='01'
                        group by (IFAKKDNR) );

       exec sql
         insert into tvrelwaeco/EDI_KUNDE$
         SELECT KDKDNR, KDNAM1, KDNAM2, KDKOKD, KDRAKD, KDDBKD, KDKDGR,
         KDKSTC, KDABST, ZVDA_KUNDE, INBOUND, ZVDAOFLS, ZVDAOFRE,
         KDZR_KUNDE, KDZRZRKD, ZKUN_KUNDE, KZDFUE, KZKLAB, KZKFAB, KZKGUT,
         KZKZLS, KZKZRE, KZKDLS, KZKDRE, KZUNBN, KZKPIF, KZEDIU, KZEDIF,
         KZEDIB, KZZNRN, KZEDIL, KZORSP, KZDRRG, KZDRGU, KZPDFK, VSABST,
         VSEDIL, VSREAD, min(tstamp)           FROM edi_kunden
                   GROUP BY KDKDNR, KDNAM1, KDNAM2, KDKOKD, KDRAKD, KDDBKD,
         KDKDGR, KDKSTC, KDABST, ZVDA_KUNDE, INBOUND, ZVDAOFLS, ZVDAOFRE,
         KDZR_KUNDE, KDZRZRKD, ZKUN_KUNDE, KZDFUE, KZKLAB, KZKFAB, KZKGUT,
         KZKZLS, KZKZRE, KZKDLS, KZKDRE, KZUNBN, KZKPIF, KZEDIU, KZEDIF,
         KZEDIB, KZZNRN, KZEDIL, KZORSP, KZDRRG, KZDRGU, KZPDFK, VSABST,
         VSEDIL, VSREAD;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(bar_tec/partner)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(bar_tec/partner)            ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;


       exec sql
         insert into bar_tec/partner
         SELECT substr(KDKDNR, 1, 6), substr(KDNAM1, 1, 25), substr(KDNAM2,
         1, 25), KDPOLZ , substr(KDwort, 1, 25) , substr(KDSTRA, 1, 25),
         char(' '), char(' ', 1), char(' '), char(' ', 1), char(' ', 1) FROM
         kund01, kdew01 WHERE KDEWFL09 ='TEC001' and kdewfirm='01' and
         kdewkdnr=kdkdnr and kdewfirm=kdfirm;

       endsr;

       //-----------------------------------------------------------------------
       //QM_ITEMS für QM ausgeben
       //-----------------------------------------------------------------------

       begsr QM_items;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/QM_ITEMS)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/QM_ITEMS)          ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       exec sql
         insert into tvrelwaeco/QM_ITEMS
         SELECT substr(char(rkreda), 1, 4) Jahr,
                substr(char(rkreda), 5, 2) Monat, ITEM,
                char(' ', 50) ITEMDESC,
           dec(sum(APGLMG), 12, 4) menge,    artnr , artbezfra,
                dec(0, 12, 4) WE
         FROM rpmsales# WHERE ENTITY ='DE411'
         and h1 <> 'supplement' and substr(TEPRGR, 1, 1)<>'9' and
         AKAFAT not in ('02', '03', '04', '05', '14', '31', '50', '62',
                        '63', '70', '71', '72', '84', '85', '88', '89')
         group by substr(char(rkreda), 1, 4),
                  substr(char(rkreda), 5, 2) ,ITEM, artnr , artbezfra;


       exec sql
         update  tvrelwaeco/QM_ITEMS  set ITEMDESC =
         (select b.TETBZ1 from teil01 b where tefirm = '01'     and
                                              item   =  tetenr)
          where exists
         (select b.TETBZ1 from teil01 b where tefirm = '01'     and
                                              item   =  tetenr);

       exec sql
         update  tvrelwaeco/QM_ITEMS  set we       =
         (select sum(AEMENG) from bwae  where aefirm = '01'     and
                            substr(char(AEWEDA), 1, 4) > '2014' and
          substr(char(AEWEDA), 1, 4) = Jahr  and
          substr(char(AEWEDA), 5, 2) = Monat and
          aetenr                     = item
          group by substr(char(AEWEDA), 1, 4),
                   substr(char(AEWEDA), 5, 2) ,aetenr )
          where exists
         (select sum(AEMENG) from bwae  where aefirm = '01'     and
                            substr(char(AEWEDA), 1, 4) > '2014' and
          substr(char(AEWEDA), 1, 4) = Jahr  and
          substr(char(AEWEDA), 5, 2) = Monat and
          aetenr                     = item
          group by substr(char(AEWEDA), 1, 4),
                   substr(char(AEWEDA), 5, 2) ,aetenr );



       eval p_infil   =  'QM_ITEMS' +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
       eval p_outfil =  'QM_ITEMS';

       eval p_msgf    =  *blank;
       eval p_print   =  *blank;
       eval p_lib     =  'TVRELWAECO';

       clear     Wrk.var1;
       clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/QM/QM_ITEMS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed QM_ITEMS               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object   QM_ITEMS                ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;

       eval p_outfil =  'QM_ITEMS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/QM/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done QM_ITEMS                  ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object QM_ITEMS                  ';
          exsr      SR_log;
          status = §§§MTX;
          exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //Zolltarifnummer updaten in LFS prodwin51 (umgebung EDC)
       //-----------------------------------------------------------------------

       begsr prj015p44;

       //Zollnummer
       exec sql
         UPDATE  PRODWIN51/prj015p44 a SET zollpos =
         (SELECT max(substr(zollnr, 1, 8)) from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku))
         where      exists
         (SELECT max(substr(zollnr, 1, 8)) from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku));

       //nur 8 Positionen 9 position clearen
       exec sql
          update   PRODWIN51/prj015p44
          set zollpos = substr(zollpos, 1, 8) concat ' ';

       //ABC-Kennung
       exec sql
         UPDATE  PRODWIN51/prj015p44 a SET kapgr   =
         (SELECT max(abc)                  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku))
         where      exists
         (SELECT max(abc)                  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku));


       //Gewicht Brutto aus TEGWBR
       exec sql
         UPDATE pRODWIN51/prj015p    a SET a.GEWFAK  =
         (SELECT max(gewicht)              from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku))
         where      exists
         (SELECT max(gewicht)              from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku));


       //EINK°UFR!!!!!
       exec sql
         UPDATE  PRODWIN51/prj015p44 a SET EKUSR  =
         (SELECT max(#TESAAV)  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku))
         where      exists
         (SELECT max(#TESAAV)  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku));

       //EINK°UFR!!!!!  HBMW
       exec sql
         UPDATE  PRODWIN51/prj015p44 a SET HBMW   =
         (SELECT max(#TESAAV)  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku))
         where      exists
         (SELECT max(#TESAAV)  from Bar_kalk/kalk_file where
          a.artnum=dec(artsku) and version='$$EL_PS_DB'
          and substr(artsku, 10, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 09, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 08, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 07, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 06, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 05, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 04, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 03, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 02, 1) in ('0','1','2','3','4','5','6','7','8','9')
          and substr(artsku, 01, 1) in ('0','1','2','3','4','5','6','7','8','9')
          group by dec(artsku));

       endsr;


       //-----------------------------------------------------------------------
       //tvrelwaeco/RHGEFAHRN updaten über Teilestamm
       //-----------------------------------------------------------------------

       begsr rhgefahrn;

       §records  = 0;

       exec sql
         select count(*) into :§records
         FROM teil01 WHERE tefirm = '01' and TEGFGN='LQ' and
         tetenr not in (select rgtenr from
                   tvrelwaeco/RHGEFAHRN where rgfirm= tefirm);

       //tvrelwaeco/RHGEFAHRN updaten über Teilestamm für LQ
         exec sql
           insert into tvrelwaeco/rhgefahrn
           SELECT tefirm, tetenr, 'ADR', '####', ' ', ' ', '##',
                   ' ', ' ', ' ', ' ',
           ' ', ' ', ' ', ' ', ' ', ' ',' ', ' ', ' ', 0,00, 0,00, 0,00, 0,
           0,00, ' ', 0 , ' ' FROM teil01 WHERE tefirm = '01' and TEGFGN='LQ'
           and
           tetenr not in (select rgtenr from
                     tvrelwaeco/RHGEFAHRN where rgfirm= tefirm);

       //tvrelwaeco/RHGEFAHRN updaten über Teilestamm für UN Nummern
         exec sql
           insert into tvrelwaeco/rhgefahrn
           SELECT tefirm,tetenr,'ADR','####', tegfgn,'01',tegfgs, ' ', ' ',
           ' ','' ,' ', ' ', ' ', ' ', ' ', ' ',' ', ' ', ' ', 0,00, 0,00,
           0,00, 0, 0,00, ' ', 0 , ' ' FROM teil01
                                       WHERE tefirm = '01' and (TEGFGN<>
           ' ' and TEGFGN<> '9999' and tegfgn<> '0000' and tegfgn<> 'LQ') and
           tetenr not in (select rgtenr from tvrelwaeco/RHGEFAHRN where
           rgfirm= tefirm);

       exec sql
          delete   FROM tvrelwaeco/rhgefahrn WHERE RGKL ='LQ' and
          substr(RGTENR, 1, 1) <> '#' and rgtenr     in (select tetenr from
          teil01 where tefirm='01' and TEGFGN<>'LQ');

          status='update tvrelwaeco/RHGEFAHRN ' +
                 %char(§records);
          exsr      SR_log;


       exec sql
          update  rhgefahrn set  rgbm      =
          (select TEGWBR from teil01 where
                        tefirm = '01' and TEGFGN='LQ' and
                        tetenr = rgtenr  and rgbm <> tegwbr)
          where exists
          (select TEGWBR from teil01 where
                        tefirm = '01' and TEGFGN='LQ' and
                        tetenr = rgtenr  and rgbm <> tegwbr);


       exec sql
          update  rhgefahrn set  rgnm      =
          (select TEGWNT from teil01 where
                        tefirm = '01' and TEGFGN='LQ' and
                        tetenr = rgtenr  and rgnm <> TEGWNT)
          where exists
          (select TEGWNT from teil01 where
                        tefirm = '01' and TEGFGN='LQ' and
                        tetenr = rgtenr  and rgnm <> TEGWNT);


       exec sql
          update  rhgefahrn set  rgbm      =
          (select TEGWBR from teil01 where
                        tefirm = '01' and TEGFGN<>'LQ' and
                        tetenr = rgtenr  and rgbm <> tegwbr)
          where exists
          (select TEGWBR from teil01 where
                        tefirm = '01' and TEGFGN<>'LQ' and
                        tetenr = rgtenr  and rgbm <> tegwbr);


       exec sql
          update  rhgefahrn set  rgnm      =
          (select TEGWNT from teil01 where
                        tefirm = '01' and TEGFGN<>'LQ' and
                        tetenr = rgtenr  and rgnm <> TEGWNT)
          where exists
          (select TEGWNT from teil01 where
                        tefirm = '01' and TEGFGN<>'LQ' and
                        tetenr = rgtenr  and rgnm <> TEGWNT);


       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'RHGEFAHRN' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'RHGEFAHRN';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Stammdaten/RHGEFAHRN*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed RHGEFAHRN*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object RHGEFAHRN*                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RHGEFAHRN';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Stammdaten/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for RHGEFAHRN             ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object RHGEFAHRN                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'RHGEFAHRN';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Stammdaten/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/RHGEFAHRN)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/RHGEFAHRN)    ';
       endmon;



       endsr;

       //-----------------------------------------------------------------------
       //tvrelwaeco/rpm_month ausgeben als Protokoll in Verzeichnis
       //-----------------------------------------------------------------------

       begsr rpm_month;

       §records  = 0;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(TVRELWAECO/RPM_MONTH)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(TVRELWAECO/RPM_MONTH)          ';
             exsr      SR_log;
             status = §§§MTX;
             exsr      SR_log;
       endmon;

       exec sql
         insert into tvrelwaeco/RPM_MONTH
         SELECT * FROM rpmsales# WHERE substr(RKREDA, 1, 6) =
                       :yearmonth;

       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'RPM_MONTH' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'RPM_MONTH';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/RPM/RPM_MONTH*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed RPM_MONTH*             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object RPM_MONTH*                ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RPM_MONTH';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/RPM/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for RPM_MONTH             ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object RPM_MONTH                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'RPM_MONTH';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/RPM/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/RPM_MONTH)     ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/RPM_MONTH)    ';
       endmon;



       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;
         if fkt <> *blank;
            status = fkt + ' ' + status;
         endif;
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


