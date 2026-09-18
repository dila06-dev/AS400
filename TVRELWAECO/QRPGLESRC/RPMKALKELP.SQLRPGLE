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
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      * SELECT * from prj015p
      * Datei #PRJ015P in TVRELWAECO wurde erstellt. 25.01.2017
      *
      *****************************************************************
     h  option(*SRCSTMT:*NoDebugIO)

     fRPMKALKELPuf   e             disk
     f                                     RENAME(RPMKALKELP:phy01r)
     f***                                  INFDS(DSF1)
     f                                     USROPN
     fprj015p   uf   e           k disk
     f***                                  INFDS(DSF1)
     f***kalk_file2if   e           k disk
     fteil01    if   e           k disk
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
      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying


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
     i*KALK_F1
     i*              ekpr                        §ekpr
     i*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Aufbau
     c
     c*************      exsr      sr_stueckl
     C*Ablauf
     c                   exsr      sr1000
     C*update(!)
     c*****              exsr      sr2000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR


     C                   open      RPMKALKELP

     C                   DO        *HIVAL
     C                   READ      RPMKALKELP                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        WAOFVEUR <>'TP-3820-500'
     C                   movel     artsku        artnumI          10 0
     C                   z-add     artnumI       artnum
     c     artnum        chain     prj015p
     C                   if         %found(prj015p)
     C                   clear                   typ               1
     C                   clear                   lfdSTKMAT
     C                   clear                   lfdSTKLHN
     C                   clear                   lfdSTKFRA
     C                   clear                   lfdSTK
     C                   clear                   lfdMATKOS
     C                   clear                   lfdFERLOH
     C                   clear                   lfdFERGKV
     C                   clear                   lfdSTK1
     C                   clear                   lfdFERGKF
     C                   clear                   lfdMATGKO
     C                   clear                   lfdSTK2
     C                   clear                   lfdSTK3
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
     C*******20170125    eval      id_art  = 'H '
     C                   endif
     C                   if        ARTZ1   = 'EIPROD' and LOHN > 0
     C*                 unter Fertigwaren
     C*******20170125    eval      id_art  = '1 '
     C                   endif
     C*                 verlängerte Werkbank
     C                   if        id_art=  '2 ' and beistell > 0
     C*******20170125    eval      id_art  = '9 '
     C                   endif
     C                   if        EK  -BEISTELL  = 0  or
     C                             EK  -BEISTELL  < 0
     C*                 unter Fertigwaren, wenn ekpreis 0< Beistellung
     C*******20170125    eval      id_art  = '2 '
     C                   endif
     C*                 derzeit fix, da keiner pflegt
     C                   clear                   lcp230           1102
     C*****              eval      lcp230  =(0,44   * CWSTCK2)
     C*                  aus kalkulationsergebnis
     C                   eval      lcp230  = lohn
     C*ACHTUNG(!)
     C*************      goto      tagx
     C*Zuweisungen Case
     C                   select
     C                   when      id_art=  '1 '
     c*                 *** Fertigwaren                                      */
     c******nicht änd.   eval      TYP   = 'F'
     c                   eval(H)   lfdmatkos=EK  +FRACHT+ZOLL+WAOFWF07
     c                   eval(H)   lfdFERLOH=LOHN
     c                   eval(H)   lfdFERGKF=FGK
     c                   eval(H)   lfdMATGKO=MGK
     c                   eval(H)   lfdSTK3  =ST3_KALK
     c                   eval(H)   lfdSTK1  =lfdMATKOS+lfdFERLOH
     c                   eval(H)   lfdSTK2  =lfdSTK1  +lfdFERGKF+lfdMATGKO
     c******nicht änd.   movel     '300'         invart
     c******nicht änd.   movel     'E'           BA
     c                   movel     '300'         #invart
     c                   movel     'E'           #BA
     c*                 *** Handelsware                                      */
     c*                 *** in Stücklist als Hauptartikel                    */
     c*                 *** eval(H)   aus lp1  =EK                           */
     c*                 *** eval(H)   lfdFMDLOH=lfdSTKLHN+lfdSTKFRA          */
     c*                 *** eval(H)   lfdFMDLOH=lfdSTKLHN+lfdSTKFRA          */
     C                   when      id_art=  '2 '
     c******nicht änd.   eval      TYP   = 'V'
     c                   eval(H)   lfdSTKMAT=EK
     c                   eval(H)   lfdSTKFRA=FRACHT+ZOLL+WAOFWF07
     c                   eval(H)   lfdMATGKO=MGK
     c                   eval(H)   lfdSTK   =ST3_KALK
     c                   eval(H)   lfdSTK1  =ST3_KALK
     c                   eval(H)   lfdSTK2  =ST3_KALK
     c                   eval(H)   lfdSTK3  =ST3_KALK
     c******nicht änd.   movel     '700'         invart
     c******nicht änd.   movel     'Z'           BA
     c                   movel     '700'         #invart
     c                   movel     'Z'           #BA
     c*                 *** Rohstoffe                                        */
     C                   when      id_art=  '3 '
     c******nicht änd.   eval      TYP   = 'R'
     c                   eval(H)   lfdSTKMAT=EK
     c                   eval(H)   lfdSTKFRA=FRACHT+ZOLL+WAOFWF07
     c                   eval(H)   lfdSTK   =ST3_KALK-MGK
     c*******ina?        eval(H)   .....    =MGK
     c******nicht änd.   movel     '011'         invart
     c******nicht änd.   movel     'Z'           BA
     c                   movel     '011'         #invart
     c                   movel     'Z'           #BA
     c*                 *** (verlängerte Werkbank)                           */
     C                   when      id_art=  '9 '
     c******nicht änd.   eval      TYP   = 'R'
     c                   eval(H)   lfdSTKFRA=FRACHT+ZOLL+WAOFWF07
     c                   eval(H)   lfdSTKLHN=(EK  -BEISTELL)
     c                   eval(H)   lfdFMDLOH=lfdSTKLHN+lfdSTKFRA
     c                   eval(H)   lfdMATKOS=EK  -(EK  -BEISTELL)
     c                   eval(H)   lfdFERLOH=LOHN
     c                   eval(H)   lfdFERGKF=FGK
     c                   eval(H)   lfdMATGKO=MGK
     c                   eval(H)   lfdstkMAT=lfdMATKOS+LOHN+FGK+MGK
     c                   eval(H)   lfdSTK   =lfdstkMAT+lfdSTKLHN+lfdSTKFRA
     c                   eval(H)   lfdSTK1  =lfdMATKOS+lfdFERLOH+lfdFMDLOH
     c                   eval(H)   lfdSTK2  =lfdSTK1  +lfdFERGKF+lfdMATGKO
     c                   eval(H)   lfdSTK3  =lfdSTK2
     c******nicht änd.   movel     '428'         invart
     c******nicht änd.   movel     'A'           BA
     c                   movel     '428'         #invart
     c                   movel     'A'           #BA
     c*                 *** Hilfs. und Betriebsstoffe                        */
     C                   when      id_art=  'H '
     c******nicht änd.   eval      TYP   = 'B'
     c                   eval(H)   lfdSTKMAT=ek
     c                   eval(H)   lfdSTKFRA=FRACHT+ZOLL+WAOFWF07
     c                   eval(H)   lfdFERLOH=LOHN
     c                   eval(H)   lfdFERGKF=FGK
     c                   eval(H)   lfdMATGKO=MGK
     c                   eval(H)   lfdSTK   =ST3_KALK
     c                   eval(H)   lfdSTK3  =ST3_KALK
     c******nicht änd.   movel     '800'         invart
     c******nicht änd.   movel     'Z'           BA
     c                   movel     '800'         #invart
     c                   if        statnr = '906'
     c                   if        artgrp = 'KAT'
     c                   movel     '801'         #invart
     c                   movel     '801'         invart
     c                   endif
     c                   if        artgrp = 'DIS'
     c                   movel     '802'         #invart
     c                   movel     '802'         invart
     c                   endif
     c                   if        artgrp = 'VER'
     c                   movel     '803'         #invart
     c                   movel     '803'         invart
     c                   endif
     c                   if        artgrp = 'MAR'
     c                   movel     '804'         #invart
     c                   movel     '804'         invart
     c                   endif
     c                   movel     'Z'           #BA
     c                   other
     c                   endsl
     c*                 *** übergabe in excel Tabelle                        */
     c******nicht änd.   z-add     invart        #invart
     c******nicht änd.   movel     typ           #typ
     c                   z-add     lfdSTKMAT     #UDSTKMAT
     c                   z-add     lfdSTKLHN     #UDSTKLHN
     c                   z-add     lfdSTKFRA     #UDSTKFRA
     c                   z-add     lfdSTK        #UDSTK
     c                   z-add     lfdMATKOS     #UDMATKOS
     c                   z-add     lfdFERLOH     #UDFERLOH
     c                   z-add     lfdFERGKV     #UDFERGKV
     c                   z-add     lfdSTK1       #UDSTK1
     c                   z-add     lfdFERGKF     #UDFERGKF
     c                   z-add     lfdMATGKO     #UDMATGKO
     c                   z-add     lfdSTK2       #UDSTK2
     c                   z-add     lfdSTK3       #UDSTK3
     c
     c*                 *** übergabe aus fixgetfelder   fix==>bud            */
     c                   z-add     lfdfmdloh     lfdfmdloh
     c                   z-add     lfdSTKMAT     lfdSTKMAT
     c                   z-add     lfdSTKLHN     lfdSTKLHN
     c                   z-add     lfdSTKFRA     lfdSTKFRA
     c                   z-add     lfdSTK        lfdSTK
     c                   z-add     lfdMATKOS     lfdMATKOS
     c                   z-add     lfdFERLOH     lfdFERLOH
     c                   z-add     lfdFERGKV     lfdFERGKV
     c                   z-add     lfdFERGKF     lfdFERGKF
     c                   z-add     lfdMATGKO     lfdMATGKO
     c                   z-add     lfdSTK        lfdSTK
     c                   z-add     lfdSTK1       lfdSTK1
     c                   z-add     lfdSTK2       lfdSTK2
     c                   z-add     lfdSTK3       lfdSTK3
     c
     c*                 *** fixgetfelder initialisieren                      */
     c****               clear                   lfdfmdloh
     c****               clear                   lfdSTKMAT
     c****               clear                   lfdSTKLHN
     c****               clear                   lfdSTKFRA
     c****               clear                   lfdSTK
     c****               clear                   lfdMATKOS
     c****               clear                   lfdFERLOH
     c****               clear                   lfdFERGKV
     c****               clear                   lfdFERGKF
     c****               clear                   lfdMATGKO
     c****               clear                   lfdSTK
     c****               clear                   lfdSTK1
     c****               clear                   lfdSTK2
     c****               clear                   lfdSTK3
     c
     c     tagx          tag
     C     ',':'.'       xlate     ARTBEZ        ARTBEZ                 70
     C     '"':' '       xlate     ARTBEZ        ARTBEZ                 70
     c
     c                   if        (invart <>  999 )
     C*                  if             (WAOFVEUR = '9102900268' or
     C*                                  WAOFVEUR = '9102600002' or
     C*                                  WAOFVEUR = '9108024168' or
     C*                                  WAOFVEUR = '9108014673' or
     C*                                  WAOFVEUR = '9108014708' or
     C*                                  WAOFVEUR = '9105600005'  )
     c******nicht änd.   exsr      sr1150
     c                   setoff                                       77
     c                   seton                                        77
     c   77              update    phy01r
     c   77              update    prj015f
     C                   else
     C*****              delete    phy01r
     C                   endif
     c
     C                   endif
     C                   endif
     C                   endif
     C                   enddo
     c                   close     RPMKALKELP

     C     ##1000        ENDSR


     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr1150        BEGSR
     C*
     c***  KEY1150       klist
     c***                kfld                    version
     c***                kfld                    WAOFVEUR
     c***                movel     '$$EL_PS_DB'  version
     C*
     c     KEY1150b      klist
     c                   kfld                    WAOFFIRM
     c                   kfld                    WAOFVEUR
     C*
      *                 Kalk_file2                                            
     c***  KEY1150       chain     kalk_file2
     C
     c***                IF        %found(kalk_file2)
     C***                exsr      sr1500
     C***                endif
     C*
      *                 teil_file2                                            
     c     KEY1150b      chain     teil01
     C
     c                   IF        %found(teil01)
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
     C*****              movel     TEMPEK#       x                 2
     C                   movel     TEMPEK        x                 2
     C*****              movel     ersetz        X
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
     C***                movel     temeek#       x
     C                   movel     temeek        x
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
     c+  (select max(#UDSTK3) from tvrelwaeco/RPMKALKELP
     c+   where tetenr = WAOFVEUR and TEFIRM ='01'
     c+         group by WAOFVEUR )
     c+    where exists
     c+  (select max(#UDSTK3) from tvrelwaeco/RPMKALKELP
     c+   where tetenr = WAOFVEUR and TEFIRM ='01'
     c+         group by WAOFVEUR )
     c/end-exec

     C                   goto      ##2000

     c/exec sql
     c+ update prodwin51/prj015p set
     c+       lfdSTKMAT   =     lfdSTKMAT,
     c+       lfdSTKLHN   =     lfdSTKLHN,
     c+       lfdSTKFRA   =     lfdSTKFRA,
     c+       lfdSTK      =     lfdSTK   ,
     c+       lfdMATKOS   =     lfdMATKOS,
     c+       lfdFERLOH   =     lfdFERLOH,
     c+       lfdFERGKV   =     lfdFERGKV,
     c+       lfdSTK1     =     lfdSTK1  ,
     c+       lfdFERGKF   =     lfdFERGKF,
     c+       lfdMATGKO   =     lfdMATGKO,
     c+       lfdSTK2     =     lfdSTK2  ,
     c+       lfdSTK3     =     lfdSTK3
     c+ where artnum in ( select artsku from RPMKALKELP)
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
     c                   movel     WAOFVEUR      tuTENR
     c                   movel     eeinh2        tumein

     c     KEY5900       chain     teuf00
     c                   IF        %found(teuf00)
     c                   ENDIF

     C*
     C     ##5900        ENDSR
     C**************************************************************************
     C*vorher Stücklistenkalkulation
     C*-------------------------------------------------------------------------

     C     sr_stueckl    BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##_stueckl
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*
     c                   clear                   status          120
      /FREE
       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(bar_kalk/SLAZS)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
       on-error;
          status='Error by rmvlnk object                           ';
       endmon;
      /End-FREE

     c                   call      'STR_STUECK'

     c/exec sql
     c+ update  bar_kalk/SLAZS set SLAZJZEI = 010101
     c/end-exec

      /FREE
       MONITOR;
       Wrk.var1 =
           'CRTDUPOBJ OBJ(SLAZS) FROMLIB(BAR_KALK) OBJTYPE(*FILE)' +
           ' TOLIB(QTEMP) NEWOBJ(SLAZS) DATA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
       on-error;
          status='Error by rmvlnk object                           ';
       endmon;
      /End-FREE

     c/exec sql
     c+ insert into qtemp/SLAZS
     c+ SELECT DISTINCT * FROM bar_kalk/SLAZS
     c/end-exec

     c/exec sql
     c+ delete FROM bar_kalk/SLAZS
     c/end-exec

     c/exec sql
     c+ insert into bar_kalk/SLAZS
     c+ select * FROM qtemp/SLAZS
     c/end-exec

     c                   exsr      sr_KALKELP

     C     ##_stueckl    ENDSR

     C**************************************************************************
     C*aus letztem Kalkulationsergebnis
     C*aus letzter Stücklisternrecherche
     C*-------------------------------------------------------------------------

     C     sr_KALKELP    BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ delete from tvrelwaeco/RPMKALKELP
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMKALKELP
     c+ SELECT WAOFFIRM, WAOFBERE, WAOFKAJJ, WAOFKANR, WAOFVEUR, ARTBEZ,
     c+ ARTGRP, STATNR, ABC, BUCHUNG2, ULAND, LIEFERANT1, LIEFERANT2,
     c+ ZOLLNR, ARTZ1, WACDEK, EK_WAECO_IMPEX, KURS, EK_PREIS_IMPEX_EU, EK,
     c+ FRACHT, ZOLL, VERSICHERUNG, ZUSATZ, BEZUGSKOSTEN, LOHN, STK_I, FGK,
     c+ MGK, STK2, SONDEREINZELKOSTEN, ST3_KALK, STK3_FIX, ICS_BERECHNET,
     c+ ICS_PREISLISTE, ICS_NEU, ICS_FINAL, ICN_BERECHNET, ICN_PREISLISTE,
     c+ ICN_NEU, ICN_FINAL, EXS_BERECHNET, EXS_PREISLISTE, EXS_NEU,
     c+ EXS_FINAL, EXN_BERECHNET, EXN_PREISLISTE, EXN_NEU, EXN_FINAL,
     c+ OEM_BERECHNET, OEM_PREISLISTE, OEM_NEU, OEM_FINAL,
     c+ GH_NETTO_BERECHNET, GH_NETTO_NEU, GH_RABATT_BERECHNET,
     c+ EVP_PREISLISTE, GH_RABATT_NEUE, EVP_NETTO_KALK, EVP_BRUTTO_KALK,
     c+ ANLDAT, #TEVOZ1, #TEVOA1, ARTSKU, FAKTOR#, FAKTOR#EK, STK_LCP,
     c+ COSTPRS_AR, COSTPRS_AJ, TSTAMP, E10, MSAA, OTRA, MKAB, MF, GKFZB,
     c+ BT, DIVFRIGO, MINIBUS, DEFA, OETEILE, KLIMATEILE, E1, E2, E3, E4,
     c+ E5, E6, E7, E8, E9, LAENGE, BREITE, HOEHE, GEWICHT, ARTSTATUS,
     c+ PREISKDU, ARTEAN, ARTZ2, MARGE_NEU1, BUCHUNG201, ID_ART, DOMPB,
     c+ #0073, #0173, #0273, #0373, #0400, KCJMNG_VJ, KCJMNG_AJ, KCJUMS_VJ,
     c+ KCJUMS_AJ,
     c+ dec(0, 3, 0) #invart, char(' ', 1) #typ, current
     c+ timestamp p,
     c+ dec(0, 11, 2) #UDSTKMAT,dec(0, 11, 2) #UDSTKLHN,
     c+ dec(0, 11, 2) #UDSTKWKZG,dec(0, 11, 2) #UDSTKWKZU,
     c+ dec(0, 11, 2) #UDSTKENTG,dec(0, 11, 2) #UDSTKENTU,
     c+ dec(0, 11, 2) #UDSTKLIC,dec(0, 11, 2) #UDSTKFRA,
     c+ dec(0, 11, 2) #UDFERGKF,dec(0, 11, 2) #UDFERGKV,
     c+ dec(0, 11, 2) #UDFERLOH,dec(0, 11, 2) #UDMATGKO,
     c+ dec(0, 11, 2) #UDMATKOS,
     c+ dec(0, 11, 2) #UDSTK,dec(0, 11, 2) #UDSTK1,dec(0, 11, 2) #UDSTK2,
     c+ dec(0, 11, 2) #UDSTK3,
     c+ dec(0, 11, 2) beistell, dec(0, 5, 0) parts,
     c+ char(' ', 3) #invart, char(' ', 1) #ba, char(' ', 1) #typ
     c+ FROM TVRELWAECO/RPMKALK300
     c/end-exec

     c/exec sql
     c+  update bar_kalk/SLAZSLF set SLAZAUWT= SLAZEIMG*
     c+ ( select ek from tvrelwaeco/RPMKALKELP
     c+    where WAOFVEUR=SLAZKOTE )
     c+  where exists
     c+ ( select ek from tvrelwaeco/RPMKALKELP
     c+    where WAOFVEUR=SLAZKOTE )
     c/end-exec

     c/exec sql
     c+  update TVRELWAECO/RPMKALKELP   set beistell =
     c+ ( select sum(SLAZAUWT) from bar_kalk/SLAZSLF
     c+    where WAOFVEUR=SLAZTENR group by SLAZTENR )
     c+  where exists
     c+ ( select sum(SLAZAUWT) from bar_kalk/SLAZSLF
     c+    where WAOFVEUR=SLAZTENR group by SLAZTENR )
     c/end-exec

     C     ##_KALKELP    ENDSR

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
     c                   ENDSR

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
