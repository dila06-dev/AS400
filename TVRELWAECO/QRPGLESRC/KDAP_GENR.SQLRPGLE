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
      * SELECT * FROM kund WHERE KDKDNR = '015048'
      * Datei #kdap01 in QTEMP wurde erstellt.
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     f#kdap01   if   e             disk    prefix('#')
     f                                     RENAME(#KDAP01:phy02r)
     f                                     INFDS(DSF1)
     F                                     USROPN

     fkdap01    uf a e           k disk    RENAME(kdap1:phy03r)
     fkdaz01    uf a e           k disk    RENAME(kdaz1:phy04r)
     fTXST01    uf a e           k disk    RENAME(TXST1:phy05r)

     DDate             S               D   DATFMT(*ISO)
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
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
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

     C     *ENTRY        PLIST
     C                   PARM                    customer         10
     C                   PARM                    eMail            60
     C                   PARM                    ojahr             4
     C                   PARM                    oorder            6
     C                   PARM                    §§§job           10
     C                   PARM                    §§§usr           10
     C                   PARM                    §§§pgm           10
     C                   PARM                    §§§LIB           10

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     c                   movel     'KDAP_GENR'   §§§pgm
     c                   seton                                        91
     c                   if        error = '0'
     c                   setoff                                       91
     c                   endif
     c                   if        *in91 = '0'
     c     key1000       klist
     c                   kfld                    K2FIRM
     c                   kfld                    K2KDAR
     c                   kfld                    customer
     c
     c                   movel     '01'          K2FIRM
     c                   movel     'EK'          K2KDAR
     c
     c                   seton                                        77
     C     KEY1000       SETLL     kdap01                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      kdap01                                 95
     C                   clear                   ##mail           60
     C     *IN95         IFEQ      '1'
     C     K2FIRM        orne      '01'
     C     K2KDAR        orne      'EK'
     C     K2KDNR        orne      customer
     C                   leave
     C                   else
     C  n95              movel     K2KNAM        ##mail
     c  n95              move      K2HINW        ##mail
     c     ##mail        ifeq      eMail
     C                   movel     k2lfnr        counting
     c                   setoff                                       77
     C                   leave
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     c
     c   77              exsr      sr2500
     c   77              exsr      sr4500
     C   77              movel     counting      K2LFNR
     C   77              movel     eMail         K2KNAM
     C   77              move      email         K2HINW
     C   77              write     phy03r

     C                   endif
     C
     C                   exsr      sr2600
     C                   exsr      sr2700
     C

     C                   EXSR      RETURN
     C*
     C**************************************************************************
     C* sr5000:
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     c                   eval      K2LOCK  =  *blank
     c                   eval      K2JNAM  =  §§§job
     c                   movel     date          K2JDAT
     c                   movel     zeit          K2JZEI
     c                   eval      K2USER  =  §§§usr
     c                   eval      K2PROG  =  §§§pgm
     c                   eval      K2BIBL  =  §§§LIB
     c                   eval      K2FIRM  =  #K2FIRM
     c                   eval      K2KDAR  =  #K2KDAR
     c                   eval      K2KDNR  =  #K2KDNR
     c                   eval      K2LFNR  =  #K2LFNR
     c                   eval      K2VSST  =  #K2VSST
     c                   eval      K2MCBG  =  #K2MCBG
     c                   eval      K2NAM1  =  #K2NAM1
     c                   eval      K2NAM2  =  #K2NAM2
     c                   eval      K2NAM3  =  #K2NAM3
     c                   eval      K2STRA  =  #K2STRA
     c                   eval      K2POLD  =  #K2POLD
     c                   eval      K2POLZ  =  #K2POLZ
     c                   eval      K2POLN  =  #K2POLN
     c                   eval      K2WORT  =  #K2WORT
     c                   eval      K2POFA  =  #K2POFA
     c                   eval      K2KNAM  =  #K2KNAM
     c                   eval      K2HINW  =  #K2HINW
     c                   eval      K2TLNR  =  #K2TLNR
     c                   eval      K2TXNR  =  #K2TXNR
     c                   eval      K2TFNR  =  #K2TFNR
     c                   eval      K2LAND  =  #K2LAND
     c                   eval      K2SPCD  =  #K2SPCD
     c                   eval      K2APGR  =  #K2APGR
     c                   eval      K2ANRD  =  #K2ANRD
     c                   eval      K2GBDA  =  #K2GBDA
     c                   eval      K2EMNR  =  #K2EMNR
     c                   eval      K2ANCD  =  #K2ANCD
     c                   eval      K2RANG  =  #K2RANG
     c                   eval      K2HSNR  =  #K2HSNR
     c                   eval      K2FRIN  =  #K2FRIN
     c                   eval      K2FREX  =  #K2FREX

     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C* sr5000:
     C*-------------------------------------------------------------------------
     C*
     C     sr2600        BEGSR
     C*
     c     key2600       klist
     c                   kfld                    KDAZFIRM
     c                   kfld                    KDAZDANA
     c                   kfld                    KDAZAFJJ
     c                   kfld                    KDAZAFNR
     c                   kfld                    KDAZAFPO
     c                   kfld                    KDAZKDAR
     c                   kfld                    KDAZKDNR
     c                   kfld                    KDAZVSNR

     c                   eval      KDAZLOCK=  *blank
     c                   eval      KDAZDANA=  'AFKO     '
     c                   eval      KDAZJNAM=  §§§job
     c                   movel     date          KDAZJDAT
     c                   movel     zeit          KDAZJZEI
     c                   eval      KDAZUSER=  §§§usr
     c                   eval      KDAZPROG=  §§§pgm
     c                   eval      KDAZBIBL=  §§§LIB
     c                   eval      KDAZFIRM=  K2FIRM
     c                   movel     ojahr         KDAZAFJJ
     c                   eval      KDAZAFNR=  oorder
     c                   eval      KDAZAFPO=  *zero
     c                   eval      KDAZKDAR=  K2KDAR
     c                   eval      KDAZKDNR=  K2KDNR
     c
     c                   eval      KDAZVSNR=  K2LFNR
     c                   eval      KDAZFRIN=  *blank
     c                   eval      KDAZFREX=  *blank

     c     key2600       chain     kdaz01                             93

     C   93              write     phy04r

     C*
     C     ##2600        ENDSR
     C*
     C**************************************************************************
     C* sr5000:
     C*-------------------------------------------------------------------------
     C*
     C     sr2700        BEGSR
     C*
     c     key2700       klist
     c                   kfld                    TTFIRM
     c                   kfld                    TTTCDE
     c                   kfld                    TTKDLI
     c                   kfld                    TTTENR
     c                   kfld                    TTA115
     c                   kfld                    TTA215
     c                   kfld                    TTSPCD
     c                   kfld                    TTUCDE
     c                   kfld                    TTGADA
     c                   kfld                    TTLFZN

     c                   eval      TTLOCK  =  *blank
     c                   eval      TTJNAM  =  §§§job
     c                   movel     date          TTJDAT
     c                   movel     zeit          TTJZEI
     c                   eval      TTUSER  =  §§§usr
     c                   eval      TTPROG  =  §§§pgm
     c                   eval      TTBIBL  =  §§§LIB
     c                   eval      TTFIRM  =  K2FIRM
     c                   movel     'TRTX27'      TTTCDE
     c                   eval      TTKDLI  =  K2KDNR
     c                   clear                   TTTENR
     c                   movel     K2KDAR        TTA115
     c                   movel     K2LFNR        TTA215
     c                   movel     'D'           TTSPCD
     c                   movel     'EMAIL'       TTUCDE
     c                   clear                   TTGADA
     c                   clear                   TTLFZN
     c                   clear                   TTGBDA
     c                   movel     eMail         TTTEXT
     c                   clear                   TTWERT
     c                   clear                   TTDR01
     c                   clear                   TTDR02
     c                   clear                   TTDR03
     c                   clear                   TTDR04
     c                   clear                   TTDR05
     c                   clear                   TTDR06
     c                   clear                   TTDR07
     c                   clear                   TTDR08
     c                   clear                   TTDR09
     c                   clear                   TTDR10
     c                   clear                   TTFRIN
     c                   clear                   TTFREX

     c     key2700       chain     TXST01                             93

     C   93              write     phy05r

     C*
     C     ##2700        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##4500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##4500
     c/end-exec

     c                   clear                   counting          3 0
     c
     c/exec sql
     C+   SELECT max(K2LFNR)+1
     C+          into    :counting
     C+          FROM kdap01 WHERE K2FIRM = '01' and K2KDAR = 'EK' and
     C+                            K2KDNR = :customer
     c/end-exec
     C*

     c
     C     ##4500        ENDSR

     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##9999
     c/end-exec

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
     c
     C*                 Standardkunde Parameter
     C                   clear                   md
     C                   movea(p)  customer      md(001)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC5350'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#kdap01'     OUTFIL           10
     C                   PARM      'QTEMP     '  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md
     c
     C                   open      #kdap01
     c                   z-add     1             F1RRN
     C     F1RRN         CHAIN     #kdap01                            91
     C   91              movel     '1'           error             1
     C  N91              movel     '0'           error

     c                   exsr      sr9999
     C                   close     #kdap01

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
     C**************************************************************************
