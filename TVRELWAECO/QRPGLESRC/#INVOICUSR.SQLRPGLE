     h option(*SRCSTMT:*NoDebugIO)
     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F* CHGDTAARA DTAARA(UNIQUE_F *ALL) VALUE(300082)            *
     F*              * letzte verwendete aus Datei               *
     F* CHGDTAARA DTAARA($invoices  *ALL) VALUE(1148)            *
     F*              * letzte verwendete aus Datei               *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F* CRTDDMF FILE(EINVOICEUS/EINVHF) RMTFILE(CORPFEVF/EINVHF) *
     F* RMTLOCNAME('10.10.10.6' *IP)                             *
     F*                                                          *
     F* For userid TRANSFER the password is DOMUSA01  in USA     *
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

     fINVOICEHl1if   e           k disk    RENAME(INVOICER :head_ )
     fINVOICEPl1if   e           k disk    RENAME(INVOICER :pos_  )

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

     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------
     I/COPY ##I001
     I*-------------------------------------------------------------------------
     IPHY02R
     I              E_INVOICE                   sentence
     I
     I*-------------------------------------------------------------------------
     Iphy01r
     I              id                          id_
     I
     I*-------------------------------------------------------------------------
     Ihead_
     I              XSI                         XSI_
     I              GXSXTD                      GXSXTD_
     I              XMLNS                       XMLNS_
     I              SCHEMALOCA                  SCHEMALOC_
     I              RELEASEID                   RELEASEID_
     I              LOGICALID                   LOGICALID_
     I              RECEIVER_L                  RECEIVER__
     I              CREATIONDA                  CREATIOND_
     I              PROCESS                     PROCESS_
     I              TYPE                        TYPE_
     I              GXSTYPE                     GXSTYPE_
     I              GXSDESC                     GXSDESC_
     I              ID                          ID_
     I              DOCUMENTDA                  DOCUMENTD_
     I              CURRENCYID                  CURRENCYI_
     I              TOTALAMOUN                  TOTALAMOU_
     I              QUALIFIEDA                  QUALIFIED_
     I              AMOUNT                      AMOUNT_
     I              CHARGETYPE                  CHARGETYP_
     I              CHARGEAMT                   CHARGEAMT_
     I              CHARGEDATE                  CHARGEDAT_
     I              DISCOUNT                    DISCOUNT_
     I              NAME                        NAME_
     I              SUPPLIERPA                  SUPPLIERP_
     I              STREETNAME                  STREETNAM_
     I              CITYNAME                    CITYNAME_
     I              COUNTRYCOD                  COUNTRYCO_
     I              POSTALCODE                  POSTALCOD_
     I              CUSTOMERPA                  CUSTOMERP_
     I              CUSTOMID                    CUSTOMID_
     I              CUSTOMSTR                   CUSTOMSTR_
     I              CUSTOMLIN1                  CUSTOMLIN_
     I              CUSTOMNAME                  CUSTOMNAM_
     I              CUSTOMCOUN                  CUSTOMCOU_
     I              CUSTOMPLZ                   CUSTOMPLZ_
     I              SHIPFRNAME                  SHIPFRNAM_
     I              SHIPFRSTR                   SHIPFRSTR_
     I              SHIPFRCITY                  SHIPFRCIT_
     I              SHIPFRCOUN                  SHIPFRCOU_
     I              SHIPFRPLZ                   SHIPFRPLZ_
     I              SHIPTONAME                  SHIPTONAM_
     I              SHIPTOID                    SHIPTOID_
     I              SHIPTOSTR                   SHIPTOSTR_
     I              SHIPTOLIN1                  SHIPTOLIN_
     I              SHIPTOCITY                  SHIPTOCIT_
     I              SHIPTOCOUN                  SHIPTOCOU_
     I              SHIPTOPLZ                   SHIPTOPLZ_
     I              BILLTONAME                  BILLTONAM_
     I              BILLTOID                    BILLTOID_
     I              BILLTOSTR                   BILLTOSTR_
     I              BILLTOLIN1                  BILLTOLIN_
     I              BILLTOCITY                  BILLTOCIT_
     I              BILLTOCOUN                  BILLTOCOU_
     I              BILLTOPLZ                   BILLTOPLZ_
     I              TYPE6                       TYPE6_
     I              TAX_CURREN                  TAX_CURRE_
     I              BASISAMOUN                  BASISAMOU_
     I              RATENUMERI                  RATENUMER_
     I              PROCESSINV                  PROCESSIN_
     I              TAXABLECCY                  TAXABLECC_
     I              TAXAUTHORI                  TAXAUTHOR_
     I              TAXAUT7                     TAXAUT7_
     I              AMOUNT_CUR                  AMOUNT_CU_
     I              TAX_AMOUNT                  TAX_AMOUN_
     I              TSTAMPI                     TSTAMPI_
     I              KEYS                        KEYS_
     I              #PROTOKOLL                  #PROTOKOL_
     I
     I*-------------------------------------------------------------------------
     Ipos_
     I              INVOICEID                   INVOICEID_
     I              INVOICELIN                  INVOICELI_
     I              DESCRIPTIO                  DESCRIPTI_
     I              INVOIC8                     INVOIC8_
     I              QUANTITY                    QUANTITY_
     I              UNITPRICE_                  UNITPRICE
     I              AMOUNT                      AMOUNT2
     I              UNITCODE                    UNITCODE_
     I              PERQUANTIT                  PERQUANTI_
     I              AMOUNTRAB                   AMOUNTRAB_
     I              INVOIC9                     INVOIC9_
     I              TOTALAMOUN                  TOTALAMOU2
     I              TAXRATE                     TAXRATE_
     I              TAXAMOUNT                   TAXAMOUN_
     I              ORDERREF                    ORDERREF_
     I              POREF                       POREF_
     I              SHPREF                      SHPREF_
     I              TSTAMPI                     TSTAMPI_
     I              KEYS                        KEYS_
     I              #PROTOKOLL                  #PROTOKOL_
     I
     I*-------------aus--#CT0501------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    company           2
     C                   PARM                    returnc          30
     C*-------------------------------------------------------------------------

     c  n22              eval      keys  = 'no match found'
     c                   seton                                        22

     c                   if        company     =      rkfirm and
     c                             week    < 8
     c                   if        status = '  '
     c****               if        #cc = 1213
     c****               seton                                        25
     c****               endif

     C     *LIKE         DEFINE    id_           §id
     C                   if        §id        = *blank
     C                   eval      §Id        = id_
     c                   seton                                        64
     c                   setoff                                       63
     C                   endif

     C                   if        id_        = §id
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
     Clr 64              eval      id_        = §id
     Clr 64              z-add     20            doclength         2 0
     Clr 64              exsr      srcommand
     Clr 64              eval      returnc =   %subst(keys:01:doclength)
     Clrn64              eval      returnc =   'no match found'
     Clr 64              exsr      srSAVEDATA
     C**************************************************************************
     C* QUSRTOOLSendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   clear                   phy02r
     c                   move      §id           ##afrk            7
     c                   clear                   ##tst            26
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
     c                             'Internet: http://www.dometic-waeco.de   '
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
     c                   kfld                    id_
     C*
      * :Rechnungskopf  -1-
     c     keysr_afrk    chain     INVOICEHl1                         92
     C*
      * :Rechnungspositionen -2-
     c                   if        *in92 = '0'
     C     keysr_afrk    SETLL     INVOICEPl1                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      INVOICEPl1                             95
     C                   IF        *in95 = '1'            or
     C                             id_       <>  INVOICEID_
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
      * :in jedem Fall lt. Trend
     C*
     c                   clear                   phy02r
     C                   eval      unique_inv = unique_inv + 1
     C*
     c* 15.03.2012                                               +
     C*
     c
     c                   eval      sentence = 'SBP201WAEGERIMSGER' +
     c                             ##afrk                        +
     c                             'WAEGER'                      +
     c                             '   '                         +
     c                             'WAE'                         +
     c                             '          '                  +
     c                             '      '                      +
     c                             'EUR'
     c                   write     phy02r
     c
      * :===>          -initialisierung aller KÖPFE
      * :===>          -open
     c  n63              exsr      sr9500
     c  n63              exsr      sr9800
     c                   seton                                        63
     C                   movel     keys          INVOICEID_
     C                   movel     keys2         INVOICEID_
     c                   eval      INVOICELIN  = INVOICELI_
     c                   eval      DESCRIPTIO  = DESCRIPTI_
     c                   eval      INVOIC8     = 'Invoiced Quantity  '
     c                   eval      QUANTITY    = QUANTITY_
     c                   eval      UNITPRICE_  = UNITPRICE
     c                   eval      AMOUNT      = AMOUNT2
     c                   eval      UNITCODE    = UNITCODE_
     c                   eval      PERQUANTIT  = PERQUANTI_
     c                   eval      AMOUNTRAB   = AMOUNTRAB_
     c                   eval      INVOIC9     = INVOIC9_
     c                   eval      TOTALAMOUN  = TOTALAMOU2
     c                   eval      TAXRATE     = TAXRATE_
     c                   eval      TAXAMOUNT   = TAXAMOUN_
     c                   eval      ORDERREF    = ORDERREF_
     c                   eval      POREF       = POREF_
     c                   eval      SHPREF      = SHPREF_
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
     c                   eval      ##tst =    %char(#tstamp)
     c                   eval      sentence  =
     c                             'SBP201WAEGERIMSGER'          +
     c                             ##afrk                        +
     c                             'Z'
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
     C                   clear                   kunde             7
     C                   movel     RKKDNR        kunde
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
     C*
     C                   clear                   INVOICEID
     C                   clear                   WAECONR           6
     C*
     C                   clear                   RECEIVER_L
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :RECEIVER_L
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
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
     C                   if               rkfirm='99'
     C                   eval             WAECONR  =  '000000'
     C                   eval             keys     =  RECEIVER_L + '_' +
     C                                                LOGICALID  + '_' +
     C                                                %trim(id_)
     C                   eval             keys2    =
     C                                                %trim(id_)
     C                   endif
     C*

     C                   eval               protokoll=RECEIVER_L + '_' +
     C                                                %trim(id_) + ' ' +
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

     C                   eval      TOTALAMOUN =  TOTALAMOU_
     C                   eval      AMOUNT     =  AMOUNT_
     C                   eval      TAX_CURREN =  TAX_CURRE_
     C                   eval      TAXAUTHORI =  TAXAUTHOR_
     C                   eval      AMOUNT_CUR =  AMOUNT_CU_
     C                   eval      BASISAMOUN =  BASISAMOU_
     C                   eval      TAXAUT7=      TAXAUT7_
     C                   eval      TAX_AMOUNT =  TAX_AMOUN_
     C                   clear                   PROCESSINV
     C                   eval      DISCOUNT   =  DISCOUNT_


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
     C                   clear                   RECEIVER_L
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :RECEIVER_L
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null    and
     C+                  substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+                  COMPA00001 is not null
     c/end-exec
     C*
     C                   clear                   LOGICALID
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :LOGICALID
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
     C**********         movel     'Invoice'     TYPE
     c                   eval      TYPE        = TYPE_
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
     C                   eval      DOCUMENTDA    = DOCUMENTD_
     C                   movel     CURRENCYI_    CURRENCYID
     C                   eval      TOTALAMOUN = TOTALAMOUN
     C                   movel     CURRENCYI_    QUALIFIEDA
     C                   eval      AMOUNT     = TOTALAMOUN
     C                   clear                   CHARGETYPE
     C                   eval      CHARGETYPE =  CHARGETYP_
     C                   clear                   CHARGEAMT
     C                   eval      CHARGEAMT  =  CHARGEAMT_
     C                   clear                   CHARGEDATE
     C                   if        %subst( (CHARGEDAT_):11:09) = ' '
     C                   eval      CHARGEDATE    =
     C                             %subst( (CHARGEDAT_):01:10) +
     C                                                 'T00:00:00'
     C                   else
     C                   eval      CHARGEDATE   = CHARGEDAT_
     C                   endif
     C                   clear                   Name
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
     4+ select distinct substr("LogicalID", 1, 6) into :SUPPLIERPA
     4+            from einvoice/idnumbers
     4+            where WAECONR = :WAECONR   and
     4+            "LogicalID"      is not null   and
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
     C                   clear                   CUSTOMID
     C
     C                   clear                   CUSTOMERPA
     C                   clear                   CUSTOMID
     C                   clear                   CUSTOMSTR
     C                   clear                   CUSTOMLIN1
     C                   clear                   CUSTOMNAME
     C                   clear                   CUSTOMCOUN
     C                   clear                   CUSTOMPLZ
     C*
     C                   clear                   CUSTOMID
     c/exec sql
     4+ select distinct substr("LogicalID", 1, 6) into :CUSTOMID
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "LogicalID"      is not null   and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C*
     C*
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
     4*+ select distinct substr("CountryCode", 1, 40)       into :COUNTRYCOD
     4*+            from einvoice/idnumbers
     4*+            where WAECONR = :kunde     and
     4*+            "CountryCode"              is not null  and
     C*+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C*+            COMPA00001 is not null
     c*/end-exec
     C                   clear                   CUSTOMPLZ
     c/exec sql
     4+ select distinct substr("PostalCode", 1, 40)         into :CUSTOMPLZ
     4+            from einvoice/idnumbers
     4+            where WAECONR = :kunde     and
     4+            "PostalCode"               is not null  and
     C+            substr(COMPA00001, 1, 2) = :RKFIRM    and
     C+            COMPA00001 is not null
     c/end-exec
     C
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
     c                   movel     Name          SHIPFRNAME
     c                   movel     STREETNAME    SHIPFRSTR
     c                   movel     CITYNAME      SHIPFRCITY
     c                   movel     COUNTRYCOD    SHIPFRCOUN
     c                   movel     POSTALCODE    SHIPFRPLZ

     c                   movel     SHIPTONAM_    SHIPTONAME
     c                   movel     SHIPTOID_     SHIPTOID
     c                   movel     SHIPTOSTR_    SHIPTOSTR
     c                   movel     SHIPTOLIN_    SHIPTOLIN1
     c                   movel     SHIPTOCIT_    SHIPTOCITY
     c                   movel     SHIPTOCOU_    SHIPTOCOUN
     c                   movel     SHIPTOPLZ_    SHIPTOPLZ
     C
     C                   clear                   type
     C****               Movel     'Invoice'     type
     c                   eval      TYPE        = TYPE_
     C                   clear                   type6
     C*2014.05.19*       Movel     'EU'          type6
     C                   Movel     'VAT'         type6
     C                   movel     TAX_CURREN    TAX_CURREN
     C                   eval      BASISAMOUN = BASISAMOUN
     C                   eval      RATENUMERI = RATENUMER_
     C                   clear                   PROCESSINV
     C                   eval      PROCESSINV ='Tax free intra-community '+
     C                                         'supply according to '     +
     C                                         '§4 and §6a of value '
     C                   movel     TAXAUTHORI    TAXAUTHORI
     C                   clear                   TAXAUT7
     C                   movel     AMOUNT_CUR    AMOUNT_CUR
     C                   clear                   TAX_AMOUNT
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

     C*-------------------------------------------------------------------------
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
     C*co
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

