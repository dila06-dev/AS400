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
     c                   if        company = '08'
     c                   exsr      sr01
     c                   endif
     c                   if        company = '15'
     c                   exsr      sr15
     c                   endif
     c                   if        company = '52'
     c                   exsr      sr01
     c                   endif
     c                   if        company = '55'
     c                   exsr      sr01
     c                   endif
     c                   if        company = '03'
     c                   exsr      sr03
     c                   endif
     c                   if        company = '99'
     c                   exsr      sr99
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
     c/exec sql
     c+ CREATE TABLE QTEMP/BATCHRUN (RKFIRM CHARACTER ( 2) NOT NULL WITH
     c+ DEFAULT, RKRGJJ NUMERIC ( 4, 0) NOT NULL WITH DEFAULT, RKRGNR
     c+ CHARACTER ( 6) NOT NULL WITH DEFAULT)
     c/end-exec


     C*
     c/exec sql
     c+ insert into QTEMP/BATCHRUN
     c+ SELECT distinct RKFIRM, RKRGJJ, RKRGNR
     c+ FROM einvoice/invoices WHERE
     c+ status = '  ' and rkfirm = :company
     c************ and RKKDNR in ('008138','052774','088505')
     c/end-exec

     C*
     c/exec sql
     c+ SELECT dec(count(*), 13, 0) count  into :INVOICES#
     c+ FROM QTEMP/BATCHRUN
     c/end-exec

     C     ##01          ENDSR

     C**************************************************************************
     C*ElPs  03 Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr03          BEGSR
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
     c/exec sql
     c+ CREATE TABLE QTEMP/BATCHRUN (
     c+ RKFIRM NUMERIC ( 2, 0) NOT NULL WITH DEFAULT,
     c+ RKRGJJ NUMERIC ( 4, 0) NOT NULL WITH DEFAULT,
     c+ RENRAUFTL NUMERIC ( 12, 0) NOT NULL WITH DEFAULT)
     c/end-exec

     C*
     c/exec sql
     c+ insert into QTEMP/BATCHRUN
     c+ SELECT distinct AVKFA, AVKFAKJ, RENRAUFTL
     c+ FROM einvoicesi/invoices WHERE
     c+ status = '  ' and AVKFA  = '01'     and
     c+ AVKKDNR in (3020027, 3030075, 3030208)
     c/end-exec

     C*
     c/exec sql
     c+ SELECT dec(count(*), 13, 0) count  into :INVOICES#
     c+ FROM QTEMP/BATCHRUN
     c/end-exec

     C     ##03          ENDSR

     C**************************************************************************
     C*ElPs  15 Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr15          BEGSR
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
     c/exec sql
     c+ CREATE TABLE QTEMP/BATCHRUN (
     c+ RKFIRM NUMERIC ( 2, 0) NOT NULL WITH DEFAULT,
     c+ RKRGJJ NUMERIC ( 4, 0) NOT NULL WITH DEFAULT,
     c+ RENRAUFTL NUMERIC ( 12, 0) NOT NULL WITH DEFAULT)
     c/end-exec

     C*
     c/exec sql
     c+ insert into QTEMP/BATCHRUN
     c+ SELECT distinct AVKFA, AVKFAKJ, RENRAUFTL
     c+ FROM einvoicedi/invoices WHERE
     c+ status = '  ' and AVKFA  = '15'
     c/end-exec

     C*
     c/exec sql
     c+ SELECT dec(count(*), 13, 0) count  into :INVOICES#
     c+ FROM QTEMP/BATCHRUN
     c/end-exec

     C     ##15          ENDSR

     C**************************************************************************
     C*USA   99 Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr99          BEGSR
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
     c/exec sql
     c+ CREATE TABLE QTEMP/BATCHRUN (
     c+ RKFIRM CHARACTER ( 02) NOT NULL WITH DEFAULT,
     c+ id     CHARACTER ( 30) NOT NULL WITH DEFAULT,
     c+ RKKDNR CHARACTER ( 06) NOT NULL WITH DEFAULT)
     c/end-exec

     C*
     c/exec sql
     c+ insert into QTEMP/BATCHRUN
     c+ SELECT DISTINCT RKFIRM, ID, RKKDNR
     c+ FROM einvoiceus/invoices WHERE
     c+ STATUS ='  '
     c/end-exec

     C*
     c/exec sql
     c+ SELECT dec(count(*), 13, 0) count  into :INVOICES#
     c+ FROM QTEMP/BATCHRUN
     c/end-exec

     C     ##99          ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
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
