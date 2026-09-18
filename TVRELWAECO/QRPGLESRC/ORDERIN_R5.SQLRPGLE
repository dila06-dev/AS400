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
     F*  SC     Schnittstelle                                    *
     F*                                                          *
     F*  Freischaltung: 003438 BMW                               *
     F*                 022691 John Deere                        *
     F*                 00000 #######                            *
     F*                                                          *
     F************************************************************
     H*datfmt(*iso) timfmt(*iso)
     H*datfmt(*eur) timfmt(*eur)

     fhdxorder  ip   e             disk

     forderh    if a e             disk    RENAME(orderhpf:header)
     forderl    if a e             disk    RENAME(orderlpf:line  )
     fordert    if a e             disk    RENAME(ordertpf:text  )

     D*-------------------------------------------------------------------------
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

     D Chx             DS
     D  chx1                   1     20    INZ('Auftrag in Trend ein')
     D  chx2                  21     40    INZ('geleitet ==> next St')
     D  chx3                  41     50    INZ('ep: ORDERR')

     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'


     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*-------------------------------------------------------------------------

     c                   eval      h050      =   %trim(h050)
     c                   setoff                                       25
     c                   if        h020   =      ###h020   and
     c                             h050   =      ###h050
     c                   seton                                        25
     c                   endif
     c  n25              exsr      srheader
     c  n25              write     header
     c  n25              exsr      sr_save

     c                   exsr      srline
     c                   write     line
     c                   z-add     h020          ###h020
     c                   movel     h050          ###h050
     c                   clear                   h240
     c                   clear                   h040

     c                   setoff                                       30
     c   30              exsr      srtext
     c   30              write     text

     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     srheader      BEGSR
      *
     c                   move      h030          ##h030            6
     c                   movel     ##h030        AKKDNR           10
     c                   CALL      'HDXZKUNR'                           97
     c                   PARM                    AKKDNR
     c
     c                   movel     'H'           h010
     c                   if        h040  = 0
     c                   move      h030          h040
     c                   endif

     c                   movel     h050          h050
     c***                linksbündige *blanks werden eleminiert
     c                   eval      h050      =   %trim(h050)
     c                   if        H030 = 55278 or H030 = 78146
     c                   eval      h050      =   %trim(%char (jahr)) +
     c                                           %trim(h050)
     c                   endif
     c                   if        h140 = 'F  '
     c                   movel     'FR '         H140
     c                   endif
     c                   if        h140 = 'D  '
     c                   movel     'DE '         H140
     c                   endif

     c                   movel     zeit          h070
     c
     c                   if        h240   =   *blanks
     c***                linksbündige *blanks werden eleminiert
     c***                Referenze
     c                   eval      h240      =   %subst(h240:1:6) +
     c                                           '          '
     c*****              wieder zurück  14.12.2015
     c                   eval      h240      =   %trim(h050)
     c*****              wieder zurück  13.01.2016  für bestimmte Kunden JIS
     c                   if        H040      =   001075 or
     c                             H040      =   082157
     c                   eval      h240      =   %subst(h240:1:8) +
     c                                           '          '
     c                   endif
     c                   endif
     c                   eval      h330i    = %XLATE(lo:up:h330i)
     c                   eval      H300      =   %trim(H330i)
     c
     c                   if        H300    =     'HOFFMANNDI'  or
     c                             H300    =     'ANDERS    '  or
     c                             H300    =     'AXMANN    '  or
     c                             H300    =     'CUNI      '  or
     c                             H300    =     'REMKE     '
     c*********          if        H040 = 42326  and
     c*********                    H300 <>    'REMKE     '
     c*********          z-add     09592         H040
     c*********          z-add     09592         H020
     c*********          endif
     c                   if        H040 = 42326
     c                   z-add     09592         H040
     c                   z-add     09592         H020
     c                   endif
     c                   if        H040 = 22691
     c                   z-add     22691         H040
     c                   endif
     c                   if        H040 = 22691
     c                   z-add     22691         H040
     c                   endif
     c                   endif
     c
     c                   clear                   H310
     c                   movel     h310          H310
     c                   movel     'HDXORDER'    H330
     c*
     c                   eval      %subst(h310:417:03) = '   '
     c                   if        %trim(LIEFER) = 'Frei Haus '
     c                   eval      %subst(h310:417:03) = '001'
     c                   endif
     c*
     C                   select
     C                   when      %trim(LIEFER) = 'CFR       '
     C                   eval      h230 = '21'
     C                   when      %trim(LIEFER) = 'CIF       '
     C                   eval      h230 = '16'
     C                   when      %trim(LIEFER) = 'CIP       '
     C                   eval      h230 = '25'
     C                   when      %trim(LIEFER) = 'CPT       '
     C                   eval      h230 = '24'
     C                   when      %trim(LIEFER) = 'DAF       '
     C                   eval      h230 = '28'
     C                   when      %trim(LIEFER) = 'DDP       '
     C                   eval      h230 = '20'
     C                   when      %trim(LIEFER) = 'DDU       '
     C                   eval      h230 = '19'
     C                   when      %trim(LIEFER) = 'DEQ       '
     C                   eval      h230 = '30'
     C                   when      %trim(LIEFER) = 'DES       '
     C                   eval      h230 = '29'
     C                   when      %trim(LIEFER) = 'EXW       '
     C                   eval      h230 = '02'
     C                   when      %trim(LIEFER) = 'FCA       '
     C                   eval      h230 = '22'
     C                   when      %trim(LIEFER) = 'FOB       '
     C                   eval      h230 = '10'
     c                   other                                                  %found(WAECOLCP)
     C                   eval      h230 = '02'
     c                   ENDsl                                                  %found(WAECOLCP)
     C* Versandbedingung Spedition
     C* Aendungen 20240201 integration EINZELLIEF bis gln
     C                   eval      %subst(h310:417:10) = EINZELLIEF
     C                   eval      %subst(h310:428:05) = LIEFERPOS
     C                   eval      %subst(h310:433:10) = BESTELLPOS
     C                   eval      %subst(h310:444:10) = GLN
     c*
     c                   movel     EINZELLIEF    h210
     c                   if        EINZELLIEF    <>   *blank
     c                   movel     'H'           H220
     c                   endif
     c*
     c                   eval      %subst(h310:501:12) =zipcode
     c                   if        H310a <> *blank
     c                   eval      %subst(h310:480:05) ='Werk:'
     c                   eval      %subst(h310:485:07) =
     c                             %subst(h310a:001:07)
     c                   endif
     c                   if        H310b <> *blank
     c                   eval      %subst(h310:491:04) ='ALS:'
     c                   eval      %subst(h310:495:06) =
     c                             %subst(h310b:001:06)
     c                   endif
     c*
     c                   movel     '99'          h350
     c                   movel     '  '          h350
     c                   if        H040 = 22691 or H040 = 03438
     c*****              movel     '  '          h350
     c                   endif
     c                   z-add     02            h030
     c                   movel     date          h360
     c                   movel     tstampi       h370


     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*

     c                   movel     'L'           L010
     c***                linksbündige *blanks werden eleminiert
     c                   eval      l040      =   %trim(l040)
     c                   movel     h050          L040
     c                   movel     h030          L250
     c                   z-add     02            l250
     c*                  if        L250 = 55278 or L250 = 78146
     c*                  eval      l040      =   %trim(%char (jahr)) +
     c*                                          %trim(l040)
     c*                  endif
     c                   if        L050  > 9999
     c                   eval      L050  = l050 /100
     c                   endif

     c                   movel     L070          L070
     c***                linksbündige *blanks werden eleminiert
     c                   eval      L080      =   %trim(L080)
     c                   eval      l150      =   %trim(L080III)

     c                   movel     'HDXORDER'    L160
     c                   movel     '99'          L240
     c                   movel     '  '          L240
     c                   if        h040 = 22691 or h040 = 03438
     c***                movel     '  '          L240
     c                   endif
     c                   if        preis > 0
     c                   z-add     preis         L210
     c                   endif
     C                   eval      %subst(l150:415:10) = EINZELLIEF
     C                   eval      %subst(l150:428:05) = LIEFERPOS
     C                   eval      %subst(l150:433:15) = BESTELLPOS
     c                   movel     date          L180
     c                   movel     tstampi       L190
     c                   movel     date          L200

     C     ##line        ENDSR

     C**************************************************************************
     C*text
     C*-------------------------------------------------------------------------
     C*
     C     srtext        BEGSR
      *
     c                   clear                   text


     c                   movel     'T'           h010
     c                   eval      t020      =   h030
     c***                linksbündige *blanks werden eleminiert
     c                   if        T020 = 55278 or T020 = 78146
     c                   eval      T030      =   %trim(%char (jahr)) +
     c                                           %trim(T030)
     c                   endif
     c*
     c                   movel     '99'          T350
     c                   if        T020 = 22691 or T020 = 03438
     c                   movel     '99'          T350
     c                   endif
     c                   movel     date          T040
     c                   movel     zeit          T050
     c                   movel     tstampi       t370

     C     ##text        ENDSR

     C**********************************************************************
     C*Sicherung nach Auftragserzeugung und Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_save       BEGSR
      *
     C                   movel     h020          #h030             7
     C                   clear                   md
     C                   movea(p)  'ORDERIN_R5'  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C                   movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(099)
     C                   movea(p)  #h030         md(100)
     C                   movea(p)  h050          md(106)
     C                   MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
      *
     C     ##_save       ENDSR
     C
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   exsr      sr9999
     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     c                   clear                   ###h020           7 0
     c                   clear                   ###h050          10

     C                   ENDSR

