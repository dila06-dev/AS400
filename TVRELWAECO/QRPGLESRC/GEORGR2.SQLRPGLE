     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:
     F*
     F*  ---------- Schnittstelle
     F*SELECT   PRTENR, PRGADA, PRWACD, PREZPR
     F* FROM    prei01
     F*WHERE    PRFIRM ='55' and PRBEGR ='PVK' and
     F*         (PRGBDA = 0 or PRGBDA > 20151028) and
     F*          PRWACD ='CHF'
     F*ORDER BY prtenr,PRGADA desc
     F*Datei THEOXX in TVRELWAECO
     F*
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     ftheoxx    ip   e             disk
     F                                     RENAME(theoxx:PHY00R)
     fgeorg2    if a e             disk
     F                                     RENAME(georg2:PHY01R)
     fgrpp01    if   e           k disk    RENAME(grpp1:phy03r)
     F
     fkond01    if   e           k disk    RENAME(kond1:phy04r)
     F

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
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     Derror            S              1a
     D
     C*-------------------------------------------------------------------------
b

     I*-------------------------------------------------------------------------
     c**** code:konv     xlate     ARTNR         ARTNR
     c**** code:konv     xlate     ARTBEZ        ARTBEZ
     I*-------------------------------------------------------------------------
     c
     C                   clear                   #vrg             13 2
     C                   if        PRTENR    <> #prtenr
     c     keygrpp       klist
     c                   kfld                    #firma            2
     c                   kfld                    PRTENR
     c                   eval      #firma  = '55'
     C     keygrpp       SETLL     grpp01                             95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      grpp01                                 95
     C     *IN95         IFEQ      '1'
     C     GRPPFIRM      orne      #firma
     C     GRPPTENR      orne      PRTENR
     C                   leave
     C                   else
     C  n95              exsr      kondition
     C                   endif
     C                   enddo
     C                   endif
     c                   exsr      sr_001
     c
     C                   endif

     C**************************************************************************
     C* sr_SDG: Sendungssatz
     C*-------------------------------------------------------------------------
     C*
     C     sr_001        BEGSR
     C                   clear                   #PREZPR          1302
     C                   eval(h)   #PREZPR =(PREZPR+#vrg) * 1,08
     c                   eval      a     =   '"' +
     c                                       %trimr(PRTENR) +
     c                                       '$'            +
     c                                       %char(#PREZPR) +
     c                                       '$'            +
     c                                       '           '  +
     c                                       %char(PREZPR)  +
     c                                       '           '  +
     c                                       %char(#vrg)    +
     c                                       '           '  +
     c                                       GRPPGPMG
     c                   write     phy01r
     c                   clear                   a
     c                   clear                   #vrg
     c                   clear                   GRPPGPMG
     C                   movel     PRTENR        #prtenr          15
     C*
     C     ##_001        ENDSR
     C*
     C**************************************************************************
      * :Nachnahme über wao8 bei sales companies
      * :
     C*-------------------------------------------------------------------------
     C*
     C     kondition     BEGSR
     C*
     c
      * :lesen Lieferscheindaten
     c     k_KOND01      klist
     c                   kfld                    KOFIRM
     c                   kfld                    KOBEGR
     c                   kfld                    KOPSLI
     c                   kfld                    KOABTL
     c                   kfld                    KOLAND
     c                   kfld                    KOBLGA
     c                   kfld                    KOKDLI
     c                   kfld                    KOVSNR
     c                   kfld                    KOPJNR
     c                   kfld                    KOKDLG
     c                   kfld                    KOPRGR
     c                   kfld                    KOMAGR
     c                   eval      kofirm ='55'
     c                   eval      KOBEGR ='VRG'
     c                   clear                   KOPSLI
     c                   clear                   KOABTL
     c                   clear                   KOLAND
     c                   clear                   KOBLGA
     c                   clear                   KOKDLI
     c                   clear                   KOVSNR
     c                   clear                   KOPJNR
     c                   clear                   KOKDLG
     c                   clear                   KOPRGR
     c                   clear                   KOMAGR
     c                   eval      komagr = GRPPGPMG
     c
     c     k_KOND01      chain     KOND01

      /free
          IF        %found(KOND01);
             monitor;
                Date_in_V=%date(%char(KOGADA):*iso0);
             On-error *all;
                error='1';
             endmon;
             monitor;
                Date_in_B=%date(%char(KOGBDA):*iso0);
             On-error *all;
                error='1';
                if       KOGBDA =0;
                   error='0';
                   Date_in_B=%date() + %days(365);
                endif;
             endmon;
             if error ='0';
                if Date_in_V > %date() - %days(0);
                   error='1';
                endif;
                if Date_in_B < %date() + %days(1);
                   error='1';
                endif;
             endif;
             if error ='0';
                eval      #vrg   =  #vrg + KORABA;
             endif;
          endif;

      /end-free
     c*
     C     ##_kond       ENDSR
     C**************************************************************************
     C*
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

