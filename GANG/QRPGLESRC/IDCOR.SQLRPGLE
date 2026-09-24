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

     f#id1500   ip   e             disk
     F                                     RENAME(#id1500:PHY01R)
     f#idco     if a e             disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     d*firma            s                   like(xprs010)

     D umlaut          C                   CONST('äüöÄÜÖß')
     D konv            C                   CONST('auoAUOs')
     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatumi           S               D
     Dzeit             S               T

     D*-------------------------------------------------------------------------
b
     I*-------------------------------------------------------------------------
     c*    umlaut:konv   xlate     ARTBEZ        ARTBEZ
     I*-------------------------------------------------------------------------
     c                   exsr      sr_001
     C**************************************************************************
     C* sr_REF: Artikeldaten
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C*
      * :Artikeldaten
     c                   movel     BUCDAT        REPYEA
     c                   move      BUCDAT        REPMON
     C                   if        jahr$ =    REPYEA   and
     C                             monat$ =   REPMON
     c                   clear                   #idcor
     c                   movel     'DE411 '      DCCODE
     c                   movel     #LBLBTENR     INUMBE
     c     ';':','       xlate     ARTBEZ        ARTBEZ
     c                   movel     ARTBEZ        IDESCR
     c                   movel     idco          IDCO_
     c                   movel     BUCDAT        REPYEA
     c                   move      BUCDAT        REPMON
     c     100           mult      RECMNG        QTY
     c                   movel     #LBLBBWME     UNIT
     c                   if        #LBLBBWME = 'S'
     c                   movel     'PCS'         UNIT
     c                   endif
     c                   if        #LBLBBWME = 'M'
     c                   movel     'M  '         UNIT
     c                   endif
     c                   if        #LBLBBWME = 'K'
     c                   movel     'KG '         UNIT
     c                   endif
     c     100           mult      RECBTR        ACPAID
     c                   movel     WACDEK        CURREN
     c                   if        WACDEK  = '   '
     c                   movel     'EUR'         CURREN
     c                   endif
     c                   if        WACDEK  = 'IUS'
     c                   movel     'USD'         CURREN
     c                   endif
     c                   clear                   STK
     c                   clear                   STKPRI
     c     ';':','       xlate     name          SUPNAM
     c                   movel     PM            SUPTYP
     c                   if        PM      = ' '
     c                   movel     'G'           SUPTYP
     c                   endif
     c                   eval      SUPCOU  = %subst(pname:11:2)
     c                   movel     PNAME         DELTER
     c                   if        delter  = '   '
     c                   movel     'EXW'         DELTER
     c                   endif
     c                   if        delter  = '004' or delter = '006' or
     c                             delter  = '012' or delter = '002'
     c                   movel     'EXW'         DELTER
     c                   endif
     c                   if        delter  = '001'
     c                   movel     'CIP'         DELTER
     c                   endif
     c                   if        delter  = '005'
     c                   movel     'CIF'         DELTER
     c                   endif
     c                   if        delter  = '007'  or delter  = '010'
     c                   movel     'FOB'         DELTER
     c                   endif
     c                   clear                   #h                3
     c                   eval      #h = %subst(pname:6:3)
     c                   movel     ZBD           PAYTER
     c                   clear                   CASHDI
     c                   clear                   GRPCON
     c                   movel     STATNR        PROGRP
     c                   clear                   PURCHC
     c                   movel     #h            SUPCOU
     c                   if        #h = '   '
     c                   movel     'DE'          SUPCOU
     c                   endif
     c                   if        #h = 'I  '
     c                   movel     'IT'          SUPCOU
     c                   endif
     c                   if        #h = 'E  '
     c                   movel     'ES'          SUPCOU
     c                   endif
     c                   if        #h = 'USA'
     c                   movel     'US'          SUPCOU
     c                   endif
     c                   if        #h = 'ROK'
     c                   movel     'KR'          SUPCOU
     c                   endif
     c
     c                   if        #LBLBTENR  <> '999          '
     c                   write     #idcor
     c                   endif
     C                   endif
     c
     C*
     C     ##_001        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C                   clear                   #c               10 0
     C                   clear                   jahr$             4 0
     C                   clear                   monat$            2 0
     c/exec sql
     c+ select current timestamp, current date, current time,
     c+        year(current date -1 month),
     c+        month(current date -1 month)
     c+ into   :tstampi, :datumi, :zeit, :jahr$, :monat$
     c+ from   gang/systempf
     c/end-exec
     C                   ENDSR

