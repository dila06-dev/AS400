     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*      August 2010 M.Gang                                    *
     F*      Änderungen:                                         *
     F*      Anlage 537p über Call Ausnahme: LBLBLSTC <> '816'   *
     F*      in Protokoll ist der Satz vorhanden                 *
     F*                                                          *
     F* SELECT #ERRORTXT FROM datenkw/#lblb WHERE #LBLBTMST >
     F* '20111031999999990000012225'
     F* SELECT-Anweisung vollständig verarbeitet.
     F* update                datenkw/#lblb set
     F* #ERRORTXT = 'UNGÜLTIGE BUCHUNG  ' !! substr(#ERRORTXT, 20, 61)
     F*                                     WHERE #LBLBTMST >
     F* '20111031999999990000012225'
     F* 12695 Zeilen in #LBLB in DATENKW aktualisiert.
     F* SELECT #ERRORTXT FROM datenkw/#lblb WHERE #LBLBTMST >
     F* '20111031999999990000012225'
     F*                                                          *
     F* update  datenkw/#lblb  set
     F* #ERRORTXT = '816 Korrektur      ' !! substr(#ERRORTXT, 20, 61)
     F* where
     F* #LBLBLSTC ='816' and (#LBLBBDAT >20180300 and #LBLBBDAT <20180400)
     F*                                                          *
     F*                                                          *
     F* update        teew01 set TEEWSKUN = teewtenr
     F*                      WHERE TEEWSKUN ='          ' and TEEWfirm
     F* ='01' and substr(teewtenr, 1, 1) ='9' and substr(teewtenr, 11, 1)
     F* =' ' and teewtenr  ='9620013485'
     F*                                                          *
     F* select * from teew01
     F*                      WHERE                            TEEWfirm
     F* ='01'    and
     F*          (teewtenr  ='9108008189'  or teewskun='9108008189')
     F*                                                          *
     F* SELECT * FROM teew01 where (TEEWPROG='SCM_IMPORT'     and
     F*                             TEEWJDAT='20230317' )  and
     F*   teewskun in (select teewtenr from teew01 where teewfirm='01'
     F*                     and teewtenr<>teewskun)
     F*                                                          *
     F* delete        teew01 where (TEEWPROG='SCM_IMPORT'     and
     F*                             TEEWJDAT='20230317' )  and
     F*   teewskun in (select teewtenr from teew01 where teewfirm='01'
     F*                     and teewtenr<>teewskun)
     F*                                                          *
     F*update        datenkw/#lblb set #artnum=#LBLBTENR
     F*                            WHERE #LBLBBDAT >20231100 and #ARTNUM=0
     F*and substr( #LBLBTENR, 10, 1) <> ' '
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
     F************************************************************

     f#lblb     uf   e           k disk
     fprj015p   if   e           k disk
     fafko01    if   e           k disk
     fprj535p   uf a e           k disk
     fprj537l11 if   e           k disk
     f#bwae99   if   e           k disk
     fbbep00    if   e           k disk
     fprj535zp  uf   e           k disk
     fBWAE09    if   e           k disk
     F                                     RENAME(BWAE1:log02r)
     f#BLPO99   if   e           k disk

     fkalk_file2if   e           k disk
     fsystempf  if   e           k disk

     D*Date             S               D   DATFMT(*ISO)

     DDate             S               D   DATFMT(*YMD)
     Dpjahr            S              2
     Dpmonat           S              2
     Dptag             S              2
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T

     * PROGRAMM-call-DATENSTRUKTUR
     D CALLPGM         DS
     D  TYP                    1      1    inz
     D  BUCDAT                 2      9  0 inz
     D  WENR
     D* WENRI                 10     13  0 inz
     D  AEWeJJ#               10     17  0 inz
     D  AEWenr#               18     23    inz
     D  BELNUM                24     34  0 inz
     D  LIFNR                 35     45  0 inz
     D  HANR                  46     56    inz
     D  BSTNUM                57     63  0 inz
     D  BSTPOS                64     67  0 inz
     D  KSTSTL                68     74  0 inz
     D  KUNDNR                75     81  0 inz
     D  AFTNUM                82     92  0 inz
     D  AFTPOS                93     96  0 inz
     D  BUCKEY                97     98    inz
     D  ARTNUM                99    109  0 inz
     D  ARTNUMVAR            110    113  0 inz
     D  VARTYP               114    114    inz
     D  LO                   115    122    inz
     D  LO2                  123    130    inz
     D  ENH                  131    135    inz
     D  MNG                  136    147  4 inz
     D  ABM1                 148    158  2 inz
     D  ABM2                 159    169  2 inz
     D  ABM3                 170    180  2 inz
     D  ABMENH               181    183    inz
     D  ERG                  184    194  2 inz
     D  ERGENH               195    197    inz
     D  MNG2                 198    209  4 inz
     D  LOIST                210    217    inz
     D  LOIST2               218    225    inz
     D  ENHIST               226    230    inz
     D  MNGIST               231    242  4 inz
     D  MNGIST2              243    254  4 inz
     D  LOAVW                255    259    inz
     D  MNGAVW               260    271  4 inz
     D  BUCTXT               272    296    inz
     D  ERRCDE               297    298    inz
     D  ERRTXT               299    377    inz
     D  STAINP               378    378    inz
     D  KONKNZ               379    379    inz
     D  KUNKNZ               380    380    inz
     D  MVKNZ                381    384    inz
     D  CHARGE               385    404    inz
     I*-------------------------------------------------------------------------
     IPRJ535f
     I              BSTPOS                      §BSTPOS
     I              BSTNUM                      §BSTNUM
     I              erg                         §ERG
     I              ERRTXT                      §ERRTXT
     IPRJ537f
     I              abm1                        §abm1
     I              abm2                        §abm2
     I              abm3                        §abm3
     I              BSTPOS                      §BSTPOS
     I              BSTNUM                      §BSTNUM
     I              ERG                         §ERG
     I              MNG                         §MNG
     I              MNGAVW                      §MNGAVW
     I              HLOAVW                      §HLOAVW
     I*-------------------------------------------------------------------------
     Iprj015f
     I              F01                         §f01
     I              F02                         §f02
     I              F03                         §f03
     I              PRSENH                      §PRSENH
     C*-------------------------------------------------------------------------
     I#LBLBR
     I              #artnum                     §artnum
     C*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1

     C* --------------------------------------------------
     C
     C     *LIKE         DEFINE    #LBLBFIRM     $LBLBFIRM
     C     *LIKE         DEFINE    #LBLBTMST     $LBLBTMST
     C
     C                   clear                   $LBLBFIRM
     C                   clear                   $LBLBTMST
     C                   movel     '01'          $LBLBFIRM
     C                   movel     #TIMESTAM2    $LBLBTMST
     C
     C     KEY0000       KLIST
     C                   KFLD                    $LBLBFIRM
     C                   KFLD                    $LBLBTMST
     C                   movel     #LBLBTMST     vTIMESTAMP       26
     C*
     C     KEY0000       SETGT     #lblb                              95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #lblb                                  95
     C  n95              movel     #LBLBTMST     vTIMESTAMP       26
     C                   IF        *in95 = '0' and
     C                             vTIMESTAMP > $TIMESTAM2
     C                   seton                                        95
     C                   endif
     C                   if        %subst(#ERRORTXT: 1: 19) <> ' '
     C                   move      '1'           t                 1
     C                   endif
     C     *IN95         IFEQ      '1'
     c     #LBLBFIRM     orne      $LBLBFIRM
     C                   leave
     C                   else
     C* 2026-09-18: Pro gelesenem Satz SR1000 nur einmal ausfuehren.
     C* SR9820 aendert #ERRORTXT und fuehrt UPDATE #LBLBR aus.
     C* Einzelne IFs konnten danach einen zweiten Aufruf ausloesen.
     C* SELECT verhindert erneute Buchung ohne neues READ.
     C* Kennzeichen vor jeder Verarbeitung neu setzen.
     C                   movel     '0'           wewe
     C                   select
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'ARTIKEL FEHLT IN TB'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 20) =
     C                             'DISPOSTEUERUNG FEHLT'    or
     C                             %subst(#ERRORTXT: 1: 19) =
     C                             'DISPOSTEUERUNG FEHL'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'DATUM ABGESCHLOSSEN'   and
     C                             #LBLBLSTC = '825'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'UNGÜLTIGE BUCHUNG  '
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'LAGERORT 1 UNGÜLTIG'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'LAGERORT 2 UNGÜLTIG'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 10) =
     C                             'EINHEITEN:'
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'Korrektur Inventur '
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             '816 Korrektur      '
     C                   exsr      sr1000
     C                   when      %subst(#ERRORTXT: 1: 19) =
     C                             'Korrektur Wareneing'
     C                   movel     '1'           wewe              1
     C                   exsr      sr1000
     C                   endsl
     C                   endif
     C                   enddo
     C                   endif
     C*
     C                   out       #TIMESTAM2
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C* SR1000:
     C*-------------------------------------------------------------------------

     C     SR1000        BEGSR
     C*
     c     KEY1000       klist
     c                   kfld                    #version
     c                   kfld                    #LBLBTENR
     C*
      *                 Kalk_file2                                            
     c     KEY1000       chain     kalk_file2
     c                   IF        %found(kalk_file2)
     c                   seton                                        40
     c                   clear                   callpgm
     c                   clear                   log02r
     c                   clear                   BWAE1
     c                   clear                   BBEP1
     c                   movel     '00000000'    eplfnr                        
     c                   exsr      SR9810
     c                   exsr      SR9820
     c                   setoff                                       40
     c                   else
     c                   seton                                        40
     c                   clear                   callpgm
     c                   clear                   log02r
     c                   clear                   BWAE1
     c                   clear                   BBEP1
     c                   movel     '00000000'    eplfnr                        
     C                   clear                   ARTSKU
     c                   exsr      SR9810
     c                   exsr      SR9820
     c                   setoff                                       40
     c                   ENDIF
     C*
     C     ##1000        ENDSR

     C**************************************************************************
     C* sr2000: Mengeneinheiten   LBLBMEIN  immer *blank?
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     C*
     C                   clear                   enh
     C                   select
     C                   when      #LBLBBWME = 'S'
     C                   movel     'ST'          enh
     C                   when      #LBLBBWME = 'D'
     C                   movel     'DM'          enh
     C                   when      #LBLBBWME = 'M'
     C                   movel     'M '          enh
     C                   when      #LBLBBWME = 'Z'
     C                   movel     'CM'          enh
     C                   when      #LBLBBWME = 'K'
     C                   movel     'KG'          enh
     C                   when      #LBLBBWME = 'G'
     C                   movel     'G '          enh
     C                   other
     C                   movel     '??'          enh
     C                   endsl
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* sr2000a: Mengeneinheiten Bestellung  EPMEIN    immer *blank?
     C*-------------------------------------------------------------------------
     C*
     C     SR2000a       BEGSR
     C*
     C                   clear                   enhmng
     C                   select
     C                   when      EPMEIN   = 'S'
     C                   movel     'ST'          enhmng
     C                   when      EPMEIN   = 'D'
     C                   movel     'DM'          enhmng
     C                   when      EPMEIN   = 'M'
     C                   movel     'M '          enhmng
     C                   when      EPMEIN   = 'Z'
     C                   movel     'CM'          enhmng
     C                   when      EPMEIN   = 'K'
     C                   movel     'KG'          enhmng
     C                   when      EPMEIN   = 'G'
     C                   movel     'G '          enhmng
     C                   other
     C                   movel     '??'          enhmng
     C                   endsl
     C*
     C     ##2000a       ENDSR
     C*
     C**************************************************************************
     C* sr2000b: Preiseinheiten Bestellung  EPMEPR    immer *blank?
     C*-------------------------------------------------------------------------
     C*
     C     SR2000b       BEGSR
     C*
     C                   clear                   enhlfr
     C                   select
     C                   when      EPMEPR   = 'S'
     C                   movel     'ST'          enhlfr
     C                   when      EPMEPR   = 'D'
     C                   movel     'DM'          enhlfr
     C                   when      EPMEPR   = 'M'
     C                   movel     'M '          enhlfr
     C                   when      EPMEPR   = 'Z'
     C                   movel     'CM'          enhlfr
     C                   when      EPMEPR   = 'K'
     C                   movel     'KG'          enhlfr
     C                   when      EPMEPR   = 'G'
     C                   movel     'G '          enhlfr
     C                   other
     C                   movel     '??'          enhlfr
     C                   endsl
     C*
     C     ##2000b       ENDSR
     C*
     C**************************************************************************
     C* sr2000z: Währungen übersetzen
     C*-------------------------------------------------------------------------
     C*
     C     SR2000z       BEGSR
     C*
     C                   clear                   wschl
     C                   select
     C                   when      EPWACD   = 'EUR'
     C                   z-add     24            wschl
     C                   when      EPWACD   = 'GBP'
     C                   z-add     13            wschl
     C                   when      EPWACD   = 'JPY'
     C                   z-add     16            wschl
     C                   when      EPWACD   = 'PLZ'
     C                   z-add     35            wschl
     C                   when      EPWACD   = 'SEK'
     C                   z-add     02            wschl
     C                   when      EPWACD   = 'USD'
     C                   z-add     04            wschl
     C                   other
     C                   z-add     00            wschl
     C                   endsl
     C*
     C     ##2000z       ENDSR
     C*
     C**************************************************************************
     C* sr2009: Bewegungsabhängige Buchungsinformationen
     C*-------------------------------------------------------------------------
     C*
     C     SR2009        BEGSR
     C*
     C*                  *defauld - Werte (vorerst)
     C*                  *
     c                   Z-ADD     #LBLBBWMG     mng
     C*
     C                   z-add     4711          kststl
     c                   movel     'FA'          BUCKEY
     C                   move      #LBLBLSTC     §LBLBLSTC         3 0
     C                   z-add     §LBLBLSTC     belnum
     C                   select
     C                   when      #LBLBLSTC = '210'
     C                   when      #LBLBLSTC = '220'
     c                   movel     'FA'          BUCKEY
     C                   when      #lBLBLSTC = '230'
     C                   z-add     *zero         kststl
     c                   movel     4720          aftnum
     C                   when      #LBLBLSTC = '270'
     C                   z-add     4712          kststl
     C                   when      #LBLBLSTC = '280'
     C                   z-add     4712          kststl
     C                   when      #LBLBLSTC = '300'
     c                   movel     'U '          BUCKEY
     c                   movel     'DUMMY'       lo2
     C                   z-add     *zero         kststl
     C                   when      #LBLBLSTC = '320'
     c                   movel     'FA'          BUCKEY
     C                   z-add     320           kststl
     C                   when      #LBLBLSTC = '410'
     c                   movel     'L '          BUCKEY
     C                   z-add     4713          kundnr
     C                   z-add     *zero         kststl
     C                   z-add     4712          aftnum
     C*** ermitteln wao2 z-add                   aftpos
     C                   when      #LBLBLSTC = '420'  or
     C                             #LBLBLSTC = '140'
     c                   movel     'L '          BUCKEY
     C                   z-add     4713          kundnr
     C                   z-add     *zero         kststl
     C                   z-add     4712          aftnum
     c                   movel     #LBLBDAKY     aftnum
     c                   clear                   #pos              4
     c                   eval      #pos = %subst(#LBLBDAKY: 11: 4)
     c                   move      #pos          aftpos
     c                   exsr      sr9850
     c  n96              clear                   ##kundnr          6 0
     c  n96              z-add     ##kundnr      kundnr
     C*** ermitteln wao2 z-add                   aftpos
     C                   when      #LBLBLSTC = '510'
     c                   movel     'S '          BUCKEY
     C                   z-add     4711          kststl
     C                   when      #LBLBLSTC = '512'
     c                   movel     'AS'          BUCKEY
     C                   when      #LBLBLSTC = '514'
     C                   z-add     514           kststl
     C                   when      #LBLBLSTC = '515'
     C                   z-add     515           kststl
     C                   when      #LBLBLSTC = '516'
     C                   z-add     516           kststl
     C                   when      #LBLBLSTC = '517'
     C                   z-add     517           kststl
     C                   when      #LBLBLSTC = '518'
     C                   z-add     518           kststl
     C                   when      #LBLBLSTC = '519'
     C                   z-add     519           kststl
     C                   when      #LBLBLSTC = '520'
     C                   z-add     520           kststl
     C                   when      #LBLBLSTC = '530'
     C                   z-add     530           kststl
     C                   when      #LBLBLSTC = '531'
     C                   z-add     531           kststl
     C                   when      #LBLBLSTC = '532'
     C                   z-add     532           kststl
     C                   when      #LBLBLSTC = '533'
     C                   z-add     533           kststl
     C                   when      #LBLBLSTC = '600' or
     C                             #LBLBLSTC = '330'
     c                   movel     'U '          BUCKEY
     c                   movel     'DUMMY'       lo2
     C                   z-add     *zero         kststl
     C                   when      #LBLBLSTC = '610' or
     C                             #LBLBLSTC = '130'
     c                   movel     'L '          BUCKEY
     c                   movel     610           aftnum
     c                   movel     #LBLBDAKY     aftnum
     c                   z-add     01            aftpos
     C                   z-add     *zero         kststl
     c                   clear                   #pos              4
     c                   eval      #pos = %subst(#LBLBDAKY: 11: 4)
     c                   move      #pos          aftpos
     c                   exsr      sr9850
     c  n96              clear                   ##kundnr          6 0
     c  n96              z-add     ##kundnr      kundnr
     C                   when      #LBLBLSTC = '810'
     C                   z-add     *zero         kststl
     c                   movel     4720          aftnum
     C                   when      #LBLBLSTC = '815'
     c                   movel     'K '          BUCKEY
     C                   z-add     *zero         kststl
     C                   movel     eplfnr        lifnr
     C                   eval      lifnr= lifnr/10000
     C                   when      #LBLBLSTC = '816'
     C                   z-add     *zero         kststl
     C***iffart = 535p ='S'                 u p d a t e
     C***iffart = 537p ='S' prüfen auf ebene lagerplatz
     C                   when      #LBLBLSTC = '817'
     c                   movel     'LV'          BUCKEY
     C                   z-add     *zero         kststl
     C                   z-add     9122800       lifnr
     C                   when      #LBLBLSTC = '820'
     c                   movel     'FL'          BUCKEY
     C                   z-add     *zero         kststl
      *                 auftrags# aus trend                                   
     c                   movel     4720          aftnum
     C                   when      #LBLBLSTC = '825'
     c                   movel     'Z '          BUCKEY
     C                   movel     eplfnr        lifnr
     C                   eval      lifnr= lifnr/10000
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '900'
     C                   z-add     *zero         kststl
     c                   movel     'II'          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '910'
     c                   movel     'I '          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '911'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '912'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '920'
     c                   movel     'I '          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '921'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '922'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     c                   when      #LBLBLSTC = '930'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     C                   when      #LBLBLSTC = '931'
     c                   movel     'FA'          BUCKEY
     C                   z-add     *zero         kststl
     C                   when      #LBLBLSTC = '935'
     c                   movel     'FA'          BUCKEY
     C                   z-add     935           kststl
     C                   when      #LBLBLSTC = '950'
     c                   movel     'U '          BUCKEY
     c                   movel     'DUMMY'       lo2
     C                   z-add     *zero         kststl
     C                   movel     eplfnr        lifnr
     C                   eval      lifnr= lifnr/10000
     C                   when      #LBLBLSTC = '955'
      *                 sperre                                                
     c                   movel     'CC'          BUCKEY
     C                   z-add     *zero         kststl
     c                   movel     'DUMMY'       lo2
     C                   when      #LBLBLSTC = '956'
      *                 entsperren                                            
     c                   movel     'CC'          BUCKEY
     C                   z-add     *zero         kststl
     c                   movel     'DUMMY'       lo2
     C                   when      #LBLBLSTC = '960'
     c                   movel     'U '          BUCKEY
     c                   movel     'DUMMY'       lo2
     C                   z-add     *zero         kststl
     C                   other
     C                   endsl
     C*
     C                   clear                   iffart
     C                   if        #LBLBSTKZ = 'S'  and
     C                             (#LBLBLSTC = '815' or #LBLBLSTC = '825')
     C                   exsr      STORNO
     C                   if        $#AELFNR = *blank
     C                   exsr      STORNO2
     C                   endif
     C                   endif
     C*
      *                 Mengen für EL-System aufbereiten                      
     C                   select
     C                   when      BUCKEY   = 'FA'
     c     mng           mult      -1            mng
     C                   when      BUCKEY   = 'L '
     c     mng           mult      -1            mng
     C                   when      BUCKEY   = 'U '
     c     mng           mult      -1            mng
     C                   when      BUCKEY   = 'LV'
     c     mng           mult      -1            mng
     C                   when      BUCKEY   = 'AS'
     c     mng           mult      -1            mng
     C                   when      BUCKEY   = 'S '
     c     mng           mult      -1            mng
     C                   other
     C                   endsl
     C*
     C     ##2009        ENDSR
     C*
     C**************************************************************************
     C* sr2010: Status Wareneingang und Bestellposition
     C*-------------------------------------------------------------------------
     C*
     C     SR2010        BEGSR
     C*
     C                   clear                   ia                1 0
      *                 Wareneingangsstatus                                   
     C                   select
     C                   when      #STATUSWAE = '00'
      *                 WE erfolgt                                            
     C                   when      #STATUSWAE = '05'
      *                 WE Rücklieferung                                      
     C                   when      #STATUSWAE = '10'
      *                 Rechnungseingang                                      
     C                   when      #STATUSWAE = '20'
      *                 Rechnungsprüfung                                      
     C                   when      #STATUSWAE = '30'
      *                 Übernahme in FIBU                                     
     C                   when      #STATUSWAE = '90'
      *                 gesperrt                                              
     C                   other
     C                   endsl
     C*
      *                 Bestellpositionen Status                              
     C                   select
     C                   when      #STATUSBEP = '20'
      *                 AB- freigeben                                         
     C                   when      #STATUSBEP = '30'
      *                 Teillieferung                                         
     C                   when      #STATUSBEP = '35'
      *                 Rücklieferung mit Nachlieferung                       
     C                   when      #STATUSBEP = '36'
      *                 Teillieferung und Teilfaktura                         
     C                   when      #STATUSBEP = '38'
      *                 Rücklieferung ohne Nachlieferung                      
     C                   when      #STATUSBEP = '40'
      *                 Komplettlieferung                                     
     C                   when      #STATUSBEP = '45'
      *                 Komplettlieferung mit Teilfaktura                     
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '50'
      *                 Teilfaktura                                           
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '60'
      *                 Faktura                                               
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '65'
      *                 manueller Abschluss                                   
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '80'
      *                 FIBU-Übernahme                                        
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '90'
      *                 gesperrt                                              
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '91'
      *                 Bestellung freigeben                                  
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '92'
      *                 storniert                                             
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '93'
      *                 manuelle Dispo-Bedarfe                                
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '95'
      *                 Reorganisation                                        
     C                   z-add     1             ia
     C                   when      #STATUSBEP = '99'
      *                 Löschung                                              
     C                   z-add     1             ia
     C                   other
     C                   endsl
     C*
     C     ##2010        ENDSR
     C*
     C**************************************************************************
     C* sr2002: lesen von Lagerbewegung auf WE/Rechnung von Trend
     C*-------------------------------------------------------------------------
     C*
     C     SR2002        BEGSR
     c*
      *                 Key: firma / timestamp ==> AEFIRM / AETMST            
      *                                                                        
     c                   movel     ' '           #BBEP
     c                   movel     ' '           #BWAE
     c                   movel     ' '           #BGFS
     c                   move      ' '           #BBEP2
     c                   move      ' '           #BWAE2
     c                   clear                   AEWeJJ#
     c                   clear                   AEwenr#
     c                   clear                   #AEFIRM
     c                   clear                   #AEBeJJ
     c                   clear                   #AEBenr
     c                   clear                   #AEBEPO
      *                                                                        
     c                   clear                   #AELFNR
     c                   clear                   #AEWEJJ
     c                   clear                   #AEWENR
     c                   clear                   #STATUSWAE
     c                   clear                   #STATUSBEP
      *                                                                        
      *                 Wareneingang lesen                                    
     C     KEY2002a      KLIST
     C                   KFLD                    #LBLBFIRM
     C                   KFLD                    #LBLBTMST
      *                                                                        
      *                 Bestellposition                                       
     C     KEY2002b      KLIST
     C                   KFLD                    AEFIRM
     C                   KFLD                    AEBeJJ
     C                   KFLD                    AEBenr
     C                   KFLD                    AEBEPO
      *                                                                        
     c                   setoff                                       73
      *                                                                        
     c     key2002a      chain     #bwae99
      *                 Wareneingang lesen                                    
     C                   if        %found(#bwae99)
     c                   seton                                        73
     c                   movel     '1'           #BWAE
     c                   movel     aewest        #STATUSWAE
     c                   endif
     C*
     C  n73              exsr      sr9900
     C*
     C                   if        *in73  = '1'
      *                 weitere Fehler                                        
      *                 WE_Lager <> Wareneingangslager                        
     c                   if        #LBLBLANR <> AEBWLA
     c                   move      '9'           #BWAE2
     c                   endif
      *                 WE_menge <> abgerechnete Menge                        
     c                   if        #LBLBBWMG <> AEBRMG
     c                   move      '2'           #BWAE2
     c                   endif
      *                 WE_artikel <> Artikel WE-Satz                         
     c                   if        #LBLBTENR <> AETENR
     c                   move      '1'           #BWAE2
     c                   endif
     C*
     c                   eval      #AEFIRM  =   AEFIRM
     c                   eval      #AEBeJJ  =   AEBeJJ
     c                   eval      #AEBenr  =   AEBenr
     c                   eval      #AEBEPO  =   AEBEPO
     c                   eval      #AELFNR  =   AELFNR
     c                   eval      #AEWEJJ  =   AEWEJJ
     c                   eval      #AEWENR  =   AEWENR
     C*
      *                 Bestellposition lesen                                 
     c     key2002b      chain     bbep00
     C                   if        %found(bbep00)
     c                   movel     '1'           #BBEP
     c                   movel     epbest        #STATUSBEP
     C*
      *                 weitere Fehler                                        
      *                 WE_Lager <> Wareneingangslager                        
     c                   if        eplanr   <> AEBWLA
     c                   move      '9'           #BBEP2
     c                   endif
      *                 WE_Lieferant <> Lieferant WE-SATZ                     
     c                   if        eplfnr   <> AElfnr
     c                   move      '3'           #BWAE2
     c                   endif
      *                 WE_menge <> abgerechnete Menge                        
     c                   if        epBRMG   <> AEBRMG
     c                   move      '2'           #BBEP2
     c                   endif
      *                 WE_artikel <> Artikel WE-Satz                         
     c                   if        epTENR   <> AETENR
     c                   move      '1'           #BBEP2
     c                   endif
      *                 Bestellung anlegen (buckey = 'Z ' or buckey = 'K ')   
     C                   if        #LBLBLSTC = '815' or #LBLBLSTC = '825'
     c                   exsr      SR9830
     c                   z-add     #num          AEWeJJ#
     c**************     eval      AEBeJJ#    =  AEBeJJ
     c                   eval      AEwenr#    =  #AEWENR
     c     ' ':'0'       xlate     AEWenr#       AEWenr#
     c                   seton                                        55       
     c                   endif
     c                   endif
     C*
     c                   endif
     C*
     C     ##2002        ENDSR
     C*
     C**************************************************************************
     C* sr2005: PRJ535 anlegen Bestellungen
     C*-------------------------------------------------------------------------
     C*
     C     SR2005        BEGSR
     c*
      *                 Zur Ermittlung einiger Felder ist das lesen der       
      *                 537 erforderlich (wurde im CALL generiert)            
      *                 wenr muss eindeutig sein                              
      *                                                                        
     C     KEY2005       KLIST
     C                   KFLD                    wenr
     C                   KFLD                    artnum
     C                   KFLD                    buckey
      *                                                                        
     c     key2005       chain     PRJ537l11
     C                   if        %found(PRJ537l11)
     c                   z-add     BUCDAT        BUCDAT
     c                   z-add     BEWDAT        BEWDAT
     c                   z-add     BEWTIM        BEWTIM
     c                   z-add     24            wschl
     c*
      *                 Bestellungsvorgang anlegen  WE-Eingang                
     c                   setoff                                       33
     c     wenr          chain     PRJ535P
     C                   if        not %found(PRJ535P)
     c                   z-add     mng           mngein
      *                                                                        
      *                 Rechnungen liegen vor? lesen der #blpo99              
     c                   exsr      sr9910
      *                                                                        
     c                   movel     enh           ENHEIN
     C                   eval      §BSTPOS       =   §BSTPOS
     C                   eval      §BSTnum       =   §BSTnum
     C                   eval      §erg          =   §erg
      *                 Ist-Menge ???? nur wenn rechnung vorliegt status      
     C*****hier***    d  eval      iffmng = #LBLBBWMG
     C*   ohne bestabndsführung kst 4711  Artikelstamm
     C*   siehe Änderung Organisation    dann richtige kostenstelle
      *                 Preis Bestellung                                      
     C                   eval      bstprs = EPPREI
      *                 enhlfr preiseinheit in Bestellung EPMEPR ==> enhlfr   
     C                   exsr      sr2000b
      *                 faklfr derzeit nicht Standard aus A-Stamm             
     C*             faklfr faktor lieferant umrechnungseinheit auf unsere EH
     C*    enhlfr * fakrot = enhbas
      *                 Mengeneinheit Bestellung exsr sr2000a (enhmng)        
     C                   exsr      sr2000a
      *                 fakmng derzeit nicht Standard aus A-Stamm             
     C*   fakmng = faktor menge
     C*   externe * faktor = intern
      *                 Lieferantennummer Lieferschein (lfrsch)  WE           
     C                   movel     AEBLIN        lfrsch
      *                 zusatztext bei Wareneingang                           
     C                   movel     AEBUT1        buctxt
      *                 Lieferantennummer (lifnr)  Bestellung                 
     C                   movel     eplfnr        lifnr
     C                   eval      lifnr= lifnr/10000
      *                 währungsschlüssel bestellung wschl                    
     C                   exsr      SR2000z
      *          rabmng = rabatt wenn vorliegt (bestellposition) n e i n      
     C*
     C                   movel     'J'           f02
     C                   exsr      SR2006
     C                   z-add     #aebepo       angpos
     c                   write     prj535F
     c                   ELSE
      *                 darf nicht sein (hier zunächst ausschluss)            
     c                   setoff                                       37
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'Korrektur Wareneing'
     C                   eval      iffout = mngerf
     C                   endif
     c   37              update    PRJ535F
     c                   endif
     C*
     c                   endif
     C*
     C     ##2005        ENDSR
     C*
     C**************************************************************************
     C* sr2006: Artikeldaten lesen
     C*-------------------------------------------------------------------------
     C*
     C     SR2006        BEGSR
     c*
      *                 Artikelzusatzdaten                                    
     c     artnum        chain     prj015p
     C                   if        not %found(prj015p)
     C*     hier prsfak Preisfaktor siehe Artikelstamm aus besttellung   **
     C*     ?            movel     prsfak        enhstl
      *
     C*                  enhstl = interne einheit bestände
     C                   movel     enhstl        enhstl
     c
     C*                  enhbas preiseinheit Artikelstamm
     C                   movel     §PRSENH       enhbas
     c                   endif
      *
     C     ##2006        ENDSR
     C*
     C**************************************************************************
     C* SR9800: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9800        BEGSR
     C*
     C     KEY9800       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c     KEY9800       chain     systempf
     c                   IF        %found(systempf)
     c*
     c                   ENDIF
     C*
     C     ##9800        ENDSR
     C*
     C**************************************************************************
     C* SR9810: Call auf Buchungsprogramm
     C*-------------------------------------------------------------------------
     C*
     C     SR9810        BEGSR
     C*
     C                   setoff                                       50
     C*
     c   40              movel     'I'           TYP
     c   40              movel     'II'          BUCKEY
     c***40  3.11.2011   movel     #LBLBLORT     LO
     c   40              movel     #LBLBLANR     LO
     c   40              move      ARTSKU        #ARTNUM          11
     c   40              movel     '0'           #ARTNUM          11
     c   40              movel     #ARTnum       ARTNUM
     c***** 03.11.2011   if        #LBLBLORT  = *blank
     c   40              movel     '000 #000'    LO
     c   40              movel     #LBLBLANR     LO
     c***** 03.11.2011   endif
     c                   move      #LBLBBDAT     Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   clear                   #d                8
     C                   eval      %subst(#d: 3: 2)    = pjahr
     C                   eval      %subst(#d: 5: 2)    = pmonat
     C                   eval      %subst(#d: 7: 2)    = ptag
     C                   eval      %subst(#d: 1: 2)    = '00'
     C*
     c                   move      #d            BUCDAT
     C                   movel     #LBLBTMST     BUCTXT
     C*
      *                 Mengeneinheiten                                       
     C                   exsr      SR2000
      *                 lesen von Lagerbewegung auf WE/Rechnung von Trend     
     C                   exsr      SR2002
      *                 Wechel Lieferant Rechnung und Lieferung               
     C********           if        %subst(LIEFERANT2: 1: 4)    = 'SABE'
     C                   if        LIEFERANT1 <> *blank
     C                   movel     LIEFERANT1    eplfnr
     C                   endif
     C                   if        LIEFERANT2 <> *blank  and
     C                             eplfnr     =  *blank
     C                   movel     LIEFERANT2    eplfnr
     C                   endif
     C********           endif
      *                 Zuweisung der Buchungscodes                           
     C                   exsr      SR2009
      *                 status WARENEINGANG und BESTELLPOSITION               
     C                   exsr      SR2010
     c*
     c**   ' ':'0'       xlate     AEBenr#       AEBenr#
     c                   eval      BSTPOS    =   #AEBEPO
     c     ' ':'0'       xlate     AEWenr#       AEWenr#
     c                   move      #AEBENR       BSTnum
      *                 Anlage 537p über Call                                 
     c                   if        #LBLBLSTC <> '816'
     c                   call      'PRJ522U2'
     c                   parm                    callpgm
     c                   endif
     c
      *                 05.03.2018 Anlage
     c                   if        #LBLBLSTC =  '816'
     c                   call      'PRJ522U2'
     c                   parm                    callpgm
     c                   endif
     c
      *                 Bestellungsvorgang anlegen bei buckey = 'Z ', 'K '    
      *                 anlegen 55=1                                          
     c                   if        #LBLBLSTC <> '816'
     c   55              exsr      sr2005
     c                   endif
     c
     c                   movel     #LBLBTMST     #TIMESTAM2
     c                   setoff                                       55
     c*
     C     ##9810        ENDSR
     C*
     C**************************************************************************
     C* SR9820: Protokoll
     C*-------------------------------------------------------------------------
     C*
     C     SR9820        BEGSR
     C*
     C     KEY9820       KLIST
     C                   KFLD                    #LBLBFIRM
     C                   KFLD                    #LBLBTMST
     C
     c**** KEY9820       chain     #LBlb
     c****               IF        %found(#LBlb)
     C                   if        #LBLBSTKZ = 'S'  and
     C                             (#LBLBLSTC = '815' or #LBLBLSTC = '825')
     C                   movel     'J'           #STORNO
     C                   endif
     C                   movel     artnum        §artnum
     c   76              z-add     iffmng        #RWERT
     c  n76              clear                   #RWERT
     C                   z-add     wenr          #WE#EL
      *                 Wechel Lieferant Rechnung und Lieferung               
     C*******            if        %subst(LIEFERANT2: 1: 4)    = 'SABE'
     C                   if        LIEFERANT1 <> *blank
     C                   movel     LIEFERANT1    #AELFNRR
     C                   endif
     C                   if        LIEFERANT2 <> *blank  and
     C                             eplfnr     =  *blank
     C                   movel     LIEFERANT2    #AELFNRR
     C                   endif
     C*******            endif
     C                   eval      #LBLBLOCK  =  #LBLBLOCK
     C                   eval      #LBLBJNAM  =  #LBLBJNAM
     C                   eval      #LBLBJDAT  =  #LBLBJDAT
     C                   eval      #LBLBJZEI  =  #LBLBJZEI
     C                   eval      #LBLBUSER  =  #LBLBUSER
     C                   eval      #LBLBPROG  =  #LBLBPROG
     C                   eval      #LBLBBIBL  =  #LBLBBIBL
     C                   eval      #LBLBFIRM  =  #LBLBFIRM
     C                   eval      #LBLBTMST  =  #LBLBTMST
     C                   eval      #LBLBBSTY  =  #LBLBBSTY
     C                   eval      #LBLBWKNR  =  #LBLBWKNR
     C                   eval      #LBLBLANR  =  #LBLBLANR
     C                   eval      #LBLBBSLA  =  #LBLBBSLA
     C                   eval      #LBLBTENR  =  #LBLBTENR
     C                   eval      #LBLBFBNR  =  #LBLBFBNR
     C                   eval      #LBLBGEBI  =  #LBLBGEBI
     C                   eval      #LBLBCONT  =  #LBLBCONT
     C                   eval      #LBLBBHNR  =  #LBLBBHNR
     C                   eval      #LBLBLORT  =  #LBLBLORT
     C                   eval      #LBLBCHAR  =  #LBLBCHAR
     C                   eval      #LBLBFUMG  =  #LBLBFUMG
     C                   eval      #LBLBKDNR  =  #LBLBKDNR
     C                   eval      #LBLBLFNR  =  #LBLBLFNR
     C                   eval      #LBLBMEIN  =  #LBLBMEIN
     C                   eval      #LBLBLSTC  =  #LBLBLSTC
     C                   eval      #LBLBBDAT  =  #LBLBBDAT
     C                   eval      #LBLBBZEI  =  #LBLBBZEI
     C                   eval      #LBLBBWMG  =  #LBLBBWMG
     C                   eval      #LBLBBWME  =  #LBLBBWME
     C                   eval      #LBLBSTMG  =  #LBLBSTMG
     C                   eval      #LBLBSTKZ  =  #LBLBSTKZ
     C                   eval      #LBLBLGBS  =  #LBLBLGBS
     C                   eval      #LBLBDANA  =  #LBLBDANA
     C                   eval      #LBLBDAKY  =  #LBLBDAKY
     C                   eval      #LBLBKOTR  =  #LBLBKOTR
     C                   eval      #LBLBKSST  =  #LBLBKSST
     C                   eval      #LBLBKOAR  =  #LBLBKOAR
     C                   eval      #LBLBMOKZ  =  #LBLBMOKZ
     C                   eval      #LBLBFBKZ  =  #LBLBFBKZ
     C                   eval      #LBLBDRKZ  =  #LBLBDRKZ
     C                   eval      #LBLBRGKZ  =  #LBLBRGKZ
     C                   eval      #LBLBCSKZ  =  #LBLBCSKZ
     C                   eval      #LBLBKZ01  =  #LBLBKZ01
     C                   eval      #LBLBKZ02  =  #LBLBKZ02
     C                   eval      #LBLBBEZ1  =  #LBLBBEZ1
     C                   eval      #LBLBBEZ2  =  #LBLBBEZ2
     C                   eval      #LBLBUTMS  =  #LBLBUTMS
     C                   eval      #LBLBBSEI  =  #LBLBBSEI
     C                   eval      #LBLBQSST  =  #LBLBQSST
     C                   eval      #LBLBQSTM  =  #LBLBQSTM
     C                   eval      #LBLBWBKT  =  #LBLBWBKT
     C                   eval      #LBLBEBKT  =  #LBLBEBKT
     C                   eval      #LBLBSPKZ  =  #LBLBSPKZ
     C                   eval      #LBLBSPGR  =  #LBLBSPGR
     C                   eval      #LBLBFRIN  =  #LBLBFRIN
     C                   eval      #LBLBFREX  =  #LBLBFREX
     C                   eval      #BUCHUNG   =  ' '
     C*********          eval      #TSTAMP    =  tstampi
     C                   movel     tstampi       #tstampi         26
     C*
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'ARTIKEL FEHLT IN TB' and
     C                             #STATUS    =  '  '
     C                   eval      #STATUS    =  '01'
     C                   end
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'DATUM ABGESCHLOSSEN' and
     C                             #STATUS    =  '  '
     C                   eval      #STATUS    =  '02'
     C                   end
     C*
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'ARTIKEL FEHLT IN TB' and
     C                             #STATUS    =  '01'
     C                   eval      #STATUS    =  '30'
     C                   end
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'DATUM ABGESCHLOSSEN' and
     C                             #STATUS    =  '02'
     C                   eval      #STATUS    =  '30'
     C                   end
     C*
     C*
     C                   movel     ERRTXT        #ERRORTXT
     C*****              move      BUCKEY        #ERRORTXT
     C                   eval      %subst(#ERRORTXT: 20: 26)  = #tstampi
     C                   eval      %subst(#ERRORTXT: 55: 8)  =
     C                             %subst(lo: 01: 8 )
     C                   eval      %subst(#ERRORTXT: 66: 3)  =
     C                             %subst(enh: 01: 3 )
     C                   eval      %subst(#ERRORTXT: 70: 5)  =
     C                             %subst(lo2: 01: 5 )
     C                   z-add     artnum        #artnums
     C                   movel     BUCKEY        #BUCKEY
     C                   update    #LBLBR
     c*****              endif
     C*
     C     ##9820        ENDSR
     C*
     C**************************************************************************
     C* SR9830: lesen Parameterdaten Zählschleife
     C*-------------------------------------------------------------------------
     C*
     C     SR9830        BEGSR
     C*
     C     KEY9830       KLIST
     C                   KFLD                    sa
     C
     C     *LIKE         DEFINE    num           #num
     C                   movel     'A '          sa
     C*
     c     KEY9830       chain     prj535zp
     c                   IF        %found(prj535zp)
     c                   eval      num   = num + 1
     c                   z-add     num           #num
     C                   if        %subst(#ERRORTXT: 1: 19) =
     C                             'Korrektur Wareneing'
     C                   eval      iffout = mngerf
     C                   endif
     c                   update    PRJ535ZF
     c                   else
     c                   clear                   #num
     c                   unlock    prj535zp
     c                   ENDIF
     C*
     C     ##9830        ENDSR
     C*
     C**************************************************************************
     C* SR9900: lesen über bwae09
     C*-------------------------------------------------------------------------
     C*
     C     SR9900        BEGSR
     C*
      *                 Wareneingang lesen                                    
     C     KEY9900       KLIST
     C                   KFLD                    #LBLBFIRM
     C                   KFLD                    ##year            4 0
     C                   KFLD                    ##wae             6 0
     C*
     C                   clear                   #waex             6
     C                   clear                   #wae              6
     C                   movel     #LBLBDAKY     ##year
     C                   eval      #waex =  %subst(#LBLBDAKY: 05: 6)
     C                   evalr     #wae  =  %trimr(#waex)
     C     ' ':'0'       xlate     #wae          #wae
     C
     C                   movel     #wae          ##wae
     C*
     c                   clear                   #BWAE
     c                   clear                   #STATUSWAE
     C*
     C                   if        %subst(#LBLBDAKY: 05: 6) <> *blank  and
     C                             %subst(#LBLBDAKY: 05: 6) <> '000000'
     c     KEY9900       chain     bwae09
     c                   IF        %found(bwae09)
     c                   movel     '2'           #BWAE
     c                   movel     aewest        #STATUSWAE
     c                   seton                                        73
     c                   ENDIF
     c                   ENDIF
     C*
     C     ##9900        ENDSR
     C*
     C**************************************************************************
     C* SR9910: Rechnungen liegen vor? lesen der #blpo99
     C*-------------------------------------------------------------------------
     C*
     C     SR9910        BEGSR
     C*
     c                   clear                   IFFMNG
      *                 Rechnungen liegen vor? lesen der #blpo99              
     C     KEY#blpo      KLIST                                                 
     c                   kfld                    #LBLBFIRM
     C                   KFLD                    AEWEJJ                        
     C                   KFLD                    AEWENR                        
     c                   setoff                                       76       
     C     KEY#blpo      SETLL     #BLPO99                            99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #BLPO99                                99
     c                   if        *in99 ='1'                        or
     c                             AEWEJJ   <> BLPOWEJJ              or
     c                             AEWENR   <> BLPOWENR
     C                   LEAVE
     C                   else
     c                   seton                                        76       
     c                   eval      iffmng =          mng
     c*                  eval      iffmng = iffmng + BLPOMENG
     c                   endif                                                 
     c                   enddo
     C                   endif
     C*
     C     ##9910        ENDSR
     C*
     C**************************************************************************
     C*Kundendaten lesen
     C*-------------------------------------------------------------------------
     C*
     C     sr9850        BEGSR
     C*
      * :Kundendaten lesen
     c     keysr_afko    klist
     c                   kfld                    #LBLBFIRM
     c                   kfld                    akAFJJ
     c                   kfld                    akAFNR

     c                   movel     #LBLBDAKY     a                10
     c                   movel     a             akAFJJ
     c                   move      a             akAFNR

     c     keysr_afko    chain     afko01                             96
     c   96              clear                   afko1
     C*
     C     ##9850        ENDSR
     C*
     C**************************************************************************
     C*storno: stornos ableiten1
     C*-------------------------------------------------------------------------
     C*
     C     storno        BEGSR
     C*
      *                 lesen rechnungsbezug ermitteln                        
     C     *LIKE         DEFINE    #WE#EL        $#WE#EL
     C     *LIKE         DEFINE    #AELFNR       $#AELFNR
     C                   clear                   $#WE#EL
     C                   clear                   $#AELFNR
     C                   eval      #lblbutms  =  #LBLBUTMS
     C*
     c/exec sql
     c+ whenever not found goto ##storno
     c/end-exec
     C*
     c/exec sql
     c+ SELECT   #WE#EL, #AELFNR into
     c+ :$#WE#EL, :$#AELFNR
     c+ FROM #lblbl2
     c+ where #LBLBTMST = :#lblbutms
     c/end-exec
     C*
     C                   if        wewe <>'1'
     c/exec sql
     c+ update   prj535p  set
     c+ iffart = 'S'
     c+ where  WENR  = :$#WE#EL
     c/end-exec
     C                   endif
     C*
     C                   if        wewe = '1'
     c/exec sql
     c+ update   prj535p  set
     c+ iffart = 'S', iffout = mngerf
     c+ where  WENR  = :$#WE#EL and iffmng=0 and
     c+        BUCTXT = substr(:#LBLBTMST, 1, 25)
     c/end-exec
     C                   endif
     C*
     c/exec sql
     c+ update   #lblbl2  set
     c+ #STORNO = 'J'
     c+ where #LBLBTMST = :#lblbutms
     c/end-exec
     C*
     C                   eval      iffart = 'S'
     C                   if        $#AELFNR <> *blank
     C                   movel     $#AELFNR      lifnr
     C                   eval      lifnr= lifnr/10000
     c                   movel     'Z '          BUCKEY
     C                   endif
     C
     C     ##storno      ENDSR
     C*
     C**************************************************************************
     C*storno: stornos ableiten2
     C*-------------------------------------------------------------------------
     C*
     C     storno2       BEGSR
     C*
      *                 lesen rechnungsbezug ermitteln                        
     C                   clear                   $#WE#EL
     C                   clear                   $#AELFNR
     C                   eval      #lblbutms  =  #lblbutms
     C*
     c/exec sql
     c+ whenever not found goto ##storno2
     c/end-exec
     C*
     c/exec sql
     c+ SELECT   #WE#EL, #AELFNR into
     c+ :$#WE#EL, :$#AELFNR
     c+ FROM #lblbl2
     c+ where #LBLBDAKY = :#LBLBDAKY and #LBLBTENR =:#LBLBTENR
     c/end-exec
     C*
     c/exec sql
     c+ update   prj535p  set
     c+ iffart = 'S'
     c+ where  WENR  = :$#WE#EL
     c/end-exec
     C*
     c/exec sql
     c+ update   #lblbl2  set
     c+ #STORNO = 'J'
     c+ where #LBLBDAKY = :#LBLBDAKY and #LBLBTENR =:#LBLBTENR
     c/end-exec
     C*
     C                   eval      iffart = 'S'
     C                   if        $#AELFNR <> *blank
     C                   movel     $#AELFNR      lifnr
     C                   eval      lifnr= lifnr/10000
     c                   movel     'Z '          BUCKEY
     C                   endif
     C
     C     ##storno2     ENDSR
     C*
     C**************************************************************************
     C*Datumsbezüge
     C*-------------------------------------------------------------------------
     C*
     C     sr0000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##0000
     c/end-exec
     C*
     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   kalk_file
     c/end-exec
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   clear                   #d                8
     C                   eval      %subst(#d: 3: 2)    = pjahr
     C                   eval      %subst(#d: 5: 2)    = pmonat
     C                   eval      %subst(#d: 7: 2)    = ptag
     C                   eval      %subst(#d: 1: 2)    = '00'
     C*
     C     ##0000        ENDSR
     C*
     C**************************************************************************
     C     *inzsr        BEGSR
     c                   move      '01'          firma             2
     c                   movel     'LP1'         begr              3
     c                   z-add     9110000000    #sku             10 0

     C     *DTAARA       DEFINE                  #TIMESTAM2       26
     C     *lock         IN        #TIMESTAM2

     C     *DTAARA       DEFINE                  $TIMESTAM2       26
     C     *lock         IN        $TIMESTAM2

     c                   exsr      sr0000

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
      ************************************************************
      * LAGERBUCHUNG PARAMETER
      ************************************************************
      *01  LNK538.
      *#   02     TYP         PIC X.
      *#                          I=INTERAKTIV  BUCHEN
      *#                          B=BATCH       BUCHEN
      *#                          O=FILE OPEN
      *#                          C=FILE CLOSE
      *#                          -+ VORZEICHEN AUS JAVA
      *#   02     BUCDAT      PIC 9(8).
      *#                          BUCHUNGSDATUM 00JJMMTT
      *    02     WENR        PIC 9(14).
      *                           WARENEINGANGSNUMMER + KONTEIERUNG
      *    ? wareneingangszugriff
      *    02     BELNUM      PIC 9(11).
      *                           AUFTRAGSBELEG
      *    02     LIFNR       PIC 9(11).
      *    ? lieferant
      *    02     HANR        PIC X(11).
      *    02     BSTNUM      PIC 9(7).
      *    ? lieferant  muss bei Lieferant
      *    02     BSTPOS      PIC 9(4).
      *    ? für rechnungsprüfung auf bestellebene
      *    02     KSTSTL      PIC 9(7).
      *    ? wenn kostenstelle
      *    02     KUNDNR      PIC 9(7).
      *    ? lieferung an kunde
      *    02     AFTNUM      PIC 9(11).
      *    ? lieferung an kunde aufragsnummer für kunde oder eigene Fertigun
      *    02     AFTPOS      PIC 9(04).
      *    ? lieferung an kunde aufragsnummer für kunde oder eigene Fertigun
      *    02     BUCKEY      PIC X(02).
      *                           I  =INVENTUR ZUR LAUFZEIT
      *                           Z  =ZUGANG VON LIEFERANT
      *                           N  =EINHEIETNUMRECHNUNG
      *                           U  =UMBUCHUNG
      *                           L  =Lieferung an Kunde
      *                           FA =FERTIGUNGSABGANG
      *                           FZ =FERTIGUNGSZUGANG
      *                           LA =ABGANG AN LIEFERANT
      *                           LU =LIEFERANTENBEREITSTELLUNG
      *                           LV =LIEFERANTENVERBRAUCH
      *                           II = INVENTUR ZUM STICHTAG
      *                           IA = ÜBERNAHME AUS ALTSYSTEM
      *                           KA = ABGANG AN KUNDEN
      *                           KE = RÜCKNAHME VOM KND
      *    02     ARTNUM      PIC 9(11).
      *    02     ARTNUMVAR   PIC 9(04).
      *    02     VARTYP      PIC X.
      *    02     LO          PIC X(8).
      *                       LAGERORT      ANFORDERUNG    v o n
      *    02     LO2         PIC X(8).
      *                       LAGERORT      ANFORDERUNG DER UMBUCHUNG  wohin
      *    02     ENH         PIC X(5).
      *                       MENGENEINHEIT ANFORDERUNG
      *    02     MNG         PIC S9(8)V9(4).
      *                       MENGE         ANFORDERUNG
      *    02     ABM1        PIC S9(9)V9(2).
      *    02     ABM2        PIC S9(9)V9(2).
      *    02     ABM3        PIC S9(9)V9(2).
      *    02     ABMENH      PIC XXX.
      *    02     ERG         PIC S9(9)V9(2).
      *    02     ERGENH      PIC XXX.
      *                       MENGE         ANFORDERUNG
      *    02     MNG2        PIC S9(8)V9(4).
      *                       MENGE         ANFORDERUNG UMBUCHUNG
      *    02     LOIST       PIC X(8).
      *                       LAGERORT      IST
      *    02     LOIST2      PIC X(8).
      *                       LAGERORT      IST         DER UMBUCHUNG
      *    02     ENHIST      PIC X(5).
      *                       MENGENEINHEIT IST
      *    02     MNGIST      PIC S9(8)V9(4).
      *                       MENGE         IST
      *    02     MNGIST2     PIC S9(8)V9(4).
      *                       MENGE         IST         UMBUCHUNG
      *    02     LOAVW       PIC X(5).
      *                       ORT DER AVW-BUCHUNG
      *    02     MNGAVW      PIC S9(8)V9(4).
      *                       MENGE         IST AVW     IN STÜCK
      *    02     BUCTXT      PIC X(25).
      *                       BUCHUNGSVERMERK
      *    ? was ich möchte
      *    02     ERRCDE      PIC XX.
      *                       FEHLERCODE '  '=OK
      *    ? was war los (nicht ERRCDE)
      *    02     ERRTXT      PIC X(79).
      *                       FEHLERTEXT
      *    02     STAINP      PIC X(01).
      *                       FERTIGUNGSSTAUS
      *    02     KONKNZ      PIC X.
      *                       KONSIGNATIONSBEWEGUNG
      *    02     KUNKNZ      PIC X.
      *                       KUNDENWARE
      *                       MEHRFACHBELEGUNG
      *                       1= OHNE DATUMSCHECK
      *    02     MVKNZ       PIC X(04).
      *    02     CHARGE      PIC X(20).
