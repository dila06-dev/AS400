     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      * /free
      *
      *  //Set SQL options
      *  exec sql
      *   SET OPTION
      *       commit=*none,
      *       datfmt=*iso;
      *
      *  //Create the SQL table
      *  exec sql
      *    DROP TABLE QGPL/MYDATA ;
      *
      *  *inlr = *on;
      *
      * /end-free
      *
      *
      *********************************************************************************

     f***man       uf   e             disk
     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)
     F***                                     USROPN

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    company          02
     C                   PARM                    INVOICES#         6 0
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   if        company = '01'
     c                   exsr      sr01
     c                   endif

     C                   EXSR      RETURN

     C**************************************************************************
     C*trend 01 Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr01          BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     C*
     c/exec sql
     c+ insert into  einvoice/custid$
     c+ SELECT DISTINCT ID, SCHEMENAME, ID_CUSTOME, current timestamp,
     c+        substr(profile, 1, 30) keys,
     c+        ('*input ') concat substr(PROPATH, 1, 94) concat ' '
     c+                    concat substr(PROKEY, 1, 26)
     c+ from   EINVOICEIN/INCUST
     c+ WHERE (SCHEMENAME ='LegalEntityUniqueID' or
     c+        SCHEMENAME ='CompanyRegistryData' or
     c+        SCHEMENAME ='TradeRegistryNumber' )
     c+        and id = '20145651209 '
     c/end-exec


     c                   clear                   #taxid           20
     c/exec sql
     c+ SELECT taxid  into :#taxid
     c+ FROM EINVOICEIN/INcust
     c+ WHERE TAXID <> ' '
     c+ and id = '20145651209 '
     c/end-exec

     c                   clear                   #COUNTRYCO       03
     c/exec sql
     c+ SELECT COUNTRYCOD     into :#COUNTRYCO
     c+ FROM EINVOICEIN/INcust
     c+ WHERE SCHEMENAME = 'LegalEntityUniqueID'
     c+ and id = '20145651209 '
     c/end-exec

     C*
     c/exec sql
     c+ insert into  einvoice/custtaxid$
     c+ SELECT ID, TAXID_SCHE, :#COUNTRYCO,
     c+        :#taxid,
     c+        current timestamp,
     c+        substr(profile, 1, 30) keys,
     c+        ('*input ') concat substr(PROPATH, 1, 94) concat ' '
     c+                    concat substr(PROKEY, 1, 26)
     c+ FROM EINVOICEIN/INcust
     c+ where (TAXID_SCHE= 'TypeOfVAT       ' or
     c+        TAXID_SCHE ='CompanyTaxNumber' or
     c+        TAXID_SCHE ='GeneralTaxNumber' or
     c+        TAXID <> ' '                      )
     c+        and id = '20145651209 '
     c/end-exec


     C*
     c/exec sql
     c+ insert into  einvoice/suppid$
     c+ SELECT DISTINCT ID, SCHEMENAME, ID_SUPPLIE, current timestamp,
     c+        substr(profile, 1, 30) keys,
     c+        ('*input ') concat substr(PROPATH, 1, 94) concat ' '
     c+                    concat substr(PROKEY, 1, 26)
     c+ from   einvoicein/insupp
     c+ WHERE  ID ='20145651209'
     c/end-exec

     C*
     c/exec sql
     c+ insert into  einvoice/supptaxid$
     c+ SELECT DISTINCT ID,TAXID_SCHE,SCHEMEAGEN,taxid,current timestamp,
     c+ substr(profile, 1, 30) keys,
     c+ ('*input ') concat substr(PROPATH, 1, 94) concat ' '
     c+             concat substr(PROKEY, 1, 26)
     c+ from   einvoicein/insupp
     c+ WHERE  TAXID_SCHE<> ' ' and
     c+        ID ='20145651209'
     c/end-exec

     C*
     c/exec sql
     c+ insert into einvoice/invoicepo$
     c+ SELECT ID, ID_INVOICE, DESCRIPTIO,TYPE_INVOI,
     c+        QUANTITY, CURRENCYID, AMOUNT, UNITCODE,
     c+        PERQUANTIT, QUALIFIEDA, TOTALAMOUN ,
     c+        TOTALA3,RATENUMERI, TAX_AMOUNT , SALESORDER,
     c+        PURCHASEOR, SHIPPINGTR,
     c+            current timestamp,
     c+ substr(profile, 1, 30) keys,
     c+ ('*input ') concat substr(PROPATH, 1, 94) concat ' '
     c+             concat substr(PROKEY, 1, 26)
     c+ FROM einvoicein/INline WHERE ID like '%2014313663%'
     c/end-exec

     c/exec sql
     c+ insert into einvoice/invoicehe$
     c+ select
     c+ XSI, GXSXTD, XMLNS, SCHEMALOCA, RELEASEID, LOGICALID,
     c+ RECEIVER_L, CREATIONDA, "TYPE"
     c+
     c+
     c+ from
     c+ einvoicein/INbill a,einvoicein/INhead b,
     c+ einvoicein/INproc c , einvoicein/INshfr d ,
     c+ einvoicein/INshto e WHERE
     c+ A.PROKEY= b.PROKEY and A.PROKEY= c.PROKEY and
     c+ A.PROKEY= d.PROKEY and A.PROKEY= e.PROKEY
     c/end-exec

     C*
     c/exec sql
     c+ SELECT dec(count(*), 13, 0) count  into :INVOICES#
     c+ FROM QTEMP/BATCHRUN
     c/end-exec

     C     ##01          ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
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
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
