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
      * SELECT DISTR, COUNTR, SUPPLWORLD, CATEGORY, SUPPLLOCAL,
      * KIAINTER.BRAND, TPTTXT, KIAINTER.TEEANR, KIAINTER.ARTNR, TETBZ1,
      * BILLING, RABATT, NETTO, TEPRGR, RABATTP, INPUT FROM
      * tvrelwaeco/kiainter, internet WHERE KIAINTER.ARTNR = INTERNET.ARTNR
      * and (input not like '%Thumbnail%') and ((input like '%_p%') or
      * (input like '%_P%')) and (input not like '%.pdf%') and (hex(input)
      * like '%6D97%')
      * Datei INT_KIA in TVRELWAECO wurde ersetzt.
      *****************************************************************

     fartnotes  uf   e             disk
     f                                     RENAME(artnotes:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
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
     C                   open      artnotes
     C                   DO        *HIVAL
     C
     C                   READ      artnotes                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   movel     artnr         ##artnr          15
     C                   clear                   umlaut            1
     C                   clear                   change            1
     C                   eval      umlaut = '/'
     C                   eval      change = '+'
     c                   exsr      sr_repl
     C                   movel     artnr         ##artnr2         15
     C                   movel     ##artnr2      e9
     C                   movel     ##artnr       artnr
     c                   update    phy01r
     c                   endif
     C
     C                   enddo
     C                   close     artnotes
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   exsr      sr1000
     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
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
     c+ insert into tvrelwaeco/internet
     c+ SELECT ARTNR,E9,ARTGRP,STATNR,input,ARTBEZ,abc,char(' ', 1) pdf,
     c+ char(' ', 1) jpg, char(' ', 1) rest, current timestamp
     c+ tstamp FROM lotus/artnotes, gang/picture
     c+ WHERE artgrp <> 'SON' and
     c+ ((input like '%.jpg%') or (input like '%.pdf%')  or
     c+  (input like '%_WAE%') or (input like '%_wae%')  or
     c+  (input like '%_dom%') or (input like '%_DOM%')  or
     c+  (input like '%_mbc%') or (input like '%_MBC%')) and
     c+ upper(trim(input)) like '%' concat trim
     c+ (substr("E9", 1, 15)) concat '%'
     c/end-exec

     C     ##1000        ENDSR

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

     C**************************************************************************
     C* sr_repl: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_repl       BEGSR
     C*
     c                   eval      pos = %scan(umlaut: artnr )
     c                   dow       pos > 0
     c                   eval      artnr  =
     c                             %replace(change: artnr  : pos: +
     c                             %len(umlaut))
     c                   if        (pos+%len(change) > %len(artnr ))
     c                   eval      pos = 0
     c                   else
     c                   eval      pos = %scan(umlaut: artnr  :
     c                             pos+%len(change))
     c                   endif
     c                   enddo
     C*
     C     ##_repl       ENDSR
     C*
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
