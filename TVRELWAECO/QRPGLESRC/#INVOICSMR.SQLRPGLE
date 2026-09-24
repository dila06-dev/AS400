     h option(*SRCSTMT:*NoDebugIO)
     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*           telnet     '10.35.12.2'                        *
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
     f$STOMO$6L if   e           k disk
     f$ANACF00F if   e           k disk

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
     c                             week        < 8
     c                   if        status = '  '
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *LIKE         DEFINE    RKFIRM        §§RKFIRM
     C     *LIKE         DEFINE    S§DAFA        §§S§DAFA
     C     *LIKE         DEFINE    S§NUFA        §§S§NUFA
     C                   if        §§RKFIRM   = *blank  and
     C                             §§S§DAFA   = 0       and
     C                             §§S§NUFA   = 0
     C                   eval      §§RKFIRM   = RKFIRM
     C                   eval      §§S§DAFA   = S§DAFA
     C                   eval      §§S§NUFA   = S§NUFA
     c                   seton                                        64
     c                   setoff                                       63
     C                   endif

     C                   if        §§RKFIRM   = RKFIRM  and
     C                             §§S§DAFA   = S§DAFA  and
     C                             §§S§NUFA   = S§NUFA
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
     Clr 64              eval      RKFIRM     = §§RKFIRM
     Clr 64              eval      S§DAFA     = §§S§DAFA
     Clr 64              eval      S§NUFA     = §§S§NUFA
     Clr 64              z-add     18            doclength         2 0
     Clr 64              exsr      srcommand
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
     c                   kfld                    S§NUFA
     c                   kfld                    S§DAFA
     C*
      * :Rechnungspositionen -2-
     C     keysr_afrk    SETLL     $STOMO$6L                          95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      $STOMO$6L                              95
     C                   IF        *in95 = '1'            or
     C                             S§DAFA   <>  §§S§DAFA  or
     C                             S§NUFA   <>  §§S§NUFA
     C                   leave
     C                   else
     c                   exsr      sr_002
     c                   endif
     c                   enddo
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
     C*
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     c                   movel     '0'           typProd           1
     C                   eval      unique_inv = unique_inv + 1
     C                   move      unique_inv    #unique_f        18
     C                   movel     'M'           Paym              1
     C                   movel     S§COAR        #ALTENR          12
     C*
     c
     c                   movel     '1900'        mwst              4
     c
     c                   movel     '0000'        weight            4
     c                   z-add     S§QTMO        menge             5 0
     c                   clear                   unitpnetto        9 2
     c                   clear                   poswertn          9 2
     c                   if        menge < 0
     c                   eval      menge = menge * -1
     c                   endif
     c                   z-add     S§PEFE        lpreis            9 2
     c                   eval      poswertn = S§PEFE*S§QTMO
     c                   eval      unitpnetto = S§PEFE
     c
     C                   clear                   #unique_fr       18
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             'WAEGER'                      +
     c                             '   '                         +
     c                             'WAE'                         +
     c                             '          '                  +
     c                             '      '                      +
     c                             'EUR'                         +
     c                             #unique_f                     +
     c                             #unique_fR
     c                   write     phy02r
     c
      * :===>          -initialisierung aller KÖPFE
      * :===>          -open
     c  n63              exsr      sr9500
     c  n63              exsr      sr9800
     c                   seton                                        63
     C                   movel     keys          INVOICEID
     c****               eval      INVOICELIN  = %char(S§RIGA)
     c                   eval      INVOICELIN  = %subst(S§COAR:01:15)
     c                   eval      DESCRIPTIO  = S§DEAR
     c                   eval      INVOIC8     = 'Invoiced Quantity  '
     c                   eval      QUANTITY    = menge
     c                   eval      UNITPRICE_  = S§ZONA
     c                   eval      AMOUNT      = 1
     c                   eval      UNITCODE    = 'ST'
     c                   eval      PERQUANTIT  = unitpnetto
     c                   eval      amountrab   = *zero
     c                   eval      INVOIC9     = S§ZONA
     c                   eval      TOTALAMOUN  = poswertn
     c                   z-add     poswertn      TOTALAMOUN
     c                   eval      TAXRATE     = 0,00
     c                   eval      TAXAMOUNT   = 0
     c***                eval      ORDERREF    = %subst(S§COAR:01:15)+
     c                   eval      ORDERREF    = %char(S§RIGA)
     c***
     c                   eval      POREF       = S§NUDO
     c                   eval      SHPREF      = S§NORM
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
     C*Funktion Aufbereitung der Inhalte hier clearing  Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr9500        BEGSR
     C*
     C
     C                   clear                   keys             30
     C                   clear                   protokoll
     C                   clear                   id_id
     C                   clear                   TOTALAMOUN
     C                   clear                   TAX_CURREN
     C                   clear                   BASISAMOUN
     C                   clear                   RATENUMERI
     C                   clear                   PROCESSINV
     C                   clear                   TAX_AMOUNT
     C*
     C                   clear                   INVOICEID
     C                   clear                   WAECONR           6
     C*
     c/exec sql
     4+ SELECT sum(S§PEFE*S§QTMO) into :TOTALAMOUN
     4+        FROM $STOMO$6l
     4+        WHERE S§NUFA = :S§NUFA
     c/end-exec
     C*
     C*
     C                   clear                   kunde             6
     C                   movel     S§COCF        kunde
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
     C                   if               rkfirm='01' or rkfirm= '98'
     C                   eval             WAECONR  =  '000000'
     C                   if               rkfirm='98'
     C                   eval             keys     =  RECEIVER_L + '_' +
     C                                                LOGICALID  + '_' +
     C                                %subst(%char(S§DAFA):1:4)  +
     C                                           %char(S§NUFA)
     C                   endif
     C

     C                   eval             protokoll=   RKFIRM    +
     C                                %subst(%char(S§DAFA):1:4)  +
     C                                           %char(S§NUFA)   + ' ' +
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
     C                   movel     keys          INVOICEID

     C                   eval      TOTALAMOUN = TOTALAMOUN
     C                   eval      AMOUNT     = TOTALAMOUN
     C                   movel     S§ZONA        TAX_CURREN
     C                   movel     S§ZONA        TAXAUTHORI
     C                   movel     S§ZONA        AMOUNT_CUR
     C                   eval      BASISAMOUN = TOTALAMOUN
     C                   eval      TAXAUT7=
     C                             (1*0,0               )*1
     C                   eval      TAX_AMOUNT=
     C                             (1*0,0               )*1
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
     C                   clear                   kunde             6
     C                   movel     S§COCF        kunde
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
     C                   eval      CREATIONDA    =
     C                             %subst(%char(tstampi):01:10)  +  'T' +
     C                             %subst(%char(tstampi):12:02)  + ':'  +
     C                             %subst(%char(tstampi):15:02)  + ':'  +
     C                             %subst(%char(tstampi):18:02)
     C                   clear                   PROCESS
     C                   movel     'Invoice'     TYPE
     C                   clear                   GXSTYPE
     C                   eval       GXSTYPE ='Duplication Reason'
     C                   clear                   GXSDESC
     C                   movel     keys          GXSDESC
     C                   clear                   id
     C                   movel     keys          id
     C                   clear                   DOCUMENTDA
     C                   movel     S§DAFA        #rkjdat           8
     C                   clear                   #rkjzei           6
     C                   eval      DOCUMENTDA    =
     C                             %subst(    (#RKJDAT):01:04) +  '-' +
     C                             %subst(    (#RKJDAT):05:02) +  '-' +
     C                             %subst(    (#RKJDAT):07:02) +  'T' +
     C                             %subst(%char(tstampi):12:02) + ':'  +
     C                             %subst(%char(tstampi):15:02) + ':'  +
     C                             %subst(%char(tstampi):18:02)
     C                   clear                   CURRENCYID
     C                   movel     S§ZONA        CURRENCYID
     C                   eval      TOTALAMOUN =  TOTALAMOUN
     C                   clear                   QUALIFIEDA
     C                   movel     S§ZONA        QUALIFIEDA
     C                   eval      AMOUNT     =  TOTALAMOUN
     C                   clear                   CHARGETYPE
     C                   clear                   CHARGEAMT
     C                   clear                   CHARGEDATE
     C                   clear                   #HARGEDATE       10
     C                   eval      CHARGEDATE    =
     C                             %subst( (#HARGEDATE):01:10) +
     C                                                 'T00:00:00'
     C                   clear                   Name
     C*
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
     4+ select substr("CityName", 1, 40)           into :CITYNAME
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "CityName"                 is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
     C                   clear                   COUNTRYCOD
     c/exec sql
     4+ select substr("CountryCode", 1, 40)        into :COUNTRYCOD
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "CountryCode"              is not null  and
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
     C                   clear                   CUSTOMID
     C
     C                   clear                   CUSTOMERPA
     C                   clear                   CUSTOMID
     C                   clear                   CUSTOMSTR
     C                   clear                   CUSTOMLIN1
     C                   clear                   CUSTOMNAME
     C                   clear                   CUSTOMCOUN
     C                   clear                   CUSTOMPLZ
     c/exec sql
     C+ select A$RAGS, A$INDI, A$LOCA, A$LIST, A$CAVP into
     C+        :CUSTOMERPA,
     C+        :CUSTOMSTR,
     C+        :CUSTOMNAME,
     C+        :CUSTOMCOUN,
     C+        :CUSTOMPLZ
     C+ from $ANACF00F where A$COCF = :S§COCF
     c/end-exec
     C*
     C                   clear                   kunde             6
     C                   movel     S§COCF        kunde
     C                   clear                   CUSTOMID
     c/exec sql
     4+ select substr("LogicalID", 1, 6) into :CUSTOMID
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
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
     c*/end-exec
     C                   clear                   CUSTOMPLZ
     c/exec sql
     4+ select substr("PostalCode", 1, 40)         into :CUSTOMPLZ
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "PostalCode"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
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
     c*    keysr_afad    klist
     c*                  kfld                    RKFIRM
     c*                  kfld                    RPAFJJ
     c*                  kfld                    RPAFNR
     c*                  kfld                    adposi
     c*                  kfld                    adaart
     c*                  clear                   adposi
     c*                  movel     'ADVS'        adaart
      *
     c*    keysr_afad    chain     afad01                             89
     c*  89              clear                   afad1
     c*  89              movel     'ADAG'        adaart
     c*  89keysr_afad    chain     afad01                             89
     c*  89              clear                   afad1

     c                   movel     Name          SHIPFRNAME
     c                   movel     STREETNAME    SHIPFRSTR
     c                   movel     CITYNAME      SHIPFRCITY
     c                   movel     COUNTRYCOD    SHIPFRCOUN
     c                   movel     POSTALCODE    SHIPFRPLZ

     c*                  movel     ADNAM1        SHIPTONAME
     c*                  clear                   SHIPTOID
     c*                  movel     ADSTRA        SHIPTOSTR
     c*                  clear                   SHIPTOLIN1
     c*                  movel     ADWORT        SHIPTOCITY
     c*                  clear                   SHIPTOCOUN
     c*                  movel     ADPOLN        SHIPTOPLZ
     C
     C                   clear                   type
     C                   Movel     'Invoice'     type
     C                   clear                   type6
     C*2014.05.19*       Movel     'EU'          type6
     C                   Movel     'VAT'         type6
     C                   clear                   TAX_CURREN
     C                   movel     S§ZONA        TAX_CURREN
     C                   eval      BASISAMOUN =  TOTALAMOUN
     C                   clear                   RATENUMERI
     C                   clear                   PROCESSINV
     C                   eval      PROCESSINV ='Tax free intra-community '+
     C                                         'supply according to '     +
     C                                         '§4 and §6a of value '
     C                   clear                   TAXAUTHORI
     C                   movel     S§ZONA        TAXAUTHORI
     C                   clear                   TAXAUT7
     C                   clear                   AMOUNT_CUR
     C                   movel     S§ZONA        AMOUNT_CUR
     C                   clear                   TAX_AMOUNT
     C                   clear                   TAXABLECCY
     C                   movel     S§ZONA        TAXABLECCY
     C                   clear                   TAXABLEAMN
     C
     C                   clear                   discount
     c****/exec sql
     c****+ select  RPERG1+RPERG2+RPERG3+RPERG4      into :discount
     c****+            from  afrp01
     c****+            where RPFIRM = :RKFIRM  and
     C****+                  RPRGJJ = :RKRGJJ  and
     C****+                  RPRGNR = :RKRGNR
     c****/end-exec
     C
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
     C/COPY ##CLRPFM                                       ##CLRPFM
     C**************************************************************************

