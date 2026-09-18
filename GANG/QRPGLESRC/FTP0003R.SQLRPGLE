      * PROGRAMMNAME.:FTP0003r                                                
      * FUNKTION.....:Error-Handling
      * Feb.2010       GANG, MANFRED
      *
      *
      *
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     F**************************************************************************

     fwaeedihp  up   e             disk
     fWAEEDILPl1uf   e           K disk

     FF3L2      if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(f3:log03r)
     Fsbgau300  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(AU300R1:log04r)
     FF5L1      if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(f5:log05r)
     Fsbgau500  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(AU500R1:log06r)
     Fsystempf  iF a E           k DISK
     Fsbgart07  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(ART07R1:log07r)
     Fsbgart00  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(ART00R1:log08r)

     DDate             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A

     D*-----------BOR Bordersatz -----------------------------------------------
     D text            DS
     D  text1                  1     14    INZ('reload order: ')
     D  text2                 15     21
     D  text3                 22     60    INZ(' for DC-system         ')
     D mod             DS
     D  mod1                   1     20    INZ('00000000000000000000')
     D  mod2                  21     32    INZ('000000000000')
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I/COPY ##I002
     I/COPY ##I003
     I*-------------------------------------------------------------------------
     c
     C     *LIKE         DEFINE    EDIH030       §KEY01
     C     *LIKE         DEFINE    EDIH080       §KEY02
     c                   z-add     EDIH030       §KEY01
     c                   movel     EDIH080       §KEY02
     c
     C**************************************************************************
     C* lesen daten aus Rechnung
     C*-------------------------------------------------------------------------
     C*
     C     sr5801        BEGSR
     C*
     C     KEY5801       KLIST
     C                   KFLD                    FAK1010
     C                   KFLD                    #§key01           5 0
     C                   KFLD                    #fak3090         21
     C                   z-add     1             FAK1010
     C                   z-add     §key01        #§key01
     C                   movel     §KEY02        #fak3090

     C     KEY5801       SETLL     F3L2                               99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      F3L2                                   99
     c                   if        *in99 ='1'                        or
     c                             FAK1010  <> 1                     or
     C                             #§key01  <> FAK1020               or
     C                             %subst(§KEY02:1:10) <>
     C                             %subst(FAK3090:1:10)
     C                   LEAVE
     C                   else
     C                   z-add     FAK1010       $FAK1010          2 0
     C                   z-add     FAK1020       $FAK1020          5 0
     C                   z-add     FAK1030       $FAK1030          6 0
     C                   if        fak1030 = 263691
     C                   clear                   $fak1030
     C                   endif
     C                   exsr      sr5801D
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##5801        ENDSR
     C*
     C**************************************************************************
     C* lesen daten aus Rechnung Detail
     C*-------------------------------------------------------------------------
     C*
     C     sr5801d       BEGSR
     C*
     C     KEY5801d      KLIST
     C                   KFLD                    $FAK1010
     C                   KFLD                    $FAK1020
     C                   KFLD                    $FAK1030

     C     KEY5801d      SETLL     F5L1                               99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      F5L1                                   99
     c                   if        *in99 ='1'                       or
     c                             $FAK1010 <> FAK1010              or
     C                             $FAK1020 <> FAK1020              or
     C                             $FAK1030 <> FAK1030
     C                   LEAVE
     C                   else
     C* FAK3120  = fak5480  Liefertermine
     C                   if        FAK5090  = EDIL220  and
     C                             FAK3120  = fak5480
     C                   exsr      sr9002
     C                   endif
     C*
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##5801d       ENDSR
     C*
     C**************************************************************************
     C* lesen daten aus auftrag
     C*-------------------------------------------------------------------------
     C*
     C     sr5802        BEGSR
     C*
     C     KEY5802       KLIST
     C                   KFLD                    FAK1010
     C                   KFLD                    #§key01           5 0
     C                   z-add     1             FAK1010
     C                   z-add     §key01        #§key01
     C                   movel     §KEY02        #fak3090

     C     KEY5802       SETLL     sbgau300                           99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      sbgau300                               99
     c                   if        *in99 ='1'                        or
     c                             AU3010   <> 1                     or
     C                             #§key01  <> AU3020
     C****************             %subst(§KEY02:1:10) <>
     C****************             %subst(au3090:1:10)
     C                   LEAVE
     C                   else
     C*
     C                   if        %subst(§KEY02:1:10) =
     C                             %subst(au3090:1:10)
     C                   z-add     AU3010        $FAK1010          2 0
     C                   z-add     AU3020        $FAK1020          5 0
     C                   z-add     AU3030        $FAK1030          6 0
     C                   exsr      sr5802D
     C                   endif
     C*
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##5802        ENDSR
     C*
     C**************************************************************************
     C* lesen daten aus Auftrag Detail
     C*-------------------------------------------------------------------------
     C*
     C     sr5802d       BEGSR
     C*
     C     KEY5802d      KLIST
     C                   KFLD                    $FAK1010
     C                   KFLD                    $FAK1020
     C                   KFLD                    $FAK1030

     C     KEY5802d      SETLL     sbgau500                           99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      sbgau500                               99
     c                   if        *in99 ='1'                       or
     c                             $FAK1010 <> AU5010               or
     C                             $FAK1020 <> AU5020               or
     C                             $FAK1030 <> AU5030
     C                   LEAVE
     C                   else
     C*
     C                   if        au5090   = EDIL220
     C                   seton                                        80
     C                   exsr      sr9002
     C                   setoff                                       80
     C                   endif
     C*
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##5802d       ENDSR
     C*
     C**************************************************************************
     C* Error kein Auftrag, keine Rechnung
     C*-------------------------------------------------------------------------
     C*
     C     sr5802e       BEGSR
     C*
     C                   seton                                        80
     C                   exsr      sr9002e
     C                   setoff                                       80
     C*
     C     ##5802e       ENDSR
     C*
     C**************************************************************************
     C* weiltere Teillieferung
     C*-------------------------------------------------------------------------
     C*
     C     SR9100        BEGSR
     C*
     C     KEYline       KLIST
     C                   KFLD                    §key01
     C                   KFLD                    EDIH040
     C                   z-add     1             clinen            5 0
     C*
     C     keyline       SETLL     WAEEDILPL1                         99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDILPL1                             99
     C     *IN99         IFEQ      '1'
     C     §key01        ORNE      EDIl030
     C     EDIH040       ORNE      EDIl040
     C                   LEAVE
     C                   else
     C*
     C                   exsr      sr9001
     C                   setoff                                       55
     C                   exsr      sr5801
     C                   exsr      sr5802
     C  n55              exsr      sr5802e
     C                   setoff                                       55
     C*
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##9100        ENDSR
     C*
     C**************************************************************************
     C* ...
     C*-------------------------------------------------------------------------
     C*
     C     sr9001        BEGSR
     C*
     C*
     C     ##9001        ENDSR
     C*
     C**************************************************************************
     C* ...
     C*-------------------------------------------------------------------------
     C*
     C     sr9002        BEGSR
     C*
     C*
     C     ##9002        ENDSR
     C*
     C**************************************************************************
     C* ...
     C*-------------------------------------------------------------------------
     C*
     C     sr9002e       BEGSR
     C*
     C*
     C     ##9002e       ENDSR
     C*
     C**************************************************************************
     C* lesen aus sbgart07    check auf artikel
     C*-------------------------------------------------------------------------
     C*
     C     sr_art        BEGSR
     C*
     C                   clear                   error            65
     C
     c     EDIL220       chain     sbgart07                           92
     C*
     C     key_art       KLIST
     C                   KFLD                    ART010
     C                   KFLD                    ART020
     C                   KFLD                    ART030
     c
     C   92              eval      Error=
     C                             ' article does not exist in the system'
     c
     c  n92key_art       chain     sbgart00                           92
     c  n92              if        art550  = 'VKNEIN'
     C  n92              eval      Error=
     C                             ' article is protected by supervisor  '
     c                   endif
     c  n92              if        art550  = 'VKSPER'
     C  n92              eval      Error=
     C                             ' article is not allowed for selling  '
     c                   endif
     c  n92              if        art180  = 'X'
     C  n92              eval      Error=
     C                             ' article is not anymore guilty replaced by:'
     c                   eval      %subst(Error:44:15) = art100
     c                   endif
     C*
     C                   clear                   anldat            8 0
     C                   clear                   #a                8
     C                   clear                   #anldat          10
     c  n92              movel     ART280        jj                2 0
     c  n92              movel     ART280        jjmm              4 0
     c  n92              move      ART280        tt                2 0
     c  n92              move      jjmm          mm                2 0
     c  n92              eval      anldat=(20000000+(jj*10000)+(mm*100)+tt)
     c  n92              if        anldat > 20500000
     c  n92              movel     '19'          anldat
     c                   endif
     c  n92              movel     anldat        #a
     c  n92              eval      %subst(#anldat:01:02) = %subst(#a:07:02)
     c  n92              eval      %subst(#anldat:03:01) = '.'
     c  n92              eval      %subst(#anldat:04:02) = %subst(#a:05:02)
     c  n92              eval      %subst(#anldat:06:01) = '.'
     c  n92              eval      %subst(#anldat:07:04) = %subst(#a:01:04)
     C*
     c  n92              if         edih060  < anldat
     c                   endif
     C*
     C     ##_art        ENDSR
     C*
     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C*
     C     *INZSR        BEGSR
     C* *LDA DEFINIEREN/LESEN
     C     *DTAARA       DEFINE    *LDA          LDA
     C                   IN        LDA
     C*
     C     *DTAARA       DEFINE                  firma             2
     C*    aktuelle Firma einlesen
     C                   IN        firma
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   OUT       LDA
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C/COPY ##PSSR                                         Errorroutine
