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
      * insert into        tvrelwaeco/E_PREIS                                 
      * SELECT zoned(1, 2, 0) #PRS010, char('173XXX', 6)
      * #PRS020,char('CHF', 3) #PRS030, item #PRS040,
      *  zoned(round(ics_2*0,813470/0,909090, 2), 9, 2) #PRS050,
      * zoned(substr(char(current date -000 day), 1, 2)  concat
      * substr(char(current date -000 day), 4, 2)  concat
      * substr(char(current date -000 day), 7, 2), 6, 0)   #PRS070,
      *                           char('   ', 15) #prs080,
      * zoned(substr(char(current date +286 day), 1, 2)  concat
      * substr(char(current date +286 day), 4, 2)  concat
      * substr(char(current date +286 day), 7, 2), 6, 0) #PRS120,
      * zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
      * char(('$' concat substr(char(current timestamp), 01, 19)), 50)
      *  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
      * char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
      * FROM itemserv  where ics_2   > 0
      *
      *
      *SELECT zoned(1, 2, 0) #PRS010, char('191453', 6) #PRS020,char('RUB',
      * 3) #PRS030, char(item, 15)   #PRS040,
      *zoned(round(ICS_2/0,0227, 2), 9, 2) #PRS050,
      *zoned(substr(char(current date -001 day), 1, 2)  concat
      *substr(char(current date -000 day), 4, 2)  concat
      *substr(char(current date -000 day), 7, 2), 6, 0)   #PRS070,
      *                                            char(' ', 15) #prs080,
      *zoned(substr(char(current date +419 day), 1, 2)  concat
      *substr(char(current date +419 day), 4, 2)  concat
      *substr(char(current date +419 day), 7, 2), 6, 0) #PRS120,
      *zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
      *char(('$' concat substr(char(current timestamp), 01, 19)), 50)
      * #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
      *char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
      *FROM itemserv
      *Datei SCHOLZ in TVRELWAECO wurde ersetzt.
      *
      *insert into  tvrelwaeco/E_PREIS
      *SELECT zoned(01, 2, 0) #PRS010, char((substr(lieferant, 1, 3)
      *concat 'XXX'), 6) #PRS020, char('000', 3) #prs030, ITEM #prs040,
      *zoned( PVKNETTO, 9, 2) #prs050, zoned(160121, 6, 0) #prs070,
      *char(' ', 15) #prs080, zoned(0, 6, 0) #prs120, zoned(0, 6, 0)
      *#gebucht, ' ' #MODUS, char('Hause ', 50) #version, zoned(0, 9, 2)
      *#PRS050_A, zoned(0, 6, 0) #PRS070_A,char(' ', 15) #PRS080_A,
      *zoned(0, 6, 0) #prs120_a FROM TVRELWAECO/PKKKUPDout WHERE LIEFERANT
      *='173' and REFERENCE ='TP_073_Ergänzung_PH'
      *1883 Zeilen in E_PREIS in TVRELWAECO eingefügt.
      *****************************************************************

     fe_preis   up   e           k disk    RENAME(e_preis:e_preisr)
     f#PREIL1   uf a e           k disk    RENAME(prei1:phy01r)
     f#PREIL2   uf a e           k disk    RENAME(prei1:phy02r)
     f#PREIL15  uf a e           k disk    RENAME(prei1:phy15r)
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

     c                   if        (%subst(#prs020:4:3) =  'XXX' or
     c                              %subst(#prs020:4:3) =  'xxx'   ) and
     c                              #PRS050 > 0                      and
     c                              %subst(#prs020:1:3) <> 'AKG'
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
     c  n93              z-add     prezpr        #PRS050_A
     c  n93              move      prgada        #PRS070_A
     c  n93              move      prgbda        #PRS120_A

     c                   exsr      sr1500
     c                   if        #PRS030  <> '000'
     C                   movel     #PRS030       PRWACD
     c                   endif

     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     C****BISDAT******   clear                   PRGBDA         Achtung geändert 01.01.2026
     C                   movel     '0'           *in47
     C                   if        *in47 ='0'
     C                   if         %subst(#VERSION:1:8)<>'CURRENCY'
     C   93              write     phy01r
     C  n93              update    phy01r
     C                   else
     C                   unlock    #PREIL1
     C                   unlock    #PREIL2
     C                   endif
     C                   endif
     C
     C                   if        (%subst(#prs020:1:3) =  ' 73' or
     C                              %subst(#prs020:1:3) =  '073' or
     C                              %subst(#prs020:1:3) =  '173' or
     C                              %subst(#prs020:1:3) =  '174' or
     C                              %subst(#prs020:1:3) =  '175' or
     C                              %subst(#prs020:1:3) =  '180' or
     C                              %subst(#prs020:1:3) =  '175'  ) and
     C                              #PRS030 =  '000'
     C                   movel     'SEK'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'USD'         #WAWACD           3
     C                   exsr      sr7000
     c                   movel     'AUD'         #WAWACD           3
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
     C                   movel     'RUB'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'ZAR'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif

     C                   if        (%subst(#prs020:1:3) =  '273' or
     C                              %subst(#prs020:1:3) =  '373'  ) and
     C                              #PRS030 =  '000'
     C                   movel     'USD'         #WAWACD           3
     C                   exsr      sr7000
     c                   movel     'AUD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'JPY'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'SGD'         #WAWACD           3
     C                   exsr      sr7000
     C                   movel     'NZD'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif

     C                   if        (%subst(#prs020:1:3) =  '177' or
     C                              %subst(#prs020:1:3) =  '177'  ) and
     C                              #PRS030 =  '000'
     c                   movel     'AUD'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif

     C                   if        (%subst(#prs020:1:3) =  '176' or
     C                              %subst(#prs020:1:3) =  '176'  ) and
     C                              #PRS030 =  '000'
     c                   movel     'RUB'         #WAWACD           3
     C                   exsr      sr7000
     C                   endif
     C                   endif

     C                   if        (%subst(#prs020:1:3) =  'AKG' or
     C                              %subst(#prs020:1:3) =  'AKG'  ) and
     C                              #PRS030 =  '000'
     c                   exsr      sr1500
     C                   movel     'SEK'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'USD'         #WAWACD           3
     C                   exsr      sr7002
     c                   movel     'AUD'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'PLN'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'PLZ'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'GBP'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'CHF'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'JPY'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'NOK'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'DKK'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'HUF'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'CZK'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'SGD'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'NZD'         #WAWACD           3
     C                   exsr      sr7002
     C                   movel     'RUB'         #WAWACD           3
     C                   exsr      sr7002
     C                   endif


     c                   if        (%subst(#prs020:4:3) <> 'XXX'   and
     c                              %subst(#prs020:4:3) <> 'xxx'   and
     c                              %subst(#prs020:1:3) <> 'AKG'   ) and
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

     C**************************************************************************
     C*fill in
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR

     C                   movel     #prs010       PRFIRM
     C                   movel     'PKG'         PRBEGR
     C                   if        %subst(#prs020:1:3) =  'AKG'
     C                   movel     'AKG'         PRBEGR
     C                   endif
     c                   eval      PRKDLG = '0'         +
     c                              %subst(#prs020:2:2)
     c                   eval      PRKDLG =
     c                              %subst(#prs020:1:3)
     c                   if         %subst(#prs020:1:1) = ' '
     c                   movel     '0'           PRKDLG
     c                   endif
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
     C
     c                   if        prgbda =20000000
     c                   z-add     0             prgbda
     c                   endif
     C
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
     C                   if        %subst(#prs020:1:3) =  'AKG'
     C                   movel     *blank        PRKDLG
     C                   endif

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
     C*********          movel     'PKD'         PRBEGR
     C                   endif
     c                   move      #prs020       #y                6
     c**                 movel     '0'           #y
     c                   movel     #y            PRKDLI
     C                   movel     #prs040       PRTENR
     C                   movel     #prs020       PRKDLI
     C                   movel     'EUR'         PRWACD
     C                   if        #PRS020='191453'
     C                   movel     #PRS030       PRWACD
     C                   endif

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
     C
     c                   if        prgbda =20000000
     c                   z-add     0             prgbda
     c                   endif
     C
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
     c****scholz 28.02.2014
     c                   movel     prgada        WAGADA
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
     C****BISDAT******   clear                   PRGBDA         Achtung geändert 01.01.2026
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
     C* sr7002: ...
     C*-------------------------------------------------------------------------
     C*
     C     sr7002        BEGSR
     C*
     C
     C                   movel     '01'          WAFIRM
     C                   movel     'EUR'         WASTWC
     C                   movel     #WAWACD       WAWACD
     c                   movel     date          WAGADA
     c****scholz 28.02.2014
     c                   movel     prgada        WAGADA
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
     c     key001        chain     #PREIL15                           93
     c                   exsr      sr1500
     C                   movel     #WAWACD       PRWACD
     c                   z-add     whcd_prs      prezpr
     C****BISDAT******   clear                   PRGBDA         Achtung geändert 01.01.2026
     C   93              write     phy15r
     C  n93              update    phy15r
     c                   leave
     c                   else
     c                   endif
     c                   endif
     c                   enddo
     c
     C*
     C     ##7002        ENDSR
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
