      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#rab1     if   e             disk
     F                                     RENAME(#rab1:phy01r)
     F                                     USROPN
     f#rab2     if   e             disk
     F                                     RENAME(#rab2:phy02r)
     F                                     USROPN
     f#rab3     if   e             disk
     F                                     RENAME(#rab3:phy03r)
     F                                     USROPN
     f#rab4     if   e             disk
     F                                     RENAME(#rab4:phy04r)
     F                                     USROPN
     f#rab5     if   e             disk
     F                                     RENAME(#rab5:phy05r)
     F                                     USROPN
     f#rab6     if   e             disk
     F                                     RENAME(#rab6:phy06r)
     F                                     USROPN
      *                                                                     ----
     f#kondL1   uf a e           k disk    RENAME(kond1:log01r)
     f#kondL2   uf a e           k disk    RENAME(kond1:log02r)
     f#kondL3   uf a e           k disk    RENAME(kond1:log03r)
     f#kondL4   uf a e           k disk    RENAME(kond1:log04r)
     fSBGKDS00  IF   E           K DISK
     F
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D/COPY ##I001
     D*-------------------------------------------------------------------------
     D*                                                                     ----
     D*-------------------------------------------------------------------------
     C*    *ENTRY        PLIST
     c*                  PARM                    k                 5
     C*
     D*-------------------------------------------------------------------------
     C                   setoff                                       10
     C                   exsr      sr1000
     C                   exsr      sr1010
     C                   exsr      sr2000
     C                   exsr      sr2010
     C***                exsr      sr3000
     C***                exsr      sr3010
     C***                exsr      sr4000
     C***                exsr      sr4010
     C***                exsr      sr5000
     C***                exsr      sr5010
     C***                exsr      sr6000
     C***                exsr      sr6010
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##1000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab1
     C+ SELECT rab010, rab020, rab050, rab070 FROM sbgrab00 WHERE rab070 >
     C+ 0 and substr(rab020, 3, 3) <> 'XXX'
     c/end-exec
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr1010        BEGSR
     C*
     C                   open      #rab1
     C                   DO        *HIVAL
     C*
     C                   READ      #rab1                                  95
     C   95              LEAVE
     C*
     C                   clear                   log01r
     C*
     C     KEY1010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLI
     C                   KFLD                    KOPRGR
     C                   movel     rab010        kofirm
     C                   movel     'RK1'         kobegr
     C                   move      rab020        #kokdli           6
     C                   movel     '0'           #kokdli
     C                   movel     #kokdli       kokdli
     C                   movel     rab050        koprgr
     c     key1010       chain     #kondL1                            92
     C*
     C                   movel     '20100101'    kogada
     C                   movel     rab010        kofirm
     C                   movel     'RK1'         kobegr
     C                   move      rab020        #kokdli           6
     C                   movel     '0'           #kokdli
     C                   movel     'J'           KORBKZ
     C                   movel     '0'           KOSTKZ
     C                   movel     #kokdli       kokdli
     C                   movel     rab050        koprgr
     C                   z-add     rab070        koraba
     C                   eval      koraba =      koraba  * -1
     C                   z-add     20100101      KOGADA
     C                   clear                   KOGBDA
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   seton                                        44
     C                   movel     rab020        #kunde
     C                   exsr      sr8000
     C*
     C                   if        *in45 = '1'
     C   92              write     log01r
     C* n92              update    log01r
     C                   endif
     C*
     C                   enddo
     C                   close     #rab1
     C                   setoff                                       44

     C*
     C     ##1010        ENDSR

     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##2000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab2
     C+ SELECT rab010, rab020, rab050, rab140 FROM sbgrab00 WHERE rab140 >
     C+ 0 and substr(rab020, 3, 3) <> 'XXX'
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr2010        BEGSR
     C*
     C                   open      #rab2
     C                   DO        *HIVAL
     C*
     C                   READ      #rab2                                  95
     C   95              LEAVE
     C*
     C                   clear                   log01r
     C*
     C     KEY2010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLI
     C                   KFLD                    KOPRGR
     C                   movel     rab010        kofirm
     C                   movel     'RK2'         kobegr
     C                   move      rab020        #kokdli           6
     C                   movel     '0'           #kokdli
     C                   movel     #kokdli       kokdli
     C                   movel     rab050        koprgr
     c     key2010       chain     #kondL1                            92
     C*
     C                   movel     '20100101'    kogada
     C                   movel     rab010        kofirm
     C                   movel     'RK2'         kobegr
     C                   move      rab020        #kokdli           6
     C                   movel     '0'           #kokdli
     C                   movel     #kokdli       kokdli
     C                   movel     'J'           KORBKZ
     C                   movel     '0'           KOSTKZ
     C                   movel     rab050        koprgr
     C                   z-add     rab140        koraba
     C                   eval      koraba =      koraba  * -1
     C                   z-add     20100101      KOGADA
     C                   clear                   KOGBDA
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   seton                                        44
     C                   movel     rab020        #kunde
     C                   exsr      sr8000
     C*
     C                   if        *in45 = '1'
     C   92              write     log01r
     c* n92              update    log01r
     C                   endif
     C*
     C                   enddo
     C                   close     #rab2
     C                   setoff                                       44

     C*
     C     ##2010        ENDSR

     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##3000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##3000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab3
     C+ SELECT rab010, rab020, rab050, rab070 FROM sbgrab00 WHERE rab070 >
     C+ 0 and substr(rab020, 3, 3) =  'XXX'
     c/end-exec
     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr3010        BEGSR
     C*
     C                   open      #rab3
     C                   DO        *HIVAL
     C*
     C                   READ      #rab3                                  95
     C   95              LEAVE
     C*
     C                   clear                   log02r
     C*
     C     KEY3010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLG
     C                   KFLD                    KOPRGR
     C                   movel     rab010        KOFIRM
     C                   movel     'RG1'         KOBEGR
     C                   move      rab020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:01) = ' '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     rab050        KOPRGR
     c     key3010       chain     #kondL2                            92
     C*
     C                   movel     '20100101'    kogada
     C                   movel     rab010        KOFIRM
     C                   movel     'RG1'         KOBEGR
     C                   move      rab020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:01) = ' '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     rab050        KOPRGR
     C                   z-add     rab070        koraba
     C                   eval      koraba =      koraba  * -1
     C                   z-add     20100101      KOGADA
     C                   clear                   KOGBDA
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   exsr      sr8000
     C*
     C   92              write     log02r
     C  n92              update    log02r
     C*
     C                   enddo
     C                   close     #rab3

     C*
     C     ##3010        ENDSR

     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##4000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab4
     C+ SELECT rab010, rab020, rab050, rab140 FROM sbgrab00 WHERE rab140 >
     C+ 0 and substr(rab020, 3, 3) =  'XXX'
     c/end-exec
     C*
     C     ##4000        ENDSR
     C*
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr4010        BEGSR
     C*
     C                   open      #rab4
     C                   DO        *HIVAL
     C*
     C                   READ      #rab4                                  95
     C   95              LEAVE
     C*
     C                   clear                   log02r
     C*
     C     KEY4010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLG
     C                   KFLD                    KOPRGR
     C                   movel     rab010        KOFIRM
     C                   movel     'RG2'         KOBEGR
     C                   move      rab020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:01) = ' '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     rab050        KOPRGR
     c     key4010       chain     #kondL2                            92
     C*
     C                   movel     '20100101'    kogada
     C                   movel     rab010        KOFIRM
     C                   movel     'RG2'         KOBEGR
     C                   move      rab020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:01) = ' '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     rab050        KOPRGR
     C                   z-add     rab140        koraba
     C                   eval      koraba =      koraba  * -1
     C                   z-add     20100101      KOGADA
     C                   clear                   KOGBDA
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   exsr      sr8000
     C*
     C   92              write     log02r
     C  n92              update    log02r
     C*
     C                   enddo
     C                   close     #rab4

     C*
     C     ##4010        ENDSR

     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##5000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##5000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab5
     C+ SELECT PRM010, PRM020, PRM040, PRM120, PRM090, PRM100 FROM sbgprm00
     C+ WHERE substr(PRM020, 3, 3) = 'XXX' and prm080= 'B' and prm120 > 0
     c/end-exec
     C*
     C     ##5000        ENDSR
     C*
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr5010        BEGSR
     C*
     C                   open      #rab5
     C                   DO        *HIVAL
     C*
     C                   READ      #rab5                                  95
     C   95              LEAVE
     C*
     C                   clear                   log03r
     C*
     C     KEY5010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLG
     C                   KFLD                    KOTENR
     C                   movel     prm010        kofirm
     C                   movel     'RB1'         kobegr
     C                   move      prm020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:03) = '   '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     prm040        koTENR
     c     key5010       chain     #kondL3                            92
     C*
     C                   movel     prm010        kofirm
     C                   movel     'RB1'         kobegr
     C                   move      prm020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:03) = '   '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     prm040        kotenr
     C                   z-add     prm120        koraba
     C                   eval      koraba =      koraba  * -1
     C
     C                   movel     prm090        tt                2 0
     C                   move      prm090        jj                2 0
     C                   movel     prm090        ttmm              4 0
     C                   move      ttmm          mm                2 0
     c                   eval      KOGADA=(20000000+(jj*10000)+(mm*100)+tt)
     C
     C                   movel     prm100        tt                2 0
     C                   move      prm100        jj                2 0
     C                   movel     prm100        ttmm              4 0
     C                   move      ttmm          mm                2 0
     c                   eval      KOGBDA=(20000000+(jj*10000)+(mm*100)+tt)
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   exsr      sr8000
     C*
     C   92              write     log03r
     C  n92              update    log03r
     C*
     C                   enddo
     C                   close     #rab5

     C*
     C     ##5010        ENDSR

     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##6000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##6000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/#rab6
     C+ SELECT PRM010, PRM020, PRM040, PRM120, PRM090, PRM100 FROM sbgprm00
     C+ WHERE substr(PRM020, 3, 3) <>'XXX' and prm080= 'B' and prm120 > 0
     c/end-exec
     C*
     C     ##6000        ENDSR
     C*
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr6010        BEGSR
     C*
     C                   open      #rab6
     C                   DO        *HIVAL
     C*
     C                   READ      #rab6                                  95
     C   95              LEAVE
     C*
     C                   clear                   log04r
     C*
     C     KEY6010       KLIST
     C                   KFLD                    KOFIRM
     C                   KFLD                    KOBEGR
     C                   KFLD                    KOKDLI
     C                   KFLD                    KOTENR
     C                   movel     prm010        KOFIRM
     C                   movel     'RB2'         KOBEGR
     C                   move      prm020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:03) = '   '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     prm040        KOTENR
     c     key6010       chain     #kondL4                            92
     C*
     C                   movel     prm010        KOFIRM
     C                   movel     'RB2'         KOBEGR
     C                   move      prm020        #KOKDLG           6
     C                   movel     '0'           #KOKDLG
     C                   eval      %subst(#KOKDLG:04:03) = '   '
     C                   movel     #KOKDLG       KOKDLG
     C                   movel     prm040        KOTENR
     C                   z-add     prm120        koraba
     C                   eval      koraba =      koraba  * -1
     C
     C                   movel     prm090        tt                2 0
     C                   move      prm090        jj                2 0
     C                   movel     prm090        ttmm              4 0
     C                   move      ttmm          mm                2 0
     c                   eval      KOGADA=(20000000+(jj*10000)+(mm*100)+tt)
     C
     C                   movel     prm100        tt                2 0
     C                   move      prm100        jj                2 0
     C                   movel     prm100        ttmm              4 0
     C                   move      ttmm          mm                2 0
     c                   eval      KOGBDA=(20000000+(jj*10000)+(mm*100)+tt)
     C                   movel     §§§usr        KOUSER
     C                   movel     §§§pgm        KOPROG
     C                   add       1             a                 5 0
     C                   if        a = 80
     C                   clear                   p                 1
     C                   endif
     C                   seton                                        44
     C                   movel     prm020        #kunde
     C                   exsr      sr8000
     C*
     C                   if        *in45 = '1'
     C   92              write     log04r
     C  n92              update    log04r
     C                   endif
     C*
     C                   enddo
     C                   close     #rab6
     C                   setoff                                       44

     C*
     C     ##6010        ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*

     C                   movel     'EUR'         KOWACD
     C                   movel     'J'           KORBKZ
     C                   movel     '1'           KOSTKZ

     C     KEY8000       KLIST
     C                   KFLD                    #firma            2 0
     C                   KFLD                    #kunde            5 0

     C                   z-add     1             #firma
     C*********          z-add     1             #kunde

     c                   seton                                        45
     c   44key8000       chain     sbgkds00                           94
     c   44              if        kds200 =  99 or
     c                             *in94  = '1'
     c                   setoff                                       45
     c                   endif

     C*
     C     ##8000        ENDSR

     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   z-add     1             p01               1 0
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
