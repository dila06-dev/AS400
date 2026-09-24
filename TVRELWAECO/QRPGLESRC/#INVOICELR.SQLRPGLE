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
     F* select case
     F*       when CHARGEDATE <> '0000.00.00T00:00:00' then
     F*       (substr(char
     F*       (date(substr(char(CHARGEDATE), 1, 4) concat '-' concat
     F*       substr(char(CHARGEDATE), 6, 2) concat '-' concat
     F*       substr(char(CHARGEDATE), 9, 2)) + 0000 days, iso), 1, 10))
     F*       ELSE  (substr(char(current date, iso), 1, 10))
     F*       end
     F*       FROM EINVOICE/INVOICEhe$
     F*       where id        =   'DE411 _DE111A_20145648667001'
     F*
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  changes                                                 *
     F*  mg001 15.05.2015  M.Gang                                *
     F*        using different references                        *
     F*                                                          *
     F*                                                          *
     F*de411-2014123456                                          *
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
     f$PAVWUMSKLif   e           k disk
     f$PAVWUMSPLif   e           k disk
     fPKUNADR   if   e           k disk    RENAME(PKUNADR :#PKUNADR)
     fPKUNSTA   if   e           k disk    RENAME(PKUNSTA :#PKUNSTA)
     fpartsta   if   e           k disk    RENAME(partsta :#partsta)

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
     I*-------------------------------------------------------------------------
     I#partsta
     I              FILLER                      #FILLER
     I
     I*-------------aus--#CT0501------------------------------------------------
     I#PKUNSTA
     I              FILLER                      #FILLER2
     I
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    company           2
     C                   PARM                    returnc          30
     C*-------------------------------------------------------------------------

     c  n22              eval      keys  = 'no match found'
     c                   seton                                        22
     c                   clear                   rkfirm            2
     c                   if        company =  '15'
     c                   movel     '15'          rkfirm
     c                   endif
     c                   if        company =  '03'
     c                   movel     '03'          rkfirm
     c                   endif
     C*                  select
     C*                  when
     C*                            AVKKDNR = 3030208
     C*                  eval      rkfirm  = '03'
     C*                  when      AVKKDNR = 3030000
     C*                  eval      rkfirm  = '05'
     C*                  when      AVKKDNR = 3030208
     C*                  eval      rkfirm  = '04'
     C*                  when      AVKKDNR = 0750865
     C*                  eval      rkfirm  = '07'
     C*                  when      AVKKDNR = 2151617
     C*                  eval      rkfirm  = '08'
     C*                  when      AVKKDNR = 0020778
     C*                  eval      rkfirm  = '11'
     C*                  when      AVKKDNR = 3040777
     C*                  eval      rkfirm  = '15'
     c*                  other
     c*                  endsl
     c                   move      RENRAUFTL     bulkinv           3
     c                   if        company     =      rkfirm and
     c                             week        < 8
     c****all*********             (rkfirm = '03' and AVKKDNR = 3020027 or
     c****all*********             (rkfirm = '03' and AVKKDNR = 3030075 or
     c****all*********             (rkfirm = '03' and AVKKDNR = 3030208 or
     c****all*********              rkfirm = '04' and AVKKDNR = 3030208 or
     c****all*********              rkfirm = '05' and AVKKDNR = 3030000 or
     c****all*********              rkfirm = '07' and AVKKDNR = 0750865 or
     c****all*********              rkfirm = '08' and AVKKDNR = 2151617 or
     c****all*********              rkfirm = '11' and AVKKDNR = 0020778 or
     c****all*********              rkfirm = '15' and AVKKDNR = 3040777 )
     c                   if        RENRAUFTL=5652530002
     c                   clear                   hdh               1
     c                   endif
     c                   if        status = '  '
     c******                         and  bulkinv ='001'
     c                             or
     c                             ((RENRAUFTL=5650102003 and status=' ')
     c                                  or
     c                              (RENRAUFTL=5650102003 and status=' '))
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *LIKE         DEFINE    AVKFA         §§AVKFA
     C     *LIKE         DEFINE    AVKFAKJ       §§AVKFAKJ
     C     *LIKE         DEFINE    RENRAUFTL     §RENRAUFTL
     C                   if        §§AVKFA    = 0       and
     C                             §§AVKFAKJ  = 0       and
     C                             §RENRAUFTL = 0
     C                   eval      §§AVKFA    = AVKFA
     C                   eval      §§AVKFAKJ  = AVKFAKJ
     C                   eval      §RENRAUFTL = RENRAUFTL
     c                   seton                                        64
     c                   setoff                                       63
     C                   endif

     C                   if        §§AVKFA    = AVKFA   and
     C                             §§AVKFAKJ  = AVKFAKJ and
     C                             §RENRAUFTL = RENRAUFTL
     C     *DTAARA       DEFINE                  $invoices        10 0
     C  n25*lock         IN        $invoices
     C  n25              eval      $invoices  =  $invoices   + 1
     C                   if        *in22      = '1'
     C  n25              out       $invoices
     C                   endif
     C  n25              exsr      sr_001
     c                   seton                                        25
     c                   exsr      sr1000
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
     Clr 64              eval      AVKFA      = §§AVKFA
     Clr 64              eval      AVKFAKJ    = §§AVKFAKJ
     Clr 64              eval      RENRAUFTL  = §RENRAUFTL
     Clr 64              z-add     25            doclength         2 0
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
     c                   kfld                    AVKFA
     c                   kfld                    avkfakj
     c                   kfld                    AVKRENR
     c*******            kfld                    AVKAUFTL
     c*******            kfld                    avkaufn
     c
     c     nachl_afrk    klist
     c                   kfld                    AVKFA
     c                   kfld                    avkfakj
     c                   kfld                    AVKRENR
     c                   kfld                    AVKAUFTL
     c                   kfld                    avkaufn
     c
     C                   eval      AVKRENR=§RENRAUFTL/1000
     C                   move      §RENRAUFTL    AVKAUFTL
     c
     C*
      * :Rechnungskopf  -1-
     c     keysr_afrk    chain     $PAVWUMSKL                         92
     C*
      * :Rechnungspositionen -2-
     c                   if        *in92 = '0'
     C     keysr_afrk    SETLL     $PAVWUMSPL                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      $PAVWUMSPL                             95
     C                   IF        *in95 = '1'            or
     C                             AVKFA    <>  AVpFA     or
     C                             avkfakj  <>  avpfakj   or
     C                             AVKRENR  <>  AVpRENR
     C*******  raus 2.10.2015 nach Tests
     C*******  Achtung             AVKAUFTL <>  AVpAUFTL  or
     C*******  Achtung             avkaufn  <>  avpaufn
     C                   leave
     C                   else
     c                   if        AVKMWKZ     = 'J' and
     c                             #position   = 0
     c                   clear                   #position         4 0
     c                   clear                   xp                4 0
     c                   clear                   #mwst            13 2
     c/exec sql
     C+ select count(*)                                into :#position
     C+            from  $PAVWUMSp
     C+            where AVpFA   = :AVkFA     and
     C+                  avpfakj = :avkfakj   and
     C+                  AVpRENR = :AVKRENR   and
     C+                  AVpAUFTL= :AVPAUFTL
     c/end-exec
     C                   endif
     C*
     C*******  Achtung
     C                   if        AVKAUFTL <>  AVpAUFTL  or
     C                             avkaufn  <>  avpaufn
     C                   eval      AVkAUFTL =   AVpAUFTL
     C                   eval      avkaufn  =   avpaufn
     c     nachl_afrk    chain     $PAVWUMSKL                         96
     c   96              clear                   AVKWAEH
     c   96              clear                   AVKAUFN
     c   96              clear                   AVKBSZE
     c   96              clear                   AVKMWSA
     c   96              clear                   AVKMWER
     c   96              clear                   AVKMWKZ
     c   96              clear                   #position
     c                   if        AVKMWKZ     = 'J'
     c                   clear                   #position         4 0
     c                   clear                   xp                4 0
     c                   clear                   #mwst            13 2
     c/exec sql
     C+ select count(*)                                into :#position
     C+            from  $PAVWUMSp
     C+            where AVPFA   = :AVKFA     and
     C+                  avPfakj = :avkfakj   and
     C+                  AVPRENR = :AVKRENR   and
     C+                  AVPAUFTL= :AVPAUFTL
     c/end-exec
     C                   endif
     C*
     C                   endif
     C*******  Achtung
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
     c***%%keysr_aflp    klist
     c***%%              kfld                    RKFIRM
     c***%%              kfld                    RKRGJJ
     c***%%              kfld                    RKRGNR
     c***%%              kfld                    RKLIJJ
     c***%%              kfld                    RKLINR
     c***%%              kfld                    Rplipo
     c***%%keysr_aflp    chain     #aflpl1                            96
     c** 96              clear                   aflp1
     C*
      * :Kopfdaten Auftrag
     c***%%keysr_afko    klist
     c***%%              kfld                    RKFIRM
     c***%%              kfld                    RPAFJJ
     c***%%              kfld                    RPAFNR

     c***%%keysr_afko    chain     afko01                             96
     c** 96              clear                   afko1
     C*
     C*
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     c                   movel     '0'           typProd           1
     C                   eval      unique_inv = unique_inv + 1
     C                   move      unique_inv    #unique_f        18
     C                   movel     'M'           Paym              1
     C                   move      AVPARTN       #ALTENR          12
     C*
     C*
     c                   eval      typRecord = 'B'
     c                   if        AVKAUKK   = 'G'
     c                   movel     'D'           typRecord         1
     c                   endif
     c
     c                   clear                   mwst              4
     c                   if        AVKMWKZ = 'J'
     c                   movel     AVKMWSA       mwst              4
     c                   endif
     c
     c                   movel     '0000'        weight            4
     c                   z-add     AVPFAMG       menge             9 2
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   move      menge         #menge            9
     c     *LIKE         DEFINE    AVPPREI       #AVPPREI
     c                   eval      #AVPPREI    = AVPPREI
     c                   eval      amount      = #AVPPREI
     c                   select
     c                   when      AVPPREH   = 1
     c                   eval      AVPPREI  = AVPPREI / 10
     c                   when      AVPPREH   = 2
     c                   eval      AVPPREI  = AVPPREI / 100
     c                   when      AVPPREH   = 3
     c                   eval      AVPPREI  = AVPPREI / 1000
     c                   other
     c                   eval      AVPPREI  = AVPPREI
     c                   endsl
     c                   z-add     AVPPREI       lpreis            9 2
     c                   move      lpreis        #lpreis           9
     c* wegen Einlagerungskosten, daher Nettowert aus Lieferschein
     c* 21.02.2012
     c                   clear                   poswertn         11 2
     c                   z-add     AVPPNWE       poswertn
     c                   if        AVKWAEH  <> 'EUR'
     c                   z-add     avpwpnw       poswertn
     c                   endif
     c***                eval      poswertn=AVPFAMG*AVPPREI
     c                   if        poswertn   < 0
     c                   eval      poswertn=poswertn   * -1
     c                   endif
     c                   move      poswertn      #poswertn        11
 MG01c                   movel     'N'           indicator         1
 MG01c                   if        poswertn = 0
 MG01c                   movel     'Y'           indicator         1
 MG01c                   endif
     c                   clear                   unitpnetto       12 5
     c                   eval(r)   unitpnetto = AVPPREI
     c                   select
     c                   when      AVPPREH   = 1
     c                   eval(r)   unitpnetto=unitpnetto*10
     c                   when      AVPPREH   = 2
     c                   eval(r)   unitpnetto=unitpnetto*100
     c                   when      AVPPREH   = 3
     c                   eval      unitpnetto=unitpnetto*1000
     c                   other
     c                   eval(r)   unitpnetto=unitpnetto*1
     c                   endsl
     c***                if        menge < 0
     c***                eval      unitpnetto = (poswertn/AVPFAMG)
     c***                endif
     c                   if        unitpnetto < 0
     c                   eval      unitpnetto = unitpnetto * -1
     c                   endif
     c                   move      unitpnetto    #unitpnetto       9
     c                   movel     ' '           CreditInit        1
     c                   if        AVKAUKK   = 'G'
     c                   movel     'C'           CreditInit        1
     c*                  CreditInit = ' '  bei gutschrift 'C'
     c                   endif
     c                   clear                   filler01         50
     c                   clear                   kiaHyundai       10
     c
     c                   exsr      sr4900
     c                   exsr      sr5000
     c
     C                   clear                   #unique_fr       18
     c                   if        typRecord = 'C'
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
     C                   endif
     C                   move      wert          #unique_fr       18
     c                   if        wert = '0000000000' or
     c                             wert = '          '
     c                   endif
     c                   clear                   unique_fr        10
     c                   clear                   unique_ref       13
     c***                Korrektur auf 'D', wenn keine C-Referenz
     c
     C                   eval      rkreda=AVKFAKT+(AVKFAKM*100)+
     C                                            (AVKFAKJ*10000)
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             typRecord                     +
     c                             'WAEGER'                      +
     c                             Paym                          +
     c                             typProd                       +
     c                             %char(avplinr)                +
     c                             %char(AVPAAPN)                +
     c                             %char(AVPLIEJ)                +
     c                             %char(AVPLIEM)                +
     c                             %char(AVPLIET)                +
     c                             %char(AVKRENR)                +
     c                             '   '                         +
     c                             %char(rkreda)                 +
     c* 15.03.2012                                               +
     c                             %subst(      #ALTENR:01:12)   +
     c                             'WAE'                         +
     c                             artbe1                        +
     c                             '          '                  +
     c                             weight                        +
     c                             #menge                        +
     c                             'EUR'                         +
     c                             #lpreis                       +
     c                             mwst                          +
     c                             #poswertn                     +
 MG01c                             indicator                     +
     c                             avkbsze                       +
     c                             avkbsnr                       +
     c                             #unitpnetto                   +
     c                             CreditInit                    +
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
     c                   eval      amount      = #AVPPREI
     c                   seton                                        63
     C                   movel     keys          INVOICEID
     C                   clear                   INVOICEID
     C                   movel     keys2         INVOICEID
     c                   movel     AVPARTN       INVOICELIN
     c                   if        konartnum  <> 0
     c                   movel     konartnum     INVOICELIN
     c                   else
     c                   if        modnum     <> '     '
     c                   movel     modnum        INVOICELIN
     c                   endif
     c                   endif
     c                   eval      DESCRIPTIO  = artbe1
     c                   eval      INVOIC8     = 'Invoiced Quantity  '
     c                   eval      QUANTITY    = menge
     c                   select
     c                   when      AVPPREH   = 1
     c                   eval      PERQUANTIT  = 10
     c                   when      AVPPREH   = 2
     c                   eval      PERQUANTIT  = 100
     c                   when      AVPPREH   = 3
     c                   eval      PERQUANTIT  = 1000
     c                   other
     c                   eval      PERQUANTIT  = 1
     c                   endsl
     c                   eval      UNITPRICE_  = AVKWAEH
     c                   eval      UNITCODE    = 'ST'
     c**                 eval      amount      = unitpnetto
     c**                 eval      amount      = AVPPREI
     c                   eval      INVOIC9     = AVKWAEH
     c                   eval      TOTALAMOUN  = poswertn
     c                   z-add     poswertn      TOTALAMOUN
     c                   eval      TAXRATE     = 0,00
     c                   eval      TAXAMOUNT   = 0
     c
     c                   if        AVKMWKZ     = 'J'
     c                   eval      xp=xp + 1
     c                   eval      TAXRATE     = AVKMWSA
     c*********          mathematisch genau und dann kaufmännisch grundet
     c*********          AVKMWER = totalsumme nur auf Kopfebene
     c                   if        xp<>#position
     c                   eval(rh)  TAXAMOUNT =  poswertn*AVKMWSA /100
     c                   eval      #mwst=#mwst+TAXAMOUNT
     c                   else
     c                   eval      TAXAMOUNT =  AVKMWER-#mwst
     c                   endif
     c                   endif
     c
     c                   eval      ORDERREF    = %char(AVpAUFN)  + '/' +
     c                                           %char(AVpAUFTL) + '/' +
     c                                           %char(AVpAAPN)
     c****               eval      ORDERREF    = %char(avplinr) +
     c****                                       %char(AVPAAPN)
     c                   eval      shpref      = %char(AVPLINR)
     c                   if        AVPLINR     = 0
     c                   eval      shpref      = %char(AVKAUFN)
     c                   endif
     c                   clear                   amountrab
     c                   eval      amountrab =
     c                             (AVPRABAW + AVPRAB2W+ AVPRAB3W+
     c                              AVPRAB4W + AVPRAB5W+ AVPRAB6W)
     c                   eval      POREF       = AVKBSZE
     c                   if        AVKBSNR = 'EDI:B2B'
     c***                pavpumst
     c                   exsr      SRPOREF
     c                   endif
mg001c                   if        AVKBSNR <>'EDI:B2B'
mg001c                   exsr      SRPOREF2
mg001c                   if        %subst(poref2:01:3)='P.O'  or
mg001c                             %subst(poref2:01:2)='PO'
mg001c                   eval      POREF       = poref2
mg001c                   endif
mg001c                   endif
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
     c*
     C     ##_002        ENDSR
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
     C* sr4900: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr4900        BEGSR
     C*
     c     AVPARTN       chain     PARTSTA                            97
     c   97              clear                   artbe1
     c   97              clear                   konartnum
     c   97              clear                   modnum
     c
     C*
     C     ##4900        ENDSR
     C*
     C**************************************************************************
     C* sr5000: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     keysr5kund    klist
     c                   kfld                    AVKKDNR
     c
     c     keysr5kund    chain     PKUNADR                            97
     c*  97              clear                   AVKKDNR
     c
     C*
     C     ##5000        ENDSR
     C*
     C**************************************************************************
     C* srprof: Daten Referenz bei B2B Geschäft
     C*-------------------------------------------------------------------------
     C*
     C     SRPOREF       BEGSR
     C*
     C                   clear                   poref
     C*
     c/exec sql
     C+ select substr(avtpte1, 24, 40)   into :poref
     C+            from  $PAVWUMST
     C+            where AVTFA   = :AVKFA     and
     C+                  AVTAUFN = :avkaufn   and
     C+                  AVTAUFTL= 1          and
     C+                  AVTAAPN = :AVPAAPN+0,1
     c/end-exec
     C*
     C     ##poref       ENDSR
     C*
     C**************************************************************************
     C* srprof: Daten Referenz bei B2B Geschäft
     C*-------------------------------------------------------------------------
     C*
mg001C     SRPOREF2      BEGSR
mg001C*
mg001C                   clear                   poref2           40
mg001C*
mg001c/exec sql
mg001C+ select substr(avtpte1, 01, 40)   into :poref2
mg001C+            from  $PAVWUMST
mg001C+            where AVTFA   = :AVKFA     and
mg001C+                  AVTAUFN = :avkaufn   and
mg001C+                  AVTAUFTL= 1          and
mg001C+                  AVTAAPN = :AVPAAPN+0,1
mg001c/end-exec
     C*
     C     ##poref2      ENDSR
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
     C                   clear                   #avknwer         1304
     C                   clear                   #avknwerw        1304
     C                   clear                   #AVKMWER         1304
     C*
     C                   clear                   INVOICEID
     C                   clear                   WAECONR           6
     C*
     c*             Werte ermittlen in Abhängigkeit der Währung
     c*             keine gemischten Formen  (?) eigentlich mit case?
     c/exec sql
     C+ select sum(avknwer+AVKVSKO+AVKVPKO+AVKVIKO+AVKMWER)
     C+                                               into :#avknwer
     C+            from  $PAVWUMSk
     C+            where AVKFA   = :AVKFA     and
     C+                  avkfakj = :avkfakj   and
     C+                  AVKRENR = :AVKRENR   and
     C+                  AVKWAEH = 'EUR'
     c/end-exec
     C*
     c/exec sql
     C+ select sum(avknwerw+AVKVSKO+AVKVPKO+AVKVIKO+AVKMWER)
     C+                                                into :#avknwerw
     C+            from  $PAVWUMSk
     C+            where AVKFA   = :AVKFA     and
     C+                  avkfakj = :avkfakj   and
     C+                  AVKRENR = :AVKRENR   and
     C+                  AVKWAEH <> 'EUR'
     c/end-exec
     C*
     C                   if        #avknwer =  0
     C                   z-add     #avknwerw     #avknwer
     C                   endif
     C*
     C*
     C*
     c/exec sql
     C+ select sum(AVKMWER)                            into :#AVKMWER
     C+            from  $PAVWUMSk
     C+            where AVKFA   = :AVKFA     and
     C+                  avkfakj = :avkfakj   and
     C+                  AVKRENR = :AVKRENR
     c/end-exec
     C*
     C*
     C                   clear                   kunde             7
     C                   move      AVKKDNR       kunde
     C                   clear                   RECEIVER_L
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :RECEIVER_L
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"                is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C*
     C                   clear                   LOGICALID
     c/exec sql
     C+ select distinct substr("LogicalID", 1, 6) into :LOGICALID
     C+            from einvoice/idnumbers
     C+            where WAECONR = '000000'   and
     C+            "LogicalID"                is not null     and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C*
     C                   if               AVKFA  = 01  or AVKFA = 15
     C                   eval             WAECONR  =  '000000'
     C                   clear                   rkreda            8 0
     C                   eval      rkreda=AVKFAKT+(AVKFAKM*100)+
     C                                            (AVKFAKJ*10000)
     C
     C*****              if               rkfirm='03'
     C                   eval             keys     =  RECEIVER_L + '_' +
     C                                                LOGICALID  + '_' +
     C                                           %char(AVKFAKJ)        +
     C                                    %subst(%char(RENRAUFTL):01:7)
     C                   eval             keys2    =
     C                                           %char(AVKFAKJ)  +
     C                                    %subst(%char(RENRAUFTL):01:7)
     C                   endif
     C

     C                   eval        protokoll=  %char(AVKFA)     +
     C                                           %char(AVKFAKJ)   +
     C                                           %char(RENRAUFTL) + ' ' +
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
     C                   movel     protokoll     #protokoll      128
     C                   movel     keys          id_id
     C                   clear                   id_id
     C                   movel     keys2         id_id
     C                   movel     keys          INVOICEID
     C                   clear                   INVOICEID
     C                   movel     keys2         INVOICEID

     C                   eval      TOTALAMOUN = #avknwer*1
     C                   eval      AMOUNT     = #avknwer*1
     C                   movel     AVKWAEH       TAX_CURREN
     C                   movel     AVKWAEH       TAXAUTHORI
     C                   movel     AVKWAEH       AMOUNT_CUR
     C                   eval      BASISAMOUN = #avknwer
     C                   eval      TAXAUT7=
     C                             (#AVKMWER             )*1
     C                   eval      TAX_AMOUNT=
     C                             (#AVKMWER             )*1
     C                   clear                   PROCESSINV
     C*******            endif


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
     C*
     C*Ausgabe INVOICEHEA - 3 -     ''''''''''''''''''''''''''''''''''
     c/exec sql
     C+ update einvoice/INVOICEHEA
     C+ set LOGICALID = :id_id,
     C+     RECEIVER_L= '     '
     c/end-exec
     C*
     C                   clear                   kunde             7
     C                   move      AVKKDNR       kunde
     C                   clear                   RECEIVER_L
     c/exec sql
     C+ select distinct substr("LogicalID", 1, 6) into :RECEIVER_L
     C+            from einvoice/idnumbers
     C+            where WAECONR = :kunde     and
     C+            "LogicalID"                is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   LOGICALID
     c/exec sql
     C+ select distinct substr("LogicalID", 1, 6) into :LOGICALID
     C+            from einvoice/idnumbers
     C+            where WAECONR = :WAECONR   and
     C+            "LogicalID"                is not null     and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   CREATIONDA
     C                   movel     AVKFAKJ       #AVKFAKJ
     C                   movel     AVKFAKM       #AVKFAKM
     C                   movel     AVKFAKT       #AVKFAKT
     C                   eval      CREATIONDA    =
     C                             %subst(      #AVKFAKJ:01:04) +  '-' +
     C                             %subst(      #AVKFAKM:01:02) +  '-' +
     C                             %subst(      #AVKFAKT:01:02) +  'T' +
     C                                                            '00:00:00'
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
     C*******            movel     rkjdat        #rkjzei           6
     C                   movel     AVKFAKJ       #AVKFAKJ          4
     C                   movel     AVKFAKM       #AVKFAKM          2
     C                   movel     AVKFAKT       #AVKFAKT          2
     C                   eval      DOCUMENTDA    =
     C                             %subst(      #AVKFAKJ:01:04) +  '-' +
     C                             %subst(      #AVKFAKM:01:02) +  '-' +
     C                             %subst(      #AVKFAKT:01:02) +  'T' +
     C                                                            '00:00:00'
     C*******                      %subst(%char(#RKJZEI):01:02) +  ':' +
     C*******                      %subst(%char(#RKJZEI):03:02) +  ':' +
     C*******                      %subst(%char(#RKJZEI):05:02)
     C                   clear                   CURRENCYID
     C                   movel     AVKWAEH       CURRENCYID
     C                   eval      TOTALAMOUN = #avknwer
     C                   clear                   QUALIFIEDA
     C                   movel     AVKWAEH       QUALIFIEDA
     C                   eval      AMOUNT     = #avknwer
     C                   clear                   CHARGETYPE
     C                   clear                   CHARGEAMT
     C                   clear                   CHARGEDATE
     C                   clear                   #HARGEDATE        8
     C                   move      avknetd       #HARGEDATE        8
     c     ' ':'0'       xlate     #HARGEDATE    #HARGEDATE
     C                   eval      CHARGEDATE =  %subst(#HARGEDATE:05:04) +
     C                                           '.'                       +
     C                                           %subst(#HARGEDATE:03:02) +
     C                                           '.'                       +
     C                                           %subst(#HARGEDATE:01:02) +
     C                                                  'T00:00:00'
     C                   clear                   name
     C                   move      AVKDRUD       #AVKDRUD          8
     C     ' ':'0'       xlate     #AVKDRUD      #AVKDRUD          8
     C                   move      avknetd       #avknetd          8
     C     ' ':'0'       xlate     #avknetd      #avknetd          8
     C                   clear                   CHARGEDATE
     C
     c/exec sql
     4+ select case
     4+    when :#avknetd   <> '00000000' then
     4+         (substr(char(date(substr(char(:#avknetd), 5, 4)
     4+          concat '-' concat
     4+          substr(char(:#avknetd), 3, 2)
     4+          concat '-' concat
     4+          substr(char(:#avknetd), 1, 2)) +
     4+               0       days, iso), 1, 10))
     4+               concat 'T00:00:00'
     4*+   ELSE  (substr(char(current date, iso), 1, 10))
     4+    else  (substr(char(date(substr(char(:#AVKDRUD), 5, 4)
     4+           concat '-' concat
     4+           substr(char(:#AVKDRUD), 3, 2)
     4+           concat '-' concat
     4+           substr(char(:#AVKDRUD), 1, 2)) +
     4+               :AVKNETT days, iso), 1, 10))
     4+               concat 'T00:00:00'
     4+    end
     4+    into :CHARGEDATE
     4+    from qsys2/qsqptabl
     c/end-exec
     C*
     C                   clear                   name
     c/exec sql
     4+ select distinct substr("Name", 1, 40)               into :NAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "Name"                is not null       and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   SUPPLIERPA
     c/exec sql
     4+ select distinct substr("LegalEntityUniqueID", 1, 6) into :SUPPLIERPA
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "LegalEntityUniqueID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   STREETNAME
     c/exec sql
     4+ select distinct substr("StreetName", 1, 40)         into :STREETNAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "StreetName"               is not null     and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CITYNAME
     c/exec sql
     4+ select distinct substr("CityName", 1, 40)           into :CITYNAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "CityName"                 is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   COUNTRYCOD
     c/exec sql
     4+ select distinct substr("CountryCode", 1, 40)        into :COUNTRYCOD
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "CountryCode"              is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   POSTALCODE
     c/exec sql
     4+ select distinct substr("PostalCode", 1, 40)         into :POSTALCODE
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
     C                   move      AVKKDNR       kunde
     C
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :CUSTOMID
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   CUSTOMERPA
     c/exec sql
     4+ select distinct substr("Name", 1, 40)         into :CUSTOMERPA
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "Name"                     is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CUSTOMNAME
     c/exec sql
     4+ select distinct substr("CityName", 1, 40)         into :CUSTOMNAME
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
     4+ select distinct substr("StreetName", 1, 40)         into :CUSTOMSTR
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "StreetName"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   CUSTOMCOUN
     c/exec sql
     4+ select distinct substr(COUNT00001, 1, 03)           into :CUSTOMCOUN
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            COUNT00001                 is not null and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C*                   clear                   COUNTRYCOD
     c*/exec sql
     4*+ select distinct substr("CountryCode", 1, 40)     into :COUNTRYCOD
     4*+            from einvoice/idnumbers
     4*+            where WAECONR = :kunde     and
     4*+            "CountryCode"              is not null  and
     C*+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C*+            COMPA00001 is not null
     c*****/end-exec
     C                   clear                   CUSTOMPLZ
     c/exec sql
     4+ select distinct substr("PostalCode", 1, 40)         into :CUSTOMPLZ
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "PostalCode"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C                   clear                   BILLTOCITY
     c/exec sql
     c+ select distinct substr("CityName", 1, 40)         into :BILLTOCITY
     c+            from einvoice/idnumbers
     c+            where WAECONR = :kunde     and
     c+            "Company"                  is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
      * :Lieferadresse/Adresse bill


     c                   movel     Name          SHIPFRNAME
     c                   movel     STREETNAME    SHIPFRSTR
     c                   movel     CITYNAME      SHIPFRCITY
     c                   movel     COUNTRYCOD    SHIPFRCOUN
     c                   movel     POSTALCODE    SHIPFRPLZ
     c                   if        AVKVSN1 <> ' ' or
     c                             AVKVSN2 <> ' ' or
     c                             AVKVSN3 <> ' '
     c                   movel     AVKVSN1       SHIPTONAME
     c                   clear                   SHIPTOID
     c                   movel     AVKVSN3       SHIPTOSTR
     c                   clear                   SHIPTOLIN1
     c                   movel     AVKVSOR       SHIPTOCITY
     c                   movel     AVKVSPL       SHIPTOCOUN
     c                   movel     AVKVSLK       SHIPTOPLZ
     C                   else
     c     AVKKDNR       chain     PKUNSTA                            97
     c  n97              movel     VERANSNAM     SHIPTONAME
     c  n97              clear                   SHIPTOID
     c  n97              movel     VERANSSTR     SHIPTOSTR
     c  n97              clear                   SHIPTOLIN1
     c  n97              movel     VERANSORT     SHIPTOCITY
     c  n97              movel     KUNLKZ        SHIPTOCOUN
     C                   movel     VERANSPLZ     SHIPTOPLZ
     C                   endif

     c                   if        SHIPTONAME    = *blank
     c                   eval      SHIPTONAME    = CUSTOMERPA
     c                   eval      SHIPTOSTR     = CUSTOMSTR
     c                   eval      SHIPTOCITY    = BILLTOCITY
     c                   eval      SHIPTOCOUN    = CUSTOMCOUN
     c                   eval      SHIPTOPLZ     = CUSTOMPLZ
     c                   endif

     c                   clear                   pos1              2 0
     c                   clear                   pos2              2 0
     c                   clear                   i                 2 0
     c                   DOU       I >= 10
     c                   move      i             mScan             1
     c                   eval      pos1 = %scan(mScan: SHIPTOCITY)
     c                   if        pos1 > 0  and pos1 < pos2
     c                   z-add     pos1          pos2
     c                   endif
     c                   if        pos2 = 0
     c                   z-add     pos1          pos2
     c                   endif
     C                   eval      i = i + 1
     C                   enddo
     C                   if        pos2 > 0
     C                   eval      SHIPTOCOUN=%subst(SHIPTOCITY:pos2:05)
     C                   eval      %subst(SHIPTOCITY:pos2:05) ='     '
     C                   endif
     C
     C                   clear                   type
     C                   Movel     'Invoice'     type
     C                   clear                   type6
     C*2014.05.19*       Movel     'EU'          type6
     C                   Movel     'VAT'         type6
     C                   clear                   TAX_CURREN
     C                   movel     AVKWAEH       TAX_CURREN
     C                   eval      BASISAMOUN = #avknwer
     C                   clear                   RATENUMERI
     C                   clear                   PROCESSINV
     C                   eval      PROCESSINV ='Tax free intra-community '+
     C                                         'supply according to '     +
     c                                         '§4 and §6a of value '
     C                   clear                   TAXAUTHORI
     C                   movel     AVKWAEH       TAXAUTHORI
     C**********         clear                   TAXAUT7
     C                   clear                   AMOUNT_CUR
     C                   movel     AVKWAEH       AMOUNT_CUR
     C**********         clear                   TAX_AMOUNT
     C                   clear                   TAXABLECCY
     C                   movel     AVKWAEH       TAXABLECCY
     C                   clear                   TAXABLEAMN
     C                   z-add     AVKMWSA       TAXABLEAMN
     C
     C                   clear                   discount
     c/exec sql
     c+ select  AVPRABAW + AVPRAB2W + AVPRAB3W+
     c+         AVPRAB4W + AVPRAB5W + AVPRAB6W      into :discount
     c+            from  EINVOICESI/$PAVWUMSp
     c+            where AVpFA   =  :AVkFA    and
     C+                  avpfakj =  :avkfakj  and
     C**************     AVpRENRL=  :AVkRENR  and
     C+                  AVpAUFTL=  :AVkAUFTL and
     C+                  avpaufn =  :avkaufn
     c/end-exec
     C
     C                   if        AVKAUKK    = 'G'
     C                   movel     'Credit Note' TYPE
     C                   endif
     C                   if        #avknwer   < 0
     C                   movel     'Credit Note' TYPE
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

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'ADDLIBLE LIB(EINVOICESI) POSITION(*BEFORE EINVOICE)';
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
     C                   if        company =  '03'
     C     *DTAARA       DEFINE                  inv03            04
     C                   IN        inv03
     C                   movel     inv03         enviro
     C                   endif
     C
     C                   if        company =  '15'
     C     *DTAARA       DEFINE                  inv15            04
     C                   IN        inv15
     C                   movel     inv15         enviro
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
     C/COPY ##commandt                                     commandt
     C/COPY ##SAVEDATA                                     ##SAVEDATA
     C/COPY ##CLRPFM                                       ##CLRPFM
     C**************************************************************************

