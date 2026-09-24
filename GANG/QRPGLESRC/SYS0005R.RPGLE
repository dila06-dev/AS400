      * PROGRAMMNAME.:SYS0005R                                                
      * FUNKTION.....:........-VERARBEITUNG
      * 06.07.98       GANG, MANFRED
     * UPDATE         FILE(§000PHY1) TOFILE(*LIBL/SYSPROGPF)
      * READ/F.UPDATE  FILE(§000LOG1) TOFILE(*LIBL/SYSPROGL1)
      * READ           FILE(SYSPROF1) TOFILE(*LIBL/SYSPROFL1)
      * READ FÜR F4    FILE(§000PHY2) TOFILE(*LIBL/SYSPROFPF)
      * READ FÜR F4    FILE(QAUOOPT)  TOFILE(*LIBL/QAUOOPT)
      * READ FÜR F4    FILE(SYSPROG2) TOFILE(*LIBL/SYSPROGL2)
      *
      *
      *
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      * IN27 ??????????????????
      * srstp Protokollierung      //Gang                     01.10.2002
      *-------------------------------------------------------------------------
     F**************************************************************************
     FSYS0005D  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(DSDSPF)
     F                                     SFILE(§DDS1§S1:SFLRN1)
     F                                     RENAME(SYS0005D0:§DDS1§D0)
     F                                     RENAME(SYS0005D1:§DDS1§D1)
     F                                     RENAME(SYS0005C1:§DDS1§C1)
     F                                     RENAME(SYS0005S1:§DDS1§S1)
     F§000LOG1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SYSPROGPFR:LOG01R)
     F                                     INFDS(DSF1)
     F§000PHY1  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SYSPROGPFR:PHY01R)
     F*                                             KCOMIT
     FSYSPROF1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SYSPROFPFR:LOG02R)
     F§000PHY2  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SYSPROFPFR:PHY02R)
     FQAUOOPT   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     FSYSPROG2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SYSPROGPFR:LOG03R)
     F#auswpf   uF a E           k DISK
     Fsystempf  uF a E           k DISK
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D**************************************************************************
     D CTLfirma        DS
     D firma                   1      2
     D**************************************************************************
     D*-------------------------------------------------------------------------
     D* PROGRAMMSPEZIFISCHE ZUWEISUNGEN FÜR MELDUNGEN
     D CTLMSG          DS
     D  IMSG01                 1     30    INZ('"Programmschlüssel" ')
     D  IMSG02                31     60    INZ
     D  IMSG03                61     90    INZ
     D SFLMSG          DS
     D  I§§§01                 1     20    INZ('"Programmsteuerung" ')
     D CTLEOF          DS
     D  IEOF01                 1     10    INZ
     D  IEOF02                11     40    INZ('"Programmschlüssel" ')
     D  IEOF03                41     70    INZ
     D CTLFKT          DS
     D  IF16                   1     30    INZ('F16=Aufruf-Programm ')
     D CTL001          DS
     D  §§§§§1                 1      9    INZ('SYS0005S1')
     D  §§§§§2                10     18    INZ('SYS0005C1')
     D*-----------Dateischlüsselbereich ----------------------------------------
     D KEYDAT          DS
     D  §KEY01                 1     10    INZ
     D  §KEY02                11     15  0 INZ
     D  §KEY03                16     25    INZ
     D*-----------Startposition Schlüssel---------------------------------------
     D KEYS            DS
     D  KEYS01                 1     10    INZ
     D  KEYS02                11     15  0 INZ
     D  KEYS03                16     25    INZ
     D*-----------Range-Area Schlüssel von--------------------------------------
     D KEYV            DS
     D  KEYV01                 1     10    INZ
     D  KEYV02                11     15  0 INZ
     D  KEYV03                16     25    INZ
     D*-----------Range-Area Schlüssel bis--------------------------------------
     D KEYB            DS
     D  KEYB01                 1     10    INZ
     D  KEYB02                11     15  0 INZ
     D  KEYB03                16     25    INZ
     D*-----------erster modifizierter Satz bei DFTLD=J-------------------------
     D MODK            DS
     D  MODK01                 1     10    INZ
     D  MODK02                11     15  0 INZ
     D  MODK03                16     25    INZ
     D*-----------erster Key in gelesener Subfile ------------------------------
     D FSTK            DS
     D  FSTK01                 1     10    INZ
     D  FSTK02                11     15  0 INZ
     D  FSTK03                16     25    INZ
     D*-----------letzter Key in gelesener Subfile -----------------------------
     D LSTK            DS
     D  LSTK01                 1     10    INZ
     D  LSTK02                11     15  0 INZ
     D  LSTK03                16     25    INZ
     D*-----------Key in Subfile-Sätze Display-Area-----------------------------
     D KEYFMT          DS
     D  S1KY01                 1     10    INZ
     D  S1KY02                11     15  0 INZ
     D  S1KY03                16     25    INZ
     D*-----------Key in Subfile-Sätze Hidden-Area------------------------------
     D KEYHID          DS
     D  H1KY01                 1     10    INZ
     D  H1KY02                11     15  0 INZ
     D  H1KY03                16     25    INZ
     D*-----------Clear-Key-Area------------------------------------------------
     D KEYC            DS
     D  KEYC01                 1     10    INZ('          ')
     D  KEYC02                11     15  0 INZ(00000)
     D  KEYC03                16     25    INZ('          ')
     D KEYM            DS
     D  KEYM01                 1     10    INZ('          ')
     D  KEYM02                11     15  0 INZ(99999)
     D  KEYM03                16     25    INZ('          ')
     I**************************************************************************
     I/COPY ##E
     I*-------------------------------------------------------------------------
     I/COPY ##I001
     I/COPY ##I002
     I/COPY ##I003
     I*-------------------------------------------------------------------------
     ILOG01R
     I              S4USRP                      §KEY01
     I              S4LFD#                      §KEY02
     I              S4PGM                       §KEY03
     IPHY01R
     I              S4USRP                      §KEY01
     I              S4LFD#                      §KEY02
     I              S4PGM                       §KEY03
     I§DDS1§S1
     I* KEY-AREA
     I              S1USRP                      S1KY01
     I              S1LFD#                      S1KY02
     I              S1PGM                       S1KY03
     I* HIDDEN-KEY-AREA
     I              H1USRP                      H1KY01
     I              H1LFD#                      H1KY02
     I              H1PGM                       H1KY03
     I* ATTRIBUTE-AREA
     I              §§LFD#                      §§KY02
     IQPDMOPT
     I              COMMAND                     CMD
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*VORLAUFKARTEN ÜBERGABEBEREICHE                                  *********
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    DSPMOD            1
     C                   PARM                    §§XP
     C                   PARM                    §§YP
     C                   PARM                    FUNKT             9
     C                   PARM                    SFLP1             5
     C                   PARM                    DFTLD             1
     C                   PARM                    PKYS01
     C                   PARM                    PKYS02
     C                   PARM                    PKYS03
     C                   PARM                    PKYV01
     C                   PARM                    PKYV02
     C                   PARM                    PKYV03
     C                   PARM                    PKYB01
     C                   PARM                    PKYB02
     C                   PARM                    PKYB03
     C                   PARM                    CTL34             1
     C                   PARM                    CTLRWT            1
     C*
     C*                    MOVEL*LOVAL    KEYC01
     C*                    MOVEL*LOVAL    KEYC03
     C                   MOVEL     *HIVAL        KEYM01
     C                   MOVEL     *HIVAL        KEYM03
     C*
     C     *LIKE         DEFINE    KEYS01        PKYS01
     C                   MOVEL     PKYS01        KEYS01
     C     *LIKE         DEFINE    KEYS02        PKYS02
     C                   MOVEL     PKYS02        KEYS02
     C     *LIKE         DEFINE    KEYS03        PKYS03
     C                   MOVEL     PKYS03        KEYS03
     C*
     C     *LIKE         DEFINE    KEYV01        PKYV01
     C*                    MOVELPKYV01    KEYV01
     C     *LIKE         DEFINE    KEYV02        PKYV02
     C                   MOVEL     PKYV02        KEYV02
     C     *LIKE         DEFINE    KEYV03        PKYV03
     C                   MOVEL     PKYV03        KEYV03
     C*
     C     *LIKE         DEFINE    KEYB01        PKYB01
     C                   MOVEL     PKYB01        KEYB01
     C     *LIKE         DEFINE    KEYB02        PKYB02
     C                   MOVEL     PKYB02        KEYB02
     C     *LIKE         DEFINE    KEYB03        PKYB03
     C                   MOVEL     PKYB03        KEYB03
     C*
     C     *LIKE         DEFINE    §§§USR        §§§ALL
     C                   MOVEL     '*ALL'        §§§ALL
     C     LOG202        CHAIN     SYSPROF1                           91
     C   91              CLEAR                   §§§ALL
     C  N91              MOVEL     S5BERE        §§§ALL
     C  N91              MOVEL     S5BERE        §§§SYS            4
     C*
     C*    KEYV01        IFEQ      *BLANK
     C*                  MOVEL     §§§USR        KEYV01
     C*                  call      '##SYS0005R'
     C*                  parm                    §§§USR
     C*                  parm                    keyv01
     C*                  parm      '1'           fkt               1
     C*                  ENDIF
     C                   SETOFF                                       07
     C*                  jetzt über #auswbz  in sr2700
     C*
     C*
     C                   Z-ADD     69            FTLNG
     C*                    30+   56789.
     C                   MOVEA     '010000'      FKTTST
     C*AUS *LDA
     C                   clear                   fxrrn
     C     FXRRN         IFNE      *ZERO
     C     FXRRN         CHAIN     §000PHY1                           91
     C  N91              MOVEL     §KEY01        KEYS01
     C  N91              MOVEL     §KEY01        KEYV01
     C* N91                MOVEL§KEY02    KEYS02
     C* N91                MOVEL§KEY02    KEYV02
     C* N91                MOVEL§KEY03    KEYS03
     C* N91                MOVEL§KEY03    KEYV03
     C  N91              UNLOCK    §000PHY1
     C                   ENDIF
     C/COPY ##SUB1FA
     C*
     C                   clear                   vorabcall        90
     c                   exsr      sr2700
     C                   eval      vorabcall = %subst(#AUSWBZ:10:90)
     C                   if        %subst(firma:1:1) = 'E'
     C                   z-add     1             c1f
     C                   eval      c1ftxt   = 'Dometic Waeco Group   '
     C                   z-add     c1f           $_c1f             2 0
     C                   endif
     C                   if        %subst(firma:2:1) = 'T'
     C                   eval      c1ttxt   = 'TestSystem  '
     C                   eval      c1t = %subst(firma:2:1)
     C                   move      c1t           $_c1t             1
     C                   endif
     C                   if        %subst(firma:2:1) = 'P'
     C                   eval      c1ttxt   = 'Produktion  '
     C                   eval      c1t = %subst(firma:2:1)
     C                   move      c1t           $_c1t             1
     c                   endif
     c                   clear                   c1DRUCKER#       10
     c                   clear                   c1batch#          1
     c                   exsr      sr2600
     C*
     C     KEYC          IFNE      KEYS
     C                   MOVEL     'J'           CTLLD
     C                   END
     C*
     C     KEYV01        IFEQ      *BLANK
     C                   MOVE      *LOVAL        KEYV01
     C                   END
     C     KEYV03        IFEQ      *BLANK
     C                   MOVE      *LOVAL        KEYV03
     C                   END
     C*
     C     KEYB01        IFEQ      *BLANK
     C                   MOVE      *HIVAL        KEYB01
     C                   END
     C     KEYB03        IFEQ      *BLANK
     C                   MOVE      *HIVAL        KEYB03
     C                   END
     C*
     C*EIGENE FUNKTIONSTASTE FÜR BEARBEITUNG DATEI
     C                   Z-ADD     16            NEUFNR
     C                   Z-ADD     *ZERO         CTLARB
     C                   MOVEL     IF16          NEUFKT
     C                   EXSR      FKTPGM
     C*
     C*-------------------------------------------------------------------------
     C* DATEI-SCHLÜSSEL
     C* §000LOG1:
     C     KEY001        KLIST
     C                   KFLD                    §KEY01
     C                   KFLD                    §KEY02
     C                   KFLD                    §KEY03
     C*
     C     KEYSR1        KLIST
     C                   KFLD                    S1KY01
     C                   KFLD                    S1KY02
     C                   KFLD                    S1KY03
     C*
     C     LSTKEY        KLIST
     C                   KFLD                    LSTK01
     C                   KFLD                    LSTK02
     C                   KFLD                    LSTK03
     C* §000LOG2:
     C     LOG201        KLIST
     C                   KFLD                    KEYV01
     C                   KFLD                    §§§USR
     C     LOG202        KLIST
     C                   KFLD                    §§§ALL
     C                   KFLD                    §§§USR
     C* SYSPROGL2:
     C     LOG203        KLIST
     C                   KFLD                    §§§USR
     C                   KFLD                    D3OP
     C*
     C* WINDOW AUSGEBEN
     C                   WRITE     §DDS1§D0
     C                   WRITE     §DDS1§D1
     C*
     C*
     C/COPY ##SUB1DIAL                                    DIALOGSCHL.
     C/COPY ##SUB1CTLA                                    SR1101SR1111
     C**************************************************************************
     C* SR1100: SONSTIGE ZUWEISUNGEN NACH READ FORMAT ALS VORLAUF
     C*-------------------------------------------------------------------------
     C*
     C     SR1100        BEGSR
     C*
     C*          *IN28     IFEQ '0'                        KEINE MODIFIZ.
     C*          DFTLD     ANDNE'J'                        LADEN ?
     C*
     C                   MOVEL     KEYV01        KEYB01
     C                   Z-ADD     99999         KEYB02
     C                   MOVEL     *HIVAL        KEYB03
     C                   MOVEL     KEYV01        KEYS01
     C     *LIKE         DEFINE    S5BERE        §§BERE
     C     *LIKE         DEFINE    S5STEP        §§STEP
     C                   CLEAR                   §§BERE
     C*
     C*                    ENDIF
     C*
     C     LOG201        CHAIN     SYSPROF1                           91
     C*
     C     §§§ALL        IFNE      '*ALL'
     C   91              MOVEL     'MENÜ:'       TXT015           15
     C   91              MOVE      KEYV01        TXT015
     C   91              MOVEA     TXT015        MD
     C   91              MOVEL     'AL00050'     MSG
     C   91              EXSR      SNDMSG
     C   91              MOVE      'F'           CTLVLD
     C   91              MOVE      'J'           CTLLD
     C   91              Z-ADD     *ZERO         FSTK02
     C   91              MOVEL     *LOVAL        FSTK03
     C   91              MOVEL     FSTK          KEYV
     C                   ENDIF
     C                   MOVEL     *BLANK        §§STEP
     C  N91              MOVEL     S5STEP        §§STEP
     C     §§§ALL        IFEQ      *BLANK
     C  N91              MOVEL     S5BERE        §§BERE
     C                   ENDIF
     C     §§§ALL        IFNE      *BLANK
     C                   MOVEL     §§§ALL        §§BERE
     C                   ENDIF
     C*
     C                   if        c1f <>  $_c1f  or c1t <>  $_c1t
     C                   exsr      sr2800
     C     c1f           IFeq      1
     C                   call      '#CHGLIBL'
     C                   parm      'L'           f                 1
     C                   parm                    c1t               1
     C                   endif
     C     c1f           IFeq      2
     C                   call      '#CHGLIBL'
     C                   parm      'D'           f                 1
     C                   parm                    c1t               1
     C                   endif
     C     c1f           IFeq      3
     C                   call      '#CHGLIBL'
     C                   parm      'P'           f                 1
     C                   parm                    c1t               1
     C                   endif
     C  n94              in        firma
     C  n94              eval      c1t = %subst(firma:2:1)
     C  n94              move      c1t           $_c1t             1
     C  n94              z-add     c1f           $_c1f
     C  n94              if        %subst(firma:1:1) = 'E'
     C                   z-add     1             c1f
     C                   eval      c1ftxt   = 'Dometic Waeco Group   '
     C                   endif
     C  n94              if        %subst(firma:2:1) = 'T'
     C                   eval      c1ttxt   = 'TestSystem  '
     C                   endif
     C  n94              if        %subst(firma:2:1) = 'P'
     C                   eval      c1ttxt   = 'Produktion  '
     c                   endif
     C                   endif
     C*
     C                   if        c1drucker <> c1drucker# or
     C                             c1batch   <> c1batch#
     C                   call      '#DRUCHENR'
     C                   parm                    C1DRUCKER
     C                   parm                    C1batch
     C                   exsr      sr2600
     C                   endif
     C*
      * Meldung holen aus DTAARA QTEMP/MSGUSER
     C                   IN        msguser
     C                   movel     msguser       c1meld
     C                   If        c1meld = *blank
     C                   IN        info01
     C                   movel     info01        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info99
     C                   movel     info99        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info98
     C                   movel     info98        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info97
     C                   movel     info97        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info96
     C                   movel     info96        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info95
     C                   movel     info95        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info94
     C                   movel     info94        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info93
     C                   movel     info93        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info92
     C                   movel     info92        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info91
     C                   movel     info91        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                   IN        info90
     C                   movel     info90        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                             and %subst(firma:1:1) = 'E'
     C                   IN        info89
     C                   movel     info89        c1meld
     C                   endif
     C                   If        c1meld = *blank
     C                             and %subst(firma:1:1) = 'E'
     C                   IN        info88
     C                   movel     info88        c1meld
     C                   endif
     C     *LIKE         DEFINE    §KEY01        ##KEYV01
     C     §KEY01        IFNE      ##KEYV01
     C                   MOVE      'J'           CTLLD
     C                   eval      ##KEYV01  = §KEY01
     C                   ENDIF
     C                   if        vorabcall <> ' '
     C                   MOVEL     vorabcall     H1CALL
     C                   clear                   vorabcall
     C                   exsr      srsys2
     C                   ENDIF
     C*
     C     ##1100        ENDSR
     C*
     C**************************************************************************
     C* SR1120: SONSTIGE PRÜFUNGEN  CTRPRF=0 ==> OK
     C*-------------------------------------------------------------------------
     C*
     C     SR1120        BEGSR
     C*
     C                   MOVEL     '0'           CTLPRF
     C     §KEY01        IFNE      KEYV01
     C                   MOVEL     '1'           CTLPRF
     C                   ENDIF
     C*
     C     ##1120        ENDSR
     C*
     C**************************************************************************
     C* SR1121: SUBFILE-SÄTZE AUFBEREITEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1121        BEGSR
     C*
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEL     S4DESC        S1DESC
     C                   MOVEL     S4PGMK        S1PGMK
     C                   MOVEL     KEYDAT        KEYHID
     C                   MOVEL     S4LIB         H1LIB
     C                   MOVEL     S4DESC        H1DESC
     C                   MOVEL     S4PGMV        H1PGMV
     C                   MOVEL     S4LIBV        H1LIBV
     C                   MOVEL     S4PGMC        H1PGMC
     C                   MOVEL     S4PGMK        H1PGMK
     C                   MOVEL     S4CALL        H1CALL
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C*
     C     ##1121        ENDSR
     C*
     C/COPY ##SUB1ANLA                                    SR1131
     C**************************************************************************
     C* SR1198: VARIABLE ATTRIBUTSTEUERUNG PROTECTED (AATR,33)
     C*-------------------------------------------------------------------------
     C*
     C     SR1198        BEGSR
     C* KEYBEREICH
     C*                    MOVEAATR,33    §§KY01
     C                   MOVEA     ATR(33)       §§KY02
     C*                    MOVEAATR,33    §§KY03
     C* SONSTIGE
     C                   MOVEA     ATR(33)       §§f
     C                   MOVEA     ATR(33)       §§ftxt
     C                   MOVEA     ATR(07)       §§f
     C                   MOVEA     ATR(33)       §§ftxt
     C                   MOVEA     ATR(07)       §§t
     C                   MOVEA     ATR(33)       §§ttxt
     C                   MOVEA     ATR(07)       §§drucker
     C                   MOVEA     ATR(07)       §§batch
     C                   MOVEA     ATR(41)       §§meld
     C                   MOVEA     ATR(41)       §§m1
     C                   MOVEA     ATR(41)       §§m2
     C                   MOVEA     ATR(33)       §§DESC
     C                   MOVEA     ATR(33)       §§PGMK
     C* CONTROL-RECORD
     C                   MOVEA     ATR(33)       §§OP
     C                   MOVEA     ATR(33)       §§§S02
     C                   MOVEA     ATR(7)        §§§V01
     C*
     C     ##1198        ENDSR
     C*
     C**************************************************************************
     C* SR1199: VARIABLE ATTRIBUTSTEUERUNG
     C*-------------------------------------------------------------------------
     C*
     C     SR1199        BEGSR
     C* KEYBEREICH
     C**                   MOVEAATTK      §§KY01
     C                   MOVEA     ATTK          §§KY02
     C**                   MOVEAATTK      §§KY03
     C* SONSTIGE
     C                   MOVEA     ATTS          §§DESC
     C                   MOVEA     ATTS          §§PGMK
     C                   MOVEA     ATR(07)       §§f
     C                   MOVEA     ATR(33)       §§ftxt
     C                   MOVEA     ATR(07)       §§t
     C                   MOVEA     ATR(33)       §§ttxt
     C                   MOVEA     ATR(07)       §§drucker
     C                   MOVEA     ATR(07)       §§batch
     C                   MOVEA     ATR(41)       §§meld
     C                   MOVEA     ATR(41)       §§m1
     C                   MOVEA     ATR(41)       §§m2
     C* CONTROL-RECORD
     C                   MOVEA     ATTO          §§OP
     C*  06                MOVEAATR,33    §§OP
     C                   MOVEA     ATR(7)        §§§S02
     C   06              MOVEA     ATR(33)       §§§S02
     C                   MOVEA     ATR(7)        §§§V01
     C   06              MOVEA     ATR(33)       §§§V01
     C     §§BERE        IFNE      '*ALL'
     C     §§BERE        ANDNE     '*CHANGE'
     C                   EXSR      SR1198
     C                   ENDIF
     C                   SELECT
     C     S1PGMK        WHENEQ    '*'
     C                   EXSR      SR1198
     C                   MOVEA     ATR(7)        §§§S02
     C                   MOVEA     ATR(7)        §§§V01
     C     S1PGMK        WHENEQ    'B'
     C                   MOVEA     ATR(31)       §§DESC
     C                   MOVEA     ATR(31)       §§PGMK
     C                   MOVEA     ATR(31)       §§KY02
     C     S1PGMK        WHENEQ    'R'
     C                   MOVEA     ATR(13)       §§DESC
     C                   MOVEA     ATR(13)       §§PGMK
     C                   MOVEA     ATR(13)       §§KY02
     C     S1PGMK        WHENEQ    'G'
     C                   MOVEA     ATR(23)       §§DESC
     C                   MOVEA     ATR(23)       §§PGMK
     C                   MOVEA     ATR(23)       §§KY02
     C     S1PGMK        WHENEQ    'T'
     C                   MOVEA     ATR(21)       §§DESC
     C                   MOVEA     ATR(21)       §§PGMK
     C                   MOVEA     ATR(21)       §§KY02
     C     S1PGMK        WHENEQ    'P'
     C                   MOVEA     ATR(29)       §§DESC
     C                   MOVEA     ATR(29)       §§PGMK
     C                   MOVEA     ATR(29)       §§KY02
     C                   ENDSL
     C*
     C     ##1199        ENDSR
     C*
     C**************************************************************************
     C* SR1201: F4=BEDIENERFÜHRUNG
     C*-------------------------------------------------------------------------
     C*
     C     SR1200        BEGSR
     C*
     C     §§CRR         IFEQ      §§§§§1
     C     §§CRR         OREQ      §§§§§2
     C*
     C                   Z-ADD     SFLDR1        SAVDR1
     C                   Z-ADD     *ZERO         SFLDR1
     C                   Z-ADD     SFLRN1        XX               15 0
     C*
     C                   SELECT
     C     §§CRN         WHENNE    *ZERO
     C     *IN83         ANDEQ     '0'
     C     *IN89         ANDEQ     '1'
     C                   Z-ADD     §§CRN         SFLRN1
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C  N91              Z-ADD     S1F1RR        FXRRN
     C  N91              EXSR      RETURN
     C   91              MOVEL     'AL00002'     MSG
     C   91              EXSR      SNDMSG
     C   91              MOVE      'F'           CTLVLD
     C* S1PROFILE
     C* ---------
     C     §§CRF         WHENEQ    'KEYV01'
     C                   CLEAR                   FXRRN
     C                   CALL      'SYSM015C'                           97
     C                   IN        LDA
     C     CTLTST        IFEQ      '03'
     C                   EXSR      RETURN
     C                   ENDIF
     C     FXRRN         IFNE      *ZERO
     C     FXRRN         CHAIN     §000PHY2                           91
     C  N91              MOVEL     S5PRF         KEYV01
     C  N91              MOVE      'J'           CTLLD
     C   91              MOVE      'F'           CTLVLD
     C                   ENDIF
     C*EINZELSATZ UBER SYS0006R
     C*------------------------
     C     §§CRN         WHENNE    *ZERO
     C     *IN89         ANDEQ     '0'
     C     §§§SYS        IFEQ      '*ALL'
     C     §§§USR        OREQ      'xxxx'
     C                   CLEAR                   FXRRN
     C                   Z-ADD     §§CRN         SFLRN1
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C**N91                CLEARMSGPGM
     C  N91              Z-ADD     S1F1RR        FXRRN
     C  N91              OUT       LDA
     C  N91              CALL      'SYS0006C'                           97
     C  N91              MOVEL     §§§PGM        MSGPGM
     C  N91              IN        LDA
     C  N91CTLTST        IFEQ      '03'
     C  N91              EXSR      RETURN
     C                   ENDIF
     C   91              MOVEL     'AL00002'     MSG
     C   91              EXSR      SNDMSG
     C   91              MOVE      'F'           CTLVLD
     C                   ENDIF
     C*
     C* POSITION UNGÜLTIG
     C                   OTHER
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C*
     C                   ENDSL
     C*
     C                   Z-ADD     SFLAS1        SFLRN1
     C     SFLDR1        IFEQ      *ZERO
     C                   Z-ADD     SAVDR1        SFLDR1
     C                   END
     C                   Z-ADD     XX            SFLRN1
     C* FUNKTIONSTASTENAKTUALISIERUNG
     C                   Z-ADD     16            NEUFNR
     C                   Z-ADD     *ZERO         CTLARB
     C                   MOVEL     IF16          NEUFKT
     C                   EXSR      FKTPGM
     C*
     C* POSITION UNGÜLTIG
     C                   ELSE
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ENDIF
     C*
     C     ##1200        ENDSR
     C*
     C**************************************************************************
     C* SR1301: BEARBEITEN VON 1 BIS N-1 (KOMPLETTE SUBF.) NSUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1301        BEGSR
     C*
     C*          C1AUSW    IFEQ 'X'
     C*
     C     1             DO        SFLAS1        SFLRN1
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C     *IN91         IFEQ      '0'
     C                   MOVEA     FUNKT         *IN(81)
     C                   MOVE      'X'           D3OP
     C                   UPDATE    §DDS1§S1
     C                   ENDIF
     C                   ENDDO
     C*
     C*                    ENDIF
     C*
     C* SUBFILE BEARBEITEN
     C                   EXSR      SR1401
     C*
     C     ##1301        ENDSR
     C*
     C*/COPY ##SUB1OPTA                                     SR1401
     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1OPTA                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN OPTIONEN 1.SUBFILE
     C*               BEI ALPHAKEY
     C* 10.02.99       GANG, MANFRED
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C* SR1401: AUSWAHL BEARBEITEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1401        BEGSR
     C*
     C                   SETOFF                                       28
     C                   Z-ADD     SFLDR1        SAVDR1
     C                   Z-ADD     *ZERO         SFLDR1
     C                   Z-ADD     *ZERO         CRTREC
     C                   Z-ADD     *ZERO         MODREC
     C                   Z-ADD     *ZERO         DLTREC
     C                   Z-ADD     *ZERO         HELP1             1 0
     C*
     C     1             DO        *HIVAL
     C                   READC     §DDS1§S1                               91
     C                   MOVE      '0'           *IN34
     C   91              LEAVE
     C     DFTLD         IFEQ      'J'
     C     HELP1         ANDEQ     0
     C                   MOVEL     KEYFMT        MODK
     C                   ADD       1             HELP1
     C                   END
     C                   MOVE      'J'           CTLCHG            1
     C                   MOVE      'N'           CTLVLD            1
     C     *LIKE         DEFINE    S1OP          D3OP
     C                   MOVEL     S1OP          D3OP
     C                   EXSR      SR1501
     C*
     C     CTLVLD        IFEQ      'N'
     C                   SELECT
     C*
     C* SÄTZE KOPIEREN
     C     D3OP          WHENEQ    'K'
     C     D3OP          OREQ      'X'
     C     §§§CFK        ANDEQ     BT15
     C                   EXSR      SR1601
     C                   EXSR      SR1402
     C* AUSWAHL SATZ DRUCKEN
     C     D3OP          WHENEQ    'D'
     C     D3OP          OREQ      'X'
     C     §§§CFK        ANDEQ     BT21
     C                   EXSR      SR1701
     C                   EXSR      SR1402
     C* AUSWAHL SATZ MODIF.
     C     D3OP          WHENEQ    'N'
     C     D3OP          OREQ      'X'
     C     §§§CFK        ANDEQ     BT06
     C                   CLEAR                   S1F1RR
     C                   EXSR      SR1801
     C                   EXSR      SR1402
     C* AUSWAHL SATZ MODIF.
     C     D3OP          WHENEQ    'Ä'
     C     D3OP          OREQ      'X'
     C     §§§CFK        ANDEQ     BT02
     C                   EXSR      SR1801
     C                   EXSR      SR1402
     C* LÖSCHEN SÄTZE
     C     D3OP          WHENEQ    'L'
     C     D3OP          OREQ      'X'
     C     §§§CFK        ANDEQ     BT23
     C                   MOVE      'D'           CTLMOD
     C                   EXSR      SR1901
     C                   EXSR      SR1402
     C* KEINE OPTION
     C     D3OP          WHENEQ    ' '
     C                   MOVE      'N'           CTLCHG
     C*                    MOVE 'J'       CTLLD
     C* QAUOOPT
     C* FALSCHE FUNKTION ODER CODE
     C                   OTHER
     C     §§§SYS        IFEQ      '*ALL'
     C     §§§USR        OREQ      'xxxx'
     C                   EXSR      SRSYS1
     C                   ENDIF
     C*
     C     D3OP          IFNE      OPTION
     C     *IN96         OREQ      '1'
     C     §§§SYS        ORNE      '*ALL'
     C                   MOVEL     'AL00024'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ENDIF
     C                   CLEAR                   OPTION
     C*
     C                   ENDSL
     C*
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        D3OP
     C     SFLDR1        IFEQ      *ZERO
     C                   Z-ADD     SFLRN1        SFLDR1
     C                   END
     C*
     C     CTLVLD        IFEQ      'F'
     C     CTL34         ANDEQ     'J'
     C                   MOVE      '1'           *IN34
     C                   ENDIF
     C*
     C                   MOVEA     FUNKT         *IN(81)
     C                   UPDATE    §DDS1§S1
     C                   SETOFF                                       86
     C                   SETON                                        28
     C*
     C                   ENDDO
     C*
     C                   Z-ADD     SFLAS1        SFLRN1
     C     SFLDR1        IFEQ      *ZERO
     C                   Z-ADD     SAVDR1        SFLDR1
     C                   END
     C*
     C     ##1401        ENDSR
     C**************************************************************************
     C* SR1402: CHANGE FÜR NEUAUFBAU FESTSTELLEN
     C*-------------------------------------------------------------------------
     C*
     C     SR1402        BEGSR
     C*
     C     CTLVLD        IFNE      'F'
     C     DFTLD         ANDEQ     'J'
     C                   MOVE      'J'           CTLLD
     C                   END
     C*
     C     ##1402        ENDSR
     C/COPY ##OPCODE                                       SR1500
     C*
     C**************************************************************************
     C* SR1501: PRÜFUNGEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1501        BEGSR
     C*
     C                   EXSR      SRATTR
     C     §§§SYS        IFNE      '*ALL'
     C     §§§USR        ANDNE     'xxxx'
     C     D3OP          IFNE      'X'
     C                   EXSR      SR1500
     C                   ENDIF
     C                   ENDIF
     C     CTLVLD        IFEQ      'F'
     C                   MOVE      '1'           *IN60
     C                   MOVEA     ATR(9)        §§OP
     C                   ENDIF
     C*
     C     KEYFMT        IFNE      KEYHID
     C     CTLVLD        ANDNE     'F'
     C     KEYSR1        CHAIN     §000LOG1                           91
     C     *IN91         IFEQ      '0'
     C                   MOVEL     'AL00012'     MSG
     C                   MOVEL     I§§§01        TXT24            24
     C                   MOVE      S1KY01        TXT24
     C                   MOVEA     TXT24         MD
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   SETON                                        62
     C                   END
     C                   END
     C*
     C     §§§SYS        IFNE      '*ALL'
     C     §§§USR        ANDNE     'xxxx'
     C                   EXSR      SR1503
     C                   END
     C*
     C     ##1501        ENDSR
     C*
     C**************************************************************************
     C* SR1502: SATZMODIFIZIERUNG DURCH EINEN ANDEREN ANWENDER?
     C*-------------------------------------------------------------------------
     C*
     C     SR1502        BEGSR
     C*
     C     KEYHID        IFNE      KEYDAT
     C     H1DESC        ORNE      S4DESC
     C     H1PGMK        ORNE      S4PGMK
     C                   MOVEL     'AL00015'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   SETON                                        60
     C                   MOVEA     ATR(9)        §§OP
     C                   MOVE      ' '           CTLMOD
     C                   ENDIF
     C*          H1KY01    IFNE §KEY01
     C*                    SETON                     62
     C*                    MOVEAATR,9     §§KY01
     C*                    ENDIF
     C     H1KY02        IFNE      §KEY02
     C                   SETON                                        62
     C                   MOVEA     ATR(9)        §§KY02
     C                   ENDIF
     C*          H1KY03    IFNE §KEY03
     C*                    SETON                     62
     C*                    MOVEAATR,9     §§KY03
     C*                    ENDIF
     C     H1DESC        IFNE      S4DESC
     C                   SETON                                        70
     C                   MOVEA     ATR(9)        §§DESC
     C                   ENDIF
     C     H1PGMK        IFNE      S4PGMK
     C                   SETON                                        71
     C                   MOVEA     ATR(9)        §§PGMK
     C                   ENDIF
     C*
     C     ##1502        ENDSR
     C*
     C**************************************************************************
     C* SR1503: KENNWORTEINGABE OK
     C*-------------------------------------------------------------------------
     C*
     C     SR1503        BEGSR
     C*
     C                   GOTO      ##1503
     C                   CALL      'KNWPRF1'                            97
     C                   PARM                    C1KW
     C                   PARM      'D'           MODUS             1
     C                   PARM      ' '           RTNCOD            1
     C                   PARM                    §§§PGM
     C                   MOVE      '0'           *IN61
     C     RTNCOD        IFNE      '0'
     C                   MOVE      'F'           CTLVLD
     C                   MOVE      '1'           *IN61
     C                   MOVEA     ATR(9)        §§KW
     C                   MOVE      ' '           CTLMOD
     C                   MOVE      '1'           *IN34
     C                   ENDIF
     C*
     C     ##1503        ENDSR
     C*
     C**************************************************************************
     C* SR1505: OP-CODE UND DATENSATZ STEHEN IM WIDERSPRUCH
     C*-------------------------------------------------------------------------
     C*
     C     SR1505        BEGSR
     C*
     C     *IN91         IFEQ      '0'
     C*
     C     D3OP          IFEQ      'N'
     C     §§§CFK        OREQ      BT06
     C                   MOVEL     'AL00031'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   MOVE      ' '           CTLMOD
     C                   SETON                                        60
     C                   SETON                                        62
     C*                    MOVEAATR,9     §§KY01
     C                   MOVEA     ATR(9)        §§KY02
     C*                    MOVEAATR,9     §§KY03
     C                   ENDIF
     C     D3OP          IFEQ      'Ä'
     C     §§§CFK        OREQ      BT02
     C     CTLRWT        IFNE      'J'
     C     KEYFMT        ANDNE     KEYHID
     C                   MOVEL     'AL00031'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   MOVE      ' '           CTLMOD
     C*                    MOVEAATR,9     §§KY01
     C                   MOVEA     ATR(9)        §§KY02
     C*                    MOVEAATR,9     §§KY03
     C                   SETON                                        60
     C                   SETON                                        62
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     ##1505        ENDSR
     C*
     C**************************************************************************
     C* SR1506: KEINE ÄNDERUNGEN VORGENOMMEN
     C*-------------------------------------------------------------------------
     C*
     C     SR1506        BEGSR
     C*
     C     KEYHID        IFEQ      KEYFMT
     C     H1DESC        ANDEQ     S1DESC
     C     H1PGMK        ANDEQ     S1PGMK
     C                   MOVEL     'AL00048'     MSG
     C                   MOVEL     S1KY01        IMSG02
     C                   MOVEL     I§§009        IMSG03
     C                   MOVEA     CTLMSG        MD
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   SETON                                        60
     C                   MOVEA     ATR(9)        §§OP
     C                   MOVE      ' '           CTLMOD
     C                   ENDIF
     C*
     C     ##1506        ENDSR
     C*
     C/COPY ##DATUM                                        SR1510 DATUM
     C*
     C**************************************************************************
     C* SR1601: SÄTZE KOPIEREN
     C*-------------------------------------------------------------------------
     C*
     C     SR1601        BEGSR
    C* KOPIER-MODUS
     C                   MOVE      '1'           *IN60
     C                   MOVEL     'AL00026'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C     ##1601        ENDSR
     C*
     C**************************************************************************
     C* SR1701: SÄTZE DRUCKEN
     C*-------------------------------------------------------------------------
     C*
     C     SR1701        BEGSR
    C* DRUCK-MODUS
     C                   MOVE      '1'           *IN60
     C                   MOVEL     'AL00026'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C     ##1701        ENDSR
     C*
     C**************************************************************************
     C* SR1801: SÄTZE ANLEGEN/UPDATEN UPDATE-DATEI #1: DATEI
     C*-------------------------------------------------------------------------
     C*
     C     SR1801        BEGSR
     C*
     C     S1F1RR        IFNE      *ZERO
     C                   MOVE      'U'           CTLMOD
     C     S1F1RR        CHAIN     §000PHY1                           91
     C                   EXSR      SR1502
     C                   ELSE
     C                   MOVE      'W'           CTLMOD
     C                   CLEAR                   PHY01R
     C                   END
     C                   EXSR      SR1505
     C                   EXSR      SR1506
     C     S1F1RR        IFNE      *ZERO
     C     CTLMOD        ANDEQ     ' '
     C                   UNLOCK    §000PHY1
     C                   ENDIF
     C*
     C     CTLMOD        IFNE      ' '
     C                   MOVEL     KEYFMT        KEYDAT
     C                   MOVEL     S1DESC        S4DESC
     C                   MOVEL     S1PGMK        S4PGMK
     C                   MOVEL     §§§USR        S4USR
     C                   MOVEL     KEYDAT        KEYHID
     C                   MOVEL     S4DESC        H1DESC
     C                   MOVEL     S4PGMK        H1PGMK
     C                   CLEAR                   S1OP
     C     CTLMOD        IFEQ      'W'
     C     S1KY01        IFEQ      *BLANK
     C                   MOVEL     §§§USR        S1KY01
     C                   ENDIF
     C                   Z-ADD     LDADTP        S4ADAT
     C                   MOVEL     'A'           S4AKT
     C                   WRITE     PHY01R
     C                   ADD       1             CRTREC
     C                   ADD       1             E1CRT
     C                   MOVE      'J'           CTLCHG            1
     C                   MOVE      'J'           CTLLD
     C                   MOVEL     I§§010        IMSG03
     C                   EXSR      MSG001
     C                   ELSE
     C                   MOVEL     LDADTP        S4EDAT
     C                   UPDATE    PHY01R
     C                   ADD       1             MODREC
     C                   ADD       1             E1MOD
     C                   MOVE      'J'           CTLCHG            1
     C                   MOVEL     I§§009        IMSG03
     C                   EXSR      MSG001
     C                   END
     C                   END
     C*
     C     ##1801        ENDSR
     C*
     C**************************************************************************
     C* SR1901: SÄTZE LÖSCHEN UPDATE-DATEI #1: DATEI
     C*-------------------------------------------------------------------------
     C*
     C     SR1901        BEGSR
     C*
     C     KEYSR1        SETLL     §000LOG1
     C                   DO        *HIVAL
     C     KEYSR1        READE     §000LOG1                               91
     C   91              LEAVE
     C                   Z-ADD     F1RRN         X1RRN            15 0
     C     X1RRN         DELETE    PHY01R                             93
     C                   SETON                                        86
     C                   CLEAR                   S1OP
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   CLEAR                   KEYHID
     C                   ADD       1             DLTREC
     C                   ADD       1             E1DLT
     C                   MOVE      'J'           CTLCHG            1
     C                   MOVEL     I§§011        IMSG03
     C                   EXSR      MSG001
     C                   END
     C*
     C     ##1901        ENDSR
     C*
     C*
     C**************************************************************************
     C* lesen aus #auswpf     *94  on = fehler, nur hier verwenden
     C*-------------------------------------------------------------------------
     C*
     C     sr2600        BEGSR
     C*
     C     KEY2600       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c                   clear                   $key1
     c                   clear                   $key2
     c                   clear                   $key3
     C                   movel     'WAECO'       $key1
     C                   movel     §§§USR        $key2
     C                   movel     'PRINTER'     $key3
     C*
     c     KEY2600       chain     systempf                           94
     c  n94              eval      c1DRUCKER  =  %subst($P1:11:10)
     c  n94              eval      c1batch    =  %subst($P1:21:10)
     c  n94              eval      c1DRUCKER# =  %subst($P1:11:10)
     c  n94              eval      c1batch#   =  %subst($P1:21:10)
     c   94              eval      c1DRUCKER  =  '          '
     c   94              eval      c1batch    =  ' '
     c                   unlock    systempf
     C*
     C     ##2600        ENDSR
     C*
     C**************************************************************************
     C* lesen aus #auswpf     vorschlag holen aus #auswpf
     C*-------------------------------------------------------------------------
     C*
     C     sr2700        BEGSR
     C*
     c                   clear                   $key1
     c                   clear                   $key2
     c                   clear                   $key3
     C                   movel     'WAECO'       $key1
     C                   movel     §§§usr        $key2
     C                   movel     'PROFILE'     $key3
     C*
     c     KEY2600       chain     systempf                           94
     c                   clear                   c1F__#            1
     c* n94   *          eval      c1F__#     =  %subst($P1:01:01)
     c* n94   *          movel     c1f__#        c1f
     c* n94   *          eval      c1t        =  %subst($P1:002:01)
     c  n94              eval      keyv01     =  %subst($P1:001:10)
     c                   unlock    systempf
     C*
     C     ##2700        ENDSR
     C*
     C**************************************************************************
     C* lesen aus #auswpf     vorschlag holen aus #auswpf
     C*-------------------------------------------------------------------------
     C*
     C     sr2750        BEGSR
     C*
     c                   clear                   $key1
     c                   clear                   $key2
     c                   clear                   $key3
     C                   movel     'WAECO'       $key1
     C                   movel     §§§usr        $key2
     C                   movel     'PROFILE'     $key3
     C*
     c     KEY2600       chain     systempf                           94
     c                   clear                   c1F__#            1
     c* n94   *          eval      c1F__#     =  %subst($P1:01:01)
     c* n94   *          movel     c1f__#        c1f
     c* n94   *          eval      c1t        =  %subst($P1:002:01)
     c  n94              eval      %subst($P1:001:10) = KEYv01
     c                   update    #SYSTEMR
     C*
     C     ##2750        ENDSR
     C*
     C**************************************************************************
     C* lesen aus #auswpf     Berechtigung prüfen aus #auswpf
     C*-------------------------------------------------------------------------
     C*
     C     sr2800        BEGSR
     C*
     c     #auskey       klist
     c                   kfld                    #ausber
     c                   kfld                    #ausbwh
     C*
     c                   clear                   #ausber
     C                   move      §§§usr        #ausbwh
     C                   movel     'F'           hlp2              2
     C                   move      c1f           hlp2
     C                   movel     hlp2          hlp3              3
     C                   move      c1t           hlp3              3
     C                   movel     hlp3          #ausber
     C*
     c     #auskey       chain     #auswpf                            94
     c*                  clear                   c1F__#            1
     c* n94              eval      c1F__#     =  %subst(#auswbz:01:01)
     c* n94              movel     c1f__#        c1f
     C                   clear                   $_c1f
     C                   clear                   $_c1t
     c   94              exsr      sr2700
     c   94              clear                   c1f
     c   94              clear                   c1t
     C   94              call      '#LIBALTC'
     C   94              clear                   c1ftxt
     C   94              clear                   c1ttxt
     c                   unlock    #auswpf
     C*
     C     ##2800        ENDSR
     C*
     C**************************************************************************
     C* SRFK13: ???
     C*-------------------------------------------------------------------------
     C*
     C     SRFK13        BEGSR
     C*
      * Programmfunktion laden aus gang/#SYS0005R, wenn Eintrag
     C     §§§SYS        IFEQ      '*ALL'
     C     §§§USR        OREQ      'xxxx'
     C                   IN        #SYS0005R
     C                   movel     #SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   endif
     C*
      * Meldung löschen aus DTAARA QTEMP/MSGUSER  +
      *                     DTAARA Arbeitsumgebung §USER(1-9)
     C                   call      '##SYS0005R'
     C                   parm                    §§§USR
     C                   parm                    keyv01
     C                   parm      '9'           fkt               1
     C*
     C     ##FK13        ENDSR
     C*
     C**************************************************************************
     C* SRFK16: AUFRUF CALL
     C*-------------------------------------------------------------------------
     C*
     C     SRFK16        BEGSR
     C*
     C                   Z-ADD     SFLDR1        SAVDR1
     C                   Z-ADD     *ZERO         SFLDR1
     C                   Z-ADD     SFLRN1        XX               15 0
     C     §§CRR         IFEQ      §§§§§1
     C*
     C                   SELECT
     C****       §§CRF     WHEQ 'S1LFD#'
     C     §§CRN         WHENNE    *ZERO
     C                   Z-ADD     §§CRN         SFLRN1
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C     *IN91         IFEQ      '1'
      * Programmfunktion laden aus gang/$SYS0005R, wenn Eintrag
     C                   IN        $SYS0005R
     C                   movel     $SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ELSE
     C                   MOVEL     S1KY03        PGM
     C                   MOVEL     H1LIB         LIB
     C     H1PGMV        IFNE      *BLANK
     C                   MOVEL     H1PGMV        PGM
     C                   ENDIF
     C     H1LIBV        IFNE      *BLANK
     C                   MOVEL     H1LIBV        LIB
     C                   ENDIF
     C     LIB           IFEQ      *BLANK
     C                   MOVEL     '*LIBL'       LIB
     C                   ENDIF
     C* STEPVERARBEITUNG ?
     C                   MOVEL     ' '           STEPER            1
     C     §§STEP        IFEQ      'J'
     C     H1PGMC        ANDNE     *BLANK
     C                   EXSR      SRSTEP
     C                   ENDIF
     C*
     C     STEPER        IFNE      '1'
     C                   SELECT
     C     H1PGMC        WHENEQ    'D'
     C     H1PGMC        OREQ      'B'
     C                   CALL      'SYS0001C'                           97
     C                   PARM                    PGM              10
     C                   PARM                    LIB              10
     C                   PARM                    H1PGMC
     C                   EXSR      SRSTP
     C     H1PGMC        WHENEQ    'Z'
     C                   CALL      'SYS0002C'                           97
     C                   PARM                    PGM              10
     C                   PARM                    LIB              10
     C                   PARM                    H1PGMC
     C                   EXSR      SRSTP
     C     H1PGMC        WHENEQ    'C'
     C                   CALL      'SYS0003C'                           97
     C                   PARM                    PGM              10
     C                   PARM                    LIB              10
     C                   PARM                    H1PGMK
     C                   EXSR      SRSTP
     C     H1PGMC        WHENEQ    'Q'
     C                   EXSR      SRSYS2
     C                   EXSR      SRSTP
     C                   OTHER
      * Programmfunktion laden aus gang/$SYS0005R, wenn Eintrag
     C                   IN        $SYS0005R
     C                   movel     $SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   MOVE      'F'           CTLVLD
     C                   ENDSL
     C                   ELSE
      * Programmfunktion laden aus gang/$SYS0005R, wenn Eintrag
     C                   IN        $SYS0005R
     C                   movel     $SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   MOVEL     'SYS0002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ENDIF
     C*
     C* PROGRAMMÜBERGABE *IN03 FÜR PROGRAMMENDE (FUNKTIONSTASTE PF03)
     C                   IN        LDA
     C     CTLTST        IFEQ      '03'
     C                   EXSR      RETURN
     C                   ENDIF
     C                   ENDIF
     C* POSITION UNGÜLTIG
     C                   OTHER
      * Programmfunktion laden aus gang/$SYS0005R, wenn Eintrag
     C                   IN        $SYS0005R
     C                   movel     $SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C*
     C                   ENDSL
     C* POSITION UNGÜLTIG
     C                   ELSE
      * Programmfunktion laden aus gang/$SYS0005R, wenn Eintrag
     C                   IN        $SYS0005R
     C                   movel     $SYS0005R     H1CALL
     C                   exsr      SRSYS2
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ENDIF
     C*
     C                   Z-ADD     SFLAS1        SFLRN1
     C     SFLDR1        IFEQ      *ZERO
     C                   Z-ADD     SAVDR1        SFLDR1
     C                   END
     C                   Z-ADD     XX            SFLRN1
     C*
     C* FUNKTIONSTASTENAKTUALISIERUNG
     C                   Z-ADD     16            NEUFNR
     C                   Z-ADD     *ZERO         CTLARB
     C                   MOVEL     IF16          NEUFKT
     C                   EXSR      FKTPGM
     C*
     C     ##FK16        ENDSR
     C*
     C**************************************************************************
     C* SRSYS1: READ QAUOOPT
     C*-------------------------------------------------------------------------
     C*
     C     SRSYS1        BEGSR
     C*
     C     §§§ALL        ifeq      '*ALL'
     C                   OPEN      QAUOOPT
     C     1             DO        *HIVAL
     C                   READ      QAUOOPT                                96
     C   96              LEAVE
     C     D3OP          IFEQ      OPTION
     C                   MOVEA     CMD           MD
     C                   ADD       0             X                 3 0
     C     1             DO        *HIVAL
     C                   ADD       1             X
     C     X             ADD       1             Y                 3 0
     C     MD(X)         IFEQ      ' '
     C     MD(Y)         ANDEQ     ' '
     C                   MOVE      X             STRING
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   CALL      'SYS0000C'                           96
     C                   PARM                    MD
     C                   PARM                    STRING           15
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   CLOSE     QAUOOPT
     C   96              EXSR      SRSYS3
     C                   ENDIF
     C*
     C     ##SYS1        ENDSR
     C*
     C**************************************************************************
     C* SRSYS2: READ QUALIFIZIERT
     C*-------------------------------------------------------------------------
     C*
     C     SRSYS2        BEGSR
     C*
     C                   MOVEA     H1CALL        MD
     C                   ADD       0             X
     C     1             DO        *HIVAL
     C                   ADD       1             X
     C     X             ADD       1             Y
     C     MD(X)         IFEQ      ' '
     C     MD(Y)         ANDEQ     ' '
     C                   MOVE      X             STRING
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   CALL      'SYS0004C'                           96
     C                   PARM                    MD
     C                   PARM                    STRING           15
     C                   PARM                    LIB              10
     C                   PARM                    H1PGMK
     C*
     C     ##SYS2        ENDSR
     C*
     C**************************************************************************
     C* SRSYS3: READ SYSPROGL2
     C*-------------------------------------------------------------------------
     C*
     C     SRSYS3        BEGSR
     C*
     C     LOG203        CHAIN     SYSPROG2                           96
     C     *IN96         IFEQ      '0'
     C                   MOVEA     S4CALL        MD
     C                   ADD       0             X
     C     1             DO        *HIVAL
     C                   ADD       1             X
     C     X             ADD       1             Y
     C     MD(X)         IFEQ      ' '
     C     MD(Y)         ANDEQ     ' '
     C                   MOVE      X             STRING
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   CALL      'SYS0004C'                           96
     C                   PARM                    MD
     C                   PARM                    STRING           15
     C                   PARM                    LIB              10
     C                   PARM                    H1PGMK
     C                   ENDIF
     C*
     C     ##SYS3        ENDSR
     C*
     C*
     C**************************************************************************
     C* SRSTEP: MENÜ = STAPELVERARBEITUNG ?
     C*-------------------------------------------------------------------------
     C*
     C     SRSTEP        BEGSR
     C*
     C     H1PGMK        IFEQ      '*'
     C                   MOVEL     '1'           STEPER
     C                   ELSE
     C     KEYSR1        CHAIN     §000LOG1                           96
     C  N96S4PGMK        IFNE      '*'
     C  N96              READP     §000LOG1                               96
     C     §KEY01        IFEQ      S1KY01
     C     *IN96         ANDEQ     '0'
     C     S4PGMK        ANDNE     '*'
     C                   MOVEL     '1'           STEPER
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     '1'           STEPER
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     ##STEP        ENDSR
     C*
     C*
     C**************************************************************************
     C* SRSTP : MENÜ = STAPELVERARBEITUNG ? UPDATE AUF DATEI
     C*-------------------------------------------------------------------------
     C*
     C     SRSTP         BEGSR
     C*
     C     S1KY02        ifne      99999
     C**** §§STEP        IFEQ      'J'
     C**** S1KY02        ANDNE     99999
     C     S1F1RR        CHAIN     §000PHY1                           91
     C     §§STEP        IFEQ      'J'
     C  N91              MOVEL     '*'           S4PGMK
     C  N91              MOVEL     '*'           H1PGMK
     C                   endif
     C  N91              MOVEL     §§§USR        S4USRC
     C  N91              MOVEL     LDADTP        S4DAYC
     C  N91              TIME                    S4TIMX            6 0
     C  N91              MOVEL     S4TIMX        S4TIMC
     C  N91              MOVE      '00'          S4TIMC
     C  N91              UPDATE    PHY01R
     C  N91              ADD       1             MODREC
     C  N91              ADD       1             E1MOD
     C  N91              EXSR      SR1198
     C  N91              UPDATE    §DDS1§S1
     C                   ENDIF
     C*
     C*
     C     ##STP         ENDSR
     C*
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
     C     *DTAARA       DEFINE                  firma
     C*    aktuelle Firma einlesen
     C                   IN        firma
     C*
     C     *DTAARA       DEFINE                  info01          132
     C*    TAS0001C aktiv im Hintergrund ?
     C*
     C     *DTAARA       DEFINE                  info90          132
     C*
     C     *DTAARA       DEFINE                  info91          132
     C*
     C     *DTAARA       DEFINE                  info92          132
     C*
     C     *DTAARA       DEFINE                  info93          132
     C*
     C     *DTAARA       DEFINE                  info94          132
     C*
     C     *DTAARA       DEFINE                  info95          132
     C*
     C     *DTAARA       DEFINE                  info96          132
     C*
     C     *DTAARA       DEFINE                  info97          132
     C*
     C     *DTAARA       DEFINE                  info98          132
     C*
     C     *DTAARA       DEFINE                  info99          132
     C*
     C     *DTAARA       DEFINE                  info88          132
     C*
     C     *DTAARA       DEFINE                  info89          132
     C*
     C     *DTAARA       DEFINE                  msguser         512
     C*
     C     *DTAARA       DEFINE                  #SYS0005R       256
     C*
     C     *DTAARA       DEFINE                  $SYS0005R       256
     C*
     C     *DTAARA       DEFINE                  savestatus       80
     C* NACHRICHTEN-SFL INITIALISIEREN
     C                   MOVEL     '*'           §§§PGQ
     C                   EXSR      CLRMSG
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   WRITE     §DDS1§D0
     C                   OUT       LDA
     C                   MOVE      '1'           *INLR
     C                   setoff                                       27
     C                   call      '##SYS0005R'
     C                   parm                    §§§USR
     C                   parm                    keyv01
     C                   parm      '0'           fkt               1
     C*
     C*    aktualisieren #auswpf letztes Menü
     c                   exsr      sr2750
     C*
     c                   clear                   #ausber
     C                   movel     'F0   '       #ausber
     C                   move      §§§usr        #ausbwh
     c     #auskey       chain     #auswpf                            94
     c                   clear                   c1F__#            1
     c  n94              eval      %subst(#AUSWBZ:106:10) = keyv01
     C  n94              call      '#DATAKTR'
     C                   parm      '*JMT4'       datmod            5
     C                   parm                    rtncod            1
     C                   parm                    sysges           26
     C                   parm                    sysdat           10
     C                   parm                    syszei            8
     C*                  eval      %subst(#AUSWBZ:71:02) =
     C*                            %subst(sysdat:007:02)
     C*                  eval      %subst(#AUSWBZ:73:01) = '.'
     C*
     C*                  eval      %subst(#AUSWBZ:74:02) =
     C*                            %subst(sysdat:005:02)
     C*                  eval      %subst(#AUSWBZ:76:01) = '.'
     C*
     C*                  eval      %subst(#AUSWBZ:77:04) =
     C*                            %subst(sysdat:001:04)
     C*
     C*
     C*                  eval      %subst(#AUSWBZ:084:02) =
     C*                            %subst(syszei:001:02)
     C*                  eval      %subst(#AUSWBZ:086:01) = ':'
     C*
     C*                  eval      %subst(#AUSWBZ:087:02) =
     C*                            %subst(syszei:003:02)
     C*                  eval      %subst(#AUSWBZ:089:01) = ':'
     C*
     C*                  eval      %subst(#AUSWBZ:100:02) =
     C*                            %subst(syszei:005:02)
     c  n94              update    #auswrf
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
     C/COPY ##PSSR                                         Errorroutine
     C/COPY ##MESSAGES                                     Nachrichten
     C/COPY ##MODATR                                       variabl.Attr.
     C/COPY ##TASTATUR                                     TastatDef.
