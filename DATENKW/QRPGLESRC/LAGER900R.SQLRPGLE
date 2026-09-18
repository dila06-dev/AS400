      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Inventurwerte übergeben
      *               
      * November 2009   GANG, MANFRED
      * SELECT LUFIRM lbbsfirm, LULANR LBBSlanr,char(' ', 8) LBBSLORT,
      * lutenr lbbstenr, LUENDB lbbslagb,char(' ', 1) LBBSSPKZ,TEEWSKUN,
      * TEEWPRGR,temein temein , int( 20110331), int( 121212)
      * FROM lbsu, teil01, teew01
      * WHERE LUJHJJ=2011 and LUMONA=03 and LUENDB<> 0 and
      * lutenr=tetenr and lutenr=TEEWtenr
      *
      * SELECT count(*) FROM #lblb WHERE #LBLBLSTC = '900' and #LBLBBDAT
      * =20110331
      *
      *
      * SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      * LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      * char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      * temein temein , int( 20121201) datum, int( 120000) zeit
      * FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      * LBHPTENR=TEEWtenr and
      * LBHKFIRM = '01' and LBHKIVJJ = 2012 and LBHKIVNR > 8000 and
      * LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      * and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      * group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      * 14720 Sätze zu Teildatei PRJTRENDL2 in Datei PRJTRENDL2 hinzugefügt.
      *
      * zusätzlich daten für Lager 500 und 510, da  sie nicht gezählt wurden
      * SELECT lbbsfirm, LBBSlanr,char(' ', 8) LBBSLORT, lbbstenr,
      * zoned(sum(lbbslagb), 13, 4) lbbslagb,
      *           char(' ', 1) LBBSSPKZ, TEEWSKUN,TEEWPRGR, temein temein ,
      * int( 20131130) datum, int( 120000) zeit FROM LBBS011203 , teil01,
      * teew01 WHERE LBBSFIRM ='01' and LBBSLANR in ('500', '510')
      *                                                 and lbbstenr=tetenr
      * and lbbstenr=TEEWtenr and lbbsfirm =teewfirm and lbbsfirm=tefirm
      * group by lbbsfirm,LBBSlanr ,lbbstenr,TEEWSKUN,TEEWPRGR,temein
      * 574 Sätze zu Teildatei PRJTRENDL2 in Datei PRJTRENDL2 hinzugefügt.
      *
      * für Abschluß 30.11.2014  lbhkjdat=20141129, da vorher einer
      * für Abschluß 30.11.2014  aus der Norm gelaufen war
      * -----------------------
      * SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      * LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      * char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      * temein temein , int( 20141130) datum, int( 120000) zeit
      * FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      * LBHPTENR=TEEWtenr and
      * LBHKFIRM = '01' and LBHKIVJJ = 2014 and
      * lbhkivjj=2014 and lbhkjdat=20141129 and
      * LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      * and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      * group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      *
      * SELECT lbbsfirm, LBBSlanr,char(' ', 8) LBBSLORT, lbbstenr,
      * zoned(sum(lbbslagb), 13, 4) lbbslagb,
      *           char(' ', 1) LBBSSPKZ, TEEWSKUN,TEEWPRGR, temein temein ,
      * int( 20141130) datum, int( 120000) zeit FROM LBBS       , teil01,
      * teew01 WHERE LBBSFIRM ='01' and LBBSLANR in ('500', '510')
      *                                                 and lbbstenr=tetenr
      * and lbbstenr=TEEWtenr and lbbsfirm =teewfirm and lbbsfirm=tefirm
      * group by lbbsfirm,LBBSlanr ,lbbstenr,TEEWSKUN,TEEWPRGR,temein
      * Datei PRJTRENDL5 in PRODWIN51 wurde erstellt.
      *
      * 2015 inventur
      * -------------
      * insert into PRODWIN51/PRJTRENDL5
      * SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      * LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      * char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      * temein temein , int( 20151129) datum, int( 120000) zeit
      * FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      * LBHPTENR=TEEWtenr and
      * LBHKFIRM = '01' and LBHKIVJJ = 2015 and
      * lbhkivjj=2015 and lbhkjdat=20151128 and
      * LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      * and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      * group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      * 14555 Zeilen in PRJTRENDL5 in PRODWIN51 eingefügt.
      *
      * 2016 2016 Abweichungen lfs Trend
      * insert into PRODWIN51/PRJTRENDL5
      * SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      * LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      * char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      * temein temein , int( 20160630) datum, int( 234500) zeit
      * FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      * LBHPTENR=TEEWtenr and
      * LBHKFIRM = '01' and LBHKIVJJ = 2016 and
      * lbhkivjj=2016 and lbhkjdat=20160701 and
      * LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      * and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      * group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      * 1543 Zeilen in PRJTRENDL5 in PRODWIN51 eingefügt.
      *
      * aus Bestandsdatei Sicherung LBBS_  in tvrelwaeco/Q
      * SELECT LBBSFIRM, LBBSLANR, char(' ', 8) LBBSLORT , LBBSTENR ,
      * zoned(sum(LBBSLAGB), 13, 4) lbbslagb , char(' ', 1) LBBSSPKZ,
      * TEEWSKUN,TEEWPRGR,temein temein , int( 20160630) datum, int(
      * 234500) zeit FROM tvrelwaeco/lbbs_, teil01, teew01 WHERE
      * LBbsTENR=tetenr  and LBbsTENR=TEEWtenr and    TEFIRM=LBBSFIRM and
      * TEEWFIRM=LBBSFIRM and LBBSFIRM ='01' and LBBSLANR not in ('100',
      * '110', '510') GROUP BY LBBSFIRM, LBBSLANR,LBBSTENR ,
      * TEEWSKUN,TEEWPRGR,temein
      * Datei Q in TVRELWAECO wurde erstellt.
      *
      * SELECT * FROM q WHERE LBBSLANR = '500' and LBBSTENR in (select
      * lbbstenr from PRODWIN51/PRJTRENDL5 where LBBSLANR =LBBSlanr and
      * LBBSLANR ='500') ORDER BY LBBSTENR
      *
      *
      *  1.) CLRPFM FILE(PRODWIN51/PRJTRENDL5)
      *
      *  2.) Anforderung ohne Lager 100,110,500,510 aus Sicherung
      *      vom 30.06.2016 23:45
      *  SELECT LBBSFIRM, LBBSLANR, char(' ', 8) LBBSLORT , LBBSTENR ,
      *  zoned(sum(LBBSLAGB), 13, 4) lbbslagb , char(' ', 1) LBBSSPKZ,
      *  TEEWSKUN,TEEWPRGR,temein temein , int( 20160630) datum, int(
      *  234500) zeit FROM tvrelwaeco/lbbs_, teil01, teew01 WHERE
      *  LBbsTENR=tetenr  and LBbsTENR=TEEWtenr and    TEFIRM=LBBSFIRM and
      *  TEEWFIRM=LBBSFIRM and LBBSFIRM ='01' and LBBSLANR not in ('100',
      *  '110', '510', '500') GROUP BY LBBSFIRM, LBBSLANR,LBBSTENR ,
      *  TEEWSKUN,TEEWPRGR,temein
      *  19472 Sätze zu Teildatei PRJTRENDL5 in Datei PRJTRENDL5 hinzugefügt
      *              2016-06-30-23.45.00.519011
      *
      *  3.) CLRPFM FILE(PRODWIN51/PRJTRENDL5)
      *
      *  4.) Zwischenträger bilden
      *
      *  SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      *  LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      *  char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      *  temein temein , int( 20160630) datum, int( 234500) zeit
      *  FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      *  LBHPTENR=TEEWtenr and
      *  LBHKFIRM = '01' and LBHKIVJJ = 2016 and
      *  lbhkivjj=2016 and lbhkjdat=20160701 and
      *  LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      *  and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      *  group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      *  Datei P___201606 in TVRELWAECO wurde erstellt.
      *
      *  5.)  Lager 100 + 110
      *  SELECT LBBSFIRM, LBBSLANR, char(' ', 8) LBBSLORT , LBBSTENR ,
      *  zoned(sum(LBBSLAGB), 13, 4) lbbslagb , char(' ', 1) LBBSSPKZ,
      *  TEEWSKUN,TEEWPRGR,temein temein , int( 20160630) datum, int(
      *  234500) zeit FROM tvrelwaeco/lbbs_, teil01, teew01 WHERE
      *  LBbsTENR=tetenr  and LBbsTENR=TEEWtenr and    TEFIRM=LBBSFIRM and
      *  TEEWFIRM=LBBSFIRM and LBBSFIRM ='01' and LBBSLANR     in ('100',
      *  '110')               GROUP BY LBBSFIRM, LBBSLANR,LBBSTENR ,
      *  TEEWSKUN,TEEWPRGR,temein
      *  1356 Zeilen in PRJTRENDL5 in PRODWIN51 eingefügt.
      *  Buchung nicht abgeleitet
      *
      *  6.) Buchungen Bernd mit Inventurbuchung alle
      *
      *  insert into PRODWIN51/PRJTRENDL5
      *  SELECT LBHKFIRM lbbsfirm,LBHpLANR LBBSlanr,char(' ', 8) LBBSLORT,
      *  LBHPTENR  lbbstenr,  zoned(sum(LBHPBWMG), 13, 4) lbbslagb ,
      *  char(' ', 1) LBBSSPKZ,   TEEWSKUN,TEEWPRGR,
      *  temein temein , int( 20160629) datum, int( 234500) zeit
      *  FROM lbhk, lbhp, teil01, teew01 WHERE LBHPTENR=tetenr and
      *  LBHPTENR=TEEWtenr and
      *  LBHKFIRM = '01' and LBHKIVJJ = 2016 and
      *  lbhkivjj=2016 and lbhkjdat=20160701 and
      *  LBHKFIRM=LBHPFIRM and LBHKIVJJ=LBHPIVJJ and LBHKIVNR=LBHpIVNR
      *  and TEFIRM=LBHKFIRM and TEEWFIRM=LBHpFIRM and LBHKFIRM=LBHpFIRM
      *  group by  LBHKFIRM,LBHpLANR ,LBHPTENR,TEEWSKUN,TEEWPRGR,temein
      *  1543 Zeilen in PRJTRENDL5 in PRODWIN51 eingefügt.
      *
      *
      *  01.08.2016
      *  1.) CLRPFM FILE(PRODWIN51/PRJTRENDL5)
      *  2.)
      *  insert into PRODWIN51/PRJTRENDL5
      *  SELECT LUFIRM lbbsfirm, LULANR LBBSlanr,char(' ', 8) LBBSLORT,
      *  lutenr lbbstenr, LUENDB lbbslagb,char(' ', 1) LBBSSPKZ,TEEWSKUN,
      *  TEEWPRGR,temein temein , int( 20160731), int( 235555)
      *  FROM lbsu, teil01, teew01
      *  WHERE LUJHJJ=2016 and LUMONA=07 and LUENDB<> 0 and LUFIRM='01' and
      *  lutenr=tetenr and lutenr=TEEWtenr and lufirm=TEEWfirm and
      *  lufirm=tefirm
      *  20634 Zeilen in PRJTRENDL5 in PRODWIN51 eingefügt.
      *
      *  insert into PRODWIN51/PRJTRENDL5
      *  SELECT DISTINCT lblbfirm, LBlblanr, LBlbLORT, lblbtenr, LBLBBWMG*0
      *  LBLBBWMG , LBLBSPKZ,TEEWSKUN , TEEWPRGR, LBLBMEIN , int( 20210630),
      *  int( 235555) FROM lblb01,teew01 WHERE LBLBJDAT>20210100 and
      *  lblbfirm='01' and lblbtenr=TEEWtenr and lblbfirm=TEEWfirm and
      *  LBLBLANR in ('A01','A02','A03','A04','B01','B02','B04', 'B10',
      *  'B11','B12','B90','B05','B97',
      *  'C01','C02','C03','C04','C05','C06','C07', 'C08','C09',
      *  'N01','N02','N03','N04','N05','N06','N21', 'N22','N23',
      *  'N24','N25','N40','N90','N95','N97')
      *
      *
      *
      *
      *
      *
      * eval      #LBLBBDAT = 20131130             grundsätzlich ändern
      * eval      # = 20131130777777771000000000   grundsätzlich ändern
      * umwandeln
      * call      LAGER900R (#lblb - aufbau)
      * CHGDTAARA DTAARA(DATENKW/#TIMESTAM2)
      * liblist aufbauen
      *         QTEMP                   SFBS
      *         PROGPRJ2                SMDIBS002
      *         PROGAFPN                TMNP
      *         PROGAFP                 MODWAO
      *         PROGN                   TAMF
      *         PROG                    TAMP
      *         PRODWIN51               TVPF
      *         PROD                    TVPP
      *         QGPL                    TFXF
      *         TEST                    DATENKW
      *         SFBF                    TVRELWAECO
      *         SASF                    BAR_KALK
      *         SFB                     GANG
      *         SAS
      *         SASS
      *
      * CALL PGM(LAGERBEW3R) PARM('$$EL_PS_DB' '0' '0')
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fPRJTRENDL5ip   e             disk    RENAME(PRJTRENDL5:phy00r)
      *                                                                     ----
     f#lblb     uf a e           k disk
     F                                     RENAME(#LBLBR:phy01r)
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------

     C                   clear                   phy01r
     C                   eval      #ERRORTXT='Korrektur Inventur'
     C                   movel     LBBSFIRM      #LBLBFIRM
     C                   eval      #         = #   + 1
     C                   eval      #LBLBTMST = #
     C                   eval      #LBLBLANR = LBBSLANR
     C                   eval      #LBLBLORT = LBBSLORT
     C                   eval      #LBLBTENR = LBBSTENR
     C                   eval      #LBLBBWMG = LBBSLAGB
     C                   eval      #LBLBLSTC = '900'
     C                   eval      #LBLBMEIN = TEMEIN
     C                   eval      #LBLBBWME = TEMEIN
     C                   eval      #LBLBBDAT = 20210731
     C                   eval      #LBLBPROG = 'LAGER900R'
     C                   write     phy01r
     C*
     C**************************************************************************
     C*update
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C*
     C     ##3000        ENDSR

     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   clear                   #                26 0
     C                   eval      # = 20210731000009999900000000
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
