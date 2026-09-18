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
      * Datei #KUND01 in QTEMP wurde erstellt.
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      * Anpassung an Dateiänderung KDEW am 12.11.12 Schneider
      *
      *****************************************************************

     fksba      ip   e           k disk    RENAME(ksba:phy01r)
     f#kund01   if   e             disk    prefix('#')
     f                                     RENAME(#kund01:phy02r)
     f                                     INFDS(DSF1)
     F                                     USROPN

     fkund01    uf a e           k disk    RENAME(kund1:phy03r)
     f#KDZRL1   uf a e           k disk
     fkdew01    uf a e           k disk    RENAME(kdew1:phy04r)

     D*Date             S               D   DATFMT(*EUR)
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
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     c                   seton                                        91
     c                   if        code1 = '0600A'
     c                   setoff                                       91
     c                   endif
     c                   if        error = '0'
     c                   setoff                                       91
     c                   endif
     c                   if        *in91 = '0'
     c
     c**                 movel     CODE1         KDZRMIKD
     c**                 exsr      sr1500
     c** 97              movel     customer      KDKDNR
     c                   movel     CODE2         KDZRMIKD
     c                   exsr      sr1500
     c   97              movel     customer      KDKDNR
     c
     c  n97              movel     KDZRFIRM      KDFIRM
     c  n97              movel     KDZRKDNR      KDKDNR
     c
     c     keykund       klist
     c                   kfld                    KDFIRM
     c                   kfld                    KDKDNR
     c
     c     keykund       chain     kund01                             98
     C   98              clear                   phy03r
     c                   exsr      sr2500
     c                   movel     KDZRKDNR      KDKDNR
     c                   movel     DEALER        KDNAM1
     c                   movel     DEALER        KDMCBG
     c                   movel     DEALER        KDKNAM
     c                   movel     STREET        KDSTRA
     c                   movel     PLZ           KDPOLZ
     c                   movel     ORT           KDWORT
     c                   movel     TEL1          KDTLNR
     c                   movel     TEL2          KDTFNR
     c                   movel     EMAIL         x                20
     C   98              write     phy03r
     C  n98              update    phy03r
     c
     c     keyKDEW2      klist
     c                   kfld                    KDEWFIRM
     c                   kfld                    KDEWKDNR
     c
     C                   eval      KDEWFIRM   =  KDFIRM
     c                   eval      KDEWKDNR   =  KDKDNR
     c
     c     keyKDEW2      chain     KDEW01                             98
     C   98              clear                   phy04r
     C                   eval      KDEWLOCK   =  ' '
     C                   eval      KDEWJNAM   =  §§§job
     C                   movel     date          KDEWJDAT
     C                   movel     zeit          KDEWJZEI
     C                   eval      KDEWUSER   =  §§§usr
     C                   eval      KDEWPROG   =  §§§pgm
     C                   eval      KDEWBIBL   =  §§§LIB
     C                   eval      KDEWFIRM   =  KDFIRM
     C                   eval      KDEWKDNR   =  KDKDNR
     C                   eval      KDEWGSKZ   =  #KDEWGSKZ
     C                   eval      KDEWBLKZ   =  #KDEWBLKZ
     C                   eval      KDEWBVKG   =  #KDEWBVKG
     C                   eval      KDEWKSST   =  #KDEWKSST
     C                   eval      KDEWKDKR   =  #KDEWKDKR
     C                   eval      KDEWZOTN   =  #KDEWZOTN
     C                   eval      KDEWZPUR   =  #KDEWZPUR
     C                   eval      KDEWURLD   =  #KDEWURLD
     C                   eval      KDEWDAGB   =  #KDEWDAGB
     C**                 eval      KDEWPLKZ   =  #KDEWPLKZ
     C**                 eval      KDEWKDPL   =  #KDEWKDPL
     C**                 eval      KDEWEZPL   =  #KDEWEZPL
     C**                 eval      KDEWKDPL   =  #KDEWKDPL
     C**                 eval      KDEWEZPL   =  #KDEWEZPL
     C**                 eval      KDEWKZKY   =  #KDEWKZKY
     c                   eval      KDEWFFRI   =  #KDEWFFRI
     C*********          eval      KDEWF256   =  #KDEWF256
     C   98              write     phy04r
     C  n98              update    phy04r
     C                   endif

     C*
     C**************************************************************************
     C* sr5000: Kundenzuordnung order  -2-
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*
     c     keysr1500     klist
     c                   kfld                    KDZRFIRM
     c                   kfld                    KDZRMIKD
     c
     c                   movel     '01'          KDZRFIRM
     c
     c     keysr1500     chain     #KDZRL1                            97
     c   97              clear                   KDZR1
     c
     c                   if        *in97 = '1'
     c                   exsr      sr4500
     c                   movel     '01'          KDZRFIRM
     c                   movel     customer      KDZRKDNR
     c****               movel     '007260'      KDZRZRKD
     c                   movel     '190629'      KDZRZRKD
     c                   movel     '   '         KDZRVBKD
     c****               movel     CODE1         KDZRMIKD
     c                   movel     CODE2         KDZRMIKD
     c                   endif
     c
     c                   movel     §§§job        KDZRJNAM
     c                   movel     date          KDZRJDAT
     c                   movel     zeit          KDZRJZEI
     c                   movel     §§§usr        KDZRUSER
     c                   movel     §§§pgm        KDZRPROG
     c                   movel     §§§LIB        KDZRBIBL
     C   97              write     KDZR1
     C  n97              update    KDZR1
     c
     C*
     C     ##1500        ENDSR
     C*
     C**************************************************************************
     C* sr5000:
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     c                   eval      KDLOCK  =  *blank
     c                   eval      KDJNAM  =  §§§job
     c                   movel     date          KDJDAT
     c                   movel     zeit          KDJZEI
     c                   eval      KDUSER  =  §§§usr
     c                   eval      KDPROG  =  §§§pgm
     c                   eval      KDBIBL  =  §§§LIB
     c                   eval      KDFIRM  =  #KDFIRM
     c                   eval      KDKDNR  =  #KDKDNR
     c                   eval      KDKDST  =  '01'
     c                   eval      KDKDST  =  '01'
     c                   eval      KDMCBG  =  #KDMCBG
     c                   eval      KDNAM1  =  *blank
     c                   eval      KDNAM2  =  *blank
     c                   eval      KDNAM3  =  *blank
     c                   eval      KDSTRA  =  *blank
     c                   eval      KDPOLD  =  #KDPOLD
     c                   eval      KDPOLZ  =  *blank
     c                   eval      KDPOFA  =  *blank
     c                   eval      KDKNAM  =  *blank
     c                   eval      KDHINW  =  *blank
     c                   eval      KDTLNR  =  *blank
     c                   eval      KDTXNR  =  *blank
     c                   eval      KDTFNR  =  *blank
     c                   eval      KDLIFN  =  #KDLIFN
     c                   eval      KDSTKD  =  #KDSTKD
     c                   eval      KDKOKD  =  #KDKOKD
     c                   eval      KDRAKD  =  #KDRAKD
     c                   eval      KDDBKD  =  #KDDBKD
     c                   eval      KDABST  =  #KDABST
     c                   eval      KDLAND  =  #KDLAND
     c                   eval      KDABMA  =  #KDABMA
     c                   eval      KDWACD  =  #KDWACD
     c                   eval      KDSPCD  =  #KDSPCD
     c                   eval      KDMWST  =  #KDMWST
     c                   eval      KDLIBD  =  #KDLIBD
     c                   eval      KDVALT  =  #KDVALT
     c                   eval      KDZABD  =  #KDZABD
     c                   eval      KDVPEI  =  #KDVPEI
     c                   eval      KDAFBS  =  #KDAFBS
     c                   eval      KDLIAR  =  #KDLIAR
     c                   eval      KDSARG  =  #KDSARG
     c                   eval      KDACAB  =  #KDACAB
     c                   eval      KDACLS  =  #KDACLS
     c                   eval      KDACFK  =  #KDACFK
     c                   eval      KDVEAB  =  #KDVEAB
     c                   eval      KDVELS  =  #KDVELS
     c                   eval      KDVERG  =  #KDVERG
     c                   eval      KDTOUR  =  #KDTOUR
     c                   eval      KDKOR1  =  #KDKOR1
     c                   eval      KDKOR2  =  #KDKOR2
     c                   eval      KDVZKT  =  #KDVZKT
     c                   eval      KDVBEI  =  #KDVBEI
     c                   eval      KDRAB1  =  #KDRAB1
     c                   eval      KDRAB2  =  #KDRAB2
     c                   eval      KDRAB3  =  #KDRAB3
     c                   eval      KDRBF1  =  #KDRBF1
     c                   eval      KDRBF2  =  #KDRBF2
     c                   eval      KDRBF3  =  #KDRBF3
     c                   eval      KDFR02  =  #KDFR02
     c                   eval      KDPSLI  =  #KDPSLI
     c                   eval      KDKNLO  =  #KDKNLO
     c                   eval      KDFR04  =  #KDFR04
     c                   eval      KDVKGB  =  #KDVKGB
     c                   eval      KDLANR  =  #KDLANR
     c                   eval      KDKDB1  =  #KDKDB1
     c                   eval      KDKDB2  =  #KDKDB2
     c                   eval      KDKDB3  =  #KDKDB3
     c                   eval      KDKDGR  =  #KDKDGR
     c                   eval      KDSABE  =  #KDSABE
     c                   eval      KDAFET  =  #KDAFET
     c                   eval      KDANLF  =  #KDANLF
     c                   eval      KDVBKD  =  #KDVBKD
     c                   eval      KDNLKZ  =  #KDNLKZ
     c                   eval      KDNIGB  =  #KDNIGB
     c                   eval      KDLFDR  =  #KDLFDR
     c                   eval      KDAFWS  =  #KDAFWS
     c                   eval      KDOPSU  =  #KDOPSU
     c                   eval      KDKLSU  =  #KDKLSU
     c                   eval      KDHVSU  =  #KDHVSU
     c                   eval      KDAFDA  =  #KDAFDA
     c                   eval      KDAFJJ  =  #KDAFJJ
     c                   eval      KDAFNR  =  #KDAFNR
     c                   eval      KDLIDA  =  #KDLIDA
     c                   eval      KDLIJJ  =  #KDLIJJ
     c                   eval      KDRGJJ  =  #KDRGJJ
     c                   eval      KDRGNR  =  #KDRGNR
     c                   eval      KDEMNR  =  #KDEMNR
     c                   eval      KDVSLD  =  #KDVSLD
     c                   eval      KDLFT1  =  #KDLFT1
     c                   eval      KDLFT2  =  #KDLFT2
     c                   eval      KDLFT3  =  #KDLFT3
     c                   eval      KDLFT4  =  #KDLFT4
     c                   eval      KDLFT5  =  #KDLFT5
     c                   eval      KDLFT6  =  #KDLFT6
     c                   eval      KDLFT7  =  #KDLFT7
     c                   eval      KDKSTC  =  #KDKSTC
     c                   eval      KDSTUB  =  #KDSTUB
     c                   eval      KDKDB4  =  #KDKDB4
     c                   eval      KDFR03  =  #KDFR03
     c                   eval      KDPOLN  =  #KDPOLN
     c                   eval      KDKOND  =  #KDKOND
     c                   eval      KDBSPL  =  #KDBSPL
     c                   eval      KDDAKZ  =  #KDDAKZ
     c                   eval      KDSALS  =  #KDSALS
     c                   eval      KDLSSR  =  #KDLSSR
     c                   eval      KDLORT  =  #KDLORT
     c                   eval      KDKSKZ  =  #KDKSKZ
     c                   eval      KDEURO  =  #KDEURO
     c                   eval      KDKNKD  =  #KDKNKD
     c                   eval      KDSTNR  =  #KDSTNR
     c                   eval      KDCHLF  =  #KDCHLF
     c                   eval      KDPPKZ  =  #KDPPKZ
     c                   eval      KDSDBD  =  #KDSDBD
     c                   eval      KDKNLA  =  #KDKNLA
     c                   eval      KDRBGR  =  #KDRBGR
     c                   eval      KDBNKZ  =  #KDBNKZ
     c                   eval      KDVOBU  =  #KDVOBU
     c                   eval      KDBIBU  =  #KDBIBU
     c                   eval      KDMIBT  =  #KDMIBT
     c                   eval      KDRESV  =  #KDRESV
     c                   eval      KDRLFZ  =  #KDRLFZ
     c                   eval      KDRLFA  =  #KDRLFA
     c                   eval      KDLZER  =  #KDLZER
     c                   eval      KDGBLE  =  #KDGBLE
     c                   eval      KDHSNR  =  #KDHSNR
     c                   eval      KDKMAT  =  #KDKMAT
     c                   eval      KDKDBE  =  #KDKDBE
     c                   eval      KDPRIO  =  #KDPRIO
     c                   eval      KDKOSP  =  #KDKOSP
     c                   eval      KDKOBR  =  #KDKOBR
     c                   eval      KDFREX  =  #KDFREX

     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C                   clear                   customer         10

     c/exec sql
     c+ whenever not found goto ##4500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##4500
     c/end-exec

     c/exec sql
     C+   SELECT max(KDKDNR)+1
     C+          into    :customer
     C+          FROM kund01 WHERE kdkdnr <'200000'
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
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CT0707'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#kund01'     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md
     c
     C                   open      #kund01
     c                   z-add     1             F1RRN
     C     F1RRN         CHAIN     #kund01                            91
     C   91              movel     '1'           error             1
     C  N91              movel     '0'           error

     c     keyKDEW       klist
     c                   kfld                    #KDFIRM
     c                   kfld                    #KDKDNR
     c
     C*                 Kostenstellenhinterlegungen Parameter
     c     keyKDEW       chain     KDEW01                             99
     C   99              clear                   phy04r
     C   99              movel     '1'           error             1
     C                   movel     KDEWFIRM      #KDEWFIRM         2
     C                   movel     KDEWKDNR      #KDEWKDNR        10
     C                   movel     KDEWGSKZ      #KDEWGSKZ         1
     C                   movel     KDEWBLKZ      #KDEWBLKZ         1
     C                   movel     KDEWBVKG      #KDEWBVKG         3
     C                   movel     KDEWKSST      #KDEWKSST        10
     C                   movel     KDEWKDKR      #KDEWKDKR         4
     C                   movel     KDEWZOTN      #KDEWZOTN         1
     C                   movel     KDEWZPUR      #KDEWZPUR         1
     C                   movel     KDEWURLD      #KDEWURLD         1
     C                   movel     KDEWDAGB      #KDEWDAGB         1
     C**                 movel     KDEWPLKZ      #KDEWPLKZ         1
     C**                 movel     KDEWKDPL      #KDEWKDPL         4
     C**                 movel     KDEWEZPL      #KDEWEZPL         1
     C**                 movel     KDEWKZKY      #KDEWKZKY         3
     C**                 movel     KDEWFFRI      #KDEWFFRI       239
     C******             movel     KDEWF256      #KDEWF256       248
     C                   movel     KDEWFFRI      #KDEWFFRI       248
     c                   unlock    kdew01

     c                   exsr      sr9999
     C                   close     #kund01

     C                   ENDSR

     C**************************************************************************
