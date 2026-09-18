      * PROGRAMMNAME.:FTPI001r                                                
      * FUNKTION.....:FTP-Dialog
      * Feb.2010       GANG, MANFRED
      *                movel     ATR(22) türkis underline inverse
      *                movel     ATR(21) türkis underline
      *                movel     ATR(19) gelb
      *  SELECT A.FAK1020,A.FAK1030,A.FAK5480, A.FAK1750 , A.FAK1060, '5' a
      *  ,B.FAK3120,B.FAK3310, '3' b, A.FAK5090,C.FAK2320, count(*) FROM
      *  gang/F5 a, gang/f3 b, gang/f2 c WHERE a.FAK1030 = c.FAK1030 and
      *  a.FAK1030 = b.FAK1030 and A.FAK1040 = '08' and A.FAK1020 = 40631
      *  and A.FAK1750=b.FAK1750 and A.FAK1750=c.FAK1750 GROUP BY A.FAK1020,
      *  a.FAK1030,A.FAK5480, A.FAK1750, A.FAK1060, B.FAK3120, B.FAK3310 ,
      *  A.FAK5090,C.FAK2320 ORDER BY A.FAK1020, A.FAK1030,A.FAK1060,
      *  A.FAK5090
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     F**************************************************************************
     FFTPI001d  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(DSDSPF)
     F                                     SFILE(§DDS1§S1:SFLRN1)
     F                                     RENAME(FTPI001D0:§DDS1§D0)
     F                                     RENAME(FTPI001D1:§DDS1§D1)
     F                                     RENAME(FTPI001C1:§DDS1§C1)
     F                                     RENAME(FTPI001S1:§DDS1§S1)
     F§000LOG1  IF   E           K DISK    INFSR(*PSSR)
     F****                                 USROPN
     F                                     RENAME(EDIHPF0:LOG01R)
     F                                     INFDS(DSF1)
     F§000PHY1  UF A E             DISK    INFSR(*PSSR)
     F***                                  USROPN
     F                                     RENAME(EDIHPF0:PHY01R)
     FWAEEDILPl1if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(EDILPF0:log02r)
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
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
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
     D  IF16                   1     20    INZ(' F16=Bestandsliste  ')
     D  IF13                  21     40    INZ(' F13=Disponierung   ')
     D CTL001          DS
     D  §§§§§1                 1      9    INZ('FTPI001S1')
     D  §§§§§2                10     18    INZ('FTPI001C1')
     D GR              C                   CONST('ABCDEFGHIJKLMNOPQRS-
     D                                     TUVWXYZßÄÖÜ')
     D KL              C                   CONST('abcdefghijklmnopqrs-
     D                                     tuvwxyzßäöü')
     D*-----------Dateischlüsselbereich ----------------------------------------
     D KEYDAT          DS
     D  §KEY01                 1     07S 0 INZ
     D  §KEY02                08     37    INZ
     D*-----------Startposition Schlüssel---------------------------------------
     D KEYS            DS
     D  KEYS01                 1     07S 0 INZ
     D  KEYS02                08     37    INZ
     D*-----------Range-Area Schlüssel von--------------------------------------
     D KEYV            DS
     D  KEYV01                 1     07S 0 INZ
     D  KEYV02                08     37    INZ
     D*-----------Range-Area Schlüssel bis--------------------------------------
     D KEYB            DS
     D  KEYB01                 1     07S 0 INZ
     D  KEYB02                08     37    INZ
     D*-----------erster modifizierter Satz bei DFTLD=J-------------------------
     D MODK            DS
     D  MODK01                 1     07S 0 INZ
     D  MODK02                08     37    INZ
     D*-----------erster Key in gelesener Subfile ------------------------------
     D FSTK            DS
     D  FSTK01                 1     07S 0 INZ
     D  FSTK02                08     37    INZ
     D*-----------letzter Key in gelesener Subfile -----------------------------
     D LSTK            DS
     D  LSTK01                 1     07S 0 INZ
     D  LSTK02                08     37    INZ
     D*-----------Key in Subfile-Sätze Display-Area-----------------------------
     D KEYFMT          DS
     D  S1KY01                 1     07S 0 INZ
     D  S1KY02                08     37    INZ
     D*-----------Key in Subfile-Sätze Hidden-Area------------------------------
     D KEYHID          DS
     D  H1KY01                 1     07S 0 INZ
     D  H1KY02                08     37    INZ
     D*-----------Clear-Key-Area------------------------------------------------
     D KEYC            DS
     D  KEYC01                 1     07S 0 INZ(0000000)
     D  KEYC02                08     37    INZ('          ')
     D KEYM            DS
     D  KEYM01                 1     07S 0 INZ(9999999)
     D  KEYM02                08     37    INZ('          ')
     I*-------------------------------------------------------------------------
     D KEYSav          DS
     D  K1                     1     07S 0 INZ
     D  K2                    08     37    INZ
     D*-------------------------------------------------------------------------
     Dp                s              5  0
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
     I*input     E psatz
     I**************************************************************************
     I*-------------------------------------------------------------------------
     ILOG01R
     I              EDIH030                     §KEY01
     I              EDIH080                     §KEY02
     IPHY01R
     I              EDIH030                     §KEY01
     I              EDIH080                     §KEY02
     I§DDS1§S1
     I* KEY-AREA
     I              S1EDIH030                   S1KY01
     I              S1EDIH080                   S1KY02
     I* HIDDEN-KEY-AREA
     I              h1EDIH030                   h1KY01
     I              h1EDIH080                   h1KY02
     I* ATTRIBUTE-AREA
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
     C                   PARM                    PKYV01
     C                   PARM                    PKYV02
     C                   PARM                    PKYB01
     C                   PARM                    PKYB02
     C                   PARM                    CTL34             1
     C                   PARM                    CTLRWT            1
     C
     C*                  OPEN      §000log1
     C*                  OPEN      §000phy1
     C*
     C                   clear                   KEYC01
     C                   MOVEL     *HIVAL        KEYM01
     C                   clear                   KEYC02
     C                   MOVEL     *HIVAL        KEYM02
     C*
     C     *LIKE         DEFINE    KEYS01        PKYS01
     C                   z-add     PKYS01        KEYS01
     C     *LIKE         DEFINE    KEYS02        PKYS02
     C                   movel     PKYS02        KEYS02
     C*
     C     *LIKE         DEFINE    KEYV01        PKYV01
     C   50              movel     default       KEYV01
     C  n50              z-add     PKYV01        KEYV01
     C     *LIKE         DEFINE    KEYV02        PKYV02
     C                   movel     PKYV02        KEYV02
     C*
     C     *LIKE         DEFINE    KEYB01        PKYB01
     C                   z-add     PKYB01        KEYB01
     C     *LIKE         DEFINE    KEYB02        PKYB02
     C                   movel     PKYB02        KEYB02
     C*
     C                   SETOFF                                       07
     C*
     C                   Z-ADD     075           FTLNG
     C*                    30+   56789.
     C                   MOVEA     '000001'      FKTTST
     C*AUS *LDA
     C                   clear                   fxrrn
     C     FxRRN         IFNE      *ZERO
     C     FxRRN         CHAIN     §000PHY1                           9191
     C  N91              z-add     §KEY01        KEYS01
     C  N91              UNLOCK    §000PHY1
     C                   ENDIF
     C/COPY ##SUB1FA
     C*
     C     KEYC          IFNE      KEYS
     C                   MOVEL     'J'           CTLLD
     C                   END
     C*
     C     KEYV01        IFEQ      *Zero
     C                   MOVE      *zero         KEYV01
     C                   END
     C     KEYV02        IFEQ      *BLANK
     C                   MOVE      *blank        KEYV02
     C                   END
     C*
     C     KEYB01        IFEQ      *Zero
     C                   Z-add     9999999       KEYB01
     C                   END
     C     KEYB02        IFEQ      *BLANK
     C                   MOVE      *HIVAL        KEYB02
     C                   END
     C*
     C*EIGENE FUNKTIONSTASTE FÜR BEARBEITUNG DATEI
     C                   Z-ADD     16            NEUFNR
     C                   Z-ADD     *ZERO         CTLARB
     C*******nein        MOVEL     IF16          NEUFKT
     C*******nein        MOVEL     '13'          key(13)
     C                   EXSR      FKTPGM
     C*
     C*-------------------------------------------------------------------------
     C* DATEI-SCHLÜSSEL
     C* §000LOG1:
     C     KEY001        KLIST
     C                   KFLD                    §KEY01
     C                   KFLD                    §KEY02
     C*
     C     KEYSR1        KLIST
     C                   KFLD                    S1KY01
     C                   KFLD                    S1KY02
     C*
     C     LSTKEY        KLIST
     C                   KFLD                    LSTK01
     C                   KFLD                    LSTK02
     C*
     C                   z-add     3             zeile
     C                   z-add     10            spalte
     C*
     C*
     C* WINDOW AUSGEBEN
     C                   WRITE     §DDS1§D0
     C                   WRITE     §DDS1§D1
     C*
     C*/COPY ##SUB1DIAL                                    DIALOGSCHL.
     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1DIAL                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN DIALOG
     C* Oktober 2009   GANG, MANFRED
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C* SCHLEIFE FÜR DIALOG
     C*-------------------------------------------------------------------------
     C*
     C* CTLC9=SÄTZE ANLEGEN
     C     CTL89         IFEQ      '1'
     C     CTL83         ANDEQ     '1'
     C                   SETON                                        06
     C                   EXSR      SR1101
     C                   MOVE      'N'           CTLLD
     C                   MOVE      'N'           CTLVLD
     C                   ENDIF
     C*
    C* SCHLEIFE FÜR DIALOG                                START DO
     C                   DO        *HIVAL
     C* SUBFILE LADEN
     C                   EXSR      SR1100
     C     CTLLD         IFEQ      'J'
     C     *IN26         OREQ      '1'
     C                   SETOFF                                       25
     C                   EXSR      SR1101
     C                   SETOFF                                       06
     C                   MOVE      'N'           CTLLD             1
     C                   MOVE      'N'           CTLVLD            1
     C                   END
     C*
     C     SFLRN1        IFEQ      *ZERO
     C                   SETON                                        25
     C                   EXSR      SR1101
     C                   MOVEL     'N'           CTLLD
     C                   END
     I*/COPY ##§§CR
     C                   MOVE      §§§L          §§§B
     C                   MOVE      §§§C          §§§D
     C     §§XP          IFGT      *ZERO
     C                   MOVE      §§§LW         §§§B
     C                   MOVE      §§§CW         §§§D
     C                   ENDIF
     C                   if        Zeile  > 0 and spalte > 0
     C                   MOVE      zeile         §§CRLN
     C                   MOVE      spalte        §§CRCL
     C                   endif
     C*
     C                   WRITE     MSGSFLC
     C                   MOVEA     CTL29         *IN(29)
     C                   MOVEA     FKTTST        *IN(35)
     C                   TIME                    TIMEX
     C                   EXFMT     §DDS1§C1
     C                   EXSR      CLRMSG
     C***                  EXSR SR1100                     ZUWEISUNGEN
     C*
     C                   Z-ADD     §§§SFR        SFLDR1
     C                   MOVE      CTLVLD        VALID             1
     C                   MOVE      'N'           CTLVLD            1
    C* BEARBEITUNG                                        START SELECT
     C                   SELECT
     C* F03=BEENDEN
     C     §§§CFK        WHENEQ    BT03
     C                   MOVEL     '03'          CTLTST
     C                   EXSR      RETURN
     C* F12=ABBRECHEN
     C     §§§CFK        WHENEQ    BT12
     C     CTLVLD        IFEQ      'N'
     C                   MOVEL     '12'          CTLTST
     C                   EXSR      RETURN
     C                   END
     C* F4=BEDIENERFÜHRUNG
     C     §§§CFK        WHENEQ    BT04
     C                   EXSR      SR1200
     C* F4=BEDIENERFÜHRUNG
     C     §§§CFK        WHENEQ    BT09
     C                   EXSR      SR1250
     C* F5=AKTUALISIEREN
     C     §§§CFK        WHENEQ    BT05
     C                   MOVE      'J'           CTLLD
     C                   MOVE      'N'           CTLVLD
     C                   MOVEL     FSTK          MODK
     C* F08=BLÄTTERN RÜCKWERTS
     C     §§§CFK        WHENEQ    BT08
     C     LSTKEY        SETGT     §000LOG1
     C     SFLAS1        ADD       SFLPG1        SFLBK1
     C     1             DO        SFLBK1
     C                   READP     §000LOG1                               91
     C     KEYDAT        IFLT      KEYV
     C                   SETON                                        91
     C                   ENDIF
     C   91              LEAVE
     C                   EXSR      SR1120
     C     CTLPRF        IFEQ      '1'
     C     SFLBK1        ADD       1             SFLBK1
     C                   ENDIF
     C                   ENDDO
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'AL00009'     MSG
     C                   MOVEL     §§CRR         IEOF01
     C                   MOVEL     §KEY01        IEOF03
     C                   MOVEA     CTLEOF        MD
     C                   EXSR      SNDMSG
     C                   CLEAR                   KEYS
     C                   ELSE
     C                   MOVEL     KEYDAT        KEYS
     C                   END
     C                   EXSR      SR1101
     C* F07=BLÄTTERN VORWÄRTS
     C     *IN07         WHENEQ    '1'
     C     §§§CFK        OREQ      BT07
     C     CTLF07        IFNE      '1'
     C                   MOVEL     'AL00010'     MSG
     C                   MOVEL     §§CRR         IEOF01
     C                   MOVEL     §KEY01        IEOF03
     C                   MOVEA     CTLEOF        MD
     C                   EXSR      SNDMSG
     C                   ELSE
     C                   CLEAR                   FSTK
     C                   EXSR      SR1111
     C                   END
     C* HELP
     C     §§§CFK        WHENEQ    FHELP
     C*
     C* F24=PF-TASTEN-WECHSEL
     C     §§§CFK        WHENEQ    BT24
     C                   EXSR      FKTPGM
     C                   WRITE     §DDS1§D1
     C*
     C* F10=WECHSELN ZUR COMMAND-LINE DER AS/400
     C     §§§CFK        WHENEQ    BT10
     C                   CALL      'QUSCMDLN'
     C*
     C* F13=SONSTIGE FREI WÄHLBARE FUNKTIONEN
     C     §§§CFK        WHENEQ    BT13
     C                   EXSR      SRFK13
     C*
     C* F16=SONSTIGE FREI WÄHLBARE FUNKTIONEN
     C     §§§CFK        WHENEQ    BT16
     C                   EXSR      SRFK16
     C*
     C* PGM BEENDEN ODER WEITERE VERARBEITUNG
     C                   OTHER
     C     SFLRN1        IFNE      *ZERO
     C                   EXSR      SR1401
     C                   END
     C     KEYS          IFNE      KEYC
     C                   MOVE      'J'           CTLLD
     C                   END
     C     CTLCHG        IFEQ      'N'
     C     CTLVLD        ANDEQ     'N'
     C     KEYS          ANDEQ     KEYC
     C     §§§CFK        ANDNE     BT06
     C****> NO             EXSR RETURN
     C                   MOVEL     'USR0001'     MSG
     C                   MOVEL     'SYGMSG '     MSGF
     C                   EXSR      SNDMSG
     C                   MOVEL     '       '     MSGF
     C                   END
     C     *IN28         IFEQ      '0'
     C     §§§CFK        ANDEQ     BT06
     C                   SETON                                        06
     C                   MOVEL     'J'           CTLLD
     C                   END
     C*
     C                   ENDSL
    C* BEARBEITUNGSENDE                                   ENDE SELECT
     C*
     C                   MOVE      'N'           CTLCHG
     C*
     C                   ENDDO
    C* ENDE DER SCHLEIFE FÜR DIALOG                       END DO
     C*
     C*/COPY ##SUB1CTLA                                    SR1101SR1111
     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1CTLA                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN CLEAR/READ 1.SUBFILE
     C* 10.02.99       GANG, MANFRED
     C* 28.06.01       GANG, MANFRED
     C*                clear auf Format nur wenn *IN27 = '0'
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C* SR1101: SUBFILE #1 LADEN/AUFRUF WEITERE STEUERUNG
     C*-------------------------------------------------------------------------
     C*
     C     SR1101        BEGSR
     C*
     C*
     C     DFTLD         IFEQ      'J'
     C     §§§CFK        OREQ      BT05
     C     MODK          IFNE      KEYC
     C                   MOVEL     MODK          KEYS
     C                   CLEAR                   MODK
     C                   END
     C                   END
     C*
     C                   MOVEL     KEYS          KEYDAT
     C                   CLEAR                   FSTK
     C*
     C                   MOVE      '0'           *IN31
     C                   CLEAR                   KEYS
     C                   WRITE     §DDS1§C1
     C                   MOVE      '1'           *IN31
     C                   EXSR      SRATTR
     C                   Z-ADD     *ZERO         SFLRN1
     C                   Z-ADD     *ZERO         SFLAS1
     C                   Z-ADD     *ZERO         SFLDR1
     C*
     C     *IN06         IFEQ      '1'
     C     *IN25         OREQ      '1'
     C                   EXSR      SR1131
     C                   ELSE
     C*          KEY001    SETLL§000LOG1
     C     KEYV01        ifne      *zero
     C                   EXSR      SR1111
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     ##1101        ENDSR
     C*
     C**************************************************************************
     C* SR1111: DATEI LESEN UM SUBFILE #1 ZU FÜLLEN
     C*-------------------------------------------------------------------------
     C*
     C     SR1111        BEGSR
     C*
     C                   Z-ADD     *ZERO         DISREC            5 0
     C                   MOVE      '0'           CTLF07
     C                   SETOFF                                       98
     C     SFLRN1        DIV       SFLPG1        CTLSF             5 1
     C     CTLSF         MULT      10            CTLSF1            1 0
     C                   Z-ADD     CTLSF         CTLSF2            5 0
     C     CTLSF1        IFGT      0
     C                   Z-ADD     1             SFLAS1
     C                   ELSE
     C                   Z-ADD     *ZERO         SFLAS1
     C                   ENDIF
     C                   SETON                                        32
     C     *IN07         IFEQ      '1'
     C     §§§CFK        OREQ      BT07
     C     KEY001        SETGT     §000LOG1
     C                   ELSE
     C     KEY001        SETLL     §000LOG1
     C                   ENDIF
     C                   DO        *HIVAL
     C                   READ      §000LOG1                               95
     C     *IN95         IFEQ      '1'
     C     SFLAS1        OREQ      SFLPG1
     C                   LEAVE
     C                   ENDIF
     C     KEYDAT        IFGT      KEYB
     C     KEYDAT        orEQ      KEYB
     C                   READP     §000LOG1                               95
     C                   SETON                                        95
     C                   LEAVE
     C                   ENDIF
     C     KEYDAT        IFGT      KEYV
     C     KEYDAT        oreq      KEYV
     C                   MOVE      '0'           CTLPRF            1
     C                   MOVE      '1'           ok                1
     C                   EXSR      SR1120
     C     CTLPRF        IFEQ      '0'
     C                   EXSR      SR_leer
     C***                CLEAR                   §DDS1§S1            alt
     C  N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   EXSR      SR1121
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   exsr      sr9100
     C                   MOVEL     KEYDAT        LSTK
     C     FSTK          IFEQ      KEYC
     C                   MOVEL     KEYDAT        FSTK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C*
     C     SFLRN1        DIV       SFLPG1        CTLSF             5 1
     C                   Z-ADD     CTLSF         CTLSF2            5 0
     C     SFLPG1        MULT      CTLSF2        SFLDR1
     C                   SUB       SFLPG1        SFLDR1
     C                   ADD       1             SFLDR1
     C     *IN95         IFEQ      '1'
     C     SFLAS1        ANDGT     *ZERO
     C     SFLAS1        ANDLT     SFLPG1
     C     SFLPG1        ADD       SFLDR1        SFLDR1
     C                   ENDIF
     C*
     C     *IN95         IFEQ      '0'
     C                   READP     §000LOG1                               95
     C                   MOVE      '1'           CTLF07
     C                   SETOFF                                       98
     C                   ELSE
     C     SFLAS1        IFGT      SFLPG1
     C                   MOVE      '1'           CTLF07
     C                   SETON                                        98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C                   ENDIF
     C*
     C     SFLRN1        IFGT      1
     C                   SETOFF                                       32
     C                   ENDIF
     C*
     C     DISREC        IFGT      1
     C                   MOVEL     DISREC        TXT5              5
     C                   MOVEA     TXT5          MD
     C                   MOVEL     'AL00035'     MSG
     C                   EXSR      SNDMSG
     C                   ENDIF
     C*
     C                   Z-ADD     *ZERO         §§CRLN
     C                   Z-ADD     *ZERO         §§CRCL
     C*
     C     ##1111        ENDSR
     C*
     C**************************************************************************
     C* SR1100: SONSTIGE ZUWEISUNGEN NACH READ FORMAT ALS VORLAUF
     C*-------------------------------------------------------------------------
     C*
     C     SR1100        BEGSR
     C*
     C                   seton                                        27
     C*
     C                   clear                   ##sflas1
     C                   move      keys          keydat
     C                   move      keys          keysav
     C                   move      *hival        keyb02
     C     key001        setll     §000log1                           91
     C  n91              read      §000log1                               91
     C   91              clear                   keyfmt
     C  n91              move      keydat        keyfmt
     C*
     C                   move      keysav        keys
     C                   if        keys01 <> *zero
     C                   z-add     keys01        keyb01
     C                   endif
     C*
     C                   seton                                        27
     C     §§§cfk        ifeq      BT05
     C                   MOVE      'J'           CTLLD
     C                   endif
     C*
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
     C
     c                   IF        CTLPRF = '0' and keyv02 <> *blank
     c                   If        %subst(keyv02:01:01) <> %subst(§key02:01:01)
     c                             and %subst(keyv02:01:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:02:01) <> %subst(§key02:02:01)
     c                             and %subst(keyv02:02:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:03:01) <> %subst(§key02:03:01)
     c                             and %subst(keyv02:03:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:04:01) <> %subst(§key02:04:01)
     c                             and %subst(keyv02:04:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:05:01) <> %subst(§key02:05:01)
     c                             and %subst(keyv02:05:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:06:01) <> %subst(§key02:06:01)
     c                             and %subst(keyv02:06:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:07:01) <> %subst(§key02:07:01)
     c                             and %subst(keyv02:07:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:08:01) <> %subst(§key02:08:01)
     c                             and %subst(keyv02:08:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:09:01) <> %subst(§key02:09:01)
     c                             and %subst(keyv02:09:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     c                   If        %subst(keyv02:10:01) <> %subst(§key02:10:01)
     c                             and %subst(keyv02:10:01) <> *blank
     C                   MOVEL     '1'           CTLPRF
     C                   goto      ##1120
     C                   ENDIF
     C                   ENDIF
     c*
     C*                 %subst(c1search1:01:10) <> *blank                     
     c                   IF        CTLPRF = '0'
     C*****              MOVEL     '0'           ok                1
     c                   if        %subst(c1search1:01:10) <> *blank  and
     c                             %subst(C1OPTION:01:1)  = *blank
     c*#####
     C                   z-add     1             clinen            5 0
     C     keyline       SETLL     WAEEDILPL1                         99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDILPL1                             99
     C     *IN99         IFEQ      '1'
     C     §key01        ORNE      EDIl030
     C     EDIH040       ORNE      EDIl040
     C                   LEAVE
     C                   else
     C                   seton                                        88
     c                   if        (%subst(c1search1:01:10) =
     c                              %subst(edil220:01:10) and OK = '1')
     c                   movel     '0'           ok
     c                   else
     C                   setoff                                       55
     C                   exsr      sr5801
     C                   exsr      sr5802
     C                   setoff                                       55
     c                   endif
     C                   setoff                                       88
     C                   endif
     c                   enddo
     C                   endif
     c*#####innere
     c                   IF        ok     = '1'
     C                   MOVEL     '1'           CTLPRF
     c                   endif
     C                   ENDIF
     C                   ENDIF
     c*
     C*                 *in55 Errorabfrage  ( zusätzlich )                    
     C*                 + Suche Artikel %subst(c1search1:01:10)               
     c                   IF        CTLPRF = '0'
     c                   if        %subst(C1OPTION:01:1)  = 'E' and
     c                             %subst(c1search1:01:10) <> *blank
     C                   z-add     1             clinen            5 0
     C     keyline       SETLL     WAEEDILPL1                         99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDILPL1                             99
     C     *IN99         IFEQ      '1'
     C     §key01        ORNE      EDIl030
     C     EDIH040       ORNE      EDIl040
     C                   LEAVE
     C                   else
     C                   seton                                        88
     c*******
     c                   if        (%subst(c1search1:01:10) =
     c                              %subst(edil220:01:10) and OK = '1')
     C                   movel     '0'           ok
     C                   setoff                                       55
     C                   exsr      sr5801
     C                   exsr      sr5802
     C   55              movel     '1'           ok
     C                   setoff                                       55
     c                   else
     C                   setoff                                       55
     C                   if        ok       = '1'
     C                   exsr      sr5801
     C                   exsr      sr5802
     C   55              movel     '1'           ok
     c                   endif
     C                   setoff                                       55
     c                   endif
     c*********
     C                   setoff                                       88
     C                   endif
     c                   enddo
     C                   endif
     c*#####innere
     c                   IF        ok     = '1'
     C                   MOVEL     '1'           CTLPRF
     c                   endif
     C                   ENDIF
     C                   ENDIF
     c*
     C*                 *in55 Errorabfrage  ( ausschließlich )                
     c                   IF        CTLPRF = '0'
     c                   if        %subst(C1OPTION:01:1)  = 'E' and
     c                             %subst(c1search1:01:10) =  *blank
     C                   z-add     1             clinen            5 0
     C     keyline       SETLL     WAEEDILPL1                         99
     C     *IN99         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDILPL1                             99
     C     *IN99         IFEQ      '1'
     C     §key01        ORNE      EDIl030
     C     EDIH040       ORNE      EDIl040
     C                   LEAVE
     C                   else
     C                   seton                                        88
     c*******
     C                   setoff                                       55
     C                   exsr      sr5801
     C                   exsr      sr5802
     C  n55              movel     '0'           ok
     C                   setoff                                       55
     c*********
     C                   setoff                                       88
     C                   endif
     c                   enddo
     C                   endif
     c*#####innere
     c                   IF        ok     = '1'
     C                   MOVEL     '1'           CTLPRF
     c                   endif
     C                   ENDIF
     C                   ENDIF
     c*
     c*                  eval      p = %scan(keyv02 : §KEY02)
     C*
     C     ##1120        ENDSR
     C*
     C**************************************************************************
     C* SR1120II: SONSTIGE PRÜFUNGEN  CTRPRF=0 ==> OK
     C*-------------------------------------------------------------------------
     C*
     C     SR1120II      BEGSR
     C*
     C* n80              movel     FAK5090       feld10           10
     C*  80              movel     au5090        feld10           10
     C* 55='1' in jedem gültiger Auftragseintrag, kein ERROR
     C                   seton                                        55
     C*
     c                   if        %subst(c1search1:01:10) <> *blank
     C*
     c                   if        ((%subst(c1search1:01:10) =
     c                              %subst(fak5090:01:10) and *in80='0')  or
     c                             (%subst(c1search1:01:10) =
     c                              %subst(au5090:01:10) and *in80='1')  or
     c                             (%subst(c1search1:01:10) =
     c                              %subst(edil220:01:10) ))
     C                   MOVEL     '0'           ok
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     ##1120II      ENDSR
     C*
     C**************************************************************************
     C* SR1121: SUBFILE-SÄTZE AUFBEREITEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1121        BEGSR
     C*
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   exsr      sr9000
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   move      keysav        keys
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
     C* SONSTIGE
     C                   MOVEA     ATR(33)       §§ausgabe
     C* CONTROL-RECORD
     C*                  MOVEA     ATR(33)       §§OP
     C                   MOVEA     ATR(07)       §§§V01
     C                   MOVEA     ATR(07)       §§§V02
     C                   MOVEA     ATR(07)       §§search
     C                   MOVEA     ATR(33)       §§kw
     C                   MOVEA     ATR(33)       §§search2
     C*
     C     ##1198        ENDSR
     C*
     C**************************************************************************
     C* SR1199: VARIABLE ATTRIBUTSTEUERUNG
     C*-------------------------------------------------------------------------
     C*
     C     SR1199        BEGSR
     C* KEYBEREICH
     C* SONSTIGE
     C* CONTROL-RECORD
     C*                  MOVEA     ATTO          §§OP
     C                   MOVEA     ATR(33)       §§ausgabe
     C*  06                MOVEAATR,33    §§OP
     C                   MOVEA     ATR(7)        §§§V01
     C   06              MOVEA     ATR(07)       §§§V01
     C   50              MOVEA     ATR(33)       §§§V01
     C                   MOVEA     ATR(7)        §§§V02
     C   06              MOVEA     ATR(07)       §§§V02
     C                   MOVEA     ATR(33)       §§kw
     C                   MOVEA     ATR(07)       §§search
     C                   MOVEA     ATR(33)       §§search2
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
     C***  *IN89         ANDEQ     '1'
     C                   Z-ADD     §§CRN         SFLRN1
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C  N91              movel     s1ky01        PKYS01
     C  N91              movel     s1ky02        PKYS02
     C  N91              Z-ADD     S1F1RR        FXRRN
     C  N91              EXSR      RETURN
     C   91              MOVEL     'AL00002'     MSG
     C   91              EXSR      SNDMSG
     C   91              MOVE      'F'           CTLVLD
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
     C* SR1255: F9=reload funktion
     C*-------------------------------------------------------------------------
     C*
     C     SR1250        BEGSR
     C*
     C                   MOVEL     'DOMWECOSQL'  MSGF
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
     C***  *IN89         ANDEQ     '1'
     C                   if        (§§§USR='HARTMANN' or
     C                              §§§USR='CAIRO   ' or
     C                              §§§USR='BERRUE  ' or
     C                              §§§USR='BOWLER  ' or
     C                              §§§USR='GANG    ')
     C                   Z-ADD     §§CRN         SFLRN1
     C                   movel     '0'           mod
     C                   movel     H1EDIH040     text2
     C                   z-add     KEYV01        kunde
     C     SFLRN1        CHAIN     §DDS1§S1                           91
     C  N91              movel     s1ky01        PKYS01
     C  N91              movel     s1ky02        PKYS02
     C  N91              Z-ADD     S1F1RR        FXRRN
     C  N91              call      'QM0002C'
     C                   parm                    Text
     C                   parm      '006'         xPos              3
     C                   parm      '05'          yPos              2
     C                   parm      '0'           dspMod            1
     C                   parm                    Mod              32
     C                   parm                    kunde             7 0
     C                   parm                    H1EDIH040
     C                   else
     C                   MOVEL     'AL00003'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   endif
     C
     C   91              MOVEL     'AL00002'     MSG
     C   91              EXSR      SNDMSG
     C   91              MOVE      'F'           CTLVLD
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
     C*
     C* POSITION UNGÜLTIG
     C                   ELSE
     C                   MOVEL     'AL00002'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   ENDIF
     C*
     C     ##1250        ENDSR
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
     C                   MOVEl     'Ä'           s1OP
     C                   MOVE      '1'           *IN34
     C                   EXSR      SR1505
     C                   EXSR      SR1506
     C                   MOVEA     FUNKT         *IN(81)
     C                   UPDATE    §DDS1§S1
     C                   ENDIF
     C                   ENDDO
     C*
     C*                    ENDIF
     C*
     C* SUBFILE BEARBEITEN
     C*                  EXSR      SR1401
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
     C                   movel     ' '           DR0021x           1
     C                   SETOFF                                       28
     C                   Z-ADD     SFLDR1        SAVDR1
     C                   Z-ADD     *ZERO         SFLDR1
     C                   Z-ADD     *ZERO         CRTREC
     C                   Z-ADD     *ZERO         MODREC
     C                   Z-ADD     *ZERO         DLTREC
     C                   Z-ADD     *ZERO         HELP1             1 0
     C                   clear                   count             3 0
     C*
     C     1             DO        *HIVAL
     C                   READC     §DDS1§S1                               91
     C                   MOVE      '0'           *IN34
     C   91              LEAVE
     C                   eval      count = count + 1
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
     C                   if        d3op = ' S'
     C                   eval      d3op = 'S '
     C                   endif
     C                   SELECT
     C*
     C* SÄTZE KOPIEREN
     C*    D3OP          WHENEQ    'K'
     C*    D3OP          OREQ      'X'
     C*    §§§CFK        ANDEQ     BT15
     C*                  EXSR      SR1601
     C*                  EXSR      SR1402
     C* AUSWAHL SATZ DRUCKEN
     C*    D3OP          WHENEQ    'D'
     C*    D3OP          OREQ      'X'
     C*    §§§CFK        ANDEQ     BT21
     C*                  EXSR      SR1701
     C* AUSWAHL SATZ MODIF.
     C*    D3OP          WHENEQ    'N'
     C*    D3OP          OREQ      'X'
     C*    §§§CFK        ANDEQ     BT06
     C*                  CLEAR                   S1F1RR
     C*                  EXSR      SR1801
     C*                  EXSR      SR1402
     C* AUSWAHL SATZ MODIF.
     C     D3OP          WHENEQ    '1'
     C     D3OP          OREQ      '1'
     C*    §§§CFK        ANDEQ     BT02
     C*****              if        $$$tra <> '  ' or  $$$cty <> ' '
     C*****              EXSR      SR1801
     C*****              EXSR      SR1402
     C*****              Endif
     C* AUSWAHL SATZ MODIF.
     C* LÖSCHEN SÄTZE
     C*    D3OP          WHENEQ    'L'
     C*    D3OP          OREQ      'X'
     C*    §§§CFK        ANDEQ     BT23
     C*                  MOVE      'D'           CTLMOD
     C*                  EXSR      SR1901
     C*                  EXSR      SR1402
     C* KEINE OPTION
     C*    D3OP          WHENEQ    ' '
     C*                  MOVE      'N'           CTLCHG
     C*                    MOVE 'J'       CTLLD
     C* FALSCHE FUNKTION ODER CODE
     C                   OTHER
     C                   MOVE      '1'           *IN60
     C                   MOVEL     'AL00024'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C*
     C                   ENDSL
     C                   END
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
     C*
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
     C*
     C**************************************************************************
     C* SR1501: PRÜFUNGEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1500        BEGSR
     C*
     C*/COPY ##OPCODE                                       SR1500
     C*
     C*
     C     ##1500        ENDSR
     C*
     C**************************************************************************
     C* SR1501: PRÜFUNGEN FÜR SUBFILE #1
     C*-------------------------------------------------------------------------
     C*
     C     SR1501        BEGSR
     C*
     C                   EXSR      SRATTR
     C     D3OP          IFNE      'X'
     C                   EXSR      SR1500
     C                   ENDIF
     C     CTLVLD        IFEQ      'F'
     C                   MOVE      '1'           *IN60
     C*                  MOVEA     ATR(9)        §§OP
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
     C     ##1501        ENDSR
     C*
     C**************************************************************************
     C* SR1502: SATZMODIFIZIERUNG DURCH EINEN ANDEREN ANWENDER?
     C*-------------------------------------------------------------------------
     C*
     C     SR1502        BEGSR
     C* platz nicht prüfen
     C     KEYHID        IFNE      KEYDAT
     C                   MOVEL     'AL00015'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   SETON                                        60
     C*                  MOVEA     ATR(9)        §§OP
     C                   MOVE      ' '           CTLMOD
     C                   ENDIF
     C*    H1KY01        IFNE      §KEY01
     C*                  SETON                                        61
     C*                  MOVEA     ATR(9)        §§KY01
     C*                  ENDIF
     C*
     C     ##1502        ENDSR
     C*
     C**************************************************************************
     C* SR1503: KENNWORTEINGABE OK
     C*-------------------------------------------------------------------------
     C*
     C     SR1503        BEGSR
     C*
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
     C                   ENDIF
     C     D3OP          IFEQ      'Ä'
     C     §§§CFK        OREQ      BT02
     C     CTLRWT        IFNE      'J'
     C     KEYFMT        ANDNE     KEYHID
     C                   MOVEL     'AL00031'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   MOVE      ' '           CTLMOD
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
     C                   MOVEL     'AL00048'     MSG
     C                   MOVEL     S1KY01        IMSG02
     C                   MOVEL     I§§009        IMSG03
     C                   MOVEA     CTLMSG        MD
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   SETON                                        60
     C*                  MOVEA     ATR(9)        §§OP
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
     c                   EXSR      SR1506
     C     S1F1RR        IFNE      *ZERO
     C     CTLMOD        ANDEQ     ' '
     C                   UNLOCK    §000PHY1
     C                   ENDIF
     C*
     C     CTLMOD        IFNE      ' '
     C                   MOVEL     KEYFMT        KEYDAT
     C                   MOVEL     KEYDAT        KEYHID
     C                   CLEAR                   S1OP
     C     CTLMOD        IFEQ      'W'
     C     S1KY01        IFEQ      *zero
     C                   MOVEL     §§§USR        S1KY01
     C                   ENDIF
     C                   WRITE     PHY01R
     C                   ADD       1             CRTREC
     C                   ADD       1             E1CRT
     C                   MOVE      'J'           CTLCHG            1
     C                   MOVE      'J'           CTLLD
     C                   MOVEL     I§§010        IMSG03
     C                   EXSR      MSG001
     C                   ELSE
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
     C**************************************************************************
     C* SRFK13: ???
     C*-------------------------------------------------------------------------
     C*
     C     SRFK13        BEGSR
     C*
     C*
     C     ##FK13        ENDSR
     C*
     C**************************************************************************
     C* SRFK16: AUFRUF CALL
     C*-------------------------------------------------------------------------
     C*
     C     SRFK16        BEGSR
     C*
     C*
     C     ##FK16        ENDSR
     C*
     C**************************************************************************
     C* lesen aus #auswpf     Firma     holen aus #auswpf
     C*-------------------------------------------------------------------------
     C*
     C     sr2700        BEGSR
     C*
     C     KEY2700       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c                   clear                   $key1
     c                   clear                   $key2
     c                   clear                   $key3
     C                   movel     'WAECO'       $key1
     C                   movel     §§§usr        $key2
     C                   movel     'PROFILE'     $key3
     C*
     c     KEY2700       chain     systempf                           94
     c                   clear                   c1F__#            1
     c                   clear                   default           7
     c  n94              eval      default    =  %subst($P2:001:07)
     c  n94              testn                   default              50
     c  n94              if        *in50 = '1' and default <> '0000000'
     c                   movel     default       KEYV01
     c                   else
     c                   setoff                                       50
     c                   endif
     C*
     C     ##2700        ENDSR
     C*
     C**************************************************************************
     C* Ausgabe Kopfsatz
     C*-------------------------------------------------------------------------
     C*
     C     SR9000        BEGSR
     C*
      *                 Datum Eingang
     C                   move      edih060       #060              8
     C                   eval      %subst(feld10:1:02) =  %subst(#060:7:02)
     C                   eval      %subst(feld10:3:01) =  '.'
     C                   eval      %subst(feld10:4:02) =  %subst(#060:5:02)
     C                   eval      %subst(feld10:6:01) =  '.'
     C                   eval      %subst(feld10:7:04) =  %subst(#060:1:04)
     C                   move      feld10        feld11           11
     C                   movel     ATR(27)       feld11
     C                   movea(p)  feld11        md(001)
      *
      *                 Bestellung
     C                   movel     §KEY02        feld10           10
     C                   move      feld10        feld11
     C                   movel     ATR(27)       feld11
     C                   movea(p)  feld11        md(014)
      *
     C                   if        %subst(EDIH370:1:01) <> '0' and
     C                             %subst(EDIH370:1:01) <> ' '
      *                 priority identifier
     C                   eval      %subst(feld02:2:01) = %subst(EDIH370:1:1)
     C                   movel     ATR(13)       feld02            2
     C                   movea(p)  feld02        md(022)
     C                   endif
     C                   movel(p)  ATR(01)       md(024)
      *
     C                   if        %subst(EDIH370:2:01) =  '1'
      *                 Only full order delivery allowed
     C                   eval      %subst(feld05:2:04) = 'full'
     C                   movel     ATR(13)       feld05            5
     C                   movea(p)  feld05        md(025)
     C                   endif
      *
      *                 Datum Termin
     C                   move      edih090       #060              8
     C                   eval      %subst(feld10:1:02) =  %subst(#060:7:02)
     C                   eval      %subst(feld10:3:01) =  '.'
     C                   eval      %subst(feld10:4:02) =  %subst(#060:5:02)
     C                   eval      %subst(feld10:6:01) =  '.'
     C                   eval      %subst(feld10:7:04) =  %subst(#060:1:04)
     C                   move      feld10        feld11
     C                   movel     ATR(27)       feld11
     C                   if        %subst(EDIH370:3:01) =  '1'
      *                 delivery date must be exactly
     C                   movel     ATR(13)       feld11
     C                   endif
     C                   movea(p)  feld11        md(030)
     C                   movel(p)  ATR(01)       md(041)
     C*
      *                 Vers.Adr. PLZ
     C                   if        EDIH260 > 0
     C                   z-add     edih260       nummer
     C                   z-add     0             anzdec
     C                   z-add     07            maxlng
     C                   z-add     00            atrind
     C                   exsr      sr3000
     c                   movel     ATR(27)       txt08
     C                   movea(p)  txt08         md(42)
     C                   else
     C                   endif
      *
      *                 Kunde
     C                   movel     edih210       feld20           20
     C                   move      feld20        feld21           21
     C                   movel     ATR(27)       feld21
     C                   movea(p)  feld21        md(049)
      *
     C*
      *                 AUSGABE-übergeben
     C                   movea(p)  md            s1ausgabe
      *
      *                 hidden-fields
     C                   z-add     §KEY01        h1KY01
     C                   z-add     EDIH040       H1EDIH040
     C                   movel     EDIL220       H1EDIL220
     C*
     C     ##9000        ENDSR
     C*
     C**************************************************************************
     C* Ausgabe Dateilsatz
     C*-------------------------------------------------------------------------
     C*
     C     SR9001        BEGSR
     C*
      *                 Artikel
     C                   movel     EDIL220       feld10           10
     C                   move      feld10        feld11
     C                   movel     ATR(26)       feld11
     C                   movea(p)  feld11        md(001)
     C                   movea(p)  ' '           md(012)
      *
      *                 Position
     C                   if        EDIL050 > 0
     C                   z-add     EDIL050       nummer
     C                   z-add     0             anzdec
     C                   z-add     04            maxlng
     C                   z-add     01            atrind
     C                   exsr      sr3000
     c                   movel     ATR(26)       txt04
     C                   movea(p)  txt04         md(13)
     c                   movel     atr(03)       md(17)
     C                   else
     C                   endif
     C*
      *                 Menge
     C                   if        EDIL240 > 0
     C                   z-add     EDIL240       nummer
     C                   z-add     3             anzdec
     C                   z-add     10            maxlng
     C                   z-add     01            atrind
     C                   exsr      sr3000
     c                   movea(p)  ATR(26)       md(32)
     C                   movea(p)  txt10         md(33)
     C                   else
     C                   endif
      *
      *                 Artikelbezeichnung Kunde
     C                   movel     EDIL230       feld20           20
     C                   move      feld20        feld21           21
     C                   movel     ATR(26)       feld21
     C                   movea(p)  feld21        md(042)
     C                   movea(p)  ' '           md(063)
     C*
      *                 AUSGABE-übergeben
     C                   movea(p)  md            s1ausgabe
      *
      *                 hidden-fields
     C                   z-add     §KEY01        h1KY01
     C                   z-add     EDIH040       H1EDIH040
     C                   movel     EDIL220       H1EDIL220
     C*
     C     ##9001        ENDSR
     C*
     C**************************************************************************
     C* Ausgabe rechnungssatz N80 / Auftragssatz 80
     C*-------------------------------------------------------------------------
     C*
     C     SR9002        BEGSR
     C*
     c                   seton                                        55
      *                 Auftrag
     C  n80              move      fak1030       feld07           07
     C   80              move      au5030        feld07           07
     C  n80              movel     ATR(25)       feld07
     C   80              movel     ATR(22)       feld07
     C                   movea(p)  feld07        md(001)
      *
      *                 Auftragsart
     C  n80              move      FAK1040       feld03           03
     C   80              move      au5040        feld03           03
     C                   movel     ATR(27)       feld03
     C                   movea(p)  feld03        md(008)
      *
      *                 Artikel
     C  n80              movel     FAK5090       feld10           10
     C   80              movel     au5090        feld10           10
     C                   move      feld10        feld11
     C                   movel     ATR(27)       feld11
     C                   movea(p)  feld11        md(012)
      *
      *                 Position
     C  n80              z-add     fak1060       §§                2 0
     C   80              z-add     au5060        §§
     C                   if        §§      > 0
     C                   z-add     §§            nummer
     C                   z-add     0             anzdec
     C                   z-add     04            maxlng
     C                   z-add     01            atrind
     C                   exsr      sr3000
     c                   movel     ATR(26)       txt04
     C                   movea(p)  txt04         md(21)
     c                   movel     atr(03)       md(22)
     C                   else
     C                   endif
      *
      *                 Rechnungs# bei Rechnung
     C  n80              move      FAK1750       feld07           07
     C  n80              movel     ATR(27)       feld07
     C  n80              movea(p)  feld07        md(025)
     C*
      *                 Lieferdatum
     C  n80              movel     fak5480       #060
     C   80              movel     au5460        #060
     C  n80              if        #060    <> '      '
     C                   eval      %subst(feld10:1:02) =  %subst(#060:1:02)
     C                   eval      %subst(feld10:3:01) =  '.'
     C                   eval      %subst(feld10:4:02) =  %subst(#060:3:02)
     C                   eval      %subst(feld10:6:01) =  '.'
     C                   eval      %subst(feld10:7:02) =  '20'
     C                   eval      %subst(feld10:9:02) =  %subst(#060:5:02)
     C                   move      feld10        feld11
     C                   movel     ATR(27)       feld11
     C                   movea(p)  feld11        md(032)
     C                   else
     C                   endif
     C*
      *                 Menge Lieferschein
     C  n80              if        fak5320 > 0
     C                   z-add     fak5320       nummer
     C                   z-add     0             anzdec
     C                   z-add     5             maxlng
     C                   z-add     01            atrind
     C                   exsr      sr3000
     c                   movea(p)  ATR(11)       md(34)
     C                   movea(p)  txt05         md(35)
     C                   endif
      *
      *                 Artikelzusatzdaten
     C                   exsr      sr_art
     C*
     c  n92              if         edih060  < anldat
     C                   movea(p)  #anldat       md(048)
     c                   endif
     C*
     C                   if        *in92 = '0'  and art100 <> *blank
     C                   clear                   feld10
     C                   movel     art100        feld10
     C                   movea(p)  feld10        md(059)
     C                   endif
     C  n92              movea(p)  art180        md(070)
      *
     C*
      *                 AUSGABE-übergeben
     C                   movea(p)  md            s1ausgabe
     C*
      *                 hidden-fields
     C                   z-add     §KEY01        h1KY01
     C                   z-add     EDIH040       H1EDIH040
     C                   movel     EDIL220       H1EDIL220
     C*
     C     ##9002        ENDSR
     C*
     C**************************************************************************
     C* Ausgabe error kein rechnungssatz N80 und Auftragssatz 80
     C*-------------------------------------------------------------------------
     C*
     C     SR9002e       BEGSR
     C*
     c                   seton                                        55
      *                 Auftrag
     C                   clear                   error            65
     C                   eval      Error=
     C                             ' missing order, no bill and entry'
     C                   exsr      sr_art
     C                   movel     ATR(27)       error
     C                   movea(p)  error         md(001)
     C*
      *                 AUSGABE-übergeben
     C                   movea(p)  md            s1ausgabe
     C*
     C     ##9002e       ENDSR
     C*
     C**************************************************************************
     C* Formatierung von Werten bzw. Zeichen
     C*-------------------------------------------------------------------------
     C*
     C     SR3000        BEGSR
     C*
     C                   if        format = ' '
     C                   eval      format = 'J'
     C                   endif
     C                   call      '#CVTNUMCR'
     C                   parm                    alpha            21
     C                   parm                    nummer           15 5
     C                   parm                    anzdec           01 0
     C                   parm                    format           01
     C                   parm      'N'           aufrnd           01
     C                   parm                    atrind           02 0
     C                   parm                    maxlng           02 0
     C                   parm                    rtnlng           02 0
     C*
     C                   movel     alpha         txt15            15
     C                   movel     alpha         txt14            14
     C                   movel     alpha         txt13            13
     C                   movel     alpha         txt12            12
     C                   movel     alpha         txt11            11
     C                   movel     alpha         txt10            10
     C                   movel     alpha         txt03            03
     C                   movel     alpha         txt04            04
     C                   movel     alpha         txt05            05
     C                   movel     alpha         txt06            06
     C                   movel     alpha         txt07            07
     C                   movel     alpha         txt08            08
     C                   movel     alpha         txt09            09
     C                   clear                   alpha
     C                   clear                   format
     C*
     C     ##3000        ENDSR
     C*
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
     C****************             FAK3120  = fak5480
     C                             FAK3310  = fak5480
     C                   if        *in88 = '1'
     C                   setoff                                       80
     C                   exsr      sr1120II
     C                   endif
     C                   if        ##sflas1 < sflpg1  and *in88 = '0'
     C* N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             ##sflas1          5 0
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEA     ATR(33)       §§OP
     C                   clear                   s1ausgabe
     C                   exsr      sr9002
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   MOVEA     ATR(07)       §§OP
     C                   endif
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
     C                   if        *in88 = '1'
     C                   seton                                        80
     C                   exsr      sr1120II
     C                   endif
     C                   if        ##sflas1 < sflpg1  and *in88 = '0'
     C* N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             ##sflas1          5 0
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEA     ATR(33)       §§OP
     C                   clear                   s1ausgabe
     C                   seton                                        80
     C                   exsr      sr9002
     C                   setoff                                       80
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   MOVEA     ATR(07)       §§OP
     C                   endif
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
     C* N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             ##sflas1          5 0
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEA     ATR(33)       §§OP
     C                   clear                   s1ausgabe
     C                   seton                                        80
     C                   exsr      sr9002e
     C                   setoff                                       80
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   MOVEA     ATR(07)       §§OP
     C*
     C     ##5802e       ENDSR
     C*
     C**************************************************************************
     C* weiltere Teillieferung
     C*-------------------------------------------------------------------------
     C*
     C     SR9100        BEGSR
     C*
     C                   add       1             ##sflas1
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
     C*
     C                   if        ##sflas1 < sflpg1
     C* N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             ##sflas1          5 0
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEA     ATR(33)       §§OP
     C                   clear                   s1ausgabe
     C                   exsr      sr9001
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   MOVEA     ATR(07)       §§OP
     C                   setoff                                       55
     C                   setoff                                       88
     C                   exsr      sr5801
     C                   exsr      sr5802
     C* n55 = ERROR
     C  n55              exsr      sr5802e
     C                   setoff                                       55
     C                   endif
     C*
     C                   endif
     c                   enddo
     C                   endif
     C*
     C     ##9100        ENDSR
     C*
     C**************************************************************************
     C* Leersatz
     C*-------------------------------------------------------------------------
     C*
     C     SR_leer       BEGSR
     C*
     C                   add       1             ##sflas1
     C*
     C                   if        sflrn1   <>   0
     C                   if        ##sflas1 < sflpg1
     C* N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             ##sflas1          5 0
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   clear                   S1OP
     C                   MOVEL     KEYDAT        KEYFMT
     C                   MOVEA     ATR(33)       §§OP
     C                   clear                   s1ausgabe
     C                   MOVEL     KEYDAT        KEYHID
     C                   Z-ADD     F1RRN         S1F1RR
     C                   MOVEA     FUNKT         *IN(81)
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
     C                   MOVEA     ATR(07)       §§OP
     C                   endif
     C                   endif
     C*
     C     ##_leer       ENDSR
     C*
     C**************************************************************************
     C* lesen aus sbgart07    check auf artikel
     C*-------------------------------------------------------------------------
     C*
     C     sr_art        BEGSR
     C*
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
     C                             ' article is not anymore valid replaced by:'
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
     C     *DTAARA       DEFINE                  tastatur        480
     C*    aktuelle Firma einlesen
     C     *lock         IN        tastatur
     C                   CALL      '#MODATR'                            97
     C                   PARM                    ATR
      * IF16                   1     30    INZ(' F16=.............  ')
      * IF13                  31     60    INZ(' F13=............   ')
     C*                                         12345678901234567890
     C                   clear                   md#2
     C                   movel     atr(04)       if13
     C                   move      atr(27)       if13
     C                   movea     if13          md#2(241)
     C
     C                   movel     atr(04)       if16
     C                   move      atr(27)       if16
     C                   movea     if16          md#2(301)
     C
     C                   movea(p)  md#2          tastatur
     C                   out       tastatur
     C* NACHRICHTEN-SFL INITIALISIEREN
     C                   MOVEL     '*'           §§§PGQ
     C                   EXSR      CLRMSG
     C*
     C* default werte
     C                   exsr      sr2700
     C                   MOVEL     §§§PGM        MSGPGM
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
     C                   WRITE     §DDS1§D0
     C                   OUT       LDA
     C                   MOVE      '1'           *INLR
     C*                  close     §000log1
     C     *lock         IN        tastatur
     C                   clear                   tastatur
     C                   out       tastatur
     C*                  close     §000phy1
     C* close
     C                   CALL      '#SUCHEN'                            97
     C                   PARM                    p1              256
     C                   PARM                    p2              256
     C                   PARM                    RTNCOD            1
     C                   PARM      '1'           op                1
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C/COPY ##PSSR                                         Errorroutine
     C/COPY ##MESSAGES                                     Nachrichten
     C/COPY ##MODATR                                       variabl.Attr.
     C/COPY ##TASTATUR                                     TastatDef.
