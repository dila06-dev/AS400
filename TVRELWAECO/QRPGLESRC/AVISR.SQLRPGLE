     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
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
      *
      *
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
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
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

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/SQL_0002
     c+ SELECT char( '01' concat substr(ALKDNR, 1, 6) concat substr(ALKMNR,
     c+ 1, 6) concat '1 Avis: 'concat TBTEXT concat dec(ALJDAT) concat ' '
     c+ concat dec(ALJZEI), 100) , ALAFJJ, ALAFNR , current timestamp ,
     c+ current date FROM aflp, txbe WHERE AlFIRM='01' and AlAFJJ='2013'
     c+ and tbFIRM='01' and TBTCDE ='TXSP' and TBTEXT like '%301 -%' and
     c+ AlFIRM=tbfirm and AlAFJJ=TBJHJJ and AlAFNR = tbAFNR and
     c+ (date(substr(char(ALJDAT), 1, 4) concat '-' concat
     c+ substr(char(ALJDAT), 5, 2) concat '-' concat substr(char(ALJDAT),
     c+ 7, 2))) > current date - 2 day and ALKDNR ='040631' and char( '01'
     c+ concat substr(ALKDNR, 1, 6) concat substr(ALKMNR, 1, 6) concat
     c+ '1 Avis: 'concat TBTEXT concat dec(ALJDAT) concat ' ' concat
     c+ dec(ALJZEI), 100) not in (select sel0001 from #SQL_0002) GROUP BY
     c+ char( '01' concat substr(ALKDNR, 1, 6) concat substr(ALKMNR, 1, 6)
     c+ concat '1 Avis: 'concat TBTEXT concat dec(ALJDAT) concat ' ' concat
     c+ dec(ALJZEI), 100),ALAFJJ,alafnr
     c/end-exec

     C     ##1000        ENDSR

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
