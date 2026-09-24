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

     fe_preis   up   e           k disk
     f#PREIL1   uf a e           k disk    RENAME(prei1:phy01r)
     f#PREIL2   uf a e           k disk    RENAME(prei1:phy02r)
     fkund01    if   e           k disk

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

     c                   if        %subst(#prs020:3:3) =  'XXX' or
     c                             %subst(#prs020:3:3) =  'xxx'
     C*                 update prei
     c     key001        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA
     c                   kfld                    PRKDLG

     c                   exsr      sr1500

     c     key001        chain     #PREIL1                            93
     C   93              clear                   phy01r

     c                   exsr      sr1500

     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     C   93              write     phy01r
     C  n93              update    phy01r
     C                   endif


     c                   if        %subst(#prs020:3:3) <> 'XXX'   and
     c                             %subst(#prs020:3:3) <> 'xxx'
     C*                 update prei
     c     key002        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLI
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA

     c                   exsr      sr2500

     c     key002        chain     #PREIL2                            93
     C   93              clear                   phy02r

     c                   exsr      sr2500

     C   93              write     phy02r
     C  n93              update    phy02r
     C                   endif




     C**************************************************************************
     C*fill in
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR

     C                   movel     #prs010       PRFIRM
     C                   movel     'PKG'         PRBEGR
     c                   eval      PRKDLG = '0'         +
     c                              %subst(#prs020:1:2)
     C                   movel     #prs040       PRTENR
     C                   movel     'EUR'         PRWACD

     c                   move      #prs070       jj                2 0
     c                   movel     #prs070       jjmm              4 0
     c                   movel     #prs070       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      #prs120       jj                2 0
     c                   movel     #prs120       jjmm              4 0
     c                   movel     #prs120       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgbda
     c                   endif
     C                   z-add     #prs050       prezpr
     C                   Movel     '1'           prpdvk
     C                   Movel     'S'           prmepr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     c                   movel     date          prJDAT
     c                   movel     zeit          prJZEI
     c                   movel     tstampi       PRTSTP

     C     ##1500        ENDSR

     C**************************************************************************
     C*fill in
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR

     C                   movel     #prs010       PRFIRM
     C                   movel     'PKD'         PRBEGR
     C                   exsr      sr5000
     C                   if        cond = '1'
     C                   movel     'PKO'         PRBEGR
     C                   endif
     c                   move      #prs020       #y                6
     c                   movel     '0'           #y
     c                   movel     #y            PRKDLI
     C                   movel     #prs040       PRTENR
     C                   movel     'EUR'         PRWACD

     c                   move      #prs070       jj                2 0
     c                   movel     #prs070       jjmm              4 0
     c                   movel     #prs070       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      #prs120       jj                2 0
     c                   movel     #prs120       jjmm              4 0
     c                   movel     #prs120       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgbda
     c                   endif
     C                   z-add     #prs050       prezpr
     C                   Movel     '1'           prpdvk
     C                   Movel     'S'           prmepr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     c                   movel     date          prJDAT
     c                   movel     zeit          prJZEI
     c                   movel     tstampi       PRTSTP

     C     ##2500        ENDSR

     C**************************************************************************
     C* sr5000: Kundenzuordnung Konditionskunde = Hauptkunde dann PKO
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     keykund01     klist
     c                   kfld                    KDFIRM
     c                   kfld                    KDKDNR
     C
     C                   movel     #prs010       KDFIRM
     C                   move      #prs020       #y
     C                   movel     '0'           #y
     C                   movel     #y            KDKDNR
     c                   movel     '0'           cond              1
     c
     c     keykund01     chain     kund01                             97
     c   97              clear                   kund1
     c  n97              if        KDKDNR  =  KDKOKD
     c                   movel     '1'           cond              1
     c                   endif
     C*
     C     ##5000        ENDSR
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
