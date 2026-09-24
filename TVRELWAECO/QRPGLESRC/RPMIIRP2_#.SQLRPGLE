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
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fRPMII_TO# up   e           k disk    RENAME(RPMII_TO#:phy01r)

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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   setoff                                       70
     C     ';':' '       xlate     APTBZ1        APTBZ1                 70
     C     ',':'.'       xlate     APTBZ1        APTBZ1                 70
     C     '"':' '       xlate     APTBZ1        APTBZ1                 70
     C     '´':' '       xlate     APTBZ1        APTBZ1                 70
     C     '`':' '       xlate     APTBZ1        APTBZ1                 70
     C     ';':' '       xlate     KDRBEZ        KDRBEZ                 70
     C     ',':'.'       xlate     KDRBEZ        KDRBEZ                 70
     C     '"':' '       xlate     KDRBEZ        KDRBEZ                 70
     C     '´':' '       xlate     KDRBEZ        KDRBEZ                 70
     C     '`':' '       xlate     KDRBEZ        KDRBEZ                 70
     c                   if        APPRGR  = '    '
     c                   movel     '000 '        APPRGR
     c                   endif
     C                   update    phy01r

     C**************************************************************************
     C*Definition: inaktiv gesetzt 06.09.2013
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
     c+ delete from tvrelwaeco/RPMII_TO# where
     c+ substr(sku, 1, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 2, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 3, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 4, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 5, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 6, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 7, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 8, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 9, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 10, 1) not in ('1','2','3','4','5','6','7','8','9','0')
     c+ or
     c+ substr(sku, 11, 1) <> ' '
     c/end-exec

     C     ##1000        ENDSR

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
     C******             exsr      sr1000
     C                   ENDSR

     C**************************************************************************
