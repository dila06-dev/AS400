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
     F*  BENGDSSONR Schnittstelle                                *
     F*                                                          *
     F*  mg01  Anpassung auf Rel 1.2 (Dateierweiterung)          *
     F*        Übergabe von max. 3 Zu.- oder Abschlägen          *
     F*        Änderung: 07.02.2011                              *
     F*        keine nagativen Rabatte möglich                   *
     F*                                                          *
     F*        edvaludatu   initialisiert Berthold 24.03.11      *
     F*        edformatvd    "                                   *
     F*  Korrektur                                               *
     F*  _________                                               *
     F*  SELECT * FROM edi_techps where substr(EDLSNUMMER, 10, 6)*
     F*  in (select rklinr from #afrk11016 where #cc = 8         *
     F*  and rklijj = substr(EDLSNUMMER, 6, 4)                   *
     F*  and rklinr = substr(EDLSNUMMER, 10, 6)                  *
     F*  and RKRGNR = substr(EDBELEGNR, 10, 6)                   *
     F*  and RKRGJJ = substr(EDBELEGNR, 6, 4))                   *
     F*                                                          *
     F*
     F* SELECT RPRGNR ,akrakd, EDI_TECHPS.EDDART, EDI_TECHPS.EDBELEGNR,
     F* EDI_TECHPS.EDRECHNR FROM statistik , edi_techps WHERE (AKAFAT =
     F* '82' and AKRAKD ='011016' ) and rprgnr = substr(edrechnr, 10, 6)
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#afrkhdx  up   e             disk    RENAME(#AFRKHDX  :PHY01R)
     fafrk01    if   e           k disk
     fafrp01    if   e           k disk
     f#aflpL1   if   e           k disk
     fafko01    if   e           k disk
     fafad01    if   e           k disk
     fifap02    if   e           k disk
     f#afulL1   if   e           k disk

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
     Dweek             s              1s 0
     D
     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------aus--#CT0501------------------------------------------------

     c                   if        week   <>9
     c                   if        status = '  '
     c*                  if        rKRGNR = '227453'
     c*                            rKRGNR = '119248' or

     C     *DTAARA       DEFINE                  $AFRhdx          10 0
     C  n25*lock         IN        $AFRhdx
     C  n25              eval      $AFRhdx    =  $AFRhdx     + 1
     C  n25              out       $AFRhdx
     c                   seton                                        25
     c                   exsr      sr1000
     c                   eval      status = '10'
     c                   eval      #cc = $AFRhdx
     c                   seton                                        22
     c   22              update    phy01r

     c                   endif
     c                   endif

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
     c                   exsr      sr3000
     c
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*

     C                   clear                   HDX#
     C                   clear                   FEETBACK
     C                   movel     'R'           eddart           01
     c                   if        AKAFAT    = '11 ' or AKAFAT    = '14 ' or
     c                             AKAFAT    = '17 ' or AKAFAT    = '20 ' or
     c                             AKAFAT    = '71 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '82 ' or AKAFAT    = '50 ' or
     c                             AKAFAT    = '70 ' or AKAFAT    = '99 '
     C                   movel     'G'           eddart
     c                   endif
     c
     c                   move      almaaf        HDX#             20
     c                   if        hdx#  = ' '
     C                   movel     AKREF1        HDX#
     c                   endif
     c                   eval      FEETBACK =    %char(ALLIJJ) +
     c                                           ' '           +
     c                                           ALLINR        +
     c                                           ' '           +
     c                                           %char(ALLIPO) +
     c                                           ' '           +
     c                                           %char(RKRGJJ) +
     c                                           ' '           +
     c                                           RKRGNR        +
     c                                           ' '           +
     c                                            %char(rplipo)
     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0)
     c+ into   :tstampi, :datum, :datum2, :zeit, :week
     c+ from   qsys2/qsqptabl
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     C                   ENDSR

     c




