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
