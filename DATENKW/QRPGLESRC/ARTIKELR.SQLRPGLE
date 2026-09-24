     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*SELECT ekusr, f20 FROM PRJ015P WHERE ARTNUM =9600004363   *
     F*      48282 Emsdetten                         10519303    *
     F*update prodwin51/prj015P set ekusr='HR',
     F*                             f20  ='HR'
     F*where ARTNUM =9600004363
     F*insert 'HA', 'Alma Hartmann', 0 into prodwin/prj042P
     F*
     F*      48282 Emsdetten                         10519303    *
     F*      HR  Alma Hartmann einkäufer             10519303    *
     F*      HR  Alma Hartmann Dispo                 10519303    *
     F*SELECT * FROM PRJ042p                                     *
     F*SELECT * FROM PRJ684p                                     *
     F*      gang 20100705 SKU# generiert                        *
     F*      40            %subst(buchung2: 01: 1) = '%'         *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
MG001F* mg  05.07.2011 freigabe P='0000' ==> '2011'             *             
     F************************************************************

     fkalk_file1up   e             disk
     fprj015p   uf a e           k disk
     fprj042p   uf a e           k disk
     fPRJ684P   uf a e           k disk
     fprj015p44 uf a e           k disk
     fsystempf  if   e           k disk
     fPREI02    if   e           k disk
     ftrtp00    if   e           k disk
     fbbep09    if   e           k disk
     fTEIL00    if   e           k disk
     fsbgarb00  if   e           k disk
     fTeuf00    if   e           k disk

     DDate             S               D   DATFMT(*ISO)
     Dtstampi          S               Z
     Ddatumi           S               D
     Dzeit             S               T

     I*-------------------------------------------------------------------------
     D pc            E DS                  EXTNAME(PRJ015p)
     D*-------------------------------------------------------------------------
     IKALK_F1
     I              status                      §status
     I              zoll                        §zoll
     I*-------------------------------------------------------------------------
     IPRJ684f
     I              bez                         §bez
     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1

     C* --------------------------------------------------
     c*  Schlüsselliste für prei02
     c     preikey       klist
     c                   kfld                    FIRMA
     c                   kfld                    BEGR
     c                   kfld                    TETENR

     C* --------------------------------------------------

     c                   if        #version= version
     c                   exsr      sr0000
     c                   endif
     Clr                 out       #sku

     C**************************************************************************
     C* SR0000P:
     C*-------------------------------------------------------------------------
     C     SR0000        BEGSR
     C*
     c                   setoff                                       4025
     c                   if        artnr =  '060722128151000'
     c                   clear                   ff                1
     c                   endif
     c                   if        ( artnr =  '4443300027'    or
     c                               artnr =  '4443300113'    or
     c                               artnr =  '4443900264'    or
     c                               artnr =  '4443900073'    or
     c                               artnr =  '4443300008'    or
     c                               artnr =  '4442500120'    or
     c                               artnr =  '4443300054'    or
     c                               artnr =  '4443300038'    or
     c                               artnr =  '4443300055'    or
     c                               artnr =  '4445900137'    or
     c                               artnr =  '4445900092'    or
     c                               artnr =  '4443300074'    or
     c                               artnr =  '4445900057'    or
     c                               artnr =  '4443900029'    or
     c                               artnr =  '4443900039'    or
     c                               artnr =  '4443900256'    or
     c                               artnr =  '4445900114'    or
     c                               artnr =  '4445900073'    or
     c                               artnr =  '4443900245'    or
     c                               artnr =  '4443300053'    or
     c                               artnr =  '4443900308')
     c                   clear                   v1111             1
     c                   endif
     c                   if        artnr <> '____________'  and
     c                             artnr <> '____________'  and
     c                             sys01 <> 'P'
     c*                  if        artnr =  '060722128151000' and
     c**** Hause 1.3.2012
     c************************     artnr =  '9108000527'    and
     c******** Kordel 05.11.2014   artz3   <> '82    '        and
     c***** lt.NINa                artz3   <> '89    '        and
     c******** Kordel 05.11.2014   STK_LCP <> 0


     c                   clear                   ff                1
     c                   if        artsku = *blank
     c                   if        %subst(ARTNR: 1: 3) = '444' or
     c                             %subst(ARTNR: 1: 3) = '888' or
     c                             %subst(ARTNR: 1: 3) = '910' or
     c                             %subst(ARTNR: 1: 3) = '991' or
     c                             %subst(ARTNR: 1: 3) = '992' or
     c                             %subst(ARTNR: 1: 3) = '958' or
     c                             %subst(ARTNR: 1: 1) = '9'   or
     c                             %subst(ARTNR: 1: 3) = '913'
     c                   movel     artnr         artsku
     c                   testn                   artsku               25
     c  n25              clear                   artsku
     c***                add       1             #sku             10 0
     c***                movel     #sku          artsku
     c                   seton                                        40
     c                   endif
     c                   endif

      *                 *in50 = Satz zulässig für Übernahme                   
     c                   movel     anldat        p                 4
     c                   seton                                        50
mg001c                   if        P = '0000'
mg001c                   movel     '2011'        p
mg001c                   endif

      *                 keine SKU, keine Übernahme                            
     c                   if        artsku = *blank
     c********           setoff                                       50
     c                   endif
      *                 abc=K = Hilfsartikel für Produktion keine Übernahme   
     c                   if        abc = 'K'
     c** aktiv setzen    setoff                                       50
     c                   endif
      *                 %subst(BUCHUNG: 16: 3) = '###' kein Lagersatz         
      *                 in sbgarb00 keine Übernahme                           
     c                   if        %subst(BUCHUNG: 16: 3) = '###'
     c                   setoff                                       50
     c                   endif

      *                 Anruf Klaffke 15.07.2010                              
     c                   if        artsku = *blank
     c*  50              add       1             #sku
     c*  50              movel     #sku          artsku
     c                   seton                                        40
     c                   endif

      *                 abc=X (Auslaufartikel) und keine Bestände und         
      *                 keine Bestellungen bzw. Abrufe vorhanden und          
     c                   if        abc  = 'X'   and
     c                             c001 =  0    and
     c                             b005 =  0
     c************       setoff                                       50
     c                   endif
     c                   if        #version= version  and
     c                             p > '0000' and artsku  <> *blank  and
     c                             *in50 = '1'
      *                 prj015p                                               
     c                   seton                                        33
     C                   movel     artsku        artnumI          10 0
     C                   z-add     artnumI       artnum
     c     artnum        chain     prj015p
     C                   if         %found(prj015p)
     c***33              call      'PRJ015TRC'
     c***                parm      'ARTIKELR  '  pgmc             10
     c***                parm                    Pc
      *             invart sichern, da nicht mehr über bgfs überschreibar     
      *             Abstimmung Kordel/klaffke 19.07.2010                      
     C     *LIKE         DEFINE    invart        ##invart
     c                   eval      ##invart  =     invart
     c                   endif

      *                 costprs Umrechnung faktoren Konvertierung             
     C                   clear                   COSTPRS$AR       1404
     C                   eval      COSTPRS$AR  = COSTPRS_AR
     c                   if        faktor#='2'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 10
     c                   endif
     c                   if        faktor#='3'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 100
     c                   endif
     c                   if        faktor#='4'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 1000
     c                   endif
     c                   if        faktor#='5'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 1000
     c                   endif
     c                   if        faktor#='6'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 1000
     c                   endif
     c                   if        faktor#='7'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 2
     c                   endif
     c                   if        faktor#='8'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 4
     c                   endif
     c                   if        faktor#='9'
     C                   eval      COSTPRS$AR  = COSTPRS_AR * 2
     c                   endif

     c                   exsr      SR1000

     c                   setoff                                       3367
     c                   movel     anldat        #anldat           6 0
     c                   movel     #anldat       #anldatj          4 0
     c                   move      #anldat       #anldatm          2 0
     c                   if        jahr$ =    #anldatj   and
     c***********                  anldat = 20091014
     c                             monat$ =   #anldatm
     c                   seton                                        33
     c                   endif
     C                   if        not %found(prj015p)
     c                   write     PRJ015F
     c                   seton                                        67
     c                   ELSE
     c                   move      '@'           bez3
     c                   eval      invart  =     ##invart
     c   33              update    PRJ015F
     c                   endif
     c                   seton                                        33
      *
      *                 prj015p44                                             
     c                   seton                                        33
     C                   move      artsku        artnum
     c     artnum        chain     prj015p44
     C                   if        not %found(prj015p44)
     c                   z-add     COSTPRS$AR    auflkst
     C                   eval      %subst(KDASF: 1: 03) = LiefNr
     C                   eval      %subst(kdtxt: 1: 03) = ARTGRP
     c                   eval      %subst(buchung2: 02: 1) = 'W'
     c                   write     PRJ015F44
     c                   ELSE
     C                   eval      %subst(KDASF: 1: 03) = LiefNr
     C                   eval      %subst(kdtxt: 1: 03) = ARTGRP
     c                   move      '@'           bez3
     c                   eval      %subst(buchung2: 02: 1) = 'U'
     c   33              update    PRJ015F44
     c                   endif
      *
     c                   eval      %subst(buchung: 14: 1) = '@'
     c                   movel     udate         xudate            6
     c                   eval      %subst(buchung: 15: 6) = xudate
     c   40              eval      %subst(buchung2: 01: 1) = '%'
     c                   if        *in67 = '1'
     c   33              update    KALK_F1
     c                   endif
     c                   endif
     c                   setoff                                       33



     c                   endif
     C*
     C     ##0000        ENDSR

     C**************************************************************************
     C* SR1000P:
     C*-------------------------------------------------------------------------
     C     SR1000        BEGSR
     C*
     C                   clear                   PRJ015F
     C                   move      artsku        artnum
     C                   movel     '0'           vartyp
     C                   movel     'A'           typgrp
     C                   eval      %subst(krzbez: 1: 15) = artnr
     C                   movel     ARTBEZ        bez2
     C                   eval      %subst(bez3: 1: 05)= %subst(artbez: 26: 05)
     C***                movel     StatNr        cla
     C                   movel     ZOLLNR        zollpos
     C                   movel     StatNr        hbmw
     C
     C                   if        LIEFERANT1 = '90733 '
     C                   movel     999           matkstart
     C*                  Konzernlieferant unbekannt
     C                   else
     C                   z-add     999           MATKSTART
     C                   endif
     C                   if        ARTZ1   = 'EIPROD'
     C                   movel     'ST '         ptprsenh
     C                   endif
     C
     C                   movel     'J '          F01
     C                   movel     'J '          F02
     C                   movel     'J '          F03
     C                   movel     'B '          F04
     C* klären forcast   movel     'N '          f17
     C                   movel     #TEDIAV       f20
     C                   seton                                        41
     C                   exsr      sr5500
     C                   exsr      SRprj042p
     C                   setoff                                       41
     C                   movel     #TESAAV       ekusr
     C                   seton                                        42
     C                   exsr      sr5500
     C                   exsr      SRPRJ684P
     C                   setoff                                       42
     C*
     C**** keine festen zuordnungen   movel     '001'         HLO
     C*
     c* TEIL-Satz lesen
     c     teilkey       klist
     c                   kfld                    firma
     c                   kfld                    artnr
     c
     c     teilkey       chain     TEIL1
     c                   IF        %found(TEIL00)
     c
      *                 basis                                                 
     C                   movel     temein        x                 2
     C                   eval      %subst(x: 2: 1)= ' '
     C                   exsr      sr2000
     C                   movel     x             basenh
     c                   movel     x             enhstl
     c
      *                 tempek   nach  prsenh, enh2                           
     C                   movel     tempek        x                 2
     C                   movel     ersetz        x                 2
     C                   eval      %subst(x: 2: 1)= ' '
     C                   exsr      sr2000
     C                   movel     x             prsenh
     C                   movel     x             enh2
     C                   if        enh2  <>      basenh
     C                   if        basenh = 'DM' and enh2   = 'M '
     C                   z-add     10            fak2
     C                   endif
     C                   if        basenh = 'DM' and enh2   = 'CM'
     C                   z-add     0,10          fak2
     C                   endif
     C                   if        basenh = 'CM' and enh2   = 'M '
     C                   z-add     100           fak2
     C                   endif
     C                   if        basenh = 'CM' and enh2   = 'DM'
     C                   z-add     10            fak2
     C                   endif
     C                   if        basenh = 'M ' and enh2   = 'DM'
     C                   z-add     0,10          fak2
     C                   endif
     C                   if        basenh = 'M ' and enh2   = 'CM'
     C                   z-add     0,01          fak2
     C                   endif
     C                   else
     C                   clear                   enh2
     C                   endif
     c
     C                   if        basenh = 'DM' and prsenh = 'M '
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'DM' and prsenh = 'CM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'CM' and prsenh = 'M '
     C                   z-add     100           efak2
     C                   endif
     C                   if        basenh = 'CM' and prsenh = 'DM'
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'M ' and prsenh = 'DM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'M ' and prsenh = 'CM'
     C                   z-add     0,01          efak2
     C                   endif
     C*
      *                 temeek   nach  prsenh, enh2                           
      *       SELECT basenh, eeinh2, count(*) FROM prodtst88/prj015p GROUP    
      *       BY basenh, eeinh2 ORDER BY basenh, eeinh2                       
     C                   movel     temeek        x
     C                   eval      %subst(x: 2: 1)= ' '
     C                   exsr      sr2000
     C                   movel     x             eeinh2
      *                                                                        
     C                   if        eeinh2<>      basenh and
     C                             eeinh2  <>    *blank
     C                   if        basenh = 'DM' and eeinh2 = 'M '
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'DM' and eeinh2 = 'CM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'CM' and eeinh2 = 'M '
     C                   z-add     100           efak2
     C                   endif
     C                   if        basenh = 'CM' and eeinh2 = 'DM'
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'DM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'CM'
     C                   z-add     0,01          efak2
     C                   endif
     C                   if        basenh = 'ST' and eeinh2 = 'M '
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'ST' and eeinh2 = 'KG'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'ST'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'KG' and eeinh2 = 'ST'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   endif
     C*
      *                 Ausnahme, da die Relation nicht erkannt wird,         
      *                 was den Cost_preis betrifft 3, M, M                   
     C                   if        faktor# = '@'  and
     C                             PRMEPR# = '@'  and
     C                             TEMPEK# = '@'
     C*****************  z-add     0             prsfak
     C                   else
     C*
      *                 faktoren Konvertierung                                
     C                   if        faktor# = ' '
     C                   movel     '1'           faktor#
     C                   endif
     c                   if        faktor#='1'
     C                   z-add     0             prsfak
     c                   endif
     c                   if        faktor#='2'
     C                   z-add     1             prsfak
     c                   endif
     c                   if        faktor#='3'
     C                   z-add     2             prsfak
     c                   endif
     c                   if        faktor#='4'
     C                   z-add     3             prsfak
     c                   endif
     c                   if        faktor#='5'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '01000'
     c                   endif
     c                   if        faktor#='6'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '10000'
     c                   endif
     c                   if        faktor#='7'
     c                   z-add     1             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00005'
     c                   endif
     c                   if        faktor#='8'
     c                   z-add     2             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00025'
     c                   endif
     c                   if        faktor#='9'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00500'
     c                   endif
     c                   endif
     C*
     c                   if        artnr    = '8880600003'
     c                   move      '2'           tetart
     c                   endif
     C*
     c                   move      tetart        invart
     C*
     C                   select
     C                   when      invart   = 1
     C                   movel     300           invart
     C                   when      invart   = 2
     C                   movel     700           invart
     C                   when      invart   = 3
     C                   movel     011           invart
     C                   other
     C                   endsl
     C*
     c                   if        ARTGRP   = 'FWK' or ARTGRP = 'LOH'  or
     c                             ARTGRP   = 'DRU' or ARTGRP = 'WER'  or
     c                             ARTGRP   = 'SON' or ARTGRP = 'GAR'  or
     c                             ARTGRP   = 'PRO' or ARTGRP = 'CDR'
     c                   move      800           invart
     c                   endif
     C*
     C                   endif
     C
      *                 WAECO-LCP Grundlage                                   
     C                   exsr      sr9500
     C****fremdlohn      z-add     lcp050        lfdstklhn
     C                   eval      LFDSTK2 =( lcp160 + lcp310 )
     C
     C                   if        artnr = 'AWU-121ST '
     C                   clear                   ppp               1
     C                   endif
      *   ***********************************************                     
      *                 Handelsware                                           
     C                   if        invart = 700
     C*2010419
     C                   movel     'Z'           ba
     C                   z-add     COSTPRS$AR    lfdstk2
     C                   z-add     COSTPRS$AR    lfdstk3
     C                   eval      lfdmatgko  =
     C                             (costprs$ar)*
     C                             4,5/104,50
     C                   eval      lfdmatkos = COSTPRS$AR - lfdmatgko
     C                   eval      lfdstk1 = (lfdstk2 - lfdmatgko)
     C                   eval      lfdstkfra  =
     C                             costprs$ar*frachtsatz/100,00
     C                   eval      lfdstkmat  = (lfdstk2 - lfdmatgko
     C                                                     -lfdstkfra)
     C*****              eval      lfdstkmat  = (lfdstk    -lfdstkfra)
     C                   eval      lfdstk = lfdstk3
     C                   endif
      *   ***********************************************                     
     C
      *                 Rohstoff  eigentlich wie Handelsware                  
     C                   if        invart = 011  or invart = 800
     C                   if        invart = 011
     C                   clear                   lfdstklhn
     C                   endif
     C                   movel     'Z'           ba
     C*2010419
     C                   z-add     COSTPRS$AR    lfdstk1
     C                   z-add     COSTPRS$AR    lfdstk2
     C                   z-add     COSTPRS$AR    lfdstk3
     C                   z-add     COSTPRS$AR    LFDSTK
     C                   eval      lfdmatkos = COSTPRS$AR - lfdmatgko
     C                   eval      lfdstkfra  =
     C                             costprs$ar*frachtsatz/100,00
     C                   eval      lfdstkmat  =
     C                             (costprs$ar-lfdstkfra)
     C                   endif
     C
      *   ************************************************************        
      *   * EigenProduktion: (161 Egelkamp)  Definition "EIPROD" CU-84        
      *   * / CA-0800-DC                                                      
      *   * Wertermittlung: nur aus Stückliste d. h. auch                     
      *   * CWSTCK2W=WEKPR  LOL                                               
      *   ************************************************************        
      *                 Eigenproduktion  invart = 1,ARTZ1   = 'EIPROD'        
     C                   if        ARTZ1   = 'EIPROD'
     C                   movel     'E'           ba
     C                   eval      invart = 300
     C                   eval      ptprsenh = prsenh
     C                   eval      ptprsfak = prsfak
      *
     C                   if        artnr = 'AWU-121ST '
     C                   clear                   ppp               1
     C                   endif
     C                   z-add     LCP230        LFDFERLOH
     C                   eval      lfdfergkf = ( LFDFERLOH * 1,11 )
     C                   z-add     *zero         LFDfergkv
     C                   eval      lfdmatgko  =
     C                             (costprs$ar)*
     C                             4,5/104,50
     C                   z-add     COSTPRS$AR    LFDSTK2
     C                   z-add     COSTPRS$AR    LFDSTK3
     C                   eval      lfdmatkos= COSTPRS$AR -
     C                                        lfdferloh  - lfdfergkv -
     C                                        lfdfergkf  - lfdmatgko
     C                   eval      LFDSTK1 =(LFDMATKOS + LFDFERLOH +
     C                                       LFDFERGKV )
     C                   eval      LFDSTK2 =(lfdstk1   + LFDFERgkf +
     C                                       LFDmatgko )
     C                   eval      LFDSTK3 =lfdstk2
     C
     C                   endif
      *   ***********************************************                     
      *   *verlängerte Werkbank?? ohne Beistellung  "autoset"                 
      *   *verl. Werkbank:     Definition "KONFEK" = 'KON' oder 'CON'         
      *   *RV-118-HD-KR                                                       
      *   *Wertermittlung: Stückliste und evtl. Preis aus Trenddateien        
      *   *immer mit LOL quasi als                                            
      *   *Eigenproduktionsanteil hat keinen Lieferanteneintrag               
      *   ************************************************************        
      *                 (verlängerte Werkbank??) ohne Beistellung autoset     
     C                   if        ( %subst(ARTZ1: 01: 3) = 'KON'   or
     C                               %subst(ARTZ1: 01: 3) = 'CON' ) and
     C                             CCSTCK > 0
     C                   movel     'A'           ba
     C                   eval      invart = 300
     C                   eval      ptprsenh = prsenh
     C                   eval      ptprsfak = prsfak
      *
     C                   z-add     LCP230        LFDFERLOH
     C                   eval      lfdfergkf = ( LFDFERLOH * 1,11 )
     C                   z-add     *zero         LFDfergkv
     C                   eval      lfdmatgko  =
     C                             (costprs$ar)*
     C                             4,5/104,50
     C                   z-add     COSTPRS$AR    LFDSTK2
     C                   z-add     COSTPRS$AR    LFDSTK3
     C*                  eval      LFDFMDLOH= cOSTPRS$AR -
     C*                                       lfdferloh  - lfdfergkv -
     C*                                       lfdfergkf  - lfdmatgko
     C
     C                   eval      lfdmatkos= costprs$ar -
     C                                        lfdferloh  - lfdfergkv -
     C                                        lfdfergkf  - lfdmatgko -
     C                                        LFDFMDLOH
     C                   eval      LFDSTK1 =(LFDMATKOS + LFDFERLOH +
     C                                       LFDFERGKV )
     C                   eval      LFDSTK2 =(lfdstk1   + LFDFERgkf +
     C                                       LFDmatgko )
     C                   eval      LFDSTK3 =lfdstk2
     C
     C                   z-add     lfdmatkos     LFDSTK
     C                   eval      lfdstkfra  =
     C                             lfdmatkos *frachtsatz/100,00
     C                   eval      lfdstkmat  =
     C                             (lfdmatkos -lfdstkfra)
     C* neu ab 12.02.2010  pleimann
     C                   movel     'E'           ba
     C                   eval      invart = 300
     C                   eval      ptprsenh = prsenh
     C                   eval      ptprsfak = prsfak
      *
     C                   if        artnr = 'AWU-121ST '
     C                   clear                   ppp               1
     C                   endif
     C                   z-add     LCP230        LFDFERLOH
     C                   eval      lfdfergkf = ( LFDFERLOH * 1,11 )
     C                   z-add     *zero         LFDfergkv
     C                   eval      lfdmatgko  =
     C                             (costprs$ar)*
     C                             4,5/104,50
     C                   z-add     costprs$ar    LFDSTK2
     C                   z-add     costprs$ar    LFDSTK3
     C                   eval      lfdmatkos= costprs$ar -
     C                                        lfdferloh  - lfdfergkv -
     C                                        lfdfergkf  - lfdmatgko
     C                   eval      LFDSTK1 =(LFDMATKOS + LFDFERLOH +
     C                                       LFDFERGKV )
     C                   eval      LFDSTK2 =(lfdstk1   + LFDFERgkf +
     C                                       LFDmatgko )
     C                   eval      LFDSTK3 =lfdstk2
     C
     C                   endif
      *   ***********************************************                     
      *   *verlängerte Werkbank mit  Beistellung                              
      *   *Beistellung:   Definition <> "EIPROD" und <> 'KON'und <>           
      *   *'CON'und !!!Stückliste!!!!                                         
      *   *Wertermittlung: Stückliste und evtl. Preis aus Trenddateien        
      *   *Wert aus Stückliste = Beistellungswert                             
      *   ************************************************************        
      *                 verlängerte Werkbank mit Beistellung                  
     c                   if        %subst(ARTZ1: 01: 3) <> 'KON'     and
     c                             %subst(ARTZ1: 01: 3) <> 'CON'     and
     c                             %subst(ARTZ1: 01: 6) <> 'EIPROD'  and
     c                             CCSTCK > 0 and sys01 ='2 '
     C                   movel     'A'           ba
     C                   eval      invart = 428
     C                   eval      ptprsenh = prsenh
     C                   eval      ptprsfak = prsfak
      *
     C                   if        artnr = 'AWU-121ST '
     C                   clear                   ppp               1
     C                   endif
     C                   z-add     LCP230        LFDFERLOH
     C                   eval      lfdfergkf = ( LFDFERLOH * 1,11 )
     C                   z-add     *zero         LFDfergkv
     C                   eval      lfdmatgko  =
     C                             (costprs$ar-beistell)*
     C                             4,5/104,50
     C********           193,33
     C                   z-add     beistell      LFDMATkos
     C                   eval      lfdstkfra  =
     C                             lfdmatkos *frachtsatz/100,00
     C                   eval      lfdstklhn= costprs$ar -
     C                                        lfdferloh  - lfdfergkv -
     C                                        lfdfergkf  - lfdmatgko -
     C                                        beistell   - lfdstkfra
     C                   eval      LFDFMDLOH  =  lfdstklhn+lfdstkfra
     C                   eval      LFDSTK1 =(LFDMATKOS + LFDFERLOH +
     C                                       LFDFERGKV + lfdfmdloh )
     C                   eval      LFDSTK2 =(lfdstk1   + LFDFERgkf +
     C                                       LFDmatgko   )
     C                   eval      LFDSTK3 =lfdstk2
     C                   eval      LFDSTK = lfdstk3
     C                   eval      LFDSTKMAT = LFDSTK-LFDstkLhn-lfdstkfra
     C                   endif
      *   ***********************************************                     
      *
     C*
     C     ##1000        ENDSR


     C**************************************************************************
     C* sr2000: Mengeneinheiten
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     C*
     C                   select
     C                   when      x        = 'B '
     C                   movel     '10'          x
     C                   when      x        = 'C '
     C                   movel     'CL'          x
     C                   when      x        = 'D '
     C                   movel     'DM'          x
     C                   when      x        = 'G '
     C                   movel     'GR'          x
     C                   when      x        = 'K '
     C                   movel     'KG'          x
     C                   when      x        = 'N '
     C                   movel     'ML'          x
     C                   when      x        = 'S '
     C                   movel     'ST'          x
     C                   when      x        = 'Z '
     C                   movel     'CM'          x
     C                   other
     C                   eval      %subst(x: 2: 1)= ' '
     C                   endsl
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* SR5500: lesen trtp00, um zu ermitteln, ob ein Lieferant mit 90733
     C*         gelesen werden muss
     C*
     C*-------------------------------------------------------------------------
     C*
     C     SR5500        BEGSR
     C*
     c     KEY5500       klist
     c                   kfld                    tpfirm
     c                   kfld                    tpspcd
     c                   kfld                    tptart
     c                   kfld                    tptcde
     C*
     c                   movel     testlf        #testlf          10
     c                   clear                   sabe              3
     c                   eval      sabe = %subst(testlf: 03: 3)
     C*
     C                   movel     '01'          tpfirm
     C                   movel     'D'           tpspcd
     C                   movel     'SABE      '  tptart
     C                   clear                   tptcde
     C   41              movel     #TEDIAV       tptcde
     C   42              movel     #TESAAV       tptcde
     C*
     c     KEY5500       chain     trtp00
     c                   IF        %found(trtp00)
     c                   else
     c                   clear                   TPTTXT
     c                   ENDIF
     C*
     C     ##5500        ENDSR
     C*
     C**************************************************************************
     C* SR5600: lesen prei1 über SABE
     C*-------------------------------------------------------------------------
     C*
     C     SR5600        BEGSR
     C*
     c                   IF        %found(trtp00)
     c                   movel     '90733'       testlf
     c                   movel     'SABE'        lieferant2
     c                   move      sabe          lieferant2
     c                   ENDIF
     c                   movel     TESTLF        lieferant1
     c                   eval      %subst(BUCHUNG: 10: 1) = '1'
     c     preikey       setll     prei1
     c                   DOU       %eof(prei02)
     c     preikey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = testlf
     c                   eval      %subst(BUCHUNG: 10: 1) = ' '
     c                   eval      WACDEK   = prwacd

     c                   z-add     1             faktor            5 0
     c                   if        prpdvk='1'
     c                   z-add     1             faktor
     c                   endif
     c                   if        prpdvk='2'
     c                   z-add     10            faktor
     c                   endif
     c                   if        prpdvk='3'
     c                   z-add     100           faktor
     c                   endif
     c                   if        prpdvk='4'
     c                   z-add     1000          faktor
     c                   endif
     c                   if        prpdvk='5'
     c                   z-add     10000         faktor
     c                   endif
     c                   if        prpdvk='6'
     c                   z-add     100000        faktor
     c                   endif
     c                   if        prpdvk='7'
     c                   z-add     5             faktor
     c                   endif
     c                   if        prpdvk='8'
     c                   z-add     25            faktor
     c                   endif
     c                   if        prpdvk='9'
     c                   z-add     500           faktor
     c                   endif

     c                   z-add     PRGADA        datumv
     c                   z-add     PRGBDA        datumb
     c                   z-add     PREZPR        WEKPR
     c                   eval      wekpr = wekpr/faktor

     c                   ENDIF
     C                   ENDDO
     C*
     c                   if        %subst(BUCHUNG: 10: 1) = '1'
     c                   exsr      sr5700
     c                   endif
     C*
     C     ##5600        ENDSR
     C*
     C**************************************************************************
     C* SR5700: lesen prei1 II
     C*-------------------------------------------------------------------------
     C*
     C     SR5700        BEGSR
     C*
     c                   movel     #TESTLF       testlf
     c                   movel     TESTLF        lieferant1
     c                   eval      %subst(BUCHUNG: 10: 1) = '1'
     c     preikey       setll     prei1
     c                   DOU       %eof(prei02)
     c     preikey       READE     prei1
     c                   IF        not %eof(prei02) and PRGBDA=0
     c                             and PRKDLI = testlf
     c                   eval      %subst(BUCHUNG: 10: 1) = ' '
     c                   eval      WACDEK   = prwacd

     c                   z-add     1             faktor            5 0
     c                   if        prpdvk='1'
     c                   z-add     1             faktor
     c                   endif
     c                   if        prpdvk='2'
     c                   z-add     10            faktor
     c                   endif
     c                   if        prpdvk='3'
     c                   z-add     100           faktor
     c                   endif
     c                   if        prpdvk='4'
     c                   z-add     1000          faktor
     c                   endif
     c                   if        prpdvk='5'
     c                   z-add     10000         faktor
     c                   endif
     c                   if        prpdvk='6'
     c                   z-add     100000        faktor
     c                   endif
     c                   if        prpdvk='7'
     c                   z-add     5             faktor
     c                   endif
     c                   if        prpdvk='8'
     c                   z-add     25            faktor
     c                   endif
     c                   if        prpdvk='9'
     c                   z-add     500           faktor
     c                   endif

     c                   z-add     PRGADA        datumv
     c                   z-add     PRGBDA        datumb
     c                   z-add     PREZPR        WEKPR
     c                   eval      wekpr = wekpr/faktor

     c                   ENDIF
     C                   ENDDO
     C*
     C     ##5700        ENDSR
     C*
     C**************************************************************************
     C* SRprj042p: ...
     C*-------------------------------------------------------------------------
     C*
     C     SRprj042p     BEGSR
     C*
     C*
     c                   movel     #TEDIAV       dspber
     c     DSPBER        chain     prj042p
     c                   IF        %found(prj042p)
     c                   else
     c                   movel     TPTTXT        Bez
     c                   write     PRJ042F
     c                   ENDIF
     C*
     C     ##prj042p     ENDSR
     C*
     C**************************************************************************
     C* SRPRJ684P: ...
     C*-------------------------------------------------------------------------
     C*
     C     SRPRJ684P     BEGSR
     C*
     C*
     c                   movel     #TESAAV       HBMW
     c     HBMW          chain     PRJ684P
     c                   IF        %found(PRJ684P)
     c                   else
     c                   movel     TPTTXT        §Bez
     c                   write     PRJ684F
     c                   ENDIF
     C*
     C     ##PRJ684P     ENDSR
     C*
     C**************************************************************************
     C* SR5800: BBEP09
     C*-------------------------------------------------------------------------
     C*
     C     SR5800        BEGSR
     C*
     c     KEY5800       klist
     c                   kfld                    EPFIRM
     c                   kfld                    eptenr
     C*
     C                   movel     '01'          EPFIRM
     c                   movel     artnr         eptenr
     C*
     c                   eval      %subst(BUCHUNG: 11: 1) = ' '
     c     KEY5800       chain     bbep09
     c                   IF        %found(BBEP09)
     c                   else
     c                   eval      %subst(BUCHUNG: 11: 1) = 'D'
     c                   ENDIF
     C*
     C     ##5800        ENDSR
     C*
     C**************************************************************************
     C* SR5900: teuf00 Mengeneinheiten
     C*-------------------------------------------------------------------------
     C*
     C     SR5900        BEGSR
     C*
     c*  Schlüsselliste für teuf00
     c     key5900       klist
     c                   kfld                    FIRMA
     c                   kfld                    tuTENR
     c                   kfld                    tumein

     C                   movel     '01'          FIRMA
     c                   movel     artnr         tuTENR
     c                   movel     eeinh2        tumein

     c     KEY5900       chain     teuf00
     c                   IF        %found(teuf00)
     c                   ENDIF

     C*
     C     ##5900        ENDSR

     C**************************************************************************
     C* SR9500: datenermittlung gemäß waecolcp
     C*-------------------------------------------------------------------------
     C     SR9500        BEGSR
     C*
     C                   clear                   $key1
     C                   clear                   $key2
     C                   clear                   $key3
     C                   z-add     *zero         LCP280
     C                   movel     jahr          $key1
     C                   movel     'LCP280'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr9800
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp280           1102
     c                   ENDIF
      *
     C                   z-add     *zero         LCP300           1102
     C                   movel     jahr          $key1
     C                   movel     'LCP300'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr9800
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp300           1102
     c                   ENDIF
      *
     C                   z-add     *zero         LCP270           1102
     C                   movel     jahr          $key1
     C                   movel     'LCP270'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr9800
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp270           1102
     c                   ENDIF
      *
     c                   clear                   lcp050           1102
     C                   eval      LCP050=((ekpr-beistell)*kwakurs)
     C*********          z-add     wekpr         LCP050           1102
     C                   movel     wacdek        LCP060           1102
     C                   z-add     kwakurs       LCP070           1102
     c                   clear                   lcp080           1102
     C                   eval      LCP080= (ekpr-beistell)
     C*********          z-add     ekpr          LCP080
     C                   z-add     fracht        LCP090           1102
     C                   z-add     §zoll         LCP100           1102
     C                   z-add     versicheru    LCP110           1102
     C                   z-add     beistell      LCP120           1102
     C                   z-add     entwicklun    LCP130           1102
     C*
     c                   clear                   lcp140           1102
     C                   eval      lcp140 = ( LCP080 + LCP090 + LCP100 +
     C                                        LCP110 + LCP120 + LCP130 )
      *
      *
     c                   clear                   lcp160           1102
     C                   if        ARTZ1   = 'EIPROD'
     C                   eval      lcp160 = lcp140 + (LCP270 * CWSTCK2) +
     C                                      (LCP270 * CWSTCK2)*LCP280/100
     C                   endif
      *
      *                  ... sollte dann Handelsware sein
     C                   if        ARTZ1   = '      '
     C                   z-add     lcp140        LCP160
     C                   endif
     C                   z-add     lcp160        LCP170           1102
      *
     c                   clear                   lcp200           1102
     c                   clear                   lcp220           1102
     C                   eval      LCP200  =lcp160+(LCP140 * LCP300/100)
     C                   eval      lcp220  =     LCP200
      *
     c                   clear                   lcp230           1102
     C                   eval      lcp230  =(LCP270 * CWSTCK2)
     C* siehe oben                               LCP270
     C                   z-add     CWSTCK2       LCP260           1102
     C* siehe oben                               LCP280           1102
     c                   clear                   lcp290           1102
     C                   eval      LCP290 = (LCP270 * CWSTCK2)*LCP280/100
     C* siehe oben                               LCP300
     c                   clear                   lcp310           1102
     C                   eval      LCP310  = (LCP140 * LCP300/100)
     C*
     C     ##9500        ENDSR

     C**************************************************************************
     C* SR9050: lesen Parameterdaten aus DometicSystemdatei
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
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     c                   move      '01'          firma             2
     c                   movel     'LP1'         begr              3

     C     *DTAARA       DEFINE                  #sku             10 0
     C     *lock         IN        #sku

     C                   clear                   jahr$             4 0
     C                   clear                   monat$            2 0
     c/exec sql
     c+ select current timestamp, current date, current time,
     c+        year(current date -1 month),
     c+        month(current date -1 month)
     c+ into   :tstampi, :datumi, :zeit, :jahr$, :monat$
     c+ from   gang/systempf
     c/end-exec


     C                   ENDSR

