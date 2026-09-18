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
      *CPYFRMIMPF FROMFILE(TVRELWAECO/ZOLLSATZ#) TOFILE(TVRELWAECO/ZOLLSATZ)
      *MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      *
      *188 Sätze aus Teildatei ZOLLSATZ# kopiert.
      *
      *  SELECT char(' ', 15) ITEM#, char(' ', 15) ZOLL#, current timestamp
      *  tstamp FROM zollsatz
      *  Datei ZOLLSATZ2 in TVRELWAECO wurde erstellt.
      *
      *
      *  SELECT KAZKKASL, KAZKBAWT,current timestamp FROM kazk WHERE
      *  KAZKFIRM='01' and KAZKZART='ZKO' and KAZKBEGR='BG2' and
      *  KAZKBERE='001'
      *
      *  hier andere Zollnummer
      *  update teil                 set tezotn    =
      *  (select zoll#      from TVRELWAECO/ZOLLSATZ2
      *   where ITEM#=tetenr and tefirm in ('08', '52') and item#='68008')
      *   where exists
      *  (select zoll#      from TVRELWAECO/ZOLLSATZ2
      *   where ITEM#=tetenr and tefirm in ('08', '52') and item#='68008')
      *
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
     c****               exsr      sr6500

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
     c+ insert into kazk
     c+ select  char(' ', 1)       KAZKLOCK,  char('GANG#', 10) KAZKJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0) KAZKJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0) KAZKJZEI,
     c+         char('GANG#', 10)       KAZKUSER,
     c+         char('I_KAZKR', 10)     KAZKPROG,
     c+         char('TVRELWAECO', 10)  KAZKBIBL,
     c+         char('01', 02)          KAZKFIRM,
     c+         char('ZKO', 03)         KAZKZART,
     c+         char('BG2', 03)         KAZKBEGR,
     c+         KAZKKASL                KAZKKASL,
     c+         char('   ', 15)         KAZKTENR,
     c+ zoned(('20') concat  substr(char(current date + 0000 day), 7, 2)
     c+ concat ('0101') ) KAZKGADA,
     c***+ zoned(('20') concat  substr(char(current date + 0000 day), 7, 2)
     c***+ concat ('1231') ) KAZKGbDA,
     c+               0   KAZKGbDA,
     c+         KAZKBAWT            KAZKBAWT,
     c+         zoned(0, 9, 4)      KAZKBAWV,
     c+         char('J', 01)       KAZKWTFL,
     c+         char(' ', 01)       KAZKPDIM,
     c+         char('1', 01)       KAZKSART,
     c+         char('001', 03)     KAZKBERE,
     c+         char('  ', 12)      KAZKFRIN,
     c+         char('  ', 20)      KAZKFREX
     c+       from  Zollsatz
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
     c+         char('IDCO', 10)        TEOSPROG,
     c+         char('TVRELWAECO', 10)  TEOSBIBL,
     c+         char('01', 02)          TEOSFIRM,
     c+       char('IDCO', 04)        TEOSKLCD,
     c+       a.artnr TEOSTENR,char(idco, 10) TEOSMM01,
     c+ char(' ', 10) TEOSMM02, char(' ', 10) TEOSMM03,
     c+ char(' ', 10) TEOSMM04, char(' ', 10) TEOSMM05,
     c+ char(' ', 10) TEOSMM06, char(' ', 10) TEOSMM07,
     c+ char(' ', 10) TEOSMM08, char(' ', 10) TEOSMM09,
     c+ char(' ', 10) TEOSMM10, char(' ', 100) TEOSFREI
     c+       from         bar_kalk/kalk_file a, idco b
     c+ where a.statnr=b.statnr  and b.artnr = a.artnr  and
     c+ version = '$$EL_PS_DB'
     c+                        and  a.artnr not in
     c+ ( select TEOSTENR from teos where TEOSKLCD = 'IDCO' and
     c+   TEOSMM01 <> ' ')
     c/end-exec


     C     ##6500        ENDSR

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
