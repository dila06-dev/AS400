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
      * SELECT zoned((IFAKIFFI), 7) C010, char(ifakmaaf, 10)C020,
      * zoned(digits(IFAPIFPO), 5) C030, date(substr(char(aplfTE), 1, 4)
      * concat '-' concat substr(char(aplfTE), 5, 2) concat '-' concat
      * substr(char(aplfTE), 7, 2) ) c040, zoned(APBSMG*1, 8, 3) c050,
      * substr(IFAPFREX, 4, 60) c060, char(IFAPAFJJ concat '/' concat
      * char(IFAPAFNR) concat '/' concat char(digits(IFAPAFPO)), 20) c070,
      * char (' ', 1) c080,timestamp(AEJDAT concat AEJZEI) c090, char (' ',
      * 100) c100, char('00', 2) c110 FROM ifak, ifap, ifad ,afpn, afpo
      * WHERE (IFAkIFFI ='88505' and IFAKMAAF ='76791-4' and IFAkIFFI
      * =IFApIFFI and IFAKIFNR = IFApIFNR and IFAkIFFI =IFAdIFFI and
      * IFAKIFNR = IFAdIFNR and IFAPAFJJ =AEAFJJ and IFAPAFNR = AEAFNR and
      * IFAPAFPO=AEAFPO and IFAPAFJJ = APAFJJ and IFAPAFNR = APAFNR and
      * IFAPAFPO=APAFPO ) ORDER BY AFPN.AEJDAT, AFPN.AEJZEI
      *
      *
      *
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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     c
     c                   exsr      sr1000
     C                   EXSR      RETURN
     c

     C**************************************************************************
     C*Absatzzahlen
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
     c
     c/exec sql
     c+ update #DC2580
     c+ set IFAPLFTE=IFADUEDA
     c+ where ifaplfte =0
     c/end-exec
     c

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/confirm
     c+ SELECT zoned((IFAKIFFI), 7) C010, char(ifakmaaf, 10) C020,
     c+        zoned(digits(IFAPIFPO), 5) C030,
     c+        date(substr(char(ifaplfTE), 1, 4) concat '-' concat
     c+             substr(char(ifaplfTE), 5, 2) concat '-' concat
     c+             substr(char(ifaplfTE), 7, 2) ) c040,
     c+        zoned(IFAPBSMG*1, 8, 3) c050, substr(IFAPFREX, 4, 60) c060,
     c+        char(IFAPAFJJ concat '/' concat char(IFAPAFNR) concat '/'
     c+        concat char(digits(IFAPAFPO)), 20) c070,
     c+        char (' ', 1) c080, current timestamp c090,
     c+        char(ifaptenr concat char (' ', 085)) c100,
     c+                              char('00', 2) c110 FROM #DC2580
     c/end-exec
     c
     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

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
