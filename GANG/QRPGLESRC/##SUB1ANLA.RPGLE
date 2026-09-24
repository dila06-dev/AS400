     C**************************************************************************
     C* PROGRAMMNAME.:##SUB1ANLA                                              
     C* FUNKTION.....:SUBFILESTEUERUNGSROUTINEN CLEAR/READ 1.SUBFILE
     C* Oktober 2009   GANG, MANFRED
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C* SR1131: SÄTZE IN SUBFILE #1 FÜLLEN ZWECKS ANLAGE
     C*-------------------------------------------------------------------------
     C*
     C     SR1131        BEGSR
     C*
     C     CTLVLD        IFEQ      'N'
     C     SFLRN1        DOUEQ     SFLPG1
     C*
     C                   CLEAR                   §DDS1§S1
     C                   ADD       1             SFLAS1
     C                   ADD       1             SFLRN1
     C                   MOVEA     FUNKT         *IN(81)
     C*
     C   06              MOVEL     'N'           S1OP
     C   06              EXSR      SR1199
     C   25
     CANN06              EXSR      SR1198
     C*
     C                   WRITE     §DDS1§S1
     C                   Z-ADD     1             SFLDR1
     C*
     C                   ENDDO
     C*
     C   25              MOVEL     'AL00004'     MSG
     C   25              MOVEA     I§§§01        MD
     C   25              EXSR      SNDMSG
     C*
     C                   Z-ADD     *ZERO         §§CRLN
     C                   Z-ADD     *ZERO         §§CRCL
     C                   MOVE      '0'           CTLF07
     C   06              SETOFF                                       98
     C   25              SETON                                        98
     C                   ENDIF
     C*
     C     ##1131        ENDSR
     C*
