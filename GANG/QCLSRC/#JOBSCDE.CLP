             PGM

/*   -DER JOB IST RESTARTFÄHIG                                               */

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&LAGERBEWC) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&COUNT) VALUE(0)
 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

             IF         COND(&QTIME *GT '173000') THEN(GOTO +
                          CMDLBL(ENDPGM))
                RTVDTAARA  DTAARA(DATENKW/LAGERBEWC) RTNVAR(&LAGERBEWC)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                    GOTO       CMDLBL(ENDPGM)
             ENDDO

             IF         COND(&LAGERBEWC *EQ '0') THEN(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

             CHGVAR     VAR(&COUNT) VALUE(&COUNT +1)
             IF         COND(&COUNT *EQ 1 ) THEN(DO)
                ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(BAR_KALK/KALK) PARM('$$EL_PS_DB')
                MONMSG     MSGID(CPF0000) EXEC(DO)
                    GOTO       CMDLBL(ENDPGM)
                ENDDO
                CALL PGM(ARTIKELC) PARM('$$EL_PS_DB')
                MONMSG     MSGID(CPF0000) EXEC(DO)
                    GOTO       CMDLBL(ENDPGM)
                ENDDO
             ENDDO
             IF         COND(&COUNT *GT 100) THEN(DO)
                CHGVAR     VAR(&COUNT) VALUE(0)
             ENDDO

             CALL PGM(LAGERBEWC) PARM('$$EL_PS_DB')
             MONMSG     MSGID(CPF0000)

             IF         COND(&CODE *EQ '0') THEN(DO)
                DLYJOB     DLY(300)
                GOTO       CMDLBL(LOOP)
             ENDDO

             GOTO       CMDLBL(ENDPGM)

 ENDPGM:     ENDPGM
