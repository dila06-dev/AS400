     C* PROGRAMMNAME.:##MODATR                                                
     C* FUNKTION.....:AUFRUF ATTRIBUTE-FELDGRUPPE
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* SRATTR: ZUORDNUNGEN
     C**************************************************************************
     C*
     C     SRATTR        BEGSR
     C*
     C                   MOVEA     ATR(33)       ATTS
     C                   MOVEA     ATR(33)       ATTK
     C                   MOVEA     ATR(33)       ATTO
     C                   MOVEA     ATR(40)       §§KW
     C*
     C   82              MOVEA     ATR(7)        ATTS
     C   83              MOVEA     ATR(7)        ATTS
     C   81              MOVEA     ATR(7)        ATTK
     C   82              MOVEA     ATR(7)        ATTK
     C   83              MOVEA     ATR(7)        ATTK
     C   82              MOVEA     ATR(7)        ATTO
     C   83              MOVEA     ATR(7)        ATTO
     C   84              MOVEA     ATR(7)        ATTO
     C   82              MOVEA     ATR(24)       §§KW
     C   83              MOVEA     ATR(24)       §§KW
     C   84              MOVEA     ATR(24)       §§KW
     C*
     C   86              MOVEA     ATR(41)       ATTS
     C   86              MOVEA     ATR(41)       ATTK
     C   86              MOVEA     ATR(41)       ATTO
     C*
     C     ##ATTR        ENDSR
     C*
     C**************************************************************************
     C* MODATR: VARIABLE STEUERUNG DER FELDATTRIBUTE/FELDGRUPPE FÜLLEN
     C**************************************************************************
     C*
     C     MODATR        BEGSR
     C                   CLEAR                   ATR
     C                   CALL      '#MODATR'                            97
     C                   PARM                    ATR
     C                   ENDSR
     C*
