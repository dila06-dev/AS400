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
     c                   exsr      sr1050
     c                   exsr      sr1060
     c                   exsr      sr1070
     c                   exsr      sr1080
     c                   exsr      sr1999
     c                   exsr      sr2000
     C                   EXSR      RETURN
     c

     C**************************************************************************
     C*changes total
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/confirm
     c+ SELECT zoned((IFAKIFFI), 7) C010, char(ifakmaaf, 10)C020,
     c+ zoned(digits(IFAPIFPO), 5) C030, date(substr(char(aplfTE), 1, 4)
     c+ concat '-' concat substr(char(aplfTE), 5, 2) concat '-' concat
     c+ substr(char(aplfTE), 7, 2) ) c040, zoned(APBSMG*1, 8, 3) c050,
     c+ char(AEUSer concat ' change orderline ' concat char(AEJDAT) concat
     c+ ' ' concat char(digits(AEJzei)) concat ' ' concat apafst, 60) c060,
     c+ char(IFAPAFJJ concat '/' concat char(IFAPAFNR) concat '/' concat
     c+ char(digits(IFAPAFPO)), 20) c070, char (' ', 1)
     c+ c080,timestamp(AEJDAT concat digits(AEJZEI)) c090, char(aptenr
     c+ concat  char (' ', 085)) c100,
     c+       char('00', 2) c110 FROM ifak, ifap, ifad ,afpn, afpo WHERE
     c+ (IFAkIFFI in (select substr(SALES#, 2, 5) from salescomp) and
     c+ IFAKIFNR = IFApIFNR and IFAkIFFI =IFAdIFFI and IFAKIFNR = IFAdIFNR
     c+ and IFAPAFJJ =AEAFJJ and IFAPAFNR = AEAFNR and IFAPAFPO=AEAFPO and
     c+ IFAPAFJJ = APAFJJ and IFAPAFNR = APAFNR and IFAPAFPO=APAFPO ) and
     c+ APAFST < '90' and timestamp (AEJDAT concat digits(AEJZEI)) >
     c+ (select tstamp from confirmcr) ORDER BY AFPN.AEJDAT, AFPN.AEJZEI
     c/end-exec
     c
     C     ##1000        ENDSR

     C**************************************************************************
     C*changes total
     C*-------------------------------------------------------------------------
     C*
     C     sr1050        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1050
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung nach Auftragseingang fehler im interface Trend
     c/exec sql
     c+ insert into tvrelwaeco/confirmhlp
     c+ SELECT            C010, C020, C030, C040, C050,
     c+ char(ifapuser concat ' change interface ' concat char(IFAPJDAT)
     c+ concat ' ' concat char(digits(IFAPJZEI)) concat ' ' concat
     c+ IFAPIFST concat ' ' concat substr(ifapffld, 1, 6)
     c+          concat IFAPFENR, 60) c060
     c+ , char(IFAPAFJJ concat '/' concat char(IFAPAFNR) concat '/' concat
     c+ char(digits(IFAPAFPO)), 20) c070, char (' ', 1) c080 ,
     c+ timestamp(IFAPJDAT concat digits(IFAPJZEI)) c090,c100,
     c+ char('00', 2) c110  frOM  ifap, confirm
     c+ where
     c+ (IFApIFFI in (select substr(SALES#, 2, 5) from salescomp) and
     c+ IFAPIFST >'90' and  IFAPIFFI = substr(digits(c010), 3, 5) and
     c+ c020 = IFAPIFNR and c030=IFAPIFPO
     c+               and timestamp (IFAPJDAT concat digits(IFAPJZEI)) >
     c+ (select tstamp -00 day from confirmcr))
     c*+  ordER BY  IFAPJDAT,  IFAPJZEI
     c+
     c/end-exec
     c
     C     ##1050        ENDSR

     C**************************************************************************
     C*changes total
     C*-------------------------------------------------------------------------
     C*
     C     sr1060        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1060
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung die nur im Interface bearbeitet wurden ohne order#
     C*nachträgliche aktivierung aus dem Interface heraus => freigabe
     c/exec sql
     c+ insert into tvrelwaeco/confirmhlp
     c+ SELECT distinct   C010, C020, C030, C040, C050,
     c+ char(ifapuser concat ' change_interface ' concat char(IFAPJDAT)
     c+ concat ' ' concat char(digits(IFAPJZEI)) concat ' ' concat
     c+ IFAPIFST concat ' ' concat substr(ifapffld, 1, 6)
     c+          concat IFAPFENR, 60) c060
     c+ , char(IFAPAFJJ concat '/' concat char(IFAPAFNR) concat '/' concat
     c+ char(digits(IFAPAFPO)), 20) c070, char (' ', 1) c080 ,
     c+ timestamp(IFAPJDAT concat digits(IFAPJZEI)) c090,c100,
     c+ char('00', 2) c110  frOM  ifap, confirm
     c+ where
     c+ (IFApIFFI in (select substr(SALES#, 2, 5) from salescomp)
     c+                and  IFAPIFFI = substr(digits(c010), 3, 5) and
     c+ c020 = IFAPIFNR and c030=IFAPIFPO and c070='0/      /0000 '
     c+               and timestamp (IFAPJDAT concat digits(IFAPJZEI)) >
     c+ (select tstamp -  00 minutes  from confirmcr))
     c*+  ordER BY  IFAPJDAT,  IFAPJZEI
     c/end-exec
     c
     C     ##1060        ENDSR

     C**************************************************************************
     C*changes total
     C*-------------------------------------------------------------------------
     C*
     C     sr1070        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1070
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung mit 94 Stornierungen melden
     c/exec sql
     c+ insert into tvrelwaeco/confirmhlp
     c+ SELECT zoned((IFAKIFFI), 7) C010, char(ifakmaaf, 10)C020,
     c+ zoned(digits(IFAPIFPO), 5) C030, date(substr(char(aplfTE), 1, 4)
     c+ concat '-' concat substr(char(aplfTE), 5, 2) concat '-' concat
     c+ substr(char(aplfTE), 7, 2) ) c040, zoned(APBSMG*1, 8, 3) c050,
     c+ char(AEUSer concat ' change orderline ' concat char(AEJDAT) concat
     c+ ' ' concat char(digits(AEJzei)) concat ' ' concat apafst, 60) c060,
     c+ char(IFAPAFJJ concat '/' concat char(IFAPAFNR) concat '/' concat
     c+ char(digits(IFAPAFPO)), 20) c070, char (' ', 1)
     c+ c080,timestamp(AEJDAT concat digits(AEJZEI)) c090, char(aptenr
     c+ concat  char (' ', 085)) c100,
     c+       char('00', 2) c110 FROM ifak, ifap, ifad ,afpn, afpo WHERE
     c+ (IFAkIFFI in (select substr(SALES#, 2, 5) from salescomp) and
     c+ IFAKIFNR = IFApIFNR and IFAkIFFI =IFAdIFFI and IFAKIFNR = IFAdIFNR
     c+ and IFAPAFJJ=AEAFJJ and IFAPAFNR = AEAFNR and
     c+     IFAKFIRM=IFAPFIRM and IFAKFIRM=AEFIRM and IFAKFIRM=APFIRM and
     c+ IFAPAFJJ = APAFJJ and IFAPAFNR = APAFNR and IFAPAFPO=APAFPO ) and
     c+ APAFST = '94' and timestamp (AEJDAT concat digits(AEJZEI)) >
     c+ (select tstamp -00 days from confirmcr)
     c*+  ordER BY  IFAPJDAT,  IFAPJZEI
     c/end-exec
     c
     C     ##1070        ENDSR

     C**************************************************************************
     C*expected new delivery date!
     C*-------------------------------------------------------------------------
     C*
     C     sr1080        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1080
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/confirmhlp
     c+ SELECT zoned( substr(DOKDNR, 1, 6), 7) c010,
     c+        char(domaaf, 10) C020,
     c+        zoned(digits(DOIFPO), 5) C030,
     c+        date(substr(char(dolfTE), 1, 4) concat '-' concat
     c+             substr(char(dolfTE), 5, 2) concat '-' concat
     c+             substr(char(dolfTE), 7, 2) ) c040,
     c+        zoned(doBSMG*1, 8, 3) c050,
     c+        char('#01 ' concat
     c+        char(substr(DOLFTE, 1, 8)) concat ' ' concat
     c+        char(substr(DODSTE, 1, 8)), 60) c060,
     c+        char(doAFJJ concat '/' concat char(doAFNR)
     c+        concat '/' concat char(digits(doAFPO)), 20) c070,
     c+        char (' ', 1) c080, DOTMST c090,
     c+        char(dotenr concat char (' ', 085)) c100,
     c+        char('00', 2) c110
     c+        FROM DOMCHKBAS
     c+        where DODSTE >  0
     c+  and   DOTMST > (select tstamp -00 days -00 minute from confirmcr )
     c+
     c/end-exec
     c
     C     ##1080        ENDSR
     C**************************************************************************
     C*changes selektiv
     C*-------------------------------------------------------------------------
     C*
     C     sr1999        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1999
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*löschen doppelter Einträge
     c/exec sql
     c+ delete from TVRELWAECO/CONFIRMHLP a
     c+ WHERE a.C010 in (select b.c010 from confirm b
     c+ where a.C020=b.C020 and
     c+       a.C030=b.C030 and
     c+       a.C060=b.C060)
     c/end-exec
     c
     C     ##1999        ENDSR


     C**************************************************************************
     C*changes selektiv
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ update confirmcr set tstamp =
     c+ (SELECT current timestamp tstamp FROM qsys2/qsqptabl)
     c/end-exec
     c
     C     ##2000        ENDSR

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
