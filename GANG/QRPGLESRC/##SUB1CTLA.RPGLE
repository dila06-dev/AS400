     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1CTLA                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN CLEAR/READ 1.SUBFILE
     C* Oktober 2009   GANG, MANFRED
     C*                clear auf Format nur wenn *IN27 = '0'
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C* SR1101: SUBFILE #1 LADEN/AUFRUF WEITERE STEUERUNG
     C*-------------------------------------------------------------------------
     C*
     C     SR1101        BEGSR
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
     C                   EXSR      SR1111
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
     C                   READP     §000LOG1                               95
     C                   SETON                                        95
     C                   LEAVE
     C                   ENDIF
     C     KEYDAT        IFGT      KEYV
     C                   MOVE      '0'           CTLPRF            1
     C                   EXSR      SR1120
     C     CTLPRF        IFEQ      '0'
     C***                CLEAR                   §DDS1§S1            alt
     C  N27              CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             SFLRN1
     C                   ADD       1             DISREC
     C                   EXSR      SR1121
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C                   WRITE     §DDS1§S1
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
