/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&K &#)

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$GANG)     TYPE(*CHAR) LEN(32)
             DCLF       FILE(GANG/PREISC)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
                CLRPFM     FILE(GANG/HELP__01B)
                MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '239999') THEN(GOTO +
                          CMDLBL(ENDPGM))

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&FIRMA = '1' *AND &AKTIV = 'A') THEN(DO)

                CLRPFM     FILE(GANG/HELP__01)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/HELP__02)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/RABATT)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(PREISR) PARM('00000' &#)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(PREISR) PARM(&KUNDE &KENNUNG)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(PREISR) PARM('99999' &#)
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(GANG/HELP__01) +
                             TOFILE(GANG/HELP__01B) MBROPT(*ADD)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(GANG/HELP__02) +
                             TOFILE(GANG/HELP__01B) MBROPT(*ADD)
                MONMSG     MSGID(CPF0000)
             ENDDO
             GOTO LOOP

 ENDPGM:

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
