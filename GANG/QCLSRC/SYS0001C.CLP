/*    * PROGRAMMNAME.:SYS0001C                                               */
/*    * FUNKTION.....:CALL PROGRAMME                                         */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PGM &LIB &PGMART)

/*----------------------------------------------------------------------------*/

/* &PGM      PROGRAMM                                          */
             DCL        VAR(&PGM)    TYPE(*CHAR) LEN(10)
/* &LIB      BIBLIOTHEK                                        */
             DCL        VAR(&LIB)    TYPE(*CHAR) LEN(10)
/* &PGMART   PROGRAMMART                                       */
             DCL        VAR(&PGMART) TYPE(*CHAR) LEN(1)

             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PGMSAVE) TYPE(*CHAR) LEN(10)
/*----------------------------------------------------------------------------*/
             IF         COND(&PGMART = 'D') THEN(DO)
                RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&PGMSAVE)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGM)
             ENDDO
             ADDLIBLE   LIB(&LIB)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('1'))
             CALL       PGM(&LIB/&PGM)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR = '0') THEN(DO)
                RMVLIBLE   LIB(&LIB)
             ENDDO
ENDE:
             IF         COND(&PGMART = 'D') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGMSAVE)
             ENDDO
             ENDPGM
