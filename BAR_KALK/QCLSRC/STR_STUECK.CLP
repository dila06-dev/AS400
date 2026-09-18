/*-------------------------------------------------*/
/* Stuecklisten aufbauen                           */
/*-------------------------------------------------*/
             PGM

             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DLTF       FILE(BAR_KALK/#PR0011L1)
             MONMSG     MSGID(CPF0000)
/*           MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(PART2))  */
/* Stuecklistendateien arbeitsanteilige Kosten */
/*          AUSGABE arbeitsanteilige Kosten                                  */
             CALL       PGM(DUMMY512) PARM(&MD '#PR0011' ' ' ' ' +
                          '#PR0011' 'BAR_KALK' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          Index #pr0011l1 in bar_kalk erstellen                            */
             CALL       PGM(DUMMY512) PARM(&MD '#PR0012' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

part2:
/* Stuecklistendateien leeren */
             CLRPFM     FILE(BAR_KALK/SLAZS)

/* Stuecklisten aufbauen */
             CALL       PGM(BAR_KALK/EXSLAZGES)
             CALL       PGM(BAR_KALK/EXSLAZS_RE)

             ENDPGM
