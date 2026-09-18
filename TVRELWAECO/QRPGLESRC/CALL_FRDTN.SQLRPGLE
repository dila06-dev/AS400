     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
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
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

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
     D info            DS
     D  infox                  1     50
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I*-------------------------------------------------------------------------
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   eval      p_Firm  = '01'
     c                   move      'k12016bbb'   x                09
     c                   eval      P_Jahr             =
     c                             %dec(%subst(x:3:4):4:0)
     c                   eval      p_Komnr   ='119375'
     C*Absatz/Umsatzdaten
     c                   call      'LFFRDTN'
     C                   PARM                    p_Firm            2
     C                   PARM                    P_Jahr            4 0
     C                   PARM                    p_Komnr           6
     C                   PARM      *zero         p_KomDat          8 0
     C                   PARM      *zero         P_Jahr_Or         4 0
     C                   PARM      *Blank        p_Order           6
     C                   PARM      *zero         P_Jahr_LF         4 0
     C                   PARM      *Blank        p_Lief            6
     C                   PARM      *zero         p_LiefDat         8 0
     C                   PARM      *zero         P_Jahr_RE         4 0
     C                   PARM      *Blank        p_Rech            6
     C                   PARM      *zero         p_RechDat         8 0
     C                   PARM      *Blank        p_kunde          10
     C                   PARM      *Blank        p_sped#          10
     C                   PARM      *Blank        P_vsbd           10
     C                   PARM      *zero         p_cod             9 2
     C                   PARM      *zero         p_ZBPRZ           9 2
     C                   PARM      *zero         p_rfrebt         12 4
     C                   PARM      *Blank        p_RKWACD         03
     C                   PARM      *zero         p_nn             12 4
     C                   PARM      *Blank        p_invnr          15
     C                   PARM      *Blank        p_cc              1

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
     C*-------------------------------------------------------------------------


     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------


     C**************************************************************************
     C*.
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

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
