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
      * SELECT ARTNUM, ARTNR, STK3_ELPS,STK3_TREND,faktor# FROM
      * qtemp/#kw0032 WHERE STK3_ELPS<>STK3_TREND and STK3_ELPS<>0 ORDER BY
      * faktor#
      * Datei STK3KORDEL in TVRELWAECO wurde erstellt.
      *
      * SELECT ARTNUM, ARTNR, STK3_ELPS,STK3_TREND,faktor# FROM
      * qtemp/#kw0032 WHERE STK3_ELPS=0 ORDER BY faktor#
      * 1499 Sätze zu Teildatei STK3KORDEL in Datei STK3KORDEL hinzugefügt.
      *
      * SELECT ARTNUM, ARTNR, STK3_ELPS, STK3_TREND, FAKTOR#, char(' ', 10)
      * protokoll FROM stk3kordel
      * Datei STK3KORDE# in TVRELWAECO wurde erstellt.
      *****************************************************************

     fstk3korde#up   e           k disk    RENAME(stk3korde#:phy01r)
     fteil00    uf   e           k disk    RENAME(teil1:phy02r)

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
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   seton                                        40
     c     STK3_ELPS     sub       stk3_trend    diff             14 6
     c                   exsr      sr3000
     c                   if        diff  <  0
     c                   eval      diff  = diff * -1
     c                   endif
     c                   if        STK3_ELPS = 0  or diff < 0,0059
     C                   else
     C                   endif
     C                   exsr      sr1000
     C                   update    phy01r

     C**************************************************************************
     C* SR1000:
     C*-------------------------------------------------------------------------
     C*
     C     SR1000        BEGSR
     C*

     c     key001        klist
     c                   kfld                    firma             2
     c                   kfld                    artnr
     c                   movel     '01'          firma
     C     key001        chain     teil00                             93
     C  n93              z-add     STK3_ELPS     a                12 2
     C  n93              exsr      sr2000
     C******* n93              z-add     STK3_ELPS     testpr
     C  n93              z-add     a             STK3_ELPS
     C                   if        *in40 = '1'
     C  n93              movel     testpr        #testpr          12
     C  n93              if        %subst(#testpr: 11: 1) <> '0'
     C  n93              move      '0'           #testpr          12
     C  n93              move      '0'           testpr
     C  n93              update    phy02r
     C  n93              movel     '10'          protokoll
     C                   endif
     C                   endif

     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C* SR2000:
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     C*
      *                 costprs Umrechnung faktoren Konvertierung             
     c                   z-add     STK3_ELPS     b                14 6
     c                   if        faktor#='2'
     C                   eval      b           = b          / 10
     c                   endif
     c                   if        faktor#='3'
     C                   eval      b           = b          / 100
     c                   endif
     c                   if        faktor#='4'
     C                   eval      b           = b          / 1000
     c                   endif
     c                   if        faktor#='5'
     C                   eval      b           = b          / 1000
     c                   endif
     c                   if        faktor#='6'
     C                   eval      b           = b          / 1000
     c                   endif
     c                   if        faktor#='7'
     C                   eval      b           = b          / 2
     c                   endif
     c                   if        faktor#='8'
     C                   eval      b           = b          / 4
     c                   endif
     c                   if        faktor#='9'
     C                   eval      b           = b          / 2
     c                   endif
     C                   eval      b   =   b    +  0,005
     c                   z-add     b             STK3_ELPS
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* SR3000:
     C*-------------------------------------------------------------------------
     C*
     C     SR3000        BEGSR
     C*
      *                 costprs Umrechnung faktoren Konvertierung             
     c                   if        faktor#='2'
     C                   eval      diff        = diff       / 10
     c                   endif
     c                   if        faktor#='3'
     C                   eval      diff        = diff       / 100
     c                   endif
     c                   if        faktor#='4'
     C                   eval      diff        = diff       / 1000
     c                   endif
     c                   if        faktor#='5'
     C                   eval      diff        = diff       / 1000
     c                   endif
     c                   if        faktor#='6'
     C                   eval      diff        = diff       / 1000
     c                   endif
     c                   if        faktor#='7'
     C                   eval      diff        = diff       / 2
     c                   endif
     c                   if        faktor#='8'
     C                   eval      diff        = diff       / 4
     c                   endif
     c                   if        faktor#='9'
     C                   eval      diff        = diff       / 2
     c                   endif
     C                   eval      diff =  diff  +  0,005
     C*
     C     ##3000        ENDSR
     C*
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
