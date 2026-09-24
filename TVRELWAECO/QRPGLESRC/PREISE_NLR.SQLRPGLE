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

     fe_preis   up   e           k disk    RENAME(e_preis:e_preisr)
     f#PREIL1   uf a e           k disk    RENAME(prei1:phy01r)
     f#PREIL2   uf a e           k disk    RENAME(prei1:phy02r)
     fkund01    if   e           k disk
     fwaeh01    if   e           k disk

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

     C     *ENTRY        PLIST
     C                   PARM                    v                01

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   if        (%subst(#prs020:1:2) =  '56' or
     c                              %subst(#prs020:1:2) =  '57' or
     c                              %subst(#prs020:1:2) =  '58'   ) and
     c                              #PRS050 > 0
     C*                 update prei
     c     key001        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA
     c                   kfld                    PRKDLG

     c                   movel     '52'          #prs010

     c                   exsr      sr1500

     c     key001        chain     #PREIL1                            93
     C   93              clear                   phy01r
     c  n93              z-add     prezpr        #PRS050_A
     c  n93              move      prgada        #PRS070_A
     c  n93              move      prgbda        #PRS120_A

     c                   exsr      sr1500

     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     C                   clear                   PRGBDA
     C                   movel     '0'           *in47
     C                   if        *in47 ='0'
     C   93              write     phy01r
     C  n93              update    phy01r
     C                   endif
     C
     C
     C                   if        %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp'
     C                   movel     'SEK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'USD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'AUD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'PLN'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'PLZ'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'GBP'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'CHF'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'JPY'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'NOK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'DKK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'HUF'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'CZK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'SGD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'NZD'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif
     C                   endif


     c                   if        (%subst(#prs020:1:2) <> '56'   and
     c                              %subst(#prs020:1:2) <> '57'   and
     c                              %subst(#prs020:1:2) <> '58'   ) and
     c                              #PRS050 > 0
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
     c  n93              z-add     prezpr        #PRS050_A
     c  n93              move      prgada        #PRS070_A
     c  n93              move      prgbda        #PRS120_A

     c                   exsr      sr2500

     C   93              write     phy02r
     C  n93              update    phy02r
     C                   endif

     c                   if        #PRS050       > 0
     c   93              movel     'W'           #MODUS
     c  n93              movel     'U'           #MODUS
     c                   move      prJDAT        #GEBUCHT
     c                   update    e_preisr
     C                   endif
     c
     c
     c
     c
     c                   if        (%subst(#prs020:1:2) =  '56' or
     c                              %subst(#prs020:1:2) =  '57' or
     c                              %subst(#prs020:1:2) =  '58'   ) and
     c                              #PRS050 > 0
     C*                 update prei

     c                   exsr      sr1500
     c                   movel     '08'          #prs010

     c     key001        chain     #PREIL1                            93
     C   93              clear                   phy01r
     c  n93              z-add     prezpr        #PRS050_A
     c  n93              move      prgada        #PRS070_A
     c  n93              move      prgbda        #PRS120_A

     c                   exsr      sr1500

     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     C                   clear                   PRGBDA
     C                   movel     '0'           *in47
     C                   if        *in47 ='0'
     C   93              write     phy01r
     C  n93              update    phy01r
     C                   endif
     C
     C
     C                   if        %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp' or
     C                             %subst(#prs020:1:3) =  'ppp'
     C                   movel     'SEK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'USD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'AUD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'PLN'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'PLZ'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'GBP'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'CHF'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'JPY'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'NOK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'DKK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'HUF'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'CZK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'SGD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'NZD'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif
     C                   endif


     c                   if        (%subst(#prs020:1:2) <> '56'   and
     c                              %subst(#prs020:1:2) <> '57'   and
     c                              %subst(#prs020:1:2) <> '58'   ) and
     c                              #PRS050 > 0

     c                   exsr      sr2500

     c     key002        chain     #PREIL2                            93
     C   93              clear                   phy02r
     c  n93              z-add     prezpr        #PRS050_A
     c  n93              move      prgada        #PRS070_A
     c  n93              move      prgbda        #PRS120_A

     c                   exsr      sr2500

     C   93              write     phy02r
     C  n93              update    phy02r
     C                   endif

     c

     C**************************************************************************
     C*fill in
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR

     C                   movel     #prs010       PRFIRM
     C                   movel     'PRL'         PRBEGR
     c                   eval      PRPSLI =
     c                              %subst(#prs020:1:2)
     c*                  eval      PRKDLG =
     c*                             %subst(#prs020:1:2)
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
     c
     c                   movel     date          prJDAT
     c                   if        prgada <      prjdat and v = '0'
     c                   movel     date          prgada
     c                   endif
     c
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
     c**                 movel     '0'           #y
     c                   movel     #y            PRKDLI
     C                   movel     #prs040       PRTENR
     C                   movel     #prs020       PRKDLI
     C                   movel     'EUR'         PRWACD

     c                   move      #prs070       jj                2 0
     c                   movel     #prs070       jjmm              4 0
     c                   movel     #prs070       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c
     c                   movel     date          prJDAT
     c                   if        prgada <      prjdat and v = '0'
     c                   movel     date          prgada
     c                   endif
     c
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
     C                   movel     #prs020       KDKDNR
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
     C* sr7000: ...
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
     C*
     c     key7000       klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c*********          kfld                    WAPLKZ
     C
     C                   movel     '01'          WAFIRM
     C                   movel     'EUR'         WASTWC
     C                   movel     #WAWACD       WAWACD
     c                   movel     date          WAGADA
     c                   clear                   whcd_prs         11 2
     C
     c     KEY7000       SETgt     WAEH01                             94
     c                   DO        *HIVAL
     c                   READp     WAEH01                                 94
     c     *IN94         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      #WAWACD
     c                   leave
     c                   else
     c                   if        WAPLKZ ='J'
     c                   exsr      sr1500
     c                   eval(H)   whcd_prs=#prs050*1  /WAKURS
     C                   movel     #WAWACD       PRWACD
     c     key001        chain     #PREIL1                            93
     c                   exsr      sr1500
     C                   movel     #WAWACD       PRWACD
     c                   z-add     whcd_prs      prezpr
     C                   clear                   PRGBDA
     C   93              write     phy01r
     C  n93              update    phy01r
     c                   leave
     c                   else
     c                   endif
     c                   endif
     c                   enddo
     c
     C*
     C     ##7000        ENDSR
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
     C                   movel     jahr          #jahr             4
     C                   movel     monat         #monat            2
     C                   movel     tag           #tag              2
     C
     c
     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
