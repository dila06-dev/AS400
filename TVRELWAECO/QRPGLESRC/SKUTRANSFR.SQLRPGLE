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
      *
      * #DP0051 --
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
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C*                  open      man
     C*                  DO        *HIVAL
     C*
     C*                  READ      man                                    95
     C*                  IF        *in95 = '1'
     C*                  leave
     C*                  else
     C*                  movel     man12         artnr
     C*                  exsr      srlines
     c*                  update    phy01r
     c*                  endif
     C
     C*                  enddo
     C*                  close     man
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*update
     c                   exsr      sr6000
     c                   exsr      sr6500
     c                   exsr      sr6750

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
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
     c+ insert into teos
     c+ select  char(' ', 1)       TEOSLOCK,  char('GANG#', 10) TEOSJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0) TEOSJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0) TEOSJZEI,
     c+         char('GANG#', 10)       TEOSUSER,
     c+         char('SKUTRANSF', 10)        TEOSPROG,
     c+         char('TVRELWAECO', 10)  TEOSBIBL,
     c+         char('01', 02)          TEOSFIRM,
     c+       char('SKU ', 04)        TEOSKLCD,
     c+         ITEM  TEOSTENR,char(sku, 10) TEOSMM01,
     c+ char(' ', 10) TEOSMM02, char(' ', 10) TEOSMM03,
     c+ char(' ', 10) TEOSMM04, char(' ', 10) TEOSMM05,
     c+ char(' ', 10) TEOSMM06, char(' ', 10) TEOSMM07,
     c+ char(' ', 10) TEOSMM08, char(' ', 10) TEOSMM09,
     c+ char(' ', 10) TEOSMM10, char(' ', 100) TEOSFREI
     c+       from         SKUTRANSF          a
     c+ where item <> ' ' and sku <> ' ' and
     c+                               ITEM  not in
     c+ ( select TEOSTENR from teos where TEOSKLCD = 'SKU' and
     c+   TEOSMM01 <> ' ')
     c/end-exec


     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6500        BEGSR
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
     c+ update teos               a set TEOSMM01   =
     c+ (select char(sku, 10) from   SKUTRANSF
     c+  where ITEM=TEOSTENR and TEOSKLCD='SKU'
     c+         and TEOSFIRM in ('01','51'))
     c+         where exists
     c+ (select char(sku, 10) from   SKUTRANSF
     c+  where ITEM=TEOSTENR and TEOSKLCD='SKU'
     c+         and TEOSFIRM in ('01','51'))
     c/end-exec

     C*
     c/exec sql
     c+ update teos               a set TEOSJDAT   =
     c+ (select  zoned(('20')
     c+  concat  substr(char(current date +0 day), 7, 2)  concat
     c+  substr(char(current date +0 day), 4, 2)  concat
     c+  substr(char(current date +0 day), 1, 2), 8, 0)
     c+                                             from   SKUTRANSF
     c+  where ITEM=TEOSTENR and TEOSKLCD='SKU'
     c+         and TEOSFIRM in ('01','51'))
     c+         where exists
     c+ (select zoned(('20')
     c+  concat  substr(char(current date +0 day), 7, 2)  concat
     c+  substr(char(current date +0 day), 4, 2)  concat
     c+  substr(char(current date +0 day), 1, 2), 8, 0)
     c+                                             from   SKUTRANSF
     c+  where ITEM=TEOSTENR and TEOSKLCD='SKU'
     c+         and TEOSFIRM in ('01','51'))
     c/end-exec


     C     ##6500        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6750        BEGSR
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
     c+ update bar_kalk/kalk_file a set artbezfra  =
     c+ (select TEOSMM01   from teos
     c+  where artnr=TEOSTENR and teosklcd='SKU 'and version='$$EL_PS_DB'
     c+         and TEOSFIRM in ('01','51') and artnr in
     c+         (select item from skutransf))
     c+         where exists
     c+ (select TEOSMM01   from teos
     c+  where artnr=TEOSTENR and teosklcd='SKU 'and version='$$EL_PS_DB'
     c+         and TEOSFIRM in ('01','51') and artnr in
     c+         (select item from skutransf))
     c/end-exec


     C     ##6750        ENDSR

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
