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
      * update               bar_kalk/kalk_file b set buchung2 =
      * (select BUCHUNG2 from RPMKALKUL a where    artnr=WAOFVEUR and
      *  version='$$EL_PS_DB')
      * where exists
      * (select BUCHUNG2 from RPMKALKUL a where    artnr=WAOFVEUR and
      *  version='$$EL_PS_DB')
      * 47323 Zeilen in KALK_FILE in BAR_KALK aktualisiert.
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * SELECT JAHR, LIEFNR, ARTNR, artsku, ARTBEZ,sys01 IDART, ARTGRP,
      * STATNR, ABC, KALK_FILE.KSCHEMA, ULAND, LIEFERANT1, LIEFERANT2,
      * KALK_FILE.ZOLLNR, ARTZ1, ARTZ2, ARTZ3, WACDVK, WACDEK, WEKPR,
      * DATUMV, FRACHTSATZ, FRACHT, ZOLLSATZ, ZOLL, VERSICHERU, KCJUMS_VJ,
      * KCJUMS_AJ, ANLDAT, STK_LCP_A, CCSTCK, CWSTCK2,beistell,
      * WAOFVEUR, WAOFWF01, WAOFWF02, WAOFWF03, WAOFWF04 EKPR, WAOFWF05
      * FRACHT, WAOFWF06 ZOLL , WAOFWF07 VERS, WAOFWF09 BEZK, WAOFWF16
      * LOHN, WAOFWF11 STK1, WAOFWF12 FGK , WAOFWF13 MGK, WAOFWF14 STK3,
      * WAOFWF17, dec(0, 3, 0) #invart, char(' ', 1) #typ, current
      * timestamp p,
      * dec(0, 11, 2) #UDSTKMAT,dec(0, 11, 2) #UDSTKLHN,
      * dec(0, 11, 2) #UDSTKWKZG,dec(0, 11, 2) #UDSTKWKZU,
      * dec(0, 11, 2) #UDSTKENTG,dec(0, 11, 2) #UDSTKENTU,
      * dec(0, 11, 2) #UDSTKLIC,dec(0, 11, 2) #UDSTKFRA,
      * dec(0, 11, 2) #UDFERGKF,dec(0, 11, 2) #UDFERGKV,
      * dec(0, 11, 2) #UDFERLOH,dec(0, 11, 2) #UDMATGKO,
      * dec(0, 11, 2) #UDMATKOS,
      * dec(0, 11, 2) #UDSTK,dec(0, 11, 2) #UDSTK1,dec(0, 11, 2) #UDSTK2,
      * dec(0, 11, 2) #UDSTK3
      * FROM bar_kalk/kalk_file, waof WHERE version =
      * '$$EL_PS_DB' and ARTNR = WAOFVEUR and (WAOFKAJJ concat '/' concat
      * WAOFKANR) = buchung2
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fKALKOUTPU#uf   e             disk
     f                                     RENAME(KALKOUTPU#:phy01r)
     f***                                  INFDS(DSF1)
     f                                     USROPN
     fprj015p   uf   e           k disk
     f***                                  INFDS(DSF1)
     fkalk_file2if   e           k disk
     f
     fTeuf00    if   e           k disk

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
     I*-------------------------------------------------------------------------
     D pc            E DS                  EXTNAME(PRJ015p)
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
     iKALK_F1
     i              ekpr                        §ekpr
     i*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Aufbau
     c                   exsr      sr1000
     C*update(!)
     c*******            exsr      sr2000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     C                   open      KALKOUTPU#

     C                   DO        *HIVAL
     C                   READ      KALKOUTPU#                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        ARTNR <>'##-029-04PP8G'
     C                   movel     artsku        artnumI          10 0
     C                   z-add     artnumI       artnum
     c     artnum        chain     prj015p
     C                   if         %found(prj015p)
     C                   clear                   typ               1
     C                   clear                   BUDSTKMAT
     C                   clear                   BUDSTKLHN
     C                   clear                   BUDSTKFRA
     C                   clear                   BUDSTK
     C                   clear                   BUDMATKOS
     C                   clear                   BUDFERLOH
     C                   clear                   BUDFERGKV
     C                   clear                   BUDSTK1
     C                   clear                   BUDFERGKF
     C                   clear                   BUDMATGKO
     C                   clear                   BUDSTK2
     C                   clear                   BUDSTK3
     C*Zuweisungen Dollar
     C                   if        WACDEK   = 'USD'
     C***                eval(H)   ekpr =  ekpr*1,15/1,301
     C                   endif
     C*Zuweisungen Case
     C                   if        ARTGRP   = 'FWK' or ARTGRP = 'LOH'  or
     C                             ARTGRP   = 'DRU' or ARTGRP = 'WER'  or
     C                             ARTGRP   = 'SON' or ARTGRP = 'GAR'  or
     C                             ARTGRP   = 'PRO' or ARTGRP = 'CDR'
     C*                 unter Betriebsstoffen
     C******             eval      idart   = 'H '
     C                   endif
     C                   if        ARTZ1   = 'EIPROD' and LOHN > 0
     C*                 unter Fertigwaren
     C******             eval      idart   = '1 '
     C                   endif
     C*                 verlängerte Werkbank
     C                   if        idart =  '2 ' and beistell > 0
     C******             eval      idart   = '9 '
     C                   endif
     C                   if        EKPR-BEISTELL  = 0  or
     C                             EKPR-BEISTELL  < 0
     C*                 unter Fertigwaren, wenn ekpreis 0< Beistellung
     C******             eval      idart   = '2 '
     C                   endif
     C*                 derzeit fix, da keiner pflegt
     C                   clear                   lcp230           1102
     C                   eval      lcp230  =(0,44   * CWSTCK2)
     C*ACHTUNG(!)
     C*************      goto      tagx
     C*Zuweisungen Case
     C                   select
     C                   when      idart =  '1 '
     c*                 *** Fertigwaren                                      */
     c                   eval      TYP   = 'F'
     c                   eval(H)   BUDmatkos=EKPR+FRACHT01+ZOLL01+VERS
     c                   eval(H)   BUDFERLOH=LOHN
     c                   eval(H)   BUDFERGKF=FGK
     c                   eval(H)   BUDMATGKO=MGK
     c                   eval(H)   BUDSTK3  =STK3
     c                   eval(H)   BUDSTK1  =BUDMATKOS+BUDFERLOH
     c                   eval(H)   BUDSTK2  =BUDSTK1  +BUDFERGKF+BUDMATGKO
     c                   movel     '300'         invart
     c                   movel     'E'           BA
     c*                 *** Handelsware                                      */
     C                   when      idart =  '2 '
     c                   eval      TYP   = 'V'
     c                   eval(H)   BUDSTKMAT=EKPR
     c                   eval(H)   BUDSTKFRA=FRACHT01+ZOLL01+VERS
     c                   eval(H)   BUDMATGKO=MGK
     c                   eval(H)   BUDSTK   =STK3
     c                   eval(H)   BUDSTK1  =STK3
     c                   eval(H)   BUDSTK2  =STK3
     c                   eval(H)   BUDSTK3  =STK3
     c                   movel     '700'         invart
     c                   movel     'Z'           BA
     c*                 *** Rohstoffe                                        */
     C                   when      idart =  '3 '
     c                   eval      TYP   = 'R'
     c                   eval(H)   BUDSTKMAT=EKPR
     c                   eval(H)   BUDSTKFRA=FRACHT01+ZOLL01+VERS
     c                   eval(H)   BUDSTK   =STK3-MGK
     c                   eval(H)   BUDSTK3  =STK3-MGK
     c                   movel     '011'         invart
     c                   movel     'Z'           BA
     c*                 *** (verlängerte Werkbank)                           */
     C                   when      idart =  '9 '
     c                   eval      TYP   = 'R'
     c                   eval(H)   BUDSTKFRA=FRACHT01+ZOLL01+VERS
     c                   eval(H)   BUDSTKLHN=(EKPR-BEISTELL)
     c                   eval(H)   BUDFMDLOH=BUDSTKLHN+BUDSTKFRA
     c                   eval(H)   BUDMATKOS=EKPR-(EKPR-BEISTELL)
     c                   eval(H)   BUDFERLOH=LOHN
     c                   eval(H)   BUDFERGKF=FGK
     c                   eval(H)   BUDMATGKO=MGK
     c                   eval(H)   BUDstkMAT=BUDMATKOS+LOHN+FGK+MGK
     c                   eval(H)   BUDSTK   =BUDstkMAT+BUDSTKLHN+BUDSTKFRA
     c                   eval(H)   BUDSTK1  =BUDMATKOS+BUDFERLOH+BUDFMDLOH
     c                   eval(H)   BUDSTK2  =BUDSTK1  +BUDFERGKF+BUDMATGKO
     c                   eval(H)   BUDSTK3  =BUDSTK2
     c                   movel     '428'         invart
     c                   movel     'A'           BA
     c*                 *** Hilfs. und Betriebsstoffe                        */
     C                   when      idart =  'H '
     c                   eval      TYP   = 'B'
     c                   eval(H)   BUDSTKMAT=ekpr
     c                   eval(H)   BUDSTKFRA=FRACHT01+ZOLL01+VERS
     c                   eval(H)   BUDFERLOH=LOHN
     c                   eval(H)   BUDFERGKF=FGK
     c                   eval(H)   BUDMATGKO=MGK
     c                   eval(H)   BUDSTK   =STK3
     c                   eval(H)   BUDSTK3  =STK3
     c                   movel     '800'         invart
     c                   movel     'Z'           BA
     c                   other
     c                   endsl
     c*                 *** übergabe in excel Tabelle                        */
     c                   z-add     invart        #invart
     c                   movel     typ           #typ
     c                   z-add     BUDSTKMAT     #UDSTKMAT
     c                   z-add     BUDSTKLHN     #UDSTKLHN
     c                   z-add     BUDSTKFRA     #UDSTKFRA
     c                   z-add     BUDSTK        #UDSTK
     c                   z-add     BUDMATKOS     #UDMATKOS
     c                   z-add     BUDFERLOH     #UDFERLOH
     c                   z-add     BUDFERGKV     #UDFERGKV
     c                   z-add     BUDSTK1       #UDSTK1
     c                   z-add     BUDFERGKF     #UDFERGKF
     c                   z-add     BUDMATGKO     #UDMATGKO
     c                   z-add     BUDSTK2       #UDSTK2
     c                   z-add     BUDSTK3       #UDSTK3
     c
     c*                 *** übergabe aus Budgetfelder                        */
     c                   z-add     BUDfmdloh     lfdfmdloh
     c                   z-add     BUDSTKMAT     lfdSTKMAT
     c                   z-add     BUDSTKLHN     lfdSTKLHN
     c                   z-add     BUDSTKFRA     lfdSTKFRA
     c                   z-add     BUDSTK        lfdSTK
     c                   z-add     BUDMATKOS     lfdMATKOS
     c                   z-add     BUDFERLOH     lfdFERLOH
     c                   z-add     BUDFERGKV     lfdFERGKV
     c                   z-add     BUDFERGKF     lfdFERGKF
     c                   z-add     BUDMATGKO     lfdMATGKO
     c                   z-add     BUDSTK        lfdSTK
     c                   z-add     BUDSTK1       lfdSTK1
     c                   z-add     BUDSTK2       lfdSTK2
     c                   z-add     BUDSTK3       lfdSTK3
     c*
     c*                 *** Budgetfelder initialisieren                      */
     c***                clear                   BUDfmdloh
     c****               clear                   BUDSTKMAT
     c*                  clear                   BUDSTKLHN
     c**                 clear                   BUDSTKFRA
     c***                clear                   BUDSTK
     c**                 clear                   BUDMATKOS
     c***                clear                   BUDFERLOH
     c**                 clear                   BUDFERGKV
     c***                clear                   BUDFERGKF
     c**                 clear                   BUDMATGKO
     c***                clear                   BUDSTK
     c**                 clear                   BUDSTK1
     c***                clear                   BUDSTK2
     c*                  clear                   BUDSTK3
     c
     c     tagx          tag
     C     ',':'.'       xlate     ARTBEZ        ARTBEZ                 70
     C     '"':' '       xlate     ARTBEZ        ARTBEZ                 70
     c
     c                   if        (invart <>  999 )
     C*                  if             (ARTNR = '9102900268' or
     C*                                  ARTNR = '9102600002' or
     C*                                  ARTNR = '9108024168' or
     C*                                  ARTNR = '9108014673' or
     C*                                  ARTNR = '9108014708' or
     C*                                  ARTNR = '9105600005'  )
     c                   exsr      sr1150
     c                   update    phy01r
     c                   setoff                                       77
     c                   seton                                        77
     c   77              update    prj015f
     C                   else
     C*****              delete    phy01r
     C                   endif
     c
     C                   endif
     C                   endif
     C                   endif
     C                   enddo
     c                   close     KALKOUTPU#

     C     ##1000        ENDSR


     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr1150        BEGSR
     C*
     c     KEY1150       klist
     c                   kfld                    version
     c                   kfld                    artnr
     c                   movel     '$$EL_PS_DB'  version
     C*
      *                 Kalk_file2                                            
     c     KEY1150       chain     kalk_file2
     C
     c                   IF        %found(kalk_file2)
     C                   exsr      sr1500
     C                   endif
     C*
     C     ##1150        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr1500        BEGSR
     C*
      *                 tempek   nach  prsenh, enh2                           
     C                   movel     TEMPEK#       x                 2
     C                   movel     ersetz        X
     C                   eval      %subst(x: 2: 1)= ' '
     C                   exsr      sr1600
     C                   movel     x             prsenh
     C                   movel     x             enh2
     C                   if        enh2  <>      basenh
     C                   if        basenh = 'DM' and enh2   = 'M '
     C                   z-add     10            fak2
     C                   endif
     C                   if        basenh = 'DM' and enh2   = 'CM'
     C                   z-add     0,10          fak2
     C                   endif
     C                   if        basenh = 'CM' and enh2   = 'M '
     C                   z-add     100           fak2
     C                   endif
     C                   if        basenh = 'CM' and enh2   = 'DM'
     C                   z-add     10            fak2
     C                   endif
     C                   if        basenh = 'M ' and enh2   = 'DM'
     C                   z-add     0,10          fak2
     C                   endif
     C                   if        basenh = 'M ' and enh2   = 'CM'
     C                   z-add     0,01          fak2
     C                   endif
     C                   else
     C                   clear                   enh2
     C                   endif
     c
     C                   if        basenh = 'DM' and prsenh = 'M '
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'DM' and prsenh = 'CM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'CM' and prsenh = 'M '
     C                   z-add     100           efak2
     C                   endif
     C                   if        basenh = 'CM' and prsenh = 'DM'
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'M ' and prsenh = 'DM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'M ' and prsenh = 'CM'
     C                   z-add     0,01          efak2
     C                   endif
     C*
      *                 temeek   nach  prsenh, enh2                           
      *       SELECT basenh, eeinh2, count(*) FROM prodtst88/prj015p GROUP    
      *       BY basenh, eeinh2 ORDER BY basenh, eeinh2                       
     C                   movel     temeek#       x
     C                   eval      %subst(x: 2: 1)= ' '
     C                   exsr      sr1600
     C                   movel     x             eeinh2
      *                                                                        
     C                   if        eeinh2<>      basenh and
     C                             eeinh2  <>    *blank
     C                   if        basenh = 'DM' and eeinh2 = 'M '
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'DM' and eeinh2 = 'CM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'CM' and eeinh2 = 'M '
     C                   z-add     100           efak2
     C                   endif
     C                   if        basenh = 'CM' and eeinh2 = 'DM'
     C                   z-add     10            efak2
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'DM'
     C                   z-add     0,10          efak2
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'CM'
     C                   z-add     0,01          efak2
     C                   endif
     C                   if        basenh = 'ST' and eeinh2 = 'M '
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'ST' and eeinh2 = 'KG'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'M ' and eeinh2 = 'ST'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   if        basenh = 'KG' and eeinh2 = 'ST'
     C                   exsr      sr5900
     c                   IF        %found(teuf00)
     C                   z-add     TUUFAK        efak2
     c                   ENDIF
     C                   endif
     C                   endif
      *                 faktoren Konvertierung                                
     C                   movel     FAKTOR#EK     faktor#
     C                   if        faktor# = ' '
     C                   movel     '1'           faktor#
     C                   endif
     c                   if        faktor#='1'
     C                   z-add     0             prsfak
     c                   endif
     c                   if        faktor#='2'
     C                   z-add     1             prsfak
     c                   endif
     c                   if        faktor#='3'
     C                   z-add     2             prsfak
     c                   endif
     c                   if        faktor#='4'
     C                   z-add     3             prsfak
     c                   endif
     c                   if        faktor#='5'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '01000'
     c                   endif
     c                   if        faktor#='6'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '10000'
     c                   endif
     c                   if        faktor#='7'
     c                   z-add     1             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00005'
     c                   endif
     c                   if        faktor#='8'
     c                   z-add     2             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00025'
     c                   endif
     c                   if        faktor#='9'
     c                   z-add     3             prsfak
     c                   eval      %subst(bez3: 10: 05) = '00500'
     c                   endif
     C*
     C                   movel     'ST '         ptprsenh
     C*
     c                   eval      ptprsenh = prsenh
     c                   eval      ptprsfak = prsfak
     C*
     C     ##1500        ENDSR

     C**************************************************************************
     C* sr1600: Mengeneinheiten
     C*-------------------------------------------------------------------------
     C*
     C     SR1600        BEGSR
     C*
     C                   select
     C                   when      x        = 'B '
     C                   movel     '10'          x
     C                   when      x        = 'C '
     C                   movel     'CL'          x
     C                   when      x        = 'D '
     C                   movel     'DM'          x
     C                   when      x        = 'G '
     C                   movel     'GR'          x
     C                   when      x        = 'K '
     C                   movel     'KG'          x
     C                   when      x        = 'N '
     C                   movel     'ML'          x
     C                   when      x        = 'S '
     C                   movel     'ST'          x
     C                   when      x        = 'Z '
     C                   movel     'CM'          x
     C                   other
     C                   eval      %subst(x: 2: 1)= ' '
     C                   endsl
     C*
     C     ##1600        ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ update teil  set testpr =
     c+  (select max(#UDSTK3) from tvrelwaeco/KALKoutpu#
     c+   where tetenr = artnr and TEFIRM ='01'
     c+         group by artnr)
     c+    where exists
     c+  (select max(#UDSTK3) from tvrelwaeco/KALKoutpu#
     c+   where tetenr = artnr and TEFIRM ='01'
     c+         group by artnr)
     c/end-exec

     c/exec sql
     c+ update prodwin51/prj015p set
     c+       lfdSTKMAT   =     BUDSTKMAT,
     c+       lfdSTKLHN   =     BUDSTKLHN,
     c+       lfdSTKFRA   =     BUDSTKFRA,
     c+       lfdSTK      =     BUDSTK   ,
     c+       lfdMATKOS   =     BUDMATKOS,
     c+       lfdFERLOH   =     BUDFERLOH,
     c+       lfdFERGKV   =     BUDFERGKV,
     c+       lfdSTK1     =     BUDSTK1  ,
     c+       lfdFERGKF   =     BUDFERGKF,
     c+       lfdMATGKO   =     BUDMATGKO,
     c+       lfdSTK2     =     BUDSTK2  ,
     c+       lfdSTK3     =     BUDSTK3
     c+ where artnum in ( select artsku from kalkoutpu#)
     c/end-exec

     C     ##2000        ENDSR

     C**************************************************************************
     C* SR5900: teuf00 Mengeneinheiten
     C*-------------------------------------------------------------------------
     C*
     C     SR5900        BEGSR
     C*
     c*  Schlüsselliste für teuf00
     c     key5900       klist
     c                   kfld                    tufirm
     c                   kfld                    tuTENR
     c                   kfld                    tumein

     C                   movel     '01'          tufirm
     c                   movel     artnr         tuTENR
     c                   movel     eeinh2        tumein

     c     KEY5900       chain     teuf00
     c                   IF        %found(teuf00)
     c                   ENDIF

     C*
     C     ##5900        ENDSR

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
