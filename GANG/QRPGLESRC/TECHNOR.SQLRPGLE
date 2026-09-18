      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fwaetechp  ip   e             disk
     F                                     RENAME(FAK00R1:phy01r)
     F*                                    USROPN
     fEdi_techp uf a e             disk
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
     D*-------------------------------------------------------------------------
     C*
     C*                  open      waetechp
     C                   exsr      sr3000
     C*                  close     waetechp
     C
     C*
     C***                exsr      return
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*

     C                   clear                   Edi_techpr
     C                   exsr      sr5000
     C                   if        FAK001  = '10'
     C                   movel     'R'           eddart
     C                   endif
     C                   if        FAK001  = '20'
     C                   movel     'G'           eddart
     C                   endif
     C                   if        FAK001  = '30'
     C                   movel     'G'           eddart
     C                   endif
     C                   movel     '1'           edtestk
     C                   move      FAK004        EDBELEGNR
     C                   if        FAK004   <>   ##fak004
     C                   clear                   m
     C                   endif
     C                   move      FAK004        ##fak004         10
     C     ' ':' '       xlate     EDBELEGNR     EDBELEGNR
     C                   movel     '         '   EDBELEGNR
     C     ' ':' '       xlate     EDRECHNR      EDRECHNR
     c                   eval      edbldatum =
     c                             %subst(FAK018:5:4)       +
     c                             %subst(FAK018:3:2)        +
     c                             %subst(FAK018:1:2)
     C                   clear                   edrechnr
     C                   clear                   edrechda
     c                   eval      edkaufer  =
     c                             %subst(FAK003:4:3)       +
     c                             %subst(FAK003:8:3)
     C                   movel     '1058'        edtlnummer
     C                   eval      edglntechn = '4026765000006'
     C                   eval      edustidtec = 'DE-220465473'
     C                   move      '30'          edvaludatu
     C     ' ':' '       xlate     edvaludatu    edvaludatu
     C                   move      '804'         edformatvd
     c                   clear                   $kds230           7
     c                   eval      $kds230   =
     c                             %subst(FAK003:4:3)       +
     c                             %subst(FAK003:8:3)       +
     C                             ' '
     C                   exsr      sr4500
     C                   movel     $kds030       ednamekauf
     C                   movel     $kds060       edstrhaunr
     C                   movel     $kds090       edortnkauf
     C                   movel     $kds080       edplzkaufe
     C                   movel     $kds070       edlandkauf
     C                   move      'EUR'         edwahrunre
     C*                  move      'EUR'         edwahrunza
     C                   clear                   edwahrunza
     C                   eval      m = m +1
     C                   move      m             edpositinr
     C     ' ':' '       xlate     edpositinr    edpositinr
     C                   exsr      sr4010
     C                   movel     fak007        edartiknrl
     C                   if        edartiknrl =  *blank
     C                   movel     fak008        edartiknrl
     C                   endif
     C                   movel     fak019        edartklbez
     C                   movel     fak011        #fak011           6
     c                   eval      edbermenge =
     c                             '000000000'               +
     c                             %subst(#fak011:1:5)       +
     C                             '.'                       +
     c                             %subst(#fak011:6:1)       +
     C                             '0'
     C                   exsr      sr4006
     C                   movel     'PCE'         edmaseinhe
     c     1,19          mult      fak012        nfak012           8 2
     c                   move      nfak012       #fak012           8
     c                   eval      EDEINZELPR =
     c                             '00000000'                +
     c                             %subst(#fak012:1:6)       +
     C                             '.'                       +
     c                             %subst(#fak012:7:2)
     c                   exsr      sr4007
     c                   move      fak012        #fak012
     c                   eval      ednettopre =
     c                             '        '                +
     c                             %subst(#fak012:1:6)       +
     C                             '.'                       +
     c                             %subst(#fak012:7:2)
     c                   movel     '        1'   ednettopre
     C                   movel     'PCE'         edpreisein
     C                   move      FAK005        edlsnummer
     C                   movel     '         '   edlsnummer
     c                   eval      edlsdatum =
     c                             %subst(FAK006:5:4)       +
     c                             %subst(FAK006:3:2)        +
     c                             %subst(FAK006:1:2)
     c                   eval      edustsatz =
     c                             '            19.00'
     c                   clear                   p                12 2
     c                   eval      p=(fak013*1,19-fak013)
     c                   move      p             #p               12
     c     ' ':'0'       xlate     #p            #p               12
     c                   eval      edustbetr =
     c                             '0000'               +
     c                             %subst(#p:1:10)      +
     c                             '.'                  +
     c                             %subst(#p:11:02)
     c                   exsr      sr4003
     c                   move      fak013        #p               12
     c     ' ':'0'       xlate     #p            #p               12
     c                   eval      EDPOSIBETR   =
     c                             '0000'               +
     c                             %subst(#p:1:10)      +
     c                             '.'                  +
     c                             %subst(#p:11:02)
     c                   exsr      sr4004
     c                   movel     fak017        edbnrkaeuf
     c                   movel     '        '    edbestdatu
     c                   clear                   edbestdatu
     c                   eval      edstsatzat  =
     c                             '             0.00'
     c                   clear                   edstsatzat
     c                   eval      edstbetrat   =
     c                             '             0.00'
     c                   clear                   edstbetrat
     c                   movel     $kds030       EDNAMEEMPF
     c                   movel     $kds060       EDSTRHNRES
     c                   movel     $kds090       EDORTNAMES
     c                   movel     $kds080       EDPLZENDES
     c                   movel     $kds070       EDLANDENES
     c                   eval      EDABPROSAZ   =
     c                             '             0.00'
     c                   clear                   EDABPROSAZ
     c                   eval      EDABBETRAG   =
     c                             '             0.00'
     c                   clear                   EDABBETRAG
     c                   eval      EDZUPROSAZ   =
     c                             '             0.00'
     c                   clear                   EDZUPROSAZ
     c                   eval      EDZUBETRAG   =
     c                             '             0.00'
     c                   clear                   EDZUBETRAG
     c                   move      $fak013       EDGESAMTRE
     c                   movel     '0000000'     EDGESAMTRE
     c                   eval      EDGESAMTRE =
     c                             %subst(EDGESAMTRE:2:14)      +
     c                             ','                          +
     c                             %subst(EDGESAMTRE:16:02)
     c                   exsr      sr4002

     c                   move      $mwst         EDUMSSTBET
     c                   movel     '0000000'     EDUMSSTBET
     c                   eval      EDUMSSTBET =
     c                             %subst(EDUMSSTBET:2:14)      +
     c                             ','                          +
     c                             %subst(EDUMSSTBET:16:02)
     c                   exsr      sr4001

     c                   move      $kds070       EDSTBEAUST
     c                   movel     '0000000'     EDSTBEAUST
     c                   exsr      sr4000
     c                   clear                   EDFILLER
     C                   write     Edi_techpr

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDSTBEAUST:x:1) = '0'
     C                   eval      %subst(EDSTBEAUST:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4000        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4001        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDUMSSTBET:x:1) = '0'
     C                   eval      %subst(EDUMSSTBET:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4001        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4002        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDGESAMTRE:x:1) = '0'
     C                   eval      %subst(EDGESAMTRE:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4002        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4003        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDUSTBETR:x:1) = '0'
     C                   eval      %subst(EDUSTBETR:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4003        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4004        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDPOSIBETR:x:1) = '0'
     C                   eval      %subst(EDPOSIBETR:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4004        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4006        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDBERMENGE:x:1) = '0'
     C                   eval      %subst(EDBERMENGE:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4006        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4007        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(EDEINZELPR:x:1) = '0'
     C                   eval      %subst(EDEINZELPR:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4007        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4010        BEGSR

     C                   setoff                                       30
     C                   z-add     *zero         x                 3 0
     C                   do        *hival
     C                   eval      x = x + 1
     C                   if        %subst(edpositinr:x:1) = '0'
     C                   eval      %subst(edpositinr:x:1) = ' '
     C                   else
     C                   seton                                        30
     C                   endif
     C   30              leave
     C                   enddo

     C     ##4010        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C                   clear                   $kds020          25
     C                   clear                   $kds030          25
     C                   clear                   $kds060          25
     C                   clear                   $kds080           5
     C                   clear                   $kds090          25
     C                   clear                   $kds070           3

     c/exec sql
     c+ whenever not found goto ##4500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##4500
     c/end-exec

     c/exec sql
     C+ select  kds020,
     C+         kds030,
     C+         kds060,
     C+         kds080,
     C+         kds090,
     C+         kds070
     C+ into    :$kds020,
     C+         :$kds030,
     C+         :$kds060,
     C+         :$kds080,
     C+         :$kds090,
     C+         :$kds070
     C+ FROM    sbgkds00
     C+ WHERE   kds230                = :$kds230
     c/end-exec
     C*

     C     ##4500        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     C                   movel     fak004        $fak004          10
     C                   clear                   $fak013          14 2
     C                   clear                   $mwst            14 2

     c/exec sql
     c+ whenever not found goto ##5000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##5000
     c/end-exec

     c/exec sql
     C+ SELECT sum( FAK013 ) into  :$fak013 FROM waetechp
     C+ where  FAK004 = :$fak004
     c/end-exec
     C*
     C
     C                   eval      $mwst  = $fak013 *19/100

     C     ##5000        ENDSR

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
     C                   clear                   m                 6 0
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
