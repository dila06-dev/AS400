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

     fconr_ar   ip   e             disk
     F                                     RENAME(CONR_AR_EX:PHY01R)
     fconr_ar#  if a e             disk
     F                                     RENAME(CONR_AR#:PHY02R)

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
     Iphy02r
     I              CONR_AR#                    sentence
     I
     C*-------------------------------------------------------------------------
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
     c                   eval      sentence  =
     c                             %trimr(ARTIKELNR)         +
     c                             ';'                       +
     c                             %trimr(%char(BESTAND))    +
     c                             ';'                       +
     c                             %trimr(Datum)
     c                   write     phy02r
     C*
     c                   clear                   sentence
     C*
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
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datumi, :zeit
     c+ from   sbghel00
     c/end-exec
     C                   ENDSR

