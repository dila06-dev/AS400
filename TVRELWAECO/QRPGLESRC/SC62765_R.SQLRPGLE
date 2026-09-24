     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  lesen bezug Interface ifap -3-                          *
     F*   keysr_ifap    klist                                    *
     F*                 kfld                    RKFIRM           *
     F*                 kfld                    RPAFJJ           *
     F*                 kfld                    RPAFNR           *
     F*                 kfld                    ALAFPO           *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#AFRK62765up   e             disk    RENAME(#AFRK62765:PHY01R)
     fdom005    if a e             disk    RENAME(RUE00R1:PHY02R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     fafko01    if   e           k disk
     fafad01    if   e           k disk
     fifap02    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------

     c                   if        status = '  '

     C     *DTAARA       DEFINE                  $AFRK62765       10 0
     C  n25*lock         IN        $AFRK62765
     C  n25              eval      $AFRK62765 = $AFRK62765 + 1
     C  n25              out       $AFRK62765
     c                   seton                                        25
     C                   setoff                                       47
     c                   exsr      sr1000
     c                   eval      status = '10'
     c                   eval      #cc = $AFRK62765
     c                   update    phy01r

     c                   endif
     Clr                 out       unique_f
     C*****lr                 exsr      sr1500

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_afrk    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     C*
      * :Rechnungskopf  -1-
     c     keysr_afrk    chain     AFRK01                             92
     C*
      * :Rechnungspositionen -2-
     c                   if        *in92 = '0'
     C     keysr_afrk    SETLL     AFRP01                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      AFRP01                                 95
     C                   IF        *in95 = '1'            or
     C                             RKFIRM   <>  RpFIRM    or
     C                             RKRGJJ   <>  RpRGJJ    or
     C                             RKRGNR   <>  RpRGNR    or
     C                             RKLIJJ   <>  RpLIJJ    or
     C                             RKLINR   <>  RpLINR
     C                   leave
     C                   else
     c                   exsr      sr_002
     c                   endif
     c                   enddo
     c                   endif
     c                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_002        BEGSR
     C*
      * :lesen ob Position im Lieferschein vorhanden ( nicht bei
      * :Gutschriften oder Nichlagerführungsartikel )
      * :Auftragslieferpositionen -3-
     c     keysr_aflp    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RKRGJJ
     c                   kfld                    RKRGNR
     c                   kfld                    RKLIJJ
     c                   kfld                    RKLINR
     c                   kfld                    Rplipo
     c     keysr_aflp    chain     #aflpl1                            96
     c   96              clear                   aflp1
     C*
      * :Kopfdaten Auftrag
     c     keysr_afko    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR

     c     keysr_afko    chain     afko01                             96
     c   96              clear                   afko1
     C*
     C*
      * :Lieferadresse/Adresse bill
     c     keysr_afad    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR
     c                   kfld                    adposi
     c                   kfld                    adaart

     c                   clear                   adposi
     c                   movel     'ADAG'        adaart

     c     keysr_afad    chain     afad01                             97
     c   97              clear                   afad1
     C*
      * :lesen bezug Interface ifap -3-
     c     keysr_ifap    klist
     c                   kfld                    RKFIRM
     c                   kfld                    RPAFJJ
     c                   kfld                    RPAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_ifap    chain     ifap02                             97
     c   97              clear                   ifap1
     c   97              clear                   IFAPIFPO
      * :in jedem Fall lt. Trend
     C*
     c     ' ':'0'       xlate     ALMAAF        #almaaf          10
     c                   testn                   #almaaf              20
     c   20              movel     #ALMAAF       RUEAUFN
     c   20              move      #ALMAAF       RUEAUFTL
     c                   eval      RUEAAPN = IFAPIFPO / 10
     c                   clear                   RUEARTN
     c
     c                   movel     ALTENR        ruewinanr
     c                   z-add     alglmg        rueglmg
     c                   movel     ALLSDA        ruelied
     c     ' ':'0'       xlate     ALFIRM        #alfirm           2
     c                   movel     #ALFIRM       ruewinfa
     c                   movel     ALRAKD        #ruewin           6
     c                   move      #ruewin       ruewinkdn
     c                   move      ALAFNR        ruewinauf
     c                   movel     AKAFAT        ruewinaa
     c                   z-add     ALAFPO        ruewinpos
     c     ' ':'0'       xlate     RKRGNR        #RKRGNR           6
     c                   movel     #RKRGNR       ruewinrg
     c                   z-add     alntsk        ruewinprs
     c
     c                   write     phy02r
     c     linecount     add       1             linecount        10 0
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
     C*Funktion *insert
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##1500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1500
     c/end-exec

     c/exec sql
     C+        insert into tvrelwaeco/dom005
     C+ SELECT zoned(substr(IFAPIFNR, 1, 7), 7, 0),
     C+        zoned(substr(IFAPIFNR, 8, 3), 3, 0),
     C+        zoned(IFAPIFPO/10, 5, 1),
     c+        zoned(0, 11, 0),
     c+        IFAPTENR,
     c+        zoned(IFAPBSMG, 8, 3),
     c+        zoned(IFAPERDA, 8, 0),
     c+        zoned(IFAPFIRM, 2, 0),
     c+        zoned(IFAPIFFI, 5, 0),
     c+        zoned(IFAPAFNR, 6, 0),
     c+        zoned(08, 2, 0),
     c+        zoned(IFAPAFPO, 3, 0),
     c+        zoned(0, 6, 0),
     c+        zoned(0, 9, 2)
     4+
     4+       FROM ifap
     C+       WHERE IFAPIFFI = '62765' and
     C+       digits(IFAPERDA) = substr(char(current date, iso), 1, 4)concat
     C+                          substr(char(current date, iso), 6, 2)concat
     C+                          substr(char(current date, iso), 9, 2)
     C+       and ifAPAFNR not in
     C+       (select alAFNR from aflp where alAFJJ = ifAPAFJJ and
     C+                                      ALAFPO = ifAPAFPO and
     C+                                      allinr in
     C+       (select RkLINR from afrk where RKFIRM = alfirm and
     C+                                      RKRGJJ = alRGJJ and
     C+                                      RKLIJJ = allijj and
     C+                                      RKRGNR = alRGNR    ))
     c/end-exec
     C*
     c/exec sql
     C+ update tvrelwaeco/dom005 set  RUEARTN   =
     C+ (select dec(IFEPIDEN) from ifep
     C+ WHERE digits(RUEAUFN)=substr(IFEPIFNR, 1, 7) and RUEWINPOS=IFEPIFPO)
     C+ where exists
     C+ (select dec(IFEPIDEN) from ifep
     C+ WHERE digits(RUEAUFN)=substr(IFEPIFNR, 1, 7) and RUEWINPOS=IFEPIFPO)
     c/end-exec

     C     ##1500        ENDSR

     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C     *DTAARA       DEFINE                  unique_f         10 0
     C     *lock         IN        unique_f
     C
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

