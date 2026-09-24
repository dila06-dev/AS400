     C**************************************************************************
     C* PROGRAMMNAME.:##OPCODE                                                
     C* FUNKTION.....:GÜLTIGE OPERATIONSCODE
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* SR1500: PRÜFUNGEN FÜR EINGABE OP-CODE
     C*-------------------------------------------------------------------------
     C*
     C     SR1500        BEGSR
     C*
     C     CTLVLD        IFNE      'F'
     C                   CALL      'OPCODE'                             98
     C                   PARM                    D3OP
     C                   PARM                    §§§CFK
     C                   PARM                    FUNKT
     C                   PARM                    MODUS
     C                   PARM      ' '           RTNCOD            1
     C                   PARM                    CTLVLD            1
     C                   PARM                    §§§PGM
     C                   ENDIF
     C*
     C     ##1500        ENDSR
     C*
