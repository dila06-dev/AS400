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
      * create index tvrelwaeco/HDXFORCASl achtung eigene Datei
      * on TVRELWAECO/HDXFORCAST(#AEBEJJ,#AEBENR,#AEBEPO,#LBLBLSTC)
      * Index AVISHELLL1 in TVRELWAECO für Tabelle AVISHELLPF in TVRELWAECO
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     f#LBLBL5   uf   e           k disk
     f                                     RENAME(#lblbr:phy01r)
     f                                     INFDS(DSF1)
     F                                     USROPN
     fbbep00    if   e           k disk
     F                                     USROPN
     fHDXFORCASTuf a e             disk    RENAME(HDXFORCAST:PHY02R)
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
     I*phy01r
     I*              key                         #key
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
     c************       exsr      sr1000
     C     *LIKE         DEFINE    #AEBEJJ       ##AEBEJJ
     C     *LIKE         DEFINE    #AEBENR       ##AEBENR
     C     *LIKE         DEFINE    #AEBEPO       ##AEBEPO
     C     *LIKE         DEFINE    #LBLBLSTC     ##LBLBLSTC
     c
     c                   clear                   #AEBEJJ
     c                   clear                   #AEBENR
     c                   clear                   #AEBEPO
     c                   clear                   #LBLBLSTC
      *                 Bestellposition                                       
     C     KEY#lblbl5    KLIST
     C                   KFLD                    #AEBEJJ
     c
     c                   movel     ' '           status            1
     C                   if        not %open(#lblbl5)
     C                   open      #lblbl5
     c                   endif
     C
     C                   if        not %open(bbep00)
     C                   open      bbep00
     C                   endif
     C                   open      hdxforcast
     C     KEY#lblbl5    SETLL     #lblbl5                            95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C
     C                   READ      #lblbl5                                95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   select
     C                   when      status     = '  '
     C                   exsr      sr2500
     c                   seton                                        30
     c                   setoff                                       30
     c   30              update    phy01r
     c  n30              unlock    #LBLBL5
     C                   other
     C                   endsl
     c                   endif
     C
     C                   enddo
     C                   endif
     C                   close     #lblbl5
     C                   close     bbep00
     C                   close     hdxforcast
b

     c                   exsr      sr1500
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
     c+ insert into tvrelwaeco/HDXFORCAST
     c+ SELECT #AELFNR, #AEBEJJ, #AEBENR, #LBLBBWMG, #LBLBTENR,#AEBEPO,
     c+ EPBEDA,EPBETE,EPBEST,
     c+ #WERTA, #LBLBFBNR , #LBLBLSTC,
     c+ #LBLBBDAT,#LBLBBWMG,#LBLBBWME,#AEWENR, #LBLBTMST FROM #LBLBL5,
     c+ BBEP01
     c+ WHERE EPFIRM IN('01', '51') AND
     c+       EPBEJJ = #AEBEJJ AND EPBENR = #AEBENR AND EPBEPO =
     c+ #AEBEPO
     c+
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
     C*
     C                   if        ##AEBEJJ   <>  #AEBEJJ   or
     C                             ##AEBENR   <>  #AEBENR   or
     C                             ##AEBEPO   <>  #AEBEPO   or
     C                             ##LBLBLSTC <>  #LBLBLSTC
     c                   clear                   count             3 0
     C                   endif
     c*
      *                 Bestellposition                                       
     C     KEYbbep00     KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEBEJJ
     C                   KFLD                    #AEBENR
     C                   KFLD                    #AEBEPO
     C
     C                   movel     '01'          #AEFIRM
     C
      *                 Bestellposition lesen immer aktuell                   
     c     keybbep00     chain     bbep00
     C                   if        %found(bbep00)
     c                   else
     c                   clear                   EPBEDA
     c                   clear                   EPBETE
     c                   clear                   EPBEST
     c                   endif
     c*
     c                   write     phy02r
     c
     c                   eval      ##AEBEJJ    =  #AEBEJJ
     c                   eval      ##AEBENR    =  #AEBENR
     c                   eval      ##AEBEPO    =  #AEBEPO
     c                   eval      ##LBLBLSTC  =  #LBLBLSTC
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
           'TVRELWAECO/hdxforcast';
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
