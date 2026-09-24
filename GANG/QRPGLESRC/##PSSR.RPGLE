     C**************************************************************************
     C* PROGRAMMNAME.:##PSSR                                                  
     C* FUNKTION.....:FEHLERROUTINE
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* FEHLER-ROUTINE
     C*-------------------------------------------------------------------------
     C     *PSSR         BEGSR
     C                   CALL      'DWEPSSRR'                           98
     C                   PARM                    DUMP              1
     C                   PARM                    DSPGM
     C                   PARM                    MSGF
     C     DUMP          IFNE      'N'
     C                   DUMP
     C                   END
     C                   MOVE      '1'           *INLR
     C                   ENDSR     '*CANCL'
