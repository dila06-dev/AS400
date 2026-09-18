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
      * SELECT char('01', 2) kpfirm, char(substr(SRCDTA, 1, 10), 10)
      * KPKDNR,char(artnr, 15) kptenr, char(substr(ARTBEZFRA, 1, 15), 30)
      * KPIDEN,char(ARTBEZ, 30) kpibz1 FROM TVRELWAECO/SKUTRANSF#,
      * bar_kalk/kalk_file WHERE version = '$$EL_PS_DB' and ARTBEZFRA <> ' '
      * 1095378 Sätze zu Teildatei KPIFTRANS in Datei KPIFTRANS hinzugefügt.
      *
      * SELECT KPFIRM, KPKDNR FROM kpiftrans GROUP BY KPFIRM, KPKDNR
      * Datei SC_TOTAL in TVRELWAECO wurde erstellt.
      * nun sind alle bisherigen hier abgelegt;Achtung Neuanlagen
      *
      *
      * Achtung ÄNDERUNG 11.11.2013
      * Artikel über einen rplacement sichern und später löschen
      * SELECT * FROM KPIF WHERE KPFIRM ='01' AND KPKDNR IN ('015177',
      * '062765', '055278')
      * AND KPIDEN<>KPTENR AND KPIDEN IN (SELECT REPLACM FROM
      * ANALYSESKU WHERE KPTENR = KPTENR)
      * Datei KPIFREPLAC in TVRELWAECO wurde erstellt.
      * anschliessend delete fahren
      *
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
     C                   PARM                    §§firm           02
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

     C*write
     c                   exsr      sr6000

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
     c+ insert into trtp
     c+ select  char(' ', 1)                 tpLOCK,
     c+         char('GANG#', 10)            tpJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   tpJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)   tpJZEI,
     c+         char('GANG#', 10)            tpUSER,
     c+         char('TRTPR    ', 10)        tpPROG,
     c+         char('TVRELWAECO', 10)       tpBIBL,
     c+         :§§firm                      tpFIRM,
     c+         char('D', 01)                TPSPCD,
     c+         char(substr(I1, 1, 10), 10)  TPTART,
     c+         char(substr(I2, 1, 10), 10)  TPTCDE,
     c+         zoned(0, 3, 0)               TPTFLG,
     c+         char(substr(I3, 1, 50), 50)  TPTTXT,
     c+         zoned(0, 11, 5)              TPTNUM,
     c+         char(' ', 20)                TPFRIN,
     c+         char(' ', 20)                TPFREX
     c+ from    transxls            a
     c+ where substr(a.I2, 1, 10)  <> ' '          and
     c+       substr(a.I2, 1, 10)  not in
     c+ ( select TPTCDE from trtp
     c+   where  TPTART = substr(a.I1, 1, 10)
     c+          and   tpFIRM = :§§firm )
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
