             PGM
             CPYF       FROMFILE(TIM/GRADEBAL) +
                          TOFILE(UEBERNAHME/GRADEHIS) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             STRQMQRY   QMQRY(UEBERNAHME/GRADEHISQ)
             MONMSG     MSGID(CPF0000)
             ENDPGM
