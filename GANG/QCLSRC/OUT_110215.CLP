/*    * PROGRAMMNAME.:ACHTUNG MIT LÖSCHUNG DER LIB'S                         */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * ...                                                                  */
/*    * ...                                                                  */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&$LAGERBEWC) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCLF       FILE(GANG/OUT_110215)


 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))

/*          ROUTINE                                                          */
             IF         COND(&AI = 'J' *OR &AI = 'J') THEN(DO)
                DLTF       FILE(SAVEFILE/&LIB)
                MONMSG     MSGID(CPF0000)
                CRTSAVF    FILE(SAVEFILE/&LIB) TEXT('Sicherung')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&FILE) VALUE('#' *TCAT &LIB)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(SAVEFILE/&FILE)
                MONMSG     MSGID(CPF0000)

                SAVLIB     LIB(&LIB) DEV(*SAVF) SAVF(SAVEFILE/&LIB) +
                          SAVACT(*SYNCLIB) SAVACTWAIT(120) +
                          ACCPTH(*YES) OUTPUT(*OUTFILE) +
                          OUTFILE(SAVEFILE/&FILE) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000)

          /*    DLTLIB     LIB(&LIB)        */
          /*    MONMSG     MSGID(CPF0000)   */

             ENDDO
             GOTO LOOP

 ENDPGM:

             ENDPGM
