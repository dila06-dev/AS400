     C**************************************************************************
     C* PROGRAMMNAME.:##DATUM                                                 
     C* FUNKTION.....:DATUMSCHECK
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* SR1510: PRÜFUNG DATUM
     C*-------------------------------------------------------------------------
     C*
     C     SR1510        BEGSR
     C*
     C                   CALL      '#DATFRMR'                           98
     C                   PARM                    DATVON           10
     C                   PARM                    RTNMOD            5
     C                   PARM                    RTNDAT           10
     C                   PARM      '0'           RTNCOD            1
     C                   PARM      '*EUR'        DATMOD            5
     C     RTNCOD        IFNE      '0'
     C                   MOVEA     DATVON        MD
     C                   MOVEL     'AL00016'     MSG
     C                   EXSR      SNDMSG
     C                   MOVE      'F'           CTLVLD
     C                   MOVE      ' '           CTLMOD
     C                   ENDIF
     C*
     C     ##1510        ENDSR
     C*
