     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
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
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

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
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    UPLSTD            6
     C                   PARM                    days              6 0

b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   if        UPLSTD  = '$$$$$$'
     c                   exsr      sr2000
     C                   EXSR      RETURN
     c                   endif
     C
     c                   if        UPLSTD  = '      '
     c                   z-add     999999        days
     c                   else
     c                   exsr      sr1000
     c                   endif
     C
     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau
     c/exec sql
     c+ SELECT days(current date) -
     c+        days(date(substr((:UPLSTD), 5, 2) concat '.' concat
     c+                  substr((:UPLSTD), 3, 2) concat '.' concat
     c+                  substr((:UPLSTD), 1, 2)  ) +0 days )
     c+        into: days
     c+        from qsys2/qsqptabl
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##2000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*User, die gelöscht werden sollten nach ??? Tagen
     c/exec sql
     c+ insert into tvrelwaeco/ADMIN_BARI
     c+ SELECT   distinct UPUPRF,UPSTAT,
     c+          case
     c+          when UPLSTD <> ' ' then
     c+          days(current date) -
     c+          days(date(substr((UPLSTD), 5, 2) concat '.' concat
     c+                    substr((UPLSTD), 3, 2) concat '.' concat
     c+                    substr((UPLSTD), 1, 2)  ) +0 days )
     c+          else 99999
     c+          end,
     c+          current timestamp,
     c+          char('Job will *DISABLED this userprofile', 100) todo
     c+          from TVRELWAECO/#DSPUSRPRF
     c+          where  UPSTAT   = '*ENABLED' and
     c+          ( UPLSTD <> ' ' and
     c+          days(current date) -
     c+          days(date(substr((UPLSTD), 5, 2) concat '.' concat
     c+                    substr((UPLSTD), 3, 2) concat '.' concat
     c+                    substr((UPLSTD), 1, 2)  ) +0 days ) > :days)
     c/end-exec

     C*neue User
     c/exec sql
     c+ insert into tvrelwaeco/ADMIN_BARI
     c+ SELECT   distinct UPUPRF,UPSTAT,
     c+          case
     c+          when UPLSTD <> ' ' then
     c+          days(current date) -
     c+           days(date(substr((UPLSTD), 5, 2) concat '.' concat
     c+                    substr((UPLSTD), 3, 2) concat '.' concat
     c+                    substr((UPLSTD), 1, 2)  ) +0 days )
     c+          else 99999
     c+          end,
     c+          current timestamp,
     c+          char('Neuer User eingerichtet            ', 100) todo
     c+          from TVRELWAECO/#DSPUSRPRF
     c+          where
     c+          UPUPRF not in (select upuprf from #US5000
     c+                         WHERE SEL1 < current date -01 day)
     c/end-exec

     C*komplett gelöschte User
     c/exec sql
     c+ insert into tvrelwaeco/ADMIN_BARI
     c+ SELECT   distinct UPUPRF,UPSTAT,
     c+          case
     c+          when UPLSTD <> ' ' then
     c+          days(current date) -
     c+           days(date(substr((UPLSTD), 5, 2) concat '.' concat
     c+                    substr((UPLSTD), 3, 2) concat '.' concat
     c+                    substr((UPLSTD), 1, 2)  ) +0 days )
     c+          else 99999
     c+          end,
     c+          current timestamp,
     c+          char('User gelöscht                      ', 100) todo
     c+          from TVRELWAECO/#US5000
     c+          where
     c+          UPUPRF not in (select upuprf from #DSPUSRPRF)
     c/end-exec

     C*aktuelle Liste
     c/exec sql
     c+ insert into tvrelwaeco/USERPROT
     c+ SELECT *  FROM admin_bari, #DSPUSRPRF
     c+ WHERE date( SEL0004 ) = current date and
     c+           admin_barI.UPUPRF= #DSPUSRPRF.UPUPRF
     c/end-exec


     C     ##2000        ENDSR

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

     C**************************************************************************
     C*.
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
