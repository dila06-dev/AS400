     h option(*SRCSTMT:*NoDebugIO)
     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
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
      *
      *
      * SELECT APKDNR , APAFJJ, APAFNR, APAFPO, APMAAF, APTENR, APBSMG,
      * APLFTE, APKMTE, EPBEJJ,EPBENR , EPBEPO ,EPMENG,EPBETE,dec(0, 13, 4)
      * rest ,char('0', 1) status FROM afpo01,db_optlfr3 WHERE APAFST = 17
      * and APTENR ='9103500872' and APFIRM ='01' and aptenr=eptenr ORDER
      * BY APKMTE , APAFJJ, APAFNR, APAFPO
      * Datei RELEASEDT in TVRELWAECO wurde erstellt.
      * create index tvrelwaeco/RELEASEDT1
      * on TVRELWAECO/RELEASEDT(APKMTE,APAFJJ,APAFNR,APAFPO,EPBETE)
      * Index RELEASEDT1 in TVRELWAECO für Tabelle AVISHELLPF in TVRELWAECO
      *
      * SELECT DISTINCT EPBEJJ, EPBENR, EPBEPO, EPMENG, EPBETE FROM
      * TVRELWAECO/RELEASEDT
      * Datei RELEASE# in TVRELWAECO wurde erstellt.
      *
      * create index tvrelwaeco/RELEASE#1
      * on TVRELWAECO/RELEASE#(EPBEJJ,EPBENR,EPBEPO,epbete)
      * Index RELEASE#1  in TVRELWAECO für Tabelle AVISHELLPF in TVRELWAECO
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fRELEASEDT1uf   e           k disk    RENAME(RELEASEDT :log01R)
     F                                     USROPN

     fRELEASE#1 uf   e           k disk    RENAME(RELEASE#:  log02R)
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
     D
     D**********************************************************************
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
     Ilog01R
     I              epmeng                      #epmeng
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    p                10
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*...
     C*Aufträge
     c                   exsr      sr9999
     c                   exsr      sr9000
     C
     c                   exsr      sr1000
     C     *LIKE         DEFINE    APKMTE        #APKMTE
     C     *LIKE         DEFINE    APAFJJ        #APAFJJ
     C     *LIKE         DEFINE    APAFNR        #APAFNR
     C     *LIKE         DEFINE    APAFPO        #APAFPO
     C     *LIKE         DEFINE    EPBETE        #EPBETE
     c
     C     key001        KLIST
     C                   KFLD                    #APKMTE
     C                   KFLD                    #APAFJJ
     C                   KFLD                    #APAFNR
     C                   KFLD                    #APAFPO
     C                   KFLD                    #EPBETE
     C
     c                   clear                   #APKMTE
     c                   clear                   #APAFJJ
     c                   clear                   #APAFNR
     c                   clear                   #APAFPO
     c                   clear                   #EPBETE
      *                 Bestellposition                                       
     c
     c                   clear                   ueber            1304
     c
     c                   movel     ' '           status            1
     C                   if        not %open(RELEASEDT1)
     C                   open      RELEASEDT1
     c                   endif
     C                   if        not %open(RELEASE#1)
     C                   open      RELEASE#1
     c                   endif
     c
     C     key001        SETLL     RELEASEDT1                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C
     C                   READ      RELEASEDT1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        (APKMTE  =  #APKMTE  and
     C                              APAFJJ  =  #APAFJJ  and
     C                              APAFNR  =  #APAFNR  and
     C                              APAFPO  =  #APAFPO  )
     c                   unlock    RELEASEDT1
     C                   else
     C                   eval       #APKMTE =  APKMTE
     C                   eval       #APAFJJ =  APAFJJ
     C                   eval       #APAFNR =  APAFNR
     C                   eval       #APAFPO =  APAFPO
     C                   exsr      sr2500
     c   30              update    log01r
     c  n30              unlock    RELEASEDT1
     c                   endif
     c                   endif
     C
     C                   enddo
     C                   endif
     C                   close     RELEASEDT1
     c                   close     RELEASE#1
b

     C                   EXSR      RETURN

     C**************************************************************************
     C*Sätze nach Kommissionierung
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

     C*Grundaufbau ...
     c/exec sql
     c+ insert into tvrelwaeco/RELEASEDT
     c+ SELECT APKDNR , APAFJJ, APAFNR, APAFPO, APMAAF, APTENR, APBSMG,
     c+ APLFTE, APKMTE, EPBEJJ,EPBENR , EPBEPO ,EPMENG,EPBETE,dec(0, 13, 4)
     c+ rest ,char('0', 1) status FROM afpo01,db_optlfr3 WHERE APAFST = 17
     c+ and  APTENR in ('9103500872', '9105305738', '9103500872')
     c+                          and APFIRM ='01' and aptenr=eptenr
     c/end-exec

     C*Grundaufbau ...
     c/exec sql
     c+ insert into tvrelwaeco/RELEASE#
     c+ SELECT DISTINCT EPBEJJ, EPBENR, EPBEPO, EPMENG, EPBETE FROM
     c+ TVRELWAECO/RELEASEDT
     c/end-exec

     C     ##1000        ENDSR
     c*
     C**************************************************************************
     C*Sätze nach Kommissionierung
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1500
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau ...
     c/exec sql
     c+ update       hdxforcast a set #LBLBLSTC ='§§§'
     c+ where  #LBLBLSTC ='825' and #AEBEJJ in
     c+        (select b.#aebejj FROM hdxforcast b where
     c+        a.#AEBENR =b.#aebenr and a.#AEBEPO=b.#aebepo and
     c+        #LBLBLSTC ='950')
     c/end-exec

     C     ##1500        ENDSR
     c*
     C**************************************************************************
     C* sr2500: Sendungssatz Aufträge
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     c*
      *                 Bestellposition                                       
     C     key002        KLIST
     C                   KFLD                    EPBEJJ
     C                   KFLD                    EPBENR
     C                   KFLD                    EPBEPO
     C
      *                 Bestellposition lesen immer aktuell                   
     c     key002        chain     RELEASE#1
     C                   if        %found(RELEASE#1)
     C                   if        ( rest+APBSMG+ueber<epmeng or
     C                               rest+APBSMG+ueber=epmeng    )
     C                   eval      rest = rest + APBSMG + ueber
     C                   eval      epmeng=epmeng - APBSMG + ueber
     C                   eval      #epmeng=epmeng
     C                   eval      status = '1'
     c                   seton                                        30
     c                   else
     C                   eval      ueber=epmeng-rest
     C                   eval      rest=epmeng
     C                   eval      status = '0'
     c                   seton                                        30
     c                   endif
     c                   else
     c                   endif
     c*
     c                   update    log02r
     c
     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C*t...
     C*-------------------------------------------------------------------------

     C     sr9000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RELEASEDT ';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RELEASE#';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##9000        ENDSR

     c*
     c*
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

     c*                  CLEAR                   ATR
     c*                  CALL      '#MODATR'                            97
     c*                  PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*                  MOVE      '0'           *INLR
     C
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
