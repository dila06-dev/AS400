     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F* ganz wichtig: fortlaufende Nummer wird gefordert         *
     F* Clr 22              out       unique_f                   *
     F*                                                          *
     F* update #afrk_f set status = ' ', #cc= 0 whERE #CC = 1149 *
     F*                                                          *
     F* CHGDTAARA DTAARA(UNIQUE_F *ALL) VALUE(300082)            *
     F*              * letzte verwendete aus Datei               *
     F* CHGDTAARA DTAARA(RPM_LOADR  *ALL) VALUE(1148)            *
     F*              * letzte verwendete aus Datei               *
     F* clrpfm ct_ford                                           *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  Ford interface zu Clifford Thames                       *
 MG01F*  Änderung:  11.02.2011                                   *
 MG01F*  Indicator = 'Y' wenn kein Positionswert bei D           *
     F*  N638:  252 ==> 'Y',  054 ==> 'A'                        *
     F*  immer jetzt  auf '00000000' initialisiert, da fehler    *
     F*  von Ford gemeldet                                       *
     F*  movel     '00000000'    #rkvada           8             *
     F*                                                          *
     F*  15.03.2012 AFUL implementieren wegen Auflösung Stück-   *
     F*             listenauflösung                              *
     F*                                                          *
     F*SELECT JAHR, MONAT, ITEM, APGLMG, dec(count(*), 10, 0 ) anzahl FROM
     F*rpm_lfs GROUP BY JAHR, MONAT, ITEM, APGLMG
     F*Datei RPM_LFS_Q2 in TVRELWAECO wurde ersetzt.
     F*                                                          *
     F*                                                          *
     F* select distinct
     F*      ITEM , ARTNR, LADEM, LFSL, LFSH, LFSB, dec(0, 10, 0)
     F* JanA,dec(0, 10, 0) FEBA,dec(0, 10, 0) MAEA, dec(0, 10, 0)
     F* APRA,dec(0, 10, 0) MaiA,dec(0, 10, 0) junA, dec(0, 10, 0)
     F* JulA,dec(0, 10, 0) augA,dec(0, 10, 0) sepA, dec(0, 10, 0)
     F* oktA,dec(0, 10, 0) novA,dec(0, 10, 0) dezA, dec(0, 10, 0) akta,
     F*                                             dec(0, 10, 0)
     F* Janh,dec(0, 10, 0) FEBh,dec(0, 10, 0) MAEh, dec(0, 10, 0)
     F* APRh,dec(0, 10, 0) Maih,dec(0, 10, 0) junh, dec(0, 10, 0)
     F* Julh,dec(0, 10, 0) augh,dec(0, 10, 0) seph, dec(0, 10, 0)
     F* okth,dec(0, 10, 0) novh,dec(0, 10, 0) dezh, dec(0, 10, 0) akth
     F* FROM rpm_lfs
     F*                                                          *
     F* update RPM_LFS_Q1 a set jana=                            *
     F* (select sum(APGLMG) from RPM_LFS_Q2 b                    *
     F*         where jahr=2016 and monat=01 and b.item=a.item   *
     F*          group by  jahr, monat, item)                    *
     F* where exists                                             *
     F* (select sum(APGLMG) from RPM_LFS_Q2 b                    *
     F*         where jahr=2016 and monat=01 and b.item=a.item   *
     F*          group by  jahr, monat, item)                    *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     h  option(*SRCSTMT:*NoDebugIO)

     fRPM_LOAD  up   e             disk    RENAME(RPM_LOAD:PHY01R)
     fRPMII_TO  if a e             disk    RENAME(RPMII_TO:PHY02R)
     f                                     prefix('#')
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     f#afulL1   if   e           k disk
     fafko01    if   e           k disk
     fkund01    if   e           k disk
     fKDZR01    if   e           k disk
     ftxbe01    if   e           k disk
     ftrtp01    if   e           k disk
     fteil01    if   e           k disk
     fkdew01    if   e           k disk
     fteew01    if   e           k disk
     fwaeh01    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     Dweek             s              1s 0
     D
     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10

     I*-------------------------------------------------------------------------

     c                   seton                                        22

     c                   if        week   > 0
     c                   if        status = '  '  and RKRGNR > '156149'
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *DTAARA       DEFINE                  RPM_LOADR        10 0
     C  n25*lock         IN        RPM_LOADR
     C  n25              eval      RPM_LOADR  =  RPM_LOADR   + 1
     C                   if        *in22      = '1'
     C  n25              out       RPM_LOADR
     C                   endif
     c                   seton                                        25
     c                   exsr      sr1000
     c                   if        rkerg1 <> *zero
     c   55              movea     '1000'        *IN(41)
     c   55              exsr      sr_002b
     c                   endif
     c                   if        rkerg2 <> *zero
     c   55              movea     '0100'        *IN(41)
     c   55              exsr      sr_002b
     c                   endif
     c                   if        rkerg3 <> *zero
     c   55              movea     '0010'        *IN(41)
     c   55              exsr      sr_002b
     c                   endif
     c                   if        rkerg4 <> *zero
     c   55              movea     '0001'        *IN(41)
     c   55              exsr      sr_002b
     c                   endif
     c                   eval      status = '10'
     c                   eval      #cc = RPM_LOADR
     c   55              movel     '* '          RPM_LOADR
     c  n55              movel     akafat        RPM_LOADR
     c   22              update    phy01r

     c                   endif
     c                   endif
     c   lr              exsr      sr2000

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_afrk    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     C*
      * :Rechnungskopf  -1-
     c     keysr_afrk    chain     AFRK01                             92
     c
      * :Rechnungspositionen -2-
     c                   if        *in92 = '0'
     C     keysr_afrk    SETLL     AFRP01                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      AFRP01                                 95
     C                   IF        *in95 = '1'            or
     C                             RKFIRM   <>  RpFIRM    or
     C                             RKRGJJ   <>  RpRGJJ    or
     C                             RKRGNR   <>  RpRGNR    or
     C                             RKLIJJ   <>  RpLIJJ    or
     C                             RKLINR   <>  RpLINR
     C                   leave
     C                   else
     c                   exsr      sr_002
     c                   endif
     c                   enddo
     c                   endif
     c                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_002        BEGSR
     C*
      * :lesen ob Position im Lieferschein vorhanden ( nicht bei
      * :Gutschriften oder Nichlagerführungsartikel )
      * :Auftragslieferpositionen -3-
     c     keysr_aflp    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     c                   kfld                    Rplipo
     c     keysr_aflp    chain     #aflpl1                            96
     c   96              clear                   aflp1
     C*
      * :Kopfdaten Auftrag
     c     keysr_afko    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR

     c     keysr_afko    chain     afko01                             96
     c   96              clear                   afko1
     C*
     c                   setoff                                       55
     c  n96              if        akafat='01' or akafat='02' or
     c                             akafat='03' or akafat='05' or
     c                             akafat='06' or akafat='08' or
     c                             akafat='25' or akafat='26' or
     c                             akafat='27' or akafat='28' or
     c                             akafat='31' or akafat='55' or
     c                             akafat='70' or akafat='71'
     c                   seton                                        55
     c                   endif
     C*
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     c                   movel     '0'           typProd           1
     C                   movel     'M'           Paym              1
     C*
     c* 15.03.2012                                               +
     C                   if        RPUPOS  <> 0
     C                   z-add     RPNESU        ALNESU
     C                   exsr      sr9020
     C                   endif
     C*
     c                   if        ALMWCD  = '16'
     c                   movel     '1900'        mwst              4
     c                   endif
     c
     c     ALKOW1        mult      100           kon1              4 0
     c     ALKOW2        mult      100           kon2              4 0
     c     ALKOW3        mult      100           kon3              4 0
     c     ALKOW4        mult      100           kon4              4 0
     c     kon1          mult      -1            kon1
     c     kon2          mult      -1            kon2
     c     kon3          mult      -1            kon3
     c     kon4          mult      -1            kon4
     c                   movel     kon1          #kon1             4
     c                   movel     kon2          #kon2             4
     c                   movel     kon3          #kon3             4
     c                   movel     kon4          #kon4             4
     c     ' ':'0'       xlate     #kon1         #kon1
     c     ' ':'0'       xlate     #kon2         #kon2
     c     ' ':'0'       xlate     #kon3         #kon3
     c     ' ':'0'       xlate     #kon4         #kon4
     c
     c
     c                   z-add     alglmg        menge             5 0
     c                   z-add     ALPREI        lpreis            9 2
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   z-add     ALNTSK        poswertn         11 2
     c                   z-add     ALNESU        poswertn         11 2
     c
     c                   movel     ALAFPO        #alafpo           4
     c                   movel     ALlipo        #allipo           4
     c
     c                   exsr      sr8050
     c
     c*******************
     c                   exsr      sr5000
     c
     C                   select
     C                   when      %subst(KDEWKSST :1 :8)='1001    '
     c                   eval      #division =      'RVOEM   '
     C                   when      %subst(KDEWKSST :1 :8)='1002    '
     c                   eval      #division =      'RVAM    '
     C                   when      %subst(KDEWKSST :1 :8)='1003    '
     c                   eval      #division =      'RETL    '
     C                   when      %subst(KDEWKSST :1 :8)='1004    '
     c                   eval      #division =      'LODG    '
     C                   when      %subst(KDEWKSST :1 :8)='1005    '
     c                   eval      #division =      'CPVOEM  '
     C                   when      %subst(KDEWKSST :1 :8)='1006    '
     c                   eval      #division =      'CPVAM   '
     C                   when      %subst(KDEWKSST :1 :8)='1007    '
     c                   eval      #division =      'MAOEM   '
     C                   when      %subst(KDEWKSST :1 :8)='1008    '
     c                   eval      #division =      'MAAM    '
     C                   when      %subst(KDEWKSST :1 :8)='1009    '
     c                   eval      #division =      'MEDI    '
     C                   other
     C                   endsl
     C*
     C                   select
     C                   when      akafat = '01'
     c                   eval      #doctype = 'Sales Invoice     01'
     C                   when      akafat = '02'
     c                   eval      #doctype = 'Sales Invoice     02'
     C                   when      akafat = '03'
     c                   eval      #doctype = 'Sales Invoice     03'
     C                   when      akafat = '04'
     c                   eval      #doctype = 'Sales Invoice     04'
     C                   when      akafat = '05'
     c                   eval      #doctype = 'Sales Invoice     05'
     C                   when      akafat = '06'
     c                   eval      #doctype = 'Sales Invoice     06'
     C                   when      akafat = '08'
     c                   eval      #doctype = 'Sales Invoice     08'
     C                   when      akafat = '10'
     c                   eval      #doctype = 'Sales Invoice     10'
     C                   when      akafat = '25'
     c                   eval      #doctype = 'Sales Invoice     25'
     C                   when      akafat = '26'
     c                   eval      #doctype = 'Sales Invoice     26'
     C                   when      akafat = '27'
     c                   eval      #doctype = 'Sales Invoice     27'
     C                   when      akafat = '28'
     c                   eval      #doctype = 'Sales Invoice     28'
     C                   when      akafat = '31'
     c                   eval      #doctype = 'Sales Invoice     31'
     C                   when      akafat = '55'
     c                   eval      #doctype = 'Sales Invoice     55'
     C                   when      akafat = '83'
     c                   eval      #doctype = 'Sales Invoice     83'
     C                   when      akafat = '88'
     c                   eval      #doctype = 'Sales Invoice     88'
     C                   when      akafat = '11'
     c                   eval      #doctype = 'Sales CR/Adj Note 11'
     C                   when      akafat = '14'
     c                   eval      #doctype = 'Sales CR/Adj Note 14'
     C                   when      akafat = '15'
     c                   eval      #doctype = 'Sales CR/Adj Note 15'
     C                   when      akafat = '16'
     c                   eval      #doctype = 'Sales CR/Adj Note 16'
     C                   when      akafat = '17'
     c                   eval      #doctype = 'Sales CR/Adj Note 17'
     C                   when      akafat = '18'
     c                   eval      #doctype = 'Sales CR/Adj Note 18'
     C                   when      akafat = '20'
     c                   eval      #doctype = 'Sales CR/Adj Note 20'
     C                   when      akafat = '44'
     c                   eval      #doctype = 'Sales CR/Adj Note 44'
     C                   when      akafat = '50'
     c                   eval      #doctype = 'Sales CR/Adj Note 50'
     C                   when      akafat = '70'
     c                   eval      #doctype = 'Sales CR/Adj Note 70'
     C                   when      akafat = '71'
     c                   eval      #doctype = 'Sales CR/Adj Note 71'
     C                   when      akafat = '81'
     c                   eval      #doctype = 'Sales CR/Adj Note 81'
     C                   when      akafat = '82'
     c                   eval      #doctype = 'Sales CR/Adj Note 82'
     C                   when      akafat  = '99'
     c                   eval      #doctype = 'Sales CR/Adj Note 99'
     C                   other
     C                   endsl
     C*
     C                   eval      #custcode=%subst(kDEWRPMG :2,:2)
     C
     C     ';':' '       xlate     ALTBZ1        ALTBZ1                 70
     C     ',':'.'       xlate     ALTBZ1        ALTBZ1                 70
     C     '"':' '       xlate     ALTBZ1        ALTBZ1                 70
     C     '´':' '       xlate     ALTBZ1        ALTBZ1                 70
     C     '`':' '       xlate     ALTBZ1        ALTBZ1                 70
     C     ';':' '       xlate     KDNAM1        KDNAM1                 70
     C     ',':'.'       xlate     KDNAM1        KDNAM1                 70
     C     '"':' '       xlate     KDNAM1        KDNAM1                 70
     C     '´':' '       xlate     KDNAM1        KDNAM1                 70
     C     '`':' '       xlate     KDNAM1        KDNAM1                 70
     C*
      * :teew01
     c     keysr_teew    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALTENR

     c     keysr_teew    chain     teew01                             96
     c   96              clear                   TEEWPRGR
     C*
      * :teil01
     c     keysr_teil    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALTENR

     c     keysr_teew    chain     teil01                             96
     c   96              clear                   testpr
     C*
     c*******************
     c                   movel     rplipo        #rplipo           4
     c                   eval      #POSTDATE     = #POSTDATE
     c                   eval      #ENTITY       = 'DE411'
     c                   eval      #COUNT_ISO    = KDPOLD
     c                   if        #COUNT_ISO    = *blank
     c                   eval      #COUNT_ISO    ='DE'
     c                   endif
     c                   eval      #SKU          = ALTENR
     c                   eval      #APTBZ1       = ALTBZ1
     c                   eval      #APGLMG       = alglmg
     c                   eval      #ENTRY#       = #ENTRY#
     c                   eval      #DOCTYPE      = #DOCTYPE
     c                   eval      #DOC          = %char(RPRGJJ) + '/' +
     c                                                  (RPRGNR) + '/' +
     c                                             %char(rplijj) + '/' +
     c                                                  (rplinr) + '/' +
     c                                                  (#rplipo) + '/' +
     c                                                  (akafat)
     c                   eval      #RKREDA       = rkreda
     c                   eval      #COST_UNIT    = testpr
     c                   eval      #RPNESU       = rpnesu
     c                   eval      #RKWACD       = RKWACD
     c                   eval      #APPRGR       = TEEWPRGR
     C                   if        #APPRGR  = '    '
     C                   movel     '000 '        #APPRGR
     C                   endif
     c                   eval      #DIVISION     = #DIVISION
     c                   eval      #RKKDNR       = RKKDNR
     c                   eval      #KDRBEZ       = '***' + KDNAM1
     c                   eval      #ALGLMG       = ALGLMG
     c                   eval      #ALTENR       = ALTENR
     c                   eval      #CUSTCODE     = #CUSTCODE
     c
     c   55              write     phy02r
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Zu.- und Abschläge nicht positionsgebunden
     C*-------------------------------------------------------------------------
     C*
     C     sr_002b       BEGSR
     C*
     c                   clear                   phy02r
     c   41              movel     rkkon1        #rkkon           10
     c   42              movel     rkkon2        #rkkon           10
     c   43              movel     rkkon3        #rkkon           10
     c   44              movel     rkkon4        #rkkon           10
     c                   exsr      sr8250
     c                   movel     'B'           typRecord         1
     c                   movel     '0'           typProd           1
     C*
     c
     c   41              if        rkerg1 <    0
     c   41              movel     'D'           typRecord         1
     c   41              movel     'A'           typProd           1
     c                   endif
     c   42              if        rkerg2 <    0
     c   42              movel     'D'           typRecord         1
     c   42              movel     'A'           typProd           1
     c                   endif
     c   43              if        rkerg3 <    0
     c   43              movel     'D'           typRecord         1
     c   43              movel     'A'           typProd           1
     c                   endif
     c   44              if        rkerg4 <    0
     c   44              movel     'D'           typRecord         1
     c   44              movel     'A'           typProd           1
     c                   endif
     c
     c                   if        ALMWCD  = '16'
     c                   movel     '1900'        mwst              4
     c                   endif
     c
     c
     c                   z-add     1             menge             5 0
     c                   z-add     ALPREI        lpreis            9 2
     c   41              z-add     rkerg1        lpreis
     c   42              z-add     rkerg2        lpreis
     c   43              z-add     rkerg3        lpreis
     c   44              z-add     rkerg4        lpreis
     c                   if        lpreis< 0
     c                   eval      lpreis= lpreis * -1
     c                   endif
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   z-add     ALNTSK        poswertn         11 2
     c                   z-add     ALNESU        poswertn         11 2
     c   41              z-add     rkerg1        rpnesu
     c   42              z-add     rkerg2        rpnesu
     c   43              z-add     rkerg3        rpnesu
     c   44              z-add     rkerg4        rpnesu
     c
     c   41              movel     '0001'        rplipo
     c   42              movel     '0002'        rplipo
     c   43              movel     '0003'        rplipo
     c   44              movel     '0004'        rplipo
     c
     c                   exsr      sr8050
     c
     c                   movel     TPTTXT        ALTBZ1
     c                   movel     '000'         ALPRGR
     c                   clear                   #kon1
     c                   clear                   #kon2
     c                   clear                   #kon3
     c                   clear                   #kon4
     c     ' ':'0'       xlate     #kon1         #kon1
     c     ' ':'0'       xlate     #kon2         #kon2
     c     ' ':'0'       xlate     #kon3         #kon3
     c     ' ':'0'       xlate     #kon4         #kon4
     c
     c*******************
     c                   movel     rplipo        #rplipo           4
     c                   eval      #POSTDATE     = #POSTDATE
     c                   eval      #ENTITY       = 'DE411'
     c                   eval      #COUNT_ISO    = KDPOLD
     c                   if        #COUNT_ISO    = *blank
     c                   eval      #COUNT_ISO    ='DE'
     c                   endif
     c                   eval      #SKU          = ALTENR
     c                   eval      #APTBZ1       = ALTBZ1
     c                   eval      #APGLMG       = alglmg
     c                   eval      #ENTRY#       = #ENTRY#
     c                   eval      #DOCTYPE      = #DOCTYPE
     c                   eval      #DOC          = %char(RPRGJJ) + '/' +
     c                                                  (RPRGNR) + '/' +
     c                                             %char(rplijj) + '/' +
     c                                                  (rplinr) + '/' +
     c                                                  (#rplipo) + '/' +
     c                                                  (akafat)
     c                   eval      #RKREDA       = rkreda
     c                   eval      #COST_UNIT    = testpr
     c                   eval      #RPNESU       = rpnesu
     c                   eval      #RKWACD       = RKWACD
     c                   eval      #APPRGR       = TEEWPRGR
     C                   if        #APPRGR  = '    '
     C                   movel     '000 '        #APPRGR
     C                   endif
     c                   eval      #DIVISION     = #DIVISION
     c                   eval      #RKKDNR       = RKKDNR
     c                   eval      #KDRBEZ       = '* *' + KDNAM1
     c                   eval      #ALGLMG       = ALGLMG
     c                   eval      #ALTENR       = ALTENR
     c                   eval      #CUSTCODE     = #CUSTCODE
     c   55              write     phy02r
     C*
     C     ##_002b       ENDSR
     C*
     c**************************************************************************
     C*Bereinigung Währung
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*

     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c
     C*******            open      RPMII_TO
     C                   DO        *HIVAL
     C                   READ      RPMII_TO                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   if        RKWACD <> 'EUR'
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C                   movel     '0'           *in95
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        ifeq      'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      RKWACD='EUR'
     c                   eval      rpnesu=(rpnesu*wakurs)
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C                   endif
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C********           close     RPMII_TO
     C*

     C     ##2000        ENDSR

     C**************************************************************************
     C* sr5000: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     keysr5kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRAKD
     c
     c     keysr5kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr5KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDKDNR
     c
     c  n97keysr5KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrOrder          7
     c   97              clear                   KdrOrder
     c
     c     keysr5kund    chain     kdew01                             97
     c   97              clear                   KDEWKSST
     c   97              clear                   kDEWRPMG
     C*
     C     ##5000        ENDSR
     C*
     C**************************************************************************
     C* sr6000: direkter Warenempfänger  -3-
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c     keysr6kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKSTKD
     c
     c     keysr6kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr6KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDKDNR
     c
     c  n97keysr6KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrDelev          7
     c   97              clear                   KdrDelev
     c
     C*
     C     ##6000        ENDSR
     C*
     C**************************************************************************
     C* sr7000: Kunde Rechnung für ???  -1-
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
     C*
     c     keysr7kund    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRAKD
     c
     c     keysr7kund    chain     kund01                             97
     c   97              clear                   kund1
     c
     c     keysr7KDZR    klist
     c                   kfld                    RKFIRM
     c                   kfld                    KDRAKD
     c
     c  n97keysr7KDZR    chain     KDZR01                             97
     c   97              clear                   KDZR1
     c
     c  n97              movel     KDZRMIKD      KdrBill           7
     c   97              movel     KdrOrder      KdrBill
     c
     C*
     C     ##7000        ENDSR
     C*
     C**************************************************************************
     C*Funktion *insert
     C*-------------------------------------------------------------------------
     C*
     C     sr8050        BEGSR
     C*

     c                   clear                   #postdate
     c                   clear                   #entry#

     c/exec sql
     c+ whenever not found goto ##8050
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##8050
     c/end-exec

     c/exec sql
     C+ SELECT substr(char(current date, iso), 1, 4)
     c+        concat substr(char(current date, iso), 6, 2) concat
     c+        substr(char(current date, iso), 9, 2) into :#postdate
     C+        from qsys2/qsqptabl
     c/end-exec
     C*
     c/exec sql
     C+ SELECT char(days((date(substr(char(:RKREDA), 1, 4)
     c+        concat '-' concat substr(char(:RKREDA), 5, 2) concat '-'
     c+        concat substr(char(:RKREDA), 7, 2) )))) into :#entry#
     C+        from qsys2/qsqptabl
     c/end-exec
     C*

     C     ##8050        ENDSR

     C**************************************************************************
     C* sr8250: lesen trtp
     C*-------------------------------------------------------------------------
     C*
     C     sr8250        BEGSR
     C*
     c     keysr_trtp    klist
     c                   kfld                    RKFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c
     c                   movel     'D'           TPSPCD
     c                   movel     'RBAT      '  TPTART
     c                   movel     #rkkon        TPTCDE
     c
     c     keysr_trtp    chain     trtp01                             97
     c   97              clear                   TPTTXT
     c
     C*
     C     ##8250        ENDSR
     C*
     C**************************************************************************
     C* sr9020: lesen aful für Unterpositionen über rechnungspositionen
     c*         sobald im Positionssatz der Rechnung eine Unterposition
     c*         gefüllt ist, muss der Unterpositionssatz gelesen werden,
     c*         da kein Lieferscheinsatz vorhanden ist
     C*-------------------------------------------------------------------------
     C*
     C     sr9020        BEGSR
     C*
     c     keysr_aful    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPLIJJ
     c                   kfld                    RPLINR
     c                   kfld                    RPLIPO
     c                   kfld                    RPUPOS
     c
     c     keysr_aful    chain     #AFULL1                            91
     c  n91              z-add     ulglmg        alglmg
     c  n91              z-add     ULPREI        ALPREI
     c
     c     KEY2030       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     rptenr        TETENR
     C*
     c     KEY2030       chain     teil01                             98
     c  n98              movel     TETBZ1        ALTBZ1
     C*
     C     ##9020        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0)
     c+ into   :tstampi, :datum, :datum2, :zeit, :week
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

