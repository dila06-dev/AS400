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
     fgeorg     if a e             disk
     F                                     RENAME(georg:PHY01R)

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

     I*-------------------------------------------------------------------------
     c     code:konv     xlate     ARTNR         ARTNR
     c**** code:konv     xlate     ARTBEZ        ARTBEZ
     I*-------------------------------------------------------------------------
     C                   if        VERSION   = '$$EL_PS_DB'
     C                   if        STATNR  <>    '420'   and
     C                             STATNR  <>    '204'
     c   30              exsr      sr_001
     C                   endif
     C                   endif

     C**************************************************************************
     C* sr_SDG: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C                   z-add     evp_aj        #evp_aj           9 3
     c                   eval      a     =   '"' +
     c                                       %trimr(artnr) +
     c                                       '"'           +
     c                                       ','           +
     c                                       '"'           +
     c                                       uland         +
     c                                       '"'           +
     c                                       ','           +
     c                                       %char(#evp_aj)
     c                   write     phy01r
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
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C*******            eval      nxt_jahr = pjahr + 1

     C                   ENDSR

