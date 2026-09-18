             PGM        PARM(&MODUS)

             DCL        VAR(&MODUS) TYPE(*CHAR) LEN(1)

             IF         COND(&MODUS *NE 'S') THEN(CHGVAR VAR(&MODUS) +
                          VALUE('B'))

             IF         COND(&MODUS *EQ 'S') THEN(GOTO CMDLBL(STARTEN))

             HLDJOBSCDE JOB(*ALL) ENTRYNBR(*ALL)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDPGM)

 STARTEN:    RLSJOBSCDE JOB(*ALL) ENTRYNBR(*ALL)
             MONMSG     MSGID(CPF0000)

 ENDPGM:     ENDPGM
