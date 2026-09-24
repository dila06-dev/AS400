     C* PROGRAMMNAME.:##MESSAGES                                              
     C* FUNKTION.....:HANDLING MESSAGES
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* FUNKTION.....:MASSAGES SENDEN
     C**************************************************************************
     C     SNDMSG        BEGSR
     C     MSGF          IFEQ      *BLANK
     C                   MOVEL     'DOMWECOSQL'  MSGF
     C                   END
     C                   CALL      '#SNDMSG'                            97
     C                   PARM                    MSG               7
     C                   PARM                    MSGF             10
     C                   PARM                    MD
     C                   CLEAR                   MD
     C                   ENDSR
     C**************************************************************************
     C* FUNKTION.....:MASSAGES SENDEN UND EMPFANGEN FIRST LEVEL
     C**************************************************************************
     C     SNDRCV        BEGSR
     C     MSGF          IFEQ      *BLANK
     C                   MOVEL     'DOMWECOSQL'  MSGF
     C                   END
     C                   CALL      '#SNDRCV'                            97
     C                   PARM                    MSG               7
     C                   PARM                    MSGF             10
     C                   PARM                    MD
     C                   ENDSR
     C**************************************************************************
     C* FUNKTION.....:MASSAGES SENDEN AN EIN BESTIMMTES PROGRAMM
     C**************************************************************************
     C     SNDMSP        BEGSR
     C     MSGF          IFEQ      *BLANK
     C                   MOVEL     'DOMWECOSQL'  MSGF
     C                   END
     C                   CALL      '#SNDMSGP'                           97
     C                   PARM                    MSG               7
     C                   PARM                    MSGF             10
     C                   PARM                    MD
     C                   PARM                    MSGPGM           10
     C                   CLEAR                   MD
     C                   ENDSR
     C**************************************************************************
     C* FUNKTION.....:NACHRICHTENWARTESCHLANGE LEEREN
     C**************************************************************************
     C     CLRMSG        BEGSR
     C                   CALL      '#CLRMSG'                            97
     C                   ENDSR
     C**************************************************************************
     C* FUNKTION.....:STANDARDMELDUNG BEI DATEIMODIFIZIERUNG
     C**************************************************************************
     C     MSG001        BEGSR
     C                   MOVEL     'STD0000'     MSG
     C                   MOVEL     S1KY01        IMSG02
     C                   MOVEA     CTLMSG        MD
     C                   EXSR      SNDMSG
     C     ##0001        ENDSR
