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
      * checken, ob Kunde Konditionskunde
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fafku01    uf a e           k disk    RENAME(afku1:phy01r)

     DDate             S               D   DATFMT(*iso)
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


     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    rcx               1

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*                 update afku
     c     key001        klist
     c                   kfld                    AFKUFIRM
     c                   kfld                    AFKUBENU

     c                   movel     '01'          AFKUFIRM
     c                   movel     §§§usr        AFKUBENU

     c     key001        chain     afku01                             93
     C   93              clear                   phy01r
     C*                 ohne Eintrag in afku Freigabe
     C   93              movel     '1'           rcx
     C  n93              movel     '0'           rcx
     C   93              clear                   daysoff

     C  n93              exsr      sr9900
     C                   if        daysoff < 035
     C  n93              movel     '1'           rcx
     c                   movel     date          afkuJDAT
     c                   movel     zeit          afkuJZEI
     c                   movel     tstampi       afkuTSTP
     c                   else
     c                   movel     tstampi       afkuTSTP
     c                   endif
     c
     c                   eval      %subst(afkufrei:01:10) = §§§usr
     c                   eval      %subst(afkufrei:11:10) = §§§pgm
     c                   eval      %subst(afkufrei:21:10) = §§§job
     c                   eval      %subst(afkufrei:21:10) = §§§LIB
     c                   move      daysoff       #daysoff          5
     c                   eval      %subst(afkufrei:32:05) = #daysoff

     C   93              write     phy01r
     C  n93              update    phy01r

     C                   clear                   md
     C                   movea(p)  §§§usr        md(001)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#WA0001'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#WA0001'     OUTFIL           10
     C                   PARM      'QTEMP     '  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10


     C                   EXSR      RETURN

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
     C**************************************************************************
     C*days out of job
     C*-------------------------------------------------------------------------
     C*
     C     sr9900        BEGSR
     C*
     c                   clear                   daysoff           5 0

     c/exec sql
     c+ SELECT min(decimal(days(current timestamp)-days(afKUTSTP)))
     c+ into :daysoff
     c+ FROM afku
     c+ where  AFKUBENU = :§§§usr
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*SELECT min(decimal(days(current timestamp)-days(afKUTSTP)))
     C*       FROM afku  where  AFKUBENU = 'FRALLARD  '
     C*alt: SELECT decimal( days(current timestamp) - days(afKUTSTP))
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

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     C                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
