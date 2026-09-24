     h option(*SRCSTMT:*NoDebugIO)
     ******************************************************************
      * PROGRAMMNAME.:FTPI002r          0761/8888038 SZ                       
      * FUNKTION.....:holen Aufträge             010 Burkart
      *               CALL PGM(MODWAOREL/STRTRDREL)
      * Konditionen:  a) feld: ifapIFNR in der ifap entspricht
      *                        Auftrags# im Fremdsystem
      *               b) es besteht Positionstreue zwischen den Systemen
      *               call trlftest Kom-date lead time
      *
      *                SELECT * FROM trtp WHERE TPTCDE = 'AFDA'
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      *  1.)  es wird *defaulf das Datum eingetragen, welches dem nächst
      *  möglichen Auslieferungstermin entspricht
      *        (das Datum entspricht nur einem Wunschtermin)
      *  2.) das übergebene Datum entspricht dem Datum, wann geliefert
      *  werden soll, daraus errechnet sich auch der Kom-Termin
      *       ( mehr als nur Wunschtermin )
      *  3.) es erfolgt eine Berechnung auf Basis der Kalenderdaten, d.h.
      *  Feiertage werden sowohl in Deutschland als auch
      *       in Österreich berücksichtigt.
      *
      *H310 Character 419  EDC N 803 1221 Free
      *H311A Character 2   Sc N 1222 1223 COD Forwarder service way
      *H311B Character 2   Sc N 1224 1225 COD Forwarder service way
      *H311C Character 5   Sc N 1226 1230 COD Forwarder service way
      *H311D Character 1   Sc N 1231 1231 COD Forwarder service day/night
      *H311E Character 3   Sc N 1232 1234 COD currency
      *H311F Numerical 5 2 Sc N 1235 1239 discount
      *H311G Numerical 5 2 Sc N 1240 1244 tax
      *H311H Numerical 8 2 Sc N 1245 1252 amount
      *H311I Numerical 6 2 Sc N 1253 1258 delivery cost
      *H311J Numerical 6 2 Sc N 1259 1264 packing cost
      *H311K Numerical 6 2 Sc N 1265 1270 insurance cost
      *
      *SELECT h050,
      *substr(h310, 0420, 2) servWay1  ,substr(h310, 0422, 2) servWay2,
      *substr(h310, 0424, 5) servWay3  ,substr(h310, 0429, 1) coddayni,
      *substr(h310, 0430, 3) currency  ,substr(h310, 0435, 5) discount,
      *substr(h310, 0438, 5) tax       ,substr(h310, 0443, 8) amount  ,
      *substr(h310, 0451, 6) delivery  ,substr(h310, 0457, 6) package ,
      *substr(h310, 0463, 6) insurance ,substr(h310, 0420, 49) image,h360
      *FROM orderh where substr(h310, 0420, 49) <>' '  and  H030=   55278
      *and  substr(h310, 0420, 49)  not like '%      0       %'
      *and  substr(h310, 0420, 49)      like '%,%'
      *
      *
      *
      *
      *
      *  _ #DC4804 Positionen Sicherung nach Input
      *  _ #DC4805 Kopfsätze  Sicherung nach Input
      *  _ 54939 Österreich bei 16 bzw. 15 mit 8 zusatz also 815 oder 816
      *
      * Anina Rücksprach 20.02.2015
      * ===========================
      * update       afko set akvsbd='008'
      *                          WHERE akvsbd ='   ' and AKAFST < '89' and
      * akfirm='01' and akmaaf > ' '
      *
      * 01.02.2016  HDX Freigabe bestimmter Rechnungen
      * Freigabe erfolgt später über Status 35 in den Positionen und
      * dem Kopf; beide brauchen von Status 35 anstelle des Status 30
      * ==> nach Feststellung alles OK auf 35 setzten
      *Pascale direkte Umsatzung Mail Henk 20.06.2016
      *update        afko01 set   AKvsbd = '011'
      *                     WHERE AKvsbd <>'011' and AKFIRM = '01' and
      *AKKDNR ='088505' and AKAFST < '90' and akmaaf in (select h050 from
      *orderh where h100 like '%SPBI SA%' )
      *
      *19.01.2018 alle f informationen auch auf lieferschein
      * 2018/608957   bei text spedition TXSP ==> auch druckkz L
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      * mg01 c   93              exsr      sr2300k
      * mg02     timestamp lesen bei auftragswechsel sr9999
      *
      * h210 bei Teccom 00003 beinhaltet den Warenempfänger
      *      des Kunden
      * 008239  trend 900000
      * SELECT IFAKVSNR FROM ifak01 WHERE IFAKIFNR
      * ='2022-07-20-08.00.26.145000'
      *
      *
      *
      *
      *
      *****************************************************************

     forderhl1  up   e           k disk
     forderll1  uf   e           k disk

     f#IFAKL1   uf a e           k disk
     f#IFAPL1   uf a e           k disk
     f##IFAP    uf a e             disk    RENAME(IFAP1:##ifap1)
     fifad      uf a e           k disk
     fifat      uf a e           k disk
     f##ifat    uf a e             disk    RENAME(IFAT1:##ifat1)
     fifan      uf a e           k disk
     fifed      uf a e           k disk
     fifep      uf a e           k disk
     fwao8      uf a e           k disk
     fordermsgh uf a e           k disk
     fordermsgl1if   e           k disk    RENAME(ORDERMSGHF:log01r)
     fteil01    if   e           k disk
     fkpif02    if   e           k disk
     fkdvs01    if   e           k disk
     fkund01    if   e           k disk
     fifat01    if   e           k disk    RENAME(IFAT1:$$ifat1)
     fCOUMAP    if   e           k disk

     DDate             S               D   DATFMT(*iso)
     D##date           S               D   DATFMT(*iso)
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
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     ****
     D EXIFAK        E DS                  INZ
     D RTIFAK        E DS                  INZ
     D*
     I*-------------------------------------------------------------------------
     d d_head          DS                  INZ
     D  §orh310                1      2
     D  §orh315                3      4
     D  §orh316                5      9
     D  §orh400               10     10
     D  §orh420               11     13
     D  §orh430               14     18
     D  §orh440               19     23
     D  §orh410               24     31
     D  §orh450               32     37
     D  §orh460               38     43
     D  §orh470               44     49
     D*                                    prefix('§')
     D Ch              DS
     D  ch1                    1     20    INZ(' !!!! Achtung !!!   ')
     D  ch2                   21     40    INZ('Häfele Etiketten    ')

     D Chx             DS
     D  chx1                   1     20    INZ('Auftrag in Trend ein')
     D  chx2                  21     40    INZ('geleitet ==> siehe R')
     D  chx3                  41     50    INZ('eferenzen ')

     D Chx4            DS
     D  dst                    1     44    INZ('wichtiger Hinweis             ')

     D Chx5            DS
     D  LONGMSG1               1    132    INZ('Datei prüfen                  ')
     D  LONGMSG2             133    264    INZ('Artikel 207205701 in Order    ')
     D  LONGMSG3             265    396    INZ('Info an Ingo Schlemper        ')
     D chrc            S              1    DIM(1024)
     D address         S              1    DIM(1024)

     I*-------------------------------------------------------------------------
     DmField           s             30A
     DmScan            S              4a
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #h030
     C********           if        #h030     = 0000003
     C********           eval      #h030     = 9993993
     C********           endif

     c                   if        #h030   =78146 and
     c                             ( %subst(h310:501:12) = '08700       ' or
     c                               %subst(h310:501:12) = '08701       ' or
     c                               %subst(h310:501:12) = '08702       ' or
     c                               %subst(h310:501:12) = '08703       ' or
     c                               %subst(h310:501:12) = '08704       ' or
     c                               %subst(h310:501:12) = '08705       ' or
     c                               %subst(h310:501:12) = '08706       ' or
     c                               %subst(h310:501:12) = '08707       ' or
     c                               %subst(h310:501:12) = '08708       ' or
     c                               %subst(h310:501:12) = '08709       ' or
     c                               %subst(h310:501:12) = '08711       ' or
     c                               %subst(h310:501:12) = '08788       ' or
     c                               %subst(h310:501:12) = '08710       ' )
     c                   eval        h050     =    'on hold   '
     c                   endif

     C******** 20211108
     C******** h140      FROM orderh WHERE H030 =40631 and substr(h310, 501, 2)='BT'
     c***                if        #h030   =40631 and
     c***                          %subst(h310:501:02) = 'BT'
     c***                eval      h140='XI'
     c***                endif

     c                   if        #h030   =55278
     c******             z-add     77777         #h030
     c                   endif
     c                   if        #h030   =78678
     c                   z-add     78678         #h030
     c                   endif

     C     *LIKE         DEFINE    h030          #h030

     C     *LIKE         DEFINE    IFAKIFNR      $IFAKIFNR

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C                   seton                                        30
     C*                 Stammdatenauftrag Workist
     C                   if        #h030     = 00035
     C                   movel     'WORKIST  '   §§§usr
     C                   endif
     C                   if        #h030     = 00055
     C                   movel     'B2BB2C   '   §§§usr
     C                   endif
     C                   if        #h030     = 0000003
     C                   movel     'TECCOM   '   §§§usr
     C                   endif
     C                   if        #h030     = 0000025
     C                   movel     'EASYIMPORT'  §§§usr
     C                   endif
     C                   if        #h030     = 0000008
     C                   movel     'LASERNET '   §§§usr
     C                   endif
     C                   if        #h030     = 0000002
     C                   movel     'HDXORDER '   §§§usr
     C                   endif
     C*                 dcs dometic claim system internetuser
     C                   if        #h030     = 0000005  and
     C*************                #h030     = h030
     C                             h330      = 'DCS       '
     C                   movel     h330          §§§usr
     C                   endif
     c                   setoff                                       77
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   seton                                        77
     C                   endif
     C                   if         h050     =    'CZS022219 ' or
     C                              h050     =    'CZS022219 ' or
     C                              h050     =    'CZS022219 '
     C                   clear                   xcxx              1
     C                   endif
     C                   if        (#h030     =    h030         and
     C                              h050     <>   'on hold   ') or
     C                             (#h030     =    0000005 and
     C                              h330      =    'DCS       ')
MG02 c                   exsr      sr9999
     C                   exsr      srlines
     C*                 update Protokoll Header
     c                   exsr      sr2900
     c                   unlock    #IFAKL1
     c                   unlock    #IFAPL1
     c                   unlock    ifad
     c                   unlock    ifat
     c                   unlock    ifan
     c                   unlock    ifed
     c                   unlock    ifep
     c                   unlock    wao8
     c                   exsr      aifak
     c                   if        IFAKIFFI = '00003'     or
     c                             IFAKIFFI = '00025'     or
     c                             IFAKIFFI = '00035'     or
     c*********                    IFAKIFFI = '00055'     or
     c                             IFAKREF2 = 'ORDERFTEST' or
     c                             IFAKIFFI = '00008'     or
     c                             IFAKIFFI = '00009'     or
     c                             IFAKIFFI = '00004'     or
     c                             IFAKIFFI = '00077'     or
     c                             IFAKIFFI = '00005'     or
     c****** test hdx in interface lassen
     c**********************       IFAKIFFI = '00002'     or
     c                             IFAKIFFI = '42364'     or
     c                             IFAKIFFI = '91453'     or
     c                             IFAKIFFI = '96690'     or
     c                             IFAKIFFI = '52774'     or
     c                             IFAKIFFI = '02511'     or
     c                             IFAKIFFI = '72511'     or
     c************Achtung!!!!!! erst in interface
     c**** Freigabe erteilt        IFAKIFFI = '88505'     or
     c**** 15.06.2020              IFAKIFFI = '40631'     or
     c                             IFAKIFFI = '40642'     or
     c**** 31.01.2025              IFAKIFFI = '40670'     or
     c**** stop for Virus          IFAKIFFI = '55278'     or
     c****                         IFAKIFFI = '78146'     or
     c****                         IFAKIFFI = '15177'     or
     c****                         IFAKIFFI = '62765'     or
     c****                         IFAKIFFI = '78678'     or
     c                             IFAKIFFI = 'x8505'     or
     c                             IFAKIFFI = 'x8505'     or
     c                             IFAKIFFI = 'x8505'     or
     c                             IFAKIFFI = 'x8505'     or
     c                             IFAKIFFI = 'x8505'     or
     c************Achtung!!!!!!
     c                             *in71='1'
     c                   else
     c                   exsr      GNIFAK
     c                   exsr      message
     c                   exsr      sr_aksarg
     c                   exsr      sr_inco
     c                   exsr      sr_hinw
     c   79              exsr      sr_oem
     c                   if        *in81 = '1'
     c  n79              exsr      sr_fix
     c                   endif
     c                   exsr      sr_VSBD
     c                   exsr      sr_akkosp
     c                   setoff                                       79
     C                   endif
     c                   if        IFAKIFFI = 'xxxxx'     or
     c                             IFAKIFFI = '01887'
     c                   exsr      message
     c   79              exsr      sr_oem
     c                   if        *in81 = '1'
     c  n79              exsr      sr_fix
     c                   endif
     c                   exsr      sr_VSBD
     c                   exsr      sr_akkosp
     c                   setoff                                       79
     C                   endif

     C                   if         h050     =    'ZS0231785 ' or
     C                              h050     =    'ZS0231785 ' or
     C                              h050     =    'ZS0231785 '
     C                   clear                   xcxx              1
     C                   endif

     C*                 Routine Mail Auftragsbestätigung
     C                   if        ifakiffi = '78678'       or
     C                             ifakiffi = '78680'
     C                   eval      eMail='ada.glowacka@dometic.com'
     C                   endif
     C*                 Routine Mail Auftragsbestätigung
     C*                 funtioniert nur, wenn Auftrag generiert wurde
     c                   if        ( IFAKIFFI = '88505'     or
     c                               IFAKIFFI = '40631'     or
     c                               IFAKIFFI = '40670'     or
     c                               IFAKIFFI = '40642'     or
     c                               IFAKIFFI = '55278'     or
     c                               IFAKIFFI = '35671'     or
     c                               IFAKIFFI = '78146'     or
     c                               IFAKIFFI = '15177'     or
     c                               IFAKIFFI = '62765'     or
     c                               IFAKIFFI = '78680'     or
     c                               IFAKIFFI = '78678'     or
     c                               IFAKIFFI = '98264'        ) and
     c                               eMail <> *BLANK
     c                   exsr      sr9991
     c                   movel     $IFAKAFJJ     #IFAKAFJJ         4
     c                   clear                   xifakiffi
     c                   movel     '0'           xifakiffi
     c                   eval      %subst(xIFAKIFFI:02:05) = IFAKIFFI
     c
     C*                 Routine Mail Auftragsbestätigung
     C                   if        $IFAKAFNR  <> *blank
     C                   CALL      'KDAP_GENR'
     C                   PARM                    xIFAKIFFI        10
     C                   PARM                    eMail            60
     C                   PARM                    #IFAKAFJJ         4
     C                   PARM                    $IFAKAFNR
     C                   PARM                    §§§job
     C                   PARM                    §§§usr
     C                   PARM                    §§§pgm
     C                   PARM                    §§§LIB
     C
     C*                 Routine Mail Auftragsbestätigung
     C*                 Druckkennzeichen im Auftragskopf auf "Y für
     C*                 Mail
     C*                 ab 7.12.2012 beinhalten die Strukturen auch
     C*                 die Rückgabeinhalte
     C                   movel     RTIFAKAFJJ    ###FAKAFJJ        4
     C                   CALL      'WAO038'
     C                   Parm                    RTIFAKIFFI
     C                   parm                    ###FAKAFJJ
     C                   parm                    RTIFAKAFNR
     C                   exsr      mailaddon
     C                   endif
     C                   endif

     C*                 Routine Mail Auftragsbestätigung Besonderheit
     C*                 Siegen 098264 und Feld H020=220034 Fendt
     C*                 04.07.2024 #SR-302748
     c                   if        H020 = 300117 and h030 = 98264 and
     C                             $IFAKAFNR  <> *blank
     C                   eval      eMail='Verwaltung-WKL@fendt-caravan.de'
     C                   CALL      'KDAP_GENR'
     C                   PARM                    xIFAKIFFI        10
     C                   PARM                    eMail            60
     C                   PARM                    #IFAKAFJJ         4
     C                   PARM                    $IFAKAFNR
     C                   PARM                    §§§job
     C                   PARM                    §§§usr
     C                   PARM                    §§§pgm
     C                   PARM                    §§§LIB
     C                   endif
     C
     C*                 Routine Sicherung Auftragsdaten
     c                   exsr      sr_save
     C*                 confirmation generieren
     c                   exsr      confirm
     C*                 mailout
     c                   if        mailout  = '1'
     c                   exsr      sr_mail
     C                   endif
     c                   movel     '0'           mailout           1
     C                   endif
     c                   if        ifakiffi='00099' and
     c                             #h030= 900000    and
     c                              h030= 900000
     C*                 confirmation generieren
     c*                  exsr      confirm
     c                   endif

     C**************************************************************************
     C*lesen Positionen aus interface
     C*-------------------------------------------------------------------------
     C*
     C     srlines       BEGSR

     C     KEYlines      KLIST
     C                   KFLD                    h030
     C                   KFLD                    h050

     c                   setoff                                       81

     C     KEYlines      SETLL     orderll1
     C                   DO        *HIVAL
     C     KEYlines      READE     orderll1                               91
     C   91              LEAVE
     C*                 sc # und auftrag müssen identisch sein
     C                   if        l250  <> h030    or
     c                             l040  <> h050
     c                   leave
     c                   else
     c                   exsr      sr1000
     c                   endif
     C                   ENDDO
      *
     C     ##lines       ENDSR

     C**************************************************************************
     C*lesen Kopfsatz in Trend z.B: 88505 und Auftrags# Fremdsystem
     C*lesen Possatz in Trend z.B: 88505 und Auftrags# Fremdsystem und Pos#
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     C     KEYkopf       KLIST
     C                   KFLD                    IFAKIFFI
     C                   KFLD                    IFAKIFNR
     c                   move      h030          ifakiffi
     c                   movel     h050          ifakIFNR
     c                   if        h030  = 900000
     C*                 Testdaten aus 365 ORDERFTEST
     c                   move      '00099'       ifakiffi
     c                   endif
     c     keykopf       chain     #IFAKL1                            92

     C     KEYpos        KLIST
     C                   KFLD                    IFApIFFI
     C                   KFLD                    ifapIFNR
     C                   KFLD                    ifapifpo
     c                   eval      IFApIFFI   =  IFAkIFFI
     c                   eval      ifapIFNR   =  ifakIFNR
     c                   z-add     l050          ifapifpo
     c*****              eval      ifapifpo   =  l050
     c                   if        ifapifpo   =  *zero
     c                   z-add     999           ifapifpo
     c                   endif
     c
     c                   if        IFAKIFFI = '08138'  and
     c                             h170 <> *blank
     c                   eval      h180 = 'H'
     c                   endif

     c     keypos        chain     #IFAPL1                            93

MG02 c****               exsr      sr9999

     C*                 Kopfdaten Trend bei *in92 = '1'
     c   92              exsr      sr2000
     C*                 Sendungsdaten Trend bei *in92 = '1' Ebene 92
     c   92              exsr      sr2200
     C*                 Incoterms aufbereiten aus h160
     c                   clear                   incoterm         65
     c                   clear                   mScan
     c                   clear                   pos
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671' or
     c                             IFAKIFFI = '78678' or
     c                             IFAKIFFI = '78680'
     c                   eval      mScan  = '  '
     c                   eval      pos = %scan(mScan: h160)
     c                   if        pos = 0 or pos > 28
     c                   eval      pos = 30
     c                   endif
     c                   eval      incoterm      =
     c                                     %subst(h160:1:pos ) +
     c                                         ', Incoterms 2010'
     c                   endif
     c
     C*                 Textdaten Trend bei *in92 = '1' Ebene 92
     c                   setoff                                       202122
     c                   clear                   p                 3 0
     c                   if        h180 = 'H' or h180 = 'F' or h180 = 'B'
     c                   seton                                        20
     c   92              exsr      sr2300
     c                   endif
     c                   if        h200 = 'H' or h200 = 'F' or h200 = 'B'
     c                   seton                                        21
     c   92              exsr      sr2300
     c                   endif
     c                   if        h220 = 'H' or h220 = 'F'
     c                   seton                                        22
     c   92              exsr      sr2300
     c                   endif
     C*                 Tesco
     c                   if        IFAKIFFI = '40631' and
     c                             H020 =  1001798
     c   92              exsr      srTESCO
     c                   endif
     C*                 MGD Products Ltd
     c                   if        IFAKIFFI = '40631' and
     c                             H020 =  644871
     c   92              exsr      srMGD
     c                   endif
     C*                 AO RETAIL LTD
     c                   if        IFAKIFFI = '40631' and
     c                             H020 =  1002638
     c   92              exsr      srRETAIL
     c                   endif
     C*                 Robert Dyas
     c                   if        IFAKIFFI = '40631' and
     c                             H020 =  1001969
     c   92              exsr      srDyas
     c                   endif
     C*                 EDIdaten Trend bei *in92 = '1' Ebene 92
     c   92              exsr      sr2250
     C*                 Sonderinfos für Benelux Ebene kopf
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   clear                   p                 3 0
mg01 c   92              exsr      sr2300k
     c                   endif

     C*                 zusätzliche eMail Adressierungen  xyz
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671'
     c                   clear                   p                 3 0
mg01 c   92              exsr      sr2300k
     c                   endif

     C*                 zusätzliche eMail Adressierungen  xyz
     c                   if        IFAKIFFI = '00077'
mg01 c                   exsr      sr2300Bank
     c                   endif

     C*                 Speditionsinformationen
     c                   if        H280   ='401 -                  '
     c                   clear                   H280
     c                   endif
     c                   if        H280   <> ' ' or H290   <> ' '
     c                   if        H280   =  H290
     c                   eval      H290   =        *blank
     c                   endif
mg01 c   92              exsr      sr2300spd
     c                   endif
     C*                 Warehouse Informationen
     c                   if        H180 = 'W' or H200 ='W' or H220 ='W' or
     c                             H180 = 'B' or H200 ='B'
mg01 c   92              exsr      sr2300wae
     c                   endif

     C*                 lesen über KPIF, da evtl. Hauptartikel nur in
     C*                 kpif hinterlegt wegen sku-Anpassung
     c                   if        IFAKIFFI <>'55278'  or
     c                             IFAKIFFI <>'35671'
     c   93              exsr      sr9992
     c                   endif
     C*                 Positionsdaten Trend bei *in93 = '1'
     c   93              exsr      sr2100
     C*                 Textdaten Trend bei *in93 = '1' Ebene 93
     c                   setoff                                       202122
     c                   clear                   p                 3 0
     c                   if        h180 = 'L'
     c                   seton                                        20
     c   93              exsr      sr2300
     c                   endif
     c                   if        h200 = 'L'
     c                   seton                                        21
     c   93              exsr      sr2300
     c                   endif
     c                   if        h220 = 'L'
     c                   seton                                        22
     c   93              exsr      sr2300
     c                   endif
     c                   if        IFAKIFFI = '88505' and l110 <> ' '
     c   93              exsr      sr2300art
     c                   endif
     C* 28.04.2026      Stammdatenauftrag B2BB2C wenn Daten
     C* 28.04.2026      einfliessen über B2B 28.04.2026
     C* 28.04.2026      l150 65 Byrtes
     C   93              if        IFAKIFFI = '00055' and
     C                             (%subst(l150:001:65) <> ' '  or
     C                              %subst(l150:066:65) <> ' ' )
     c   93              exsr      srB2BPos
     C                   endif
     c                   if        IFAKIFFI = '00005' and l110 <> ' '
     c   93              exsr      sr2300art
     c                   endif
     C*                 italy also 25.09.2013
     c                   if        IFAKIFFI = '55278' and l110 <> ' '
     c   93              exsr      sr2300art
     c                   endif
     c                   if        IFAKIFFI = '35671' and l110 <> ' '
     c   93              exsr      sr2300art
     c                   endif
     C*                 Siegen also 26.05.2017
     c****               if        IFAKIFFI = '98264' and l110 <> ' '
     c** 93              exsr      sr2300art
     c****               endif
     C*                 HDX 15.02.2024 Erweiterungen Dirk/Anja  20240228 Achtung ohne *in93
     c                   if        H330     = 'HDXORDER' and
     c                             (%subst(l150:001:10) <> ' ' or
     c                              %subst(l150:415:10) <> ' ' or
     c                              %subst(l150:433:15) <> ' ' )
     c***93              exsr      sr2300art
     c                   exsr      sr2300art
     c                   endif
     C*                 Sonderinfos für Benelux/Siegen Ebene Position
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765' or
     c                             IFAKIFFI = '98264' or
     c                             IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671'
     c                   clear                   p                 3 0
     c   93              exsr      sr2300p
     c   93              exsr      sr2260
     c                   endif

     c                   IF        IFAKIFFI =  '02511'  or
     c                             IFAKIFFI =  '72511'
     c                   eval      l070 = 'J'
     c                   endif

     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                             and ( IFAKIFFI <> '15177'  and
     c                                   IFAKIFFI <> '72511'  and
     c                                   IFAKIFFI <> '98264' )
     c   93              exsr      sr2265
     c                   endif
     c
     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                   seton                                        81
     c                   endif


     C*                 zusätzliche eMail function
     c                   if        (( IFAKIFFI = '55278' or
     c                                IFAKIFFI = '35671' or
     c                                IFAKIFFI = '88505' or
     c                                IFAKIFFI = '78678' or
     c                                IFAKIFFI = '78680' or
     c                                IFAKIFFI = '40670' or
     c                                IFAKIFFI = '40642' or
     c                                IFAKIFFI = '40631')
     c                                and H310 <> *blank )
     c                   clear                   umlaut            1
     c                   clear                   umlaut2           2
     c                   clear                   pos               3 0
     c                   clear                   pos2              3 0
     c                   clear                   n_                3 0
     c                   eval      umlaut  = '@'
     c                   eval      umlaut2 = '##'
     c                   eval      pos = %scan(umlaut: h310)
     c                   eval      pos2= %scan(umlaut2: h310)
      *Zeichen
     c   92              if        pos > 0 and pos2 > 0  and *in92='1'
     C                   clear                   address
     C                   setoff                                       61
     C                   setoff                                       62
     C                   movea     h310          chrc
     C     pos2          do        120           n_
     C     chrc(n_)      ifeq      '#'
     C     #address      ifne      *blank
     c                   movea     address       #address       1024
     c                   eval      h600x     =   %subst(h310:1:03)
     c                   eval      h610x     =   %trim(#address)
     c                   if        h610x  <> ' '
     c   62              movel     date          h360
     c   62              movel     tstampi       h370
     c   62              write     ordermsghf
     c***62***********   exsr      sr_t_and_t ==> im Nachlauf über sql
     c                   endif
     C   62              clear                   h600x
     C   62              clear                   h610x
     C   62              clear                   address
     C   62              clear                   #address
     C                   endif
     C   61              seton                                        62
     C                   seton                                        61
     C                   else
     C   62              move      chrc(n_)      address(n_)
     C   62              movea     address       #address
     C   62              setoff                                       61
     C                   endif
     C                   enddo
     C*
     c                   movea     address       #address       1024
     c                   eval      h600x     =   %subst(h310:1:03)
     c                   eval      h610x     =   %trim(#address)
     c                   if        h610x  <> ' '
     c                   movel     date          h360
     c                   movel     tstampi       h370
     c                   write     ordermsghf
     c***62***********   exsr      sr_t_and_t ==> im Nachlauf über sql
     c                   endif
     c                   clear                   h600x
     c                   clear                   h610x
     c                   clear                   address
     c                   clear                   #address
     c                   endif
     c                   endif

     c                   if        L110  <>  *blank  or
     c                             IFAKIFFI = '00003'
     c   93              exsr      sr2280
     c                   endif


     C*                 update Protokoll line
     c                   exsr      sr2800

      *
     C     ##1000        ENDSR

     C**************************************************************************
     C*übergaben Kopf KOPFEBENE Kopfdatei
     C*ifakvsbd  = spediteur/versandbedingung  '014' z.B Hellmann  UK
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
      *
     C*                 Kopfdaten Trend
     c                   setoff                                       79
     c                   clear                   IFAK1
     c                   move      h030          ifakiffi
     c                   if        h030  = 900000
     C*                 Testdaten aus 365
     c                   move      '00099'       ifakiffi
     c                   endif
     c                   movel     date          ifakueda
     c                   movel     zeit          ifakueuz
     c                   movel     date          IFAKERDA
     c                   movel     zeit          IFAKEZEI
     c                   movel     date          ifakJDAT
     c                   movel     zeit          ifakJZEI
     C                   movel     'EDI    '     IFAKKDSB
     C                   movel     §§§usr        IFAkUSER
     C                   movel     §§§pgm        IFAkPROG
     C                   movel     §§§job        IFAkjnam
     C                   movel     §§§LIB        IFAkbibl
     C                   movel     '01'          IFAkfirm
      *
     c                   movel     '*  '         ifAKSABE
     c                   if        IFAKIFFI = '00002' and
     C                             H300    =     'ZEUZEM    '
     c                   movel     'ZEU'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '00002' and
     C                             H300    =     'HOFFMANNDI'
     c                   movel     'DH '         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '00002' and
     C                             H300    =     'HALIM     '
     c                   movel     'HAM'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '00002' and
     C                             H300    =     'HARTMANN  '
     c                   movel     'HRT'         ifAKSABE
     C                   endif
     c                   if        %subst(h300:57:04) ='BGFS'
     c                   movel     '*  '         ifAKSABE
     c                   endif
     c                   if        IFAKIFFI = '88505'
     c                   movel     '#01'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '40631' or
     c                             IFAKIFFI = '40670' or
     c                             IFAKIFFI = '40642'
     c                   movel     '#02'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '15177'
     c                   movel     '#03'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '62765'
     c                   movel     '#04'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '55278'
     c                   movel     '#05'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '35671'
     c                   movel     '#05'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '01887'
     c                   movel     '#06'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '78146'
     c                   movel     '#07'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '08138'
     c                   movel     '#08'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '02921'
     c                   movel     '#09'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '05084'
     c                   movel     '#11'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '42634'
     c                   movel     '#12'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '98264'
     c                   movel     '#13'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '78678' or
     c                             IFAKIFFI = '78680'
     c                   movel     '#14'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '91453'
     c                   movel     '#15'         ifAKSABE
     C                   endif
     C*                 Stammdatenauftrag Workist
     C                   if        #h030     = 00035
     c                   eval      ifAKSABE  = %subst(h300:001:03)
     C                   endif
     C*                 Stammdatenauftrag B2BB2C übersteuern
     C                   if        #h030     = 00055
     c                   eval      ifAKSABE  = %subst(h300:001:03)
     c                   eval      ifAKSABE  = 'B2B'
     C                   endif
     C*                 dcs dometic claim system internetuser
     C                   if        #h030     = 0000005
     c                   exsr      srDCS_ADR
     c                   movel     'GAR'         ifAKSABE
     c                   eval      ifAKSABE  = %subst(h310:232:03)
     C                   endif
     C*                 dcs dometic claim system internetuser
     C                   if        #h030     = 0000077   or
     C                             #h030     = 0000079
     c                   movel     'GA '         ifAKSABE
     C                   endif
     c                   movel     h050          ifakifnr
     c     ' ':'0'       xlate     h250          h250
     c                   move      h250          ifakafat
     c                   if        (h250  = '1' or h250 = 'J')
     c****** Mats                  ( IFAKIFFI = '40631' or
     c****** 01.08.2013              IFAKIFFI = '78678' or
     c******                         IFAKIFFI = '88505' )
     c                   seton                                        79
     c                   endif
     c                   movel     '08 '         ifakafat
     C*                 dcs dometic claim system internetuser
     C                   if        #h030     = 0000005
     c                   movel     '17 '         ifakafat
     c                   eval      ifakafat = %subst(h310:229:02)
     C                   endif
     c                   if        IFAKIFFI  = '00003'
     c                   movel     '27 '         ifakafat
     c                   endif
     c                   if        IFAKIFFI  = '00025'
     c                   movel     '01 '         ifakafat
     c                   endif
     C*                 Stammdatenauftrag Workist
     C                   if        #h030     = 00035
     c                   movel     '01 '         ifakafat
     C                   endif
     C*                 Stammdatenauftrag wie Workist
     C                   if        #h030     = 00055
     c                   movel     '01 '         ifakafat
     C                   endif
     c                   if        IFAKIFFI  = '00008'
     c                   movel     '01 '         ifakafat
     c                   endif
     c                   if        IFAKIFFI  = '00009'
     c                   movel     '01 '         ifakafat
     c                   endif
     c                   if        IFAKIFFI  = '00002'
     c                   movel     '26 '         ifakafat
     C                   if        H300    =     'HARTMANN  '  or
     c                             H300    =     'ZEUZEM    '
     c                   movel     '08 '         ifakafat
     c                   endif
     c                   endif
     C*                 webOrder
     C                   if        #h030     = 0000077
     c                   movel     '81 '         ifakafat
     C                   endif
     C                   if        #h030     = 0000079
     c                   movel     '01 '         ifakafat
     C                   endif
     c                   move      h040          ##h040            6
     c                   movel     ##h040        ifakkdnr
     C*                 Frankreich Dachser Renault  20211206    088510 eigener Kunde
     C                   if        #h030     = 0088505   and
     C                             (h020      = 5007913  or
     C                              h020      = 5007935  )
     C*                 Frankreich Dachser Renault   229677   17.02.2022
     C                   movel     '088510    '  ifakkdnr
     C                   endif
     c                   clear                   #IFAKVSBD
     c*
     c                   if        IFAKIFFI <> '00003' and
     c                             h230     <> '  '
     c                   move      h230          IFAKVSBD
     c                   movel     '0'           IFAKVSBD
     c                   endif
     c*  übergaben aus Italien teilweise falsch
     c                   if        IFAKIFFI = '55278'  or
     c                             IFAKIFFI = '35671'
     c                   move      h230          IFAKVSBD
     c                   movel     '0'           IFAKVSBD
     c**** bella 06.11.2015
     c                   if        IFAKVSBD   ='027' or
     c                             IFAKVSBD   ='053' or
     c                             IFAKVSBD   ='099' or
     c                             IFAKVSBD   ='042'
     c                   movel     '103'         IFAKVSBD
     c                   endif
     C                   endif
     c*  übergaben aus Spanien bei blank
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '   '
     c                   movel     '032'         IFAKVSBD
     c*  übergaben aus Spanien jetzt Dacher #INC-189181
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c*  übergaben aus Spanien bei blank
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '04'
     c                   movel     '104'         IFAKVSBD
     c*  übergaben aus Spanien jetzt Dacher #INC-189181
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '02'
     c                   movel     '025'         IFAKVSBD
     c*  übergaben aus Spanien jetzt Dacher #INC-189181
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '25'
     c                   movel     '025'         IFAKVSBD
     c*  übergaben aus Spanien jetzt Dacher #INC-189181
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '24'
     c                   movel     '024'         IFAKVSBD
     c*  übergaben aus Spanien jetzt Dacher #INC-189181
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c*  übergaben aus Spanien bei blank
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '22'
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '00'
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c*  übergaben aus Spanien bei 32 Dachser nach Hellmann
     c                   if        IFAKIFFI = '78146' and
     c                             h230     = '32'
     c***************    movel     '008'         IFAKVSBD
     c                   movel     '220'         IFAKVSBD
     C                   endif
     c*  übergaben aus Siegen
     c                   if        IFAKIFFI  = '98264'  and
     c                             ( h230 = '11' or h230 = '12'
     c                                           or h230 = '13')
     c                   move      h230          IFAKVSBD
     c                   movel     '8'           IFAKVSBD
     c                   if        IFAKVSBD = '811'
     C                   movel     '813'         IFAKVSBD
     C                   endif
     c                   if        %subst(h290:001:03) <> *blank and
     c                             %subst(h290:001:03) <> 'DAY'
     C                   eval      IFAKVSBD = %subst(h290:001:03)
     C                   endif
     C                   endif
     c                   if        IFAKIFFI  = '98264'  and
     c                             %subst(h290:001:03) <> *blank and
     c                             %subst(h290:001:03) <> 'DAY'
     C                   eval      IFAKVSBD = %subst(h290:001:03)
     c                   endif
     c*  übergaben aus Österreich
     c                   if        IFAKIFFI  = '54939'  and
     c                             ( h230 = '15' or h230 = '16')
     c                   move      h230          IFAKVSBD
     c                   movel     '8'           IFAKVSBD
     C                   endif
     c*  ab Werk grundsatz
     c                   move      '002'         ifaklibd
     c                   if        IFAKIFFI =  '42634' or
     c                             IFAKIFFI =  '02921' or
     c                             IFAKIFFI =  '23038' or
     c                             IFAKIFFI =  '91453' or
     c                             IFAKIFFI =  '55278' or
     c                             IFAKIFFI =  '35671' or
     c                             IFAKIFFI =  '32691'
     c*  FCA bei nicht EU
     c                   move      '022'         ifaklibd
     c                   endif
     c*
     c                   if        IFAKIFFI =  '78678'  or
     c                             IFAKIFFI =  '78680'
     c*  dap bei polen
     c                   move      '027'         ifaklibd
     c                   endif
     c*
     c                   if        IFAKIFFI =  '78146'
     c*  dap bei Spanien Katrin 22.09.2014
     c                   move      '027'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   clear                   IFAKVSBD
     C                   endif
     C
     c                   if        IFAKIFFI = '00003'
     c                   move      '033'         ifaklibd
     c                   clear                   IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '00025' or
     c                             IFAKIFFI = '00035' or
     c                             IFAKIFFI = '00055'
     c                   move      '033'         ifaklibd
     c                   clear                   IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '00008'
     c                   move      '033'         ifaklibd
     c                   clear                   IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '00009'
     c                   move      '033'         ifaklibd
     c                   clear                   IFAKVSBD
     C                   endif
     c                   if        IFAKIFFI = '00002'
     c                   move      '033'         ifaklibd
     c                   clear                   IFAKVSBD
     c                   exsr      srvsbdoem
     C                   endif
     c                   if        IFAKIFFI = '002921'
     c                   clear                   IFAKVSBD
     c                   move      '019'         IFAKVSBD
     C                   endif
     c                   if        %subst(h310:417:03) <> '   '  and
     c                             IFAKIFFI  <> '00002'
     c                   eval      IFAKVSBD = %subst(h310:417:03)
     c                   movel     IFAKVSBD      #IFAKVSBD         3
     c                   endif
     c*  übergaben aus Italien teilweise falsch
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671'
     c**** bella 06.11.2015
     c                   if        IFAKVSBD   ='027' or
     c                             IFAKVSBD   ='053' or
     c                             IFAKVSBD   ='099' or
     c                             IFAKVSBD   ='042'
     c                   movel     '103'         IFAKVSBD
     c                   endif
     C                   endif
     c**** nur für Slowakia
     c                   if        IFAKIFFI = '72511'  and
     c                             ifakvsbd  ='029'
     c                   movel     '129'         ifakvsbd
MG01 C                   endif
     c
     c**** Lars
     c                   if        IFAKIFFI = '01887'  and
     c                             (ifakvsbd  ='066'  or h230='66')
     c                   movel     '220'         ifakvsbd
MG01 C                   endif
     c**** Lars #CHN-428
     c                   if        IFAKIFFI = '08138'
     c                             and h230='14'
     c                   movel     '140'         ifakvsbd
MG01 C                   endif
     c
     c
     c
     c                   if        h030     = 752774
     c                   eval      IFAKVSBD = '008'
     c                   endif
     c                   if        h030     =  52774
     c                   eval      IFAKVSBD = '027'
     c                   endif
     c                   if        h030     =  02511
     c**** linn #INC-141204 grundsätzlich jetzt
     c                   eval      IFAKVSBD = '224'
     c**** linn #INC-135293
     c                   if        h140     = 'UK'  or
     c                             h140     = 'GB'
     c                   eval      IFAKVSBD = '224'
     c                   endif
     c                   endif
     c                   if        IFAKVSBD   ='0SC'
     c                   movel     '029'         IFAKVSBD
     c                   endif
     c**** Ausnahme Frankreich
     c                   if        IFAKIFFI = '88505'  and
     c                             ifakvsbd  ='070'
     c                   movel     '220'         ifakvsbd
MG01 C                   endif
     c
     c**** Internet 27.11.2017 Webshop
     c                   if        (IFAKIFFI = '40631'  or
     c                             IFAKIFFI = '78678' ) and
     c                             (ifakvsbd  ='   ' or
     c                              ifakvsbd  ='000')
     c                   movel     '220'         ifakvsbd
MG01 C                   endif
     c
     c                   if        (IFAKIFFI = '40631'  or
     c                             IFAKIFFI = '78680' ) and
     c                             (ifakvsbd  ='   ' or
     c                              ifakvsbd  ='000')
     c                   movel     '220'         ifakvsbd
MG01 C                   endif
     c
     c                   move      h060          ifakbeda
     c                   move      h060          ifakafda
     c                   if        ifakafda <  20140000 and
     c                             #h030    <> 0000003
     c                   z-add     20140101      ifakafda
     c                   endif
     c                   movel     h050          ifakref1
     c                   movel     h300          ifakref2
     c                   if        IFAKIFFI  =   '00035'
     c                   clear                   ifakref2
     c                   movel     h170          ifakref2
     c                   endif
     c                   if        IFAKIFFI  =   '00055'
     c                   clear                   ifakref2
     c                   movel     h170          ifakref2
     c                   endif
     c*  Sonderfunktion Schnittstelle Michael Ausgabe auf ihr Zeichen
     c                   if        h280 <> *blank
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765' or
     c                             IFAKIFFI = '98264'
     c                   movel     h280          ifakref2
     c                   endif
     c                   endif
     c                   movel     h240          IFAKMAAF
     c                   clear                   umlaut            1
     c                   clear                   pos               3 0
     c                   eval      umlaut = '@'
     c                   eval      pos = %scan(umlaut: h300)
     c                   clear                   eMail
     c                   if        pos > 0
     c                   movel     h300          eMail            60
     c                   endif
     c
     c***                Altdaten
     c                   if        %subst(h300:57:04) ='BGFS'
     c                   movel     h050          ifakref1
     c                   movel     h240          IFAKMAAF
     c                   movel     h320          ifakafat
     c                   clear                   ifakref2
     c                   movel     h300          ifakref2
     c*********          #over     'BGFS'        ifakref2
     c                   endif
     c                   if        IFAKIFFI = '00003'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     C                   movel     'TECCOM '     IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00025'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     C                   movel     'EASYIMPORT'  IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00035'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     C                   movel     'WORKIST   '  IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00055'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     c                   if        %subst(h310:433:30) <> ' '
     c                   eval      ifakref1 = %subst(h310:433:30)
     C                   endif
     C                   movel     '          '  IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00008'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     C                   movel     'LASERNET'    IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00009'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     C                   movel     'LASERNET'    IFAKKDSB
     C                   movel     '004'         ifaklibd
     c                   endif
     C                   if        #h030     = 0000005
     c********???        movel     h050          IFAKMAAF
     c********???        movel     h240          ifakref1
     C                   movel     'DCS    '     IFAKKDSB
     C********???        movel     '004'         ifaklibd
     c                   endif
     C*                 B2C  ==> IFAKLIAR
     C*                 Komplettkennzeichen wird beachtet und würde übersteuern.
     C*                 GB
     C                   if        #h030     = 0040631   and
     C                             h020      = 1002918
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Norwegen
     C                   if        #h030     = 0042634   and
     C                             h020      = 0034369
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Polen
     C                   if        #h030     = 0078678   and
     C                             h020      = 0001716
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Finnland
     C                   if        #h030     = 0005084   and
     C                             %subst(h310:417:03)  = '219'
     C*************                h020      = 0006793          20.4.2021
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Dänemark
     C                   if        #h030     = 0001887   and
     C                             %subst(h310:417:03)  = '219'
     C*************                h020      = 0006998          20.4.2021
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Schweden
     C                   if        #h030     = 0008138   and
     C                             %subst(h310:417:03)  = '219'
     C*************                h020      = 0050337          20.4.2021
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Frankreich b2c
     C                   if        #h030     = 0088505   and
     C                             h020      = 5007481
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Frankreich Dachser Renault  20211206   0088510 eigener Kunde
     C                   if        #h030     = 0088505   and
     C                             h020      = 5007913
     C*                 Frankreich Dachser Renault   229677
     C                   endif
     C*                 Spanien
     C                   if        #h030     = 0078146   and
     C                             %subst(h310:417:03)  = '219'
     c                   movel     'B2C'         ifakafat
     C                   endif
     C*                 Italien
     C                   if        #h030     = 0055278   and
     C                             %subst(h310:417:03)  = '219'
     c                   movel     'B2C'         ifakafat
     C                   endif
     c                   if        #h030     = 0000001  or
     c                             #h030     = 0000002  or
     c                             #h030     = 0000005  or
     c                             #h030     = 0000077  or
     c                             #h030     = 0000079
     c                   else
     c                   clear                   ifaklibd
     c                   endif
     c                   if        IFAKIFFI = '00002'
     c                   movel     'J'           h260
     c                   move      h230          ifaklibd
     c                   if        l210 <> 0
     c                   z-add     l210          IFAPPREI
     c                   movel     'PKO'         IFAPPRAR
     c                   movel     '1'           IFAPPDIM
     c                   movel     'S'           IFAPMEPR
     c                   endif
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     c
     C                   movel     'HDX    '     IFAKKDSB
     C                   if        H300    =     'HOFFMANNDI' or
     C                             H300    =     'ANDERS    ' or
     C                             H300    =     'AXMANN    ' or
     C                             H300    =     'CUNI      '
     C                   movel     'OEM'         IFAKABTL
     C                   movel     'E01'         IFAKKSTC
     c                   endif
     C                   if        H300    =     'ZEUZEM    '
     C                   movel     'EXP'         IFAKABTL
     C                   movel     'F01'         IFAKKSTC
     c                   endif
     C                   if        H300    =     'HARTMANN  '
     C                   movel     'EXP'         IFAKABTL
     C                   movel     'F01'         IFAKKSTC
     c                   endif
     c*********          Änderung 01.02.2016
     c                   if        H040      =   001075 or
     c                             H040      =   082157
     c***                Sammelrechnungskennzeichen
     c                   movel     'X'           IFAKSARG
     c***                Kostenbriefkasten
     c                   endif
     c                   endif
     c
     c*********          Änderung 13.04.2023
     C*                 Frankreich, England und Polen Testdaten ORDERFTEST
     C                   if        (#h030     = 0088505  or
     C                              #h030     = 0040631  or
     C                              #h030     = 0040670  or
     C                              #h030     = 0040642  or
     C                              #h030     = 0078678)
     c                   if         H340  = 'T'
     c                   movel     'J'           IFAKKOSP
     c                   movel     'J'           IFAKKOKZ
     c                   clear                   IFAKREF2
     c                   movel     'ORDERFTEST'  IFAKREF2
     c                   endif
     c                   endif
     c
     c*********          Änderung 05.09.2013
     c                   if        IFAKIFFI = '01887' or
     c                             IFAKIFFI = '08138'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     c                   endif
     c*********          Änderung 17.04.2012
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671' or
     c                             IFAKIFFI = '78678' or
     c                             IFAKIFFI = '78680' or
     c                             IFAKIFFI = '78680' or
     c                             IFAKIFFI = '78146'
     c                   movel     h050          IFAKMAAF
     c                   endif
     c*********          Änderung 04.07.2012
     c                   if        IFAKIFFI = '78146'
     c                   movel     h240          IFAKREF1
     c                   endif
     c
     c*********          Änderung 02.11.2016 wegen AMAZONE
     c                   if        IFAKIFFI = '40631' or
     c                             IFAKIFFI = '88505'
     c                   movel     H170          IFAKREF1
     c                   endif
     c
     c*********          aus Lager Schilgen nur für diesen Kunden
     c                   if        IFAKIFFI = '72511'
     c                   movel     '060'         IFAKLANR
     c                   endif
     c
     c*********          Änderung 19.04.2012
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671'
     c                   movel     h240          IFAKREF1
     c                   endif
     c
     c                   if        IFAKIFFI = '78678' or
     c                             IFAKIFFI = '78680'
     c                   movel     h240          IFAKREF1
     c                   endif
     c
     c*********          Änderung 18.02.2014
     c                   if        IFAKIFFI = '00004'
     c                   movel     'PDAP   '     IFAKKDSB
     c                   endif
     c                   if        IFAKIFFI = '00077'
     c                   movel     h050          IFAKMAAF
     c                   movel     h240          ifakref1
     c                   endif
     c
     c     '0':'N'       xlate     h260          h260
     c     ' ':'N'       xlate     h260          h260
     c     '1':'J'       xlate     h260          h260
     c                   movel     h260          ifakliar
     c
     c
     c                   if        h260 = 'J'
     c                   movel     'N'           ifaknlkz
     c                   endif
     c     ' ':'0'       xlate     h270          h270
     c                   movel     h270          ifaksarg
     c                   movel     h270          #ifaksarg         1
     c                   movel     h270          #ifaksarg2        1

     c*********          Änderung 01.02.2016
     c                   if        IFAKIFFI = '00002'
     c                   if        H040      =   001075 or
     c                             H040      =   082157
     c***                Sammelrechnungskennzeichen
     c                   movel     'X'           IFAKSARG
     c***                Kostenbriefkasten
     c                   movel     'J'           IFAKKOKZ
     c***                Kostenbriefkasten
     c                   endif
     c                   endif

     C*                 dcs dometic claim system internetuser
     c                   if        IFAKIFFI = '00005'
     c***                Kostenbriefkasten
     c****               movel     'J'           IFAKKOKZ
     c                   if        %subst(h310:242:01)  ='1'
     c                   eval      ifaklibd = '001'
     c                   else
     c                   eval      ifaklibd = '002'
     c                   endif
     c                   endif
     c
     c                   if        h030  = 900000
     C*                 Testdaten aus 365
     c                   movel     ifakref1      IFAKMAAF
     C*                 Testdaten aus 365 22.03.3022 !!!!
     c                   movel     h240          ifakref1
     c                   endif
     C*                 Achtung übersteuern
     c                   if        IFAKIFFI  = '98264'  and
     c                             h230 = '66'
     c                   eval      IFAKAFAT = '59 '
     c                   eval      IFAKWKNR = '008'
     c                   endif
     c
     c  n30              unlock    #IFAKL1
     c   30              write     IFAK1
      *
     C     ##2000        ENDSR

     C**************************************************************************
     C*übergaben Sendungsempfangsdaten KOPFEBENE
     C*IFADIFAA = 1 Auftraggeber-Adresse             adag
     C*IFADIFAA = 2 Versand Adresse                  adve
     C*IFADIFAA = 3 Rechnungsempfänger Adresse       adre
     C*IFADIFAA =   Rechnungsempfänger Adresse       *default keinen Satz
     C*-------------------------------------------------------------------------
     C*
     C     sr2200        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFAd1
     c                   movel     date          ifadueda
     c                   movel     zeit          ifadueuz
     c                   movel     date          ifadERDA
     c                   movel     zeit          ifadEZEI
     c                   movel     date          ifadJDAT
     c                   movel     zeit          ifadJZEI
     C                   movel     §§§usr        IFAdUSER
     C                   movel     §§§pgm        IFAdPROG
     C                   movel     §§§job        IFAdjnam
     C                   movel     §§§LIB        IFAdbibl
     C                   movel     '01'          IFADFIRM
     c                   move      IFAkIFFI      ifadiffi
     C                   movel     ifakIFNR      ifadifnr
      *
     c                   movel     '2 '          IFADIFAA
     C                   if        ifakiffi  = '78677' or
     C                             ifakiffi  = '78688' or
     C                             ifakiffi  = '32691' or
     C                             ifakiffi  = '23038'
     c                   movel     '  '          IFADIFAA
     C                   endif
     c                   movel     h060          ifaderda
     c                   movel     h070          ifadezei
     c                   movel     h100          ifadnam1
     c                   movel     h100          #ifadnam1        30
     c                   movel     h110          ifadnam2
     c                   movel     h120          ifadnam3
     c                   movel     h130          ifadstra
     c                   if        h140 ='HRV'
     c                   eval      h140 = 'HR '
     c                   endif
     C*                 Anpassung Mapping Landcode => ISO for B2B
     C     h140          chain     COUMAP
     C                   if        %found
     C                   eval      h140 = ISO_CODE
     C                   endif
     c                   movel     h140          ifadpold
     c                   movel     h150          ifadpolz
     c                   if        %subst(h310:501:12) <> ' '
     c                   eval      ifadpolz = %subst(h310:501:12)
     c                   endif
     c                   if        IFAKIFFI = '78678' or
     c                             IFAKIFFI = '78680'
     c     '-':' '       xlate     ifadpolz      ifadpolz
     c                   endif
     c                   setoff                                       71
     c                   if        IFAKIFFI = '78146'
     c     '-':' '       xlate     ifadpolz      ifadpolz
     c                   if        %subst(ifadpolz:01:02) = 'PT'
     c                   seton                                        71
     c                   movel     '  '          ifadpolz
     c                   endif
     c                   eval      ifadpolz  =   %trim(ifadpolz)
     c                   endif
     c                   movel     h160          ifadwort
     c                   if        %subst(h310:471:30) <> ' ' and
     c                             ( ifakiffi  = '88505' or
     c                               ifakiffi  = '40642' or
     c                               ifakiffi  = '40670' or
     c                               ifakiffi  = '40631' )
     c                   eval      ifadnam2 = %subst(h310:471:30)
     c                   endif
      *
     c                   if                                  h100=' ' and
     c                             h110=' ' and h120=' ' and h130=' ' and
     c                             h140=' ' and h150= 0  and h160=' '
     c                   movel     '  '          IFADIFAA
     c                   endif
     c                   if        IFAKIFFI = '40631'
     c***** old release  eval      ifadpolz =  %subst(h160:01:10)
     c***** old release  eval      ifadwort =  %subst(h160:11:20)
     c                   else
     c                   movel     h160          ifadwort
     c                   endif
     c
      *                  ab 15.11.2011 ist nicht mehr notwendig
     C*********          if        ifakiffi  = '08138'
     c*********          movel     h110          ifadstra
     c*********          clear                   ifadnam2
     c*********          eval      ifadwort   = 'VÄSTRA FRÖLUNDA'
     C*********          endif
     c
      *                  ab 16.02.2012 Änderung
     C                   if        ifakiffi  = '02921'
     c                   movel     h110          ifadstra
     c                   clear                   ifadnam2
     C                   endif
      *
      *                  ab 07.10.2020 Änderung for Spain
     C                   if        ifakiffi  = '78146' and
     c                             %subst(h310:301:60) <> *blank
     c                   eval      ifadstra  = %subst(h310:301:30)
     c                   if        %subst(h310:331:30) <> *blank
     c                   eval      ifadnam3  = %subst(h310:301:30)
     c                   eval      ifadstra  = %subst(h310:331:30)
     c                   endif
     C                   endif
      *
      *                  ab 06.08.2019 Änderung
     C                   if        ifakiffi  = '98264' and
     c                             %subst(h310:501:12) <> *blank
     c                   movel     ' '           ifadpolz
     c                   eval      ifadpolz = %subst(h310:501:12)
     C                   endif
      *
     c                   if        IFADIFAA <> *blank
     c   30              write     IFAd1
     c                   endif
      *
     C     ##2200        ENDSR

     C**************************************************************************
     C*übergaben EDIdaten KOPFEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2250        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFed1
     c                   movel     date          ifedueda
     c                   movel     zeit          ifedueuz
     c                   movel     date          ifedERDA
     c                   movel     zeit          ifedEZEI
     c                   movel     date          ifedJDAT
     c                   movel     zeit          ifedJZEI
     C                   movel     §§§usr        IFedUSER
     C                   movel     §§§pgm        IFedPROG
     C                   movel     §§§job        IFedjnam
     C                   movel     §§§LIB        IFedbibl
     C                   movel     '01'          IFedfirm
     c                   move      IFAkIFFI      ifediffi
     C                   movel     ifakIFNR      ifedifnr
     c*****              Warenempfänger bei Teccom
     c                   if        IFAKIFFI = '00003'
     C                   movel     H210          ifedilnr
     C                   endif
      *
     c                   move      'N'           IFEDAPER
     c   30              write     IFed1
      *
     C     ##2250        ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr2300        BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   if        ( h180 = 'H' and *in20 = '1' or
     c                               h180 = 'B' and *in20 = '1' or
     c                               h200 = 'H' and *in21 = '1' or
     c                               h200 = 'B' and *in21 = '1' or
     c                               h220 = 'H' and *in22 = '1'    )
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  =   '00077'
     c                   movel     'TXKO'        IFATTCDE
     c                   movel     'D'           IFATSPCD
     c                   movel     'A '          IFATDRK1
     c                   movel     'R '          IFATDRK2
     c                   movel     'L '          IFATDRK3
     c                   movel     'C '          IFATDRK4
     c                   endif
     c                   endif
     C*                 Fuss (2)
     c                   if        ( h180 = 'F' and *in20 = '1' or
     c                               h200 = 'F' and *in21 = '1' or
     c                               h220 = 'F' and *in22 = '1'    )
     c                   movel     '2 '          ifatiftx
     c                   endif
     C*                 Position (3)
     c                   if        ( h180 = 'L' and *in20 = '1' or
     c                               h200 = 'L' and *in21 = '1' or
     c                               h220 = 'L' and *in22 = '1'    )
     c                   movel     '3 '          ifatiftx
     c****               eval      ifatifpo   =  l050
     c                   z-add     l050          ifatifpo
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c   20              movel     h170          ifattext
     c   21              movel     H190          ifattext
     c   22              movel     h210          ifattext
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   endif
MG01 c                   if        IFAKIFFI = '98264' or
MG01 c                             IFAKIFFI = '00002'
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'SR2300    '  IFatbibl
MG01 c                   endif
     c   30              write     ##IFAt1
MG01 c                   endif
     c                   setoff                                       202122
      *
     C     ##2300        ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     srTESCO       BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  =   '40631'
     c                             and  ( H020 =1001798  or
     c                                    H020 =1001798  )
     c                   movel     'TXKO'        IFATTCDE
     c                   movel     'E'           IFATSPCD
     c                   movel     'K '          IFATDRK1
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c                   eval      ifattext  =
     c                             'unbedingt die bekannten ' +
     c                             'Versandvorschriften beachten, Info hat '
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   endif
     c                   eval      ifattext  =
     c                             'Schichtleiter'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   endif
      *
     C     ##Tesco       ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     srMGD         BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  =   '40631'
     c                             and  ( H020 = 644871  or
     c                                    H020 = 644871  )
     c                   movel     'TXKO'        IFATTCDE
     c                   movel     'F '          IFATDRK1
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c                   eval      ifattext  =
     c                             'TAIL LIFT REQUIRED FOR DELIVERY'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   endif
      *
     C     ##MGD         ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     srRETAIL      BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  =   '40631'
     c                             and  ( H020 = 1002638 or
     c                                    H020 = 1002638 )
     c                   movel     'TXKO'        IFATTCDE
     c                   movel     'K '          IFATDRK1
     c                   movel     'F '          IFATDRK2
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c                   eval      ifattext  =
     c                             'CHEP Pallet must be used with a ' +
     c                             'max height of 1.2m'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
     c
     c                   eval      ifattext  =
     c                             'bitte blaue Paletten zum Verpacken ' +
     c                             'verwenden'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
     c
     c                   movel     'L '          IFATDRK1
     c                   movel     '  '          IFATDRK2
     c                   eval      ifattext  =
     c                             'Please can you request a booking in' +
     c                             'slot for this order by: '
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
     c
     c                   movel     'L '          IFATDRK1
     c                   movel     '  '          IFATDRK2
     c                   eval      ifattext  =
     c                             'emailing MDA bookings@AO.com'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
      *
     C     ##RETAIL      ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     srDyas        BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  =   '40631'
     c                             and  ( H020 = 1002638 or
     c                                    H020 = 1002638 )
     c                   movel     'TXKO'        IFATTCDE
     c                   movel     'K '          IFATDRK1
     c                   movel     'F '          IFATDRK2
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c
     c                   movel     'L '          IFATDRK1
     c                   movel     '  '          IFATDRK2
     c
     c
     c                   eval      ifattext  =
     c                             'Please can you request a booking in' +
     c                             'slot for this order by: '
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
     c
     c                   movel     'L '          IFATDRK1
     c                   movel     '  '          IFATDRK2
     c                   eval      ifattext  =
     c                             'emailing hdcbookings@robertdyas.co.uk' +
     c                             ' and quoting customer order#'
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      ifattext  =  *blank
     c                   eval      p = p + 1
     c                   endif
      *
     C     ##DYAS        ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code     ARTIKEL
     C*          Position ==>   3    TXPO    ifatiftx
     C*SELECT * FROM txbe01 WHERE TBAFNR ='611115' and TBJHJJ =2024
     C*-------------------------------------------------------------------------
     C*
     C     sr2300art     BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Position (3)
     c                   movel     '3 '          ifatiftx
     c*****              eval      ifatifpo   =  l050
     c                   z-add     l050          ifatifpo
     c                   movel     'K '          IFATDRK1
     c                   movel     'L '          IFATDRK2
     c                   movel     'R '          IFATDRK3
     c                   movel     'L '          IFATDRK1
     c                   movel     'R '          IFATDRK2
     c                   movel     '  '          IFATDRK3
     c
     c                   movel     '1         '  ifatifuc
     c                   movel     l110          ifattext
     C*                 HDX 15.02.2024 Erweiterungen Dirk/Anja
     C*                     eval      %subst(l150:415:10) = EINZELLIEF
     C*                     eval      %subst(l150:428:05) = LIEFERPOS
     C*                     eval      %subst(l150:433:10) = BESTELLPOS
     C*                                BESTELLPOS Achtung BestellNummer gemeint
     C*                     SELECT H050, H030, L080II, H020, L050, EINZELLIEF, LIEFERPOS,
     C*                     BESTELLPOS FROM hdxorder§
      *                  *
     c                   if        H330     = 'HDXORDER'
     c                   movel     'A '          IFATDRK1
     c                   movel     'L '          IFATDRK2
     c                   movel     'R '          IFATDRK3
     c                   movel     'C '          IFATDRK4
     c                   eval      ifattext   = 'DeliveryNote Nr.' +
     c                                          %subst(L040:001:10) +
     c                                          ' Purchase Order Nr.' +
     c                                          %subst(l150:433:15)
     C*                 * bei Einzellieferscheinen aus l150:415:10
     C*                 SELECT L040,substr(l150, 415, 10) FROM orderl
     C*                 WHERE l160='HDXORDER'
     C*                 and (substr(l150, 415, 1))<> X'00' and
     C*                     (substr(l150, 416, 9))<> ' '
     C                   clear                   $x                1
     C                   eval      $x         = %subst(l150:415:1)
     c                   if        %subst(l150:416:09) <> *blank and
     c                                      $x   <> X'00'
     c                   eval      ifattext   = 'DeliveryNote Nr.' +
     c                                          %subst(l150:415:10) +
     c                                          ' Purchase Order Nr.' +
     c                                          %subst(l150:433:15)
     c                   endif
     c***30              exsr      sr_save2
     c                   endif
      *                  *
     c                   z-add     p             ifatifzn
      *                  *
     C     KEYifat01     KLIST
     C                   KFLD                    IFATIFFI
     C                   KFLD                    IFATIFTX
     C                   KFLD                    IFATIFNR
     C                   KFLD                    IFATIFPO
     C                   KFLD                    IFATIFUP
     C                   KFLD                    IFATIFUC
     C                   KFLD                    IFATIFZN
     c     KEYifat01     chain     ifat01                             64
      *                  *                  hier
     c                   if        *in64 = '1'
     c   30              write     IFAt1
     c                   endif
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300art '  IFatbibl
     c   30              write     ##IFAt1
MG01 c                   endif
     c                   eval      p = p + 1
      *
     C     ##2300art     ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code     Daten an Sedition
     C*          Kopf     ==>   4    TX??    ifatiftx  (Speditionsdaten)
     C*          Kopf     ==>   1    TX??    ifatiftx  (Speditionsdaten)
     C*          Druck    ==>   F    TX??    IFATDRK1  (Speditionsdaten)
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr2300spd     BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Spedition (4)
     c                   movel     '4 '          ifatiftx
     c* änderungen 29.09.2011
     c                   movel     '1 '          ifatiftx
     c                   movel     'F '          IFATDRK1
     c                   if        %subst(h280:1:3) ='301'  or
     c                             %subst(h290:1:3) ='301'
     c                   movel     'L '          IFATDRK2
     c                   endif
     c*                  movel     *off          IFATPRKZ
     c* änderungen 29.09.2011 ende
     C*
     c                   movel     '1         '  ifatifuc
     c                   z-add     0             ifatifzn
     c                   if        H280   <> ' '
     c                   movel     H280          ifattext
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300spd '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
     c                   if        H290   <> ' '
     c                   movel     H290          ifattext
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300spd '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
      *
     C     ##2300spd     ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code     Daten an Sedition
     C*          Kopf     ==>   4    TX??    ifatiftx  (Speditionsdaten)
     C*          Kopf     ==>   1    TX??    ifatiftx  (Speditionsdaten)
     C*          Druck    ==>   F    TX??    IFATDRK1  (Speditionsdaten)
     C*Inhalt des Fixtermines übergeben für Siegen 18.08.2015
     C*-------------------------------------------------------------------------
     C*
     C     sr2300fix     BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     'ORDERR#  '   IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Spedition (4)
     c                   movel     '4 '          ifatiftx
     c*
     c                   movel     '1 '          ifatiftx
     c                   movel     'F '          IFATDRK1
     c                   movel     'L '          IFATDRK2
     c                   if        IFAKIFFI  <>  '00077'
     c                   movel     'K '          IFATDRK3
     c                   endif
     c*                  movel     *off          IFATPRKZ
     c*
     C*
     c                   movel     '1         '  ifatifuc
     c                   z-add     0             ifatifzn
     c                   eval      ifattext      = '300: ' +
     c                                             %char(l060) +
     c                                             ' Achtung Fixtermin'
     c                   if        p  > 10
     c                   z-add     08            p
     c                   endif
     c                   z-add     p             ifatifzn
     c                   write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300fix '  IFatbibl
     c                   write     ##IFAt1
MG01 c                   endif
     c                   eval      p = p + 1
      *
     C     ##2300fix     ENDSR

     C**************************************************************************
     C*übergaben Textdaten     IFTA  Tab-Code     Daten für Warehouse
     C*          Position ==>   5    TX??    ifatiftx  (Warehouseangaben)
     C*          Position ==>   1    TX??    ifatiftx  (Warehouseangaben)
     C*          Druck    ==>   K    TX??    IFATDRK1  (Warehouseangaben)
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr2300wae     BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Warehouse (5)
     c                   movel     '5 '          ifatiftx
     c* änderungen 29.09.2011
     c                   movel     '1 '          ifatiftx
     c                   if        IFAKIFFI  <>  '00077'
     c                   movel     'K '          IFATDRK3
     c                   endif
     C*                 Änderung daniel 19.01.2018
     c                   movel     'K '          IFATDRK1
     c
MG01 c                   if        IFAKIFFI <>'05084'
     c                   movel     'L '          IFATDRK2
     c                   endif
     c*                  movel     *off          IFATPRKZ
     c* änderungen 29.09.2011 ende
     c
     c                   movel     '1         '  ifatifuc
     c                   z-add     0             ifatifzn
     c
     c                   if        H020 = 300117 and h030 = 98264
     c                   movel     Ch            ifattext
     c                   z-add     p             ifatifzn
     c                   movel     'D'           IFATSPCD
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300wae '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
     c                   if        (H180   =  'W' or H180   =  'B') and
     c                             (H170   <> *blank)
     c                   movel     H170          ifattext
     c                   z-add     p             ifatifzn
     c                   movel     'D'           IFATSPCD
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300wae '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
     c                   if        (H200   =  'W'  or H200   =  'B') and
     c                             (H190   <> *blank)
     c                   movel     H190          ifattext
     c                   z-add     p             ifatifzn
     c                   movel     'D'           IFATSPCD
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300wae '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
     c                   if        H220   =  'W' and
     c                             (H210   <> *blank)
     c                   movel     H210          ifattext
     c                   z-add     p             ifatifzn
     c                   movel     'D'           IFATSPCD
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300wae '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   endif
     c                   clear                   IFATSPCD
      *
     C     ##2300wae     ENDSR

     C**************************************************************************
     C*übergaben Textdaten Kopf
     C*-------------------------------------------------------------------------
     C*
     C     sr2300k       BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c****               movel     h070          ifatezei
     C*
     c                   z-add     1             z                 3 0
     C     z             DOUgt     420
     c
     C*                 kopf
     c                   if        %subst(h310:z:59) <> *blank
     c                   movel     '2 '          ifatiftx
     c                   eval      ifattext   =  %subst(h310:z:60) +
     c                                           '     '
     c                   movel     '1         '  ifatifuc
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300k   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c                   eval      z =  z + 60
     c                   enddo
     c
     c                   if        H280   <> ' '
     c                   movel     '2 '          ifatiftx
     c                   movel     '1         '  ifatifuc
     c                   movel     H280          ifattext
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300k   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c
     c                   if        H290   <> ' '
     c                   movel     H290          ifattext
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300k   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c
     c
     c                   if        H300   <> ' '
     c                   movel     H300          ifattext
     c                   movel     'G '          IFATDRK1
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300k   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   if        IFAKIFFI  <>  '00077'
     c                   movel     'K '          IFATDRK3
     c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
      *
     C     ##2300k       ENDSR

     C**************************************************************************
     C*übergaben Bankdaten     IFTA  Tab-Code
     C*          Kopf     ==>   1    TXKO    ifatiftx
     C*          Position ==>   3    TXPO    ifatiftx
     C*          Schluss  ==>   2    TXSC    ifatiftx
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr2300Bank    BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Fuss (2)
     c                   movel     '2 '          ifatiftx
     c                   movel     '#'           IFATDRK1
     c                   z-add     0             ifatifzn
     C*                 Vat Nummer
     c                   eval      ifattext  =  %subst(h310:121:15)
     c                   movel     'TXSC'        IFATTCDE
     c                   movel     'D'           IFATSPCD
     c                   movel     '1         '  ifatifuc
     c                   write     IFAt1
     c                   z-add     1             ifatifzn
     C*                 Bank
     c                   eval      ifattext  =  %subst(h310:136:30)
     c                   write     IFAt1
     c                   z-add     2             ifatifzn
     C*                 IBAN
     c                   eval      ifattext  =  %subst(h310:166:32)
     c                   write     IFAt1
     c                   z-add     3             ifatifzn
     C*                 BIC
     c                   eval      ifattext  =  %subst(h310:198:30)
     c                   write     IFAt1
     c                   z-add     4             ifatifzn
     C*                 ComContact
     c                   eval      ifattext  =  %subst(h310:228:30)
     c                   write     IFAt1
     c                   z-add     5             ifatifzn
     C*                 Telefon
     c                   eval      ifattext  =  %subst(h310:258:30)
     c                   write     IFAt1
      *
     C     ##2300Bank    ENDSR

     C**************************************************************************
     C*übergaben Textdaten Positionen
     C*-------------------------------------------------------------------------
     C*
     C     sr2300p       BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Fremdartikel nennen
     c                   if        L120              <> *blank
     c                   movel     '3 '          ifatiftx
     c                   movel     l120          ifattext
     c                   movel     '3         '  ifatifuc
     c****               eval      ifatifpo   =  l050
     c                   z-add     l050          ifatifpo
     c                   if        IFAKIFFI  <>  '00077'
     c                   movel     'K '          IFATDRK3
     c                   endif
     c                   movel     'L '          IFATDRK1
     c                   movel     'R '          IFATDRK2
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300p   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     C*
     C*
     c                   z-add     1             z                 3 0
     C     z             DOUgT     420
     c
     C*                 positionen
     c                   if        %subst(l150:z:60) <> *blank
     c                   movel     '3 '          ifatiftx
     c                   eval      ifattext   =  %subst(l150:z:60) +
     c                                           '     '
     c                   movel     '3         '  ifatifuc
     c****               eval      ifatifpo   =  l050
     c                   z-add     l050          ifatifpo
     c*********          if        IFAKIFFI  <>  '00077'          Kommentar 19.01.2018  Param. geändert
     c**********         movel     'K '          IFATDRK3         Kommentar 19.01.2018
     c*********          endif                                    Kommentar 19.01.2018
     c                   movel     'L '          IFATDRK1
     c                   movel     'R '          IFATDRK2
     c   30              write     IFAt1
MG01 c                   if        IFAKIFFI = '98264'
     C                   movel     'sr2300p   '  IFatbibl
     c   30              write     ##IFAt1
     C                   movel     §§§LIB        IFatbibl
MG01 c                   endif
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c                   eval      z =  z + 60
     c                   enddo
      *
     C     ##2300p       ENDSR

     C**************************************************************************
     C*B2B Textübergaben  28.04.2026
     C*-------------------------------------------------------------------------
     C*
     C     srB2BPos      BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   clear                   ##IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     C                   movel     '01'          IFatfirm
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c***                movel     h070          ifatezei
     C*
     C*                 Position (3)
     c                   movel     '3 '          ifatiftx
     c*****              eval      ifatifpo   =  l050
     c                   z-add     l050          ifatifpo
     c                   movel     'A '          IFATDRK1
     c                   movel     'L '          IFATDRK2
     c                   movel     'R '          IFATDRK3
     c
     c                   movel     'B2B       '  ifatifuc
     c                   eval      ifattext = %subst(l150:001:65)
      *                  *                  hier
     c   30              write     IFAt1
     c                   if        %subst(l150:066:65) <> *blank
     c                   eval      ifatifzn = 1
     c   30              write     IFAt1
     c                   endif
      *
     C     ##B2BPos      ENDSR

     C**************************************************************************
     C*übergaben Positionen POSITIONSEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR

     C*                 Positionsdaten Trend
     c                   clear                   IFAp1
     c                   clear                   ##IFAp1
     c                   movel     date          ifapueda
     c                   movel     zeit          ifapueuz
     c                   movel     date          ifapERDA
     c                   movel     zeit          ifapEZEI
     c                   movel     date          ifapJDAT
     c                   movel     zeit          ifapJZEI
     C                   movel     §§§usr        IFApUSER
     C                   movel     §§§pgm        IFApPROG
     C                   movel     §§§job        IFApjnam
     C                   movel     §§§LIB        IFapbibl
     C                   movel     '01'          IFapfirm
     c                   movel     IFAkIFFI      IFApIFFI
     c                   movel     ifakIFNR      ifapIFNR

     c***                eval      ifapifpo   =  l050
     c                   z-add     l050          ifapifpo
     c                   if        ifapifpo   =  *zero
     c                   z-add     999           ifapifpo
     c                   endif
     c                   eval      IFAPTENR   =  L080
     c                   if        IFAPTENR      ='4440600188'
     c                   movel     'M'           IFAPMEPR
     c                   endif
     c                   if        IFAPTENR   =  '207205701' and
     c                             IFAKIFFI   = '88505'
     c                   movel     '1'           mailout           1
     c                   endif
     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                   move      l060          ifaplfte
     c                   else
     c                   move      l060          ifapkwte
MG01 c                   if        IFAKIFFI = '15177' or
MG01 c                             IFAKIFFI = '62765'
MG01 c*                  eval      l060 = l060 - 1 day
MG01 c                   move      l060          ifaplfte
MG01 C                   endif
     c                   endif
MG01 c                   if        IFAKIFFI = '40631' or
MG01 c                             IFAKIFFI = '40642' or
MG01 c                             IFAKIFFI = '40670' or
MG01 c                             IFAKIFFI = '88505' or
MG01 c                             IFAKIFFI = '98264' or
MG01 c                             IFAKIFFI = '54939' or
MG01 c                             IFAKIFFI = '78678' or
MG01 c                             IFAKIFFI = '78680' or
MG01 c                             IFAKIFFI = '78146' or
MG01 c                             IFAKIFFI = '42634' or
MG01 c                             IFAKIFFI = '55278' or
MG01 c                             IFAKIFFI = '35671' or
MG01 c                             IFAKIFFI = '96690' or
MG01 c                             IFAKIFFI = '52774' or
MG01 c                             IFAKIFFI = '02511' or
MG01 c                             IFAKIFFI = '08138' or
MG01 c                             IFAKIFFI = '01887' or
MG01 c                             IFAKIFFI = '91453' or
MG01 c                             IFAKIFFI = '72511' or
MG01 c                             IFAKIFFI = '05084'
     c                   move      l060          ifaplfte
MG01 c                   exsr      sr8000
MG01 C                   endif
MG01 C* auch bei hdx
MG01 c                   if        IFAKIFFI = '00002'
     c                   move      l060          ifaplfte
MG01 c                   exsr      sr8000
MG01 C                   endif
MG01 C
MG01 C* auch bei Workist
MG01 c                   if        IFAKIFFI = '00035'
     c                   move      l060          ifaplfte
MG01 C*                  exsr      sr8000
MG01 C                   endif
MG01 C* auch wie bei Workist
MG01 c                   if        IFAKIFFI = '00055'
     c                   move      l060          ifaplfte
MG01 C*                  exsr      sr8000
MG01 C                   endif
MG01 C
MG01 C* in jedem Fall wird hierdurch eine zu fruehe Lieferung
MG01 C* verhindert
MG01 C
MG01 c                   if        (IFAKIFFI = '88505' or
MG01 c                             IFAKIFFI = '40642'  or
MG01 c                             IFAKIFFI = '40670'  or
MG01 c                             IFAKIFFI = '40631')
MG01 C                             and l060 > datum
     c*****              move      l060          ifaplfte
     c                   endif
MG01 C
MG01 C                   if        ifaplfte <> *zero
MG01 C                   if        %date(ifaplfte) < datum
MG01 C                   exsr      sr9900
MG01 C                   movel     newdate       ifaplfte
MG01 C                   endif
MG01 C                   endif
     c
     c                   if        IFAKIFFI = '02921' and
MG01 C                             ifaplfte =  *zero
MG01 C                   exsr      sr9900y
MG01 C                   movel     newdate       ifaplfte
MG01 C                   endif
     c
     c**** nur für Slowakia
     c                   if        IFAKIFFI = '72511'
     c                   movel     '060'         IFAPLANR
MG01 C                   endif
     c**** Österreich ==> aktuelles Datum
     c
     c                   z-add     l100          IFAPBSMG
     c                   if        l210 <> 0   and
MG01 c                             IFAKIFFI = '00005'
     c                   z-add     l210          IFAPPREI
     c                   movel     'PKO'         IFAPPRAR
     c                   eval      IFAPPRER = 'N'
     c                   movel     '1'           IFAPPDIM
     c                   movel     'S'           IFAPMEPR
     c                   endif
     C*                 dcs dometic claim system internetuser  kostenlose posit
     c                   if        IFAKIFFI = '00005'
     c                   if        l170= '1'
     c                   movel     'K  '         IFAPPRAR
     c                   endif
     c                   endif
     C*                 Kom-Datum-Übergeben!!!!!! aktuelles Tagesdatum    gang/langlitz 31.01.20025
     c                   if        IFAKIFFI = '00002'
     c                   movel     date          IFAPKMTE
     c                   endif
     c
     c   30              write     IFAp1
MG01 c                   if        IFAKIFFI = '00005'
     c   30              write     ##IFAp1
MG01 c                   endif
     c                   setoff                                       202122
      *
     C     ##2100        ENDSR

     C**************************************************************************
     C*übergaben Sendungsempfangsdaten KOPFEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFAn1
     c                   movel     date          ifanueda
     c                   movel     zeit          ifanueuz
     c                   movel     date          ifanERDA
     c                   movel     zeit          ifanEZEI
     c                   movel     date          ifanJDAT
     c                   movel     zeit          ifanJZEI
     C                   movel     §§§usr        IFAnUSER
     C                   movel     §§§pgm        IFAnPROG
     C                   movel     §§§job        IFAnjnam
     C                   movel     §§§LIB        IFanbibl
     C                   movel     '01'          IFanfirm
     c                   movel     IFAkIFFI      IFAnIFFI
     c                   movel     ifakIFNR      ifanIFNR
     c* kein Druckoptionsfenster eröffnen IFANDRKZ = 'N'
     c                   movel     'N'           IFANDRKZ
      *
     c                   movel     h060          ifanerda
     c***                movel     h070          ifanezei
     c                   movel     '0'           ifanabkz
     c   30              write     IFAd1
      *
     C     ##2500        ENDSR

     C**************************************************************************
     C*übergaben Nachnahmedaten in WAO8 Benelux Sonderformat
     C*-------------------------------------------------------------------------
     C*
     C     sr2260        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   wao81
     c                   movel     date          WAO8ERDA
     c                   movel     date          WAO8JDAT
     c                   movel     zeit          WAO8JZEI
     C                   movel     §§§usr        WAO8USER
     C                   movel     §§§pgm        WAO8PROG
     C                   movel     §§§job        WAO8jnam
     C                   movel     §§§LIB        WAO8bibl
     C                   movel     '01'          WAO8FIRM
     c                   move      IFAkIFFI      WAO8iffi
     C                   movel     ifakIFNR      WAO8ifnr
     c***                eval      WAO8IFPO   =  l050
     c                   z-add     l050          WAO8IFPO

     c                   eval      d_head    = %subst(h310:420:49)
     c*                  movel     §orh310       orh310
     c*                  movel     §orh315       orh315
     c                   movel     §orh316       WAO8SPWG
     c                   if        §orh400 =' '
     c                   movel     'J'           §orh400
     c                   endif
     c                   movel     §orh400       WAO8CODN
     c                   if        §orh420 ='   '
     c                   movel     'EUR'         §orh420
     c                   endif
     c                   movel     §orh420       WAO8CODW
     c     ' ':'0'       xlate     §orh430       §orh430
     c                   move      §orh430       WAO8CODS
     c     ' ':'0'       xlate     §orh440       §orh440
     c                   move      §orh440       WAO8CODM
     c     ' ':'0'       xlate     §orh410       §orh410
     c                   move      §orh410       WAO8CODB
     c     ' ':'0'       xlate     §orh450       §orh450
     c                   move      §orh450       WAO8CODV
     c     ' ':'0'       xlate     §orh460       §orh460
     c                   move      §orh460       WAO8CODK
     c     ' ':'0'       xlate     §orh470       §orh470
     c                   move      §orh470       WAO8CODI
     c                   clear                   ##pwinord        18
     c                   eval      ##pwinord = %subst(l150:481:18)
     c                   movel     ##pwinord     §ord450          11 2
     c                   move      ##pwinord     §ord460           7 2
     c     ' ':'0'       xlate     §orh450       §orh450
     c     ' ':'0'       xlate     §orh460       §orh460
     c                   z-add     §ord450       WAO8CODP
     c                   z-add     §ord460       WAO8CODU
     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                   move      l060          WAO8LFTE
     c                   endif
     c
     c   30              write     wao81
      *
     C     ##2260        ENDSR

     C**************************************************************************
     C*übergaben Nachnahmedaten in WAO8 Benelux Sonderformat
     C*-------------------------------------------------------------------------
     C*
     C     sr2265        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   wao81
     c                   movel     date          WAO8ERDA
     c                   movel     date          WAO8JDAT
     c                   movel     zeit          WAO8JZEI
     C                   movel     §§§usr        WAO8USER
     C                   movel     §§§pgm        WAO8PROG
     C                   movel     §§§job        WAO8jnam
     C                   movel     §§§LIB        WAO8bibl
     c                   move      IFAkIFFI      WAO8iffi
     C                   movel     ifakIFNR      WAO8ifnr
     C                   movel     '01'          WAO8FIRM
     c******+            eval      WAO8IFPO   =  l050
     c                   z-add     l050          WAO8IFPO
     c******20120525     eval      WAO8MLNR   =  h300
     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                   move      l060          WAO8LFTE
     c*****              exsr      sr2300fix
     c                   endif
     c
     c   30              write     wao81
      *
     C     ##2265        ENDSR

     C**************************************************************************
     C*übergaben Kundendaten Artikel
     C*-------------------------------------------------------------------------
     C*
     C     sr2280        BEGSR
      *
     C*                 Positionsdaten Trend
     c                   clear                   ifep1
     c                   movel     date          ifepueda
     c                   movel     zeit          ifepueuz
     c                   movel     date          ifepERDA
     c                   movel     zeit          ifepEZEI
     c                   movel     date          ifepJDAT
     c                   movel     zeit          ifepJZEI
     C                   movel     §§§usr        IFepUSER
     C                   movel     §§§pgm        IFepPROG
     C                   movel     §§§job        IFepjnam
     C                   movel     §§§LIB        IFepbibl
     C                   movel     '01'          IFepfirm
     c                   movel     IFAkIFFI      IFepIFFI
     c                   movel     ifakIFNR      ifepIFNR

     c*****              eval      ifepifpo   =  l050
     c                   z-add     l050          ifepifpo
     C*Stefie 20140916
     C                   if        #h030     = 0000003
     c                   z-add     l050          ifepposi
     c                   endif
     c                   eval      IFEPTENR   =  L080
     c                   eval      IFEPIDEN   =  L110
     c                   if        l110       =  *blank and
     c                             l120       <> *blank
     c                   eval      IFEPIDEN   =  L120
     c                   endif
     c                   if        IFepIFFI  ='98264'
     c                   if        l120       <> *blank
     c                   eval      IFEPIDEN   =  L120
     c                   endif
     c                   endif
     c   30              write     IFep1
     c                   setoff                                       202122
      *
     C     ##2280        ENDSR

     C**************************************************************************
     C*Protokoll line
     C*-------------------------------------------------------------------------
     C*
     C     sr2800        BEGSR
      *
     C*                 Übergabeprotokoll  "E D C" - part Kopf
     c*                  clear                   l150
     c                   if        *in93 = '1' and
     c                             ( ifakafjj <>   *Zero  or
     c                               ifakafnr <>   *blank or
     c                               ifakfenr <>   *blank or
     c                               ifakffld <>   *blank )
     C                   eval      l150 =
     C                             ' order already in the system          '
     C*                            ===> date and time
     c                   endif
     c                   movel     §§§USR        l160
     c                   movel     '10'          l240
     c                   movel     date          l180
     c                   movel     tstampi       l190
     c  n30              unlock    orderll1
     c   30              update    ORDERLPF
      *
      *
     C     ##2800        ENDSR

     C**************************************************************************
     C*Protokoll header
     C*-------------------------------------------------------------------------
     C*
     C     sr2900        BEGSR
      *
     C*                 Übergabeprotokoll  "E D C" - part Kopf
     c*                  clear                   h310
     c                   if        *in93 = '1' and
     c                             ( ifakafjj <>   *Zero  or
     c                               ifakafnr <>   *blank or
     c                               ifakfenr <>   *blank or
     c                               ifakffld <>   *blank )
     C                   eval      %subst(h310:1:28) =
     C                             ' order already in the system'
     C*                            ===> date and time
     c                   endif
     c                   movel     §§§USR        h330
     c                   movel     '10'          h350
     c                   movel     date          h360
     c                   movel     tstampi       h370
     c  n30              unlock    orderhl1
     c   30              update    ORDERhPF
      *
      *
     C     ##2900        ENDSR

     C**********************************************************************
     C*delivery date ermitteln
     C*-------------------------------------------------------------------------
     C
     C     sr8000        BEGSR
     c*
     c                   clear                   #CDATEISO2
     c                   if        IFAKIFFI = '08138'
     c*    Katrin: von 2 auf 3 geändert
     c*                  z-add     3             count
     c*                  movel     'SE'          sc
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI = '88505'
     c                   z-add     1             count
     c                   movel     'FR'          sc
     c                   endif
     c                   if        IFAKIFFI = '40631' or
     c                             IFAKIFFI = '40642' or
     c                             IFAKIFFI = '40670'
     c                   z-add     1             count
     c                   movel     'UK'          sc
     c                   endif
     c                   if        IFAKIFFI = '55278' or
     c                             IFAKIFFI = '35671'
     c                   z-add     1             count
     c                   movel     'IT'          sc
     c                   endif
     c                   if        IFAKIFFI  = '78678'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '78680'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '98264'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '54939'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '42634'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '96690'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '52774'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '02511'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '91453'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '78146'
     c                   z-add     2             count
     c********           goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '00002'
     c                   goto      ##8000
     c                   endif
     c                   if        IFAKIFFI  = '01887' or
     c                             IFAKIFFI  = '05084'
     c                   goto      ##8000
     c                   endif
     c*
     c                   movel     ifaplfte      #cdateiso2
     C                   eval      #CDATEISO  = %subst(#CDATEISO2:01:04) +
     C                                          '-'                      +
     C                                          %subst(#CDATEISO2:05:02) +
     C                                          '-'                      +
     C                                          %subst(#CDATEISO2:07:02)
     c*
     c                   clear                   #cdateiso2
     c                   CALL      'DELIVERY'
     c                   PARM                    #CDATEISO        10
     c                   PARM                    #CDATEISO2        8
     c                   PARM                    sc                2
     c                   PARM                    count             3 0
     c*
     c                   movel     #CDATEISO2    ifaplfte
     C*
     C     ##8000        ENDSR
     C
     C**********************************************************************
     C*LÖSCHEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     LIFAK         BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  '4     '      EXIFAKPGST
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     c                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     C*
     C                   CALL      'TRIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
     C*
     C     ##LIFAK       ENDSR
     C
     C**********************************************************************
     C*ABSCHLIEßEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     AIFAK         BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  'ABSCHL'      EXIFAKPGST
     C                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     C*
     C                   CALL      'TRIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
     C*
     C     ##AIFAK       ENDSR
     C
     C**********************************************************************
     C*FREIGEBEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     GNIFAK        BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  'GNAFKO'      EXIFAKPGST
     C                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     C*
     C                   CALL      'GNIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
      *
     C     ##GNIFAK      ENDSR
     C
     C**********************************************************************
     C*message
     C*-------------------------------------------------------------------------
     C
     C     message       BEGSR
      *
     C                   setoff                                       66
     C                   if        ifakiffi  = 'x8505' or
     C                             ifakiffi  = 'x0631' or
     C                             ifakiffi  = 'x5177' or
     C                             ifakiffi  = 'x2765' or
     C                             ifakiffi  = '08138' or
     C                             ifakiffi  = '78146' or
     C                             ifakiffi  = '02921' or
     C                             ifakiffi  = 'x1887' or
     C                             ifakiffi  = 'x5278'
     C                   seton                                        66
     C                   endif
     C   66              CALL      'MESSAGE_SC'
     C                   PARM                    ifakiffi
     C                   PARM                    IFAKMAAF
     C                   PARM      '1'           PARMX             1
      *
     C     ##message     ENDSR
     C
     C**********************************************************************
     C*confirmation ==> TVRELWAECO/confirm
     C*-------------------------------------------------------------------------
     C
     C     confirm       BEGSR
      *
     C                   if        #h030     =  00055   or
     C                             #h030     =  00002   or
     C                             #h030     =  00003   or
     C                             #h030     =  00035
     C                   else
     C                   CALL      'CONFIRM_SC'
     C                   PARM                    ifakiffi
     C                   PARM                    IFAKMAAF
     C                   endif
      *
     C     ##confirm     ENDSR
     C
     C**********************************************************************
     C*oem   Auftragsbestätigung und Priorität
     C*-------------------------------------------------------------------------
     C
     C     sr_oem        BEGSR
      *
     C                   clear                   md
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4800'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4801'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
      *
     C     ##_oem        ENDSR
     C
     C**********************************************************************
     C*fixtermin in Auftragposition Bestätigung
     C*-------------------------------------------------------------------------
     C
     C     sr_fix        BEGSR
      *
     C                   clear                   md
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4800'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md

     c                   movel     WAO8LFTE      #WAO8LFTE         8
     c                   exsr      sr9991
     C                   CALL      'WAO037'
     C                   Parm                    $IFAKiffi
     C                   parm                    $IFAKAFJJ
     C                   parm                    $IFAKAFNR
     C                   parm                    #WAO8LFTE

      *
     C     ##_fix        ENDSR
     C
     C**********************************************************************
     C*Sicherung nach Auftragserzeugung und Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_save       BEGSR
      *
     C                   clear                   md
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4804'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DC4804'     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4805'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DC4805'     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
      *
     C                   clear                   md
     C                   movea(p)  'ORDERRT   '  md(001)
     C                   movea(p)  §§§job        md(011)
     C                   movea(p)  §§§usr        md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C                   movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(099)
     C                   movea(p)  ifakiffi      md(100)
     C                   movea(p)  IFAKMAAF      md(106)
     C                   MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
      *
     C     ##_save       ENDSR
     C
     C**********************************************************************
     C*Sicherung Fehlererkennung
     C*-------------------------------------------------------------------------
     C
     C     sr_save2      BEGSR
      *
     C                   clear                   md
     c                   clear                   xxxxx            10
     c                   eval      xxxxx = %subst(l150:433:10)
     C                   movea(p)  'ORDERRT   '  md(001)
     C                   movea(p)  §§§job        md(011)
     C                   movea(p)  §§§usr        md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  '      '      md(040)
     C                   movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(099)
     C                   movea(p)  ifakiffi      md(100)
     C                   movea(p)  IFAKMAAF      md(106)
     C                   MOVEA     ' '           md(117)
     C                   movea(p)  xxxxx         md(118)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
      *
     C     ##_save2      ENDSR
     C
     C**********************************************************************
     C*vsbd
     C*-------------------------------------------------------------------------
     C
     C     sr_VSBD       BEGSR
      *
     C                   if        ifakiffi  = '40631' or
     C                             ifakiffi  = '40642' or
     C                             ifakiffi  = '40670' or
     C                             ifakiffi  = '88505'
     C                   clear                   md
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   movea(p)  #IFAKVSBD     md(016)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4802'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C                   endif
      *
     C     ##_vsbd       ENDSR
     C
     C**********************************************************************
     C*sr_akkosp  Kom_sperr
     C*-------------------------------------------------------------------------
     C
     C     sr_akkosp     BEGSR
      *
     C*                 Ausschluss ab 09.07.2025
     c****** 09.07.2025  if        ( H040      =   001075 or
     c****** 09.07.2025              H040      =   082157   ) and
     c****** 09.07.2025              ifakiffi  = '00002'
     C*                 Ausschluss ab 02.02.2016
     c****** 09.07.2025  goto      ##_akkosp
     c****** 09.07.2025  endif
     C                   if        ifakiffi  = '78677' or
     C                             ifakiffi  = '78688' or
     C                             ifakiffi  = '32691' or
     C                             ifakiffi  = '23038' or
     C****Ausschluss ab 11.07.2025 ifakiffi  = '00002' or
     c                              h050    = '2014tes5/D'
     C                   clear                   md
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   if        ifakiffi  <>'00002'
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4803'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   endif
     C                   if        ifakiffi  = '00002'
     C                   movea(p)  IFAKKDNR      md(001)
     C                   movea(p)  IFAKMAAF      md(007)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4808'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   endif
     C                   clear                   md
     C                   endif
      *
     C     ##_akkosp     ENDSR
     C
     C**********************************************************************
     C*Sammelrechnungskennzeichen
     C*-------------------------------------------------------------------------
     C
     C     sr_aksarg     BEGSR
      *
     C                   movel     ' '           #ifaksarg
     C                   if        ( ifakiffi  = '78146'  and
     C                               #ifadnam1 =
     C                             'DOMETIC SPAIN, S.L.     '  )
     C                   movel     '2'           #ifaksarg
     C                   endif
     C                   if        ( ifakiffi  = '55278'  and
     C                               #ifadnam1 =
     C                             'MAGAZZINO DOMETIC ITALY Srl')
     C                   movel     '2'           #ifaksarg
     C                   endif
     C                   if        ( ifakiffi  = '55278'  and
     C                               #ifaksarg2 = '1' )
     C                   movel     '2'           #ifaksarg
     C                   endif
     C*
     C                   if          ifakiffi  = '78146'  or
     C                               ifakiffi  = '00000'
     C*                              ifakiffi  = '55278'
     C                   clear                   md
     C                   clear                   #ifadnam1
     C                   movea(p)  ifakiffi      md(001)
     C                   movea(p)  IFAKMAAF      md(006)
     C                   movea(p)  #ifaksarg     md(016)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4806'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C                   endif
     C                   clear                   #ifaksarg2
      *
     C     ##_sarg       ENDSR
     C
     C**********************************************************************
     C*Incoterms
     C*-------------------------------------------------------------------------
     C
     C     sr_inco       BEGSR
      *
     C*Incoterms bei Norwegen einfache Variante
     C                   if          ifakiffi  = '42634'  or
     C                               ifakiffi  = '08138'  or
     C                               ifakiffi  = '02921'  or
     C                               ifakiffi  = '05084'  or
     C                               ifakiffi  = '40642'  or
     C                               ifakiffi  = '40670'  or
     C                               ifakiffi  = '40631'
     c                   clear                   incoterm
     c                   eval      incoterm =
     c                             'Emsdetten, Incoterms 2010'
     C                   endif
     C*Incoterms
     C                   if          ifakiffi  = '55278'  or
     C                               ifakiffi  = '35671'  or
     C                               ifakiffi  = '78678'  or
     C                               ifakiffi  = '78680'  or
     C                               ifakiffi  = '42634'  or
     C                               ifakiffi  = '08138'  or
     C                               ifakiffi  = '05084'  or
     C                               ifakiffi  = '02921'  or
     C                               ifakiffi  = '40642'  or
     C                               ifakiffi  = '40670'  or
     C                               ifakiffi  = '40631'
     c                   exsr      sr9991
     c                   movel     $IFAKAFJJ     #IFAKAFJJ         4
     C                   clear                   md
     C                   movea(p)  #IFAKAFJJ     md(001)
     C                   movea(p)  $IFAKAFNR     md(005)
     C                   movea(p)  incoterm      md(011)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4807'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C                   endif
     C
      *
     C     ##_inco       ENDSR
     C**********************************************************************
     C*afad Hinweisfeld Kunde
     C*-------------------------------------------------------------------------
     C
     C     sr_hinw       BEGSR
      *
     C*afad Hinweisfeld Kunde
     C                   if          h020      <> 0       and
     C                               h030      >  10      and
     C                               H020      <> H040
     c                   exsr      sr9991
     c                   movel     $IFAKAFJJ     #IFAKAFJJ         4
     C                   clear                   md
     C                   movea(p)  #IFAKAFJJ     md(001)
     C                   movea(p)  $IFAKAFNR     md(005)
     C                   movel     h020          hinweis          10
     C                   movea(p)  hinweis       md(011)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4810'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *blank        OUTFIL           10
     C                   PARM      *blank        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C                   endif
     C
      *
     C     ##_hinw       ENDSR
     C**********************************************************************
     C*mail info
     C*-------------------------------------------------------------------------
     C
     C     sr_mail       BEGSR
      *
     C                   clear                   dst
     C                   clear                   LONGMSG1
     C                   clear                   LONGMSG2
     C                   clear                   LONGMSG3
     C                   CALL      '#INFOMAIL'
     C                   PARM                    dst              44
     C                   PARM      '#DC4802'     LONGMSG1        132
     C                   PARM      *blank        LONGMSG2        132
     C                   PARM      *BLANK        LONGMSG3        132
      *
     C     ##_mail       ENDSR
     C
     C**********************************************************************
     C*mailaddon ==> lesen aler weiteren zusätzlichen optionen
     C*-------------------------------------------------------------------------
     C
     C     mailaddon     BEGSR
      *
     C*                  goto      ##_addon
     C                   clear                   xcount            1 0
     c                   clear                   #tblfzn           3 0
     C                   if        IFAKIFFI = '55278'  or
     C                             IFAKIFFI = '35671'  or
     C                             IFAKIFFI = '40631'  or
     C                             IFAKIFFI = '40642'  or
     C                             IFAKIFFI = '40670'  or
     C                             IFAKIFFI = '78678'  or
     C                             IFAKIFFI = '78680'  or
     C                             IFAKIFFI = '88505'
     C******************           h050     =    '2014tes5/D'
     C     *LIKE         DEFINE    H030          #H030
     C     *LIKE         DEFINE    H050          #H050
     C     *LIKE         DEFINE    H370          #H370
     C                   eval      #h030   =     h030
     C                   eval      #h050   =     h050
     C                   eval      #h370   =     h370
     C
     C     addon         KLIST
     C                   KFLD                    #H030
     C                   KFLD                    #H050
     C                   KFLD                    #H370
     C
     C     addon         SETLL     ORDERMSGL1                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      ORDERMSGL1                             95
     C                   IF        *in95 = '1'            or
     C                             #H030    <>  H030      or
     C                             #H050    <>  H050      or
     C                             #H370    <>  H370
     C                   leave
     C                   else
     C                   clear                   pos
     C                   clear                   Argument          1
     c                   eval      Argument='L'
     C                   eval      pos = %scan(%trim(Argument):H600x:1)
     C*      -----------
     C                   if        pos <> 0
     C                   clear                   email
     C                   EVAL      email  = %TRIM(h610x)
     C*                 update addon
     C*                 Routine Mail Auftragsbestätigung
     C                   CALL      'KDAP_GENR'
     C                   PARM                    xIFAKIFFI        10
     C                   PARM                    eMail            60
     C                   PARM                    #IFAKAFJJ         4
     C                   PARM                    $IFAKAFNR
     C                   PARM                    §§§job
     C                   PARM                    §§§usr
     C                   PARM                    §§§pgm
     C                   PARM                    §§§LIB
     C
     C*                 Routine Mail Auftragsbestätigung
     C*                 Druckkennzeichen im Auftragskopf auf "Y für
     C*                 Mail
     C*                 ab 7.12.2012 beinhalten die Strukturen auch
     C*                 die Rückgabeinhalte
     C                   movel     RTIFAKAFJJ    ###FAKAFJJ        4
     C                   CALL      'WAO038'
     C                   Parm                    RTIFAKIFFI
     C                   parm                    ###FAKAFJJ
     C                   parm                    RTIFAKAFNR
     C
     c                   endif
     C*      -----------
     C                   clear                   pos
     C                   clear                   Argument          1
     c                   eval      Argument='T'
     C                   eval      pos = %scan(%trim(Argument):H600x:1)
     C                   if        pos <> 0
     C                   clear                   email
     C                   EVAL      email  = %TRIM(h610x)
     C                   eval      xcount=xcount+1
     C                   movel     xcount        ycount           10
     C                   exsr      sr_t_and_t
     C                   endif
     C*      -----------
     c                   endif
     c                   enddo
     c                   endif
     C                   endif
      *
     C     ##_addon      ENDSR
     C
     C
     C**********************************************************************
     C*Track and Tracing
     C*Sprachcode dauerhaft geändert auf D
     C*TBUCDE     dauerhaft geändert auf 1
     C*-------------------------------------------------------------------------
     C
     C     sr_t_and_t    BEGSR
      *
     C                   movel     'D'           tbspcd            1
     C                   if        IFAKIFFI = '55278' or
     C                             IFAKIFFI = '35671'
     C                   movel     'I'           tbspcd            1
     C                   endif
     C                   if        IFAKIFFI = '40631'  or
     C                             IFAKIFFI = '40642'  or
     C                             IFAKIFFI = '40670'
     C                   movel     'E'           tbspcd            1
     C                   endif
     C                   if        IFAKIFFI = '78678'
     C                   movel     'P'           tbspcd            1
     C                   endif
     C                   if        IFAKIFFI = '78680'
     C                   movel     'P'           tbspcd            1
     C                   endif
     C                   if        IFAKIFFI = '88505'
     C                   movel     'F'           tbspcd            1
     C                   endif
     C
     c/exec sql
     c+ insert into txbe
     c+ select  char(' ', 1) TBlock,  char(:§§§job, 10) TPJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   TPJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     C+ substr(char(current time), 4, 2)  concat
     C+ substr(char(current time), 7, 2), 6, 0)   tpJZEI,
     C+ char(:§§§usr, 10) tpUSER, char(:§§§pgm, 10) tpPROG,
     C+ char(:§§§LIB, 10) TPBIBL,char('01', 02) TPFIRM,
     C+ char('AFDA', 10) TBTXAR, zoned(:#IFAKAFJJ, 4, 0) TBjhjj,
     C+ char(:$IFAKAFNR, 06) TBafnr, zoned(0, 4, 0) TBPOSI,
     C+ zoned(0, 4, 0) TBupos,char('TXVS', 10) tbtcde,
     C+ char('    ', 15) tba115,char('    ', 15) tba215,
     C**********+ char('E', 1) tbspcd,char('1', 10) tbucde,
     C+ char(:tbspcd, 1) tbspcd,         char('1', 10) tbucde,
     C+ zoned(:#tblfzn, 3, 0) tblfzn,
     C+ char(substr(:h610x, 1, 65), 65) tbtext,
     C+ zoned(0, 9, 2) TBwert,char('M', 1) tbdrk1,
     C+ char(' ', 1) tbdrk2, char(' ', 1) tbdrk3,
     C+ char(' ', 1) tbdrk4, char(' ', 1) tbdrk5,
     C+ char(' ', 20) tbrfin, char(' ', 20) tbfrex
     c+ from qsys2/qsqptabl
     c/end-exec
     C*
     C                   eval      #tblfzn = #tblfzn +1
     C********           eval      #tblfzn = 0
     C*
     C     ##_t_and_t    ENDSR
     C
     C
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9900        BEGSR
     C*
     c                   clear                   newdate           8

     c/exec sql
     c+ select  substr(char
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 7, 4)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 4, 2)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 1, 2)
     c+ into  :newdate
     c+       from qsys2/qsqptabl
     c+
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9900x       BEGSR
     C*
     c

     c/exec sql
     c+ select
     c+ date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+      substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+      substr(char(:ifaplfte), 7, 2)  ) +2 days into :##date
     c+ from qsys2/qsqptabl
     c***+ where
     c***+ date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c***+      substr(char(:ifaplfte), 5, 2) concat '-' concat
     c***+      substr(char(:ifaplfte), 7, 2)  ) < current date
     c/end-exec

     C     ##9900x       ENDSR

     C**************************************************************************
     C*time stamp
     C*update ifap set ifaplfte =  (select
     C*zoned(year(current date)
     C*concat digits(dec(month(current date), 2, 0)) concat
     C*       digits(dec(day(current date), 2, 0)))
     C*       FROM qsys2/qsqptabl) WHERE IFAPIFNR = '109175'
     C*-------------------------------------------------------------------------
     C*
     C     sr9900y       BEGSR
     C*
     c                   clear                   newdate           8

     c/exec sql
     c+ select
     c+ zoned(year(current date)
     c+ concat digits(dec(month(current date), 2, 0)) concat
     c+        digits(dec(day(current date), 2, 0)))  into :newdate
     c+ from qsys2/qsqptabl
     c/end-exec

     C     ##9900y       ENDSR

     C**************************************************************************
     C*Ermittlung Auftragsnummer nach Generierung
     C*-------------------------------------------------------------------------
     C*
     C     sr9991        BEGSR
     C*
     C     *LIKE         DEFINE    IFAKIFFI      $IFAKIFFI
     C     *LIKE         DEFINE    IFAKmaaf      $IFAKmaaf
     C     *LIKE         DEFINE    IFAKAFJJ      $IFAKAFJJ
     C     *LIKE         DEFINE    IFAKAFNR      $IFAKAFNR

     C                   clear                   $IFAKAFJJ
     C                   clear                   $IFAKAFNR
     C                   movel     IFAKiffi      $IFAKiffi
     C                   movel     IFAKmaaf      $IFAKmaaf

     c/exec sql
     c+ SELECT IFAKAFJJ, IFAKAFNR
     c+ into  :$IFAKAFJJ,
     c+       :$IFAKAFNR
     c+ FROM ifak04 WHERE IFAKIFFI = :$IFAKiffi and
     c+                   IFAKmaaf = :$IFAKmaaf
     c/end-exec

     C     ##9991        ENDSR

     C**************************************************************************
     C* sr9992: zusatz lesen der teil und evtl change der item# über
     c*         kpif
     C*-------------------------------------------------------------------------
     C*
     C     sr9992        BEGSR
     C*
     c
     c
     c     KEYteil       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     L080          TETENR
     C*
     c     KEYteil       chain     teil01                             98
     C*
     c     KEYkpif       klist
     c                   kfld                    TEFIRM
     c                   kfld                    KPKDNR
     c                   kfld                    KPVSNR
     c                   kfld                    KPIDEN
     c
     c                   if        *in98 = '1'
     c                   movel     '01'          TEFIRM
     c                   move      h040          ##h040            6
     c                   movel     ##h040        KPKDNR
     c                   clear                   KPVSNR
     c                   clear                   KPIDEN
     c                   movel     L080          KPIDEN
     C*
     c     KEYkpif       chain     kpif02                             98
     C*                 l080 = original und evtl. neue SKU
     c  n98              eval      %subst(l990:01:15) = L080
     c  n98              eval      %subst(l990:16:15) = %subst(KPTENR:01:15)
     c  n98              if        %subst(l110:01:15) = *blank
     c                   eval      %subst(l110:01:15) = l080
     c                   endif
     C*                 übersteuern
     c  n98              movel     KPTENR        L080
     c                   endif
     C*
     C     ##9992        ENDSR
     C*
     C**************************************************************************
     C* srDCS_ADR Claim system lesen Adressdatenbereiche
     C*-------------------------------------------------------------------------
     C*
     C     srDCS_ADR     BEGSR
     C*
     C                   if        h100 = *blank or
     C                             h130 = *blank or
     C                             h160 = *blank
     c     KEYkund       klist
     c                   kfld                    kdFIRM
     c                   kfld                    kdKDNR
     c                   movel     '01'          kdFIRM
     c                   movel     H020          kdKDNR##          7
     C*
     c                   eval      kdKDNR =  '00'   +
     c                                       %subst(kdKDNR##:04:04)
     c                   if        H020      > 9999
     c                   eval      kdKDNR =  '0'    +
     c                                       %subst(kdKDNR##:03:05)
     c                   endif
     c                   if        H020      > 99999
     c                   eval      kdKDNR =  %subst(kdKDNR##:02:06)
     c                   endif
     c                   eval      VSKDNR    =   kdKDNR
     C*
     c     KEYkund       chain     kund01                             98
     c
     C*                 über Kundenstamm
     c                   if        *in98 = '0'
     c                   movel     kdNAM1        h100
     c                   move      kdNAM2        h110
     c                   movel     kdNAM3        h120
     c                   movel     kdSTRA        h130
     c                   movel     kdPOLD        h140
     c                   movel     kdPOLZ        h150
     c                   eval      %subst(h310:501:12) =kdpolz
     c                   movel     kdWORT        h160
     c                   endif
     c                   endif
     C*
     C                   if        h100 = *blank or
     C                             h130 = *blank or
     C                             h160 = *blank
     c     KEYkdvs       klist
     c                   kfld                    VSFIRM
     c                   kfld                    VSKDNR
     c                   kfld                    VSVSNR
     c                   movel     '01'          VSFIRM
     c**********         movel     H020          VSKDNR
     c                   movel     '001'         VSVSNR
     C*
     c     KEYkdvs       chain     kdvs01                             98
     c
     C*                 über Kundenstamm Versandadresse
     c                   if        *in98 = '0'
     c                   movel     VSNAM1        h100
     c                   move      VSNAM2        h110
     c                   movel     VSNAM3        h120
     c                   movel     VSSTRA        h130
     c                   movel     VSPOLD        h140
     c                   movel     VSPOLZ        h150
     c                   eval      %subst(h310:501:12) =VSpolz
     c                   movel     VSWORT        h160
     c                   endif
     c                   endif
     C*
     C     ##DCS_ADR     ENDSR
     C*
     C**************************************************************************
     C* srvsbdoem oemvsbd
     C*-------------------------------------------------------------------------
     C*
     C     srvsbdoem     BEGSR
     C*
     c                   if        IFAKIFFI = '00002'
     c                   movel     '01'          kdFIRM
     c                   movel     H020          kdKDNR##          7
     C*
     c                   eval      kdKDNR =  '00'   +
     c                                       %subst(kdKDNR##:04:04)
     c                   if        H020      > 9999
     c                   eval      kdKDNR =  '0'    +
     c                                       %subst(kdKDNR##:03:05)
     c                   endif
     c                   if        H020      > 99999
     c                   eval      kdKDNR =  %subst(kdKDNR##:02:06)
     c                   endif
     c                   eval      VSKDNR    =   kdKDNR
     C*
     c     KEYkund       chain     kund01                             98
     c
     C*                 über Kundenstamm
     c                   if        *in98 = '0'
     c                   movel     kdvsbd        ifakvsbd
     c                   endif
     c                   endif
     C*
     C     ##vsbdoem     ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

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

     C**************************************************************************
