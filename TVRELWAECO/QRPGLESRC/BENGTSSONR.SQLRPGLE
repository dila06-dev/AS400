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
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     fkalk_file ip   e             disk
     fKALKSCHZU if   e           k disk
     fEPIM      if a e             disk
     F                                     RENAME(EPIM:PHY01R)

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
     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    modus             1
     C                   PARM                    rtncode           1

     I*-------------------------------------------------------------------------
     C                   movel     'Eur'         Waehrung          3
     C                   movel     'DE '         CCode             3
     C                   movel     'D  '         Country           3
     C                   movel     '0'           NewOld            1
     c     code:konv     xlate     ARTNR         ARTNR
     c**** code:konv     xlate     ARTBEZ        ARTBEZ
     I*-------------------------------------------------------------------------
     C                   if        VERSION   = #version  and
     C                             abc       <> 'K'      and
     C                             artgrp    <> 'DRU'    and
     C                             artgrp    <> 'ENT'    and
     C                             artgrp    <> 'PRO'    and
     C                             artgrp    <> 'SON'    and
     C                             artgrp    <> 'WER'    and
     C                             artgrp    <> 'GAR'    and
     C                             artgrp    <> 'LOH'    and
     C                             artgrp    <> 'FRA'    and
     C                             artgrp    <> 'FWL'    and
     C                             artgrp    <> '...'    and
     C                             artgrp    <> '...'
     C                   seton                                        31
     C                   move      anldat        #anldat           4
     C                   if        #anldat       = '0000'
     C                   move      '0101'        anldat
     C                   endif
     C                   if        abc = 'X' and c001 = 0  and
     C                             %date(anldat) < datum2
     C                   setoff                                       31
     C                   endif
     C                   else
     C                   setoff                                       31
     C                   endif
     c   30              exsr      sr_001
     c                   if        #c    > 10
     C                   endif
     c   31              exsr      sr_002
     C                   setoff                                       30
     clr                 exsr      sr_003

     C**************************************************************************
     C* sr_SDG: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
     c                   eval      sentence  =
     c                             '<?xml version="1.0" encoding="UTF-8"?>'
     c                   write     phy01r
     c                   eval      sentence  =
     c                             '<import>                              '
     c                   write     phy01r
     C*
     C     ##_001        ENDSR
     C*
     C**************************************************************************
     C* sr_REF: Artikeldaten
     C*-------------------------------------------------------------------------
     C*
     C     sr_002        BEGSR
     C*
      * :Artikeldaten
     c                   clear                   #artbez         100
     c                   movel     artbez        #artbez         100
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'Ä'
     C                   eval      change = 'Ae'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'ä'
     C                   eval      change = 'ae'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'Ü'
     C                   eval      change = 'Ue'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'ü'
     C                   eval      change = 'ue'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'Ö'
     C                   eval      change = 'Oe'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'ö'
     C                   eval      change = 'oe'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   change            2
     C                   eval      umlaut = 'ß'
     C                   eval      change = 'ss'
     c                   exsr      sr_repl
     C                   clear                   umlaut            1
     C                   clear                   changex           8
     C                   eval      umlaut = '&'
     C                   eval      changex = '&amp;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '"'
     C                   eval      changex = '&quot;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '<'
     C                   eval      changex = '&lt;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = 'ò'
     C                   eval      changex = '&#242;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '>'
     C                   eval      changex = '&gt;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '°'
     C                   eval      changex = '&deg;'
     C                   eval      changex = '&#176;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '²'
     C*gang              eval      changex = '&sup2;'
     C                   eval      changex = '&#178;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '³'
     C                   eval      changex = '&#179;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = 'µ'
     C*gang              eval      changex = '&micro;'
     C                   eval      changex = '&#181;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = 'É'
     C                   eval      changex = ' &#201;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = '§'
     C                   eval      changex = '&sect;'
     c                   exsr      sr_replx
     C                   clear                   umlaut
     C                   clear                   changex
     C                   eval      umlaut = 'ó'
     C                   eval      changex = '&oacute;'
     c                   exsr      sr_replx
     C*
     c*                  eval      sentence  =
     c*                            '<PRV name="'             +
     c*                            %trimr(artbez)            +
     c*                            '" productnr="'           +
     c*                            ARTNR                     +
     c*                            '">'
     c*                  write     phy01r
     C*
     c                   eval      sentence  =
     c                             '<PRV name="'             +
     c                             %trimr(#artbez)           +
     c                             '" productnr="'           +
     c                             ARTNR                     +
     c                             '">'
     c                   write     phy01r
     C*
     c                   clear                   sentence
     C*
     c                   eval      sentence  =
     c                             '<New>'                   +
     c                             NewOld                    +
     c                             '</New>'
     c                   write     phy01r
     C*
     c                   clear                   sentence
     C*
      * :Produktpreis für UNIT und Preis netto
     C                   movel     'Eur'         Waehrung
     c                   eval      sentence  =
     c                             '<product_price_netto unit="'  +
     c                             Waehrung                       +
     c                             '">'                           +
     c                             %char(##art290)                +
     c                             '</product_price_netto>'
     c                   write     phy01r
     C*
     c                   clear                   sentence
     C*
     c                   eval      sentence  =
     c                             '<product_price_country_select>' +
     c                             CCODE                            +
     c                             '</product_price_country_select>'
     c                   write     phy01r
     C*
      * :Produktpreis für UNIT und Preis netto
     c**211010****       clear                   sentence
     c**211010****       eval      sentence  =
     c**211010****                 '<product_price_netto unit="'    +
     c**211010****                 TEMPEK#                          +
     c**211010****                 '">'                             +
     c**211010****                 %char(##art290)                  +
     c**211010****                 '</product_price_netto>'
     c**211010****       write     phy01r
     C*
      * :Produktpreis für Land
     c**211010****       clear                   sentence
     c**211010****       eval      sentence  =
     c**211010****                 '<product_price_country_select>' +
     c**211010****                 Country                          +
     c**211010****                 '</product_price_country_select>'
     c**211010****       write     phy01r
     C*
      * :Statistiknummer
     c                   clear                   sentence
     c                   eval      sentence  =
     c                             '<statistic_group_waeco>'        +
     c                             STATNR                           +
     c                             '</statistic_group_waeco>'
     c                   write     phy01r
     C*
      * :Statistiknummer Dometic
     c                   exsr      sr2202
     c                   clear                   sentence
     c                   eval      sentence  =
     c                             '<statistic_group_dometic>'        +
     c                             DOMSTATNR                        +
     c                             '</statistic_group_dometic>'
     c                   write     phy01r
     C*
      * :obsolete und replacement
     c                   clear                   sentence
     C                   if        abc =  'X' and c001 = 0
     c                   eval      sentence  =
     c                             '<obsolete_flag>'        +
     c                             '1'                              +
     c                             '</obsolete_flag>'
     c                   write     phy01r
     c                   clear                   sentence
     c                   eval      sentence  =
     c                             '<replacement>'     +
     c                             e1                               +
     c                             '</replacement>'
     c                   write     phy01r
     C                   else
     c                   eval      sentence  =
     c                             '<obsolete_flag>'        +
     c                             '0'                              +
     c                             '</obsolete_flag>'
     c                   write     phy01r
     c                   clear                   sentence
     c                   eval      sentence  =
     c                             '<replacement>'     +
     c                             '      '                         +
     c                             '</replacement>'
     c                   write     phy01r
     C                   endif
     C*
     c                   clear                   sentence
     c                   eval      sentence  =
     c                             '</PRV>'
     c                   write     phy01r
     c                   eval      #c  = #c +1
     C*
     C     ##_002        ENDSR
     C*
     C**************************************************************************
     C* sr_003: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_003        BEGSR
     C*
     c                   clear                   sentence
     c***                eval      sentence  =
     c***                          '<total>'     +
     c***                          %char(#c)                      +
     c***                          '</total>'
     c***                write     phy01r
     c                   eval      sentence  =
     c                             '</import>'
     c                   write     phy01r
     C*
     C     ##_003        ENDSR
     C*
     C**************************************************************************
     C* SR2202: KSCHEMA Schema ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     SR2202        BEGSR
     C*
     c     kzuschema     klist
     c                   kfld                    nxt_jahr          4 0
     c                   kfld                    STATNR
     c                   kfld                    §lieferant
     C     *LIKE         DEFINE    lieferant1    §lieferant
     c                   eval      §lieferant = lieferant1
     C*
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   else
     C*
     c                   eval      §lieferant = *blank
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   ENDIF
     C*
     c                   endif
     C*
     C     ##2202        ENDSR
     C*
     C**************************************************************************
     C* sr_repl: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_repl       BEGSR
     C*
     c                   eval      pos = %scan(umlaut: #artbez)
     c                   dow       pos > 0
     c                   eval      #artbez =
     c                             %replace(change: #artbez: pos: +
     c                             %len(umlaut))
     c                   if        (pos+%len(change) > %len(#artbez))
     c                   eval      pos = 0
     c                   else
     c                   eval      pos = %scan(umlaut: #artbez:
     c                             pos+%len(change))
     c                   endif
     c                   enddo
     C*
     C     ##_repl       ENDSR
     C*
     C**************************************************************************
     C* sr_replx: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_replx      BEGSR
     C*
     c                   eval      pos = %scan(umlaut: #artbez)
     c                   dow       pos > 0
     c                   eval      #artbez =
     c                             %replace(changex: #artbez: pos: +
     c                             %len(umlaut))
     c                   if        (pos+%len(changex) > %len(#artbez))
     c                   eval      pos = 0
     c                   else
     c                   eval      pos = %scan(umlaut: #artbez:
     c                             pos+%len(changex))
     c                   endif
     c                   enddo
     C*
     C     ##_replx      ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C                   clear                   #c               10 0
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      nxt_jahr = pjahr + 1

     C                   ENDSR

