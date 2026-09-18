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
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE) DFTACTGRP(*NO)

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
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D**********************************************************************
     D ConvertTemp     pr                                                       Kommunikation
     d  tempIn                       28    const
     d  tempOut                      28
     p ConvertTemp     b                   export
     d  ConvertTemp    pi
     d  tempIn                       28    const
     d  tempOut                      28
     d tempI           s              8P 2
     d tempO           s              8P 2
     d value           ds
     D  tetenr                 1     15a
     D  quantity              16     28s04
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

      /Free
         value = %str(%ADDR(tempIn));
          Exsr sr1000;
          %STR(%ADDR(tempOut):25)=tempOut;
          *inlr=*on;
      /End-Free

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C                   CALL      'WAO00D'
     C                   PARM                    TETENR
     C                   PARM                    quantity         13 4
     C*
     C     ##1000        ENDSR
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

     p convertTemp     e

