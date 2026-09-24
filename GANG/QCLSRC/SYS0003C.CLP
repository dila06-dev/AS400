/*    * PROGRAMMNAME.:SYS0003C                                               */
/*    * FUNKTION.....:CALL COMMANDS                                          */
/*    * OKTOBER 2009                                                          */
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
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
/*----------------------------------------------------------------------------*/
             IF         COND(&PGMART = 'D') THEN(DO)
                RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&PGMSAVE)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGM)
             ENDDO
             RTVJOBA    CURLIB(&CURLIB)
             ADDLIBLE   LIB(&LIB)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('1'))
             CALL QMNHCMD PARM(&PGM)
             MONMSG     MSGID(CPF0000)
             CHGCURLIB  &CURLIB
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR = '0') THEN(DO)
                RMVLIBLE   LIB(&LIB)
             ENDDO
ENDE:
             IF         COND(&PGMART = 'D') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGMSAVE)
             ENDDO
             ENDPGM
