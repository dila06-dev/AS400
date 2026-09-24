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
      * update DIRMAIL/DMITMHDR
      * set ihref='DOMETIC file transfer itemserv'
      * WHERE IHMID ='A77NPFBEJIM7NKIT'
      * CPYF FROMFILE(TVRELWAECO/FF5#) TOFILE(QTEMP/FF5) MBROPT(*ADD)
      *
      * ********************************************************************************        
      *
      * Änderungsprotokoll:...                                                
      * Beispiel in tvrelwaeco/steps
      *             00   in Pickliste generiert durch Reservierung
      *             50   gepickt Fertig
      *             90   Lieferscheindruck
      *             90   Rückmeldung
      *
      * Hier muss eine Eindeutigkeit bestehen
      * SELECT  LBPCAFJJ, LBPCAFNR, LBPCAFPO,LBPCAFUP, LBPCLANR ,LBPCBSLA,
      * LBPCFBNR, LBPCGEBI, LBPCCONT, LBPCBHNR, LBPCLORT, LBPCRSMG,
      * LBPCGEWI ,LBPCTSTP , count(*) FROM ff1full GROUP BY LBPCAFJJ,
      * LBPCAFNR, LBPCAFPO, LBPCAFUP, LBPCLANR ,LBPCBSLA , LBPCFBNR,
      * LBPCGEBI, LBPCCONT, LBPCBHNR, LBPCLORT, LBPCRSMG, LBPCGEWI,LBPCTSTP
      * HAVING count(*) > 1
      * Lib list für Rhenania
      * VLF95DWE
      * VLPLGUSR
      * VLF95USR
      * VLNABUSR27
      *
      * insert into tvrelwaeco/FF3
      * SELECT *
      * FROM   tvrelwaeco/ff2 right JOIN
      *        tvpf/afkm01 ON ff2.LBPCNMKR <> afkm01.AMKMNR
      *        WHERE AMFIRM ='01' and ((AMKMNR='304085'or AMKMNN
      *  '304085') and AMKMJJ = year(current date))
      *
      *
      *
      *   tvrelwaeco/FF1_SAVE Sicherung der tvrelwaeco/FF1 für join
      *
      *
      *
      *
      *   SELECT * from afko01 where akref2 =
      *    (select akref1 from ff5) and akfirm='01'
      *
      *
      *
      *
      *
      *
      *
      *  08_
      *  52_
      *  54_
      *
      *
      *********************************************************************************

     fitemserv  uf   e             disk
     f                                     RENAME(itemserv:phy01r)
     f                                     INFDS(DSF1)
     F                                     USROPN


     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0

     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0

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
     D Wrk             DS                  Qualified inz
     D Var1                         200A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

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
     C*                  PARM                    §§amkdnr         10
     C                   PARM                    rfir              3
     C                   PARM                    rvsrhe           40
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   clear                   akkdnr            6
     c                   clear                   LBPCNMKR          6
     c                   clear                   akkdnr_b          7
     c                   eval      akkdnr  =   %subst(rvsrhe:03:06)
     c                   eval      akkdnr_b=   %subst(rvsrhe:02:07)
     c                   eval      LBPCNMKR=   %subst(rvsrhe:09:06)

     C                   if        rfir      = '61 '
     c                   exsr      sr2000
     c                   exsr      sr3500_OE
     C                   EXSR      RETURN
     C                   endif

     C                   if        rfir      = '52 '
     c                   exsr      sr2000
     c                   exsr      sr3500_NL
     C                   EXSR      RETURN
     C                   endif

     C                   if        rfir      = '08 '
     c                   exsr      sr2000
     c                   exsr      sr3500_BE
     C                   EXSR      RETURN
     C                   endif

     C*data bases for input
     c                   exsr      sr2000
     c                   exsr      sr3000
     c                   if        result = 0
     c                   exsr      sr3500
     c                   endif
     c                   setoff                                       40

     C   40              open      ITEMSERV
     C   40              DO        *HIVAL
     C
     C   40              READ      ITEMSERV                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c*                  move      #item         item
     c                   update    phy01r
     c                   endif
     C
     C                   enddo
     C   40              close     ITEMSERV
b
     C                   EXSR      RETURN

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
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
     C*Ausgabedatei FF1 selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ insert into ff1full
     c+ SELECT
     c+ LBPCLOCK, LBPCJNAM, LBPCJDAT, LBPCJZEI, LBPCUSER, LBPCPROG,
     c+ LBPCBIBL, LBPCFIRM, (LBPCTSTP), LBPCPCJJ, LBPCPCNR, LBPCPAKN,
     c+ LBPCDANA, LBPCJAHR, LBPCNMKR, LBPCPOSI, LBPCAFDN, LBPCAFJJ,
     c+ LBPCAFNR, LBPCAFPO, LBPCAFUP, LBPCBSTY, LBPCWKNR, LBPCKDNR,
     c+ LBPCLFNR, (LBPCLANR), (LBPCBSLA), LBPCTENR, (LBPCFBNR), (LBPCGEBI),
     c+ (LBPCCONT), (LBPCBHNR), (LBPCLORT), LBPCCHAR, LBPCFUMG, LBPCMEIN,
     c+ LBPCQUMM, LBPCZULG, LBPCZULO,    (LBPCRSMG),    (LBPCGEWI),
     c+ LBPCSTAT, (LBPCTMST), LBPCBENU, LBPCSFLD,
     c+    (LBPCABBL),    (LBPCABLA),    (LBPCABLO),
     c+ LBPCFREI, current timestamp ct,         current date cd,
     c+ char(' ', 50) info, char(' ', 1) status
     c+ FROM tvrelwaeco/#LBPC01 WHERE
     c+   ( LBPCSTAT > '50' and LBPCSTAT < '91'  or LBPCSTAT = '50')
     c+                 and LBPCFIRM = '01'
     c+ and LBPCNMKR= :LBPCNMKR
     c+ and ((year(substr(char(LBPCJDAT), 1, 4) concat '-'
     c+     concat substr(char(LBPCJDAT), 5, 2) concat '-'
     c+     concat substr(char(LBPCJDAT), 7, 2)))=year(current date)
     c+ or   (date(substr(char(LBPCJDAT), 1, 4) concat '-'
     c+     concat substr(char(LBPCJDAT), 5, 2) concat '-'
     c+     concat substr(char(LBPCJDAT), 7, 2)))>(current date -31 days))
     c/end-exec
     c*

     C*
     C*Ausgabedatei FF1 selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ insert into ff1
     c+ SELECT
     c+ LBPCLOCK, LBPCJNAM, LBPCJDAT, LBPCJZEI, LBPCUSER, LBPCPROG,
     c+ LBPCBIBL, LBPCFIRM, max(LBPCTSTP), LBPCPCJJ, LBPCPCNR, LBPCPAKN,
     c+ LBPCDANA, LBPCJAHR, LBPCNMKR, LBPCPOSI, LBPCAFDN, LBPCAFJJ,
     c+ LBPCAFNR, LBPCAFPO, LBPCAFUP, LBPCBSTY, LBPCWKNR, LBPCKDNR,
     c+ LBPCLFNR, max(LBPCLANR),max(LBPCBSLA),
     c+ LBPCTENR, max(LBPCFBNR), max(LBPCGEBI),max(LBPCCONT),
     c+ max(LBPCBHNR), max(LBPCLORT), LBPCCHAR, LBPCFUMG, LBPCMEIN,
     c+ LBPCQUMM, LBPCZULG, LBPCZULO, sum(LBPCRSMG), sum(LBPCGEWI),
     c+ LBPCSTAT, max(LBPCTMST), LBPCBENU, LBPCSFLD,
     c+ max(LBPCABBL), max(LBPCABLA), max(LBPCABLO),
     c+ LBPCFREI, ct, cd, info, status
     c+ FROM ff1full
     c+ group by
     c+ LBPCLOCK, LBPCJNAM, LBPCJDAT, LBPCJZEI, LBPCUSER, LBPCPROG,
     c+ LBPCBIBL, LBPCFIRM,           LBPCPCJJ, LBPCPCNR, LBPCPAKN,
     c+ LBPCDANA, LBPCJAHR, LBPCNMKR, LBPCPOSI, LBPCAFDN, LBPCAFJJ,
     c+ LBPCAFNR, LBPCAFPO, LBPCAFUP, LBPCBSTY, LBPCWKNR, LBPCKDNR,
     c+ LBPCLFNR, LBPCLANR,           LBPCTENR,
     c+                               LBPCCHAR, LBPCFUMG, LBPCMEIN,
     c+ LBPCQUMM, LBPCZULG, LBPCZULO,
     c+ LBPCSTAT,           LBPCBENU, LBPCSFLD,
     c+ LBPCFREI, ct, cd, info, status
     c/end-exec
     c*

     C*Ausgabedatei FF2 mit Auftragskopfdaten
     C*Achtung Kunde wird nicht immer versorgt aus FF1 (!)
     c/exec sql
     c+ insert into ff2
     c+ SELECT  distinct  * FROM ff1, TVPF/afko01  where
     c+    LBPCAFNR=AKAFNR and LBPCFIRM=AKFIRM and LBPCAFJJ=AKAFJJ
     c*************+    and AKKDNR  = :AKKDNR
     c/end-exec
     c*
     C*Ausgabedatei FF3 mit Kommissionierkopf
     C*Änderung 05.03.2015  and AMKDNR  = :AKKDNR
     c/exec sql
     c+ insert into ff3
     c+ SELECT * from  FF2 , TVPF/afkm01 WHERE
     c+        LBPCJAHR = AMKMJJ and LBPCNMKR = AMKMNR and
     c+        LBPCFIRM = AMFIRM
     c+    and AMKDNR   = :AKKDNR
     c/end-exec
     c*

     C*Ausgabedatei FF4 mit Speditionsdaten nicht mehr eindeutig
     c/exec sql
     c+ insert into ff4
     c***+ SELECT *        FROM ff3, TVPF/afsp01 WHERE LBPCAFNR = AsAFNR
     c+ SELECT *  FROM ff3, tvrelwaeco/#afsp01 WHERE LBPCAFNR = AsAFNR
     c+ and LBPCAFJJ = ASAFJJ and LBPCFIRM = ASfirm
     c+              and ASKART = 'KMNR'
     c+              and amkmjj = ASJAHR
     c+              and amfirm = ASFIRM
     c+              and AMKMNR = ASNUMM
     c/end-exec
     c*


     C*Ausgabedatei FF3 mit Speditionsdaten  afvs01
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*

     C*Ausgabedatei FF3 mit Speditionsdaten LBPCRSMG,LBPCGEWI
     C*FF6
     c***/exec sql
     c***+ insert into ff6
     c***+ SELECT LBPCFIRM, LBPCAFJJ, LBPCAFNR, LBPCAFPO, LBPCAFUP, AVKMPO
     c***+ ,LBPCRSMG, LBPCGEWI, LBPCABBL, LBPCABLA, LBPCABLO , count(*) FROM
     c***+ ff5 GROUP BY LBPCFIRM, LBPCAFJJ, LBPCAFNR, LBPCAFPO, LBPCAFUP,
     c***+ AVKMPO,LBPCRSMG, LBPCGEWI, LBPCABBL, LBPCABLA, LBPCABLO HAVING
     c***+ count(*) > 1
     c***/end-exec
     c*

     C*Ausgabedatei FF3 mit Speditionsdaten
     c*/exec sql
     c*+ insert into TVRELWAECO/forwarder
     c*+ SELECT  distinct * fROM ff5
     c*/end-exec
     c*
     c                   clear                   resultff4        13 0
     C*Ausgabedatei negatives Ergebnis anhand ff5
     c/exec sql
     c+ SELECT count(*) into :resultff4
     c+                 FROM ff4
     c/end-exec
     c*
     c                   clear                   result           13 0
     C*Ausgabedatei negatives Ergebnis anhand ff5
     c/exec sql
     c+ SELECT count(*) into :result
     c+                 FROM ff5
     c/end-exec
     c*
     c                   if        resultff4 <> 0 and
     c                             result    =  0
     c*************                §§§USR    = 'RCF95 '
     c                   exsr      sr4000
     c                   endif


     C     ##3000        ENDSR

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv
     C*-------------------------------------------------------------------------
     C*
     C     sr3500        BEGSR
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

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*20150503 Änderung:      akkdnr =:akkdnr  and
     c/exec sql
     c+ insert into ff3_b
     c+ SELECT distinct * FROM TVPF/afko01,TVPF/afkm01
     c+ WHERE AMFIRM = '01' and AMAFNR = AKAFNR and amfirm = AKFIRM and
     c+       AMAFJJ = AKAFJJ and akkdnr =:akkdnr  and
     c+       ((AMKMNR = :LBPCNMKR or AMKMNN = :LBPCNMKR)
     c+       and AMKMJJ > year(current date - 2 year))
     c+ and ((year(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))=year(current date)
     c+ or   (date(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))>(current date -131 days))
     c/end-exec
     c*

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*Pseudosatz gebildet nur in der (!) tvrelwaeco/ff1 quasi als Muster
     c*WHERE LBPCTENR = ' '              !!!!!!!!!!!!!!!!!!!!
     c/exec sql
     c+ insert into FF3
     c+ SELECT *
     c+ FROM tvrelwaeco/ff1 right JOIN
     c+                 ff3_b ON ff1.LBPCNMKR <> ff3_b.AMKMNR
     c+                 WHERE LBPCTENR = ' ' and LBPCFIRM ='01'
     c/end-exec
     c*


     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ update FF3
     c+ set LBPCAFNR=AKAFNR , LBPCFIRM=AKFIRM, LBPCAFJJ=AKAFJJ,
     c+     ct = current timestamp, cd =current date,
     c+     info = ' ', status=' '
     c/end-exec
     c*


     C*Ausgabedatei FF4 mit Speditionsdaten nicht mehr eindeutig
     c/exec sql
     c+ insert into ff4
     c***+ SELECT *        FROM ff3, TVPF/afsp01 WHERE LBPCAFNR = AsAFNR
     c+ SELECT *  FROM ff3, tvrelwaeco/#afsp01 WHERE LBPCAFNR = AsAFNR
     c+ and LBPCAFJJ = ASAFJJ and LBPCFIRM = ASfirm
     c+              and ASKART = 'KMNR'
     c+              and amkmjj = ASJAHR
     c+              and amfirm = ASFIRM
     c+              and AMKMNR = ASNUMM
     c/end-exec
     c*


     C*Ausgabedatei FF3 mit Speditionsdaten
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*

     C*Ausgabedatei FF3 mit Speditionsdaten LBPCRSMG,LBPCGEWI
     C*FF6
     c***/exec sql
     c***+ insert into ff6
     c***+ SELECT LBPCFIRM, LBPCAFJJ, LBPCAFNR, LBPCAFPO, LBPCAFUP, AVKMPO
     c***+ ,LBPCRSMG, LBPCGEWI, LBPCABBL, LBPCABLA, LBPCABLO , count(*) FROM
     c***+ ff5 GROUP BY LBPCFIRM, LBPCAFJJ, LBPCAFNR, LBPCAFPO, LBPCAFUP,
     c***+ AVKMPO,LBPCRSMG, LBPCGEWI, LBPCABBL, LBPCABLA, LBPCABLO HAVING
     c***+ count(*) > 1
     c***/end-exec
     c*

     C*Ausgabedatei FF3 mit Speditionsdaten
     c*/exec sql
     c*+ insert into TVRELWAECO/forwarder
     c*+ SELECT  distinct * fROM ff5
     c*/end-exec
     c*

     C     ##3500        ENDSR

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv  Österreich
     C*-------------------------------------------------------------------------
     C*
     C     sr3500_OE     BEGSR
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

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*20150503 Änderung:      akkdnr =:akkdnr  and
     c/exec sql
     c+ insert into ff3_b
     c+ SELECT distinct * FROM TVPF/afko01,TVPF/afkm01
     c+ WHERE AMFIRM = '61' and AMAFNR = AKAFNR and amfirm = AKFIRM and
     c+       AMAFJJ = AKAFJJ and akkdnr =:akkdnr    and
     c+       ((AMKMNR = :LBPCNMKR or AMKMNN = :LBPCNMKR)
     c+       and AMKMJJ > year(current date - 2 year))
     c+ and ((year(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))=year(current date)
     c+ or   (date(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))>(current date -131 days))
     c/end-exec
     c*

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*Pseudosatz gebildet nur in der (!) tvrelwaeco/ff1 quasi als Muster
     c*WHERE LBPCTENR = ' '              !!!!!!!!!!!!!!!!!!!!
     c/exec sql
     c+ insert into FF3
     c+ SELECT *
     c+ FROM tvrelwaeco/ff1 right JOIN
     c+                 ff3_b ON ff1.LBPCNMKR <> ff3_b.AMKMNR
     c+                 WHERE LBPCTENR = ' ' and LBPCFIRM ='61'
     c/end-exec
     c*


     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ update FF3
     c+ set LBPCAFNR=AKAFNR , LBPCFIRM=AKFIRM, LBPCAFJJ=AKAFJJ,
     c+     ct = current timestamp, cd =current date,
     c+     info = ' ', status=' '
     c/end-exec
     c*


     C*Ausgabedatei FF4 mit Speditionsdaten nicht mehr eindeutig
     c/exec sql
     c+ insert into ff4
     c***+ SELECT *        FROM ff3, TVPF/afsp01 WHERE LBPCAFNR = AsAFNR
     c+ SELECT *  FROM ff3, tvrelwaeco/#afsp01 WHERE LBPCAFNR = AsAFNR
     c+ and LBPCAFJJ = ASAFJJ and LBPCFIRM = ASfirm
     c+              and ASKART = 'KMNR'
     c+              and amkmjj = ASJAHR
     c+              and amfirm = ASFIRM
     c+              and AMKMNR = ASNUMM
     c/end-exec
     c*


     C*Ausgabedatei FF3 mit Speditionsdaten
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*


     C*Ausgabedatei FF7 mit Auftragsdaten aus System Emsdetten
     c/exec sql
     c+ insert into ff7
     c+ SELECT a.AKFIRM akfirm01, a.AKAFJJ akafjj01,
     c+        a.AKAFNR akafnr01, a.AKKDNR akkdnr01,
     c+        B.AKFIRM, B.AKAFJJ, B.AKAFNR,
     c+        B.AMFIRM, B.AMKMJJ, B.AMKMNR
     c+ FROM afko03 a, ff5 b
     c+ where  a.akfirm='01' and a.akref2 = b.akref1
     c/end-exec
     c*

     C*Ausgabedatei FF8 eindeutige Zuordnung Lieferscheindaten und
     C* und Kom-daten über
     C* Firma AKFIRM01 = 01
     C*       AMKMJJ und AMKMNR Daten Fremdcompany
     c/exec sql
     c+ insert into ff8
     c+ SELECT AKFIRM01, AKAFJJ01, AKAFNR01, AKKDNR01, AKFIRM, AKAFJJ,
     c+ AKAFNR, AMFIRM, AMKMJJ, AMKMNR, BEALFIRM, BEALLIJJ, BEALLINR,
     c+ BEALKMJJ, BEALKMNR, BEALBZFI, BEALBZLJ, BEALBZLI, BEALBZKJ,
     c+ BEALBZKM
     c+ FROM ff7, beal
     c+ WHERE BEALFIRM =AKFIRM01 and
     c+       BEALBZKJ =AMKMJJ   and BEALBZKM =AMKMNR
     c/end-exec
     c*

     C     ##3500_OE     ENDSR

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv  Benelux/Niederlande
     C*-------------------------------------------------------------------------
     C*
     C     sr3500_NL     BEGSR
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

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*20150503 Änderung:      akkdnr =:akkdnr  and
     c/exec sql
     c+ insert into ff3_b
     c+ SELECT distinct * FROM TVPF/afko01,TVPF/afkm01
     c+ WHERE AMFIRM = '52' and AMAFNR = AKAFNR and amfirm = AKFIRM and
     c+       AMAFJJ = AKAFJJ and akkdnr =:akkdnr_b  and
     c+       ((AMKMNR = :LBPCNMKR or AMKMNN = :LBPCNMKR)
     c+       and AMKMJJ > year(current date - 2 year))
     c+ and ((year(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))=year(current date)
     c+ or   (date(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))>(current date -131 days))
     c/end-exec
     c*

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*Pseudosatz gebildet nur in der (!) tvrelwaeco/ff1 quasi als Muster
     c*WHERE LBPCTENR = ' '              !!!!!!!!!!!!!!!!!!!!
     c/exec sql
     c+ insert into FF3
     c+ SELECT *
     c+ FROM tvrelwaeco/ff1 right JOIN
     c+                 ff3_b ON ff1.LBPCNMKR <> ff3_b.AMKMNR
     c+                 WHERE LBPCTENR = ' ' and LBPCFIRM ='52'
     c/end-exec
     c*


     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ update FF3
     c+ set LBPCAFNR=AKAFNR , LBPCFIRM=AKFIRM, LBPCAFJJ=AKAFJJ,
     c+     ct = current timestamp, cd =current date,
     c+     info = ' ', status=' '
     c/end-exec
     c*


     C*Ausgabedatei FF4 mit Speditionsdaten nicht mehr eindeutig
     c/exec sql
     c+ insert into ff4
     c***+ SELECT *        FROM ff3, TVPF/afsp01 WHERE LBPCAFNR = AsAFNR
     c+ SELECT *  FROM ff3, tvrelwaeco/#afsp01 WHERE LBPCAFNR = AsAFNR
     c+ and LBPCAFJJ = ASAFJJ and LBPCFIRM = ASfirm
     c+              and ASKART = 'KMNR'
     c+              and amkmjj = ASJAHR
     c+              and amfirm = ASFIRM
     c+              and AMKMNR = ASNUMM
     c/end-exec
     c*


     C*Ausgabedatei FF3 mit Speditionsdaten
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*


     C*Ausgabedatei FF7 mit Auftragsdaten aus System Emsdetten
     c/exec sql
     c+ insert into ff7
     c+ SELECT a.AKFIRM akfirm01, a.AKAFJJ akafjj01,
     c+        a.AKAFNR akafnr01, a.AKKDNR akkdnr01,
     c+        B.AKFIRM, B.AKAFJJ, B.AKAFNR,
     c+        B.AMFIRM, B.AMKMJJ, B.AMKMNR
     c+ FROM afko03 a, ff5 b
     c+ where  a.akfirm='01' and a.akref2 = b.akref1
     c/end-exec
     c*

     C*Ausgabedatei FF8 eindeutige Zuordnung Lieferscheindaten und
     C* und Kom-daten über
     C* Firma AKFIRM01 = 01
     C*       AMKMJJ und AMKMNR Daten Fremdcompany
     c/exec sql
     c+ insert into ff8
     c+ SELECT AKFIRM01, AKAFJJ01, AKAFNR01, AKKDNR01, AKFIRM, AKAFJJ,
     c+ AKAFNR, AMFIRM, AMKMJJ, AMKMNR, BEALFIRM, BEALLIJJ, BEALLINR,
     c+ BEALKMJJ, BEALKMNR, BEALBZFI, BEALBZLJ, BEALBZLI, BEALBZKJ,
     c+ BEALBZKM
     c+ FROM ff7, beal
     c+ WHERE BEALFIRM =AKFIRM01 and
     c+       BEALBZKJ =AMKMJJ   and BEALBZKM =AMKMNR
     c/end-exec
     c*

     C     ##3500_NL     ENDSR

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv  Belgien
     C*-------------------------------------------------------------------------
     C*
     C     sr3500_BE     BEGSR
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

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*20150503 Änderung:      akkdnr =:akkdnr  and
     c/exec sql
     c+ insert into ff3_b
     c+ SELECT distinct * FROM TVPF/afko01,TVPF/afkm01
     c+ WHERE AMFIRM = '08' and AMAFNR = AKAFNR and amfirm = AKFIRM and
     c+       AMAFJJ = AKAFJJ and akkdnr =:akkdnr_b  and
     c+       ((AMKMNR = :LBPCNMKR or AMKMNN = :LBPCNMKR)
     c+       and AMKMJJ > year(current date - 2 year))
     c+ and ((year(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))=year(current date)
     c+ or   (date(substr(char(AMKMDA), 1, 4) concat '-'
     c+     concat substr(char(AMKMDA), 5, 2) concat '-'
     c+     concat substr(char(AMKMDA), 7, 2)))>(current date -131 days))
     c/end-exec
     c*

     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     C*Pseudosatz gebildet nur in der (!) tvrelwaeco/ff1 quasi als Muster
     c*WHERE LBPCTENR = ' '              !!!!!!!!!!!!!!!!!!!!
     c/exec sql
     c+ insert into FF3
     c+ SELECT *
     c+ FROM tvrelwaeco/ff1 right JOIN
     c+                 ff3_b ON ff1.LBPCNMKR <> ff3_b.AMKMNR
     c+                 WHERE LBPCTENR = ' ' and LBPCFIRM ='08'
     c/end-exec
     c*


     C*Ausgabedatei FF3_pseudo selektiv aus Lagerbewegungen Pickliste
     c/exec sql
     c+ update FF3
     c+ set LBPCAFNR=AKAFNR , LBPCFIRM=AKFIRM, LBPCAFJJ=AKAFJJ,
     c+     ct = current timestamp, cd =current date,
     c+     info = ' ', status=' '
     c/end-exec
     c*


     C*Ausgabedatei FF4 mit Speditionsdaten nicht mehr eindeutig
     c/exec sql
     c+ insert into ff4
     c***+ SELECT *        FROM ff3, TVPF/afsp01 WHERE LBPCAFNR = AsAFNR
     c+ SELECT *  FROM ff3, tvrelwaeco/#afsp01 WHERE LBPCAFNR = AsAFNR
     c+ and LBPCAFJJ = ASAFJJ and LBPCFIRM = ASfirm
     c+              and ASKART = 'KMNR'
     c+              and amkmjj = ASJAHR
     c+              and amfirm = ASFIRM
     c+              and AMKMNR = ASNUMM
     c/end-exec
     c*


     C*Ausgabedatei FF3 mit Speditionsdaten
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*


     C*Ausgabedatei FF7 mit Auftragsdaten aus System Emsdetten
     c/exec sql
     c+ insert into ff7
     c+ SELECT a.AKFIRM akfirm01, a.AKAFJJ akafjj01,
     c+        a.AKAFNR akafnr01, a.AKKDNR akkdnr01,
     c+        B.AKFIRM, B.AKAFJJ, B.AKAFNR,
     c+        B.AMFIRM, B.AMKMJJ, B.AMKMNR
     c+ FROM afko03 a, ff5 b
     c+ where  a.akfirm='01' and a.akref2 = b.akref1
     c/end-exec
     c*

     C*Ausgabedatei FF8 eindeutige Zuordnung Lieferscheindaten und
     C* und Kom-daten über
     C* Firma AKFIRM01 = 01
     C*       AMKMJJ und AMKMNR Daten Fremdcompany
     c/exec sql
     c+ insert into ff8
     c+ SELECT AKFIRM01, AKAFJJ01, AKAFNR01, AKKDNR01, AKFIRM, AKAFJJ,
     c+ AKAFNR, AMFIRM, AMKMJJ, AMKMNR, BEALFIRM, BEALLIJJ, BEALLINR,
     c+ BEALKMJJ, BEALKMNR, BEALBZFI, BEALBZLJ, BEALBZLI, BEALBZKJ,
     c+ BEALBZKM
     c+ FROM ff7, beal
     c+ WHERE BEALFIRM =AKFIRM01 and
     c+       BEALBZKJ =AMKMJJ   and BEALBZKM =AMKMNR
     c/end-exec
     c*

     C     ##3500_BE     ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

     C     sr4000        BEGSR
     C*

     C*Ausgabe eines sped-satzes, sollte er nicht generiert sein
     c*
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
     C*Ableitungen für Übergaben in qtemp
     c/exec sql
     c+ insert into tvpf/AFVS
     c+ select  distinct char(' ', 1) aVLOCK,  char('GANG#', 10)   AVJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   AVJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)          AVJZEI,
     c+         char('GANG#', 10)                AVUSER,
     c+         char('FORWARDERA', 10)           AVPROG,
     c+         char('TVRELWAECO', 10)           AVBIBL,
     c+         amfirm                           AVFIRM,
     c+         AMKMJJ                           AVKMJJ,
     c+         AMKMNR                           AVKMNR,
     c+         zoned(1, 04, 0)                  AVKMPO,
     c+         AMKMNR                           AVKMNN,
     c*****     zoned(0, 06, 0)                  AVKMNN,
     c+         char('  ', 09)                   AVFR01,
     c+         zoned(1, 04, 0)                  AVANZA,
     c+         zoned(0/1, 09, 4)                AVGWBR,
     c+         zoned(0/1, 09, 4)                AVGWNT,
     c+         zoned(0/1, 09, 4)                AVVOLU,
     c+         char('2', 15)                    AVTENR,
     c+         char(' ', 01)                    AVKZ01,
     c+         char('L', 01)                    AVKLKZ,
     c+         char(' ', 02)                    AVKZ04,
     c+         zoned(0, 04, 0)                  AVABJJ,
     c+         char(' ', 06)                    AVABNR,
     c+         ASSPED                           AVKDLI,
     c******+         'TEST     '                      AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c+         char(' ', 20)                    AVDPDN,
     c+         char(' ', 15)                    AVFRIN,
     c+         char('N', 1)                     AVDSKZ,
     c+         char(' ', 2)                     AVDSDF,
     c+         char(' ', 1)                     AVDSUE,
     c+         char(' ', 20)                    AVPAKN,
     c+         char(' ', 20)                    AVHINW
     c+
     c+ from         QTEMP/ff4          a
     c+              where   AMKMJJ<>0  and
     c+                      AMKMNR<>'    '
     c/end-exec

     C*Ausgabedatei FF3 mit Speditionsdaten  afvs01
     c/exec sql
     c+ insert into ff5
     c+ SELECT * FROM ff4, tvpf/afvs01
     c+                    WHERE LBPCFIRM=Avfirm and AMFIRM=AvFIRM
     c+ and AMKMJJ = AvKMJJ  and AMKMNR = AvKMNR
     c+ and ASJAHR  =AVKMJJ  and ASNUMM  =AVKMNR
     c+ and ASFIRM  =AVFIRM  and AMKMNR = AVKMNN
     c/end-exec
     c*

     c                   clear                   result           13 0
     C*Ausgabedatei negatives Ergebnis anhand ff5
     c/exec sql
     c+ SELECT count(*) into :result
     c+                 FROM ff5
     c/end-exec
     c*

     C     ##4000        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/forwarder';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF1FULL';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free


      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF1';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF2';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF3';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF4';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF5';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF6';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF3_B';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF7';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/FF8';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free


     C     ##2000        ENDSR

     c*
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
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     c                   eval      pjahr = pjahr + 0
     c                   clear                   xp                8 0
     c                   eval      xp=(pjahr*10000)+(pmonat*100)+ptag
     c*                  move      '0101'        xp
     c*                  move      '0101'        xp
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
