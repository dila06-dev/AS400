     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     ffactories uf   e             disk
     f                                     RENAME(factoriesr:phy01r)
     F                                     INFDS(DSF1)
     fPORDB2BV4 uf a e             disk
     f                                     RENAME(PORDB2B:phy02r)
     f***                                  INFDS(DSF1)
     fbbsc      uf a e           k disk    RENAME(bbsc1:phy03r)

     DDate             S               D   DATFMT(*ISO)
     DDate2            S               D   DATFMT(*EUR)
     DDate3            S               D   DATFMT(*iso)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D*-------------------------------------------------------------------------
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     D
     D*-------------------------------------------------------------------------
     DfPos             s              5  0
     DnPos             s              5  0
     Dlength           s              5  0
     DmField           s             30A
     DmScan            S              4a
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     I*-------------------------------------------------------------------------
     C                   DO        *HIVAL
     C
     C                   READ      factories                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        ORDEMPF <> 'ORDEMPF' and
     C                             ORDEMPF <> *blank    and
     C                             h1      =  *blank    and
     C                             F1RRN   >    1
     c                   exsr      sr9999
     c                   clear                   mScan
     c                   clear                   pos
     c*                  eval      mScan  = ' '
     c*                  eval      pos = %scan(mScan: ORDLOSGR)
     c*                  eval      i = 3 - pos + 1
     c*                  eval      %subst(ORDLOSGR:i+1:pos-1) =1
     c*                  eval      ORDLOSGR  =   %trimr(ORDLOSGR)
     c*                  movel     MRDDATBES     #dat             10
     c*                  eval      MRDDATBES =
     c*                            %subst(#dat:9:2)+ '.' +
     c*                            %subst(#dat:6:2)+ '.' +
     c*                            %subst(#dat:1:4)+ '.'
     c*                  movel     MRDDATANL     #dat
     c*                  eval      MRDDATANL =
     c*                            %subst(#dat:9:2)+ '.' +
     c*                            %subst(#dat:6:2)+ '.' +
     c*                            %subst(#dat:1:4)+ '.'
     c                   if        MRDBESNR = *blank
     c                   clear                   MRDBESPOS
     c                   movel     MRDBESMNG     MRDBEDARF
     c                   clear                   MRDBESMNG
     c                   endif
     c                   clear                   ORDABS
     c                   movel     'DE411'       ORDABS
     c                   clear                   ORDDAT
     c                   movel     tstampi       #ORDDAT          26
     c*                  movel     #orddat       ORDDAT
     c                   eval      ORDDAT    =
     c                             %subst(#ORDDAT:9:2)+
     c                             %subst(#ORDDAT:6:2)+
     c                             %subst(#ORDDAT:1:4)+ ' ' +
     c                             %subst(#ORDDAT:12:2) +
     c                             %subst(#ORDDAT:15:2) +
     c                             %subst(#ORDDAT:18:2)
     c                   movel     'PCS   '      ORDMEH
     c                   exsr      sr9999
     C                   movel     tstampi       h6
     C                   movel     datum         h5
     C                   movel     '99'          h1
     C                   movel     tstampi       ORDZU1
     c
     c                   if        MRDDATANL  <> *blank  and
     c                             mrdbesmng  =  *blank  and
     c                             MRDBEDARF  <> *blank  and
     c                             MRDBEDARF  <> '00000000,000' and
     c                             MRDBEDARF  <> '0           '
     C                   movel     '10'          h1
     c                   endif
     C
     c                   if        MRDDATANL  <> *blank         and
     c                             mrdbesmng  <> *blank         and
     c                             mrdbesmng  <> '00000000,000' and
     c                             mrdbesmng  <> '0           '
     C*Bestellung
     C                   movel     '20'          h1
     c                   exsr      sr2000
     c                   endif
     c                   update    phy01r
     C*für Meldung
     c                   if        h1='10'
     c                   clear                   MRDBESNR
     c****               eval      MRDBEDARF = 'Forcast orde'
     c                   endif
     c                   if        h1='20'
     c                   eval      MRDBEDARF = 'New order   '
     c                   eval      MRDBEDARF = '00000000,000'
     c                   endif
     c                   if        h1='10' or h1='20'
     c                   exsr      sr2010
     c                   write     phy02r
     c                   endif
     C
     c                   endif
     c                   endif
     C
     C                   enddo
     C                   EXSR      RETURN
b
     *********************************************************************
     C* SR2000:
     C*-------------------------------------------------------------------

     C     SR2000        BEGSR
     C*
     c                   clear                   phy03r
     c                   movel     date          BBSCueda
     c                   movel     date          BBSCJDAT
     c                   movel     zeit          BBSCJZEI
     c                   movel     tstampi       BBSCTSTP
     C                   movel     §§§usr        BBSCUSER
     C                   movel     §§§pgm        BBSCPROG
     C                   movel     §§§job        BBSCjnam
     C                   movel     §§§LIB        BBSCbibl
      *
      *                  *default
     c                   move      '01'          bbscfirm
     C                   movel     '001'         bbscwknr
      *
     c                   eval      BBSCLFNR   =  %subst(ORDEMPF:3:5)+
     c                             '     '
     c                   move      MRDKDNART     bbsctenr
     c                   movel     mrdbesmng     mrdbesmng1       08
     c                   move      mrdbesmng     mrdbesmng2       03
     c                   movel     mrdbesmng1    mrdbesmng3       08 0
     c                   move      mrdbesmng2    mrdbesmng4       03 0
     c                   z-add     mrdbesmng3    bbscmeng
     c                   add       mrdbesmng4    bbscmeng
     c                   clear                   #dat8             8
     c                   eval      #dat8       =
     c                             %subst(MRDDATANL:7:4)+
     c                             %subst(MRDDATANL:4:2)+
     c                             %subst(MRDDATANL:1:2)
     c                   move      #dat8         BBSCBETE
     C*
     C*Achtung Bestelldatum wird hier richtig übergeben aber sehr
     C*wahrscheinlich nochmals in Trend später konvertiert
     c                   movel     BBSCJDAT      BBSCBEDA
     c                   eval      #dat8       =
     c                             %subst(MRDDATANL:1:2)+
     c                             %subst(MRDDATANL:4:2)+
     c                             %subst(MRDDATANL:7:4)
     c                   move      #dat8         BBSCBEDA
     c                   movel     date          BBSCBEDA
     C*
     c                   write     phy03r
     C*
     C     ##2000        ENDSR

     *********************************************************************
     C* SR2010:
     C*-------------------------------------------------------------------

     C     SR2010        BEGSR
     C*
     C                   select
     C*                 Seitz
     C                   when      %subst(ORDEMPF:1:7) = 'DE90538'
     c                   movel     'DE113       'ORDEMPF
     c                   if        h1  ='10'
     c                   clear                   ORDLOSGR
     c                   endif
     c                   if        h1  ='10'
     c                   clear                   MRDDATBES
     c                   endif
     C*                 Siegen
     C                   when      %subst(ORDEMPF:1:7) = 'DE92005'
     c                   movel     'DE111A      'ORDEMPF
     c                   if        h1  ='10'
     c                   clear                   ORDLOSGR
     c                   endif
     c                   if        h1  ='10'
     c                   clear                   MRDDATBES
     c                   endif
     C*                 ... other
     c                   other
     c                   movel     '??????      'ORDEMPF
     c                   endsl
     C*
     C     ##2010        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
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
     C                   TIME                    Date2

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     c                   exsr      sr9999

     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
