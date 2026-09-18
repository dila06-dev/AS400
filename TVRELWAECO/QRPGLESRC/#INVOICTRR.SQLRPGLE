     h option(*SRCSTMT:*NoDebugIO)
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
     F* CHGDTAARA DTAARA($invoices  *ALL) VALUE(1148)            *
     F*              * letzte verwendete aus Datei               *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  27.08.2014  assignment in header                        *
     F*  amount,TOTALAMOUN,BASISAMOUN  now without mulitly       *
     F*  27.08.2014 assignment in position                       *
     F*  amount, PERQUANTIT changed in different way             *
     F*                                                          *
     F*  SELECT ZBFIRM,ZBZABD,ZBTXT1, ZBTXT2,ZBNTAM,
     F*  ZBNMAM,ZBNTIN,ZBZAT1,ZBZAM1,ZBZAT2,ZBZAM2, ZBZAT3,ZBZAM3 FROM zabd
     F*  WHERE zbNTIN = 0 and ZBNTAM =0 and ZBNMAM =0 ORDER BY
     F*  ZBFIRM,ZBZABD,ZBZAT1
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*27.05.2016 changed coding 3 digits                        *
     F*select distinct substr(COUNT00001, 1, 03)           into :CUSTOMCOUN
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     finvoices  up   e             disk    RENAME(invoices :PHY01R)
     fE_INVOICE if a e             disk    RENAME(E_INVOICE:PHY02R)
     finvoiceposif a e             disk    RENAME(INVOICER :PHY03R)
     f                                     usropn
     fCUSTID    if a e             disk    RENAME(IXSRECR  :PHY04R)
     f                                     usropn
     fCUSTTAXID if a e             disk    RENAME(CUSTTAXR :PHY05R)
     f                                     usropn
     fINVOICEHEAif a e             disk    RENAME(INVOICER :PHY06R)
     f                                     usropn
     fSUPPID    if a e             disk    RENAME(IXSRECR  :PHY07R)
     f                                     usropn
     fSUPPTAXID if a e             disk    RENAME(SUPPTAXR :PHY08R)
     f                                     usropn
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
     fafad01    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcodea            C                   CONST('²³°§µÖÜÄòÉ')
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
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

     I*-------------------------------------------------------------------------
     I/COPY ##I001
     I*-------------------------------------------------------------------------
     Iphy02r
     I              E_INVOICE                   sentence
     I
     C*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    company           2
     C                   PARM                    returnc          30
     C*-------------------------------------------------------------------------

     c  n22              eval      keys  = 'no match found'
     c                   seton                                        22

     c                   if        company     =      rkfirm and
     c                             week        < 8           and
     c                             (rkfirm = '55' and rkkdnr='06233  ' or
     c                              rkfirm = '52' and rkkdnr='0666000' or
     c********                      rkfirm = '08' and rkkdnr='0010300' or
     c                              rkfirm = '08' and rkkdnr='0039300' or
     c                              rkfirm = '01' and rkkdnr='088505'  or
     c                              rkfirm = '01' and rkkdnr='008138'  or
     c                              rkfirm = '01' and rkkdnr='052774'  or
     c                              rkfirm = '01'                      or
     c                              rkfirm = '08'                      or
     c                              rkfirm = '52'                      or
     c                              rkfirm = '55'                      )
     c                   if        status = '  '
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *LIKE         DEFINE    RKFIRM        §§RKFIRM
     C     *LIKE         DEFINE    RKRGJJ        §§RKRGJJ
     C     *LIKE         DEFINE    RKRGNR        §§RKRGNR
     C                   if        §§RKFIRM   = *blank  and
     C                             §§RKRGJJ   = 0       and
     C                             §§RKRGNR   = *blank
     C                   eval      §§RKFIRM   = RKFIRM
     C                   eval      §§RKRGJJ   = RKRGJJ
     C                   eval      §§RKRGNR   = RKRGNR
     c                   seton                                        64
     c                   setoff                                       63
     C                   endif

     C                   if        §§RKFIRM   = RKFIRM  and
     C                             §§RKRGJJ   = RKRGJJ  and
     C                             §§RKRGNR   = RKRGNR
     C     *DTAARA       DEFINE                  $invoices        10 0
     C  n25*lock         IN        $invoices
     C  n25              eval      $invoices  =  $invoices   + 1
     C                   if        *in22      = '1'
     C  n25              out       $invoices
     C                   endif
     C  n25              exsr      sr_001
     c                   seton                                        25
     c                   exsr      sr1000
     c                   if        rkerg1 <> *zero
     c                   movea     '1000'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg2 <> *zero
     c                   movea     '0100'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg3 <> *zero
     c                   movea     '0010'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   if        rkerg4 <> *zero
     c                   movea     '0001'        *IN(41)
     c                   exsr      sr_002b
     c                   endif
     c                   eval      status = '10'
     c                   eval      #cc = $invoices
     C                   eval      protokoll =         #protokoll
     C                   eval      pgm       =         §§§pgm
     C                   eval      JOB       =         §§§job
     C                   eval      user      =         §§§usr
     c   22              update    phy01r

     c                   endif
     c                   endif
     c                   endif
     Clr                 exsr      sr_003
     Clr 22              out       unique_inv
     Clr 64              eval      RKFIRM     = §§RKFIRM
     Clr 64              eval      RKRGJJ     = §§RKRGJJ
     Clr 64              eval      RKRGNR     = §§RKRGNR
     Clr 64              z-add     23            doclength         2 0
     Clr                 if        enviro  =  'life'
     Clr 64              exsr      srcommand
     Clr                 endif
     Clr                 if        enviro  <> 'life'
     Clr 64              exsr      srcommandt
     Clr                 endif
     Clr 64              eval      returnc =   %subst(keys:01:doclength)
     Clrn64              eval      returnc =   'no match found'
     Clr 64              exsr      srSAVEDATA

     C**************************************************************************
     C* sr_001: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $invoices     ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'A'                           +
     c                             %subst(##tst:01:04)           +
     c                             %subst(##tst:06:02)           +
     c                             %subst(##tst:09:02)           +
     c                             %subst(##tst:12:02)           +
     c                             %subst(##tst:15:02)           +
     c                             %subst(##tst:18:02)           +
     c                             %subst(##tst:21:02)           +
     c                             'Manfred Gang Dometic WAECO Int.GmbH     ' +
     c                             '+49 (0)2572 879 - 419   '                 +
     c                             'E-Mail: gang@dometic-waeco.de '           +
     c                             'Internet: http://www.dometic-waeco.de   ' +
     c                             #filler01
     c                   seton                                        40
     c                   write     phy02r
     C*
     C     ##_001        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
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
     C*
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
     C*
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     c                   movel     '0'           typProd           1
     C                   eval      unique_inv = unique_inv + 1
     C                   move      unique_inv    #unique_f        18
     C                   movel     'M'           Paym              1
     C                   movel     ALTENR        #ALTENR          12
     C*
     c* 15.03.2012                                               +
     C                   if        RPUPOS  <> 0
     C                   z-add     RPNESU        ALNESU
     C                   exsr      sr9020
     C                   endif
     C*
     c                   eval      typRecord = 'B'
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 '
     c                   movel     'D'           typRecord         1
     c****               Achtung da Gewährleistung typProd = 'A'
     c                   movel     'A'           typProd           1
     c                   endif
     c                   if        AKAFAT    = '50 ' or AKAFAT    = '70 ' or
     c                             AKAFAT    = '71 ' or AKAFAT    = '82 '
     c                   eval      typRecord = 'C'
     c                   endif
     c
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
     c                   movel     rkvada        #rkvada           8
     c                   movel     '00000000'    #rkvada           8
     c     ' ':'0'       xlate     #rkvada       #rkvada
     c
     c                   clear                   artikelq2        10
     c                   clear                   artikelq3        12
     c                   clear                   artikelq4        10
     c                   movel     '0000'        weight            4
     c                   z-add     alglmg        menge             5 0
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   move      menge         #menge            5
     c                   z-add     ALPREI        lpreis            9 2
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   z-add     ALNTSK        poswertn         11 2
     c                   z-add     ALNESU        poswertn         11 2
     c                   if        poswertn   < 0
     c                   eval      poswertn=poswertn   * -1
     c                   endif
     c                   move      poswertn      #poswertn        11
 MG01c                   movel     'N'           indicator         1
 MG01c                   if        poswertn = 0
 MG01c                   movel     'Y'           indicator         1
 MG01c                   endif
     c                   clear                   unitpnetto        9 2
     c                   if        alglmg <>0
     c                   eval      unitpnetto = (poswertn/alglmg)
     c                   else
     c                   eval      unitpnetto = (poswertn/1)
     c                   endif
     c                   if        unitpnetto < 0
     c                   eval      unitpnetto = unitpnetto * -1
     c                   endif
     c                   move      unitpnetto    #unitpnetto       9
     c                   movel     ' '           CreditInit        1
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '71 ' or
     c                             AKAFAT    = '82 ' or AKAFAT    = '71 '
     c                   movel     'C'           CreditInit        1
     c*                  CreditInit = ' '  bei gutschrift 'C'
     c                   endif
     c                   clear                   filler01         50
     c                   clear                   kiaHyundai       10
     c
     c                   exsr      sr5000
     c                   exsr      sr6000
     c                   exsr      sr7000
     c                   if        KdrOrder  = KdrDelev
     c                   clear                   KdrDelev
     c                   endif
     c
     c                   movel     '5000'        rab01             4
     c                   movel     '2500'        rab02             4
     c                   movel     '1000'        rab03             4
     c                   movel     ALAFPO        #alafpo           4
     c                   movel     ALlipo        #allipo           4
     c
     C                   clear                   #unique_fr       18
     c                   if        typRecord = 'C'
     c                   exsr      sr8000
     c                   clear                   xpos              2 0
     c                   clear                   ypos              2 0
     c                   movel     '0000000000'  wert             10
     c                   eval      xpos = %scan(' ': unique_fr)
     c                   eval      xpos = xpos - 1
     c                   eval      ypos = 10 - xpos
     c                   eval      ypos = ypos + 1
     c                   if        xpos <> 0 and xpos <> -1
     c                   eval      %subst(wert: ypos: xpos) =
     c                             %subst(unique_fr: 1: xpos)
     C                   endif
     C                   move      wert          #unique_fr       18
     c                   if        wert = '0000000000' or
     c                             wert = '          '
     c                   endif
     c***                Korrektur auf 'D', wenn keine C-Referenz
 MG02c                   if        wert = '0000000000' or
 MG02c                             wert = '          '
 MG02c                   movel     'D'           typRecord         1
 MG02c                   movel     'A'           typProd           1
 MG02C                   clear                   #unique_fr       18
     c                   movel     'C'           CreditInit        1
 MG02c                   endif
     c                   endif
     c
     c                   if        AKREF1 = ' ' and
     c                             %subst(AKREF2:01:20) = ' ' and
     c                             typRecord = 'C'
     c                   movel     'Gutschrift'  AKREF1
     c                   endif
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
     c                             KdrBill                       +
     c                             KdrOrder                      +
     c                             KdrDelev                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             alafnr                        +
     c                             %subst(#ALAFPO:2:3)           +
     c                             %char(alafda)                 +
     c                             ALLINR                        +
     c                             %subst(#ALlipo:2:3)           +
     c*******                      %subst(%char(allipo):1:3)     +
     c                             %char(allsda)                 +
     c                             rkrgnr                        +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c* 15.03.2012                                               +
     c                             %subst(RPTENR:01:12)          +
     c                             'WAE'                         +
     c                             ALTBZ1                        +
     c                             '          '                  +
     c                             ALPRGR                        +
     c                             '      '                      +
     c                             artikelq2                     +
     c                             artikelq3                     +
     c                             artikelq4                     +
     c                             weight                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             #kon1                         +
     c                             #kon2                         +
     c                             #kon3                         +
     c                             mwst                          +
     c                             #poswertn                     +
 MG01c                             indicator                     +
     c                             AKREF1                        +
     c                             %subst(AKREF2:01:20)          +
     c                             #kon4                         +
     c                             #unitpnetto                   +
     c                             CreditInit                    +
     c                             #rkvada                       +
     c                             #unique_f                     +
     c                             filler01                      +
     c****************************************
     c                             kiaHyundai                    +
     c                             #unique_fR
     c                   write     phy02r
     c
      * :===>          -initialisierung aller KÖPFE
      * :===>          -open
     c  n63              exsr      sr9500
     c  n63              exsr      sr9800
     c                   seton                                        63
     C                   movel     keys          INVOICEID
     C                   clear                   INVOICEID
     C                   movel     keys2         INVOICEID
     c                   eval      INVOICELIN  = %subst(RPTENR:01:15)
     c
     c                   eval      DESCRIPTIO  = ALTBZ1
     c                   eval      INVOIC8     = 'Invoiced Quantity  '
     c                   if        ALNESU < 0
     c                   eval      INVOIC8     = 'credit note        '
     c                   endif
     c                   eval      QUANTITY    = menge
     c                   eval      UNITPRICE_  = rkwacd
     c                   eval      AMOUNT      = unitpnetto
     c                   eval      UNITCODE    = 'ST'
     c                   eval      PERQUANTIT  = 1
     c                   eval      INVOIC9     = rkwacd
     c                   eval      TOTALAMOUN  = poswertn
     c                   z-add     poswertn      TOTALAMOUN
     c                   if        RPMWCD       = '30'
     c                   endif
     c                   eval      TAXRATE     = 0,00
     c                   eval      TAXAMOUNT   = poswertn *1 * 0
     c                   eval      ORDERREF    = %char(ALAFJJ)  +
     c                                                (ALAFNR)
     c                   clear                   shpref
     c                   eval      shpref      = %char(RKLIJJ)  +
     c                                                (RKLINR)
     c*******                                    %char(Rplipo)
     c                   clear                   amountrab
     c                   eval      amountrab =
     c                             (RPERG1 + RPERG2 + RPERG3 + RPERG4)
     c                   eval      POREF       = almaaf
     c                   if        almaaf      = ' ' or
     c                             RKKDNR      = '008138'
     c                   eval      POREF       = akref1
     c                   endif
     c
     C                   if        PERQUANTIT < 0
     C                   eval      PERQUANTIT = PERQUANTIT * -1
     C                   endif
     C                   if        AMOUNT     < 0
     C                   eval      AMOUNT     = AMOUNT     * -1
     C                   endif
     C                   if        AMOUNTRAB  < 0
     C                   eval      AMOUNTRAB  = AMOUNTRAB  * -1
     C                   endif
     C                   if        TOTALAMOUN < 0
     C                   eval      TOTALAMOUN = TOTALAMOUN * -1
     C                   endif
     C                   if        TAXAMOUNT  < 0
     C                   eval      TAXAMOUNT  = TAXAMOUNT  * -1
     C                   endif
     C                   if        QUANTITY   < 0
     C                   eval      QUANTITY   = QUANTITY   * -1
     C                   endif
     c
     c                   setoff                                       62
     c                   write     phy03r
     c   62              write     phy04r
     c   62              write     phy05r
     c   62              write     phy06r
     c   62              write     phy07r
     c   62              write     phy08r
     c*
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
     C                   eval      unique_inv = unique_inv + 1
     C                   move      unique_inv    #unique_f        18
     C                   movel     'M'           Paym              1
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
     c
     c                   if        ALMWCD  = '16'
     c                   movel     '1900'        mwst              4
     c                   endif
     c
     c                   movel     rkvada        #rkvada           8
     c                   movel     '00000000'    #rkvada           8
     c     ' ':'0'       xlate     #rkvada       #rkvada
     c
     c                   clear                   artikelq2        10
     c                   clear                   artikelq3        12
     c                   clear                   artikelq4        10
     c                   movel     '0000'        weight            4
     c                   z-add     1             menge             5 0
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   move      menge         #menge            5
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
     c   41              z-add     rkerg1        poswertn
     c   42              z-add     rkerg2        poswertn
     c   43              z-add     rkerg3        poswertn
     c   44              z-add     rkerg4        poswertn
     c                   if        poswertn   < 0
     c                   eval      poswertn=poswertn   * -1
     c                   movel     'C'           CreditInit        1
     c                   endif
     c                   move      poswertn      #poswertn        11
 MG01c                   movel     'N'           indicator         1
 MG01c                   if        poswertn = 0
 MG01c                   movel     'Y'           indicator         1
 MG01c                   endif
     c                   clear                   unitpnetto        9 2
     c                   eval      unitpnetto = (poswertn/ 00001)
     c                   if        unitpnetto < 0
     c                   eval      unitpnetto = unitpnetto * -1
     c                   endif
     c                   move      unitpnetto    #unitpnetto       9
     c                   clear                   filler01         50
     c                   clear                   kiaHyundai       10
     c
     c                   exsr      sr5000
     c                   exsr      sr6000
     c                   exsr      sr7000
     c                   if        KdrOrder  = KdrDelev
     c                   clear                   KdrDelev
     c                   endif
     c
     c                   movel     '5000'        rab01             4
     c                   movel     '2500'        rab02             4
     c                   movel     '1000'        rab03             4
     c   41              movel     '0001'        #alafpo           4
     c   41              movel     '0001'        #allipo           4
     c   42              movel     '0002'        #alafpo           4
     c   42              movel     '0002'        #allipo           4
     c   43              movel     '0003'        #alafpo           4
     c   43              movel     '0003'        #allipo           4
     c   44              movel     '0004'        #alafpo           4
     c   44              movel     '0004'        #allipo           4
     c
     C                   clear                   #unique_fr       18
     c                   if        typRecord = 'C'
     c                   exsr      sr8000
     c                   clear                   xpos              2 0
     c                   clear                   ypos              2 0
     c                   movel     '0000000000'  wert             10
     c                   eval      xpos = %scan(' ': unique_fr)
     c                   eval      xpos = xpos - 1
     c                   eval      ypos = 10 - xpos
     c                   eval      ypos = ypos + 1
     c                   if        xpos <> 0 and xpos <> -1
     c                   eval      %subst(wert: ypos: xpos) =
     c                             %subst(unique_fr: 1: xpos)
     C                   endif
     C                   move      wert          #unique_fr       18
     c                   if        wert = '0000000000' or
     c                             wert = '          '
     c                   endif
     c***                Korrektur auf 'D', wenn keine C-Referenz
 MG02c                   if        wert = '0000000000' or
 MG02c                             wert = '          '
 MG02c                   movel     'D'           typRecord         1
 MG02c                   movel     'A'           typProd           1
     c                   movel     'C'           CreditInit        1
 MG02C                   clear                   #unique_fr       18
 MG02c                   endif
     c                   endif
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
     c                   if        AKREF1 = ' ' and
     c                             %subst(AKREF2:01:20) = ' ' and
     c                             typRecord = 'C'
     c                   movel     'Gutschrift'  AKREF1
     c                   endif
     c
     c*25.10.2012 creditInit immer *blank bei typ 'B'
     c*sind bei Ford durchgelaufen, soll aber lt. CT nicht sein
     c*bei Mobis liefen sie stattdessen auf eine Fehlermeldung
     c                   if        typRecord = 'B'
     c                   clear                   CreditInit
     c                   endif
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
     c                             KdrBill                       +
     c                             KdrOrder                      +
     c                             KdrDelev                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             alafnr                        +
     c                             %subst(#ALAFPO:2:3)           +
     c                             %char(alafda)                 +
     c                             ALLINR                        +
     c                             %subst(#ALlipo:2:3)           +
     c*******                      %subst(%char(allipo):1:3)     +
     c                             %char(allsda)                 +
     c                             rkrgnr                        +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c                             %subst(TPTTXT:01:12)          +
     c                             'WAE'                         +
     c                             ALTBZ1                        +
     c                             '          '                  +
     c                             ALPRGR                        +
     c                             '      '                      +
     c                             artikelq2                     +
     c                             artikelq3                     +
     c                             artikelq4                     +
     c                             weight                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             #kon1                         +
     c                             #kon2                         +
     c                             #kon3                         +
     c                             mwst                          +
     c                             #poswertn                     +
 MG01c                             indicator                     +
     c                             AKREF1                        +
     c                             %subst(AKREF2:01:20)          +
     c                             #kon4                         +
     c                             #unitpnetto                   +
     c                             CreditInit                    +
     c                             #rkvada                       +
     c                             #unique_f                     +
     c                             filler01                      +
     c****************************************
     c                             kiaHyundai                    +
     c                             #unique_fR
     c                   write     phy02r
     C                   movel     keys          INVOICEID
     C                   clear                   INVOICEID
     C                   movel     keys2         INVOICEID
     c                   eval      INVOICELIN  = %subst(RPTENR:01:15)
     c                   eval      DESCRIPTIO  = ALTBZ1
     c                   eval      INVOIC8     = 'Invoiced Quantity  '
     c                   if        ALNESU < 0
     c                   eval      INVOIC8     = 'credit note        '
     c                   endif
     c                   eval      QUANTITY    = menge
     c*                  eval      UNITPRICE_  = rkwacd
     c                   eval      AMOUNT      = unitpnetto
     c                   eval      UNITCODE    = 'ST'
     c                   eval      PERQUANTIT  = 1
     c                   eval      INVOIC9     = rkwacd
     c                   eval      TOTALAMOUN  = poswertn
     c                   z-add     poswertn      TOTALAMOUN
     c                   if        RPMWCD       = '30'
     c                   endif
     c                   eval      TAXRATE     = 19,00
     c                   eval      TAXAMOUNT   = poswertn * 1 * 0
     c                   eval      ORDERREF    = %char(ALAFJJ)  +
     c                                                (ALAFNR)
     c                   clear                   shpref
     c                   eval      shpref      = %char(RKLIJJ)  +
     c                                                (RKLINR)
     c********                                   %char(Rplipo)
     c                   clear                   amountrab
     c                   eval      amountrab =
     c                             (RPERG1 + RPERG2 + RPERG3 + RPERG4)
     c                   clear                   POREF
     c                   clear                   SHPREF
     c                   eval      POREF       = almaaf
     c                   if        almaaf      = ' ' or
     c                             RKKDNR      = '008138'
     c                   eval      POREF       = akref1
     c                   endif
     c
     C                   if        PERQUANTIT < 0
     C                   eval      PERQUANTIT = PERQUANTIT * -1
     C                   endif
     C                   if        AMOUNT     < 0
     C                   eval      AMOUNT     = AMOUNT     * -1
     C                   endif
     C                   if        AMOUNTRAB  < 0
     C                   eval      AMOUNTRAB  = AMOUNTRAB  * -1
     C                   endif
     C                   if        TOTALAMOUN < 0
     C                   eval      TOTALAMOUN = TOTALAMOUN * -1
     C                   endif
     C                   if        TAXAMOUNT  < 0
     C                   eval      TAXAMOUNT  = TAXAMOUNT  * -1
     C                   endif
     c                   if        QUANTITY   < 0
     c                   eval      QUANTITY   = QUANTITY   * -1
     c                   endif
     c
     c                   setoff                                       62
     c                   write     phy03r
     c   62              write     phy04r
     c   62              write     phy05r
     c   62              write     phy06r
     c   62              write     phy07r
     c   62              write     phy08r
     C*
     C     ##_002b       ENDSR
     C*
     C**************************************************************************
     C* sr_003: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_003        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      $invoices     ##afrk            7
     c                   clear                   ##tst            26
     c                   clear                   #filler01       350
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'Z'                           +
     c                             #filler01
     c   40              write     phy02r
     C*
     C     ##_003        ENDSR
     C*
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
     C* sr7000: Kunde Rechnung für Ford -1-
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
     C* sr8000: unique ziehen über text
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*
     c     keysr_txbe    klist
     c                   kfld                    RKFIRM
     c                   kfld                    TBTXAR
     c                   kfld                    RPAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     c                   kfld                    TBUPOS
     c                   kfld                    TBTCDE
     c
     c
     c                   movel     'AFDA      '  TBTXAR
     c                   clear                   TBUPOS
     c                   movel     'TXPO      '  TBTcde
     c
     c     keysr_txbe    chain     txbe01                             97
     c   97              clear                   txbe1
     c
     c  n97              movel     TBTEXT        unique_fr        10
     c  n97              movel     TBTEXT        unique_ref       13
     c   97              clear                   unique_fr
     c   97              clear                   unique_ref
     c
     C*
     C     ##8000        ENDSR
     C*
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
     C*Funktion Aufbereitung der Inhalte hier clearing  Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr9500        BEGSR
     C*
     C
     C                   clear                   keys             30
     C                   clear                   keys2            30
     C                   clear                   protokoll
     C                   clear                   id_id
     C                   clear                   TOTALAMOUN
     C                   clear                   TAX_CURREN
     C                   clear                   BASISAMOUN
     C                   clear                   RATENUMERI
     C                   clear                   PROCESSINV
     C                   clear                   TAX_AMOUNT
     C                   clear                   #RKNESU          1304
     C*
     C                   clear                   INVOICEID
     C                   clear                   WAECONR           6
     c*                                   and RKFIRM
     c*
     c/exec sql
     C+ select sum(rknesu)               into :#RKNESU
     C+            from  AFRK01
     C+            where RKFIRM  = :RKFIRM    and
     C+                  RKRGJJ  = :RKRGJJ    and
     C+                  RKRGNR  = :RKRGNR
     c/end-exec
     C*
     C*
     C*
     C                   clear                   kunde             7
     C********           movel     '088505 '     kdkdnr
     C                   movel     kdkdnr        kunde
     C                   clear                   RECEIVER_L
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :RECEIVER_L
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C*
     C                   clear                   LOGICALID
     c/exec sql
     C+ select substr("LogicalID", 1, 6) into :LOGICALID
     C+            from einvoice/idnumbers
     C+            where WAECONR = '000000'   and
     C+            "LogicalID"                is not null     and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C*
     C*
     C                   if               rkfirm='01' or rkfirm= '55'
     C                                                or rkfirm= '52'
     C                                                or rkfirm= '08'
     C                   eval             WAECONR  =  '000000'
     C                   eval             keys     =  RECEIVER_L + '_' +
     C                                                LOGICALID  +
     C                                           %char(RKRGJJ)   +
     C                                                 RKRGNR
     C                   eval             keys2    =
     C                                           %char(RKRGJJ)   +
     C                                                 RKRGNR
     C
     C                   eval             protokoll=   RKFIRM    +
     C                                           %char(RKRGJJ)   +
     C                                                 RKRGNR    + ' ' +
     C***********************************        %char(RKLIJJ)   +
     C***********************************              RKLINR    +
     C***********************************              RKKDNR    + ' ' +
     C                                           %char(#CC   )   +
     C                                                 STATUS    + ' ' +
     C                                           %char(#DATE )   + ' ' +
     C                                           %char(#TSTAMP)  + ' ' +
     C                                           %char(#COUNT)   + ' ' +
     C                                           %char(tstampi)  + ' ' +
     C                                                 §§§pgm    + ' ' +
     C                                                 §§§job    + ' ' +
     C                                                 §§§usr
     C                   movel     protokoll     #protokoll      132
     C                   movel     keys          id_id
     C                   clear                   id_id
     C                   movel     keys2         id_id
     C                   movel     keys          INVOICEID
     C                   clear                   INVOICEID
     C                   movel     keys2         INVOICEID

     C                   eval      TOTALAMOUN = #RKNESU*1
     C                   eval      AMOUNT     = #RKNESU*1
     C                   movel     rkwacd        TAX_CURREN
     C                   movel     rkwacd        TAXAUTHORI
     C                   movel     rkwacd        AMOUNT_CUR
     C                   eval      BASISAMOUN = #RKNESU*1
     C                   eval      TAXAUT7=
     C                             (RKMWS1+rkmws2+RKMWS3)*1
     C                   eval      TAX_AMOUNT=
     C                             (RKMWS1+rkmws2+RKMWS3)*1
     C                   clear                   PROCESSINV
     C                   endif


     c/exec sql
     c+ whenever SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec

     C*Ausgabe CUSTID     - 1 -  Ausgabe CUSTTAXID     -2 - über :kunde
     C/COPY ##CUST                                         ##CUST

     C*Ausgabe INVOICEHEA - 3 -     ''''''''''''''''''''''''''''''''''
     c/exec sql
     C+ update einvoice/INVOICEHEA
     C+ set LOGICALID = :id_id,
     C+     RECEIVER_L= '     '
     c/end-exec
     C*
     C                   clear                   kunde             7
     C                   movel     kdkdnr        kunde
     C                   clear                   RECEIVER_L
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :RECEIVER_L
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   LOGICALID
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :LOGICALID
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "LogicalID"      is not null     and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   CREATIONDA
     C                   movel     rkjdat        #rkjdat           8
     C                   movel     rkjdat        #rkjzei           6
     C                   eval      CREATIONDA    =
     C***************              %subst(%char(tstampi):01:10)  +  'T' +
     C***************              %subst(%char(tstampi):12:12)
     C                             %subst(    (#RKJDAT):01:04) +  '-' +
     C                             %subst(    (#RKJDAT):05:02) +  '-' +
     C                             %subst(    (#RKJDAT):07:02) +  'T' +
     C                             %subst(    (#RKJZEI):01:02) +  ':' +
     C                             %subst(    (#RKJZEI):03:02) +  ':' +
     C                             %subst(    (#RKJZEI):05:02)
     C                   clear                   PROCESS
     C                   movel     'Invoice'     TYPE
     C                   clear                   GXSTYPE
     C                   eval       GXSTYPE ='Duplication Reason'
     C                   clear                   GXSDESC
     C                   movel     keys          GXSDESC
     C                   clear                   GXSDESC
     C                   movel     keys2         GXSDESC
     C                   clear                   id
     C                   movel     keys          id
     C                   clear                   id
     C                   movel     keys2         id
     C                   clear                   DOCUMENTDA
     C                   movel     rkjdat        #rkjdat           8
     C                   movel     rkjdat        #rkjzei           6
     C                   eval      DOCUMENTDA    =
     C                             %subst(    (#RKJDAT):01:04) +  '-' +
     C                             %subst(    (#RKJDAT):05:02) +  '-' +
     C                             %subst(    (#RKJDAT):07:02) +  'T' +
     C                             %subst(    (#RKJZEI):01:02) +  ':' +
     C                             %subst(    (#RKJZEI):03:02) +  ':' +
     C                             %subst(    (#RKJZEI):05:02)
     C                   clear                   CURRENCYID
     C                   movel     rkwacd        CURRENCYID
     C                   eval      TOTALAMOUN = #RKNESU
     C                   clear                   QUALIFIEDA
     C                   movel     rkwacd        QUALIFIEDA
     C                   eval      AMOUNT     = #RKNESU
     C                   clear                   CHARGETYPE
     C                   clear                   CHARGEAMT
     C                   clear                   CHARGEDATE
     C                   clear                   #HARGEDATE       10
     C
     C*Standard + x tage wenn ZBNTAM(fester Tag)=0 and ZBNMAM=0 Monate
     C*zbntin = Zahlungstage
     c/exec sql
     C+ select distinct substr(char
     C+ (date(substr(char(:rkreda), 1, 4) concat '-' concat
     C+       substr(char(:rkreda), 5, 2) concat '-' concat
     C+       substr(char(:rkreda), 7, 2)  ) + ZBNTIN days, iso), 1, 10)
     C+       into :#HARGEDATE
     C+       from zabd  where ZBZABD = :RKZABD and ZBFIRM =:rkfirm and
     C+                        ZBNMAM = 0 and ZBNTAM = 0
     c/end-exec
     c
     C*Standard feste Zurodnung ZBNTAM(fester Tag) and ZBNMAM Monate >0
     C*sogenannte Dips Konditionen  festgelegter Tag nach x Monaten
     c                   if        #HARGEDATE = *blank
     c/exec sql
     C+ select distinct substr(char
     C+ (date(substr(char(:rkreda), 1, 4) concat '-' concat
     C+       substr(char(:rkreda), 5, 2) concat '-' concat
     C+       substr(char(ZBNTAM), 1, 2)  ) + ZBNMAM month, iso), 1, 10)
     C+       into :#HARGEDATE
     C+       from zabd  where ZBZABD = :RKZABD and ZBFIRM =:rkfirm and
     C+                        ZBNMAM > 0 and ZBNTAM > 0
     c/end-exec
     c                   endif
     c
     C*Standard feste Zurodnung nur ZBNMAM Monate >0
     C*sogenannte Dips Konditionen festgelegter Monaten,Tage aus Rechnung
     c                   if        #HARGEDATE = *blank
     c/exec sql
     C+ select distinct substr(char
     C+ (date(substr(char(:rkreda), 1, 4) concat '-' concat
     C+       substr(char(:rkreda), 5, 2) concat '-' concat
     C+       substr(char(:rkreda), 7, 2) ) + ZBNMAM month, iso), 1, 10)
     C+       into :#HARGEDATE
     C+       from zabd  where ZBZABD = :RKZABD and ZBFIRM =:rkfirm and
     C+                        ZBNMAM > 0 and ZBNTAM > 0
     c/end-exec
     c                   endif
     c
     C                   movel     #HARGEDATE    CHARGEDATE
     C                   eval      CHARGEDATE    =
     C                             %subst( (#HARGEDATE):01:10) +
     C                                                 'T00:00:00 '
     C                   clear                   Name
     c/exec sql
     4+ select substr("Name", 1, 40)               into :NAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "Name"                is not null       and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   SUPPLIERPA
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :SUPPLIERPA
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "LogicalID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   STREETNAME
     c/exec sql
     4+ select substr("StreetName", 1, 40)         into :STREETNAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "StreetName"               is not null     and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CITYNAME
     c/exec sql
     c+ select substr("CityName", 1, 40)           into :CITYNAME
     c+            from einvoice/idnumbers
     c+            where WAECONR = :WAECONR   and
     c+            "CityName"                 is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   COUNTRYCOD
     c/exec sql
     c+ select substr("CountryCode", 1, 40)        into :COUNTRYCOD
     c+            from einvoice/idnumbers
     c+            where WAECONR = :WAECONR   and
     c+            "CountryCode"              is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   POSTALCODE
     c/exec sql
     4+ select substr("PostalCode", 1, 40)         into :POSTALCODE
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "PostalCode"               is not null    and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CUSTOMERPA
     C                   clear                   CUSTOMID
     C                   clear                   CUSTOMSTR
     C                   clear                   CUSTOMLIN1
     C                   clear                   CUSTOMNAME
     C                   clear                   CUSTOMCOUN
     C                   clear                   CUSTOMPLZ
     C                   clear                   kunde
     C                   movel     kdkdnr        kunde
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :CUSTOMID
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   CUSTOMERPA
     c/exec sql
     4+ select substr("Name", 1, 40)         into :CUSTOMERPA
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "Name"                     is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CUSTOMNAME
     c/exec sql
     4+ select substr("CityName", 1, 40)         into :CUSTOMNAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "CityName"                 is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C*
     C                   clear                   CUSTOMSTR
     c/exec sql
     4+ select substr("StreetName", 1, 40)         into :CUSTOMSTR
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "StreetName"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CUSTOMCOUN
     c/exec sql
     4+ select substr(COUNT00001, 1, 03)           into :CUSTOMCOUN
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            COUNT00001                 is not null and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C*                   clear                   COUNTRYCOD
     c*/exec sql
     4*+ select substr("CountryCode", 1, 40)        into :COUNTRYCOD
     4*+            from einvoice/idnumbers
     4*+            where WAECONR = :kunde     and
     4*+            "CountryCode"              is not null  and
     C*+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C*+            COMPA00001 is not null
     c*****/end-exec
     C                   clear                   CUSTOMPLZ
     c/exec sql
     4+ select substr("PostalCode", 1, 40)         into :CUSTOMPLZ
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "PostalCode"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   BILLTOCITY
     c/exec sql
     c+ select substr("CityName", 1, 40)         into :BILLTOCITY
     c+            from einvoice/idnumbers
     c+            where WAECONR = :kunde     and
     c+            "Company"                  is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
      * :Lieferadresse/Adresse bill
     c     keysr_afad    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR
     c                   kfld                    adposi
     c                   kfld                    adaart
     c                   clear                   adposi
     c                   movel     'ADVS'        adaart

     c     keysr_afad    chain     afad01                             89
     c   89              clear                   afad1
     c   89              movel     'ADAG'        adaart
     c   89keysr_afad    chain     afad01                             89
     c   89              clear                   afad1

     c                   movel     Name          SHIPFRNAME
     c                   movel     STREETNAME    SHIPFRSTR
     c                   movel     CITYNAME      SHIPFRCITY
     c                   movel     COUNTRYCOD    SHIPFRCOUN
     c                   movel     POSTALCODE    SHIPFRPLZ
     c                   movel     ADNAM1        SHIPTONAME
     c                   clear                   SHIPTOID
     c                   movel     ADSTRA        SHIPTOSTR
     c                   clear                   SHIPTOLIN1
     c                   movel     ADWORT        SHIPTOCITY
     c                   movel     adpold        SHIPTOCOUN
     c                   movel     ADPOLZ        SHIPTOPLZ
     C
     C                   clear                   type
     C                   Movel     'Invoice'     type
     C                   clear                   type6
     C*2014.05.19*       Movel     'EU'          type6
     C                   Movel     'VAT'         type6
     C                   clear                   TAX_CURREN
     C                   movel     rkwacd        TAX_CURREN
     C                   eval      BASISAMOUN = #RKNESU
     C                   clear                   RATENUMERI
     C                   clear                   PROCESSINV
     C                   eval      PROCESSINV ='Tax free intra-community '+
     C                                         'supply according to '     +
     C                                         '§4 and §6a of value '
     C                   clear                   TAXAUTHORI
     C                   movel     rkwacd        TAXAUTHORI
     C                   clear                   TAXAUT7
     C                   clear                   AMOUNT_CUR
     C                   movel     rkwacd        AMOUNT_CUR
     C                   clear                   TAX_AMOUNT
     C                   clear                   TAXABLECCY
     C                   movel     rkwacd        TAXABLECCY
     C                   clear                   TAXABLEAMN
     C
     C                   clear                   discount
     c/exec sql
     c+ select  RPERG1+RPERG2+RPERG3+RPERG4      into :discount
     c+            from  afrp01
     c+            where RPFIRM = :RKFIRM  and
     C+                  RPRGJJ = :RKRGJJ  and
     C+                  RPRGNR = :RKRGNR
     c/end-exec
     C                   if        #RKNESU < 0
     C                   Movel     'Credit Note' type
     C                   endif
     C                   if        TOTALAMOUN < 0
     C                   eval      TOTALAMOUN = TOTALAMOUN * -1
     C                   endif
     C                   if        AMOUNT     < 0
     C                   eval      AMOUNT     = AMOUNT     * -1
     C                   endif
     C                   if        CHARGEAMT  < 0
     C                   eval      CHARGEAMT  = CHARGEAMT  * -1
     C                   endif
     C                   if        DISCOUNT   < 0
     C                   eval      DISCOUNT   = DISCOUNT   * -1
     C                   endif
     C                   if        BASISAMOUN < 0
     C                   eval      BASISAMOUN = BASISAMOUN * -1
     C                   endif
     C                   if        TAXABLEAMN < 0
     C                   eval      TAXABLEAMN = TAXABLEAMN * -1
     C                   endif
     C                   if        TAXAUT7    < 0
     C                   eval      TAXAUT7    = TAXAUT7    * -1
     C                   endif
     C                   if        TAX_AMOUNT < 0
     C                   eval      TAX_AMOUNT = TAX_AMOUNT * -1
     C                   endif
     C
     c/exec sql
     C+ update einvoice/INVOICEHEA
     C+ set
     C+     LOGICALID  = :LOGICALID ,
     C+     RECEIVER_L = :RECEIVER_L,
     C+     CREATIONDA = :CREATIONDA,
     C+     PROCESS    = :PROCESS   ,
     C+     "TYPE"     = :TYPE      ,
     C+     GXSTYPE    = :GXSTYPE   ,
     C+     GXSDESC    = :GXSDESC   ,
     C+     ID         = :ID        ,
     C+     DOCUMENTDA = :DOCUMENTDA,
     C+     CURRENCYID = :CURRENCYID,
     C+     TOTALAMOUN = :TOTALAMOUN,
     C+     QUALIFIEDA = :QUALIFIEDA,
     C+     AMOUNT     = :AMOUNT    ,
     C+     CHARGETYPE = :CHARGETYPE,
     C+     CHARGEAMT  = :CHARGEAMT ,
     C+     CHARGEDATE = :CHARGEDATE,
     C+     DISCOUNT   = :DISCOUNT  ,
     C+     NAME       = :NAME      ,
     C+     SUPPLIERPA = :SUPPLIERPA,
     C+     STREETNAME = :STREETNAME,
     C+     CITYNAME   = :CITYNAME  ,
     C+     COUNTRYCOD = :COUNTRYCOD,
     C+     POSTALCODE = :POSTALCODE,
     C+     CUSTOMERPA = :CUSTOMERPA,
     C+     CUSTOMID   = :CUSTOMID  ,
     C+     CUSTOMSTR  = :CUSTOMSTR ,
     C+     CUSTOMLIN1 = :CUSTOMLIN1,
     C+     CUSTOMNAME = :CUSTOMNAME,
     C+     CUSTOMCOUN = :CUSTOMCOUN,
     C+     CUSTOMPLZ  = :CUSTOMPLZ ,
     C+     SHIPFRNAME = :SHIPFRNAME,
     C+     SHIPFRSTR  = :SHIPFRSTR ,
     C+     SHIPFRCITY = :SHIPFRCITY,
     C+     SHIPFRCOUN = :SHIPFRCOUN,
     C+     SHIPFRPLZ  = :SHIPFRPLZ ,
     C+     SHIPTONAME = :SHIPTONAME,
     C+     SHIPTOID   = :SHIPTOID  ,
     C+     SHIPTOSTR  = :SHIPTOSTR ,
     C+     SHIPTOLIN1 = :SHIPTOLIN1,
     C+     SHIPTOCITY = :SHIPTOCITY,
     C+     SHIPTOCOUN = :SHIPTOCOUN,
     C+     SHIPTOPLZ  = :SHIPTOPLZ ,
     C+     BILLTONAME = :CUSTOMERPA,
     C+     BILLTOID   = :CUSTOMID  ,
     C+     BILLTOSTR  = :CUSTOMSTR ,
     C+     BILLTOLIN1 = :CUSTOMLIN1,
     C+     BILLTOCITY = :BILLTOCITY,
     C+     BILLTOCOUN = :CUSTOMCOUN,
     C+     BILLTOPLZ  = :CUSTOMPLZ ,
     C+     TYPE6      = :TYPE6     ,
     C+     TAX_CURREN = :TAX_CURREN,
     C+     BASISAMOUN = :BASISAMOUN,
     C+     TAXABLECCY = :TAXABLECCY,
     C+     TAXABLEAMN = :TAXABLEAMN,
     C+     RATENUMERI = :RATENUMERI,
     C+     PROCESSINV = :PROCESSINV,
     C+     TAXAUTHORI = :TAXAUTHORI,
     C+     TAXAUT7    = :TAXAUT7   ,
     C+     AMOUNT_CUR = :AMOUNT_CUR,
     C+     TAX_AMOUNT = :TAX_AMOUNT
     c/end-exec
     C*
     C*
     C*Ausgabe INVOICEPOS   - 4 -
     C*==> Ausgabe über write direkt
     c/exec sql
     C+ delete from einvoice/invoicepos
     c/end-exec
     C*
     C*Ausgabe SUPPID     - 5 -  SUPPTAXID  - 6       über :WAECONR
     C/COPY ##SUPP                                         ##SUPP
     C*

     C     ##9500        ENDSR

     C**************************************************************************
     C*open
     C*-------------------------------------------------------------------------

     C     sr9800        BEGSR
     C*
     C                   open      CUSTID
     C                   open      CUSTTAXID
     C                   open      INVOICEHEA
     C                   open      INVOICEPOS
     C                   open      SUPPID
     C                   open      SUPPTAXID
     C

     C     ##9800        ENDSR

     c*
     C**************************************************************************
     C*close
     C*-------------------------------------------------------------------------

     C     sr9850        BEGSR
     C*
     C                   close     CUSTID
     C                   close     CUSTTAXID
     C                   close     INVOICEHEA
     C                   close     INVOICEPOS
     C                   close     SUPPID
     C                   close     SUPPTAXID
     C

     C     ##9850        ENDSR

     c*
     C**************************************************************************
     C*command   LIB
     C*
     C*-------------------------------------------------------------------------

     C     SR_I4XML      BEGSR
     c                   clear                   Wrk.var1
     c
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'ADDLIBLE LIB(I4XML) POSITION(*BEFORE GANG)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'ADDLIBLE LIB(EINVOICE) POSITION(*BEFORE GANG)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C
     C     ##_I4XML      ENDSR

     C**************************************************************************
     c*
     C     *inzsr        BEGSR
     C*
     C                   exsr      SR_I4XML
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C     *DTAARA       DEFINE                  unique_inv       10 0
     C     *lock         IN        unique_inv
     C
     C     *DTAARA       DEFINE                  USESCH1401      280
     C                   IN        USESCH1401
     C
     C                   movel     'test '       enviro           04
     C                   if        company =  '01'
     C     *DTAARA       DEFINE                  inv01            04
     C                   IN        inv01
     C                   movel     inv01         enviro
     C                   endif
     C
     C                   if        company =  '08'
     C     *DTAARA       DEFINE                  inv08            04
     C                   IN        inv08
     C                   movel     inv08         enviro
     C                   endif
     C
     C                   if        company =  '52'
     C     *DTAARA       DEFINE                  inv52            04
     C                   IN        inv52
     C                   movel     inv52         enviro
     C                   endif
     C
     C                   if        company =  '55'
     C     *DTAARA       DEFINE                  inv55            04
     C                   IN        inv55
     C                   movel     inv55         enviro
     C                   endif
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

     C**************************************************************************
     C/COPY ##command                                      command
     C/COPY ##SAVEDATA                                     ##SAVEDATA
     C/COPY ##commandt                                     commandt
     C/COPY ##CLRPFM                                       ##CLRPFM
     C**************************************************************************

