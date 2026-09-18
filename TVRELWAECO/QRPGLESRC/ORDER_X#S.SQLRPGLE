     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fTEIL00    if   e           k disk

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
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D orderh        E DS                  INZ
     D orderl        E DS                  INZ
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    #                 5
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   setoff                                       40
     c                   setoff                                       41
     c                   setoff                                       42
     c                   setoff                                       43
     c                   setoff                                       44
     c                   movea     #             *IN(40)
     c   40              z-add     78688         customer          7 0
     c   41              z-add     23038         customer          7 0
     c                   eval      H010      = 'H'
     c                   eval      H020      = customer
     c                   eval      H030      = customer
     c                   eval      H040      = customer
     c                   eval      H050      = %char(order#1)
     c                   eval      H060      = datum
     c                   eval      H070      = zeit
     c                   eval      H080      = *blank
     c                   eval      H090      = *blank
     c                   eval      H100      = *blank
     c                   eval      H110      = *blank
     c                   eval      H120      = *blank
     c                   eval      H130      = *blank
     c                   eval      H140      = *blank
     c                   eval      H150      = *zero
     c                   eval      H160      = *blank
     c                   eval      H170      = *blank
     c                   eval      H180      = *blank
     c                   eval      H190      = *blank
     c                   eval      H200      = *blank
     c                   eval      H210      = *blank
     c                   eval      H220      = *blank
     c                   eval      H230      = *blank
     c                   eval      H240      = %char(order#1)
     c                   eval      H250      = *blank
     c                   eval      H260      = *blank
     c                   eval      H270      = *blank
     c                   eval      H280      = *blank
     c                   eval      H290      = *blank
     c                   eval      H300      = *blank
     c                   eval      H310      = *blank
     c                   eval      H320      = *blank
     c                   eval      H330      = §§§USR
     c                   eval      H340      = *blank
     c                   eval      H350      = *blank
     c                   eval      H350      = *blank
     c                   eval      H360      = datum
     c                   eval      H370      = tstampi
     c**
     c                   eval      L010      = 'L'
     c                   eval      L020      = *zero
     c                   eval      L030      = *zero
     c                   eval      L040      = h050
     c                   eval      L050      = *zero
     c                   eval      L060      = datum
     c                   eval      L070      = *blank
     c*******SKU         eval      L080      = *blank
     c                   eval      L090      = *blank
     c*******quantity    eval      L100      = *zero
     c                   eval      L110      = *blank
     c                   eval      L120      = *blank
     c                   eval      L130      = *blank
     c                   eval      L140      = *blank
     c                   eval      L150      = *blank
     c                   eval      L160      = *blank
     c                   eval      L170      = *blank
     c                   eval      L180      = datum
     c                   eval      L190      = tstampi
     c                   eval      L200      = datum
     c                   eval      L210      = *zero
     c                   eval      L220      = *zero
     c                   eval      L230      = *zero
     c                   eval      L240      = *blank
     c                   eval      L250      = h040
     c                   eval      L990      = *blank
     c**
     c   40              exsr      sr1000
     c   40              exsr      sr1100
     c   41              exsr      sr1000
     c   41              exsr      sr2100
     c   40              z-add     78677         customer          7 0
     c   41              z-add     32691         customer          7 0
     c                   eval      H050      = %char(order#2)
     c                   eval      H240      = %char(order#2)
     c                   eval      H020      = customer
     c                   eval      H040      = customer
     c                   eval      H030      = customer
     c                   eval      L040      = h050
     c                   eval      L250      = h040
     c   40              exsr      sr1000
     c   40              exsr      sr1200
     c   41              exsr      sr1000
     c   41              exsr      sr2200
     C                   EXSR      RETURN

     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into qtemp/orderh
     c+ SELECT :H010, :H020, :H030, :H040, :H050, :H060, :H070, :H080,
     c+        :H090, :H100, :H110, :H120, :H130, :H140, :H150, :H160,
     c+        :H170, :H180, :H190, :H200, :H210, :H220, :H230, :H240,
     c+        :H250, :H260, :H270, :H280, :H290, :H300, :H310, :H320,
     c+        :H330, :H340, :H350, :H360, :H370
     c+        from   qsys2/qsqptabl
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     sr1100        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1100
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into qtemp/orderl
     c+ SELECT :L010, :L020, :L030, :L040,
     c+        rrn(order#),
     c+        :L060, :L070,
     c+        substr(artikel, 1, 15),
     c+        :L090,
     c+        menge,
     c+        :L110, :L120, :L130, :L140, :L150, :L160,
     c+        :L170, :L180, :L190, :L200, :L210, :L220, :L230, :L240,
     c+        h030 , :L990
     c+        from tvrelwaeco/order# where
     c+        substr(artikel, 1, 15) in (select TETENR from teil where
     c+        TEFIRM = '01' and TEPRGR in ('212', '318', '332', '407',
     c+        '412', '424', '701', '702', '703', '704'))
     c+
     c/end-exec

     C     ##1100        ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     sr1200        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1200
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into qtemp/orderl
     c+ SELECT :L010, :L020, :L030, :L040,
     c+        rrn(order#),
     c+        :L060, :L070,
     c+        substr(artikel, 1, 15),
     c+        :L090,
     c+        menge,
     c+        :L110, :L120, :L130, :L140, :L150, :L160,
     c+        :L170, :L180, :L190, :L200, :L210, :L220, :L230, :L240,
     c+        h030,  :L990
     c+        from tvrelwaeco/order# where
     c+        substr(artikel, 1, 15) not in (select TETENR from teil where
     c+        TEFIRM = '01' and TEPRGR in ('212', '318', '332', '407',
     c+        '412', '424', '701', '702', '703', '704'))
     c+
     c/end-exec

     C     ##1200        ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2100
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into qtemp/orderl
     c+ SELECT :L010, :L020, :L030, :L040,
     c+        rrn(order#),
     c+        :L060, :L070,
     c+        substr(artikel, 1, 15),
     c+        :L090,
     c+        menge,
     c+        :L110, :L120, :L130, :L140, :L150, :L160,
     c+        :L170, :L180, :L190, :L200, :L210, :L220, :L230, :L240,
     c+        h030,  :L990
     c+        from tvrelwaeco/order# where
     c+        substr(artikel, 1, 15) in (select TETENR from teil where
     c+        TEFIRM = '01' and TEPRGR in ('212', '314', '316', '317',
     c+         '318', '330', '332', '336', '338', '340', '404', '406',
     c+         '407', '410', '412', '415', '424', '701', '702', '704'))
     c+
     c/end-exec

     C     ##2100        ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     sr2200        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2200
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into qtemp/orderl
     c+ SELECT :L010, :L020, :L030, :L040,
     c+        rrn(order#),
     c+        :L060, :L070,
     c+        substr(artikel, 1, 15),
     c+        :L090,
     c+        menge,
     c+        :L110, :L120, :L130, :L140, :L150, :L160,
     c+        :L170, :L180, :L190, :L200, :L210, :L220, :L230, :L240,
     c+        h030,  :L990
     c+        from tvrelwaeco/order# where
     c+        substr(artikel, 1, 15) not in (select TETENR from teil where
     c+        TEFIRM = '01' and TEPRGR in ('212', '314', '316', '317',
     c+         '318', '330', '332', '336', '338', '340', '404', '406',
     c+         '407', '410', '412', '415', '424', '701', '702', '704'))
     c+
     c/end-exec

     C     ##2200        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
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
     C                   exsr      sr9999
     C     *DTAARA       DEFINE                  order#           10 0
     C     *lock         IN        order#
     C                   eval      order#   = order# +1
     C                   z-add     order#        order#1          10 0
     C                   movel     jahr          order#1          10 0
     C                   eval      order#   = order# +1
     C                   z-add     order#        order#2          10 0
     C                   movel     jahr          order#2          10 0
     C                   out       order#
     C
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
