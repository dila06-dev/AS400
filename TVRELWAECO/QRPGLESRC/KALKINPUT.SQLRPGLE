     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
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
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fKALKOUTPUTuf   e             disk
     f                                     RENAME(KALKOUTPUT:phy01r)
     f                                     INFDS(DSF1)
     F                                     USROPN
     f#PREIL1   if   e           k disk    RENAME(prei1:log01r)
     f#PREIL3   if   e           k disk    RENAME(prei1:log03r)

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
     D
     d#073             s                   like(PREZPR)
     d#073_von         s                   like(PRGADA)
     d#073_bis         s                   like(PRGBDA)
     d#173             s                   like(PREZPR)
     d#173_von         s                   like(PRGADA)
     d#173_bis         s                   like(PRGBDA)
     d#273             s                   like(PREZPR)
     d#273_von         s                   like(PRGADA)
     d#273_bis         s                   like(PRGBDA)
     d#373             s                   like(PREZPR)
     d#373_von         s                   like(PRGADA)
     d#373_bis         s                   like(PRGBDA)
     d#400             s                   like(PREZPR)
     d#400_von         s                   like(PRGADA)
     d#400_bis         s                   like(PRGBDA)
     d#EVP             s                   like(PREZPR)
     d#evp_von         s                   like(PRGADA)
     d#evp_bis         s                   like(PRGBDA)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
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
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr1000
     c

     C                   open      KALKOUTPUT
     C                   DO        *HIVAL
     C
     C                   READ      KALKOUTPUT                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c                   exsr      sr7000
     c                   update    phy01r
     c                   endif
     C
     C                   enddo
     C                   close     KALKOUTPUT

     C                   EXSR      RETURN

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ INSERT INTO TVRELWAECO/KALKOUTPUT
     c+ SELECT JAHR,LIEFNR,ARTNR, ARTSKU,ARTBEZ,SYS01 IDART, ARTGRP,
     c+ STATNR, ABC, KALK_FILE.KSCHEMA,ULAND,LIEFERANT1, LIEFERANT2,
     c+ KALK_FILE.ZOLLNR, ARTZ1, ARTZ2, ARTZ3, WACDVK, WACDEK, WEKPR,
     c+ DATUMV,FRACHTSATZ,FRACHT,ZOLLSATZ,ZOLL,VERSICHERU, KCJUMS_VJ,
     c+ KCJUMS_AJ, ANLDAT, STK_LCP_A, CCSTCK, CWSTCK2,BEISTELL,
     c+ WAOFVEUR,WAOFWF01,WAOFWF02,WAOFWF03,WAOFWF04 EKPR, WAOFWF05
     c+ FRACHT,WAOFWF06 ZOLL,WAOFWF07 VERS, WAOFWF09 BEZK, WAOFWF16
     c+ LOHN,WAOFWF11 STK1,WAOFWF12 FGK, WAOFWF13 MGK, WAOFWF14 STK3,
     c+ WAOFWF17, DEC(0, 3, 0) #INVART, CHAR(' ', 1) #TYP, CURRENT
     c+ TIMESTAMP P,
     c+ DEC(0, 11, 2) #UDSTKMAT,DEC(0, 11, 2) #UDSTKLHN,
     c+ DEC(0, 11, 2) #UDSTKWKZG,DEC(0, 11, 2) #UDSTKWKZU,
     c+ DEC(0, 11, 2) #UDSTKENTG,DEC(0, 11, 2) #UDSTKENTU,
     c+ DEC(0, 11, 2) #UDSTKLIC,DEC(0, 11, 2) #UDSTKFRA,
     c+ DEC(0, 11, 2) #UDFERGKF,DEC(0, 11, 2) #UDFERGKV,
     c+ DEC(0, 11, 2) #UDFERLOH,DEC(0, 11, 2) #UDMATGKO,
     c+ DEC(0, 11, 2) #UDMATKOS,
     c+ DEC(0, 11, 2) #UDSTK,DEC(0, 11, 2) #UDSTK1,DEC(0, 11, 2)
     c+ #UDSTK2,
     c+ DEC(0, 11, 2) #UDSTK3,WAOFFIRM,WAOFKAJJ,WAOFKANR,
     c+ DEC(0, 11, 2) #0173, DEC(0, 11, 2) #0273,
     c+ DEC(0, 11, 2) #0373, DEC(0, 11, 2) #0400
     c+ FROM BAR_KALK/KALK_FILE, #RP0555 WHERE VERSION = '$$EL_PS_DB'
     c+ AND ARTNR = WAOFVEUR
     c+ AND (WAOFFIRM = '01' or WAOFFIRM ='51')
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set   LIEFNR= 'EL ' where a.artnr
     c+  in (select artnr from kalkinput)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set    ekpr =
     c+ (select max(ekpr) from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+  where exists
     c+ (select max(ekpr) from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set FRACHT01 =
     c+  (select max(FRACHT01) from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(FRACHT01) from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set ZOLL01   =
     c+  (select max(ZOLL01)   from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(ZOLL01)   from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set VERS     =
     c+  (select max(VERS)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(VERS)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set BEZK     =
     c+  (select max(BEZK)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(BEZK)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set LOHN     =
     c+  (select max(LOHN)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(LOHN)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set STK1     =
     c+  (select max(STK1)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(STK1)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set FGK      =
     c+  (select max(FGK)      from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(FGK)      from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set MGK      =
     c+  (select max(MGK)      from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(MGK)      from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     c/exec sql
     c+ update kalkoutput a  set STK3     =
     c+  (select max(STK3)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c+   where exists
     c+  (select max(STK3)     from kalkinput b where a.artnr=b.artnr
     c+  group by b.artnr)
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C* SR7000:
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
     C*
     c     key7000       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA
     c****               kfld                    PRKDLG

     c                   movel     '01'          PRFIRM
     c                   movel     'PKG'         PRBEGR
     c                   movel     artnr         PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     c                   clear                   #073
     c                   clear                   #073_von
     c                   clear                   #073_bis
     c                   clear                   #173
     c                   clear                   #173_von
     c                   clear                   #173_bis
     c                   clear                   #273
     c                   clear                   #273_von
     c                   clear                   #273_bis
     c                   clear                   #373
     c                   clear                   #373_von
     c                   clear                   #373_bis
     c                   clear                   #400
     c                   clear                   #400_von
     c                   clear                   #400_bis
     c                   clear                   #EVP
     c                   clear                   #evp_von
     c                   clear                   #evp_bis

     C     KEY7000       SETLL     #PREIL1                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL1                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PKG'
     c     PRTENR        orne      artnr
     c     PRWACD        orne      'EUR'
     c*    PRWACD        orne      KDWACD
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     C                   if        PRKDLG = '073'
     C                   eval      #073     =      PREZPR
     C                   eval      #073_von =      PRGADA
     C                   eval      #073_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '173'
     C                   eval      #173     =      PREZPR
     C                   eval      #0173    =      PREZPR
     C                   eval      #173_von =      PRGADA
     C                   eval      #173_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '273'
     C                   eval      #273     =     PREZPR
     C                   eval      #0273    =     PREZPR
     C                   eval      #273_von =     PRGADA
     C                   eval      #273_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '373'
     C                   eval      #373     =     PREZPR
     C                   eval      #0373    =     PREZPR
     C                   eval      #373_von =     PRGADA
     C                   eval      #373_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '400'
     C                   eval      #400     =     PREZPR
     C                   eval      #0400    =     PREZPR
     C                   eval      #400_von =     PRGADA
     C                   eval      #400_bis =     PRGBDA
     C                   endif
     C
     C                   endif
     C                   endif
     C                   enddo
     C                   endif

     c                   movel     '01'          PRFIRM
     c                   movel     'PVK'         PRBEGR
     c                   movel     artnr         PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA

     C     KEY7000       SETLL     #PREIL3                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL3                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PVK'
     c     PRTENR        orne      artnr
     c     PRWACD        orne      'EUR'
     C                   leave
     C                   else
     c                   if        artnr='9103300448'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      #EVP    =      PREZPR
     C                   eval      #evp_von=      PRGADA
     C                   eval      #evp_bis=      PRGBDA
     C                   endif
     C                   endif
     C                   enddo
     C                   endif

     C*
     C     ##7000        ENDSR
     C*
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

     C**************************************************************************
     C*.
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

     c                   eval      pjahr = pjahr + 0
     c                   clear                   xp                8 0
     c                   eval      xp=(pjahr*10000)+(pmonat*100)+ptag
     c*                  move      '0101'        xp

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
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
