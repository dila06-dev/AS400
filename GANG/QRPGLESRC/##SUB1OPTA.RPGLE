     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1OPTA                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN OPTIONEN 1.SUBFILE
     C*               BEI ALPHAKEY
     C* Oktober 2009   GANG, MANFRED
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
