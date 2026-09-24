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
     C                   PARM                    AKKDNR           10
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
     c                   if        akkdnr <> '          '
     c                   exsr      sr6000
     c                   endif
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
     c+ insert into ZKUN
     c+ select  char(' ', 1)   KZLOCK,        char('GANG#', 10) KZJNAM ,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)    KZJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)   KZJZEI,
     c+         char('GANG#', 10)       KZUSER,
     c+         char('HDXZKUNR', 10)   KZPROG,
     c+         char('TVRELWAECO', 10)  KZBIBL,
     c+         char('01', 02)          KZFIRM,
     c+        :AKKDNR  KZKDNR,
     c+ char('N', 01)   KZDFUE,
     c+ char('N', 01)   KZKLAB,
     c+ char('N', 01)   KZKFAB,
     c+ char('N', 01)   KZKGUT,
     c+ char('N', 01)   KZKZLS,
     c+ char('N', 01)   KZKZRE,
     c+ char('N', 01)   KZKZSP,
     c+ char('N', 01)   KZKZZA,
     c+ char(' ', 10)   KZKDLS,
     c+ char(' ', 10)   KZKDRE,
     c+ char(' ', 35)   KZUNBN,
     c+ zoned((0), 3) KZLFZT,
     c+ char(' ',  1)   KZLVZA,
     c+ char('0',  2)   KZZUGF,
     c+ zoned((0), 3)   KZFRZO,
     c+ char(' ', 10)   KZFR01,
     c+ char('N',  1)   KZKPIF,
     c+ char('N',  1)   KZORDE,
     c+ char('N',  1)   KZEDIU,
     c+ char('HD',  2)   KZEDIF,
     c+ char(' ', 13)   KZEDIB,
     c+ char(' ', 10)   KZZNRN,
     c+ char('N',  1)   KZDRWA,
     c+ char('N',  1)   KZDRKL,
     c+ char('N',  1)   KZDRGM,
     c+ char('N',  1)   KZVPKZ,
     c+ char('N',  1)   KZEDIL,
     c+ char('N',  1)   KZFRKZ,
     c+ char('0',  1)   KZKOLB,
     c+ char('N',  1)   KZORSP,
     c+ char('N',  1)   KZDRRG,
     c+ char('N',  1)   KZDRGU,
     c+ char('N',  1)   KZCHKZ,
     c+ char('N',  1)   KZFREX
     c+       from qsys2/qsqptabl
     c+ where  :AKKDNR not in
     c+ ( select KZKDNR from zkun where :AKKDNR = KZKDNR)
     c/end-exec


     C     ##6000        ENDSR

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
